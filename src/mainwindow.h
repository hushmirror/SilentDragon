// Copyright 2019-2021 The Hush developers
// Released under the GPLv3
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "precompiled.h"
#include "logger.h"
#include <memory>

// Forward declare to break circular dependency.
class RPC;
class Settings;
class WSServer;
class WormholeClient;

// Struct used to hold destination info when sending a Tx. 
struct ToFields {
    QString addr;
    double  amount;
    QString txtMemo;
    QString encodedMemo;
};

// Struct used to represent a Transaction. 
struct Tx {
    QString         fromAddr;
    QList<ToFields> toAddrs;
    double          fee;
};

namespace Ui {
    class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    void updateLabelsAutoComplete();
    RPC* getRPC() { return rpc; }

    QCompleter*         getLabelCompleter() { return labelCompleter; }
    QRegExpValidator*   getAmountValidator() { return amtValidator; }

    QString doSendTxValidations(Tx tx);
    void setDefaultPayFrom();

    void replaceWormholeClient(WormholeClient* newClient);
    bool isWebsocketListening();
    void createWebsocket(QString wormholecode);
    void stopWebsocket();

    void balancesReady();
    void payHushURI(QString uri = "", QString myAddr = "");

    void validateAddress();

    void updateLabels();
    void updateTAddrCombo(bool checked);
    void updateFromCombo();

    Ui::MainWindow*     ui;

    QLabel*             statusLabel;
    QLabel*             statusIcon;
    QLabel*             loadingLabel;

    Logger*      logger;

    void doClose();
protected:
    // this event is called, when a new translator is loaded or the system language is changed
    void changeEvent(QEvent* event);

    //void slotLanguageChanged(QAction* action);
protected slots:
    // this slot is called by the language menu actions
    void slotLanguageChanged(QString lang);

private:    
    void closeEvent(QCloseEvent* event);

    // loads a language by the given language shortcode (e.g. de, en)
    void loadLanguage(QString& rLanguage);

    void setupSendTab();
    void setupPeersTab();
    void setupTransactionsTab();
    void setupReceiveTab();
    void setupBalancesTab();
    void setupHushTab();
    void setupChatTab();
    void setupMarketTab();

    void slot_change_theme(const QString& themeName);
    void slot_change_currency(const QString& currencyName);

    void setupTurnstileDialog();
    void setupSettingsModal();
    void setupStatusBar();

    void removeExtraAddresses();

    Tx   createTxFromSendPage();
    bool confirmTx(Tx tx);

    void cancelButton();
    void sendButton();
    void inputComboTextChanged(int index);
    void addAddressSection();
    void maxAmountChecked(int checked);

    void editSchedule();

    void addressChanged(int number, const QString& text);
    void amountChanged (int number, const QString& text);

    void addNewZaddr();
    std::function<void(bool)> addZAddrsToComboList(bool sapling);

    void memoButtonClicked(int number, bool includeReplyTo = false);
    void fileUploadButtonClicked(int number);
    void setMemoEnabled(int number, bool enabled);
    
    void donate();
    void website();
    void telegram();
    void reportbug();
    void addressBook();
    void postToZBoard();
    void importPrivKey();
    void exportAllKeys();
    void exportKeys(QString addr = "");
    void getViewKey(QString addr = "");
    void backupWalletDat();
    void exportTransactions();

    void doImport(QList<QString>* keys);

    void restoreSavedStates();
    bool eventFilter(QObject *object, QEvent *event);

    bool            uiPaymentsReady    = false;
    QString         pendingURIPayment;

    WSServer*       wsserver = nullptr;
    WormholeClient* wormhole = nullptr;

    RPC*                rpc             = nullptr;
    QCompleter*         labelCompleter  = nullptr;
    QRegExpValidator*   amtValidator    = nullptr;
    QRegExpValidator*   feesValidator   = nullptr;

    QMovie*      loadingMovie;
    // creates the language menu dynamically from the content of m_langPath
    void createLanguageMenu(void);

    QTranslator m_translator; // contains the translations for this application
    QTranslator m_translatorQt; // contains the translations for qt
    QString m_currLang; // contains the currently loaded language
    QString m_langPath; // Path of language files
};

#endif // MAINWINDOW_H
