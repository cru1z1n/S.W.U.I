object Form1: TForm1
  Left = 278
  Top = 316
  Width = 356
  Height = 216
  Caption = 'Simba Web User Interface '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 165
    Width = 346
    Height = 13
    Caption = 
      'v0.01                                                           ' +
      '                                 By Mark.'
  end
  object Memo1: TMemo
    Left = 26
    Top = 1
    Width = 297
    Height = 161
    Lines.Strings = (
      '                                         S.W.U.I'
      '                              Simba Web User Interface'
      'Features:'
      '* Start/Stop/Restart  Scripts.'
      '*Open/Close New script.'
      '*Take ScreenShot'
      '*Custom Commands Accepted.'
      ''
      'Future Plans:'
      '*Edit Script Before Use'
      '*Import code From Online (write and test scripts on the go)')
    ReadOnly = True
    TabOrder = 0
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 312
  end
end
