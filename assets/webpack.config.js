import path from 'path'
import 'dotenv/config'
import AssetsManifest from 'webpack-assets-manifest'
import TerserJSPlugin from 'terser-webpack-plugin'
import CssMinimizerPlugin from 'css-minimizer-webpack-plugin'
import MiniCssExtractPlugin from 'mini-css-extract-plugin'
import CopyPlugin from 'copy-webpack-plugin'
import {CleanWebpackPlugin} from 'clean-webpack-plugin'

console.log(process.env);

const source = './src/'
const dist = '../modx/assets/app'

export default (env, options) => {
  const isProduction=options.mode === 'production';
  return {
    entry: path.resolve(source, 'index.js'),
    output: {
      path: path.resolve(dist),
      chunkFilename: isProduction
        ? 'js/[name].[contenthash:8].min.js'
        : 'js/[name].js',
      filename: isProduction
        ? 'js/[name].[contenthash:8].min.js'
        : 'js/[name].js'
    },
    target: 'web',
    optimization: {
      minimize: isProduction,
      minimizer: [
        new TerserJSPlugin({extractComments: false}),
        new CssMinimizerPlugin()
      ],
      splitChunks: {
        chunks: isProduction
          ? 'all'
          : 'async',
        maxInitialRequests: Infinity,
        cacheGroups: {
          vendor: {
            test: /[\\/]node_modules[\\/]/,
            reuseExistingChunk: true,
            name(module) {
              const packageName = module.context.match(/[\\/]node_modules[\\/](.*?)([\\/]|$)/)[1];
              return packageName.replace('@', '');
            },
          },
        },
      },
    },
    module: {
      rules: [{
        test: /\.scss$/,
        use: [
          // {loader: 'style-loader'},
          {loader: MiniCssExtractPlugin.loader},
          {loader: 'css-loader'},
          {
            loader: 'postcss-loader',
            options: {
              postcssOptions: {
                plugins: ['autoprefixer']
              },
            }
          },
          {loader: 'sass-loader'},
        ]
      }, {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
      }, /*{
        test: /\.(png|jpe?g|gif|webp|svg|eot|ttf|woff|woff2)$/,
        loader: 'file-loader',
        options: {
          outputPath: (url, resourcePath) => {
            return /fonts/.test(resourcePath)
              ? `fonts/${url}`
              : `images/${url}`
          },
          name: isProduction
            ? '[name].[contenthash:8].[ext]'
            : '[name].[ext]',
        }
      }*/]
    },
    plugins: [
      new CleanWebpackPlugin({
        verbose: false,
        cleanStaleWebpackAssets: true,
        // dry: isProduction,
      }),
      new AssetsManifest({
        output: path.resolve(dist, 'manifest.json'),
        publicPath: true,
      }),
      new CopyPlugin({
        patterns: [
          {from: path.resolve(source, 'images'), to: path.resolve(dist, 'images'), noErrorOnMissing: true},
          {from: path.resolve(source, 'fonts'), to: path.resolve(dist, 'fonts'), noErrorOnMissing: true}
        ],
      }),
      new MiniCssExtractPlugin({
        chunkFilename: isProduction
          ? 'css/[name].[contenthash:8].min.css'
          : 'css/[name].css',
        filename: isProduction
          ? 'css/[name].[contenthash:8].min.css'
          : 'css/[name].css',
      }),
    ],
    devServer: {
      static: {
        directory: path.resolve(dist),
        watch: true,
      },
      port: 9000,
      allowedHosts:process.env.DOMAIN,
      devMiddleware: {
        writeToDisk: true,
      },
      liveReload: true,
      hot: false,
    },
    stats: 'minimal',
  }
}
