// Copyright 2019-2021 The Hush developers
// Released under the GPLv3
#include "txtablemodel.h"
#include "settings.h"
#include "rpc.h"

PeersTableModel::PeersTableModel(QObject *parent)
     : QAbstractTableModel(parent) {
    headers << QObject::tr("PeerID") << QObject::tr("Address") << QObject::tr("ASN") << QObject::tr("TLS Cipher") << QObject::tr("TLS Verfied") << QObject::tr("Version") << QObject::tr("Protocol Version") << QObject::tr("Ping Time") << QObject::tr("Banscore") << QObject::tr("Bytes received") << QObject::tr("Bytes sent");
}

PeersTableModel::~PeersTableModel() {
    delete modeldata;
}

void PeersTableModel::addData(const QList<PeerItem>& data) {
    peers = new QList<PeerItem>();
    std::copy(data.begin(), data.end(), std::back_inserter(*peers));

    updateAllData();
}

void PeersTableModel::updateAllData() {    
    auto newmodeldata = new QList<PeerItem>();

    // Copy peer data so GUI can use it
    if (peers  != nullptr) std::copy( peers->begin(),  peers->end(), std::back_inserter(*newmodeldata));

    // Sort by connection time
    std::sort(newmodeldata->begin(), newmodeldata->end(), [=] (auto a, auto b) {
        return a.conntime > b.conntime; // reverse sort
    });

    // And then swap out the modeldata with the new one.
    delete modeldata;
    modeldata = newmodeldata;

    // do magic
    dataChanged(index(0, 0), index(modeldata->size()-1, columnCount(index(0,0))-1));
    layoutChanged();
}

int PeersTableModel::rowCount(const QModelIndex&) const
{
   if (modeldata == nullptr) return 0;
   return modeldata->size();
}

int PeersTableModel::columnCount(const QModelIndex&) const
{
   return headers.size();
}


 QVariant PeersTableModel::data(const QModelIndex &index, int role) const
 {
     // Align column 4 (amount) right
    //if (role == Qt::TextAlignmentRole && index.column() == 3) return QVariant(Qt::AlignRight | Qt::AlignVCenter);
    
    if (role == Qt::ForegroundRole) {
        // peers with banscore >=50 will likely be banned soon, color them red
        if (modeldata->at(index.row()).banscore >= 50) {
            QBrush b;
            b.setColor(Qt::red);
            return b;
        }

        // Else, just return the default brush
        QBrush b;
        b.setColor(Qt::black);
        return b;        
    }

    auto dat = modeldata->at(index.row());
    if (role == Qt::DisplayRole) {
        switch (index.column()) {
        case  0: return dat.peerid;
        case  1: return dat.address;
        case  2: return "AS" + QString::number(dat.asn);
        case  3: return dat.tls_cipher;
        case  4: return dat.tls_verified;
        case  5: return dat.subver;
        case  6: return dat.protocolversion;
        case  7: return dat.pingtime;
        case  8: return dat.banscore;
        case  9: return dat.bytes_received;
        case 10: return dat.bytes_sent;
        }
    } 

    if (role == Qt::ToolTipRole) {
        switch (index.column()) {
        case  0: return "Unique Peer ID";
        case  1: return "Network Address";
        case  2: return "Autonomous System Number";
        case  3: return "TLS Ciphersuite";
        case  4: return "TLS Certificate verified";
        case  5: return "Full Node Version";
        case  6: return "P2P Protocol Version";
        case  7: return "Ping Time (seconds)";
        case  8: return "Banscore";
        case  9: return "Bytes received";
        case 10: return "Bytes sent";
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


QVariant PeersTableModel::headerData(int section, Qt::Orientation orientation, int role) const
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

QString PeersTableModel::getPeerId(int row) const {
    return QString::number(modeldata->at(row).peerid);
}

QString PeersTableModel::getAddress(int row) const {
    return modeldata->at(row).address.trimmed();
}

QString PeersTableModel::getTLSCipher(int row) const {
    return modeldata->at(row).tls_cipher;
}

qint64 PeersTableModel::getASN(int row) const {
    return modeldata->at(row).asn;
}

qint64 PeersTableModel::getConntime(int row) const {
    return modeldata->at(row).conntime;
}

QString PeersTableModel::getType(int row) const {
    return modeldata->at(row).type;
}

QString PeersTableModel::getPingtime(int row) const {
    return Settings::getDecimalString(modeldata->at(row).pingtime);
}
