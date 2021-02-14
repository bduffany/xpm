import App from 'next/app';
import './app.css';

export default class CustomApp extends App {
  render() {
    const { Component, pageProps } = this.props;
    return <Component {...pageProps} />;
  }
}
