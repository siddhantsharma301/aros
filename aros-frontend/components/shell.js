import { useState, useEffect } from "react";
import {
  KeyIcon,
  PhotoIcon,
} from "@heroicons/react/24/outline";
import GridCards from "./gridCards";
import ImageCards from "./imageCards";

const navigation = [
  { name: "Public Key Registry", icon: KeyIcon, current: true },
  { name: "Image Signatures", icon: PhotoIcon, current: false },
];

function classNames(...classes) {
  return classes.filter(Boolean).join(" ");
}

function createKey() {
//   fetch("/api/post-pubkey", {
//     method: "POST",
//     headers: {
//       "Content-Type": "application/json",
//     },
//     body: JSON.stringify({ userId: "ANJAAAAAN", pubKey: "xyzabc8437483DBC" }),
//   }).then((response) => response.json()).then((data) => {
//     console.log(data);
//     fetch("/api/get-pubkeys", {
//       method: "GET",
//       headers: {
//         "Content-Type": "application/json",
//       },
//     }).then((response) => response.json()).then((data) => {
//       console.log(data);
//     });
//   });
}

function createImage() {
  fetch("/api/post-image", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ hash:
      "LETSGOOOOOOOOOO", signature: "xyzabc8437483DBC" }),
  }).then((response) => response.json()).then((data) => {
    console.log(data);
    fetch("/api/get-images", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    }).then((response) => response.json()).then((data) => {
      console.log(data);
    });
  });
}

export default function Shell() {
  const [currentTab, setCurrentTab] = useState("Public Key Registry");
  const [pubKeys, setPubKeys] = useState([]);
  const [images, setImages] = useState([]);

  useEffect(() => {
    fetch("/api/get-pubkeys", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    }).then((response) => response.json()).then((data) => {
      setPubKeys(data.pubKeys);
      fetch("/api/get-images", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      }).then((response) => response.json()).then((data) => {
        setImages(data.images);
      });
    });
  }, []);

  return (
    <>
      <div>
        {/* Static sidebar for desktop */}
        <div className="hidden lg:fixed lg:inset-y-0 lg:z-50 lg:flex lg:w-72 lg:flex-col">
          <div className="flex grow flex-col gap-y-5 overflow-y-auto border-r border-gray-200 bg-indigo-600 px-6">
            <div className="flex h-16 shrink-0 items-center">
              <p className="font-bold text-3xl text-white mt-8">Aros</p>
            </div>
            <nav className="flex flex-1 flex-col">
              <ul role="list" className="flex flex-1 flex-col gap-y-7">
                <li>
                  <ul role="list" className="-mx-2 space-y-1">
                    {navigation.map((item) => (
                      <li key={item.name}>
                        <a
                          onClick={() => {
                            setCurrentTab(item.name);
                          }}
                          className={classNames(
                            item.name === currentTab
                              ? "bg-indigo-700 text-white"
                              : "text-indigo-200 hover:text-white hover:bg-indigo-700",
                            "group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold"
                          )}
                        >
                          <item.icon
                            className={classNames(
                              item.name === currentTab
                                ? "text-white"
                                : "text-indigo-200 group-hover:text-white",
                              "h-6 w-6 shrink-0"
                            )}
                            aria-hidden="true"
                          />
                          {item.name}
                        </a>
                      </li>
                    ))}
                  </ul>
                </li>
              </ul>
            </nav>
          </div>
        </div>

        <main className="py-10 lg:pl-72">
          <div className="px-4 sm:px-6 lg:px-8">
          {currentTab === "Public Key Registry" ? (
              <div>
                <p className="text-indigo-800 text-3xl font-bold">Public Key Registry</p>
                {/* <button onClick={createKey}>Create key</button> */}
                <div className="mt-8">
                <GridCards pubKeys={pubKeys} />
                </div>
              </div>
          ) : (
            <div>
              <div>
                <p className="text-indigo-800 text-3xl font-bold">Image Signatures</p>
                {/* <button onClick={createImage}>Create image</button> */}
                <div className="mt-8">
                <ImageCards images={images} />
                </div>
              </div>
            </div>
          )}
          </div>
        </main >
      </div >
    </>
  );
}
