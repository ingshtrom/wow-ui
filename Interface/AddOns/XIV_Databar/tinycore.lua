local XIVBar = LibStub("AceAddon-3.0"):NewAddon("XIVBar")

XIVBar.defaults = {
  profile = {
    general = {
      barPosition = "BOTTOM",
    }
  }
}

function XIVBar:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("XIVBarDB", self.defaults)
  print("XIVBar:OnInitialize", self.db.profile.general.barPosition)
end
