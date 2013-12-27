From: keld@keldix.com
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 19:26:24 +0100
Message-ID: <20131227182624.GA14158@www5.open-std.org>
References: <52BD8EDD.10809@assyoma.it> <52BD99BC.8000205@assyoma.it> <21181.46549.590241.76206@tree.ty.sabi.co.uk> <52BDB9C0.2020906@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52BDB9C0.2020906@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 27, 2013 at 06:32:48PM +0100, Gionatan Danti wrote:
> ><snip>
> >Therefore the *probability* of loss of data because of 2 member
> >devices failing is higher in layout 1) than layout 2), whether
> >or not the drives are "adjacent".
> >
> >   Note that arguably layout 1) is not really RAID10, because an
> >   important property of RAID10 is or should be that there are
> >   only N/2 pairs out of N drives. Otherwise it is not quite
> >   'RAID1' if a chunk position in a stripe can be replicated on 2
> >   other devices, half the replicas on one and half on another.
> >
> >That the member devices are *adjacent* is irrelevant; what
> >matters is the statistical chance, which is driven by the
> >percent of cases where 2 failures result in data loss, which
> >driven by the number of paired drives.
> 
> Very detailed answer, thank you Peter :)
> 
> Based on what keld told before, the current scheme if n.2 (wikipedia's 
> one), right? It is possible, using mdadm, understand the physical layout 
> (if n.1 or n.2) of a live RAID10 array?
> 
> As schema n.1 lead to increased probability of data loss, why offset 
> layout use it instead of, say, some variance of schema n.2?

I am not sure of the probabilities on chances of surviving more
than 1 failing drive for the offset layout, but my intuition tells
me it is rather bad. As it shifts the blocks one block at a time,
my guts feeling is that it really cannot survive more than one
failing disk.

On the other hand raid10,far in the second layout (wikipedia - and 
I am the author of the text:-) I am quite sure that the layout is 
theoretically optimal, as you in the luckiest case can survive
n/2 drives failing, where n is your number of drives, and it is
integer division...  I did the design of this layout for maximum
redundancy. 

The main reason for chosing raid10,far is that it is faster
for single reads, a speed of raid0, while for other operations it is 
about the same. For degraded arrays raid10,far is probably worse
than the other raid10 types, while the IO scheduling algorithm
probably remedies some of the bad raw performance on the degraded
raid10,far.

Also the use of inner and faster sectors of a hard drive gives
raid10,far an edge towards the other raid10 types.

Best regards
Keld
