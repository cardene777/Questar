import Image from "next/image";
import { Navigation } from "@/components/parts/Navigation";
import { useConnect } from "wagmi";
import { injected } from "wagmi/connectors";
import { Button } from "@/components/ui/button";

export function Header() {
  const { connect } = useConnect();
  return (
    <header className="flex w-full items-center justify-between px-10 py-5 bg-gray-100">
      <div className="logo">
        <Image
          src="/assets/images/cheer_wave/cheer_wave_logo.png"
          alt="Logo"
          width={80}
          height={80}
        />
      </div>
      <div className="navigation">
        <Navigation />
      </div>
      <Button onClick={() => connect({ connector: injected() })}>Connect Wallet</Button>
    </header>
  );
}
