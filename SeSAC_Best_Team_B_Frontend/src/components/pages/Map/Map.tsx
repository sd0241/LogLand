import React, { useEffect, useState } from "react";
import {
  GoogleMap,
  useJsApiLoader,
  Marker,
  InfoWindow,
  MarkerClusterer,
} from "@react-google-maps/api";
import { DataItem, Image } from "../data/data";
import BoxList from "../First/BoxList";
import { useParams } from "react-router-dom";
import "./map.css";
import Aside from "../common/Aside";
import UploadComponent from "../upload/UploadComponent";

const s3_url = process.env.REACT_APP_S3_URL;
const myStyles = [
  {
    featureType: "poi",
    elementType: "labels",
    stylers: [{ visibility: "off" }],
  },
];
const containerStyle = {
  width: "100vw",
  height: "100vh",
};
interface MapProps {
  data: DataItem[];
  setData: React.Dispatch<React.SetStateAction<DataItem[] | []>>;
}
// interface setDataProps {
//   setData: React.Dispatch<React.SetStateAction<DataItem[] | []>>;
//   setIsUploadComponentVisible: React.Dispatch<React.SetStateAction<boolean>>;
// }
const center = {
  lat: 36.586148,
  lng: 128.1867972,
};
const zoom = 7;

interface MarkerComponentProps {
  item: DataItem;
  key: number;
  zoomLevel: number;
  clusterer: any;
}

const MarkerComponent = React.memo(
  ({ item, zoomLevel, clusterer }: MarkerComponentProps) => {
    console.log(item);
    const [address, setAddress] = useState(null);
    const [lat, setlat] = useState<number>(0);
    const [lng, setlng] = useState<number>(0);

    useEffect(() => {
      const fetchAddress = async () => {
        try {
          const response = await fetch(
            `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${process.env.REACT_APP_GOOGLE_MAP_API_KEY}`
          );
          const data = await response.json();
          if (data.results[0]) {
            setAddress(data.results[0].formatted_address);
          } else {
            console.error("No results found");
          }
        } catch (error) {
          console.error("Error fetching the address:", error);
        }
      };

      fetchAddress();
    }, [lat, lng]);

    const [openInfoWindowId, setOpenInfoWindowId] = useState<number | null>(
      null
    );
    const imageSize = zoomLevel < 5 ? 50 : zoomLevel < 8 ? 100 : 150;

    const handleMarkerClick = (index: number, img: Image) => {
      setOpenInfoWindowId((prev) => (prev === index ? null : index));
      console.log(img);
      setlat(img.GPSLatitude);
      setlng(img.GPSLongitude);
    };
    return (
      <>
        {item.images?.map((img, index) => (
          <Marker
            key={index}
            position={{
              lat: img.GPSLatitude,
              lng: img.GPSLongitude,
            }}
            onClick={() => handleMarkerClick(index, img)}
            clusterer={clusterer}
            icon={{
              url: `${s3_url}/${img.imageName}`,
              scaledSize: new google.maps.Size(imageSize, imageSize),
            }}
          >
            {openInfoWindowId === index && (
              <InfoWindow
                position={{
                  lat: img.GPSLatitude,
                  lng: img.GPSLongitude,
                }}
              >
                <div className="gd">
                  <div className="recordvalue">{item.record.recordValue}</div>
                  <div className="gdright">
                    {/* <h3>관련 Photo</h3> */}
                    <span>
                      <strong>Lcation</strong> : {address}
                    </span>
                    <div className="imgcount">
                      <strong>Count : {item.images.length}</strong>
                    </div>
                    <div className="images">
                      {item.images.map((aa) => (
                        <img
                          src={`${s3_url}/${aa.imageName}`}
                          alt=""
                          // style={{ width: imageSize, height: imageSize }}
                        />
                      ))}
                    </div>
                  </div>
                </div>
              </InfoWindow>
            )}
          </Marker>
        ))}
      </>
    );
  }
);

function Map({ data, setData }: MapProps) {
  const [zoomLevel, setZoomLevel] = useState<number>(zoom);
  console.log(zoomLevel);
  const [map, setMap] = React.useState<google.maps.Map | null>(null);
  const [isUploadComponentVisible, setIsUploadComponentVisible] =
    useState<boolean>(false);
  const onLoad = React.useCallback(function callback(map: any) {
    const bounds = new window.google.maps.LatLngBounds(center);
    setMap(map);
  }, []);

  const onUnmount = React.useCallback(function callback(map: any) {
    setMap(null);
  }, []);

  useEffect(() => {
    console.log("Map component rendered");
  }, []);

  const { isLoaded } = useJsApiLoader({
    id: "google-map-script",
    googleMapsApiKey: process.env.REACT_APP_GOOGLE_MAP_API_KEY as string,
  });

  const handleZoomChanged = () => {
    if (map) {
      const currentZoomLevel = map.getZoom();
      if (currentZoomLevel !== undefined) {
        setZoomLevel(currentZoomLevel);
      }
    }
  };

  useEffect(() => {
    if (map) {
      const zoomChangedListener = map.addListener(
        "zoom_changed",
        handleZoomChanged
      );
      return () => {
        google.maps.event.removeListener(zoomChangedListener);
      };
    }
  }, [map]);

  const imageSize = zoomLevel < 5 ? 50 : zoomLevel < 8 ? 100 : 150;

  return isLoaded ? (
    <>
      <Aside setIsUploadComponentVisible={setIsUploadComponentVisible} />
      <GoogleMap
        mapContainerStyle={containerStyle}
        center={center}
        zoom={zoom}
        onLoad={onLoad}
        onUnmount={onUnmount}
        options={{
          disableDefaultUI: true,
          styles: myStyles,
          minZoom: 3,
          maxZoom: 15,
        }}
      >
        <MarkerClusterer
          gridSize={80}
          maxZoom={10}
          zoomOnClick={true}
          averageCenter={true}
          minimumClusterSize={5}
          styles={[
            {
              url: "/mapcluster.png",
              height: imageSize,
              width: imageSize,
              textColor: "#000",
              textSize: 30,
            },
            // ... more styles
          ]}
          // imagePath="path/to/your/image"
        >
          {(clusterer) => (
            <>
              {data
                ?.filter((item) => item.images.length > 0)
                .map((item, index) => (
                  <MarkerComponent
                    key={index}
                    item={item}
                    zoomLevel={zoomLevel}
                    clusterer={clusterer}
                  />
                ))}
            </>
          )}
        </MarkerClusterer>
      </GoogleMap>
      {isUploadComponentVisible && (
        <UploadComponent
          setIsUploadComponentVisible={setIsUploadComponentVisible}
          setData={setData}
        />
      )}
    </>
  ) : (
    <></>
  );
}

export default React.memo(Map, (prevProps, nextProps) => {
  return JSON.stringify(prevProps.data) === JSON.stringify(nextProps.data);
});
