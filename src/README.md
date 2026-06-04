# WATERMILKTEA - Website Đặt Mua Trà Sữa Trực Tuyến

Chào mừng bạn đến với **WATERMILKTEA**! Đây là website đặt mua trà sữa trực tuyến hỗ trợ chọn kích cỡ, tích chọn nhiều loại topping, đăng ký/đăng nhập, tìm kiếm món uống và quản trị menu/hóa đơn dành cho admin.

Dự án được xây dựng theo cấu trúc tối giản, ít trang code, gộp các tính năng hợp lý và sử dụng tông màu chủ đạo ngọt ngào: **Tím Pastel, Hồng Pastel và Xanh Dương Pastel**.

---

## 🛠️ Công Nghệ Sử Dụng

- **Frontend & Logic:** ASP.NET Web Forms (sử dụng đuôi `.aspx` và code-behind `.aspx.cs` bằng ngôn ngữ C#).
- **Styling:** Vanilla CSS với thiết kế Pastel hiện đại, mượt mà và tương thích tốt trên các thiết bị.
- **Cơ sở dữ liệu:** SQL Server LocalDB (`(LocalDB)\MSSQLLocalDB`) - Tích hợp sẵn trong Visual Studio.
- **Biên dịch:** MSBuild.

---

## 🗄️ Cấu Trúc 5 Bảng Cơ Sở Dữ Liệu (Tiếng Việt)

Cơ sở dữ liệu tên **`WaterMilkTeaDB`** được thiết kế chuẩn hóa và tự động tạo khi chạy dự án lần đầu tiên:

1. **`NguoiDung`**: Quản lý tài khoản (Khách hàng & Admin).
2. **`SanPham`**: Thực đơn trà sữa và danh sách topping đi kèm.
3. **`DonHang`**: Hóa đơn chính (thông tin người nhận, địa chỉ giao hàng, trạng thái, tổng tiền).
4. **`ChiTietDonHang`**: Chi tiết từng ly trà sữa và kích cỡ đã chọn của đơn hàng.
5. **`ToppingDonHang`**: Các topping đi kèm riêng cho từng ly trà sữa trong chi tiết đơn hàng.

---

## 🌟 Chức Năng Tự Động Khởi Tạo & Chèn Dữ Liệu (Seeding)

Bạn **không cần chạy bất kỳ file SQL thủ công nào**. Khi ứng dụng được khởi chạy lần đầu:
- File `Global.asax.cs` sẽ tự động tạo cơ sở dữ liệu `WaterMilkTeaDB` nếu chưa có.
- Tự động tạo 5 bảng tiếng Việt với đầy đủ các khóa ngoại và ràng buộc.
- Tự động chèn dữ liệu mẫu bao gồm:
  - Tài khoản Admin: `admin` / mật khẩu: `admin123`
  - Tài khoản Khách hàng: `customer` / mật khẩu: `customer123`
  - 4 món trà sữa cơ bản (đính kèm hình ảnh sắc nét được sinh bởi AI trong thư mục `/Images`).
  - 4 loại topping kèm giá bán tương ứng.

---

## 📂 Danh Sách Các File Trong Dự Án (Dành cho GitHub)

Dự án được tổ chức gọn gàng để bạn dễ dàng đẩy lên GitHub:

- `WaterMilkTea.csproj`: File dự án Visual Studio / MSBuild.
- `Web.config`: File cấu hình hệ thống (chứa Connection String kết nối LocalDB).
- `DatabaseHelper.cs`: Công cụ kết nối và xử lý câu lệnh SQL (ADO.NET) an toàn, tránh SQL Injection.
- `Global.asax` & `Global.asax.cs`: Quản lý vòng đời web, tự động tạo DB và dữ liệu mẫu khi khởi động.
- `Site.Master` & `Site.Master.cs`: Layout chung (Header Logo, Navigation, Giỏ hàng, nút Đăng nhập/Đăng xuất).
- `site.css`: Tệp tin CSS chứa toàn bộ thiết kế Pastel ngọt ngào và các hiệu ứng.
- `Default.aspx` & `Default.aspx.cs`: Trang chủ hiển thị món, tìm kiếm, giỏ hàng session, và đặt hàng nhanh.
- `Auth.aspx` & `Auth.aspx.cs`: Trang tích hợp Đăng Nhập & Đăng Ký thông minh.
- `Admin.aspx` & `Admin.aspx.cs`: Trang quản trị Admin (Tab 1: Thêm/Sửa/Xóa sản phẩm, Tab 2: Xem chi tiết hóa đơn & Đổi trạng thái đơn hàng).
- `Images/`: Thư mục hình ảnh chất lượng cao của trà sữa và các loại topping.
- `.gitignore`: Loại bỏ các file tạm, file build của Visual Studio trước khi đẩy lên Git.

---

## 🚀 Hướng Dẫn Chạy Dự Án

### Cách 1: Sử dụng Visual Studio (Khuyên dùng)
1. Mở Visual Studio (phiên bản 2019 hoặc 2022).
2. Chọn **Open a project or solution** và tìm chọn tệp `WaterMilkTea.csproj`.
3. Bấm nút **Play / IIS Express** ở thanh công cụ phía trên.
4. Trình duyệt sẽ tự động mở trang web. Cơ sở dữ liệu sẽ tự động tạo và chèn dữ liệu mẫu trong vài giây đầu tiên.

### Cách 2: Chạy từ Dòng lệnh (Command Line)
Nếu máy bạn đã cấu hình các biến môi trường, bạn có thể chạy bằng lệnh:
```powershell
# Biên dịch dự án bằng MSBuild
"C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" WaterMilkTea.csproj

# Chạy IIS Express để khởi chạy web server
"C:\Program Files\IIS Express\iisexpress.exe" /path:D:\desktop\LAMTHITHUTHUY /port:8080
```
Sau đó, truy cập: `http://localhost:8080/Default.aspx` để bắt đầu trải nghiệm.

---
*Chúc bạn có những trải nghiệm tuyệt vời cùng WATERMILKTEA!* 💜
