From: "Shaw, Marco" <marco.shaw@nbtel.nb.ca>
Subject: Recovering from a disaster...
Date: Thu, 28 Nov 2002 08:53:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA780BAD6494@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Going for my RHCE in a few weeks...  Always wondered:

1. Are there any gotchas in a corrupted software RAID filesystem?  For example, /dev/md0 is an RAID1 MD device, and either the 1st superblock on /dev/md0 or maybe the underlying /dev/sda1 partition is zero'ed out.  How does one go about fixing it?  Will a simple fsck here work?  But in the above case, is fsck run against md0 or sda1?

2. If one knows that /dev/md0 is in trouble (composed of /dev/sda1 and /dev/sdb1), but /dev/sda1 is fine, can one, upon boot, simply change LILO/GRUB from trying to mount root from /dev/md0 to /dev/sda1?  My guess is no, since the disk label is different.

3. I also wonder about LVM (now with RedHat 8.0), but will ask an LVM list...

A typical scnerario could be LVM sitting on top of MD, and have to recover from some kind of disaster.

A co-worker just screwed up a system I suspect was setup with a combination of LVM and MD.  I may have too quickly tried mounting /dev/sda2 (root on on disk), and maybe should have tried mounting /dev/md0.  After trying to mount /dev/sda2 (with an raid autodetect type), I think mount complained about invalid options, so I proceeded to do an fsck on /dev/sda2, only to have mention something about the superblock (yes, I should write all the errors down), so I tried fsck on something like 32768,
and it started up... And ran... And ran.  Result aftewards: all /dev/sda2 contains now after an attempt to mount it is "lost+found"!  :(

Marco
