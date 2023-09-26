import React, { useEffect, useState } from "react";
import { Chrono } from "react-chrono";
import { DataItem } from "../data/data";
import "./timeline.css";
interface item {
  title: string;
  cardSubtitle: string;
  media: {
    type: string;
    source: {
      url: string;
    };
  };
}
interface TimelineProps {
  data: DataItem[];
}
function formatDateTime(dateTimeString: string) {
  const parsedDate = new Date(dateTimeString);
  const year = parsedDate.getFullYear();
  const month = String(parsedDate.getMonth() + 1).padStart(2, "0");
  const day = String(parsedDate.getDate()).padStart(2, "0");
  const hours = String(parsedDate.getHours()).padStart(2, "0");
  const minutes = String(parsedDate.getMinutes()).padStart(2, "0");

  return `${year}-${month}-${day} ${hours}:${minutes}`;
}

function Timeline({ data }: TimelineProps) {
  const s3_url = process.env.REACT_APP_S3_URL;
  console.log(s3_url);
  console.log(data);

  const [tooltipPosition, setTooltipPosition] = useState<{
    x: number;
    y: number;
  } | null>(null);

  // useEffect(() => {
  //   const handleMouseMove = (e: MouseEvent) => {
  //     const targetElement = e.target as HTMLElement;
  //     // targetElement를 사용하여 필요한 데이터를 가져옵니다.
  //     // 예를 들어, data-attributes를 사용하여 데이터를 저장하는 경우:
  //     const data = targetElement.dataset.yourDataAttribute;
  //     if (data) {
  //       console.log(data); // 데이터 로깅
  //     }
  //     setTooltipPosition({ x: e.clientX, y: e.clientY });
  //   };

  //   const handleMouseLeave = () => {
  //     setTooltipPosition(null);
  //   };

  //   const elements = document.querySelectorAll(".iNlFwt");
  //   elements.forEach((element) => {
  //     element.addEventListener("mousemove", handleMouseMove as EventListener);
  //     element.addEventListener("mouseleave", handleMouseLeave as EventListener);
  //   });

  //   return () => {
  //     elements.forEach((element) => {
  //       element.removeEventListener(
  //         "mousemove",
  //         handleMouseMove as EventListener
  //       );
  //       element.removeEventListener(
  //         "mouseleave",
  //         handleMouseLeave as EventListener
  //       );
  //     });
  //   };
  // }, []);

  const transformedData = data.map((item) => ({
    title:
      item.images.length > 0 ? formatDateTime(item.images[0].CreateDate) : "", // images 배열이 비어있는 경우 빈 문자열을 넣음
    cardSubtitle: item.record.recordValue,
    media: {
      type: "IMAGE",
      source: {
        url: `${s3_url}/${item.images[0].imageName}`, // 여기에 이미지 URL을 넣어주세요.
      },
    },
  }));
  console.log(transformedData);

  return (
    <div className="timebg">
      <Chrono items={transformedData} mode="VERTICAL_ALTERNATING" />
      {/* {tooltipPosition && (
        <div
          style={{
            position: "fixed",
            top: tooltipPosition.y,
            left: tooltipPosition.x,
            background: "white",
            border: "1px solid black",
            padding: "5px",
            zIndex: 1000,
          }}
          className="timehover"
        ></div>
      )} */}
    </div>
  );
}
export default Timeline;
