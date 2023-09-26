import Map from "./Map";
import { DataItem } from "../data/data";
import React, { useEffect, useState } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";
function MapPage() {
  const [data, setData] = useState<DataItem[]>([]);
  const [loading, setLoading] = useState(true);
  const { roomId } = useParams();
  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await axios.get(`/main/${roomId}`);
        console.log(res.data);
        setData(res.data);
        setLoading(false); // 데이터를 성공적으로 받아왔으므로 로딩 상태 변경
      } catch (error) {
        console.log("데이터 가져오기 오류", error);
        setLoading(false); // 데이터를 받아오는 중 오류가 발생하더라도 로딩 상태 변경
      }
    };

    fetchData();
  }, [roomId]);
  console.log(data);

  // 로딩 중일 때 로딩 표시
  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <div className="background1" style={{ display: "flex", height: "100vh" }}>
      <Map data={data} setData={setData} />
    </div>
  );
}

export default MapPage;
