import React, { useState, useEffect } from "react";

import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import Image from "next/image";

const calculateTimeLeft = (targetDate: string) => {
  const difference = +new Date(targetDate) - +new Date();
  let timeLeft = {};

  if (difference > 0) {
    timeLeft = {
      days: Math.floor(difference / (1000 * 60 * 60 * 24)),
      hours: Math.floor((difference / (1000 * 60 * 60)) % 24),
      minutes: Math.floor((difference / 1000 / 60) % 60),
      seconds: Math.floor((difference / 1000) % 60),
    };
  }

  return timeLeft;
}



export function CardItem({ targetDate }: { targetDate: string }) {
  const [timeLeft, setTimeLeft] = useState<any>(calculateTimeLeft(targetDate));

  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft(calculateTimeLeft(targetDate));
    }, 1000);

    return () => clearInterval(timer);
  }, [targetDate]); // targetDateを依存関係に追加

  const timerComponents: any[] = [];

  Object.keys(timeLeft).forEach((interval) => {
    if (!timeLeft[interval]) {
      return;
    }
    const colorClass =
      interval === "days"
        ? "text-green-500"
        : interval === "hours"
        ? "text-green-500"
        : interval === "minutes"
        ? "text-green-500"
        : "text-green-500";

    timerComponents.push(
      <span key={interval} className={`text-lg font-bold ${colorClass} mr-2 h-12`}>
        {timeLeft[interval]} {interval}{" "}
      </span>
    );
  });

  return (
    <Card className="w-[350px]">
      <Image
        src="/assets/images/questar/questar.png"
        alt="logo"
        width={350}
        height={100}
      />
      <CardHeader>
        <CardTitle>NFT Giveaway!!!</CardTitle>
        <CardDescription>Cardene NFT Giveaway.</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="flex flex-col space-y-2">
          <p className="font-semibold">Time Limit</p>
          <p className="text-xl font-medium text-gray-700 flex items-center justify-center mt-2">
            {timerComponents.length ? (
              timerComponents
            ) : (
              <span className="text-red-600 text-lg font-bold h-12 items-center">
                Time&apos;s up!
              </span>
            )}
          </p>
        </div>
      </CardContent>
      <CardFooter className="flex justify-center">
        <Button className="w-full bg-blue-300">Get</Button>
      </CardFooter>
    </Card>
  );
}
