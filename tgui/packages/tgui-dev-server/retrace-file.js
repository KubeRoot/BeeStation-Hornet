import { loadSourceMaps, retrace } from './link/retrace.js';
import fs from 'fs';
import { createRequire } from 'module';
import { createLogger } from 'common/logging.js';
import { dirname } from 'path';

const main = async () => {
  const logger = createLogger('retracer');

  const printUsage = () => {
    logger.log(`Usage:\n${process.argv0} path`);
  };

  if (process.argv.length < 3)
  {
    printUsage();
    return;
  }

  const path = process.argv[2];
  let text;

  try {
    text = fs.readFileSync(path, "ASCII");
  }
  catch (error)
  {
    logger.log(error);
    printUsage();
  }

  const requireFromRoot = createRequire(dirname(import.meta.url) + '/../..');
  const webpack = await requireFromRoot('webpack');
  const createConfig = await requireFromRoot('./webpack.config.js');
  const config = createConfig({}, { 'mode': 'production' });

  await loadSourceMaps(config.output.path);

  logger.log(retrace(text));
};

main();