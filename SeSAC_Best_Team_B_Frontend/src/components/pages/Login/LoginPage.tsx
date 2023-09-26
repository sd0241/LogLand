import React from 'react';
import axios from 'axios';
import './LoginPage.css';

const LoginPage: React.FC = () => {
  const loginUrl = process.env.REACT_APP_BACKEND + '/auth/kakao'

  return (
    <div className="login-page">
      <div className="top-section">
        <img src="mainimg.jpg" alt="아이콘" className="icon" /> {/* 아이콘 이미지 경로를 지정하세요 */}
        <div className="text">우리 둘만의</div>
        <div className="text">기억이</div>
        <div className="text">저장된 곳</div>
      </div>
      {/* <div className="middle-section">
        <input type="text" placeholder="사용자 이름" className="username-input" />
        <input type="password" placeholder="비밀번호" className="password-input" />
      </div> */}
      {/* <a href="http://localhost:5000/auth/kakao" className="kakao-login-button"> */}
      <a href={loginUrl} className="kakao-login-button">
        <img src="kakao.png" alt="카카오 로그인" className="kakao-icon" />
        <div>카카오로 로그인</div>
        <span className="tip"><img src="Union.png" alt="" />3초만에 빠른 회원가입</span>
      </a>
      <a href="/auth/kakao" className="google-login-button">
        <img src="google.png" width={25} height={25} alt="구글 로그인" className="kakao-icon" />
        <div>구글 로그인</div>
      </a>
    </div>
  );
};
export default LoginPage;