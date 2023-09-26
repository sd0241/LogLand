import React, { useEffect, useState } from "react";
import {
  GoogleMap,
  useJsApiLoader,
  MarkerF,
  Marker,
  InfoWindow,
} from "@react-google-maps/api";
import { DataItem } from "../data/data";
import BoxList from "../First/BoxList";
import { Link } from "react-router-dom";
import { useParams } from "react-router-dom";
import UploadComponent from "../upload/UploadComponent";
import "./aside.css";
interface setIsUploadComponentVisibleProps {
  setIsUploadComponentVisible: React.Dispatch<React.SetStateAction<boolean>>;
}
const Aside: React.FC<setIsUploadComponentVisibleProps> = ({
  setIsUploadComponentVisible,
}) => {
  // const [isUploadComponentVisible, setIsUploadComponentVisible] =
  useState<boolean>(false);
  const [isAsideVisible, setIsAsideVisible] = useState(false);
  const { roomId } = useParams();

  const toggleAside = () => {
    setIsAsideVisible(!isAsideVisible);
    setIsUploadComponentVisible(false);
  };

  const toggleUploadComponent = () => {
    if (window.innerWidth >= 768) {
      setIsUploadComponentVisible((prevState) => !prevState);
    } else if (window.innerWidth < 768) {
      setIsUploadComponentVisible((prevState) => !prevState);
      setIsAsideVisible(false);
    }
  };
  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth >= 768) {
        setIsAsideVisible(true);
      } else if (window.innerWidth < 768) {
        setIsAsideVisible(false);
      }
    };
    handleResize();
    console.log(1);
    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, []);
  console.log(isAsideVisible);

  return (
    <>
      <aside
        className="aside1"
        style={{ display: isAsideVisible ? "flex" : "none" }}
      >
        <div>
          <Link to="/">
            <img src="/Home.png" alt="" />
          </Link>
          <Link to={`/map/${roomId}`}>
            <div className="menu">
              <img src="/Earth.png" alt="" />
              <span>Map</span>
            </div>
          </Link>
          <Link to={`/timeline/${roomId}`}>
            <div className="menu">
              <img src="/Image.png" alt="" />
              <span>timeline</span>
            </div>
          </Link>
          <Link to="/login">
            <div className="menu">
              <img src="/Settings.png" alt="" />
              <span>login</span>
            </div>
          </Link>
          <div
            style={{
              width: "80%",
              textAlign: "center",
              color: "#fff",
              marginTop: "100px",
              margin: "20px 10%",
              background: "rgb(255 255 255 / 15%)",
              padding: "7px 0",
              borderRadius: "15px 25px 15px 25px",
            }}
            onClick={toggleUploadComponent}
          >
            <img
              style={{ marginRight: "5px" }}
              className="/uploadImg.png"
              src="/upload.png"
              alt=""
              width={40}
              height={40}
            />
            <div>upload</div>
          </div>
          <div
            className="close-button"
            onClick={() => setIsAsideVisible(false)}
          ></div>
        </div>
      </aside>
      <div className="hamburger-menu2" onClick={toggleAside}>
        <svg
          width="40"
          height="40"
          viewBox="0 0 40 40"
          xmlns="http://www.w3.org/2000/svg"
        >
          <rect y="10" width="40" height="4" rx="3" ry="2" fill="#ffffffcb" />
          <rect y="20" width="40" height="4" rx="3" ry="2" fill="#ffffffcb" />
          <rect y="30" width="40" height="4" rx="3" ry="2" fill="#ffffffcb" />
        </svg>
      </div>

      {/* {isUploadComponentVisible && <UploadComponent />} */}
    </>
  );
};
export default React.memo(Aside);
