From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Kernel 2.6.32-5-amd64 fails to boot.
Date: Wed, 2 Feb 2011 21:27:26 -0600
Message-ID: <BC.48.19545.0A02A4D4@cdptpa-omtalb.mail.rr.com>
References: <3C.5E.05134.69CB94D4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3C.5E.05134.69CB94D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>, pkg-mdadm-devel@lists.alioth.debian.org, madduck@debian.org
List-Id: linux-raid.ids


	It's very striking that the old kernel also fails to properly start
the /dev/md0 array.  Under the old kernel, the udev drive names for the PATA
drives are /dev/hda and /dev/hdb.  The arrays assembled from these members
get properly assembled in in the old kernel.  According to dmesg, they seem
to be assembled, stopped, and then assembled again.  The /dev/md0 array,
however, has members that are all named /dev/sdX - both kernels are
apparently classifying the SATA drives as SCSI (as has been the case for a
while).  After booting the old kernel, the /dev/md0 array must be started
and re-assembled to get it working, but under the new kernel, all four
arrays must be stopped and re-assembled, the lack of the /dev/md2 rootfs
system halting the boot.  For some reason, neither kernel seems to be
stopping and re-assembling the arrays built from "SCSI" members, but the old
kernel is classifying the PATA members as IDE, rather than SCSI.  Note also
the lack of any messages from the new kernel saying the arrays are being
made active, and the relative positions where the RAID personalities are
registered.

	I really need to get this resolved, because this is holding up a
number of support issues, and preventing me from upgrading the kernel and
distro on the main server, at all.

	I'm adding the Debian mdadm maintainers to the e-mail thread, hoping
they may have some input.  I'm also adding Martin Kraft, who has been
graciously helping me over on usenet.

	Dmesg | grep md from the old kernel:

[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.32-3-amd64
root=/dev/md2 ro quiet
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.32-3-amd64
root=/dev/md2 ro quiet
[    2.411210] md: raid1 personality registered for level 1
[    2.940328] md: raid6 personality registered for level 6
[    2.940331] md: raid5 personality registered for level 5
[    2.940332] md: raid4 personality registered for level 4
[    2.948514] md: md1 stopped.
[    2.951701] md: bind<hdb1>
[    2.951933] md: bind<hda1>
[    2.953206] raid1: raid set md1 active with 2 out of 2 mirrors
[    2.957738] md1: bitmap initialized from disk: read 1/1 pages, set 0 bits
[    2.957741] created bitmap (1 pages) for device md1
[    3.000642] md1: detected capacity change from 0 to 6292176896
[    3.001942]  md1: unknown partition table
<snip>

	Compare that with the new kernel:
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.32-5-amd64
root=/dev/md2 ro quiet
[    0.748091] usb usb1: Manufacturer: Linux 2.6.32-5-amd64 ehci_hcd
[    0.748547] ata1: SATA max UDMA/133 port i16@0xec00 bmdma 0xe400 irq 20
[    0.748551] ata2: SATA max UDMA/133 port i16@0xe880 bmdma 0xe408 irq 20
[    0.748553] ata3: PATA max UDMA/133 port i16@0xe800 bmdma 0xe410 irq 20
[    0.806045] usb usb2: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    0.807649] ata8: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq
14
[    0.807652] ata9: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq
15
[    0.820043] usb usb3: Manufacturer: Linux 2.6.32-5-amd64 ehci_hcd
[    0.882041] usb usb4: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    0.938057] usb usb5: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    0.994029] usb usb6: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[    1.050029] usb usb7: Manufacturer: Linux 2.6.32-5-amd64 ohci_hcd
[   16.140763] md: bind<sdk1>
[   16.150006] md: bind<sdl3>
[   16.170380] md: bind<sdl2>
[   16.199653] md: array md1 already has disks!
[   16.225273] md: bind<sdi>
[   16.349657] md: raid1 personality registered for level 1
<snip>

