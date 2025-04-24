import NodeMediaServer from 'node-media-server';
import path from 'node:path';
import fs from 'node:fs';

/**
 * Sets up an RTMP/HLS media server for efficient video streaming
 */
export function setupStreamServer(): NodeMediaServer {
  const mediaDir = path.join(process.cwd(), 'media');
  if (!fs.existsSync(mediaDir)) {
    fs.mkdirSync(mediaDir, { recursive: true });
  }

  const config = {
    rtmp: {
      port: 1936,
      chunk_size: 4096,
      gop_cache: true,
      ping: 30,
      ping_timeout: 60
    },
    http: {
      port: 8001,
      allow_origin: '*',
      mediaroot: mediaDir
    }
  };

  const nms = new NodeMediaServer(config);

  nms.run();

  console.log('RTMP/HLS server running on ports 1936 (RTMP) and 8001 (HLS/HTTP)');

  return nms;
}