import Foundation
import UIKit
import AAInfographics

class ConsumptionController: UIViewController {
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let theme = ["#438A5E"]
    let bottles = "Bottles"

    private var userId: [String]?
    private var consumption: Consumption?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let aaChartView = AAChartView()
        aaChartView.frame = self.view.bounds
        self.view.addSubview(aaChartView)

        var consumptionChart = initChart(chartType: AAChartType.spline,
                                         title: "Recycle Overview",
                                         subtitle: "bottles",
                                         tooltip: "count",
                                         categories: months,
                                         theme: theme)
        let userConsumption = Consumption()
        consumptionChart = populateChart(consumption: userConsumption,
                                         consumptionChart: consumptionChart)
        aaChartView.aa_drawChartWithChartModel(consumptionChart)
    }
       
    func initChart(chartType: AAChartType,
                   title: String,
                   subtitle: String,
                   tooltip: String,
                   categories: [String],
                   theme: [String]) -> AAChartModel{
        return AAChartModel()
            .chartType(chartType)
            .animationType(.bounce)
            .title(title)
            .subtitle(subtitle)
            .dataLabelsEnabled(false)
            .tooltipValueSuffix(tooltip)
            .categories(categories)
            .colorsTheme(theme)
    }

    func populateChart(consumption: Consumption, consumptionChart: AAChartModel) -> AAChartModel {
        let recycledArticles = AASeriesElement()
            .name(bottles)
            .data(consumption.recycledArticles)
        
        return consumptionChart.series([recycledArticles])
    }
    
}
