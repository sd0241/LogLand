import React from "react";
import axios from "axios";
import "./login.css";

const LoginPage: React.FC = () => {
  const loginUrl = process.env.REACT_APP_BACKEND+"/auth/kakao";

  return (
    <div className="background">
      <div className="login">
        <div className="form">
          <h2>
            Let's get you
            <br /> signed in!
          </h2>
          <a href={`${process.env.REACT_APP_BACKEND}/auth/kakao`} className="kakao-login-button">
            <img
              src="kakao.png"
              width={25}
              height={25}
              alt="카카오 로그인"
              className="kakao-icon"
            />
            <div>Kakao Login</div>
            <span className="tip">
              <img src="Union.png" alt="" />3 second sign up
            </span>
          </a>
          <a href="/auth/kakao" className="google-login-button">
            <img
              src="google.png"
              width={25}
              height={25}
              alt="구글 로그인"
              className="kakao-icon"
            />
            <div>google Login</div>
          </a>
        </div>
        <img src="/loginBg.png" alt="" />
      </div>
    </div>
  );
};
export default LoginPage;
