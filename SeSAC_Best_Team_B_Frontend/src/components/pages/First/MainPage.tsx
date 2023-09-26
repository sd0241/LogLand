import React, { useEffect, useState } from "react";
import BoxList from "./BoxList";
import axios from "axios";
import { DataItem } from "../data/data";
const MainPage: React.FC = () => {
  const [data, setData] = useState<DataItem[]>([]);
  const [error, setError] = useState(null as any);
  console.log('data 9', data)
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get('/main');
        setData(response.data);
      } catch (error) {
        setError(error);
      }
    };
    fetchData()
  }, [])
  function recordV(recordValue: string) {
    if (recordValue.length > 50) {
      return recordValue.slice(0, 50) + '...'
    }
    return recordValue
  }
  function formatDateTime(dateTimeString: string) {
    const parsedDate = new Date(dateTimeString);
    const year = parsedDate.getFullYear();
    const month = String(parsedDate.getMonth() + 1).padStart(2, '0');
    const day = String(parsedDate.getDate()).padStart(2, '0');
    const hours = String(parsedDate.getHours()).padStart(2, '0');
    const minutes = String(parsedDate.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }
  return (
    <div className="FirstPage">
      {data.map((item, index) => (
        <div>
          <div className="boxBG">
            <h3>{recordV(item.record.recordValue)}</h3>
            <span>{formatDateTime(item.images[0].CreateDate)}</span>
          </div>
          <BoxList key={item.record.recordId} images={item.images} record={item.record} />
        </div>
      ))}
    </div>
  );
};
export default MainPage;