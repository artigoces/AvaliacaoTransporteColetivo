object dtmdlDados: TdtmdlDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 167
  Width = 331
  object fdconConexao: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=C:\Users\VM Windows\Downloads\AppDelphi\info\BaseApp.db')
    LoginPrompt = False
    Left = 32
    Top = 14
  end
  object fdgxwtcrsrConexao: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 63
    Top = 70
  end
  object fdphysqltdrvrlnkConexao: TFDPhysSQLiteDriverLink
    Left = 175
    Top = 70
  end
end
