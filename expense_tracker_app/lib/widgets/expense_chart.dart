import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class ExpenseChart extends StatelessWidget {               // Stateless widget
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(                      // Listens to notify listeners
      builder: (context, provider, _) {
        if (provider.isMonthlyView) {
          return _buildMonthlyChart(context, provider);
        } else {
          return _buildYearlyChart(context, provider);
        }
      },
    );
  }

  Widget _buildMonthlyChart(BuildContext context, ExpenseProvider provider) {
    final maxAmount = provider.getMaxExpenseAmount();
    final displayMax = maxAmount == 0 ? 1 : maxAmount * 1.2;         // 20% extra space above tallest bar

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: displayMax.toDouble(),
        barTouchData: BarTouchData(                        // User interaction with the bars
          enabled: true,
          touchTooltipData: BarTouchTooltipData(           // Pop-up when bar is touched
            tooltipBgColor: Colors.black,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '₹${rod.toY.toStringAsFixed(0)}',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, response) {  // Runs when user taps the chart
            if (event is FlTapUpEvent && response != null) {
              final touchedSpot = response.spot;           // Gets the touched bar
              if (touchedSpot != null) {
                final day = touchedSpot.touchedBarGroup.x + 1;       // index + 1
                provider.setSelectedDay(day);              // Update the provider
              }
            }
          },
        ),
        titlesData: FlTitlesData(                          // Controls the axis data
          show: true,
          bottomTitles: AxisTitles(                        // X axis
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final day = value.toInt() + 1;
                // Show every 5th day to avoid crowding
                if (day % 5 == 1 || day == 1) {
                  return Text(
                    '$day',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(                          // Y axis
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${value.toInt()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(        
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
        ),
        borderData: FlBorderData(                          // Border for the bar graph
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        barGroups: List.generate(31, (index) {             // Create 31 bars.
          final day = index + 1;
          final amount = provider.getTotalExpenseForDay(day);
          final isSelected = provider.selectedDay == day;

          return BarChartGroupData(
            x: index,                                      // 31 in number
            barRods: [
              BarChartRodData(
                toY: amount == 0 ? 0 : amount,             // Y axis with respect to amount
                color: isSelected ? Colors.black87 : Colors.black,
                width: 6,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildYearlyChart(BuildContext context, ExpenseProvider provider) {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final maxAmount = provider.getMaxExpenseAmount();
    final displayMax = maxAmount == 0 ? 1 : maxAmount * 1.2;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: displayMax.toDouble(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '₹${rod.toY.toStringAsFixed(0)}',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, response) {
            if (event is FlTapUpEvent && response != null) {
              final touchedSpot = response.spot;
              if (touchedSpot != null) {
                final month = touchedSpot.touchedBarGroup.x + 1;
                provider.setSelectedMonth(month);
              }
            }
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final monthIndex = value.toInt();
                return Text(
                  monthNames[monthIndex],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${value.toInt()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        barGroups: List.generate(12, (index) {
          final month = index + 1;
          final amount = provider.getTotalExpenseForMonth(month);
          final isSelected = provider.selectedMonth == month;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: amount == 0 ? 0 : amount,
                color: isSelected ? Colors.black87 : Colors.black,
                width: 6,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ],
          );
        }),
      ),
    );
  }
}
