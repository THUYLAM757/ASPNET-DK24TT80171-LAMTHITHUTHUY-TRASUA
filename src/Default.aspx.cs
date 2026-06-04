using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WaterMilkTea
{
    public partial class Default : Page
    {
        
        protected global::System.Web.UI.WebControls.Panel pnlGlobalMessage;
        protected global::System.Web.UI.WebControls.Repeater rptBanners;
        protected global::System.Web.UI.WebControls.Panel pnlDefaultBanner;
        protected global::System.Web.UI.WebControls.TextBox txtSearch;
        protected global::System.Web.UI.WebControls.Button btnSearch;
        protected global::System.Web.UI.WebControls.Button btnReset;
        protected global::System.Web.UI.WebControls.Repeater rptProducts;
        protected global::System.Web.UI.WebControls.Panel pnlNoProducts;
        protected global::System.Web.UI.WebControls.LinkButton btnClearCart;
        protected global::System.Web.UI.WebControls.Repeater rptCart;
        protected global::System.Web.UI.WebControls.Panel pnlEmptyCart;
        protected global::System.Web.UI.WebControls.Panel pnlCheckout;
        protected global::System.Web.UI.WebControls.Literal litCartTotal;
        protected global::System.Web.UI.WebControls.Panel pnlCheckoutWarning;
        protected global::System.Web.UI.WebControls.Literal litCheckoutWarning;
        protected global::System.Web.UI.WebControls.TextBox txtCustomerName;
        protected global::System.Web.UI.WebControls.TextBox txtPhone;
        protected global::System.Web.UI.WebControls.TextBox txtAddress;
        protected global::System.Web.UI.WebControls.Button btnSubmitOrder;
        protected global::System.Web.UI.WebControls.Panel pnlModal;
        protected global::System.Web.UI.WebControls.LinkButton btnCloseModal;
        protected global::System.Web.UI.HtmlControls.HtmlImage imgModalProduct;
        protected global::System.Web.UI.WebControls.Literal litModalName;
        protected global::System.Web.UI.WebControls.Literal litModalPrice;
        protected global::System.Web.UI.WebControls.RadioButtonList rblSizes;
        protected global::System.Web.UI.WebControls.RadioButtonList rblSugar;
        protected global::System.Web.UI.WebControls.RadioButtonList rblIce;
        protected global::System.Web.UI.WebControls.CheckBoxList cblToppings;
        protected global::System.Web.UI.WebControls.TextBox txtQuantity;
        protected global::System.Web.UI.WebControls.Button btnAddToCart;
        protected global::System.Web.UI.WebControls.LinkButton btnCatAll;
        protected global::System.Web.UI.WebControls.LinkButton btnCatTraSua;
        protected global::System.Web.UI.WebControls.LinkButton btnCatSinhTo;
        protected global::System.Web.UI.WebControls.LinkButton btnCatNuocTraiCay;


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["SelectedCategory"] = "All";
                LoadBanners();
                LoadProducts();
                PrefillUserInfo();
                BindCart();
            }
            UpdateTabStyles();
        }


        private void LoadBanners()
        {
            try
            {
                string query = "SELECT TieuDe, MoTa, DuongDanAnh, LienKet FROM Banner WHERE ConHoatDong = 1 ORDER BY ThuTu ASC";
                DataTable dt = DatabaseHelper.ExecuteDataTable(query);
                if (dt.Rows.Count > 0)
                {
                    rptBanners.DataSource = dt;
                    rptBanners.DataBind();
                    rptBanners.Visible = true;
                    pnlDefaultBanner.Visible = false;
                }
                else
                {
                    rptBanners.Visible = false;
                    pnlDefaultBanner.Visible = true;
                }
            }
            catch (Exception ex)
            {
                rptBanners.Visible = false;
                pnlDefaultBanner.Visible = true;
                ShowGlobalMessage("Lỗi tải banner quảng cáo: " + ex.Message, false);
            }
        }



        private void LoadProducts()
        {
            try
            {
                string category = ViewState["SelectedCategory"]?.ToString() ?? "All";
                string query = "SELECT MaSanPham, TenSanPham, Gia, DuongDanAnh, MoTa FROM SanPham WHERE ConHoatDong = 1";
                List<SqlParameter> parsList = new List<SqlParameter>();

                if (category == "All")
                {
                    query += " AND LoaiSanPham IN ('TraSua', 'SinhTo', 'NuocTraiCay')";
                }
                else
                {
                    query += " AND LoaiSanPham = @Category";
                    parsList.Add(new SqlParameter("@Category", category));
                }

                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    query += " AND TenSanPham LIKE @Search";
                    parsList.Add(new SqlParameter("@Search", "%" + txtSearch.Text.Trim() + "%"));
                }

                SqlParameter[] pars = parsList.Count > 0 ? parsList.ToArray() : null;
                DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);
                rptProducts.DataSource = dt;
                rptProducts.DataBind();

                pnlNoProducts.Visible = (dt.Rows.Count == 0);
            }
            catch (Exception ex)
            {
                ShowGlobalMessage("Lỗi tải danh mục sản phẩm: " + ex.Message, false);
            }
        }

        private void PrefillUserInfo()
        {
            if (Session["UserID"] != null)
            {
                txtCustomerName.Text = Session["UserFullName"]?.ToString();
                
                
                try
                {
                    string query = "SELECT SoDienThoai, DiaChi FROM NguoiDung WHERE MaNguoiDung = @UserID";
                    SqlParameter[] pars = {
                        new SqlParameter("@UserID", Session["UserID"])
                    };
                    DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);
                    if (dt.Rows.Count > 0)
                    {
                        txtPhone.Text = dt.Rows[0]["SoDienThoai"].ToString();
                        txtAddress.Text = dt.Rows[0]["DiaChi"].ToString();
                    }
                }
                catch
                {
                    
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ViewState["SelectedCategory"] = "All";
            UpdateTabStyles();
            LoadProducts();
        }

        protected void btnCategory_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string category = btn.CommandArgument;
            ViewState["SelectedCategory"] = category;
            UpdateTabStyles();
            LoadProducts();
        }

        private void UpdateTabStyles()
        {
            string category = ViewState["SelectedCategory"]?.ToString() ?? "All";
            btnCatAll.CssClass = "category-tab" + (category == "All" ? " active" : "");
            btnCatTraSua.CssClass = "category-tab" + (category == "TraSua" ? " active" : "");
            btnCatSinhTo.CssClass = "category-tab" + (category == "SinhTo" ? " active" : "");
            btnCatNuocTraiCay.CssClass = "category-tab" + (category == "NuocTraiCay" ? " active" : "");
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectDrink")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                ShowSelectionModal(productId);
            }
        }

        private void ShowSelectionModal(int productId)
        {
            try
            {
                string query = "SELECT MaSanPham, TenSanPham, Gia, DuongDanAnh FROM SanPham WHERE MaSanPham = @ProductID";
                SqlParameter[] pars = {
                    new SqlParameter("@ProductID", productId)
                };
                DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    ViewState["SelectedProductID"] = productId;
                    
                    litModalName.Text = row["TenSanPham"].ToString();
                    decimal price = Convert.ToDecimal(row["Gia"]);
                    litModalPrice.Text = string.Format("{0:N0}đ", price);
                    imgModalProduct.Src = row["DuongDanAnh"].ToString();
                    imgModalProduct.Alt = row["TenSanPham"].ToString();

                    
                    string toppingQuery = "SELECT MaSanPham, TenSanPham, Gia, TenSanPham + ' (+' + FORMAT(Gia, 'N0') + N'đ)' AS TenSanPhamFormat FROM SanPham WHERE LoaiSanPham = 'Topping' AND ConHoatDong = 1";
                    DataTable dtToppings = DatabaseHelper.ExecuteDataTable(toppingQuery);
                    cblToppings.DataSource = dtToppings;
                    cblToppings.DataBind();

                    rblSizes.SelectedValue = "S";
                    rblSugar.SelectedValue = "100% Đường";
                    rblIce.SelectedValue = "100% Đá";
                    txtQuantity.Text = "1";

                    pnlModal.Visible = true;
                    pnlModal.CssClass = "modal-backdrop show";
                }
            }
            catch (Exception ex)
            {
                ShowGlobalMessage("Lỗi mở hộp chọn món: " + ex.Message, false);
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlModal.Visible = false;
            pnlModal.CssClass = "modal-backdrop";
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (ViewState["SelectedProductID"] == null) return;
            
            int productId = (int)ViewState["SelectedProductID"];
            string size = rblSizes.SelectedValue;
            
            int quantity = 1;
            if (!int.TryParse(txtQuantity.Text, out quantity) || quantity < 1)
            {
                
                quantity = 1;
            }

            try
            {
                
                string query = "SELECT TenSanPham, Gia FROM SanPham WHERE MaSanPham = @ProductID";
                SqlParameter[] pars = {
                    new SqlParameter("@ProductID", productId)
                };
                DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);

                if (dt.Rows.Count > 0)
                {
                    string drinkName = dt.Rows[0]["TenSanPham"].ToString();
                    decimal basePrice = Convert.ToDecimal(dt.Rows[0]["Gia"]);
                    decimal sizePrice = 0;
                    
                    if (size == "M") sizePrice = 5000;
                    else if (size == "L") sizePrice = 10000;

                    var cartItem = new CartItem
                    {
                        ProductId = productId,
                        Name = drinkName,
                        Size = size,
                        Sugar = rblSugar.SelectedValue,
                        Ice = rblIce.SelectedValue,
                        Quantity = quantity,
                        BasePrice = basePrice,
                        SizePrice = sizePrice
                    };

                    
                    foreach (ListItem item in cblToppings.Items)
                    {
                        if (item.Selected)
                        {
                            int toppingId = Convert.ToInt32(item.Value);
                            
                            string topQuery = "SELECT TenSanPham, Gia FROM SanPham WHERE MaSanPham = @ToppingID";
                            SqlParameter[] topPars = {
                                new SqlParameter("@ToppingID", toppingId)
                            };
                            DataTable dtTop = DatabaseHelper.ExecuteDataTable(topQuery, topPars);
                            if (dtTop.Rows.Count > 0)
                            {
                                cartItem.Toppings.Add(new ToppingItem
                                {
                                    ToppingId = toppingId,
                                    Name = dtTop.Rows[0]["TenSanPham"].ToString(),
                                    Price = Convert.ToDecimal(dtTop.Rows[0]["Gia"])
                                });
                            }
                        }
                    }

                    
                    var cart = Session["Cart"] as List<CartItem>;
                    if (cart == null)
                    {
                        cart = new List<CartItem>();
                    }
                    cart.Add(cartItem);
                    Session["Cart"] = cart;

                    
                    pnlModal.Visible = false;
                    pnlModal.CssClass = "modal-backdrop";
                    
                    BindCart();
                    
                    
                    var master = Master as Site;
                    master?.UpdateCartCount();

                    ShowGlobalMessage("Đã thêm " + quantity + " ly " + drinkName + " vào giỏ hàng!", true);
                }
            }
            catch (Exception ex)
            {
                ShowGlobalMessage("Lỗi thêm vào giỏ hàng: " + ex.Message, false);
            }
        }

        private void BindCart()
        {
            var cart = Session["Cart"] as List<CartItem>;
            if (cart == null || cart.Count == 0)
            {
                rptCart.Visible = false;
                pnlEmptyCart.Visible = true;
                pnlCheckout.Visible = false;
                btnClearCart.Visible = false;
            }
            else
            {
                rptCart.DataSource = cart;
                rptCart.DataBind();
                
                rptCart.Visible = true;
                pnlEmptyCart.Visible = false;
                pnlCheckout.Visible = true;
                btnClearCart.Visible = true;

                
                decimal total = 0;
                foreach (var item in cart)
                {
                    total += item.TotalPrice;
                }
                litCartTotal.Text = string.Format("{0:N0}đ", total);
            }
        }

        public string GetToppingsText(object dataItem)
        {
            var item = dataItem as CartItem;
            if (item == null || item.Toppings.Count == 0)
            {
                return "Không kèm topping";
            }

            var names = new List<string>();
            foreach (var top in item.Toppings)
            {
                names.Add(top.Name + " (+" + string.Format("{0:N0}đ", top.Price) + ")");
            }
            return "Topping: " + string.Join(", ", names);
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemoveItem")
            {
                string guid = e.CommandArgument.ToString();
                var cart = Session["Cart"] as List<CartItem>;
                if (cart != null)
                {
                    cart.RemoveAll(x => x.Guid == guid);
                    Session["Cart"] = cart;
                    
                    BindCart();
                    
                    var master = Master as Site;
                    master?.UpdateCartCount();
                }
            }
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            Session["Cart"] = new List<CartItem>();
            BindCart();
            var master = Master as Site;
            master?.UpdateCartCount();
        }

        protected void btnSubmitOrder_Click(object sender, EventArgs e)
        {
            pnlCheckoutWarning.Visible = false;

            
            if (Session["UserID"] == null)
            {
                pnlCheckoutWarning.Visible = true;
                litCheckoutWarning.Text = "Bạn cần <a href='Auth.aspx?action=login' style='color:#DC2626; font-weight:700;'>Đăng Nhập</a> hoặc <a href='Auth.aspx?action=register' style='color:#DC2626; font-weight:700;'>Đăng Ký</a> để hoàn tất đặt hàng!";
                return;
            }

            string custName = txtCustomerName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();

            if (string.IsNullOrEmpty(custName) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(address))
            {
                pnlCheckoutWarning.Visible = true;
                litCheckoutWarning.Text = "Vui lòng điền đầy đủ thông tin giao hàng bắt buộc!";
                return;
            }

            var cart = Session["Cart"] as List<CartItem>;
            if (cart == null || cart.Count == 0)
            {
                pnlCheckoutWarning.Visible = true;
                litCheckoutWarning.Text = "Giỏ hàng trống, không thể thực hiện đặt hàng!";
                return;
            }

            
            decimal totalAmount = 0;
            foreach (var item in cart)
            {
                totalAmount += item.TotalPrice;
            }

            SqlConnection conn = null;
            SqlTransaction transaction = null;

            try
            {
                conn = DatabaseHelper.GetConnection();
                conn.Open();
                transaction = conn.BeginTransaction();

                
                string insertOrderQuery = @"
                    INSERT INTO DonHang (MaNguoiDung, NgayDat, TongTien, TenNguoiNhan, SoDienThoaiNhan, DiaChiGiao, TrangThai)
                    VALUES (@UserID, GETDATE(), @TotalAmount, @CustomerName, @Phone, @Address, 'ChoDuyet');
                    SELECT SCOPE_IDENTITY();";

                int orderId = 0;
                using (SqlCommand cmd = new SqlCommand(insertOrderQuery, conn, transaction))
                {
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmd.Parameters.AddWithValue("@CustomerName", custName);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Address", address);
                    
                    orderId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                
                foreach (var item in cart)
                {
                     string insertDetailQuery = @"
                         INSERT INTO ChiTietDonHang (MaDonHang, MaSanPham, KichCo, Duong, Da, SoLuong, GiaBan)
                         VALUES (@OrderID, @ProductID, @Size, @Sugar, @Ice, @Quantity, @Price);
                         SELECT SCOPE_IDENTITY();";
 
                     int detailId = 0;
                     using (SqlCommand cmd = new SqlCommand(insertDetailQuery, conn, transaction))
                     {
                         cmd.Parameters.AddWithValue("@OrderID", orderId);
                         cmd.Parameters.AddWithValue("@ProductID", item.ProductId);
                         cmd.Parameters.AddWithValue("@Size", item.Size);
                         cmd.Parameters.AddWithValue("@Sugar", (object)item.Sugar ?? DBNull.Value);
                         cmd.Parameters.AddWithValue("@Ice", (object)item.Ice ?? DBNull.Value);
                         cmd.Parameters.AddWithValue("@Quantity", item.Quantity);
                         cmd.Parameters.AddWithValue("@Price", item.BasePrice + item.SizePrice);

                        detailId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    
                    foreach (var top in item.Toppings)
                    {
                        string insertToppingQuery = @"
                            INSERT INTO ToppingDonHang (MaChiTietDonHang, MaTopping, GiaTopping)
                            VALUES (@DetailID, @ToppingID, @ToppingPrice);";

                        using (SqlCommand cmd = new SqlCommand(insertToppingQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@DetailID", detailId);
                            cmd.Parameters.AddWithValue("@ToppingID", top.ToppingId);
                            cmd.Parameters.AddWithValue("@ToppingPrice", top.Price);

                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                
                transaction.Commit();

                
                Session["Cart"] = new List<CartItem>();
                BindCart();
                
                var master = Master as Site;
                master?.UpdateCartCount();

                ShowGlobalMessage("🎉 Đặt hàng thành công! Đơn hàng của bạn đang ở trạng thái <b>Chờ Duyệt</b>. Cảm ơn bạn đã ủng hộ WATERMILKTEA!", true);
            }
            catch (Exception ex)
            {
                if (transaction != null)
                {
                    try { transaction.Rollback(); } catch { }
                }
                ShowGlobalMessage("Có lỗi xảy ra khi tạo đơn hàng: " + ex.Message, false);
            }
            finally
            {
                if (conn != null) conn.Close();
            }
        }

        private void ShowGlobalMessage(string message, bool isSuccess)
        {
            pnlGlobalMessage.Visible = true;
            pnlGlobalMessage.CssClass = isSuccess ? "alert alert-success" : "alert alert-danger";
            pnlGlobalMessage.Controls.Clear();
            pnlGlobalMessage.Controls.Add(new Literal { Text = message });
        }
    }
}
