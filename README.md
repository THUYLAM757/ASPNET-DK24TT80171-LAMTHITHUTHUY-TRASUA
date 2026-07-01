WATERMILKTEA - Website Đặt Mua Trà Sữa Trực Tuyến
Chào mừng bạn đến với WATERMILKTEA! Đây là website đặt mua trà sữa trực tuyến hỗ trợ chọn kích cỡ, tích chọn nhiều loại topping, đăng ký/đăng nhập, tìm kiếm món uống và quản trị menu/hóa đơn dành cho admin.
Dự án được xây dựng theo cấu trúc tối giản, ít trang code, gộp các tính năng hợp lý và sử dụng tông màu chủ đạo ngọt ngào: Tím Pastel, Hồng Pastel và Xanh Dương Pastel.
🛠️ Công Nghệ Sử Dụng
Frontend & Logic: ASP.NET Web Forms (sử dụng đuôi .aspx và code-behind .aspx.cs bằng ngôn ngữ C#).
Styling: Vanilla CSS với thiết kế Pastel hiện đại, mượt mà và tương thích tốt trên các thiết bị.
Cơ sở dữ liệu: SQL Server LocalDB ((LocalDB)\MSSQLLocalDB) - Tích hợp sẵn trong Visual Studio.
Biên dịch: MSBuild.
🚀 Hướng Dẫn Chạy Dự Án
Cách 1: Sử dụng Visual Studio (Khuyên dùng)
Mở Visual Studio (phiên bản 2019 hoặc 2022).
Chọn Open a project or solution và tìm chọn tệp WaterMilkTea.csproj.
Bấm nút Play / IIS Express ở thanh công cụ phía trên.
Trình duyệt sẽ tự động mở trang web. Cơ sở dữ liệu sẽ tự động tạo và chèn dữ liệu mẫu trong vài giây đầu tiên.
Cách 2: Chạy từ Dòng lệnh (Command Line)
Nếu máy bạn đã cấu hình các biến môi trường, bạn có thể chạy bằng lệnh:
# Biên dịch dự án bằng MSBuild
"C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" WaterMilkTea.csproj
# Chạy IIS Express để khởi chạy web server
"C:\Program Files\IIS Express\iisexpress.exe" /path:D:\desktop\LAMTHITHUTHUY /port:8080
Sau đó, truy cập: http://localhost:8080/Default.aspx để bắt đầu trải nghiệm.

