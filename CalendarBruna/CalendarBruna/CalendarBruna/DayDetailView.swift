import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let time: String
    let description: String
}

class EventModel: ObservableObject {
    
    @Published var events: [Event] = [
        Event(time: "10:00 AM", description: "Meeting"),
        Event(time: "02:30 PM", description: "Lunch"),
        Event(time: "06:00 PM", description: "Gym"),
    ]
    
    func addEvent(time: String, description: String) {
        let newEvent = Event(time: time, description: description)
        events.append(newEvent)
    }
    
    func removeEvent(at index: Int) {
        events.remove(at: index)
    }
}

struct AddEventView: View {
    @Binding var isPresented: Bool
    @ObservedObject var eventModel: EventModel

    @State private var selectedTime: String = ""
    @State private var eventDescription: String = ""

    var allDayHours: [String] {
        var hours = [String]()
        for hour in 0..<24 {
            hours.append(String(format: "%02d:00", hour))
        }
        return hours
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Ora", selection: $selectedTime) {
                        ForEach(allDayHours, id: \.self) { hour in
                            Text(hour)
                        }
                    }
                }

                Section {
                    TextField("Descrizione", text: $eventDescription)
                }

                Section {
                    Button("Aggiungi Evento") {
                        if !selectedTime.isEmpty && !eventDescription.isEmpty {
                            eventModel.addEvent(time: selectedTime, description: eventDescription)
                            isPresented = false
                        }
                    }
                }
            }
            .navigationBarTitle("Aggiungi Evento", displayMode: .inline)
            .navigationBarItems(trailing: Button("Annulla") {
                isPresented = false
            })
        }
    }
}

struct EventDetailsView: View {
    @EnvironmentObject var eventModel: EventModel
    let event: Event
    let onDelete: () -> Void

    var body: some View {
        VStack {
            Text("Dettagli evento")
                .font(.title)

            Text("Ora: \(event.time)")
            Text("Descrizione: \(event.description)")

            Button("Elimina evento") {
                onDelete()
            }
            .foregroundColor(.red)
        }
        .padding()
        .navigationBarTitle("Dettagli Evento")
    }
}



struct DayDetailView: View {
    @ObservedObject var eventModel = EventModel()
    @State private var selectedEvent: Event?

    let day: Int
    let month: Int
    let year: Int
    
    @State private var isAddEventPresented: Bool = false
    
    
    // Genera dinamicamente tutti gli orari del giorno
    var allDayHours: [String] {
        var hours = [String]()
        for hour in 0..<24 {
            hours.append(String(format: "%02d:00", hour))
        }
        return hours
    }
    
    // Restituisce l'evento associato a un'ora specifica
    func getEvent(for time: String) -> Event? {
        return eventModel.events.first { $0.time == time }
    }
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer() // Aggiungi uno Spacer per allineare il contenuto a destra
                    Button(action: {
                        isAddEventPresented = true
                    }) {
                        
                        Text("\(day) \(getMonthName(month)) \(String(format: "%d", year))")
                            .scaleEffect(CGSize(width: 1, height: 1))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .accentColor(Color.black)
                            .font(.title)
                             
                            .foregroundColor(Color.primary)
                        Image(systemName: "plus")
                           
                          .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                            .foregroundColor(Color.primary)
                    
                                              
                    }
                    .padding()
                    .sheet(isPresented: $isAddEventPresented) {
                        AddEventView(isPresented: $isAddEventPresented, eventModel: eventModel)
                    }
                }
                
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading) // Aggiungi questa riga per allineare a sinistra
                
                // Mostra tutti gli orari e gli eventi associati
                ForEach(allDayHours.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text(allDayHours[index])
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if let event = getEvent(for: allDayHours[index]) {
                            HStack {
                                Text(event.description)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Button(action: {
                                    // Imposta l'evento selezionato
                                    selectedEvent = event
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                }
                            }
                            .sheet(item: $selectedEvent) { event in
                                EventDetailsView(event: event) {
                                    // Rimuovi l'evento dal modello quando viene eliminato da EventDetailsView
                                    if let index = eventModel.events.firstIndex(where: { $0.id == event.id }) {
                                        eventModel.removeEvent(at: index)
                                        selectedEvent = nil
                                    }
                                }
                                .environmentObject(eventModel)
                            }
                        } else {
                            Text("Nessun evento")
                                .scaleEffect(CGSize(width: 1.2, height: 1.2))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationBarTitle("Dettagli Giorno")
        }
        
        
       
            .padding()
            .navigationBarTitle("Dettagli Giorno")
            .preferredColorScheme(.dark)
        
    }
    
    func getMonthName(_ month: Int) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.monthSymbols[month - 1]
    }
    
}

struct DayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DayDetailView(day: 1, month: 1, year: 2023)  
    }
}
