From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: RE: RAID1: Disks alternating on reads
Date: Tue, 23 Sep 2003 11:12:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <7FD257BF8564D4119DA800508BDF07AA0B0AAC3B@usahm012.exmi01.exch.eds.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Andrew Herdman' <andrew@whine.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Pardon me if my assumption was incorrect, but I was under the belief that
> when using software RAID1, that when reads occurred on the RAID device
that
> it would read from both drives in a striped fashion similar to how RAID0
> works to improve the speed of the md devices.   I am actually seeing this,
> but it appears that the reads on each drive are continuing for 10 to 20
> seconds before moving onto the next drive and then another 10-20 seconds
and
> back again.  This is not allowing for any performance increase, it just
lets
> the drives rest alternately.

My impression from crawling through the code a few months back was that this
behavior was a design feature. On a read request, the request is sent to the
device with heads "closest" to the target sector, EXCEPT that for sequential
reads, the device gets reused on the assumption that the disk can be kept
streaming, EXCEPT that after some maximum number of reads, another drive
gets chosen to give the previous device a rest.

I speculate your files are contiguous (or nearly so) with the result that
the initially closest drive gets hammered until its 'work quota' gets
exceeded, and then the next drive will get pounded. And so on. To test this,
I think you could reduce MAX_WORK_PER_DISK in raid1.c from the default 128
(in 2.4.21) to something smaller (perhaps 8 sectors for a filesystem with 4K
block size?) and see if the load evens out.

Good luck,

	Scott Bailey
	scott.bailey at eds.com
