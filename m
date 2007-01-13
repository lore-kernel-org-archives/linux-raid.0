From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Sat, 13 Jan 2007 02:20:25 -0700
Message-ID: <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>
	 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>
	 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/12/07, James Ralston <qralston+ml.linux-raid@andrew.cmu.edu> wrote:
> On 2007-01-12 at 09:39-08 dean gaudet <dean@arctic.org> wrote:
>
> > On Thu, 11 Jan 2007, James Ralston wrote:
> >
> > > I'm having a discussion with a coworker concerning the cost of
> > > md's raid5 implementation versus hardware raid5 implementations.
> > >
> > > Specifically, he states:
> > >
> > > > The performance [of raid5 in hardware] is so much better with
> > > > the write-back caching on the card and the offload of the
> > > > parity, it seems to me that the minor increase in work of having
> > > > to upgrade the firmware if there's a buggy one is a highly
> > > > acceptable trade-off to the increased performance.  The md
> > > > driver still commits you to longer run queues since IO calls to
> > > > disk, parity calculator and the subsequent kflushd operations
> > > > are non-interruptible in the CPU.  A RAID card with write-back
> > > > cache releases the IO operation virtually instantaneously.
> > >
> > > It would seem that his comments have merit, as there appears to be
> > > work underway to move stripe operations outside of the spinlock:
> > >
> > >     http://lwn.net/Articles/184102/
> > >
> > > What I'm curious about is this: for real-world situations, how
> > > much does this matter?  In other words, how hard do you have to
> > > push md raid5 before doing dedicated hardware raid5 becomes a real
> > > win?
> >
> > hardware with battery backed write cache is going to beat the
> > software at small write traffic latency essentially all the time but
> > it's got nothing to do with the parity computation.
>
> I'm not convinced that's true.
No, it's true.  md implements a write-through cache to ensure that
data reaches the disk.

>What my coworker is arguing is that md
> raid5 code spinlocks while it is performing this sequence of
> operations:
>
>     1.  executing the write
not performed under the lock
>     2.  reading the blocks necessary for recalculating the parity
not performed under the lock
>     3.  recalculating the parity
>     4.  updating the parity block
>
> My [admittedly cursory] read of the code, coupled with the link above,
> leads me to believe that my coworker is correct, which is why I was
> for trolling for [informed] opinions about how much of a performance
> hit the spinlock causes.
>
The spinlock is not a source of performance loss, the reason for
moving parity calculations outside the lock is to maximize the benefit
of using asynchronous xor+copy engines.

The hardware vs software raid trade-offs are well documented here:
http://linux.yyz.us/why-software-raid.html

Regards,
Dan
