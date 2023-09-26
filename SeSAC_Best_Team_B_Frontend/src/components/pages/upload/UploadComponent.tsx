import React, { useState } from "react";
import axios from "axios";
import "./UploadComponent.css";
import { useParams } from "react-router-dom";
import { DataItem } from "../data/data";
interface setDataProps {
  setData: React.Dispatch<React.SetStateAction<DataItem[] | []>>;
  setIsUploadComponentVisible: React.Dispatch<React.SetStateAction<boolean>>;
}
const UploadComponent: React.FC<setDataProps> = ({
  setData,
  setIsUploadComponentVisible,
}) => {
  const { roomId } = useParams();
  console.log("roomId", roomId);
  const [selectedFiles, setSelectedFiles] = useState<FileList | null>(null);
  const [text, setText] = useState<string>("");

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSelectedFiles(e.target.files);
  };

  const handleTextChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setText(e.target.value);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedFiles) return;

    const formData = new FormData();
    for (let i = 0; i < selectedFiles.length; i++) {
      formData.append("images", selectedFiles[i]);
    }
    formData.append("text", text);
    if (roomId !== undefined) {
      formData.append("roomId", roomId);
    }

    try {
      const response = await axios.post("/upload", formData);
      console.log("Upload success:", response.data);
      setData((prevData) => [...prevData, response.data]);
      // response.data.record ? alert("업로드 성공") : alert(response.data.message);
      alert("업로드 성공") 
      setIsUploadComponentVisible(false);
    } catch (error) {
      console.error("Error uploading:", error);
      alert("메타데이터가 없습니다.")
    }
  };

  return (
    <div className="upload-container">
      <div>
        <button
          className="upload-close"
          onClick={() => {
            setIsUploadComponentVisible(false);
          }}
        >
          닫기
        </button>
      </div>
      <form onSubmit={handleSubmit}>
        <input
          type="file"
          multiple
          onChange={handleFileChange}
          accept=".jpg,jpeg, .heic"
          required
        />
        <textarea onChange={handleTextChange} value={text} required></textarea>
        <button type="submit">Upload</button>
      </form>
    </div>
  );
};

export default UploadComponent;
