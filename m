From: Ezra Nugroho <ezran@goshen.edu>
Subject: Re: RAID 5 performance problems
Date: 03 Apr 2003 16:02:32 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1049403752.22426.5146.camel@ezran.goshen.edu>
References: <Pine.GSO.4.30.0304030858080.20118-100000@multivac.sdsc.edu>
	<Pine.LNX.4.53.0304032104070.3085@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0304032104070.3085@ddx.a2000.nu>
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> here benchmark from my system with an fasttrak-tx4 (same card jonathan
> has) with WD1800BB :
> 
> /dev/hde:
>  Timing buffer-cache reads:   128 MB in  0.28 seconds =457.14 MB/sec
>  Timing buffered disk reads:  64 MB in  1.37 seconds = 46.72 MB/sec
> 
> WD1800BB on onboard ultra100 controller :
> 
> /dev/hdo:
>  Timing buffer-cache reads:   128 MB in  0.28 seconds =457.14 MB/sec
>  Timing buffered disk reads:  64 MB in  1.58 seconds = 40.51 MB/sec
> 
> WD1800BB on onboard ultra33 controller :
> 
> /dev/hda:
>  Timing buffer-cache reads:   128 MB in  0.28 seconds =457.14 MB/sec
>  Timing buffered disk reads:  64 MB in  2.55 seconds = 25.10 MB/sec

What should I expect from a 8 drive raid 5 on 3ware 7500-8?
I get only 
/dev/sda:
 Timing buffer-cache reads:   128 MB in  0.74 seconds =172.97 MB/sec
 Timing buffered disk reads:  64 MB in  1.55 seconds = 41.29 MB/sec

which seems to be slow compared to the numbers above
 
