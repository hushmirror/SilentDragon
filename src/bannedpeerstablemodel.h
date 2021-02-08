// Copyright 2019-2021 The Hush developers
// Released under the GPLv3
#ifndef BANNEDPEERSTABLEMODEL_H
#define BANNEDPEERSTABLEMODEL_H

#include "precompiled.h"

struct BannedPeerItem;

class BannedPeersTableModel: public QAbstractTableModel
{
public:
    BannedPeersTableModel(QObject* parent);    
    ~BannedPeersTableModel();

    QString  getSubnet(int row) const;
    QString  getAddress(int row) const;
    qint64   getBannedUntil(int row) const;

    int      rowCount(const QModelIndex &parent) const;
    int      columnCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;

    void addData    (const QList<BannedPeerItem>& data);

private:
    void updateAllData();
    QList<BannedPeerItem>* bannedPeers = nullptr;
    QList<BannedPeerItem>* modeldata   = nullptr;

    QList<QString>           headers;
};


#endif // BANNEDPEERSTABLEMODEL_H
