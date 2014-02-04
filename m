From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 04 Feb 2014 13:08:32 -0500
Message-ID: <52F12CA0.1030803@ubuntu.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com> <52EF3865.4000106@hardwarefreak.com> <52EFAACE.40906@ubuntu.com> <52F05ECD.5060804@hardwarefreak.com> <52F12A93.50408@SGI.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F12A93.50408@SGI.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larry Fenske <LFenske@SGI.com>, stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/4/2014 12:59 PM, Larry Fenske wrote:
> Perhaps Phillip is doing the obvious and only measuring throughput
> after the cache is full.

Or the obvious and dropping the cache first, the way hdparm -t does.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS8SygAAoJEI5FoCIzSKrwdesH/3ZuonrTN58MTmKalrdbmrvO
P9UJCY90Nzv57TBm6POzipDKe7cdBjBRSr97DU2Ea8yOqxTo9ErbbS2prUmDeC04
RrTUJnWw5eP5Zrt2TT4tnUJbKmmhxbXMxTPz8ZrzaV/2PJzh2PWbj5HjGgceyCVS
2V7iuMJfpPvL/EiiTm32gXVAp9FlWtOpiKdBg+eaD4UfLemYMObRScbhmS0+1XYh
lQ7Ce7RUE+y0zkgaeLSBDTpyUL+mVF6l9C2q0dxK8U2mhUChQl7RX81yk3ePD6DD
w+SzG+UaQjdNM9jbldHKdXSYT04u/ZX9KmZszFQGPRGvvw9tMxihjUmmawN9GWQ=
=2/Lt
-----END PGP SIGNATURE-----
