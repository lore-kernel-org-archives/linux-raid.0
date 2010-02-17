From: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 01:34:34 -0500
Message-ID: <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
	<4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
	<201002141940.35716.volkerarmin@googlemail.com> <4B7AD35E.7000405@tmr.com>
	<alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
	<20100217130103.3ca65ef3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100217130103.3ca65ef3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 16, 2010 at 21:01, Neil Brown <neilb@suse.de> wrote:
> On Tue, 16 Feb 2010 16:03:43 -0900 (AKST) "Mr. James W. Laferriere" <=
babydr@baby-dragons.com> wrote:
>> =C2=A0 =C2=A0 =C2=A0 I am unaware of any record from Neil or other m=
aintainer(s) of the
>> /md/ device tree saying that they will not remove the 0.90 table and=
 the
>> autoassembly functions there . =C2=A0I'd very much like to hear a st=
atement saying
>> there will not be a removal of the autoassembly functions for 0.90 r=
aid table
>> from the kernel tree .
>
> I will not be removing 0.90 or auto-assemble from the kernel in the
> foreseeable future.
> None the less, I recommend weaning yourself from your dependence on i=
t.
> initramfs is the future, embrace it.

What are people's reasons for pushback against initramfs?  I've heard
lots of claims that "it's not trustworthy" and "it breaks", but in 7
years of running bootable software RAID boxes on weird architectures
(even running Debian unstable) I have only once or twice had initramfs
problems.

As a software capability, initramfs makes it possible to use
*anything* as a root filesystem, no matter what is necessary to set it
up.  For example, I have seen somebody use DRBD (essentially network
RAID-1) as a root filesystem with a few custom hook scripts added to
the initramfs-tools configs.  Other examples include using Sun ZFS as
a root fs via an initramfs FUSE daemon, a feat which even Solaris
could not accomplish at the time.  Encrypted root filesystems also
require an initramfs to prompt for encryption keys and decrypt the
block device.  Multipath block devices are another example.

You should also take a look at your distro installers.  There is not a
single one made in the last several years which does not use an
initramfs to start networking or access the installation media.  In
fact, of all the distro installers I have had the most consistent
behavior regardless of system hardware from the ones which operate
entirely out of their initramfs.

=46rom a reliability perspective, an initramfs is no more essential
than, say, /sbin/init or /boot/vmlinuz-2.6.33.  Furthermore, all of
the modern initramfs generation tools automatically keep backup copies
exactly the same way that "make install" keeps backup copies of your
kernel images.  The two times I've managed to hose my initramfs I was
able to simply edit my grub config to use a file called something like
"/boot/initramfs-2.6.33.bak" instead.

In fact, I have had several times where an initramfs made my boot
process *more* reliable.  On one of my LVM JBOD systems, I was able to
pull a group of 3 SATA drives whose backplane had failed and drop them
all in USB enclosures to get the system back up and running in a half
an hour.  With just straight partitions on the volumes I would have
been hunting around for 2 hours to figure out where all my partitions
had gone only to have the USB drives spin up in a different order
during the next reboot.

If you're really concerned about boot-process reliability, go ahead
and tell your initramfs tool to include a fully-featured busybox,
coreutils, bash, strace, gdb, and a half-dozen other developer tools.
You may wait an extra 20 seconds for your bootloader to load the damn
thing during boot, but you'll be able to track down that annoying
10-second hang in your /sbin/init program during config-file parsing.

I've built specialized embedded computers with stripped-down chipset
initialization code, a tiny Linux kernel and a special-purpose
initramfs burned into the flash.  By using the fastboot patches and
disabling all the excess drivers, my kernel was fully operational
within the first half-second.  It used the tools on the initramfs to
poke around on the hard disk as a bootloader, then kexec() to load the
operational kernel.

Counting up all the problems I've had with system boot... I've had an
order of magnitude more problems from somebody getting careless with
"rm", "dpkg --purge", etc than with initramfs deficiencies.

Cheers,
Kyle Moffett
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
