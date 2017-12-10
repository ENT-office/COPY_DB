unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBDatabase, DB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  IBCustomDataSet, IBQuery, StdCtrls, IBTable, cxContainer, cxLabel,
  cxProgressBar, Menus, cxButtons, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxCheckBox;

type
  TForm1 = class(TForm)
    FDB_data_old: TIBDatabase;
    TB_data_old: TIBTransaction;
    q_data_Old: TIBQuery;
    FDB_photo_old: TIBDatabase;
    TB_photo_old: TIBTransaction;
    q_photo_Old: TIBQuery;
    FDB_data_NEW: TIBDatabase;
    TB_data_NEW: TIBTransaction;
    q_data_NEW: TIBQuery;
    FDB_photo_NEW: TIBDatabase;
    TB_photo_NEW: TIBTransaction;
    IBTblImage: TIBTable;
    q_photo_NEW: TIBQuery;
    ps: TcxProgressBar;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxLabel2: TcxLabel;
    dbPath_old: TcxButtonEdit;
    cxLabel3: TcxLabel;
    dbPath_NEW: TcxButtonEdit;
    OpenDialog1: TOpenDialog;
    cbFoto: TcxCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure dbPath_oldPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure dbPath_NEWPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses IniFiles,jpeg,ExtCtrls;
{$R *.dfm}

function FloadImageFIREBIRDServer(dr, fl: string; Q:TIBQuery): boolean;
var
  buf : tstream;
  jpgImg: TJPEGImage;
  i : TImage;
  r: boolean;
begin
  try
    try
      r := False;
        i := TImage.Create(nil);
        buf := tmemorystream.Create ;
        jpgImg := TJPEGImage.Create;
        (Q.FieldByName('PHOTO') as TBlobField).SaveTostream(buf);
        buf.Position := 0;

           jpgImg.LoadFromStream(buf);
           i.Picture.Bitmap.Assign(jpgImg);
           i.Picture.SaveToFile(dr + fl);
    except
      r := True;
    end;

  finally
    i.Free;
    result := r;
  end;
end;

function BMPtoJPG(
      var BMPpic, JPGpic: string):boolean;
      var Bitmap: TBitmap;
      JpegImg: TJpegImage;
begin
  Result:=False;
  Bitmap := TBitmap.Create;
  try
   Bitmap.LoadFromFile(BMPpic) ;
   JpegImg := TJpegImage.Create;
   try
    JpegImg.Assign(Bitmap) ;
    JpegImg.SaveToFile(JPGpic) ;
    Result:=True;
   finally
    JpegImg.Free
   end;
  finally
   Bitmap.Free
  end;
end;

function isNUll(v1,v2:string):string;
begin
  if v1 <> '' then result := v1 else result := v2;
end;

function fQueryFieldVal(q:TIBQuery;sql,fieldName:string):string;
var r:string;
begin
  q.Close;
  q.SQL.Clear;
  q.SQL.Add(sql);
  q.Open;

    if q.RecordCount > 0 then
      r := q.FieldByName(fieldName).AsString;
    result := r;
end;


procedure pQueryExecSQL(q:TIBQuery;sql:string);
begin
  q.Close;
  q.SQL.Clear;
  q.SQL.Add(sql);
  q.ExecSQL;
end;

procedure pQueryOpen(q:TIBQuery; sql:string);
begin
q.Close;
q.SQL.Clear;
q.SQL.Add(sql);
q.Open;

  q.Last;
  q.First;
end;

procedure pDBdisconnect(dbC: TIBDatabase; t:TIBTransaction);
begin
if t.InTransaction then t.Rollback;
dbC.Connected := False;
end;

function FDBConnect(dbC: TIBDatabase;t:TIBTransaction; Ctype,UName,Psswrd,DBName: string):boolean;
var err: boolean;
begin
try

    err := False;

    pDBdisconnect(dbC,t);
      dbC.LoginPrompt := False;
      dbC.Params.Values['lc_ctype'] := Ctype;
      dbC.Params.Values['user_name'] := UName;
      dbC.Params.Values['password'] := Psswrd;
      dbC.DatabaseName := DBName;
      dbC.Connected := True;


finally
result := err;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var f : tinifile;
    dbPath_data_old,dbPath_photo_old,dbPath_data_NEW,dbPath_photo_NEW:string;
    i:integer;
