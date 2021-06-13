class PUBGUser {
  String accountId;
  String name;
  String soloTier;
  String soloRank;
  int soloPoints;
  String squadTier;
  String squadRank;
  int squadPoints;

  PUBGUser(
      {this.accountId,
      this.name,
      this.soloTier,
      this.soloRank,
      this.soloPoints,
      this.squadTier,
      this.squadRank,
      this.squadPoints});

  @override
  String toString() {
    return "USER INFO:\n[name: $name\naccountId: $accountId\nsoloTier: $soloTier\nsoloRank: $soloRank\nsoloPoints: $soloPoints\nsquadTier: $squadTier\nsquadRank: $squadRank\nrankPoints: $squadPoints";
  }
}
