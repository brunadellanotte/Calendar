import SwiftUI

struct CalendarView: View {
    @State private var selectedDay: Int?
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(2023...2030, id: \.self) { year in
                            VStack(alignment: .leading) {
                                Text("Anno \(String(format: "%d", year))")
                                    .font(.title)
                                    .padding(.horizontal)
                                
                                
                                ForEach(1...12, id: \.self) { month in
                                    VStack(alignment: .leading) {
                                        Text(getMonthName(month))
                                            .font(.title2)
                                            .padding(.horizontal)
                                        
                                        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                                            
                                            ForEach(getDaysInMonth(month, year: year), id: \.self) { day in
                                                NavigationLink(
                                                    destination: DayDetailView(day: day, month: month, year: year),
                                                    label: {
                                                        VStack {
                                                            CalendarDayView(day: day)
                                                                .background(selectedDay == day ? Circle().foregroundColor(.blue).padding(4) : nil)
                                                        }
                                                    }
                                                )
                                                .accentColor(Color.black)
                                                .foregroundColor(Color.primary)
                                                .onTapGesture {
                                                    selectedDay = day
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .padding(.bottom)
                                }
                            }
                            .id(year)
                        }
                    }
                    .onAppear {
                        // Scorri fino all'anno corrente
                        scrollView.scrollTo(2030, anchor: .top)
                    }
                }
                .navigationBarTitle("Calendario")
                .preferredColorScheme(.dark)
            }
        }
            }
    }
    
    func getMonthName(_ month: Int) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.monthSymbols[month - 1]
    }
    
    func getDaysInMonth(_ month: Int, year: Int) -> [Int] {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month)
        let startDate = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        return Array(range.lowerBound..<range.upperBound)
    }


/*
 struct DayDetailView: View {
 let day: Int
 let month: Int
 let year: Int
 
 var body: some View {
 VStack {
 Text("\(day) \(getMonthName(month)) \(year)")
 .font(.title)
 .padding()
 
 // Qui puoi aggiungere la logica per visualizzare gli orari e gestire gli eventi
 // Ad esempio, puoi utilizzare un elenco di eventi o un altro componente adatto al tuo caso.
 Text("Dettagli del giorno e orari verranno visualizzati qui.")
 .padding()
 }
 .navigationBarTitle("Dettagli Giorno")
 }
 
 func getMonthName(_ month: Int) -> String {
 let dateFormatter = DateFormatter()
 return dateFormatter.monthSymbols[month - 1]
 }
 }
 */

struct CalendarDayView: View {
    let day: Int
    
    var body: some View {
        Text("\(day)")
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
            .cornerRadius(8)
            .padding(4)
            .lineLimit(1)  // Limita il testo a una sola riga
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
