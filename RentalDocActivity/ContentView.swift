import SwiftUI

class Data: ObservableObject {
    @Published var image: UIImage?
}

struct ContentView: View {
    @ObservedObject var data = Data()
    
    @State var title: String = ""
    @State var stat: Int = 0
    @State var date: Date = Date()
    @State var photo: Image = Image(systemName: "photo")
    
    @State var isPick: Bool = false
    @State var isActivity: Bool = false
    @State var source = UIImagePickerController.SourceType.photoLibrary
    
    var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        return f
    }
    
    var body: some View {
        GeometryReader {geometry in
            NavigationView {
                ScrollView {
                    VStack(spacing: 10) {
                        //品名
                        Text("品名").font(.title)
                        TextField("品名を入力ください", text: $title)

                        //状態
                        Text("状態").font(.title)
                        Picker(selection: $stat, label: Text("状態")) {
                            Text("未選択").tag(0)
                            Text("貸出中").tag(1)
                            Text("返却済").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())

                        //写真
                        Text("写真").font(.title)
                        Text(dateFormatter.string(from: date))
                        photo
                            .resizable()
                            .scaledToFit()
                        
                        HStack {
                            Spacer(minLength: 50)
                            Button(action: {
                                source = UIImagePickerController.SourceType.camera
                                isPick = true
                            }) {
                                VStack {
                                    Image(systemName: "camera")
                                        .resizable()
                                        .scaledToFit()
                                    Text("撮影")
                                }
                            }
                            Spacer(minLength: 20)
                            Button(action: {
                                source = UIImagePickerController.SourceType.photoLibrary
                                isPick = true
                            }) {
                                VStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                    Text("アルバム")
                                }
                            }
                            Spacer(minLength: 50)
                        }
                        .sheet(isPresented: $isPick) {
                            ImagePicker(image: $photo, date: $date, isPick: $isPick, source: source)
                        }
                    }
                    .padding()
                }
                //Naviメニュー
                .navigationBarTitle("レンタル管理", displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    data.image = capture(rect: geometry.frame(in: .global))
                    isActivity = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                    Text("共有する")
                })
            }
        }
        .sheet(isPresented: $isActivity) {
            if data.image != nil {
                let imgs = [data.image!]
                ActivityView(activityItems: imgs, applicationActivities: nil)
            }
        }
    }
}

extension UIView {
    var renderedImage: UIImage {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let capturedImgae: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImgae
    }
}

extension ContentView {
    func capture(rect: CGRect) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: rect.origin, size: rect.size))
        let hosting = UIHostingController(rootView: self.body)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
