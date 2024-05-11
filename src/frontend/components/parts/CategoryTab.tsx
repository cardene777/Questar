import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { PaginationComponent } from "@/components/parts/PaginationComponent";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { CardItem } from "@/components/parts/Card";

export function CategoryTab() {
  const [cardCount, setCardCount] = useState(0);

  useEffect(() => {
    async function fetchCardData() {
      const data = { count: 10 }; // ここでAPIからデータを取得する想定
      setCardCount(data.count);
    }

    fetchCardData();
  }, []);

  const getRandomDate = () => {
    const today = new Date();
    const randomDays = Math.floor(Math.random() * 91); // 0日から90日のランダム
    today.setDate(today.getDate() + randomDays);
    return today.toISOString().split("T")[0]; // YYYY-MM-DD 形式で返す
  };

  return (
    <Tabs defaultValue="nft" className="w-full px-24">
      <TabsList className="grid w-full grid-cols-3">
        <TabsTrigger value="nft">NFT</TabsTrigger>
        <TabsTrigger value="native-token">Native Token</TabsTrigger>
        <TabsTrigger value="token">Token</TabsTrigger>
      </TabsList>
      <TabsContent value="nft">
        <Card>
          <CardHeader>
            <CardTitle>NFT</CardTitle>
            <CardDescription>NFT Giveaway or Airdrop</CardDescription>
          </CardHeader>
          <CardContent className="space-y-2">
            <div className="flex flex-wrap justify-center gap-4 px-10">
              {Array.from({ length: cardCount }).map((_, index) => (
                <CardItem key={index} targetDate={getRandomDate()} />
              ))}
            </div>
          </CardContent>
          <CardFooter>
            <PaginationComponent />
          </CardFooter>
        </Card>
      </TabsContent>
      <TabsContent value="native-token">
        <Card>
          <CardHeader>
            <CardTitle>Native Token</CardTitle>
            <CardDescription>Native Token Giveaway or Airdrop</CardDescription>
          </CardHeader>
          <CardContent className="space-y-2">
            <div className="flex flex-wrap justify-center gap-4 px-10">
              {Array.from({ length: cardCount }).map((_, index) => (
                <CardItem key={index} targetDate={getRandomDate()} />
              ))}
            </div>
          </CardContent>
          <CardFooter>
            <PaginationComponent />
          </CardFooter>
        </Card>
      </TabsContent>
      <TabsContent value="token">
        <Card>
          <CardHeader>
            <CardTitle>Token</CardTitle>
            <CardDescription>Token Giveaway or Airdrop</CardDescription>
          </CardHeader>
          <CardContent className="space-y-2">
            <div className="flex flex-wrap justify-center gap-4 px-10">
              {Array.from({ length: cardCount }).map((_, index) => (
                <CardItem key={index} targetDate={getRandomDate()} />
              ))}
            </div>
          </CardContent>
          <CardFooter>
            <PaginationComponent />
          </CardFooter>
        </Card>
      </TabsContent>
    </Tabs>
  );
}
