import React from "react";
import { Link } from "react-router-dom";
import "./footer.css"

interface FooterProps {
  setUploadState: React.Dispatch<React.SetStateAction<boolean>>;
}

const Footer: React.FC<FooterProps> = ({ setUploadState }) => {
  return (
    <div className="footer">
      <Link to="#" onClick={() => setUploadState(prev => !prev)}>
        <img className="menu" src="./Vector2.png" alt="" />
      </Link>
      <Link to="/">
        <img className="menu" src="./Home.png" alt="" />
      </Link>
      <Link to="/map">
        <img className="menu" src="./earth.png" alt="" />
      </Link>
      <Link to="/timeline">
        <img className="menu" src="./Image.png" alt="" />
      </Link>
      <Link to="/login">
        <img className="menu" src="./Settings.png" alt="" />
      </Link> 
    </div>
  );
};

export default Footer;
