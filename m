From: "Jonathan Baker-Bates" <jonathan@bakerbates.com>
Subject: RE: The right way to recover from md partition failure?
Date: Mon, 30 Aug 2004 22:44:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBJAGHALMCJCFDHBILIEPCENAA.jonathan@bakerbates.com>
References: <200408302014.i7UKEU306097@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408302014.i7UKEU306097@watkins-home.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Guy
> Sent: 30 August 2004 21:14
> To: 'Jonathan Baker-Bates'; linux-raid@vger.kernel.org
> Subject: RE: The right way to recover from md partition failure?
>
>
> No need to copy, that's what md does.
>
> Verify that the disk is not part of the array:
> mdadm -D /dev/md1
>
> I bet you will find the disk is there, but failed.
> So, raidhotremove it, then raidhotadd it.
>
> mdadm is the preferred tool.  The old raidtools are not supported.
> For details:
> man mdadm
>
> You may need to install mdadm.
>
> mdadm manage /dev/md1 -r /dev/hde3
> mdadm manage /dev/md1 -a /dev/hde3
>
> or short form:
> mdadm /dev/md1 -r /dev/hde3
> mdadm /dev/md1 -a /dev/hde3
>
> It should start to re-sync.  Monitor the status with:
> cat /proc/mdstat
> and/or
> mdadm -D /dev/md1
>

Ah, thanks. I'll need to do a backup just in case before I try that though.
One question meanwhile: If there are bad blocks on the drive, and assuming
mdadm adds that disk to the array OK, can I fsck /dev/md1 in the normal way
and repair or mark them as bad? I'm a bit confused about using fsck and
RAID.

Jonathan


