<%@ Page Title="Cửa hàng - WATERMILKTEA" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WaterMilkTea.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .shop-layout {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
        }
        .products-section {
            flex: 2;
            min-width: 300px;
        }
        .cart-section {
            flex: 1;
            min-width: 300px;
            position: sticky;
            top: 90px;
            align-self: flex-start;
        }
        .hero-banner {
            background: linear-gradient(135deg, rgba(214, 196, 240, 0.4) 0%, rgba(251, 207, 232, 0.4) 100%);
            border-radius: var(--border-radius);
            padding: 2.5rem;
            text-align: center;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.6);
        }
        .hero-banner h1 {
            font-size: 2.5rem;
            color: var(--pastel-purple-dark);
            margin-bottom: 0.5rem;
            font-weight: 700;
        }
        .hero-banner p {
            color: var(--text-muted);
            font-size: 1.1rem;
        }

        /* Dynamic Carousel Styles */
        .carousel-container {
            position: relative;
            width: 100%;
            height: 320px;
            border-radius: var(--border-radius);
            overflow: hidden;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
            border: 1px solid rgba(255, 255, 255, 0.6);
        }
        .carousel-slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 0.8s ease-in-out;
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1;
        }
        .carousel-slide.active {
            opacity: 1;
            z-index: 2;
        }
        .carousel-nav-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--pastel-purple-dark);
            cursor: pointer;
            z-index: 10;
            border: 1px solid rgba(255, 255, 255, 0.5);
            transition: var(--transition);
            user-select: none;
        }
        .carousel-nav-btn:hover {
            background: rgba(255, 255, 255, 0.8);
            transform: translateY(-50%) scale(1.05);
        }
        .carousel-nav-prev {
            left: 1.5rem;
        }
        .carousel-nav-next {
            right: 1.5rem;
        }
        .carousel-dots {
            position: absolute;
            bottom: 1rem;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 0.5rem;
            z-index: 10;
        }
        .carousel-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            cursor: pointer;
            transition: var(--transition);
            border: 1px solid rgba(0, 0, 0, 0.1);
        }
        .carousel-dot.active {
            background: var(--pastel-purple-dark);
            width: 24px;
            border-radius: 10px;
        }

        /* Marquee Bar Styles */
        .marquee-bar {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 38px;
            background: rgba(138, 100, 214, 0.85);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            color: #fff;
            display: flex;
            align-items: center;
            z-index: 15;
            overflow: hidden;
            font-size: 0.95rem;
            font-weight: 600;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
        }
        .marquee-content {
            display: inline-block;
            white-space: nowrap;
            padding-left: 100%;
        }
        .carousel-slide.active .marquee-content {
            animation-name: marquee-scroll;
            animation-duration: 14s; /* Fallback */
            animation-timing-function: linear;
            animation-iteration-count: infinite;
        }

        .carousel-container:hover .marquee-content {
            animation-play-state: paused;
        }

        @keyframes marquee-scroll {
            0% { transform: translate3d(0, 0, 0); }
            100% { transform: translate3d(-100%, 0, 0); }
        }

        .search-bar {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 1.5rem;
        }
        .product-card {
            background: var(--white);
            border-radius: var(--border-radius);
            border: 1px solid rgba(0, 0, 0, 0.05);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            display: flex;
            flex-direction: column;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        .product-image {
            width: 100%;
            height: 180px;
            object-fit: cover;
            background-color: var(--pastel-purple-light);
        }
        .product-info {
            padding: 1.2rem;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .product-name {
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: 0.4rem;
            color: var(--text-main);
        }
        .product-desc {
            font-size: 0.88rem;
            color: var(--text-muted);
            margin-bottom: 1rem;
            flex: 1;
            line-height: 1.3;
        }
        .product-price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
        }
        .product-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--pastel-pink-dark);
        }
        
        /* Cart Styles */
        .cart-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--pastel-purple-dark);
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid var(--pastel-purple-light);
            padding-bottom: 0.5rem;
        }
        .cart-item-row {
            display: flex;
            flex-direction: column;
            padding: 0.8rem 0;
            border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
        }
        .cart-item-header {
            display: flex;
            justify-content: space-between;
            font-weight: 600;
            font-size: 0.95rem;
        }
        .cart-item-details {
            font-size: 0.82rem;
            color: var(--text-muted);
            margin: 0.2rem 0;
        }
        .cart-item-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 0.3rem;
        }
        .cart-item-price {
            font-weight: 600;
            color: var(--pastel-pink-dark);
        }
        .cart-total-row {
            display: flex;
            justify-content: space-between;
            font-weight: 700;
            font-size: 1.2rem;
            margin: 1.5rem 0;
            color: var(--text-main);
        }

        /* Modal Styles inside Default */
        .modal-body {
            margin-top: 1rem;
        }
        .modal-product-header {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.2rem;
        }
        .modal-product-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: var(--border-radius-sm);
        }
        .modal-product-info h3 {
            font-size: 1.3rem;
            color: var(--pastel-purple-dark);
        }
        .modal-product-info p {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--pastel-pink-dark);
        }
        .modal-section-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
            border-bottom: 1px solid var(--pastel-purple-light);
            padding-bottom: 0.2rem;
            color: var(--text-main);
        }
        .option-group {
            margin-bottom: 1.2rem;
        }
        .cbl-toppings td {
            padding: 0.3rem 0;
            display: block;
        }
        .cbl-toppings label {
            margin-left: 0.5rem;
            font-size: 0.95rem;
            cursor: pointer;
        }
        .category-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }
        .category-tab {
            padding: 0.5rem 1.25rem;
            background: var(--pastel-purple-light);
            border: 1px solid rgba(138, 100, 214, 0.2);
            color: var(--text-main);
            font-weight: 600;
            font-size: 0.95rem;
            border-radius: 50px;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
        }
        .category-tab:hover {
            background: var(--pastel-purple);
            color: var(--pastel-purple-dark);
            transform: translateY(-1px);
        }
        .category-tab.active {
            background: linear-gradient(135deg, var(--pastel-purple-dark) 0%, #7C3AED 100%);
            color: var(--white);
            border-color: transparent;
            box-shadow: 0 4px 10px rgba(138, 100, 214, 0.25);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    
    <asp:Repeater ID="rptBanners" runat="server">
        <HeaderTemplate>
            <div class="carousel-container">
        </HeaderTemplate>
        <ItemTemplate>
            <a href="<%# Eval("LienKet") == null || string.IsNullOrEmpty(Eval("LienKet").ToString()) ? "#" : Eval("LienKet") %>" 
               class="carousel-slide <%# Container.ItemIndex == 0 ? "active" : "" %>" 
               style="background-image: url('<%# Eval("DuongDanAnh") %>'); display: block;">
                
                <div class="marquee-bar">
                    <div class="marquee-content">
                        <span class="marquee-text">⚡ <%# Eval("TieuDe") %><%# Eval("MoTa") == null || string.IsNullOrEmpty(Eval("MoTa").ToString()) ? "" : ": " + Eval("MoTa") %></span>
                    </div>
                </div>
            </a>
        </ItemTemplate>
        <FooterTemplate>
                <div class="carousel-nav-btn carousel-nav-prev">&#10094;</div>
                <div class="carousel-nav-btn carousel-nav-next">&#10095;</div>
                <div class="carousel-dots" id="carouselDots"></div>
            </div>
        </FooterTemplate>

    </asp:Repeater>
    
    <asp:Panel ID="pnlDefaultBanner" runat="server" CssClass="hero-banner" Visible="false">
        <h1>🍵 WATERMILKTEA ✨</h1>
        <p>Hương vị trà sữa ngọt ngào, nhiều loại topping thơm ngon cùng kích cỡ tùy chọn!</p>
    </asp:Panel>


    <asp:Panel ID="pnlGlobalMessage" runat="server" CssClass="alert" Visible="false"></asp:Panel>

    <div class="shop-layout">
        
        
        <div class="products-section">
            <div class="card" style="margin-bottom: 1.5rem; padding: 1.2rem;">
                <div class="search-bar">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Tìm kiếm thức uống thơm ngon..."></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Tìm kiếm" CssClass="btn btn-purple" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="Đặt lại" CssClass="btn btn-secondary" OnClick="btnReset_Click" />
                </div>
                <div class="category-tabs" style="margin-top: 1rem; margin-bottom: 0;">
                    <asp:LinkButton ID="btnCatAll" runat="server" CssClass="category-tab active" OnClick="btnCategory_Click" CommandArgument="All" CausesValidation="false">Tất cả</asp:LinkButton>
                    <asp:LinkButton ID="btnCatTraSua" runat="server" CssClass="category-tab" OnClick="btnCategory_Click" CommandArgument="TraSua" CausesValidation="false">Trà sữa</asp:LinkButton>
                    <asp:LinkButton ID="btnCatSinhTo" runat="server" CssClass="category-tab" OnClick="btnCategory_Click" CommandArgument="SinhTo" CausesValidation="false">Sinh tố</asp:LinkButton>
                    <asp:LinkButton ID="btnCatNuocTraiCay" runat="server" CssClass="category-tab" OnClick="btnCategory_Click" CommandArgument="NuocTraiCay" CausesValidation="false">Nước trái cây</asp:LinkButton>
                </div>
            </div>

            
            <div class="product-grid">
                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                    <ItemTemplate>
                        <div class="product-card">
                            <img src='<%# Eval("DuongDanAnh") %>' alt='<%# Eval("TenSanPham") %>' class="product-image" />
                            <div class="product-info">
                                <h3 class="product-name"><%# Eval("TenSanPham") %></h3>
                                <p class="product-desc"><%# Eval("MoTa") %></p>
                                <div class="product-price-row">
                                    <span class="product-price"><%# string.Format("{0:N0}đ", Eval("Gia")) %></span>
                                    <asp:LinkButton ID="btnSelectDrink" runat="server" 
                                        CommandName="SelectDrink" 
                                        CommandArgument='<%# Eval("MaSanPham") %>' 
                                        CssClass="btn btn-primary btn-sm" 
                                        Text="Chọn Món" />
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            
            <asp:Panel ID="pnlNoProducts" runat="server" Visible="false" style="text-align: center; padding: 3rem;">
                <p style="font-size: 1.2rem; color: var(--text-muted);">Không tìm thấy thức uống nào phù hợp.</p>
            </asp:Panel>
        </div>

        
        <div class="cart-section" id="giohang">
            <div class="card" style="padding: 1.5rem;">
                <div class="cart-title">
                    <span>🛒 Giỏ Hàng</span>
                    <asp:LinkButton ID="btnClearCart" runat="server" CssClass="btn btn-danger btn-sm" OnClick="btnClearCart_Click" Visible="false" Style="font-size: 0.8rem; padding: 0.2rem 0.6rem;">Xóa giỏ</asp:LinkButton>
                </div>

                
                <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                    <ItemTemplate>
                        <div class="cart-item-row">
                            <div class="cart-item-header">
                                <span><%# Eval("Name") %> (<%# Eval("Size") %>, <%# Eval("Sugar") %>, <%# Eval("Ice") %>) x <%# Eval("Quantity") %></span>
                                <span class="cart-item-price"><%# string.Format("{0:N0}đ", Eval("TotalPrice")) %></span>
                            </div>
                            <div class="cart-item-details">
                                <%# GetToppingsText(Container.DataItem) %>
                            </div>
                            <div class="cart-item-actions">
                                <span style="font-size: 0.8rem; color: var(--text-muted);">Đơn giá: <%# string.Format("{0:N0}đ", Eval("UnitPrice")) %></span>
                                <asp:LinkButton ID="btnRemoveItem" runat="server" 
                                    CommandName="RemoveItem" 
                                    CommandArgument='<%# Eval("Guid") %>' 
                                    CssClass="btn btn-danger btn-sm" 
                                    Style="font-size: 0.75rem; padding: 0.15rem 0.4rem;" 
                                    Text="Xóa" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlEmptyCart" runat="server" style="text-align: center; padding: 2rem 0;">
                    <p style="color: var(--text-muted); font-size: 0.95rem;">Giỏ hàng chưa có sản phẩm nào. Chọn nước ngay nào! 🥤</p>
                </asp:Panel>

                
                <asp:Panel ID="pnlCheckout" runat="server" Visible="false">
                    <div class="cart-total-row">
                        <span>Tổng thanh toán:</span>
                        <span style="color: var(--pastel-pink-dark);"><asp:Literal ID="litCartTotal" runat="server"></asp:Literal></span>
                    </div>

                    <div style="border-top: 1px solid var(--pastel-purple-light); padding-top: 1rem; margin-top: 1rem;">
                        <h4 style="font-size: 1.1rem; color: var(--pastel-purple-dark); margin-bottom: 1rem; font-weight: 600;">Thông Tin Giao Hàng</h4>
                        
                        <asp:Panel ID="pnlCheckoutWarning" runat="server" CssClass="alert alert-danger" Visible="false" Style="font-size: 0.85rem; padding: 0.6rem; margin-bottom: 0.8rem;">
                            <asp:Literal ID="litCheckoutWarning" runat="server"></asp:Literal>
                        </asp:Panel>

                        <div class="form-group">
                            <label class="form-label" style="font-size: 0.85rem;">Họ tên người nhận <span style="color:red">*</span></label>
                            <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" Style="padding: 0.5rem 0.75rem; font-size: 0.9rem;" placeholder="Nhập tên người nhận..."></asp:TextBox>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" style="font-size: 0.85rem;">Số điện thoại <span style="color:red">*</span></label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" Style="padding: 0.5rem 0.75rem; font-size: 0.9rem;" placeholder="Nhập số điện thoại nhận hàng..."></asp:TextBox>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" style="font-size: 0.85rem;">Địa chỉ nhận hàng <span style="color:red">*</span></label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" Style="padding: 0.5rem 0.75rem; font-size: 0.9rem;" placeholder="Số nhà, tên đường, phường, quận..."></asp:TextBox>
                        </div>

                        <asp:Button ID="btnSubmitOrder" runat="server" Text="Xác Nhận Đặt Hàng" CssClass="btn btn-primary" Width="100%" OnClick="btnSubmitOrder_Click" Style="margin-top: 0.5rem;" />
                    </div>
                </asp:Panel>
            </div>
        </div>

    </div>

    
    <asp:Panel ID="pnlModal" runat="server" CssClass="modal-backdrop" Visible="false">
        <div class="modal-content">
            <asp:LinkButton ID="btnCloseModal" runat="server" CssClass="modal-close" OnClick="btnCloseModal_Click" CausesValidation="false">&times;</asp:LinkButton>
            
            <div class="modal-body">
                <div class="modal-product-header">
                    <img id="imgModalProduct" runat="server" src="" alt="" class="modal-product-img" />
                    <div class="modal-product-info">
                        <h3><asp:Literal ID="litModalName" runat="server"></asp:Literal></h3>
                        <p><asp:Literal ID="litModalPrice" runat="server"></asp:Literal></p>
                    </div>
                </div>

                
                <div class="option-group">
                    <h4 class="modal-section-title">Chọn Kích Cỡ</h4>
                    <asp:RadioButtonList ID="rblSizes" runat="server" RepeatDirection="Horizontal" CssClass="rbl-sizes" Style="margin-top: 0.5rem; width: 100%;">
                        <asp:ListItem Value="S" Selected="True">Size S (Mặc định)</asp:ListItem>
                        <asp:ListItem Value="M">Size M (+5,000đ)</asp:ListItem>
                        <asp:ListItem Value="L">Size L (+10,000đ)</asp:ListItem>
                    </asp:RadioButtonList>
                </div>

                <div class="option-group">
                    <h4 class="modal-section-title">Chọn Mức Đường</h4>
                    <asp:RadioButtonList ID="rblSugar" runat="server" RepeatDirection="Horizontal" CssClass="rbl-sizes" Style="margin-top: 0.5rem; width: 100%;">
                        <asp:ListItem Value="100% Đường" Selected="True">100% Đường</asp:ListItem>
                        <asp:ListItem Value="70% Đường">70% Đường</asp:ListItem>
                        <asp:ListItem Value="50% Đường">50% Đường</asp:ListItem>
                        <asp:ListItem Value="Không Đường">Không Đường</asp:ListItem>
                    </asp:RadioButtonList>
                </div>

                <div class="option-group">
                    <h4 class="modal-section-title">Chọn Mức Đá</h4>
                    <asp:RadioButtonList ID="rblIce" runat="server" RepeatDirection="Horizontal" CssClass="rbl-sizes" Style="margin-top: 0.5rem; width: 100%;">
                        <asp:ListItem Value="100% Đá" Selected="True">100% Đá</asp:ListItem>
                        <asp:ListItem Value="70% Đá">70% Đá</asp:ListItem>
                        <asp:ListItem Value="50% Đá">50% Đá</asp:ListItem>
                        <asp:ListItem Value="Không Đá">Không Đá</asp:ListItem>
                    </asp:RadioButtonList>
                </div>

                
                <div class="option-group">
                    <h4 class="modal-section-title">Chọn Topping kèm theo</h4>
                    <div style="max-height: 180px; overflow-y: auto; padding-right: 0.5rem; margin-top: 0.5rem;">
                        <asp:CheckBoxList ID="cblToppings" runat="server" CssClass="cbl-toppings" DataValueField="MaSanPham" DataTextField="TenSanPhamFormat">
                        </asp:CheckBoxList>
                    </div>
                </div>

                
                <div class="option-group" style="display: flex; align-items: center; gap: 1rem;">
                    <span class="form-label" style="margin-bottom: 0; font-weight: 600;">Số lượng:</span>
                    <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text="1" CssClass="form-control" Style="width: 80px; text-align: center; padding: 0.4rem;"></asp:TextBox>
                </div>

                <div style="margin-top: 1.5rem; display: flex; gap: 1rem;">
                    <asp:Button ID="btnAddToCart" runat="server" Text="Thêm Vào Giỏ Hàng" CssClass="btn btn-purple" Style="flex: 1;" OnClick="btnAddToCart_Click" />
                    <asp:Button ID="btnCancelModal" runat="server" Text="Hủy" CssClass="btn btn-secondary" OnClick="btnCloseModal_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var slides = document.querySelectorAll(".carousel-slide");
            if (slides.length <= 0) return;

            var currentSlide = 0;
            var slideTimeout = null;
            var isHovered = false;
            var currentSlideDuration = 9000;
            var slideStartTime = 0;
            var slideRemainingTime = 9000;

            // Generate dots dynamically
            var dotsContainer = document.getElementById("carouselDots");
            if (dotsContainer) {
                for (var i = 0; i < slides.length; i++) {
                    var dot = document.createElement("div");
                    dot.classList.add("carousel-dot");
                    if (i === 0) dot.classList.add("active");
                    dot.setAttribute("data-slide", i);
                    dot.addEventListener("click", function (e) {
                        var targetSlide = parseInt(e.target.getAttribute("data-slide"));
                        goToSlide(targetSlide);
                    });
                    dotsContainer.appendChild(dot);
                }
            }

            var nextBtn = document.querySelector(".carousel-nav-next");
            var prevBtn = document.querySelector(".carousel-nav-prev");

            if (nextBtn) {
                nextBtn.addEventListener("click", function () {
                    nextSlide();
                });
            }

            if (prevBtn) {
                prevBtn.addEventListener("click", function () {
                    prevSlide();
                });
            }

            function nextSlide() {
                goToSlide((currentSlide + 1) % slides.length);
            }

            function prevSlide() {
                goToSlide((currentSlide - 1 + slides.length) % slides.length);
            }

            function startSlideTimer(duration) {
                clearTimeout(slideTimeout);
                if (isHovered) return;

                currentSlideDuration = duration;
                slideStartTime = Date.now();
                slideRemainingTime = duration;

                slideTimeout = setTimeout(nextSlide, duration);
            }

            // Pause auto-play on hover
            var container = document.querySelector(".carousel-container");
            if (container) {
                container.addEventListener("mouseenter", function () {
                    isHovered = true;
                    clearTimeout(slideTimeout);
                    var elapsed = Date.now() - slideStartTime;
                    slideRemainingTime = Math.max(0, currentSlideDuration - elapsed);
                });
                container.addEventListener("mouseleave", function () {
                    isHovered = false;
                    var resumeTime = Math.max(2000, slideRemainingTime);
                    slideStartTime = Date.now();
                    currentSlideDuration = resumeTime;
                    slideTimeout = setTimeout(nextSlide, resumeTime);
                });
            }

            function updateSlideTiming(slideIndex) {
                var slide = slides[slideIndex];
                if (!slide) return 9000;

                var marqueeBar = slide.querySelector(".marquee-bar");
                var marqueeContent = slide.querySelector(".marquee-content");
                if (!marqueeBar || !marqueeContent) {
                    return 9000;
                }

                // Measure text characters to balance timings
                var textContent = marqueeContent.textContent.trim();
                var cleanText = textContent.replace(/^⚡\s*/, "");
                var charCount = cleanText.length;

                // Base formula: 4s base + 1s for every 8 characters.
                // E.g., 85 characters -> 4 + 10.6 = 14.6 seconds.
                // Min 8s, Max 18s.
                var durationSec = 4 + (charCount / 8);
                durationSec = Math.max(8, Math.min(18, durationSec));
                var durationMs = durationSec * 1000;

                // Sync the marquee scroll animation duration to exactly match the slide duration
                marqueeContent.style.animationDuration = durationSec + "s";

                return durationMs;
            }

            function goToSlide(n) {
                slides[currentSlide].classList.remove("active");
                
                var dots = document.querySelectorAll(".carousel-dot");
                if (dots && dots.length > currentSlide) {
                    dots[currentSlide].classList.remove("active");
                }

                currentSlide = n;

                var slideDuration = updateSlideTiming(currentSlide);

                slides[currentSlide].classList.add("active");
                if (dots && dots.length > currentSlide) {
                    dots[currentSlide].classList.add("active");
                }

                startSlideTimer(slideDuration);
            }

            // Initialize the first slide timing and timer
            var initialDuration = updateSlideTiming(0);
            startSlideTimer(initialDuration);
        });
    </script>
</asp:Content>

