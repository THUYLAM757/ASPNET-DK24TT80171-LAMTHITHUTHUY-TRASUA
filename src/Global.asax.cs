using System;
using System.Data.SqlClient;
using System.Configuration;

namespace WaterMilkTea
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            
            if (Session["Cart"] == null)
            {
                Session["Cart"] = new System.Collections.Generic.List<CartItem>();
            }
        }
    }

    
    [Serializable]
    public class CartItem
    {
        public string Guid { get; set; } = System.Guid.NewGuid().ToString();
        public int ProductId { get; set; }
        public string Name { get; set; }
        public string Size { get; set; } 
        public string Sugar { get; set; }
        public string Ice { get; set; }
        public int Quantity { get; set; }
        public decimal BasePrice { get; set; } 
        public decimal SizePrice { get; set; } 
        public System.Collections.Generic.List<ToppingItem> Toppings { get; set; } = new System.Collections.Generic.List<ToppingItem>();

        public decimal UnitPrice
        {
            get
            {
                decimal total = BasePrice + SizePrice;
                foreach (var top in Toppings)
                {
                    total += top.Price;
                }
                return total;
            }
        }

        public decimal TotalPrice => UnitPrice * Quantity;
    }

    [Serializable]
    public class ToppingItem
    {
        public int ToppingId { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
    }
}
