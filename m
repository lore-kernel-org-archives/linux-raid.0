From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sat, 31 Jul 2004 10:44:50 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0407311042010.4528-100000@uplift.swm.pp.se>
References: <200407301116.42676.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407301116.42676.m.watts@eris.qinetiq.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 30 Jul 2004, Mark Watts wrote:

> Basically the system load goes orbital and responsivness goes out the window.
> gkrellm only shows ~1MB/sec of disk activity and the processors (Dual Opteron) 
> are twiddling their thumbs (top shows 100% 'wa' state for both processors), 
> yet I can hardly do anything with any open applications.

I have had good results with IRQ affinity on the 3ware 7500 (echo "0" >
/proc/irq/<X>/smp_affinity on my dual pIII machine. Definately makes 3dm
behave better anyway.

And yes, writing to a hardware raid5 on 3ware isn't fast, so I use scsi 
drives for anything that needs fast writes, and then use the 3ware for 
bulk storage (most of it write once read many).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

