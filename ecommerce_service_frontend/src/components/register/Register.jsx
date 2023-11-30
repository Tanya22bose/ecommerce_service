import axios from "axios";
import "./Register.css";
import "./../../App.css";
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

const Register = () => {
  const endpoint = "http://localhost:3001";
  const navigate = useNavigate();
  const [values, setValues] = useState({
    email: "",
    password: "",
    password_confirmation: "",
  });

  const handleInputChange = (event) => {
    event.preventDefault();

    const { name, value } = event.target;
    setValues((values) => ({
      ...values,
      [name]: value,
    }));
  };

  const register = async (e) => {
    e.preventDefault();
    const user = {
      email: values.email,
      password: values.password,
      password_confirmation: values.password_confirmation,
    };
    try {
      const res = await axios.post(
        `${endpoint}/authentications/register`,
        user
      );
      if (res) {
        console.log(res.data);
        alert(res.data.message);
        navigate("/login");
      }
    } catch (error) {
      console.log(error);
      alert(error.response.data.errors);
    }
  };

  return (
    <>
      <div className="login-heading">Register Page</div>
      <div className="form-container">
        <form className="register-form" onSubmit={register}>
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
          <input
            className="form-field"
            type="password"
            placeholder="Password confirmation"
            name="password_confirmation"
            value={values.password_confirmation}
            onChange={handleInputChange}
          />
          <button className="form-field" type="submit">
            Register
          </button>
          <div style={{textAlign: "center", marginTop: "10px"}}>
            Already have an account? <a href="/login">Login</a>
          </div>
        </form>
      </div>
    </>
  );
};

export default Register;
