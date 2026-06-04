using System;
using System.Collections.Generic;
using System.Web.UI;

namespace WaterMilkTea
{
    public partial class Site : MasterPage
    {
        
        protected global::System.Web.UI.WebControls.PlaceHolder phCustomerMenu;
        protected global::System.Web.UI.WebControls.PlaceHolder phAdminMenu;
        protected global::System.Web.UI.WebControls.Literal litCartCount;
        protected global::System.Web.UI.WebControls.MultiView mvAuthStatus;
        protected global::System.Web.UI.WebControls.View vGuest;
        protected global::System.Web.UI.WebControls.View vLoggedIn;
        protected global::System.Web.UI.WebControls.Literal litUserFullName;
        protected global::System.Web.UI.WebControls.Literal litUserRole;
        protected global::System.Web.UI.WebControls.LinkButton lnkLogout;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UpdateAuthStatus();
            }
            UpdateCartCount();
        }

        public void UpdateAuthStatus()
        {
            if (Session["UserID"] != null)
            {
                mvAuthStatus.SetActiveView(vLoggedIn);
                litUserFullName.Text = Session["UserFullName"]?.ToString();
                
                string role = Session["UserRole"]?.ToString();
                litUserRole.Text = role == "Admin" ? "Quản trị" : "Khách hàng";

                if (role == "Admin")
                {
                    phAdminMenu.Visible = true;
                    phCustomerMenu.Visible = false;
                }
                else
                {
                    phAdminMenu.Visible = false;
                    phCustomerMenu.Visible = true;
                }
            }
            else
            {
                mvAuthStatus.SetActiveView(vGuest);
                phAdminMenu.Visible = false;
                phCustomerMenu.Visible = false;
            }
        }

        public void UpdateCartCount()
        {
            var cart = Session["Cart"] as List<CartItem>;
            int count = 0;
            if (cart != null)
            {
                foreach (var item in cart)
                {
                    count += item.Quantity;
                }
            }
            litCartCount.Text = count.ToString();
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Default.aspx");
        }
    }
}
