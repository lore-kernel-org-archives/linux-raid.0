From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: RAID 1 cannot boot (using grub)
Date: Mon, 16 Jun 2003 20:50:39 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0306162042180.7750-100000@sweetums.bluetronic.net>
References: <Pine.LNX.4.44.0306122342440.4181-100000@gpu.utcc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0306122342440.4181-100000@gpu.utcc>
To: Derek Yeung <dky@utcc.utoronto.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 13 Jun 2003, Derek Yeung wrote:
>modified the fstab accordingly.  Without the primary device added to
>the md set (meaning still working in degraded mode), the machine boots
>(with a few hitches -- something about a bad superblock and ext3
>mounting, which i will post more detail later)  -- but, it boots.
>The problem is after I add the /boot partition to the md set (i.e.: add
>hda1 to md1, which md1 already has hdc1), and then reboot, the machine
>fails to boot.  It stops after printing "GRUB".  Does anyone have any idea
>why?

Simple.  You've destroyed part of the bootloader.  In this case, you
didn't wait for the mirroring to complete, did you?  If so, hda1, or
(hd0,0) to grub, does not contain a valid filesystem.  Thus, there is
no stage2 or grub.conf.

You'll have to install grub on both hda and hdc as the stage1 and stage1.5
are outside partitions being mirrored (MBR and the space following it.)  And
you have go out of your way to do it so it'll work if one of the drives dies.

--Ricky


