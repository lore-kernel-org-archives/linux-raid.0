From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: SATA raid options..
Date: Sat, 3 Jul 2004 23:55:57 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0407032343210.25702-100000@sweetums.bluetronic.net>
References: <40E6E741.9090800@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E6E741.9090800@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Daniel Kirkegaard Mouritsen <daniel@mouritsen.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 3 Jul 2004, Jeff Garzik wrote:
>dmraid will be required for use, and its 2-4 months away, I would guess.
>
>Why not just use md raid?  BIOS RAID is _always_ crap.

Because Linux is not the only OS using the drives.  I do the same thing
with my 4 drives... Linux RAID0's them mostly like the BIOS.  Linux can
muck with the NTFS section (most of the array), the XFS section (40G), and
the 8G swap partition (tmpfs space mostly.)  And Win XP is happy with
them as well ('tho it has no understanding of XFS.)

(this rest of mostly off on a tangent...)

However, getting GRUB to play nicely is turning into a problem... stage1
will load stage1.5 or stage2 without issue even with them *way* out on the
"drive"; however, stage1.5 cannot load stage2 and stage2 cannot touch the
drive.  (Error 17... it cannot recognize the xfs partition)  Stage2 reboots
the machine if it tries to touch the drive.  If you're not using an Opteron,
you might get further. *grin*

--Ricky


