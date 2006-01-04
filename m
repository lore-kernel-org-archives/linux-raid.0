From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid5 read performance
Date: Wed, 4 Jan 2006 10:14:42 +0200
Message-ID: <5d96567b0601040014y7f1410c3n665fd65aa15f435c@mail.gmail.com>
References: <5d96567b0601030616n42d95089pf6422002591b5d78@mail.gmail.com>
	 <Pine.LNX.4.44.0601031533460.14492-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0601031533460.14492-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I guess i was not clear enough.

i am using raid5 over 3 maxtor disks. the chunk size is 1MB.
i mesured the io coming from one disk alone when I READ
from it with 1MB buffers , and i know that it is ~32MB/s.

I created raid0 over two disks and my throughput grown to
64 MB/s.

Doing the same thing with raid5 ended in 32 MB/s.

I am using async io since i do not want to wait for several disks
when i send an IO. By sending a buffer which is striped aligned
i am supposed to have one to one relation between a disk and an
io.

iostat show that all of the three disks work but not fully.

On 1/3/06, Mark Hahn <hahn@physics.mcmaster.ca> wrote:
> > I am checking raid5 performance.
>
> reads or writes?
>
> > I am using asynchronous ios with buffer size as the stripe size.
>
> why do you think async matters?
>
> > In this case i am using a stripe size of 1M with 2+1 disks.
>
> do you mean that md says you have 512k chunks?
>
> > Unlike raid0 , raid5 drops the performance by 50% .
>
> that's slightly unclear: -50% relative to what?  a raw single disk?
> is this reads or writes?  strictly bandwidth, and if so, do you have
> multiple outstanding reads?
>
> > Is it because it does parity checkings ?
>
> non-degraded R5 doesn't do parity checks on reads, afaik.
>
>


--
Raz
