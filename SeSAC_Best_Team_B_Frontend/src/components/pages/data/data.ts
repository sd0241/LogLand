export interface Record {
  recordId: number;
  recordValue: string;
}

export interface Image {
  imageName: string;
  GPSLatitude: number;
  GPSLongitude: number;
  CreateDate: string; // 날짜 문자열 형식이라면 Date 타입으로 변환하는 것이 좋을 수 있습니다.
  // id: number;
}

export interface DataItem {
  record: Record;
  images: Image[];
}

// export const dummyData: DataItem[] = [{
//   record: {
//     recordId: 30,
//     recordValue: "test",
//   },
//   images: [
//     {
//       imageName: 1693986455340-20230829_152711.jpg,n
//       GPSLatitude: 37.5179,
//       GPSLongitude: 126.886,
//       CreateDate: "2023-08-29T15:27:12.000Z",
//     },
//   ],
// }];
