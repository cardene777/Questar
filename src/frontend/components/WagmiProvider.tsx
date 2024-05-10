"use client";
import { WagmiProvider as WagmiProviderOriginal } from "wagmi";
import { config } from "@lib/WagmiConfig";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

export function WagmiProvider({ children }: { children: React.ReactNode }) {
    const queryClient = new QueryClient();
  return (
    <WagmiProviderOriginal config={config}>
        <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    </WagmiProviderOriginal>
  );
}
