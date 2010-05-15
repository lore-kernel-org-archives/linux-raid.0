From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Continuing problems with RAID arrays starting at boot - devices not found
Date: Sat, 15 May 2010 18:37:05 -0500
Message-ID: <4D.90.20763.8203FEB4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinUxy9cCTILXHASuCORhGO25gmgSwg-etV6JDBq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinUxy9cCTILXHASuCORhGO25gmgSwg-etV6JDBq@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Hi,
>    I have a continuing problem with all my my RAID arrays. I'm
> moderately confident that it's not a mdadm problem but I hope I can
> ask here for any tests or ideas to test it before I try reporting it
> up to the LKML. Thanks in advance.

	I was having a similar problem with one of my systems.  Because I
thought it might be an issue with udev, I tried to update the kernel.
Because of it, I am not in a situation where the system is unbootable.

>   Every time I boot all 5 drives are recognized by system BIOS. There
> is a BIOS device table printing on the screen and it __always__ shows
> all 5 drives. If I enter BIOS and look at the storage page all drives
> are shown. If I do nothing then the system waits 10 seconds, then
> boots into grub. Grub boots the kernel, the boot process rolls along,
> gets to where it starts mdadm, and then 50%-75% of the time one or
> more of the partitions isn't found and mdadm doesn't start the RAID
> correctly.

	Except that the drives on the controller are not recognized by the
BIOS (and never will be), I was have very much the same symptoms - at a high
level, anyway - as you.

>    Now, after booting and RAID not starting correctly, maybe half the
> time I can look for the drive (ls /dev/sde1 for instance) find it and
> add it back to the RAID array. Half the time the drive isn't found
> until I reboot the machine. If I look in dmesg I don't see the missing
> drive. It's just like it isn't there even though BIOS said it was
> before booting Linux. The missing drive is not always found on a warm
> reboot, but is often found on a cold reboot.
> 
>    The problem has been consistent across all the kernels I've tried
> over the last 2 months.
> 
>    My question is whether this is in any way related to mdadm? I

	'Pretty unlikely.  Mdamd doesn't fiddle with block devices created
by udev.  If the block device for the hard drive isn't there, then for
whatever reason udev isn't creating it, and if udev doesn't create it, mdadm
can't use it as a member in an array.  I think the udev problem went away
when I upgraded to 2.6.32-3-amd64 (or at least every time I have looked,
now, all 8 eSATA targets seem to be there), but now I have much bigger
problems.

> suspect it isn't but thought I'd try to get some ideas on how to test
> for the root cause of this problem. If it was purely a mdadm problem
> then even if the RAID wasn't correctly started then wouldn't I still
> find the drive partitions?

	Yes, you would.  Mdadm is failing because the block devices are not
in /dev, not the other way around.  You might look at the boot logs for
reports  concerning failing SATA devices.  Try `man udevadm`.