begin
dbPath_old.Clear;
dbPath_NEW.Clear;
{
f := tinifile.Create(extractfiledir(application.ExeName) + '\settings.ini' );
  dbPath_data_old := 'localhost:C:\project\КОПИРОВАНИЕ БАЗЫ\DB\CBASE.FDB';
  dbPath_photo_old := 'localhost:C:\project\КОПИРОВАНИЕ БАЗЫ\DB\GBASE.FDB';
  dbPath_data_NEW := 'localhost:C:\Program Files (x86)\ENT\Server\DB\CBASE.FDB';
  dbPath_photo_NEW := 'localhost:C:\Program Files (x86)\ENT\Server\DB\GBASE.FDB';
  FDBConnect(FDB_data_old,TB_data_old,'WIN1251','SYSDBA','masterkey',dbPath_data_old);
  FDBConnect(FDB_photo_old,TB_photo_old,'WIN1251','SYSDBA','masterkey',dbPath_photo_old);
  FDBConnect(FDB_data_NEW,TB_data_NEW,'WIN1251','SYSDBA','masterkey',dbPath_data_NEW);
  FDBConnect(FDB_photo_NEW,TB_photo_NEW,'WIN1251','SYSDBA','masterkey',dbPath_photo_NEW);
f.free;


pQueryOpen(q_data_Old,'select * FROM FB_USR where id = 1492081601015');
showmessage(inttostr(q_data_Old.RecordCount));
pQueryOpen(q_photo_Old,'select * FROM UPH');
showmessage(inttostr(q_photo_Old.RecordCount));

pQueryOpen(q_data_NEW,'select * FROM FB_USR');
showmessage(inttostr(q_data_NEW.RecordCount));
pQueryOpen(q_photo_NEW,'select * FROM UPH');
showmessage(inttostr(q_photo_NEW.RecordCount));
}
end;

procedure TForm1.cxButton1Click(Sender: TObject);
var sql,ImJpg,ImBMP,DirImage:string;
    dbPath_data_old,dbPath_photo_old,dbPath_data_NEW,dbPath_photo_NEW:string;
