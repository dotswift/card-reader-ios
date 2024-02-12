import Foundation
import SwiftUI

public struct CardFormView: View {
    
    @State private var isShowingSheet = false
    @State private var cardNumber: String = ""
    @State private var cardName: String = ""
    @State private var cardExpiryDate: String = ""
    @State private var cvcNumber: String = ""
    
    public var completion: ((CardDetails) -> Void)
    
    private var colors: [Color]
    private var formattedCardNumber: String { cardNumber == "" ? "4111 2222 3333 4444" : cardNumber }
    private var cardIndustry: CardIndustry { .init(firstDigit: formattedCardNumber.first) }
        
    public init(colors: [Color] = [.green, .blue, .black], completion: @escaping ((CardDetails) -> Void )) {
        self.colors = colors
        self.completion = completion
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack {
                Spacer()
//                if InsuranceDetails. == nil {
//                    CreditCardView(backgroundColors: colors, cardNumber: $cardNumber, cardExpiryDate: $cardExpiryDate, cardName: $cardName)
//                        .shadow(color: .primaryColor, radius: 5)
//                        .padding(.top, 60)
//                                    
//                } else {
//                }

                if cardIndustry != .unknown {
                    Text(cardIndustry.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.primaryColor)
                        .padding(.top, 10)
                }
                
                Button(action: {
                    isShowingSheet.toggle()
                }) {
                    HStack(alignment: .center) {
                        Image("scan", bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                        
                        Text("Scan Card")
                            .font(.system(size: 26, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(.primaryColor)
                    .padding(.all, 12)
                    .background(Color.textFieldColor)
                    .cornerRadius(16)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)

                .sheet(isPresented: $isShowingSheet) {
                    CardReaderView() { cardDetails in
                        print(cardDetails ?? "")
                        cardNumber = cardDetails?.number ?? ""
                        cardExpiryDate = cardDetails?.expiryDate ?? ""
                        cardName = cardDetails?.name ?? ""
                        isShowingSheet.toggle()
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .background(Color.backgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        CardFormView(completion: { _ in })
    }
}
