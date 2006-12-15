From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Fri, 15 Dec 2006 12:41:02 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612151156130.26813@compserv1>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1>
 <200612132257.24399.a1426z@gawab.com> <Pine.GSO.4.53.0612141538410.6095@compserv1>
 <200612150802.55396.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200612150802.55396.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Nikolai Joukov wrote:
> > > Nikolai Joukov wrote:
> > > > We have designed a new stackable file system that we called RAIF:
> > > > Redundant Array of Independent Filesystems.
> > >
> > > Great!
> > >
> > > > We have performed some benchmarking on a 3GHz PC with 2GB of RAM and
> > > > U320 SCSI disks.  Compared to the Linux RAID driver, RAIF has
> > > > overheads of about 20-25% under the Postmark v1.5 benchmark in case of
> > > > striping and replication.  In case of RAID4 and RAID5-like
> > > > configurations, RAIF performed about two times *better* than software
> > > > RAID and even better than an Adaptec 2120S RAID5 controller.
> > >
> > > I am not surprised.  RAID 4/5/6 performance is highly sensitive to the
> > > underlying hw, and thus needs a fair amount of fine tuning.
> >
> > Nevertheless, performance is not the biggest advantage of RAIF.  For
> > read-biased workloads RAID is always slightly faster than RAIF.  The
> > biggest advantages of RAIF are flexible configurations (e.g., can combine
> > NFS and local file systems), per-file-type storage policies, and the fact
> > that files are stored as files on the lower file systems (which is
> > convenient).
>
> Ok, a I was just about to inform you of a three nfs-branch raif which was
> unable to fill the net pipe.  So it looks like a 25% performance hit across
> the board.  Should be possible to reduce to sub 3% though once RAIF matures,
> don't you think?

Hmmm.  Which workload did you try?  Which RAIF level did you use: RAIF0
(striping), replication (RAIF1, default), or striping with parity (RAIF4,
5, 6)?  Which hardware did you use?  RAIF has to consume extra CPU time
and on older machines the overheads seem to be higher (CPUs are getting
faster than I/O devices at a faster pace).  Also, I guess you are
comparing RAIF mounted over three NFS branches with NFS alone, right?
It doesn't seem to be very fair to me :-)

Recently we solved the double-caching problem, which improved RAIF's
performance by an order of magnitude under I/O-intensive workloads.
(Normally, Linux stackable file systems cache the data twice.)
Unfortunately, many VFS meta-operations are synchronous (e.g., lookup).
RAIF has to wait on such operations in sequence for every branch
involved.  (This is different from, say, readpage operation.  We
call readpage on all the branches right away and then wait for their
simultaneous operation.)  Sequential waiting on lookups should be OK for
multi-threaded workloads but may result in extra elapsed time for the
single-threaded workloads.  Again, elegant solutions may require VFS API
changes.  Alternatively, we can create kernel threads for every branch.

I am not sure about 3% overheads in all the cases compared to NFS alone.
On one hand, there should be some price to pay for the extra
functionality.  On the other hand, for some workloads RAIF should
even improve performance compared to a single NFS because of the load
distribution.  In general, I agree that there are still many things we can
optimize.

Nikolai.
---------------------
Nikolai Joukov, Ph.D.
Filesystems and Storage Laboratory
Stony Brook University
