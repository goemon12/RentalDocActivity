import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image
    @Binding var date: Date
    @Binding var isPick: Bool
    @State var source: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}
