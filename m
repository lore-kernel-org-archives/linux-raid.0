From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Sat, 4 Mar 2006 10:01:12 +0100
Message-ID: <20060304090112.GC2976@redhat.com>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <du6t39$be5$1@sea.gmane.org> <20060303133952.GA2976@redhat.com> <du9ju5$6c5$1@sea.gmane.org> <20060303222619.GB2976@redhat.com> <duahsu$tgn$1@sea.gmane.org>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <duahsu$tgn$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 04, 2006 at 12:01:50AM +0100, Mario 'BitKoenig' Holbe wrote:
> Heinz Mauelshagen <mauelshagen@redhat.com> wrote:
> > On Fri, Mar 03, 2006 at 03:30:29PM +0100, Mario 'BitKoenig' Holbe wrote:
> >> But when a dirty page is modified while it's being accessed, it stays
> >> dirty and gets cleaned (i.e. written to disk) later again, right?
> > A mirroring driver (eg. the MD raid1 personality), will access the dirty
> > page multiple times to store the data on multiple mirrors before the dirty
> > flag will be cleared during endio processing.
> 
> So the dirty flag *is* cleared even if the page was modified while the
> mirroring driver did access it?

Yes, *after* it accessed it multiple times in order to update the
mirrors in the set. The mirroring driver doesn't track such changes.
If it relies on static page content during updates of its mirrors, it
need to take a private copy of the page(s).

> 
> > o write gets through to first mirror
> > o page content gets changed
> > o second write gets through to other mirror
> ...
> > This is what I meant by well-behaved applications.
> > The DBMS will write to such (eventually) inconsistent blocks
> > *before* it'll read them back in hence removing the block-level inconsistency.
> >> And couldn't this happen even on swap without reboot inbetween when a
> >> page really needs to be read from disk?
> > It shouldn't, because page-ins will follow page-outs first.
> > Meanwhile the transient page table(s) will contain the disk address(es)
> > of the respective page(s).
> 
> But given the rough scenario above there *are* page-outs first.
> Wouldn't it be possible (in both cases: the DBMS as well as the swap
> scenario), that the now cleaned page is read in later from the first
> mirror and thus contains the old content which was written before it
> got changed, written to the other mirror and got cleared?

No, a write before another read will happen unless you
found an unknown bogus case ;)

Heinz

> 
> 
> regards
>    Mario
> -- 
> <jv> Oh well, config
> <jv> one actually wonders what force in the universe is holding it
> <jv> and makes it working
> <Beeth> chances and accidents :)
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
