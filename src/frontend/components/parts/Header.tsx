import Image from "next/image";
import { Navigation } from "@/components/parts/Navigation";
import { useConnect, useAccount } from "wagmi";
import { injected } from "wagmi/connectors";
import { Button } from "@/components/ui/button";
import { useEffect, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus } from "@fortawesome/free-solid-svg-icons";

export function Header() {
  const { connect } = useConnect();
  const account = useAccount();

  const [displayAddress, setDisplayAddress] = useState("Connect Wallet");

  useEffect(() => {
    if (account?.address) {
      setDisplayAddress(
        `${account.address.substring(0, 6)}...${account.address.substring(
          account.address.length - 4
        )}`
      );
    }
  }, [account?.address]);
  return (
    <header className="flex w-full items-center justify-between px-10 py-5 bg-gray-100">
      <div className="logo w-[300px]">
        <Image
          src="/assets/images/questar/questar.png"
          alt="Logo"
          width={80}
          height={80}
        />
      </div>
      <div className="navigation">
        <Navigation />
      </div>
      <div className="flex justify-center items-center space-x-6 w-[300px]">
        <Button
          className="flex justify-center items-center space-x-3 bg-[#37aeba] text-white font-semibold text-lg"
          onClick={() => connect({ connector: injected() })}
        >
          <FontAwesomeIcon icon={faPlus} className="h-5" />
          <p>Create Task</p>
        </Button>
        <Button onClick={() => connect({ connector: injected() })}>
          {displayAddress}
        </Button>
      </div>
    </header>
  );
}
