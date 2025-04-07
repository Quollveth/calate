import { defineConfig, PluginOption } from "vite";
import react from "@vitejs/plugin-react-swc";
import tailwindcss from "@tailwindcss/vite";
import path from "path";

// https://vite.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      // @ is project root
      "@": path.resolve(__dirname, ""),
    },
  },
  plugins: [react(), tailwindcss()] as PluginOption[],
});
