using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WaterMilkTea
{
    public partial class Auth : Page
    {
        
        protected global::System.Web.UI.WebControls.MultiView mvAuth;
        protected global::System.Web.UI.WebControls.View vLogin;
        protected global::System.Web.UI.WebControls.Panel pnlLoginError;
        protected global::System.Web.UI.WebControls.Literal litLoginError;
        protected global::System.Web.UI.WebControls.Panel pnlLoginSuccess;
        protected global::System.Web.UI.WebControls.Literal litLoginSuccess;
        protected global::System.Web.UI.WebControls.TextBox txtLoginUsername;
        protected global::System.Web.UI.WebControls.TextBox txtLoginPassword;
        protected global::System.Web.UI.WebControls.Button btnLogin;
        protected global::System.Web.UI.WebControls.LinkButton lnkGoToRegister;
        protected global::System.Web.UI.WebControls.View vRegister;
        protected global::System.Web.UI.WebControls.Panel pnlRegError;
        protected global::System.Web.UI.WebControls.Literal litRegError;
        protected global::System.Web.UI.WebControls.Panel pnlRegSuccess;
        protected global::System.Web.UI.WebControls.Literal litRegSuccess;
        protected global::System.Web.UI.WebControls.TextBox txtRegUsername;
        protected global::System.Web.UI.WebControls.TextBox txtRegPassword;
        protected global::System.Web.UI.WebControls.TextBox txtRegFullName;
        protected global::System.Web.UI.WebControls.TextBox txtRegPhone;
        protected global::System.Web.UI.WebControls.TextBox txtRegEmail;
        protected global::System.Web.UI.WebControls.TextBox txtRegAddress;
        protected global::System.Web.UI.WebControls.Button btnRegister;
        protected global::System.Web.UI.WebControls.LinkButton lnkGoToLogin;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                string action = Request.QueryString["action"];
                if (action == "register")
                {
                    mvAuth.SetActiveView(vRegister);
                }
                else
                {
                    mvAuth.SetActiveView(vLogin);
                }
            }
        }

        protected void lnkGoToRegister_Click(object sender, EventArgs e)
        {
            ClearAlerts();
            mvAuth.SetActiveView(vRegister);
        }

        protected void lnkGoToLogin_Click(object sender, EventArgs e)
        {
            ClearAlerts();
            mvAuth.SetActiveView(vLogin);
        }

        private void ClearAlerts()
        {
            pnlLoginError.Visible = false;
            pnlLoginSuccess.Visible = false;
            pnlRegError.Visible = false;
            pnlRegSuccess.Visible = false;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            ClearAlerts();
            string username = txtLoginUsername.Text.Trim();
            string password = txtLoginPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                pnlLoginError.Visible = true;
                litLoginError.Text = "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!";
                return;
            }

            try
            {
                string query = "SELECT MaNguoiDung, TenDangNhap, MatKhau, HoTen, VaiTro FROM NguoiDung WHERE TenDangNhap = @Username";
                SqlParameter[] pars = {
                    new SqlParameter("@Username", username)
                };

                DataTable dt = DatabaseHelper.ExecuteDataTable(query, pars);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    string dbPassword = row["MatKhau"].ToString();

                    if (dbPassword == password) 
                    {
                        
                        Session["UserID"] = Convert.ToInt32(row["MaNguoiDung"]);
                        Session["Username"] = row["TenDangNhap"].ToString();
                        Session["UserFullName"] = row["HoTen"].ToString();
                        Session["UserRole"] = row["VaiTro"].ToString();

                        
                        var master = Master as Site;
                        master?.UpdateAuthStatus();

                        
                        if (Session["UserRole"].ToString() == "Admin")
                        {
                            Response.Redirect("Admin.aspx");
                        }
                        else
                        {
                            Response.Redirect("Default.aspx");
                        }
                    }
                    else
                    {
                        pnlLoginError.Visible = true;
                        litLoginError.Text = "Mật khẩu không chính xác!";
                    }
                }
                else
                {
                    pnlLoginError.Visible = true;
                    litLoginError.Text = "Tên đăng nhập không tồn tại!";
                }
            }
            catch (Exception ex)
            {
                pnlLoginError.Visible = true;
                litLoginError.Text = "Lỗi kết nối cơ sở dữ liệu: " + ex.Message;
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            ClearAlerts();
            string username = txtRegUsername.Text.Trim();
            string password = txtRegPassword.Text.Trim();
            string fullName = txtRegFullName.Text.Trim();
            string phone = txtRegPhone.Text.Trim();
            string email = txtRegEmail.Text.Trim();
            string address = txtRegAddress.Text.Trim();

            
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(phone))
            {
                pnlRegError.Visible = true;
                litRegError.Text = "Vui lòng nhập đầy đủ các thông tin bắt buộc (*)!";
                return;
            }

            if (password.Length < 6)
            {
                pnlRegError.Visible = true;
                litRegError.Text = "Mật khẩu phải chứa ít nhất 6 ký tự!";
                return;
            }

            try
            {
                
                string checkQuery = "SELECT COUNT(*) FROM NguoiDung WHERE TenDangNhap = @Username";
                SqlParameter[] checkPars = {
                    new SqlParameter("@Username", username)
                };

                int count = (int)DatabaseHelper.ExecuteScalar(checkQuery, checkPars);
                if (count > 0)
                {
                    pnlRegError.Visible = true;
                    litRegError.Text = "Tên đăng nhập này đã có người sử dụng. Vui lòng chọn tên khác!";
                    return;
                }

                
                string insertQuery = @"
                    INSERT INTO NguoiDung (TenDangNhap, MatKhau, HoTen, Email, SoDienThoai, DiaChi, VaiTro) 
                    VALUES (@Username, @Password, @FullName, @Email, @Phone, @Address, 'Customer');
                    SELECT SCOPE_IDENTITY();";

                SqlParameter[] insertPars = {
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Password", password),
                    new SqlParameter("@FullName", fullName),
                    new SqlParameter("@Email", (object)email ?? DBNull.Value),
                    new SqlParameter("@Phone", phone),
                    new SqlParameter("@Address", (object)address ?? DBNull.Value)
                };

                object newId = DatabaseHelper.ExecuteScalar(insertQuery, insertPars);
                if (newId != null && newId != DBNull.Value)
                {
                    
                    Session["UserID"] = Convert.ToInt32(newId);
                    Session["Username"] = username;
                    Session["UserFullName"] = fullName;
                    Session["UserRole"] = "Customer";

                    
                    Response.Redirect("Default.aspx");
                }
                else
                {
                    pnlRegError.Visible = true;
                    litRegError.Text = "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại!";
                }
            }
            catch (Exception ex)
            {
                pnlRegError.Visible = true;
                litRegError.Text = "Lỗi hệ thống: " + ex.Message;
            }
        }
    }
}
