From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Booting from RAID1
Date: Sun, 20 Dec 2009 01:07:54 -0600
Message-ID: <65.18.01567.E4DCD2B4@cdptpa-omtalb.mail.rr.com>
References: <4877c76c0912192243x5d7281begc9a94242d476a20f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912192243x5d7281begc9a94242d476a20f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Evans' <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Advice point 1; read my howto: http://wiki.tldp.org/LVM-on-RAID  If
> you see anything that doesn't work, let me know so I can fix it.

	I read through it, thanks.  I'll let you know if anything you
mention is broken -although I doubt it.

> Advice point 2; which my howto should mention: For boot devices you'll
> probably want to use the 1.0 mdadm label format (not 1.1 or 1.2, which
> are the same but change where the label is stored) for just the boot
> raid 1.0 only.

Oops!  I already created a 1.2 Superblock.  Well, no biggie.  I'll just
trash it and do it over.  The /boot array is tiny, so it doesn't take long
at all to create.

>  It will also mention some things you should be extra
> careful about...
> 
> Like mounting the bare devices in that raid set by mistake.

	Uh... yeah.  That could be ugly.  That's why I like to have a cold
drive on the shelf configured with the entire OS.

> Oh, and you'll also very likely want grub to read the /boot
> filesystem, which is why it must be on a partition followed by the
> raid header, instead of a partition containing a raid header and raid
> protected partition.  That use is OK since grub operates read-only.

	I think I follow you, here.  IOW, partition the drive, create the md
target, and then format the RAID array, right?  Or are you saying one should
format the partition and then create the RAID array on top of it?

