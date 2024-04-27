import Image from "next/image";
import { NavigationMenuDemo } from "@/components/Navigation";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-start h-screen p-24">
      <NavigationMenuDemo />

    </main>
  );
}
