From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: a couple of mdadm questions
Date: Fri, 12 Sep 2003 12:58:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16225.13912.984465.921673@notabene.cse.unsw.edu.au>
References: <1062879895.8172.20.camel@opus>
	<16220.10893.339884.282892@gargle.gargle.HOWL>
	<1063029205.22120.4.camel@opus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from seth vidal on  September 8
To: seth vidal <skvidal@phy.duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  September 8, skvidal@phy.duke.edu wrote:
> 
> > Probably.  What is the actual message?
> 
> All of the output attached below:
> 
> raid5: using function: p5_mmx (2653.200 MB/sec)
> md: raid5 personality registered as nr 4
> Journalled Block Device driver loaded
> md: Autodetecting RAID arrays.
>  [events: 00000053]
>  [events: 00000053]
>  [events: 00000053]
> md: autorun ...
> md: considering sdf1 ...
> md:  adding sdf1 ...
> md:  adding sde1 ...
> md:  adding sdc1 ...
> md: created md1
> md: bind<sdc1,1>
> md: bind<sde1,2>
> md: bind<sdf1,3>
> md: running: <sdf1><sde1><sdc1>
> md: sdf1's event counter: 00000053
> md: sde1's event counter: 00000053
> md: sdc1's event counter: 00000053
> md1: former device sdb1 is unavailable, removing from array!
> md1: former device sdd1 is unavailable, removing from array!
> md1: former device sdg1 is unavailable, removing from array!
> md1: former device sdh1 is unavailable, removing from array!

Looks like sd[bdgh]1 are *not* marked as auto-detect-raid in the
partition table.  Use fdisk/cfdisk to check.

NeilBrown
