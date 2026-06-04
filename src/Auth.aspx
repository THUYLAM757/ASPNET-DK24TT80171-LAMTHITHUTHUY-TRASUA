<%@ Page Title="Đăng nhập / Đăng ký - WATERMILKTEA" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Auth.aspx.cs" Inherits="WaterMilkTea.Auth" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .auth-container {
            max-width: 450px;
            margin: 3rem auto;
        }
        .auth-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .auth-header h2 {
            font-size: 2.2rem;
            color: var(--pastel-purple-dark);
            margin-bottom: 0.5rem;
        }
        .auth-header p {
            color: var(--text-muted);
            font-size: 1rem;
        }
        .auth-toggle-link {
            text-align: center;
            margin-top: 1.5rem;
            font-weight: 500;
        }
        .auth-toggle-link a {
            color: var(--pastel-pink-dark);
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
        }
        .auth-toggle-link a:hover {
            color: #E11D48;
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <div class="card">
            <asp:MultiView ID="mvAuth" runat="server" ActiveViewIndex="0">
                
                
                <asp:View ID="vLogin" runat="server">
                    <div class="auth-header">
                        <h2>Xin chào! 👋</h2>
                        <p>Đăng nhập vào tài khoản WATERMILKTEA của bạn</p>
                    </div>
                    
                    <asp:Panel ID="pnlLoginError" runat="server" CssClass="alert alert-danger" Visible="false">
                        <asp:Literal ID="litLoginError" runat="server"></asp:Literal>
                    </asp:Panel>
                    
                    <asp:Panel ID="pnlLoginSuccess" runat="server" CssClass="alert alert-success" Visible="false">
                        <asp:Literal ID="litLoginSuccess" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtLoginUsername.ClientID %>">Tên đăng nhập</label>
                        <asp:TextBox ID="txtLoginUsername" runat="server" CssClass="form-control" placeholder="Nhập tên đăng nhập..."></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtLoginPassword.ClientID %>">Mật khẩu</label>
                        <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập mật khẩu..."></asp:TextBox>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Đăng Nhập" CssClass="btn btn-primary" Width="100%" OnClick="btnLogin_Click" />

                    <div class="auth-toggle-link">
                        Chưa có tài khoản? 
                        <asp:LinkButton ID="lnkGoToRegister" runat="server" OnClick="lnkGoToRegister_Click" CausesValidation="false">Đăng ký ngay</asp:LinkButton>
                    </div>
                </asp:View>

                
                <asp:View ID="vRegister" runat="server">
                    <div class="auth-header">
                        <h2>Tạo tài khoản ✨</h2>
                        <p>Đăng ký để đặt hàng nhanh chóng và nhận ưu đãi</p>
                    </div>

                    <asp:Panel ID="pnlRegError" runat="server" CssClass="alert alert-danger" Visible="false">
                        <asp:Literal ID="litRegError" runat="server"></asp:Literal>
                    </asp:Panel>
                    
                    <asp:Panel ID="pnlRegSuccess" runat="server" CssClass="alert alert-success" Visible="false">
                        <asp:Literal ID="litRegSuccess" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtRegUsername.ClientID %>">Tên đăng nhập <span style="color:red">*</span></label>
                        <asp:TextBox ID="txtRegUsername" runat="server" CssClass="form-control" placeholder="Tên đăng nhập viết liền..."></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtRegPassword.ClientID %>">Mật khẩu <span style="color:red">*</span></label>
                        <asp:TextBox ID="txtRegPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Mật khẩu ít nhất 6 ký tự..."></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtRegFullName.ClientID %>">Họ và tên <span style="color:red">*</span></label>
                        <asp:TextBox ID="txtRegFullName" runat="server" CssClass="form-control" placeholder="Nhập họ tên đầy đủ..."></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtRegPhone.ClientID %>">Số điện thoại <span style="color:red">*</span></label>
                        <asp:TextBox ID="txtRegPhone" runat="server" CssClass="form-control" placeholder="Số điện thoại liên lạc..."></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtRegEmail.ClientID %>">Email</label>
                        <asp:TextBox ID="txtRegEmail" runat="server" CssClass="form-control" placeholder="Nhập địa chỉ email (tùy chọn)..."></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtRegAddress.ClientID %>">Địa chỉ giao hàng</label>
                        <asp:TextBox ID="txtRegAddress" runat="server" CssClass="form-control" placeholder="Địa chỉ giao trà sữa mặc định..."></asp:TextBox>
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Đăng Ký Tài Khoản" CssClass="btn btn-purple" Width="100%" OnClick="btnRegister_Click" />

                    <div class="auth-toggle-link">
                        Đã có tài khoản? 
                        <asp:LinkButton ID="lnkGoToLogin" runat="server" OnClick="lnkGoToLogin_Click" CausesValidation="false">Đăng nhập</asp:LinkButton>
                    </div>
                </asp:View>

            </asp:MultiView>
        </div>
    </div>
</asp:Content>
