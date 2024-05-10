import * as React from "react";

import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import Image from "next/image";

export function CardItem() {
  return (
    <Card className="w-[350px]">
      <Image
        src="/assets/images/cheer_wave/cheer_wave.png"
        alt="logo"
        width={350}
        height={100}
      />
      <CardHeader>
        <CardTitle>Cardene</CardTitle>
        <CardDescription>Support cardene.</CardDescription>
      </CardHeader>
      <CardContent>
        <form>
          <div className="grid w-full items-center gap-4">
            <div className="flex flex-col space-y-1.5">
              <Label htmlFor="framework">Cheer Token</Label>
              <Select>
                <SelectTrigger id="framework">
                  <SelectValue placeholder="Select" />
                </SelectTrigger>
                <SelectContent position="popper">
                  <SelectItem value="eth">ETH</SelectItem>
                  <SelectItem value="dai">DAI</SelectItem>
                  <SelectItem value="usdc">USDC</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="flex flex-col space-y-1.5">
              <Label htmlFor="name">Cheer Amount</Label>
              <Input id="name" placeholder="Amount of tokens to support" />
            </div>
            <div className="flex flex-col space-y-1.5">
              <Label htmlFor="framework">Cheer Flow Rate</Label>
              <Select>
                <SelectTrigger id="framework">
                  <SelectValue placeholder="Select" />
                </SelectTrigger>
                <SelectContent position="popper">
                  <SelectItem value="next">3 month</SelectItem>
                  <SelectItem value="sveltekit">6 month</SelectItem>
                  <SelectItem value="astro">1 years</SelectItem>
                  <SelectItem value="nuxt">3 years</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </form>
      </CardContent>
      <CardFooter className="flex justify-center">
        <Button>Cheer</Button>
      </CardFooter>
    </Card>
  );
}
