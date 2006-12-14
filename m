From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Thu, 14 Dec 2006 16:01:54 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612141538410.6095@compserv1>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1>
 <200612132257.24399.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200612132257.24399.a1426z@gawab.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Nikolai Joukov wrote:
> > We have designed a new stackable file system that we called RAIF:
> > Redundant Array of Independent Filesystems.
>
> Great!
>
> > We have performed some benchmarking on a 3GHz PC with 2GB of RAM and U320
> > SCSI disks.  Compared to the Linux RAID driver, RAIF has overheads of
> > about 20-25% under the Postmark v1.5 benchmark in case of striping and
> > replication.  In case of RAID4 and RAID5-like configurations, RAIF
> > performed about two times *better* than software RAID and even better than
> > an Adaptec 2120S RAID5 controller.
>
> I am not surprised.  RAID 4/5/6 performance is highly sensitive to the
> underlying hw, and thus needs a fair amount of fine tuning.

Nevertheless, performance is not the biggest advantage of RAIF.  For
read-biased workloads RAID is always slightly faster than RAIF.  The
biggest advantages of RAIF are flexible configurations (e.g., can combine
NFS and local file systems), per-file-type storage policies, and the fact
that files are stored as files on the lower file systems (which is
convenient).

> > This is because RAIF is located above
> > file system caches and can cache parity as normal data when needed.  We
> > have more performance details in a technical report, if anyone is
> > interested.
>
> Definitely interested.  Can you give a link?

The main focus of the paper is on a general OS profiling method and not
on RAIF.  However, it has some details about the RAIF benchmarking with
Postmark in Chapter 9:

  <http://www.fsl.cs.sunysb.edu/docs/joukov-phdthesis/thesis.pdf>

Figures 9.7 and 9.8 also show profiles of the Linux RAID5 and RAIF5
operation under the same Postmark workload.

Nikolai.
---------------------
Nikolai Joukov, Ph.D.
Filesystems and Storage Laboratory
Stony Brook University
