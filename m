From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 11:37:49 -0600
Message-ID: <cccedfc60712190937i4d562349s88980de1d154b2fd@mail.gmail.com>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
	 <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se>
	 <Pine.LNX.4.64.0712191002580.2468@p34.internal.lan>
	 <476957A7.5010805@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476957A7.5010805@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/19/07, Bill Davidsen <davidsen@tmr.com> wrote:
> As other posts have detailed, putting the partition on a 64k aligned
> boundary can address the performance problems. However, a poor choice of
> chunk size, cache_buffer size, or just random i/o in small sizes can eat
> up a lot of the benefit.
>
> I don't think you need to give up your partitions to get the benefit of
> alignment.

How might that benefit be realized?
Assume I have 3 disks, /dev/sd{b,c,d} all partitioned identically with
4 partitions, and I want to use /dev/sd{b,c,d}3 for a new SW raid.

What sequence of steps can I take to ensure that my raid is aligned on
a 64K boundary?
What effect do the different superblock formats have, if any, in this situation?

-- 
Jon
