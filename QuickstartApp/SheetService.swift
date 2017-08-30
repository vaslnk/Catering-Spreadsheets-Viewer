
protocol SheetService {
    func loadSheetForDate(date: String, completionHandler: @escaping (Error?, [[String]]?) -> Void)
}
