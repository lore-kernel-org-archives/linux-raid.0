From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sat, 27 Oct 2007 17:07:36 +0200
Message-ID: <20071027150735.GD6116@boogie.lpds.sztaki.hu>
References: <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com> <20071026091513.GB32550@percy.comedia.it> <1193426793.10336.302.camel@firewall.xsintricity.com> <20071027075054.GA12053@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071027075054.GA12053@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 27, 2007 at 09:50:55AM +0200, Luca Berra wrote:

>> Because you didn't stripe align the partition, your bad.
> :)
> by default fdisk misalignes partition tables
> and aligning them is more complex than just doing without.

Why use fdisk then? Use parted instead. It's not the kernel's fault if
you use tools not suited for a given task...

>> Linux works properly with a partition table, so this is a specious
>> statement.
> It should also work properly without one.

It does:

sd 0:0:2:0: [sdc] Very big device. Trying to use READ CAPACITY(16).
sd 0:0:2:0: [sdc] 7812333568 512-byte hardware sectors (3999915 MB)
sd 0:0:2:0: [sdc] Write Protect is off
sd 0:0:2:0: [sdc] Mode Sense: 23 00 00 00
sd 0:0:2:0: [sdc] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
 sdc: unknown partition table

Works perfectly without any partition tables...

You seem to be annoyed because the kernel tells you that there is no
partition table it recognizes - but if that bothers you so, simply stop
reading the kernel logs. My kernel also tells me that it failed to find
an AGP bridge - by your logic that should mean that everyone still using
AGP-capable motherboards should toss their system to the junkyard?!?

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
