"use client";

import * as React from "react";
import Link from "next/link";
import Image from "next/image";

import { cn } from "@/lib/utils";
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  NavigationMenuTrigger,
  navigationMenuTriggerStyle,
} from "@/components/ui/navigation-menu";

const components: { title: string; href: string; description: string }[] = [
  {
    title: "Artist",
    href: "/docs/primitives/alert-dialog",
    description: "Artist.",
  },
  {
    title: "Engineer",
    href: "/docs/primitives/hover-card",
    description: "Engineer.",
  },
  {
    title: "Youtuber",
    href: "/docs/primitives/progress",
    description: "Youtuber.",
  },
  {
    title: "Influencer",
    href: "/docs/primitives/scroll-area",
    description: "Influencer.",
  },
  {
    title: "Blogger",
    href: "/docs/primitives/tabs",
    description: "Blogger.",
  },
  {
    title: "Podcaster",
    href: "/docs/primitives/tooltip",
    description: "Podcaster.",
  },
];

export function Navigation() {
  return (
    <NavigationMenu>
      <NavigationMenuList>
        <NavigationMenuItem>
          <NavigationMenuTrigger>Start Cheer</NavigationMenuTrigger>
          <NavigationMenuContent>
            <ul className="grid gap-3 p-6 md:w-[400px] lg:w-[500px] lg:grid-cols-[.75fr_1fr]">
              <li className="row-span-3">
                <NavigationMenuLink asChild>
                  <a
                    className="flex h-full w-full select-none flex-col rounded-md bg-gradient-to-b from-muted/50 to-muted p-6 no-underline outline-none focus:shadow-md justify-center items-center"
                    href="/"
                  >
                    {/* <Icons.logo className="h-6 w-6" /> */}
                    <div className="mb-2 mt-4 text-lg font-medium">
                      Cheer Wave?
                    </div>
                    <Image
                      src="/assets/images/cheer_wave/cheer_wave_logo.png"
                      alt="Logo"
                      width={100}
                      height={80}
                    />
                  </a>
                </NavigationMenuLink>
              </li>
              <ListItem href="/docs" title="Patron Ranking">
                Ranking dashboard for amount and number of support.
              </ListItem>
              <ListItem href="/docs/installation" title="Contents Creator">
                List of Content Creators.
              </ListItem>
            </ul>
          </NavigationMenuContent>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuTrigger>Category</NavigationMenuTrigger>
          <NavigationMenuContent>
            <ul className="grid w-[400px] gap-3 p-4 md:w-[500px] md:grid-cols-2 lg:w-[600px] ">
              {components.map((component) => (
                <ListItem
                  key={component.title}
                  title={component.title}
                  href={component.href}
                >
                  {component.description}
                </ListItem>
              ))}
            </ul>
          </NavigationMenuContent>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <Link href="/docs" legacyBehavior passHref>
            <NavigationMenuLink className={navigationMenuTriggerStyle()}>
              Documentation
            </NavigationMenuLink>
          </Link>
        </NavigationMenuItem>
      </NavigationMenuList>
    </NavigationMenu>
  );
}

const ListItem = React.forwardRef<
  React.ElementRef<"a">,
  React.ComponentPropsWithoutRef<"a">
>(({ className, title, children, ...props }, ref) => {
  return (
    <li>
      <NavigationMenuLink asChild>
        <a
          ref={ref}
          className={cn(
            "block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
            className
          )}
          {...props}
        >
          <div className="text-sm font-medium leading-none">{title}</div>
          <p className="line-clamp-2 text-sm leading-snug text-muted-foreground">
            {children}
          </p>
        </a>
      </NavigationMenuLink>
    </li>
  );
});
ListItem.displayName = "ListItem";
