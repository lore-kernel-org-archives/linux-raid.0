From: "Eric Wood" <eric@interplas.com>
Subject: Re: How safe is software RAID compared to how safe hardware RAID is!?
Date: Fri, 21 Nov 2003 09:59:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00a901c3b040$10e451e0$9100000a@intgrp.com>
References: <16314.40792.616508.878124@notabene.cse.unsw.edu.au><PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com> <16314.44161.438158.27514@notabene.cse.unsw.edu.au> <012e01c3ae33$6cde29d0$cc07a8c0@neptune>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

3tcdgwg3 wrote:
> Did I do anything wrong?
>
> I didn't see RAID 1 hits multiple drives concurrently, specially for
> reading.
>
> I set up RAID 5, RAID 1 and single disk partitions on x86 machine,
> kernel 2.4-18.
>
> For 800 MB breading, RAID 5 take 2/3 of time used by single disk,
> but RAID 1 take 1.1 of time used by single disk.

Doing anything (reading or writing) with RAID 1 set will always be slower
than with a single drive.  Because even with reading, you're still updating
the atime on both drives.  As a test, mount that partition with noatime and
see if RAID-1 reading test nears to 1.

Here's a nice message from while back:

http://www.cs.helsinki.fi/linux/linux-kernel/2002-17/0313.html
<snip> Jaime Medrano wrote:
> I have taken a look at the read balancing code at raid1.c and I have found
> that when a sequential read happens no balancing is done, and so all the
> reading is done from only one of the mirrors while the others are iddle
<snip>

So RAID-1 sets don't stripe read.  RAID 5 is forced to stripe seek because
of its very nature of having XORed data across the drives.

-eric wood


