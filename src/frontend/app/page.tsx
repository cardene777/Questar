"use client";

import { Header } from "@/components/parts/Header";
import { CarouselPlugin } from "@/components/parts/Carousel";
import { CategoryTab } from "@/components/parts/CategoryTab";

export default function Home() {

  return (
    <main className="flex min-h-screen flex-col items-center justify-between">
      <Header /> {/* Header コンポーネントを使用 */}
      <CarouselPlugin />
      <CategoryTab />
    </main>
  );
}
