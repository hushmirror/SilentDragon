// Copyright 2019-2021 The Hush developers
// Released under the GPLv3
#ifndef PEERSTABLEMODEL_H
#define PEERSTABLEMODEL_H

#include "precompiled.h"

struct PeerItem;

class PeersTableModel: public QAbstractTableModel
{
public:
    PeersTableModel(QObject* parent);    
    ~PeersTableModel();

    QString  getPeerId(int row) const;
    QString  getAddress(int row) const;
    QString  getType(int row) const;
    qint64   getConntime(int row) const;
    QString  getASN(int row) const;
    QString  getSubver(int row) const;
    QString  getTLSCipher(int row) const;
    bool     getTLSVerified(int row) const;
    QString  getPingtime(int row) const;
    unsigned int     getBanscore(int row) const;
    unsigned int     getProtocolVersion(int row) const;

    bool     exportToCsv(QString fileName) const;

    int      rowCount(const QModelIndex &parent) const;
    int      columnCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;

    void addData    (const QList<PeerItem>& data);

private:
    void updateAllData();
    QList<PeerItem>*  peers      = nullptr;
    QList<PeerItem>* modeldata   = nullptr;

    QList<QString>           headers;
};


#endif // PEERSTABLEMODEL_H
