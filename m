From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: Upgraded grub, now confused about mirrored /boot
Date: Tue, 02 Nov 2010 02:11:06 -0400
Message-ID: <9770F687FAE544F295B1A22155F2BBA6@m5>
References: <AANLkTinnaRECf9grA6-VEAg7YNvN6M4cHWKBYsfj4v6B@mail.gmail.com>
	<4CCD7AE1.8000705@anonymous.org.uk> <20101031114655.36e627e3@notabene>
 <4CCF65F3.3040307@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4CCF65F3.3040307@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

	I upgraded my system from Red Hat FC10 to FC11.  The instructions
say to run this command:
/sbin/grub-install BOOTDEVICE

And if it fails, run this:
/sbin/grub-install --recheck /dev/sda

However, my boot disk (/boot) is mirrored on 4 disks and I think (or hope)
all 4 are bootable.  The mirrors were created at install time many years ago
when I installed FC5.  No idea if it really made more than 1 bootable.  I
have assumed that if sda failed, I could still boot from sdb, sdc or sdd.
And I do understand that I might need to remove sda first, depending on the
type of failure.  Lucky for me, no drive has failed yet and I don't recall
if I tested booting off of any other disks.

I do have this on the kernel line:
md-mod.start_dirty_degraded=1

So, what do I do now?  Run that command on all 4 disks?  Or run it on
/dev/md0?

Oh, 4 way mirror is not because I am paranoid.  I have 4 disks partitioned
alike, so I figured I would use all 4 disks just for the symmetry.  OCD
maybe, but not paranoid.  :)

# df -k /boot
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0                256586    221526     21812  92% /boot

md0 : active raid1 sdd1[0] sda1[3] sdc1[2] sdb1[1]
      264960 blocks [4/4] [UUUU]
      bitmap: 0/33 pages [0KB], 4KB chunk

Thanks,
Guy

