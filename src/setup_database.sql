USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'WaterMilkTeaDB')
BEGIN
    ALTER DATABASE WaterMilkTeaDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE WaterMilkTeaDB;
END
GO
CREATE DATABASE WaterMilkTeaDB;
GO
USE WaterMilkTeaDB;
GO
CREATE TABLE dbo.NguoiDung (
    MaNguoiDung INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap NVARCHAR(50) UNIQUE NOT NULL,
    MatKhau NVARCHAR(100) NOT NULL,
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NULL,
    SoDienThoai NVARCHAR(20) NOT NULL,
    DiaChi NVARCHAR(250) NULL,
    VaiTro NVARCHAR(20) NOT NULL
);
GO
CREATE TABLE dbo.SanPham (
    MaSanPham INT IDENTITY(1,1) PRIMARY KEY,
    TenSanPham NVARCHAR(100) NOT NULL,
    LoaiSanPham NVARCHAR(50) NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    DuongDanAnh NVARCHAR(250) NOT NULL,
    MoTa NVARCHAR(500) NULL,
    ConHoatDong BIT DEFAULT 1
);
GO
CREATE TABLE dbo.DonHang (
    MaDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung INT NOT NULL FOREIGN KEY REFERENCES dbo.NguoiDung(MaNguoiDung),
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18,2) NOT NULL,
    TenNguoiNhan NVARCHAR(100) NOT NULL,
    SoDienThoaiNhan NVARCHAR(20) NOT NULL,
    DiaChiGiao NVARCHAR(250) NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL
);
GO
CREATE TABLE dbo.ChiTietDonHang (
    MaChiTietDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaDonHang INT NOT NULL FOREIGN KEY REFERENCES dbo.DonHang(MaDonHang) ON DELETE CASCADE,
    MaSanPham INT NOT NULL FOREIGN KEY REFERENCES dbo.SanPham(MaSanPham),
    KichCo NVARCHAR(10) NOT NULL,
    Duong NVARCHAR(50) NULL,
    Da NVARCHAR(50) NULL,
    SoLuong INT NOT NULL,
    GiaBan DECIMAL(18,2) NOT NULL
);
GO
CREATE TABLE dbo.ToppingDonHang (
    MaToppingDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaChiTietDonHang INT NOT NULL FOREIGN KEY REFERENCES dbo.ChiTietDonHang(MaChiTietDonHang) ON DELETE CASCADE,
    MaTopping INT NOT NULL FOREIGN KEY REFERENCES dbo.SanPham(MaSanPham),
    GiaTopping DECIMAL(18,2) NOT NULL
);
GO
INSERT INTO dbo.NguoiDung (TenDangNhap, MatKhau, HoTen, Email, SoDienThoai, DiaChi, VaiTro) VALUES
('admin', 'admin123', N'Quản trị viên', 'admin@watermilktea.com', '0987654321', N'126 Nguyễn Thiện Thành, Phường Hòa Thuận, tỉnh Vĩnh Long', 'Admin'),
('customer', 'customer123', N'Lâm Thị Thu Thủy', 'customer@gmail.com', '0389331308', N'Phước Vĩnh Tây, Tây Ninh', 'Customer');
INSERT INTO dbo.SanPham (TenSanPham, LoaiSanPham, Gia, DuongDanAnh, MoTa, ConHoatDong) VALUES
(N'Trà sữa truyền thống', 'TraSua', 30000.00, 'Images/classic_milk_tea.png', N'Trà sữa truyền thống thơm ngon đậm vị trà', 1),
(N'Trà sữa Matcha', 'TraSua', 35000.00, 'Images/matcha_milk_tea.png', N'Hương vị trà xanh Matcha Nhật Bản thơm bùi', 1),
(N'Trà sữa Khoai môn', 'TraSua', 35000.00, 'Images/taro_milk_tea.png', N'Trà sữa khoai môn ngọt bùi quyến rũ', 1),
(N'Trà sữa Dâu tây', 'TraSua', 38000.00, 'Images/strawberry_milk_tea.png', N'Hương dâu tây ngọt ngào mát lạnh', 1),
(N'Trân châu đen', 'Topping', 5000.00, 'Images/black_pearls.png', N'Trân châu đen dẻo ngọt truyền thống', 1),
(N'Trân châu trắng', 'Topping', 7000.00, 'Images/white_pearls.png', N'Trân châu trắng giòn dai sần sật', 1),
(N'Pudding trứng', 'Topping', 8000.00, 'Images/egg_pudding.png', N'Pudding trứng thơm mềm, béo ngậy', 1),
(N'Thạch phô mai', 'Topping', 10000.00, 'Images/cheese_jelly.png', N'Thạch phô mai thơm ngon béo bùi', 1),
(N'Sinh tố Bơ', 'SinhTo', 40000.00, 'Images/avocado_smoothie.png', N'Sinh tố bơ sáp béo ngậy mát lạnh cho ngày hè', 1),
(N'Sinh tố Xoài', 'SinhTo', 38000.00, 'Images/mango_smoothie.png', N'Sinh tố xoài chín cát thơm ngọt tự nhiên', 1),
(N'Sinh tố Dâu tây', 'SinhTo', 42000.00, 'Images/strawberry_smoothie.png', N'Sinh tố dâu tây tươi đỏ mọng chua ngọt sảng khoái', 1),
(N'Nước cam ép', 'NuocTraiCay', 30000.00, 'Images/orange_juice.png', N'Nước cam vắt nguyên chất giàu Vitamin C tươi ngon', 1),
(N'Nước ép Dưa hấu', 'NuocTraiCay', 32000.00, 'Images/watermelon_juice.png', N'Nước ép dưa hấu đỏ tươi thanh mát giải nhiệt', 1),
(N'Nước chanh leo', 'NuocTraiCay', 28000.00, 'Images/passion_fruit_juice.png', N'Nước chanh leo chua ngọt thơm nồng nàn', 1);
GO

CREATE TABLE dbo.Banner (
    MaBanner INT IDENTITY(1,1) PRIMARY KEY,
    TieuDe NVARCHAR(150) NULL,
    MoTa NVARCHAR(250) NULL,
    DuongDanAnh NVARCHAR(250) NOT NULL,
    LienKet NVARCHAR(250) NULL,
    ThuTu INT DEFAULT 0,
    ConHoatDong BIT DEFAULT 1
);
GO

INSERT INTO dbo.Banner (TieuDe, MoTa, DuongDanAnh, LienKet, ThuTu, ConHoatDong) VALUES
(N'Hương vị ngọt ngào ✨', N'Trà sữa truyền thống ngọt ngào và Matcha đậm vị Nhật Bản.', 'Images/banner1.png', '#giohang', 1, 1),
(N'Mùa dâu ngọt ngào 🍓', N'Trà sữa Dâu tây & Khoai môn thơm ngon mát lạnh cho ngày hè.', 'Images/banner2.png', '#giohang', 2, 1);
GO

