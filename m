From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Fri, 3 Mar 2006 23:26:19 +0100
Message-ID: <20060303222619.GB2976@redhat.com>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <du6t39$be5$1@sea.gmane.org> <20060303133952.GA2976@redhat.com> <du9ju5$6c5$1@sea.gmane.org>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <du9ju5$6c5$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 03, 2006 at 03:30:29PM +0100, Mario 'BitKoenig' Holbe wrote:
> Heinz Mauelshagen <mauelshagen@redhat.com> wrote:
> > The fact that mirrors in a RAID1 set partially differ even on propper
> > shutdown is caused by the ability to change dirty pages *while* they
> > are being accessed (ie. by a mirroring driver).
> 
> That's quite the scenario what I thought about, but more clear now,
> thanks.
> But when a dirty page is modified while it's being accessed, it stays
> dirty and gets cleaned (i.e. written to disk) later again, right?

Well, cleaing a dirty page isn't a 1:1 action with respect to writing.
A mirroring driver (eg. the MD raid1 personality), will access the dirty
page multiple times to store the data on multiple mirrors before the dirty
flag will be cleared during endio processing.

> This
> would imply that the mirrors should always be equal after a clean
> shutdown, which in fact is not true.

Think roughly:

o page gets dirtied
o page gets handed to mirroring driver
o mirroring driver initiates writes to all mirrors
o write gets through to first mirror
o page content gets changed
o second write gets through to other mirror

> 
> > Mind you that this is a block level inconsistency only, because the
> ...
> > An example for a filesystem causing this is a file write followed
> > by a file truncation.
> 
> Yes, this is also quite similar to the scenario what I thought about -
> especially it suggests that this case happens only on "free" space.
> 
> However, Kaspers case is a bit different, since it involves swap space,
> which leads to the suspicion that there are cases where mirror
> differences could occur also on "non-free" space (although there is
> of course also something like "free" space on swap and one had to
> analyze if it's such space that is affected, which most likely isn't
> the simplest thing at all :)). While swap is probably quite robust
> against such a scenario, since it's not valid after a reboot anymore,

Yes. This is a don't care.

> I could imagine other cases (i.e. database raw devices) where subsequent
> reads lead to different data due to the different mirrors, isn't it?

This is what I meant by well-behaved applications.
The DBMS will write to such (eventually) inconsistent blocks
*before* it'll read them back in hence removing the block-level inconsistency.

> And couldn't this happen even on swap without reboot inbetween when a
> page really needs to be read from disk?

It shouldn't, because page-ins will follow page-outs first.
Meanwhile the transient page table(s) will contain the disk address(es)
of the respective page(s).

Heinz

> 
> 
> regards
>    Mario
> -- 
> File names are infinite in length where infinity is set to 255 characters.
>                                 -- Peter Collinson, "The Unix File System"
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
