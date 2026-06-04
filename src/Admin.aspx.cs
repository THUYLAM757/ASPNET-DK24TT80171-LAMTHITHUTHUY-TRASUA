using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WaterMilkTea
{
    public partial class Admin : Page
    {
        
        protected global::System.Web.UI.WebControls.Panel pnlAdminMessage;
        protected global::System.Web.UI.WebControls.LinkButton btnTabMenu;
        protected global::System.Web.UI.WebControls.LinkButton btnTabOrders;
        protected global::System.Web.UI.WebControls.LinkButton btnTabBanners;
        protected global::System.Web.UI.WebControls.MultiView mvAdmin;
        protected global::System.Web.UI.WebControls.View vMenuManagement;
        protected global::System.Web.UI.WebControls.Literal litFormTitle;
        protected global::System.Web.UI.WebControls.HiddenField hdSelectedProductID;
        protected global::System.Web.UI.WebControls.TextBox txtProdName;
        protected global::System.Web.UI.WebControls.DropDownList ddlProdCategory;
        protected global::System.Web.UI.WebControls.TextBox txtProdPrice;
        protected global::System.Web.UI.WebControls.TextBox txtProdImagePath;
        protected global::System.Web.UI.WebControls.FileUpload fuProdImage;
        protected global::System.Web.UI.WebControls.TextBox txtProdDesc;
        protected global::System.Web.UI.WebControls.CheckBox chkProdActive;
        protected global::System.Web.UI.WebControls.Button btnSaveProduct;
        protected global::System.Web.UI.WebControls.Button btnCancelEdit;
        protected global::System.Web.UI.WebControls.GridView gvProducts;
        protected global::System.Web.UI.WebControls.View vOrderManagement;
        protected global::System.Web.UI.WebControls.GridView gvOrders;
        protected global::System.Web.UI.WebControls.Panel pnlOrderDetails;
        protected global::System.Web.UI.WebControls.Literal litDetailOrderID;
        protected global::System.Web.UI.WebControls.Literal litDetailCustName;
        protected global::System.Web.UI.WebControls.Literal litDetailPhone;
        protected global::System.Web.UI.WebControls.Literal litDetailAddress;
        protected global::System.Web.UI.WebControls.Repeater rptOrderDetailItems;
        protected global::System.Web.UI.WebControls.Literal litDetailTotal;


        protected global::System.Web.UI.WebControls.View vBannerManagement;
        protected global::System.Web.UI.WebControls.Literal litBannerFormTitle;
        protected global::System.Web.UI.WebControls.HiddenField hdSelectedBannerID;
        protected global::System.Web.UI.WebControls.TextBox txtBannerTitle;
        protected global::System.Web.UI.WebControls.TextBox txtBannerDesc;
        protected global::System.Web.UI.WebControls.TextBox txtBannerLink;
        protected global::System.Web.UI.WebControls.TextBox txtBannerOrder;
        protected global::System.Web.UI.WebControls.TextBox txtBannerImagePath;
        protected global::System.Web.UI.WebControls.FileUpload fuBannerImage;
        protected global::System.Web.UI.WebControls.CheckBox chkBannerActive;
        protected global::System.Web.UI.WebControls.Button btnSaveBanner;
        protected global::System.Web.UI.WebControls.Button btnCancelBannerEdit;
        protected global::System.Web.UI.WebControls.GridView gvBanners;


        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                Response.Redirect("Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProducts();
                LoadOrders();
                LoadBanners();
            }
        }

        #region Navigation Tabs
        protected void btnTabMenu_Click(object sender, EventArgs e)
        {
            mvAdmin.SetActiveView(vMenuManagement);
            btnTabMenu.CssClass = "tab-link active";
            btnTabOrders.CssClass = "tab-link";
            btnTabBanners.CssClass = "tab-link";
            ClearMessages();
        }

        protected void btnTabOrders_Click(object sender, EventArgs e)
        {
            mvAdmin.SetActiveView(vOrderManagement);
            btnTabMenu.CssClass = "tab-link";
            btnTabOrders.CssClass = "tab-link active";
            btnTabBanners.CssClass = "tab-link";
            ClearMessages();
        }

        protected void btnTabBanners_Click(object sender, EventArgs e)
        {
            mvAdmin.SetActiveView(vBannerManagement);
            btnTabMenu.CssClass = "tab-link";
            btnTabOrders.CssClass = "tab-link";
            btnTabBanners.CssClass = "tab-link active";
            ClearMessages();
            LoadBanners();
        }


        private void ClearMessages()
        {
            pnlAdminMessage.Visible = false;
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            pnlAdminMessage.Visible = true;
            pnlAdminMessage.CssClass = isSuccess ? "alert alert-success" : "alert alert-danger";
            pnlAdminMessage.Controls.Clear();
            pnlAdminMessage.Controls.Add(new Literal { Text = msg });
        }
        #endregion

        #region Product Management (Menu)
        private void LoadProducts()
        {
            try
            {
                string query = "SELECT MaSanPham, TenSanPham, LoaiSanPham, Gia, DuongDanAnh, MoTa, ConHoatDong FROM SanPham ORDER BY LoaiSanPham, TenSanPham";
                DataTable dt = DatabaseHelper.ExecuteDataTable(query);
                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
            catch (Exception ex)
            {
                ShowMessage("Lỗi tải thực đơn: " + ex.Message, false);
            }
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            ClearMessages();

            string name = txtProdName.Text.Trim();
            string category = ddlProdCategory.SelectedValue;
            string priceText = txtProdPrice.Text.Trim();
            string imgPath = txtProdImagePath.Text.Trim();
            string desc = txtProdDesc.Text.Trim();
            bool isActive = chkProdActive.Checked;


            if (fuProdImage.HasFile)
            {
                try
                {
                    string fileExtension = System.IO.Path.GetExtension(fuProdImage.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };
                    bool isAllowed = false;
                    foreach (string ext in allowedExtensions)
                    {
                        if (fileExtension == ext)
                        {
                            isAllowed = true;
                            break;
                        }
                    }

                    if (!isAllowed)
                    {
                        ShowMessage("Định dạng file không hợp lệ! Chỉ cho phép tải lên file ảnh (.jpg, .jpeg, .png, .gif, .webp)", false);
                        return;
                    }


                    string fileName = Guid.NewGuid().ToString() + fileExtension;
                    

                    string saveDir = Server.MapPath("~/Images/");
                    
                    if (!System.IO.Directory.Exists(saveDir))
                    {
                        System.IO.Directory.CreateDirectory(saveDir);
                    }
                    
                    string savePath = System.IO.Path.Combine(saveDir, fileName);
                    fuProdImage.SaveAs(savePath);


                    imgPath = "Images/" + fileName;
                }
                catch (Exception ex)
                {
                    ShowMessage("Lỗi tải lên hình ảnh: " + ex.Message, false);
                    return;
                }
            }

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(priceText) || string.IsNullOrEmpty(imgPath))
            {
                ShowMessage("Vui lòng điền đầy đủ các trường bắt buộc (*)", false);
                return;
            }

            decimal price = 0;
            if (!decimal.TryParse(priceText, out price) || price < 0)
            {
                ShowMessage("Giá sản phẩm phải là một số hợp lệ lớn hơn hoặc bằng 0!", false);
                return;
            }

            try
            {
                if (string.IsNullOrEmpty(hdSelectedProductID.Value))
                {
                    
                    string insertQuery = @"
                        INSERT INTO SanPham (TenSanPham, LoaiSanPham, Gia, DuongDanAnh, MoTa, ConHoatDong)
                        VALUES (@Name, @Category, @Price, @ImagePath, @Desc, @IsActive)";
                    
                    SqlParameter[] pars = {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Category", category),
                        new SqlParameter("@Price", price),
                        new SqlParameter("@ImagePath", imgPath),
                        new SqlParameter("@Desc", (object)desc ?? DBNull.Value),
                        new SqlParameter("@IsActive", isActive)
                    };

                    DatabaseHelper.ExecuteNonQuery(insertQuery, pars);
                    ShowMessage("Thêm sản phẩm '" + name + "' thành công!", true);
                }
                else
                {
                    
                    int productId = Convert.ToInt32(hdSelectedProductID.Value);
                    string updateQuery = @"
                        UPDATE SanPham 
                        SET TenSanPham = @Name, LoaiSanPham = @Category, Gia = @Price, 
                            DuongDanAnh = @ImagePath, MoTa = @Desc, ConHoatDong = @IsActive
                        WHERE MaSanPham = @ProductID";

                    SqlParameter[] pars = {
                        new SqlParameter("@ProductID", productId),
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Category", category),
                        new SqlParameter("@Price", price),
                        new SqlParameter("@ImagePath", imgPath),
                        new SqlParameter("@Desc", (object)desc ?? DBNull.Value),
                        new SqlParameter("@IsActive", isActive)
                    };

                    DatabaseHelper.ExecuteNonQuery(updateQuery, pars);
                    ShowMessage("Cập nhật sản phẩm thành công!", true);
                    ResetForm();
                }

                LoadProducts();
            }
            catch (Exception ex)
            {
                ShowMessage("Lỗi lưu sản phẩm: " + ex.Message, false);
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hdSelectedProductID.Value = "";
            txtProdName.Text = "";
            txtProdPrice.Text = "";
            txtProdImagePath.Text = "";
            txtProdDesc.Text = "";
            chkProdActive.Checked = true;
            ddlProdCategory.SelectedIndex = 0;
            
            litFormTitle.Text = "Thêm Sản Phẩm Mới";
            btnCancelEdit.Visible = false;
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditProduct")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    string query = "SELECT MaSanPham, TenSanPham, LoaiSanPham, Gia, DuongDanAnh, MoTa, ConHoatDong FROM SanPham WHERE MaSanPham = @ProductID";
                    SqlParameter[] pars = { new SqlParameter("@ProductID", productId) };
                    DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);

                    if (dt.Rows.Count > 0)
                    {
                        DataRow row = dt.Rows[0];
                        hdSelectedProductID.Value = row["MaSanPham"].ToString();
                        txtProdName.Text = row["TenSanPham"].ToString();
                        ddlProdCategory.SelectedValue = row["LoaiSanPham"].ToString();
                        txtProdPrice.Text = Convert.ToDecimal(row["Gia"]).ToString("F0");
                        txtProdImagePath.Text = row["DuongDanAnh"].ToString();
                        txtProdDesc.Text = row["MoTa"].ToString();
                        chkProdActive.Checked = Convert.ToBoolean(row["ConHoatDong"]);

                        litFormTitle.Text = "Sửa Sản Phẩm #" + productId;
                        btnCancelEdit.Visible = true;
                        ClearMessages();
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Lỗi tải dữ liệu sửa sản phẩm: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "DeleteProduct")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    
                    string deleteQuery = "DELETE FROM SanPham WHERE MaSanPham = @ProductID";
                    SqlParameter[] pars = { new SqlParameter("@ProductID", productId) };
                    DatabaseHelper.ExecuteNonQuery(deleteQuery, pars);
                    
                    ShowMessage("Đã xóa sản phẩm thành công khỏi hệ thống!", true);
                }
                catch (SqlException ex)
                {
                    
                    if (ex.Number == 547) 
                    {
                        string softDeleteQuery = "UPDATE SanPham SET ConHoatDong = 0 WHERE MaSanPham = @ProductID";
                        SqlParameter[] pars = { new SqlParameter("@ProductID", productId) };
                        DatabaseHelper.ExecuteNonQuery(softDeleteQuery, pars);

                        ShowMessage("Sản phẩm này đã từng được đặt mua. Hệ thống đã chuyển trạng thái sản phẩm sang <b>Ngừng bán</b> thay vì xóa hoàn toàn.", true);
                    }
                    else
                    {
                        ShowMessage("Lỗi xóa sản phẩm: " + ex.Message, false);
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Lỗi xóa sản phẩm: " + ex.Message, false);
                }

                LoadProducts();
                ResetForm();
            }
        }
        #endregion

        #region Order Management
        private void LoadOrders()
        {
            try
            {
                string query = "SELECT MaDonHang, TenNguoiNhan, SoDienThoaiNhan, NgayDat, TongTien, TrangThai FROM DonHang ORDER BY NgayDat DESC";
                DataTable dt = DatabaseHelper.ExecuteDataTable(query);
                gvOrders.DataSource = dt;
                gvOrders.DataBind();
            }
            catch (Exception ex)
            {
                ShowMessage("Lỗi tải danh sách hóa đơn: " + ex.Message, false);
            }
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                ShowOrderDetails(orderId);
            }
            else if (e.CommandName == "ApproveOrder")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                UpdateOrderStatus(orderId, "DaDuyet");
            }
            else if (e.CommandName == "CompleteOrder")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                UpdateOrderStatus(orderId, "HoanThanh");
            }
            else if (e.CommandName == "CancelOrder")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                UpdateOrderStatus(orderId, "DaHuy");
            }
        }

        private void UpdateOrderStatus(int orderId, string newStatus)
        {
            try
            {
                string query = "UPDATE DonHang SET TrangThai = @Status WHERE MaDonHang = @OrderID";
                SqlParameter[] pars = {
                    new SqlParameter("@Status", newStatus),
                    new SqlParameter("@OrderID", orderId)
                };
                DatabaseHelper.ExecuteNonQuery(query, pars);
                
                string statusText = GetStatusText(newStatus);
                ShowMessage("Đã cập nhật trạng thái đơn hàng #" + orderId + " thành: <b>" + statusText + "</b>", true);
                
                LoadOrders();

                
                if (pnlOrderDetails.Visible && litDetailOrderID.Text == orderId.ToString())
                {
                    ShowOrderDetails(orderId);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Lỗi cập nhật trạng thái hóa đơn: " + ex.Message, false);
            }
        }

        private void ShowOrderDetails(int orderId)
        {
            try
            {
                string query = "SELECT MaDonHang, TenNguoiNhan, SoDienThoaiNhan, DiaChiGiao, TongTien FROM DonHang WHERE MaDonHang = @OrderID";
                SqlParameter[] pars = { new SqlParameter("@OrderID", orderId) };
                DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    litDetailOrderID.Text = row["MaDonHang"].ToString();
                    litDetailCustName.Text = row["TenNguoiNhan"].ToString();
                    litDetailPhone.Text = row["SoDienThoaiNhan"].ToString();
                    litDetailAddress.Text = row["DiaChiGiao"].ToString();
                    litDetailTotal.Text = string.Format("{0:N0}đ", Convert.ToDecimal(row["TongTien"]));

                    
                    string itemsQuery = @"
                        SELECT ctdh.MaChiTietDonHang, ctdh.KichCo, ctdh.Duong, ctdh.Da, ctdh.SoLuong, ctdh.GiaBan, sp.TenSanPham 
                        FROM ChiTietDonHang ctdh 
                        INNER JOIN SanPham sp ON ctdh.MaSanPham = sp.MaSanPham 
                        WHERE ctdh.MaDonHang = @OrderID";
                    
                    SqlParameter[] itemPars = { new SqlParameter("@OrderID", orderId) };
                    DataTable dtItems = DatabaseHelper.ExecuteDataTable(itemsQuery, itemPars);

                    rptOrderDetailItems.DataSource = dtItems;
                    rptOrderDetailItems.DataBind();

                    pnlOrderDetails.Visible = true;
                    ClearMessages();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Lỗi hiển thị chi tiết hóa đơn: " + ex.Message, false);
            }
        }

        #region Grid Helpers
        public string GetCategoryDisplayName(string category)
        {
            switch (category)
            {
                case "TraSua": return "Trà sữa";
                case "Topping": return "Topping";
                case "SinhTo": return "Sinh tố";
                case "NuocTraiCay": return "Nước trái cây";
                default: return category;
            }
        }

        public string GetStatusText(string status)
        {
            switch (status)
            {
                case "ChoDuyet": return "Chờ Duyệt";
                case "DaDuyet": return "Đã Duyệt";
                case "HoanThanh": return "Đã Hoàn Thành";
                case "DaHuy": return "Đã Hủy";
                default: return status;
            }
        }

        public string GetStatusBadgeClass(string status)
        {
            switch (status)
            {
                case "ChoDuyet": return "badge-pending";
                case "DaDuyet": return "badge-approved";
                case "HoanThanh": return "badge-completed";
                case "DaHuy": return "badge-cancelled";
                default: return "";
            }
        }

        public string GetDetailToppingsText(object detailId)
        {
            try
            {
                int detId = Convert.ToInt32(detailId);
                string query = @"
                    SELECT sp.TenSanPham 
                    FROM ToppingDonHang tdh 
                    INNER JOIN SanPham sp ON tdh.MaTopping = sp.MaSanPham 
                    WHERE tdh.MaChiTietDonHang = @DetailID";
                
                SqlParameter[] pars = { new SqlParameter("@DetailID", detId) };
                DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);

                if (dt.Rows.Count == 0) return "Không có";

                List<string> list = new List<string>();
                foreach (DataRow r in dt.Rows)
                {
                    list.Add(r["TenSanPham"].ToString());
                }
                return string.Join(", ", list);
            }
            catch
            {
                return "Lỗi";
            }
        }

        public decimal GetDetailToppingsTotal(object detailId, object quantity)
        {
            try
            {
                int detId = Convert.ToInt32(detailId);
                int qty = Convert.ToInt32(quantity);

                string query = "SELECT SUM(GiaTopping) FROM ToppingDonHang WHERE MaChiTietDonHang = @DetailID";
                SqlParameter[] pars = { new SqlParameter("@DetailID", detId) };
                object result = DatabaseHelper.ExecuteScalar(query, pars);

                if (result == null || result == DBNull.Value) return 0;
                
                decimal toppingsUnitTotal = Convert.ToDecimal(result);
                return toppingsUnitTotal * qty;
            }
            catch
            {
                return 0;
            }
        }
        #region Banner Management
        private void LoadBanners()
        {
            try
            {
                string query = "SELECT MaBanner, TieuDe, DuongDanAnh, ThuTu, ConHoatDong FROM Banner ORDER BY ThuTu ASC";
                DataTable dt = DatabaseHelper.ExecuteDataTable(query);
                gvBanners.DataSource = dt;
                gvBanners.DataBind();
            }
            catch (Exception ex)
            {
                ShowMessage("Lỗi tải danh sách banner: " + ex.Message, false);
            }
        }

        protected void btnSaveBanner_Click(object sender, EventArgs e)
        {
            ClearMessages();

            string title = txtBannerTitle.Text.Trim();
            string desc = txtBannerDesc.Text.Trim();
            string link = txtBannerLink.Text.Trim();
            string orderText = txtBannerOrder.Text.Trim();
            string imgPath = txtBannerImagePath.Text.Trim();
            bool isActive = chkBannerActive.Checked;

            if (fuBannerImage.HasFile)
            {
                try
                {
                    string fileExtension = System.IO.Path.GetExtension(fuBannerImage.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };
                    bool isAllowed = false;
                    foreach (string ext in allowedExtensions)
                    {
                        if (fileExtension == ext)
                        {
                            isAllowed = true;
                            break;
                        }
                    }

                    if (!isAllowed)
                    {
                        ShowMessage("Định dạng file ảnh không hợp lệ! Chỉ cho phép tải lên file (.jpg, .jpeg, .png, .gif, .webp)", false);
                        return;
                    }

                    string fileName = Guid.NewGuid().ToString() + fileExtension;
                    string saveDir = Server.MapPath("~/Images/");
                    
                    if (!System.IO.Directory.Exists(saveDir))
                    {
                        System.IO.Directory.CreateDirectory(saveDir);
                    }
                    
                    string savePath = System.IO.Path.Combine(saveDir, fileName);
                    fuBannerImage.SaveAs(savePath);

                    imgPath = "Images/" + fileName;
                }
                catch (Exception ex)
                {
                    ShowMessage("Lỗi tải lên hình ảnh banner: " + ex.Message, false);
                    return;
                }
            }

            if (string.IsNullOrEmpty(imgPath))
            {
                ShowMessage("Vui lòng tải lên hình ảnh banner hoặc nhập đường dẫn ảnh!", false);
                return;
            }

            int order = 0;
            int.TryParse(orderText, out order);

            try
            {
                if (string.IsNullOrEmpty(hdSelectedBannerID.Value))
                {

                    string insertQuery = @"
                        INSERT INTO Banner (TieuDe, MoTa, DuongDanAnh, LienKet, ThuTu, ConHoatDong)
                        VALUES (@Title, @Desc, @ImagePath, @Link, @Order, @IsActive)";

                    SqlParameter[] pars = {
                        new SqlParameter("@Title", (object)title ?? DBNull.Value),
                        new SqlParameter("@Desc", (object)desc ?? DBNull.Value),
                        new SqlParameter("@ImagePath", imgPath),
                        new SqlParameter("@Link", (object)link ?? DBNull.Value),
                        new SqlParameter("@Order", order),
                        new SqlParameter("@IsActive", isActive)
                    };

                    DatabaseHelper.ExecuteNonQuery(insertQuery, pars);
                    ShowMessage("Thêm banner mới thành công!", true);
                }
                else
                {

                    int bannerId = Convert.ToInt32(hdSelectedBannerID.Value);
                    string updateQuery = @"
                        UPDATE Banner 
                        SET TieuDe = @Title, MoTa = @Desc, DuongDanAnh = @ImagePath, 
                            LienKet = @Link, ThuTu = @Order, ConHoatDong = @IsActive
                        WHERE MaBanner = @BannerID";

                    SqlParameter[] pars = {
                        new SqlParameter("@BannerID", bannerId),
                        new SqlParameter("@Title", (object)title ?? DBNull.Value),
                        new SqlParameter("@Desc", (object)desc ?? DBNull.Value),
                        new SqlParameter("@ImagePath", imgPath),
                        new SqlParameter("@Link", (object)link ?? DBNull.Value),
                        new SqlParameter("@Order", order),
                        new SqlParameter("@IsActive", isActive)
                    };

                    DatabaseHelper.ExecuteNonQuery(updateQuery, pars);
                    ShowMessage("Cập nhật thông tin banner thành công!", true);
                    ResetBannerForm();
                }

                LoadBanners();
            }
            catch (Exception ex)
            {
                ShowMessage("Lỗi lưu banner: " + ex.Message, false);
            }
        }

        protected void btnCancelBannerEdit_Click(object sender, EventArgs e)
        {
            ResetBannerForm();
        }

        private void ResetBannerForm()
        {
            hdSelectedBannerID.Value = "";
            txtBannerTitle.Text = "";
            txtBannerDesc.Text = "";
            txtBannerLink.Text = "";
            txtBannerOrder.Text = "0";
            txtBannerImagePath.Text = "";
            chkBannerActive.Checked = true;

            litBannerFormTitle.Text = "Thêm Banner Mới";
            btnCancelBannerEdit.Visible = false;
        }

        protected void gvBanners_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditBanner")
            {
                int bannerId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    string query = "SELECT MaBanner, TieuDe, MoTa, DuongDanAnh, LienKet, ThuTu, ConHoatDong FROM Banner WHERE MaBanner = @BannerID";
                    SqlParameter[] pars = { new SqlParameter("@BannerID", bannerId) };
                    DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);

                    if (dt.Rows.Count > 0)
                    {
                        DataRow row = dt.Rows[0];
                        hdSelectedBannerID.Value = row["MaBanner"].ToString();
                        txtBannerTitle.Text = row["TieuDe"].ToString();
                        txtBannerDesc.Text = row["MoTa"].ToString();
                        txtBannerLink.Text = row["LienKet"].ToString();
                        txtBannerOrder.Text = row["ThuTu"].ToString();
                        txtBannerImagePath.Text = row["DuongDanAnh"].ToString();
                        chkBannerActive.Checked = Convert.ToBoolean(row["ConHoatDong"]);

                        litBannerFormTitle.Text = "Sửa Banner #" + bannerId;
                        btnCancelBannerEdit.Visible = true;
                        ClearMessages();
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Lỗi tải dữ liệu sửa banner: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "DeleteBanner")
            {
                int bannerId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    string deleteQuery = "DELETE FROM Banner WHERE MaBanner = @BannerID";
                    SqlParameter[] pars = { new SqlParameter("@BannerID", bannerId) };
                    DatabaseHelper.ExecuteNonQuery(deleteQuery, pars);

                    ShowMessage("Đã xóa banner thành công!", true);
                }
                catch (Exception ex)
                {
                    ShowMessage("Lỗi xóa banner: " + ex.Message, false);
                }

                LoadBanners();
                ResetBannerForm();
            }
        }
        #endregion
        #endregion
        #endregion
    }

}
