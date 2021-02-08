// Copyright 2019-2021 The Hush developers
// Released under the GPLv3
#include "settings.h"
#include "rpc.h"

BannedPeersTableModel::BannedPeersTableModel(QObject *parent)
     : QAbstractTableModel(parent) {
    headers << QObject::tr("Address") << QObject::tr("Subnet") << QObject::tr("Banned Until");
}

BannedPeersTableModel::~BannedPeersTableModel() {
    delete modeldata;
}

void BannedPeersTableModel::addData(const QList<BannedPeerItem>& data) {
    bannedPeers = new QList<BannedPeerItem>();
    std::copy(data.begin(), data.end(), std::back_inserter(*bannedPeers));

    updateAllData();
}

void BannedPeersTableModel::updateAllData() {    
    auto newmodeldata = new QList<BannedPeerItem>();

    // Copy peer data so GUI can use it
    if (bannedPeers  != nullptr) std::copy( bannedPeers->begin(),  bannedPeers->end(), std::back_inserter(*newmodeldata));

    // Sort by banned_until
    std::sort(newmodeldata->begin(), newmodeldata->end(), [=] (auto a, auto b) {
        return a.banned_until > b.banned_until; // reverse sort
    });

    // And then swap out the modeldata with the new one.
    delete modeldata;
    modeldata = newmodeldata;

    // do magic
    dataChanged(index(0, 0), index(modeldata->size()-1, columnCount(index(0,0))-1));
    layoutChanged();
}

int BannedPeersTableModel::rowCount(const QModelIndex&) const
{
   if (modeldata == nullptr) return 0;
   return modeldata->size();
}

int BannedPeersTableModel::columnCount(const QModelIndex&) const
{
   return headers.size();
}


 QVariant BannedPeersTableModel::data(const QModelIndex &index, int role) const
 {
    auto dat = modeldata->at(index.row());
    if (role == Qt::DisplayRole) {
        switch (index.column()) {
        case  0: return dat.address;
        case  1: return dat.subnet;
        case  2: return QDateTime::fromSecsSinceEpoch(dat.banned_until).toLocalTime().toString();
        }
    } 

    // we show mask because it's possible to ban ranges of addresses
    if (role == Qt::ToolTipRole) {
        switch (index.column()) {
        case  0: return "Network Address";
        case  1: return "Subnet Mask";
        case  2: return "Banned Until " + QDateTime::fromSecsSinceEpoch(dat.banned_until).toUTC().toString();
        }    
    }

    //TODO: show different icons for IP vs Tor vs other kinds of connections
   /*
    if (role == Qt::DecorationRole && index.column() == 0) {
        if (!dat.memo.isEmpty()) {
            // If the memo is a Payment URI, then show a payment request icon
            if (dat.memo.startsWith("hush:")) {
                QIcon icon(":/icons/res/paymentreq.gif");
                return QVariant(icon.pixmap(16, 16));
            } else {
                // Return the info pixmap to indicate memo
                QIcon icon = QApplication::style()->standardIcon(QStyle::SP_MessageBoxInformation);            
                return QVariant(icon.pixmap(16, 16));
                }
        } else {
            // Empty pixmap to make it align
            QPixmap p(16, 16);
            p.fill(Qt::white);
            return QVariant(p);
        }
    }
    */

    return QVariant();
 }


QVariant BannedPeersTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    //if (role == Qt::TextAlignmentRole && section == 3) return QVariant(Qt::AlignRight | Qt::AlignVCenter);
    if (role == Qt::TextAlignmentRole) return QVariant(Qt::AlignCenter | Qt::AlignVCenter);

    if (role == Qt::FontRole) {
        QFont f;
        f.setBold(true);
        return f;
    }

    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return headers.at(section);
    }

    return QVariant();
}

QString BannedPeersTableModel::getAddress(int row) const {
    return modeldata->at(row).address.trimmed();
}

QString BannedPeersTableModel::getSubnet(int row) const {
    return modeldata->at(row).subnet;
}

qint64 BannedPeersTableModel::getBannedUntil(int row) const {
    return modeldata->at(row).banned_until;
}
