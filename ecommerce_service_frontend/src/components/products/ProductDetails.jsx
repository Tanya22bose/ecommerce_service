import axios from "axios";
import { Product } from "./Products";
import "./productDetails.css";
import { useLocation } from "react-router-dom";
import { useEffect, useState } from "react";

const fetchProductQty = async (productId) => {
  const response = await axios.get(
    `http://localhost:3002/products/${productId}`
  );
  if (response?.data) console.log(response?.data);
};
const ProductDetails = () => {
  const location = useLocation();
  const { product } = location?.state;
  const [quantity, setQuantity] = useState(0);
  console.log(product);

  // useEffect(() => {
  //   (async function () {
  //     await fetchProductQty(product?.id);
  //   })();
  // }, []);

  return (
    <div className="product-display">
      <Product item={product} hide_btn hide_price />
      <div className="cart-details">
        <div>Total Price: ₹{product?.price * quantity}</div>
        {quantity === 0 ? (
          <button
            type="button"
            className="add-to-cart"
            onClick={() => setQuantity((val) => val + 1)}
          >
            Add to Cart
          </button>
        ) : (
          <div className="modify-qty">
            <button className="decrease-qty" onClick={() => setQuantity((val) => val + 1)}>+</button>
            <div>Qty: {quantity}</div>
            <button className="increase-qty" onClick={() => setQuantity((val) => val - 1)}>-</button>
          </div>
        )}
      </div>
    </div>
  );
};

export default ProductDetails;
