import SwiftUI

struct MoodDiaryEditor: View {
    @ObservedObject var viewModel: TrackingViewModel
    let selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    @State private var diaryText = ""
    @State private var selectedMood: String = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 標題區域
                HStack {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.orange)
                    
                    Spacer()
                    
                    Text("心情日記")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.darkBrown)
                    
                    Spacer()
                    
                    Button("保存") {
                        viewModel.addMoodEntry(selectedMood, note: diaryText, date: selectedDate)
                        dismiss()
                    }
                    .foregroundColor(AppColors.orange)
                    .fontWeight(.medium)
                }
                .padding()
                .background(Color.white)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 日期顯示
                        Text(dateFormatter.string(from: selectedDate))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.darkBrown)
                        
                        // 心情選擇
                        VStack(alignment: .leading, spacing: 10) {
                            Text("今天的心情")
                                .font(.headline)
                                .foregroundColor(AppColors.darkBrown)
                            
                            TextField("請輸入今天的心情...", text: $selectedMood)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // 日記內容
                        VStack(alignment: .leading, spacing: 10) {
                            Text("心情記錄")
                                .font(.headline)
                                .foregroundColor(AppColors.darkBrown)
                            
                            TextEditor(text: $diaryText)
                                .frame(minHeight: 200)
                                .padding(10)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.orange.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                }
                .background(AppColors.lightYellow)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let existingEntry = viewModel.getMoodEntry(for: selectedDate) {
                selectedMood = existingEntry.mood
                diaryText = "" // 若有 note 欄位可帶入
            }
        }
    }
}

#Preview {
    MoodDiaryEditor(
        viewModel: TrackingViewModel(),
        selectedDate: Date()
    )
}
