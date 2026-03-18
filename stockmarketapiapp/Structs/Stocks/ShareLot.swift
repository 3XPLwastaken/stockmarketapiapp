// we cant store our old tuple i tink
@Model
class ShareLot {
    var amount: Double
    var purchasedAt: Double

    init(amount: Double, purchasedAt: Double) {
        self.amount = amount
        self.purchasedAt = purchasedAt
    }
}