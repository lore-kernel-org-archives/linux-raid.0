From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Broken RAID1 boot arrays
Date: Mon, 10 May 2010 13:06:48 -0400
Message-ID: <4BE83D28.3000508@tmr.com>
References: <03.5E.29689.68E67EB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <03.5E.29689.68E67EB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer wrote:
> 	I was running a system under kernel 2.6.26.2-amd64, and it was
> having some problems that seemed possibly due to the kernel (or not), so I
> undertook to upgrade the kernel to 2.6.33-2-amd64.  Now, there's a distro
> upgrade "feature" which ordinarily prevents this upgrade, because udev won't
> upgrade with the old kernel in place, and the kernel can't upgrade because
> of unmet dependencies which require a newer udev version, among other
> things. In any case, the work-around is to create the file
> /etc/udev/kernel-upgrade, at which point udev can be upgraded and then the
> kernel must be upgraded before rebooting.  Now, I've done this before, and
> it worked, but I've never tried it on a system which boots from an array.
> This time, it broke.
>
> 	As part of the upgrade, GRUB1 is supposed to chain load to GRUB2
> which then continues to boot the system.  This does not seem to be
> happening.  What's more, when linux begins to load, it doesn't seem to
> recognize the arrays, so it can't find the root file system.  There are two
> drives, /dev/hda and /dev/hdb, each divvied up into three partitions:
> /dev/hdx1 is formatted as ext2 and (supposed to be) mounted as /boot, and
> /dev/hdx2 formatted as ext3 and is (supposed to be) /, and /dev/hdx3 is
> configured as swap.  In all three cases, the partitions are a pair of
> members in a RAID1 array.  The /dev/hdx1 partitions have 1.0 superblocks and
> are assigned /dev/md1.  The /dev/hdx2 partitions have 1.2 superblocks and
> are assigned /dev/md2.  The /dev/hdx3 partitions have 1.2 superblocks and
> are assigned /dev/md3.  All three have internal bitmaps.
>
> 	GRUB can initially read the /dev/hda1 partition, because it does
> bring up the GRUB menu, which is on /dev/hdx1.  
>
> 	If I boot to multiuser mode, I get a complaint about an address
> space collision of a device.  It then recognizes the /dev/hda1 partition as
> ext2 and starts to load the initrd, but then unceremoniously hangs.  After a
> while, it aborts the boot sequence and informs the user it has given up
> waiting for the root device.  It announces it cannot find /dev/md2 and drops
> to busybox.  Busybox, however, complains about not being able to access tty,
> and the system hangs for good.
>
> 	If I boot to single user mode, then when raid1 and raid456 load
> successfully, but then it complains that none of the arrays are assembled.
> Afterwards, it waits for / to be available, and eventually times out with
> the same errors as the multiuser mode.
>
> 	I'm not sure where I should start looking.  I suppose if initrd
> doesn't have the image of /etc, it might cause md to fail to load the
> arrays, but it certainly should contain /etc.  What else could be causing
> the failure?  I did happen to notice that under the old kernel, when md
> first tried, the arrays would not load, but then a bit later in the boot
> process, they did load.
>
>   

I have zero experience with debian, but on several other distributions I 
have noted that an upgrade to a very recent kernel from a fairly old 
kernel (which you did) will make the LVM not work if you're using that. 
If not, forget I said it, it's not related and I never chased it, I just 
saw it a few times and muttered mighty oaths and moved on.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

