From: Phillip Susi <psusi@ubuntu.com>
Subject: --no-degraded doesn't work
Date: Wed, 05 Jun 2013 11:13:57 -0400
Message-ID: <51AF55B5.8060704@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It seems that --no-degraded and/or incremental assembly does not
refuse to start a degraded array if one of the disks shows as being
removed already, possibly by an explicit fail/remove at runtime, or
manually starting the array without --no-degraded once.

Shouldn't --no-degraded refuse to start a degraded array even if the
missing disk already has been removed from the disk table in the
superblock?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRr1W1AAoJEJrBOlT6nu75E5QIAMA7FQ7gu8E1ZS2IJSiik7Ap
3JgEvt7vGlWEU8zexQHgmX7zbzIv1X7WaQfUNBdRfy8ZA2sUluv8LaiRqo4b4lSJ
kP5/cYvDJo61PkyTDEFm6dG7V7zTiyVRwns+m2UrafMN0zy3O4Mm7ix+wrjitMsU
IcRODfPvOoZ2wMcdlhSlK83vQcEG5gLKSOzCpVpai6a7m+HMDf9eTIm6iZbbjg1h
Kbov0TNiHqa3zHUgaO60AxtclxQvytQpyrcqo6M4e/rRExNzuaRD3diIcMwJRClB
uj+KTG9L/ek3YhC1m+1B+18Phi+VrRL74V4BUzIUDK2ta2uY9UZbbqmMTtPA9bg=
=byYU
-----END PGP SIGNATURE-----
