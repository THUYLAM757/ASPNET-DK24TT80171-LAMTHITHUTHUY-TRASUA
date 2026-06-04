<%@ Page Title="Quản trị - WATERMILKTEA" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="WaterMilkTea.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-layout {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.2rem;
        }
        .order-detail-card {
            background-color: var(--pastel-blue-light);
            border: 1px solid var(--pastel-blue);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-top: 1.5rem;
        }
        .badge-status {
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .badge-pending { background-color: #FEF3C7; color: #D97706; }
        .badge-approved { background-color: #DBEAFE; color: #1D4ED8; }
        .badge-completed { background-color: #D1FAE5; color: #047857; }
        .badge-cancelled { background-color: #FEE2E2; color: #B91C1C; }
    </style>
    <script type="text/javascript">
        function previewImage(input) {
            var preview = document.getElementById('imgFormPreview');
            var placeholder = document.getElementById('lblFormPreviewPlaceholder');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    placeholder.style.display = 'none';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        function previewPath(val) {
            var preview = document.getElementById('imgFormPreview');
            var placeholder = document.getElementById('lblFormPreviewPlaceholder');
            if (val && /\.(jpg|jpeg|png|gif|webp)$/i.test(val)) {
                preview.src = val;
                preview.style.display = 'block';
                placeholder.style.display = 'none';
            } else if (!val) {
                preview.src = '';
                preview.style.display = 'none';
                placeholder.style.display = 'block';
            }
        }

        function previewBannerImage(input) {
            var preview = document.getElementById('imgBannerFormPreview');
            var placeholder = document.getElementById('lblBannerFormPreviewPlaceholder');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    placeholder.style.display = 'none';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        function previewBannerPath(val) {
            var preview = document.getElementById('imgBannerFormPreview');
            var placeholder = document.getElementById('lblBannerFormPreviewPlaceholder');
            if (val && /\.(jpg|jpeg|png|gif|webp)$/i.test(val)) {
                preview.src = val;
                preview.style.display = 'block';
                placeholder.style.display = 'none';
            } else if (!val) {
                preview.src = '';
                preview.style.display = 'none';
                placeholder.style.display = 'block';
            }
        }


        // Initialize preview on page load
        window.addEventListener('DOMContentLoaded', function() {
            var txtPath = document.getElementById('<%= txtProdImagePath.ClientID %>');
            if (txtPath && txtPath.value) {
                previewPath(txtPath.value);
            }
            var txtBannerPath = document.getElementById('<%= txtBannerImagePath.ClientID %>');
            if (txtBannerPath && txtBannerPath.value) {
                previewBannerPath(txtBannerPath.value);
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-layout">
        
        <div class="hero-banner" style="padding: 1.5rem; margin-bottom: 0;">
            <h1 style="font-size: 2rem;">🎛️ Bảng Điều Khiển Quản Trị</h1>
            <p>Quản lý thực đơn sản phẩm và hóa đơn đặt hàng của WATERMILKTEA</p>
        </div>

        <asp:Panel ID="pnlAdminMessage" runat="server" CssClass="alert" Visible="false"></asp:Panel>

        
        <div class="tabs">
            <asp:LinkButton ID="btnTabMenu" runat="server" CssClass="tab-link active" OnClick="btnTabMenu_Click" CausesValidation="false">🍔 Quản lý Thực Đơn</asp:LinkButton>
            <asp:LinkButton ID="btnTabOrders" runat="server" CssClass="tab-link" OnClick="btnTabOrders_Click" CausesValidation="false">📋 Quản lý Hóa Đơn</asp:LinkButton>
            <asp:LinkButton ID="btnTabBanners" runat="server" CssClass="tab-link" OnClick="btnTabBanners_Click" CausesValidation="false">🖼️ Quản lý Banner</asp:LinkButton>
        </div>


        <asp:MultiView ID="mvAdmin" runat="server" ActiveViewIndex="0">
            
            
            <asp:View ID="vMenuManagement" runat="server">
                <div class="shop-layout">
                    
                    
                    <div style="flex: 1; min-width: 300px;">
                        <div class="card">
                            <h3 style="color: var(--pastel-purple-dark); margin-bottom: 1.2rem; font-weight: 600;">
                                <asp:Literal ID="litFormTitle" runat="server">Thêm Sản Phẩm Mới</asp:Literal>
                            </h3>
                            
                            <asp:HiddenField ID="hdSelectedProductID" runat="server" />

                            <div class="form-group">
                                <label class="form-label">Tên sản phẩm <span style="color:red">*</span></label>
                                <asp:TextBox ID="txtProdName" runat="server" CssClass="form-control" placeholder="Ví dụ: Trà sữa Bạc hà..."></asp:TextBox>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Phân loại</label>
                                    <asp:DropDownList ID="ddlProdCategory" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="TraSua">Trà sữa</asp:ListItem>
                                        <asp:ListItem Value="Topping">Topping</asp:ListItem>
                                        <asp:ListItem Value="SinhTo">Sinh tố</asp:ListItem>
                                        <asp:ListItem Value="NuocTraiCay">Nước trái cây</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Đơn giá (Size S) <span style="color:red">*</span></label>
                                    <asp:TextBox ID="txtProdPrice" runat="server" CssClass="form-control" TextMode="Number" placeholder="đ"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Hình ảnh sản phẩm <span style="color:red">*</span></label>
                                <div style="display: flex; gap: 1rem; align-items: flex-start; margin-bottom: 0.8rem;">
                                    <div style="flex: 1; display: flex; flex-direction: column; gap: 0.8rem;">
                                        <div>
                                            <label class="form-label" style="font-size: 0.85rem; font-weight: normal; margin-bottom: 0.25rem;">Tải ảnh lên từ thiết bị:</label>
                                            <asp:FileUpload ID="fuProdImage" runat="server" CssClass="form-control" style="padding: 0.35rem 0.5rem;" onchange="previewImage(this);" />
                                        </div>
                                        <div style="text-align: center; color: var(--text-muted); font-size: 0.85rem; font-weight: 600; margin: 0.2rem 0;">— HOẶC —</div>
                                        <div>
                                            <label class="form-label" style="font-size: 0.85rem; font-weight: normal; margin-bottom: 0.25rem;">Nhập đường dẫn ảnh trực tiếp:</label>
                                            <asp:TextBox ID="txtProdImagePath" runat="server" CssClass="form-control" placeholder="Images/ten_file.png..." onkeyup="previewPath(this.value);" onchange="previewPath(this.value);"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div style="width: 120px; height: 120px; border: 2px dashed var(--pastel-blue); border-radius: var(--border-radius-sm); display: flex; align-items: center; justify-content: center; overflow: hidden; background-color: var(--white); flex-shrink: 0;">
                                        <img id="imgFormPreview" src="" alt="Xem trước" style="max-width: 100%; max-height: 100%; object-fit: cover; display: none;" />
                                        <span id="lblFormPreviewPlaceholder" style="font-size: 0.75rem; color: var(--text-muted); text-align: center; padding: 0.5rem;">Chưa có ảnh</span>
                                    </div>
                                </div>
                                <span style="font-size: 0.8rem; color: var(--text-muted); display: block; line-height: 1.4;">
                                    Định dạng tệp ảnh hợp lệ: <b>.png, .jpg, .jpeg, .gif, .webp</b>.<br />
                                    Hoặc sử dụng ảnh có sẵn: `Images/classic_milk_tea.png`, `Images/matcha_milk_tea.png`...
                                </span>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Mô tả sản phẩm</label>
                                <asp:TextBox ID="txtProdDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Mô tả hương vị trà sữa hoặc topping..."></asp:TextBox>
                            </div>

                            <div class="form-group" style="display: flex; align-items: center; gap: 0.5rem;">
                                <asp:CheckBox ID="chkProdActive" runat="server" Checked="true" />
                                <label class="form-label" for="<%= chkProdActive.ClientID %>" style="margin-bottom: 0; cursor: pointer;">Đang kinh doanh</label>
                            </div>

                            <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                                <asp:Button ID="btnSaveProduct" runat="server" Text="Lưu sản phẩm" CssClass="btn btn-purple" Style="flex:1;" OnClick="btnSaveProduct_Click" />
                                <asp:Button ID="btnCancelEdit" runat="server" Text="Hủy" CssClass="btn btn-secondary" Visible="false" OnClick="btnCancelEdit_Click" CausesValidation="false" />
                            </div>
                        </div>
                    </div>

                    
                    <div style="flex: 2; min-width: 350px;">
                        <div class="card" style="padding: 1.5rem;">
                            <h3 style="color: var(--pastel-purple-dark); margin-bottom: 1rem; font-weight: 600;">Danh sách thực đơn</h3>
                            
                            <div class="table-responsive">
                                <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
                                    CssClass="table-custom" GridLines="None" 
                                    OnRowCommand="gvProducts_RowCommand" DataKeyNames="MaSanPham">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Ảnh">
                                            <ItemTemplate>
                                                <img src='<%# Eval("DuongDanAnh") %>' alt='<%# Eval("TenSanPham") %>' style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px;" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="TenSanPham" HeaderText="Tên sản phẩm" />
                                        <asp:TemplateField HeaderText="Phân loại">
                                            <ItemTemplate>
                                                <%# GetCategoryDisplayName(Eval("LoaiSanPham").ToString()) %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Giá">
                                            <ItemTemplate>
                                                <%# string.Format("{0:N0}đ", Eval("Gia")) %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Trạng thái">
                                            <ItemTemplate>
                                                <span class='badge-status <%# Convert.ToBoolean(Eval("ConHoatDong")) ? "badge-completed" : "badge-cancelled" %>'>
                                                    <%# Convert.ToBoolean(Eval("ConHoatDong")) ? "Đang bán" : "Ngừng" %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Thao tác">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("MaSanPham") %>' CssClass="btn btn-secondary btn-sm" Style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Sửa</asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("MaSanPham") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');" Style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Xóa</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>

                </div>
            </asp:View>

            
            <asp:View ID="vOrderManagement" runat="server">
                <div class="card" style="padding: 1.5rem;">
                    <h3 style="color: var(--pastel-purple-dark); margin-bottom: 1rem; font-weight: 600;">Danh Sách Hóa Đơn</h3>
                    
                    <div class="table-responsive">
                        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
                            CssClass="table-custom" GridLines="None" 
                            OnRowCommand="gvOrders_RowCommand" DataKeyNames="MaDonHang">
                            <Columns>
                                <asp:BoundField DataField="MaDonHang" HeaderText="Mã ĐH" />
                                <asp:BoundField DataField="TenNguoiNhan" HeaderText="Khách hàng" />
                                <asp:BoundField DataField="SoDienThoaiNhan" HeaderText="SĐT" />
                                <asp:TemplateField HeaderText="Ngày đặt">
                                    <ItemTemplate>
                                        <%# string.Format("{0:dd/MM/yyyy HH:mm}", Eval("NgayDat")) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tổng tiền">
                                    <ItemTemplate>
                                        <b style="color:var(--pastel-pink-dark);"><%# string.Format("{0:N0}đ", Eval("TongTien")) %></b>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Trạng thái">
                                    <ItemTemplate>
                                        <span class='badge-status <%# GetStatusBadgeClass(Eval("TrangThai").ToString()) %>'>
                                            <%# GetStatusText(Eval("TrangThai").ToString()) %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Thao tác">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnViewDetails" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("MaDonHang") %>' CssClass="btn btn-secondary btn-sm" Style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Xem chi tiết</asp:LinkButton>
                                        <asp:LinkButton ID="btnApprove" runat="server" CommandName="ApproveOrder" CommandArgument='<%# Eval("MaDonHang") %>' CssClass="btn btn-purple btn-sm" Visible='<%# Eval("TrangThai").ToString() == "ChoDuyet" %>' Style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Duyệt</asp:LinkButton>
                                        <asp:LinkButton ID="btnComplete" runat="server" CommandName="CompleteOrder" CommandArgument='<%# Eval("MaDonHang") %>' CssClass="btn btn-secondary btn-sm" Visible='<%# Eval("TrangThai").ToString() == "DaDuyet" %>' Style="padding: 0.2rem 0.5rem; font-size: 0.8rem; background-color:#A7F3D0; color:#047857;">Hoàn thành</asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelOrder" CommandArgument='<%# Eval("MaDonHang") %>' CssClass="btn btn-danger btn-sm" Visible='<%# Eval("TrangThai").ToString() == "ChoDuyet" || Eval("TrangThai").ToString() == "DaDuyet" %>' Style="padding: 0.2rem 0.5rem; font-size: 0.8rem;" OnClientClick="return confirm('Hủy đơn hàng này?');">Hủy</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    
                    <asp:Panel ID="pnlOrderDetails" runat="server" Visible="false" CssClass="order-detail-card">
                        <h4 style="color: var(--pastel-purple-dark); margin-bottom: 0.8rem; border-bottom: 1px solid var(--pastel-blue); padding-bottom: 0.4rem; font-weight: 600;">
                            Chi Tiết Đơn Hàng #<asp:Literal ID="litDetailOrderID" runat="server"></asp:Literal>
                        </h4>
                        
                        <p style="margin-bottom: 0.5rem;"><b>Người nhận:</b> <asp:Literal ID="litDetailCustName" runat="server"></asp:Literal></p>
                        <p style="margin-bottom: 0.5rem;"><b>SĐT:</b> <asp:Literal ID="litDetailPhone" runat="server"></asp:Literal></p>
                        <p style="margin-bottom: 0.8rem;"><b>Địa chỉ giao:</b> <asp:Literal ID="litDetailAddress" runat="server"></asp:Literal></p>

                        <asp:Repeater ID="rptOrderDetailItems" runat="server">
                            <HeaderTemplate>
                                <table class="table-custom" style="background-color: var(--white); border-radius: var(--border-radius-sm);">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th>Kích cỡ</th>
                                            <th>Số lượng</th>
                                            <th>Toppings kèm theo</th>
                                            <th>Giá bán</th>
                                            <th>Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("TenSanPham") %></td>
                                    <td>
                                        Size <%# Eval("KichCo") %>
                                        <%# Eval("Duong") != null && Eval("Duong") != DBNull.Value && !string.IsNullOrEmpty(Eval("Duong").ToString()) ? "<br/><small style='color:var(--text-muted);'>Đường: " + Eval("Duong") + " | Đá: " + Eval("Da") + "</small>" : "" %>
                                    </td>
                                    <td><%# Eval("SoLuong") %></td>
                                    <td><%# GetDetailToppingsText(Eval("MaChiTietDonHang")) %></td>
                                    <td><%# string.Format("{0:N0}đ", Eval("GiaBan")) %></td>
                                    <td><b><%# string.Format("{0:N0}đ", Convert.ToDecimal(Eval("GiaBan")) * Convert.ToInt32(Eval("SoLuong")) + GetDetailToppingsTotal(Eval("MaChiTietDonHang"), Eval("SoLuong"))) %></b></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                    </tbody>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>

                        <div style="text-align: right; margin-top: 1rem; font-size: 1.15rem; font-weight: 700;">
                            Tổng thanh toán: <span style="color:var(--pastel-pink-dark);"><asp:Literal ID="litDetailTotal" runat="server"></asp:Literal></span>
                        </div>
                    </asp:Panel>
                </div>
            </asp:View>

            <asp:View ID="vBannerManagement" runat="server">
                <div class="shop-layout">
                    

                    <div style="flex: 1; min-width: 300px;">
                        <div class="card">
                            <h3 style="color: var(--pastel-purple-dark); margin-bottom: 1.2rem; font-weight: 600;">
                                <asp:Literal ID="litBannerFormTitle" runat="server">Thêm Banner Mới</asp:Literal>
                            </h3>
                            
                            <asp:HiddenField ID="hdSelectedBannerID" runat="server" />

                            <div class="form-group">
                                <label class="form-label">Tiêu đề Banner</label>
                                <asp:TextBox ID="txtBannerTitle" runat="server" CssClass="form-control" placeholder="Ví dụ: Hương vị ngọt ngào..."></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Mô tả chi tiết</label>
                                <asp:TextBox ID="txtBannerDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Nhập mô tả ngắn hiển thị trên banner..."></asp:TextBox>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Liên kết khi click</label>
                                    <asp:TextBox ID="txtBannerLink" runat="server" CssClass="form-control" placeholder="#giohang hoặc URL..."></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Thứ tự hiển thị <span style="color:red">*</span></label>
                                    <asp:TextBox ID="txtBannerOrder" runat="server" CssClass="form-control" TextMode="Number" Text="0" placeholder="Số nguyên (0, 1, 2...)"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Hình ảnh Banner <span style="color:red">*</span></label>
                                <div style="display: flex; gap: 1rem; align-items: flex-start; margin-bottom: 0.8rem;">
                                    <div style="flex: 1; display: flex; flex-direction: column; gap: 0.8rem;">
                                        <div>
                                            <label class="form-label" style="font-size: 0.85rem; font-weight: normal; margin-bottom: 0.25rem;">Tải ảnh lên từ thiết bị:</label>
                                            <asp:FileUpload ID="fuBannerImage" runat="server" CssClass="form-control" style="padding: 0.35rem 0.5rem;" onchange="previewBannerImage(this);" />
                                        </div>
                                        <div style="text-align: center; color: var(--text-muted); font-size: 0.85rem; font-weight: 600; margin: 0.2rem 0;">— HOẶC —</div>
                                        <div>
                                            <label class="form-label" style="font-size: 0.85rem; font-weight: normal; margin-bottom: 0.25rem;">Nhập đường dẫn ảnh trực tiếp:</label>
                                            <asp:TextBox ID="txtBannerImagePath" runat="server" CssClass="form-control" placeholder="Images/ten_file.png..." onkeyup="previewBannerPath(this.value);" onchange="previewBannerPath(this.value);"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div style="width: 120px; height: 80px; border: 2px dashed var(--pastel-blue); border-radius: var(--border-radius-sm); display: flex; align-items: center; justify-content: center; overflow: hidden; background-color: var(--white); flex-shrink: 0;">
                                        <img id="imgBannerFormPreview" src="" alt="Xem trước" style="max-width: 100%; max-height: 100%; object-fit: cover; display: none;" />
                                        <span id="lblBannerFormPreviewPlaceholder" style="font-size: 0.75rem; color: var(--text-muted); text-align: center; padding: 0.5rem;">Chưa có ảnh</span>
                                    </div>
                                </div>
                                <span style="font-size: 0.8rem; color: var(--text-muted); display: block; line-height: 1.4;">
                                    Định dạng hợp lệ: <b>.png, .jpg, .jpeg, .gif, .webp</b>.<br />
                                    Tỷ lệ ảnh banner khuyến nghị: <b>3:1</b> (ví dụ: 1200x400px).
                                </span>
                            </div>

                            <div class="form-group" style="display: flex; align-items: center; gap: 0.5rem;">
                                <asp:CheckBox ID="chkBannerActive" runat="server" Checked="true" />
                                <label class="form-label" for="<%= chkBannerActive.ClientID %>" style="margin-bottom: 0; cursor: pointer;">Đang hoạt động (Hiển thị ngoài trang chủ)</label>
                            </div>

                            <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                                <asp:Button ID="btnSaveBanner" runat="server" Text="Lưu banner" CssClass="btn btn-purple" Style="flex:1;" OnClick="btnSaveBanner_Click" />
                                <asp:Button ID="btnCancelBannerEdit" runat="server" Text="Hủy" CssClass="btn btn-secondary" Visible="false" OnClick="btnCancelBannerEdit_Click" CausesValidation="false" />
                            </div>
                        </div>
                    </div>


                    <div style="flex: 1.5; min-width: 350px;">
                        <div class="card" style="padding: 1.5rem;">
                            <h3 style="color: var(--pastel-purple-dark); margin-bottom: 1rem; font-weight: 600;">Danh sách Banner</h3>
                            
                            <div class="table-responsive">
                                <asp:GridView ID="gvBanners" runat="server" AutoGenerateColumns="False" 
                                    CssClass="table-custom" GridLines="None" 
                                    OnRowCommand="gvBanners_RowCommand" DataKeyNames="MaBanner">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Ảnh Banner">
                                            <ItemTemplate>
                                                <img src='<%# Eval("DuongDanAnh") %>' alt='<%# Eval("TieuDe") %>' style="width: 100px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid rgba(0,0,0,0.05);" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="TieuDe" HeaderText="Tiêu đề" />
                                        <asp:BoundField DataField="ThuTu" HeaderText="Thứ tự" ItemStyle-HorizontalAlign="Center" />
                                        <asp:TemplateField HeaderText="Trạng thái">
                                            <ItemTemplate>
                                                <span class='badge-status <%# Convert.ToBoolean(Eval("ConHoatDong")) ? "badge-completed" : "badge-cancelled" %>'>
                                                    <%# Convert.ToBoolean(Eval("ConHoatDong")) ? "Hoạt động" : "Ẩn" %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Thao tác">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditBanner" runat="server" CommandName="EditBanner" CommandArgument='<%# Eval("MaBanner") %>' CssClass="btn btn-secondary btn-sm" Style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Sửa</asp:LinkButton>
                                                <asp:LinkButton ID="btnDeleteBanner" runat="server" CommandName="DeleteBanner" CommandArgument='<%# Eval("MaBanner") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Bạn có chắc chắn muốn xóa banner này?');" Style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Xóa</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>

                </div>
            </asp:View>

        </asp:MultiView>

    </div>
</asp:Content>
