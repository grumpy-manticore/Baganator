BaganatorSingleViewBankViewWarbandViewMixin = CreateFromMixins(BaganatorItemViewCommonBankViewWarbandViewMixin)

function BaganatorSingleViewBankViewWarbandViewMixin:GetMatches()
  return self.BankLive.SearchMonitor:GetMatches()
end

function BaganatorSingleViewBankViewWarbandViewMixin:NotifyBagUpdate(updatedBags)
  self.BankLive:MarkTabsPending(updatedBags)
end

function BaganatorSingleViewBankViewWarbandViewMixin:ShowTab(tabIndex, isLive)
  BaganatorItemViewCommonBankViewWarbandViewMixin.ShowTab(self, tabIndex, isLive)

  local activeBank

  if self.BankLive:IsShown() then
    activeBank = self.BankLive
  else
    activeBank = self.BankCached
  end

  local bankWidth = Baganator.Config.Get(Baganator.Config.Options.WARBAND_BANK_VIEW_WIDTH)

  activeBank:ShowTab(self.currentTab, Syndicator.Constants.AllWarbandIndexes, bankWidth)

  local searchText = self:GetParent().SearchWidget.SearchBox:GetText()
  self:ApplySearch(searchText)

  -- Copied from SingleViews/BagView.lua
  local sideSpacing, topSpacing = 13, 14
  if Baganator.Config.Get(Baganator.Config.Options.REDUCE_SPACING) then
    sideSpacing = 8
    topSpacing = 7
  end

  local bankHeight = activeBank:GetHeight() + topSpacing / 2

  bankHeight = bankHeight + 20

  activeBank:ClearAllPoints()
  activeBank:SetPoint("TOPLEFT", sideSpacing + Baganator.Constants.ButtonFrameOffset - 2, - 50 - topSpacing / 4)

  if self.isLive then
    bankHeight = bankHeight + 25
  end

  Baganator.CallbackRegistry:TriggerEvent("ViewComplete")

  self:SetSize(
    activeBank:GetWidth() + sideSpacing * 2 + Baganator.Constants.ButtonFrameOffset - 2,
    bankHeight + 55
  )

  self:GetParent():OnTabFinished()
end

function BaganatorSingleViewBankViewWarbandViewMixin:ApplySearch(text)
  if self.isLive then
    self.BankLive:ApplySearch(text)
  else
    self.BankCached:ApplySearch(text)
  end
end