begin



  if (dbPath_old.Text = '') or (dbPath_NEW.Text = '') then
  begin
    MessageDlg('Необходимо указать базы данных', mtError, [mbOk], 0);
    exit;
  end;

  dbPath_data_old := 'localhost:' + dbPath_old.Text;
  dbPath_photo_old := 'localhost:' + ExtractFilePath(dbPath_old.Text) + 'GBASE.FDB';
  dbPath_data_NEW := 'localhost:' + dbPath_NEW.Text;
  dbPath_photo_NEW := 'localhost:' +ExtractFilePath(dbPath_NEW.Text) + 'GBASE.FDB';


  if Application.MessageBox (pchar('База данных "' +dbPath_data_NEW +'" будет очищена, продолжить?'), 'Копирование базы данных', MB_YESNO) <> ID_YES
      then exit;

  FDBConnect(FDB_data_old,TB_data_old,'WIN1251','SYSDBA','masterkey',dbPath_data_old);
  FDBConnect(FDB_data_NEW,TB_data_NEW,'WIN1251','SYSDBA','masterkey',dbPath_data_NEW);
  if cbFoto.Checked then
  begin
    FDBConnect(FDB_photo_old,TB_photo_old,'WIN1251','SYSDBA','masterkey',dbPath_photo_old);
    FDBConnect(FDB_photo_NEW,TB_photo_NEW,'WIN1251','SYSDBA','masterkey',dbPath_photo_NEW);
    pQueryExecSQL(q_photo_NEW,'delete from UPH');
  end;





  pQueryExecSQL(q_data_NEW,'delete from FB_USR');
  pQueryExecSQL(q_data_NEW,'delete from FB_KEY');

  pQueryExecSQL(q_data_NEW,'delete from FB_ODO');
  pQueryExecSQL(q_data_NEW,'delete from FB_DVS');
  pQueryExecSQL(q_data_NEW,'delete from FB_ODO2');
  pQueryExecSQL(q_data_NEW,'delete from FB_TDG');

  {TB_data_NEW.commit;
  TB_photo_NEW.commit;
  exit;
  }

  IBTblImage.Open;
  createdir(extractfiledir(application.ExeName) + '\img');

  pQueryOpen(q_data_Old,'select * FROM FB_ODO');
  q_data_Old.First;
  while not q_data_Old.Eof do
  begin
    sql :=
          'insert into FB_ODO(ID,NAME,FLAG1, FLAG2) values (' +
          '''' + q_data_Old.FieldByName('ID').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('NAME').AsString + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FLAG1').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FLAG2').AsString,'0') + ''')';
    pQueryExecSQL(q_data_NEW,sql);
    q_data_Old.Next;
  end;


  {pQueryOpen(q_data_Old,'select * FROM FB_ODO2');
  q_data_Old.First;
  while not q_data_Old.Eof do
  begin
    sql :=
          'insert into FB_ODO2(OB,KONT) values (' +
          '''' + q_data_Old.FieldByName('OB').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('KONT').AsString + ''')';
    pQueryExecSQL(q_data_NEW,sql);
    q_data_Old.Next;
  end;
  }

  cxLabel1.Caption := 'Загружаем схемы доступа';
  ps.Position := 0;
  pQueryOpen(q_data_Old,'select * FROM FB_TDG');
  q_data_Old.First;
  while not q_data_Old.Eof do
  begin
    sql :=
          'insert into FB_TDG(USERID,TD,GYEAR1,GRAPH1,GYEAR2,GRAPH2,FLAG1) values (' +
          '''' + q_data_Old.FieldByName('USERID').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('TD').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('GYEAR1').AsString + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('GRAPH1').AsString,'0') + ''', ' +
          '''' + q_data_Old.FieldByName('GYEAR2').AsString + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('GRAPH2').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FLAG1').AsString,'0') + ''')';
    pQueryExecSQL(q_data_NEW,sql);

    ps.Position := q_data_Old.RecNo *100/q_data_Old.RecordCount;
    application.ProcessMessages;
    q_data_Old.Next;
  end;




  cxLabel1.Caption := 'Загружаем пользователей';
  pQueryOpen(q_data_Old,'select * FROM FB_USR');
  q_data_Old.First;
  while not q_data_Old.Eof do
  begin
    sql :=
          'insert into FB_USR(ID,TABNUM,FNAME,LNAME,SNAME,DOLZ,PODR,DOP1,DOP2,DOP3,DOP4,BALANCE,PHONE,EMAIL) values (' +
          '''' + q_data_Old.FieldByName('ID').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('TABNUM').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('FNAME').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('LNAME').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('SNAME').AsString + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('DOLZ').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('PODR').AsString,'0') + ''', ' +
          '''' + q_data_Old.FieldByName('DOP1').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('DOP2').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('DOP3').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('DOP4').AsString + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('BALANCE').AsString,'0') + ''', ' +
          '''' + q_data_Old.FieldByName('PHONE').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('EMAIL').AsString + ''') ';


    pQueryExecSQL(q_data_NEW,sql);
    ps.Position := q_data_Old.RecNo *100/q_data_Old.RecordCount;
    application.ProcessMessages;
    q_data_Old.Next;
  end;

  cxLabel1.Caption := 'Загружаем ключи';
  pQueryOpen(q_data_Old,'select * FROM FB_KEY');
  q_data_Old.First;
  while not q_data_Old.Eof do
  begin

    sql :=
          'insert into FB_KEY (UID,EXPD,DESCR,GDATE,GUID,FBLOCK,TIP,INHEX,FLAG1,FLAG2,EXPT,FLAG3,FLAG4,ACKY,DN,EXTCODE,ODO,ID,CID,FLAG5) values ( ' +
          '''' + q_data_Old.FieldByName('UID').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('EXPD').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('DESCR').AsString + ''', ' +
          '''' + q_data_Old.FieldByName('GDATE').AsString + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('GUID').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FBLOCK').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('TIP').AsString,'0') + ''', ' +
          '''' + q_data_Old.FieldByName('INHEX').AsString + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FLAG1').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FLAG2').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('EXPT').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FLAG3').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FLAG4').AsString,'0') + ''', ' +
          '''' + q_data_Old.FieldByName('ACKY').AsString + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('DN').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('EXTCODE').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('ODO').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('ID').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('CID').AsString,'0') + ''', ' +
          '''' + isNUll(q_data_Old.FieldByName('FLAG5').AsString,'0') + ''') ';


    pQueryExecSQL(q_data_NEW,sql);
    ps.Position := q_data_Old.RecNo *100/q_data_Old.RecordCount;
    application.ProcessMessages;
    q_data_Old.Next;
  end;

  if cbFoto.Checked then
  begin
    cxLabel1.Caption := 'Загружаем фото';
    pQueryOpen(q_photo_Old,'select * FROM UPH');
    q_photo_Old.First;
    while not q_photo_Old.Eof do
    begin
      DirImage := extractfiledir(application.ExeName) + '\img\';
      FloadImageFIREBIRDServer (DirImage, q_photo_Old.FieldByName('USERID').AsString + '.bmp', q_photo_Old);
      ImBMP := DirImage + q_photo_Old.FieldByName('USERID').AsString + '.bmp';
      ImJpg := DirImage + q_photo_Old.FieldByName('USERID').AsString + '.jpg';
      BMPtoJPG(ImBMP, ImJpg);

        IBTblImage.Insert;
        IBTblImage.FieldByName('USERID').AsString := q_photo_Old.FieldByName('USERID').AsString;
        TBlobField(IBTblImage.FieldByName('PHOTO')).LoadFromFile(ImJpg);
        IBTblImage.Post;

        DeleteFile(ImBMP);
        DeleteFile(ImJpg);

      ps.Position := q_photo_Old.RecNo *100/q_photo_Old.RecordCount;
      application.ProcessMessages;
      q_photo_Old.Next;
    end;
  end;



  TB_data_NEW.commit;
  TB_photo_NEW.commit;
  MessageDlg('Данные скопированы', mtInformation, [mbOk], 0);




end;

procedure TForm1.dbPath_oldPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
OpenDialog1.Filter := '*.fdb';
if OpenDialog1.Execute then dbPath_old.Text := OpenDialog1.FileName;
end;

procedure TForm1.dbPath_NEWPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
OpenDialog1.Filter := '*.fdb';
if OpenDialog1.Execute then dbPath_NEW.Text := OpenDialog1.FileName;
end;

end.
