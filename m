From: Stephen Cameron <steve.cameron@hp.com>
Subject: multipath weirdness
Date: Tue, 22 Oct 2002 14:41:01 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021022144101.A18140@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

2 questions:

1.  How do I get multipath.o to be insmod'ed at boot time
so that my multipath "raid" devices will start?

I tried this: 

	edit /etc/fstab to mount /dev/md0 someplace
	echo "alias raid multipath" >> /etc/modules.conf
	mkinitrd /boot/initrd-md `uname -r`
	(modify /etc/lilo.conf, run /sbin/lilo)
	reboot

	But, I get the (Raid repair) prompt, and lsmod
	shows multipath is not loaded. 

2.  If I don't get multipath.o to insmod at boot time, then
raid startup fails, and I get the (Raid repair) prompt.

"No problem," I think, "I'll just do this:"

	insmod multipath (works fine)
	raidstart /dev/md0 (fails with "Invalid argument".

So how do i get /dev/md0 working again?  As far as I know,
the only thing wrong with it was that multipath.o was not loaded.
The disks that comprise /dev/md0 are fine.  They are hardware
raid volumes, actually.  /dev/cciss/c1d0p1 and /dev/cciss/c2d0p1.

At this point, I can say:

mkraid /dev/md0
mke2fs /dev/md0
mount /dev/md0 /u1

and that works just fine, (apart from overwriting whatever was on
/dev/md0 beforehand, which is somewhat less than fine. )

Thanks for any info.

BTW, system was redhat advanced server 2.1, kernel was redhat's.
(2.4.34, I think)
	
-- steve
