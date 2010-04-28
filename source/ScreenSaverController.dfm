object dmController: TdmController
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 241
  Width = 380
  object tmrUpdate: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = tmrUpdateTimer
    Left = 328
    Top = 168
  end
end
