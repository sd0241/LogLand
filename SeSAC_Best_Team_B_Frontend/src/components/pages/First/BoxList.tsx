import React, { useState, useEffect } from "react";
import { DataItem, Image } from "../data/data";
import "./MainPage.css";

const BoxList: React.FC<DataItem> = ({ images }) => {
  const [dataImages, setDataImages] = useState<Image[]>(images);
  const s3_url = process.env.REACT_APP_S3_URL;

  useEffect(() => {
    if (dataImages.length > 4) {
      setDataImages(dataImages.slice(0, 4));
    }
  }, [dataImages]);

  function imageComponent(imgSrc: string) {
    let width = "100%";
    let height = "100%";

    if (dataImages.length >= 4) {
      width = "50%";
      height = "50%";
    } else if (dataImages.length === 3) {
      width = "100%";
      height = "33.3%";
    } else if (dataImages.length === 2) {
      width = "100%";
      height = "50%";
    }

    return <img src={imgSrc} style={{ width, height }} key={imgSrc} alt="" />;
  }

  console.log(dataImages)

  return (
    <div className="box">
      {dataImages.map((image) => (
        imageComponent(`${s3_url}/${image.imageName}`)
      ))}
    </div>
  );
};

export default BoxList;
