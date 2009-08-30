From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Unbalanced reads of RAID10
Date: Sun, 30 Aug 2009 02:37:06 +0200
Message-ID: <20090830003706.GB5633@rap.rap.dk>
References: <20090823142439.GA5162@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090823142439.GA5162@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Aug 23, 2009 at 04:24:39PM +0200, Piergiorgio Sartor wrote:
> Hi all,
> 
> some time ago I was reporting about a strange issue.
> 
> I have a two HDDs system, with a small RAID1 (/boot)
> and the rest as RAID10 f2 (with LVM on top).
> 
> It seems that /dev/sdb has more reads than /dev/sda.
> 
> I had a quick check, with "iostat", and it seems that
> all small reads, somehow below 1~4KiB, are done from
> /dev/sdb2, regardless.
> Actually, it seems that only if there is a pending
> (small) read, this will be scheduled to /dev/sda2,
> but non-overlapping small reads seem to happen always
> from /dev/sdb2.
> 
> This occurs with the RAID10, but it seems also with
> the RAID1.

Hmm, have you done testing separately on each array?

> In normal operation, this does not seem to lead to
> problems, but during the smart long test /dev/sdb
> takes by far more time than /dev/sda, since each
> small read stop the test, and small read occurs
> whenever there is a small write from syslog or
> similar.
> Note that failing and removing /dev/sdb2 results
> in much shorter time for the smart test, about
> 1hr30min vs. the 6~7hrs with the drive still
> attached to RAID10.
> 
> Is there any way to tune which is the "preferred"
> drive or the "preferred" policy in case of these
> small (or big) reads?

What level of the kernel are you running?

> Could this be due to HW configuration?
> The two HDDs are numbered SATA1 and SATA2 in BIOS,
> there are still SATA3 and SATA4 ports somehow
> available (SATA3 has a DVD).
> 
> How are the reads scheduled withing the RAID10 software?

there was a change of this about 2.6.25 which forced reads to always be
from the faster inner part of the disks, and that should even out reads.

Anyway I have seen some strange test results on reading small blocks
with raid10,f2 , but maybe this was pre 2.6.25. raid1 reads not behaving
as expected has been reported before.

best regards
keld
