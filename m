From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Is partition alignment needed for RAID partitions ?
Date: Thu, 02 Jan 2014 14:49:53 -0500
Message-ID: <52C5C2E1.9060906@ubuntu.com>
References: <52C08E63.8020800@insync.za.net> <52C11929.3070600@hardwarefreak.com> <52C12F8B.6080507@insync.za.net> <52C14FB8.8080005@hardwarefreak.com> <52C162A7.1080309@insync.za.net> <52C1A8F0.2030208@hardwarefreak.com> <52C2184B.5030403@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C2184B.5030403@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>, stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/30/2013 8:05 PM, Pieter De Wit wrote:
> 1) pvmove isn't as fast as I think - it might be due to some
> checksums or some other process (I know it creates a small mirror
> of a PE and then breaks it - rinse repeat for all PEs)

It doesn't actually work this way.  The man page makes it sound like
it does ( though not for every individual PE -- it uses the nebulous
term "checkpoint" ), but it turns out that in practice, there's no
such thing and it just makes one big mirror to sync as many contiguous
PEs as it can.  This can be rather annoying when you decide to reboot
85% of the way through a 1 TB pvmove and it starts over at the beginning.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSxcLhAAoJEI5FoCIzSKrw4N8H/i5M74R1CJQTbptxE5lBelLP
/ESQb/zKIDD4eEodmg4oowh260trV6u91+WBbPYcZVtQ1bPK/4kMkuH8pRVKpnvw
nQghIjKGyaPAfzGHpHxyqM/xibIwHl3doTM+Ld17jjilyYVfv/QcERn9QjYSG2pM
Isl3H+C51BMQcOPdCHUeNml5mqBxA6QB3eYkSXvtKVkbBRs1r+nOJObizwrRld5B
gFDGRmEbi40GpROCbxFPDZPqpz5wKygf+/PFm1VHt1Hsiib5rndabcsJdB9H8SqK
PDw33Qa7GRTkpWdXRhDnxJq3uXNXnF74IGtTPYS2eTZL+ljORgMq24BMo5bPLl8=
=HgAd
-----END PGP SIGNATURE-----
