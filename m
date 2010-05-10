From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Broken RAID1 boot arrays
Date: Mon, 10 May 2010 10:17:32 +0100
Message-ID: <4BE7CF2C.8030400@anonymous.org.uk>
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

On 10/05/2010 03:25, Leslie Rhorer wrote:
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
> 	Has anyone else come across this problem?  The upgrade is from
> Debian "Lenny" to "Squeeze".   Where should I start looking?

Firstly, almost certainly by 2.6.32 your IDE drives will appear as 
/dev/sdx rather than hdx so you may need to build the initrd for 2.6.32 
with a different /etc/mdadm.conf. When you boot and get the complaint 
about no / can you get a command line you can run mdadm -Evvs from?

Secondly, the idea of grub1 chain-loading grub2 sounds iffy to me; use 
either grub1 or grub2 but not both.

Hope this gives you some places to look.

Cheers,

John.
