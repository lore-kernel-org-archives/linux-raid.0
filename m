From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Kernel 2.6.32-5-amd64 fails to boot.
Date: Tue, 1 Feb 2011 14:23:46 -0600
Message-ID: <9A.25.13137.3DB684D4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

	I have been attempting to upgrade a Debian "Squeeze" Linux box from
2.6.32-3-amd64 to 2.6.32-5-amd64, but the upgrade is a non-starter.  GRUB2
comes up just fine, but when I select the new kernel version, a number of
announcements flash by too fast to seen.  I am not 100% certain, but I
believe the initrd starts to load OK. Some text flies by far too quickly to
be seen, but then an error pops up concerning an address space collision of
some PCI device. Then it shows three errors for RAID devices md1. md2, and
md3, saying they are already in use. Immediately thereafter the system shows
errors concerning  the RAID targets being already in use, after which point
the system complains it can't mount / (md2), /dev, /sys, or /proc (in that
order) because the sources do not exist (if /dev/md2 does not exist, how can
it be busy?).  Thereafter, of course, it fails to find init, since / is not
mounted.  It then tries to run BusyBox, but Busybox complains:

/bin/sh: can't access tty; job control turned off

After that, it attempts to put up an initramfs prompt, but of course with no
tty access, it just hangs completely.  Not surprisingly, recovery mode
doesn't boot, either.  It gives a bit more detail in the output, but nothing
illuminating.  The old kernel (2.6.32-3-amd64) boots just fine.

Obviously there is a problem in the initramfs, probably with mdadm, but
what?  What should I try to manipulate in the initrd so I can find out what
is failing?

