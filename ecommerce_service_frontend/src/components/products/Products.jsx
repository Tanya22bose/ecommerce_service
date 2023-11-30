import React, { useEffect, useState } from "react";
import "./Products.css";
import axios from "axios";
import { useNavigate } from "react-router-dom";

export const Product = ({ item, hide_btn = false, hide_price = false}) => {
  const navigate = useNavigate();
  return (
    <>
      <div className="product">
        <div className="product-img">
          <img src={item?.image_urls} alt="Sample" height="150" />
        </div>
        <div className="product-detail">
          <h4 className="product-name">{item?.name}</h4>
          <p>{item?.description}</p>
        </div>
        <div className="product-price">
          {hide_price ? "" : (item?.price.toLocaleString("en-IN", {
            style: "currency",
            currency: "INR",
            minimumFractionDigits: 2,
          }))}
        </div>
        {!hide_btn ? (
          <button
            className="product-action"
            onClick={() =>
              navigate("/product-details", { state: { product: item } })
            }
          >
           See Details
          </button>
        ) : (
          ""
        )}
      </div>
    </>
  );
};

const Products = () => {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    (async function () {
      await getProducts();
    })();
  }, []);

  const getProducts = async () => {
    const response = await axios.get("http://localhost:3002/products");
    if (response?.data) setProducts(response?.data);
  };

  if (products?.length) {
    return (
      <div className="align-products">
        <div className="heading">
          <p>Browse through Products</p>
        </div>
        <div className="display-products">
          {products?.map((item, idx) => (
            <Product item={item} key={idx} />
          ))}
        </div>
      </div>
    );
  } else return;
};

export default Products;
