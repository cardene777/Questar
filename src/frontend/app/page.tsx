"use client";

import { useEffect, useState } from "react";
import { Header } from "@/components/parts/Header"; // Header コンポーネントをインポート
import { CardItem } from "@/components/parts/Card";

export default function Home() {
  const [cardCount, setCardCount] = useState(0);

  useEffect(() => {
    setCardCount(10); // 初期カード数を10に設定
  }, []);

  return (
    <main className="flex min-h-screen flex-col items-center justify-between">
      <Header /> {/* Header コンポーネントを使用 */}
      <div className="flex flex-wrap justify-center gap-4 mt-16 px-10">
        {Array.from({ length: cardCount }).map((_, index) => (
          <CardItem key={index} />
        ))}
      </div>
    </main>
  );
}
