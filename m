From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 23:25:16 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0304032323580.6681@ddx.a2000.nu>
References: <Pine.GSO.4.30.0304030858080.20118-100000@multivac.sdsc.edu>
 <Pine.LNX.4.53.0304032104070.3085@ddx.a2000.nu> <1049403752.22426.5146.camel@ezran.goshen.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1049403752.22426.5146.camel@ezran.goshen.edu>
To: Ezra Nugroho <ezran@goshen.edu>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 3 Apr 2003, Ezra Nugroho wrote:

> What should I expect from a 8 drive raid 5 on 3ware 7500-8?
> I get only
> /dev/sda:
>  Timing buffer-cache reads:   128 MB in  0.74 seconds =172.97 MB/sec
>  Timing buffered disk reads:  64 MB in  1.55 seconds = 41.29 MB/sec
>
> which seems to be slow compared to the numbers above

I think you should look at the '3ware bad write speed' thread on
linux-raid
looks like you are running in 3ware raid mode ?
