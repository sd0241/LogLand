import React, { useState } from "react";
import "./roomform.css";
import axios from "axios";
import { RoomData } from './Main';
interface FormState {
  name: string;
  relationship: string;
  genderOrGroup: string;
  slogan: string;
}
interface RoomFormProps {
  setRoom: React.Dispatch<React.SetStateAction<RoomData[] | []>>;
  room: RoomData[] | []; 
  setFormDisplay: React.Dispatch<React.SetStateAction<boolean>>;
}

const RoomForm: React.FC<RoomFormProps> = ({setRoom, room, setFormDisplay}) => {

  const [formState, setFormState] = useState<FormState>({
    name: "",
    relationship: "친구",
    genderOrGroup: "남",
    slogan: "",
  });
  console.log(formState);
  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) => {
    const { name, value } = e.target;
    setFormState({
      ...formState,
      [name]: value,
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log(formState)
    if (formState.slogan.length <= 15) {

      axios
        .post("/upload/room", {...formState,genderOrGroup: formState.genderOrGroup+ (Math.floor(Math.random() * 3) + 1)})
        .then((response) => {
          console.log("Response:", response.data);

          setRoom(prevRooms => [...(prevRooms ?? []), response.data]);
          alert("룸 만들기 성공")
          setFormDisplay(false)
          console.log("Response:", response.data);
        })
        .catch((error) => {
          console.error("Error:", error);
          alert("Form Submission Failed");
        });
    } else {
      alert("슬로건은 15자 이내로 입력해주세요.");
    }
  };

  return (
    <form onSubmit={handleSubmit} className="roomForm">
      <div className="formGroup">
        <label>
          이름(그룹명):
          <input
            type="text"
            name="name"
            value={formState.name}
            onChange={handleChange}
            required
            className="input"
          />
        </label>
      </div>
      <div className="formGroup">
        <label>
          관계:
          <select
            name="relationship"
            value={formState.relationship}
            onChange={handleChange}
            required
            className="select"
          >
            <option value="친구">친구</option>
            <option value="가족">가족</option>
            <option value="여자친구">여자친구</option>
            <option value="남자친구">남자친구</option>
            <option value="애완동물">애완동물</option>
            <option value="기타">기타</option>
          </select>
        </label>
      </div>
      <div className="formGroup">
        <label>
          성별:
          <select
            name="genderOrGroup"
            value={formState.genderOrGroup}
            onChange={handleChange}
            required
            className="select"
          >
            <option value="남">남</option>
            <option value="여">여</option>
            <option value="단체">단체</option>
          </select>
        </label>
      </div>
      <div className="formGroup">
        <label>
          슬로건(15자 이내):
          <input
            type="text"
            name="slogan"
            value={formState.slogan}
            onChange={handleChange}
            maxLength={15}
            required
            className="input"
          />
        </label>
      </div>
      <button type="submit" className="button">
        전송
      </button>
    </form>
  );
};

export default RoomForm;
