import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Register from "./components/register/Register";
import Login from "./components/login/Login";
import Products from "./components/products/Products";
import ProductDetails from "./components/products/ProductDetails";

function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path="/register" element={<Register />} />
          <Route path="/login" element={<Login />} />
          <Route path="/product-details" element={<ProductDetails/>} />
          <Route path="/" element={<Products />} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
