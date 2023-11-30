import axios from "axios";
import "./Login.css";
import "./../../App.css";
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

const Login = () => {
  const endpoint = "http://localhost:3001";
  const navigate = useNavigate();
  const [values, setValues] = useState({
    email: "",
    password: "",
  });

  const handleInputChange = (event) => {
    event.preventDefault();

    const { name, value } = event.target;
    setValues((values) => ({
      ...values,
      [name]: value,
    }));
  };

  const login = async (e) => {
    e.preventDefault();
    const login_credentials = {
      email: values.email,
      password: values.password,
    };
    try {
      const response = await axios.post(
        `${endpoint}/authentications/login`,
        login_credentials
      );
      if (response) {
        console.log(response.data);
        alert(response.data.message);
        navigate("/");
      }
    } catch (error) {
      console.log(error);
      alert(error);
    }
  };

  return (
    <>
      <div className="login-heading">Login Page</div>
      <div className="form-container">
        <form className="login-form" onSubmit={login}>
          <input
            className="form-field"
            type="email"
            placeholder="Email"
            name="email"
            value={values.email}
            onChange={handleInputChange}
          />
          <input
            className="form-field"
            type="password"
            placeholder="Password"
            name="password"
            value={values.password}
            onChange={handleInputChange}
          />
          <button className="form-field" type="submit">
            Login
          </button>
          <div style={{textAlign: "center", marginTop: "10px"}}>
            Already have an account? <a href="/register">Register</a>
          </div>
        </form>
      </div>
    </>
  );
};

export default Login;
