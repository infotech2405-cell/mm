import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  /* config options here */
  typescript: {
    ignoreBuildErrors: true,
  },
  reactStrictMode: false,
  allowedDevOrigins: ["192.168.0.110", "192.168.0.105"],
  async rewrites() {
    return [
      {
        source: "/api/analyze-spectrum",
        destination: "http://localhost:3030/api/analyze-spectrum",
      },
      {
        source: "/api/chat",
        destination: "http://localhost:3031/",
      },
    ];
  },
};

export default nextConfig;
