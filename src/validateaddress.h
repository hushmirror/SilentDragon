// Copyright 2019-2021 The Hush developers
// Released under the GPLv3
#ifndef VALIDATEADDRESS_H
#define VALIDATEADDRESS_H

#include "precompiled.h"

class ValidateAddressesModel : public QAbstractTableModel {

public:
    ValidateAddressesModel(QTableView* parent, QList<QPair<QString, QString>> props);
    ~ValidateAddressesModel() = default;

    int      rowCount(const QModelIndex &parent) const;
    int      columnCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;

private:
    QList<QPair<QString, QString>> props;
    QStringList headers;    
};


#endif // VALIDATEADDRESS_H
