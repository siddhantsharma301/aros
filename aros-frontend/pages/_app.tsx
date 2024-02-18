import '../styles/globals.css'
import type { AppProps } from 'next/app'
import toast, { Toaster } from 'react-hot-toast';

export default function App({ Component, pageProps }: AppProps) {
  return <div><Component {...pageProps} /><Toaster /></div>
}
