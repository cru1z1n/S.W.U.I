program SWebUi;

uses
  Forms,
  WebUi in 'WebUi.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'S.W.U.I';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

