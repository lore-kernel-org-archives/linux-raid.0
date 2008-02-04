From: Neil Brown <neilb@suse.de>
Subject: Re: problem with spare, acive device, clean degrated, reshaip RADI5, anybody can help ?
Date: Mon, 4 Feb 2008 11:44:21 +1100
Message-ID: <18342.24549.433129.798288@notabene.brown>
References: <1153106913.20080131033456@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas-Sokov on Thursday January 31
Sender: linux-raid-owner@vger.kernel.org
To: Andreas-Sokov <andre.s@j8.com.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 31, andre.s@j8.com.ru wrote:
> Hello linux-raid.
> 
> i have DEBIAN.
> 
> raid01:/# mdadm -V
> mdadm - v2.6.4 - 19th October 2007
> 
> raid01:/# mdadm -D /dev/md1
> /dev/md1:
>         Version : 00.91.03
>   Creation Time : Tue Nov 13 18:42:36 2007
>      Raid Level : raid5
....
>   Delta Devices : 1, (4->5)

So the array is in the middle of a "reshape".

It should automatically complete...  Presumably it isn't doing that?

What does
   cat /proc/mdstat
say?

Where kernel log messages do you get when you assemble the array?


The spare device will not be added to the array until the reshape has
finished.

Hopefully you aren't using a 2.6.23 kernel?
That kernel had a bug which corrupted data when reshaping a degraded
raid5 array.

NeilBrown
