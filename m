From: Nicholas Ipsen <NCLI@ncli-design.com>
Subject: Re: Trouble adding disk to degraded array
Date: Sat, 12 Jan 2013 00:01:09 +0000
Message-ID: <CAJ=Lqma76UUcg154ChSW1e48ZxPCf8dG7WMNH6PpvQGYF_v7vw@mail.gmail.com>
References: <CAJ=LqmbYG8H45M196ZuRcDMu9Ucz0t_pQenQbZtMKM9AhSqrpQ@mail.gmail.com>
 <CAJ=LqmasSo9WRmPAO6-RBE5N=zxg9vitWhdqcekbUO89oxKevA@mail.gmail.com>
 <50EDAF0A.7030903@turmel.org> <CAJ=LqmbKR1BczeFyGeQooDsPMf8PqriiD3z7i1_LjupGij5ewQ@mail.gmail.com>
 <50EDF030.2060502@smartguide.com.au> <CAJ=LqmZKXqn+nGt8=Rt8QS9S7pVS7qyEaN8Cbb91D7XETEvFug@mail.gmail.com>
 <CAJ=LqmaouLfjy6O=wSEaC600dsApWrGGPrc0Yqs25Mvbm+0Hdw@mail.gmail.com> <alpine.DEB.2.00.1301111505110.12098@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1301111505110.12098@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yikes, I may really have stepped in it with that filesystem check... I
first mounted the filesystem, and everything looked fine after
replacing sdc1 with sdd1. I then
ran fsck -f /dev/md0, and it started to report problems after 10-15
minutes. Here's one of them, they all said the same except for the
block number:

"Error reading block 5767176 (Attempt to read block from filesystem
resulted in short read) while reading inode and block bitmaps.  Ignore
error<y>?"

I just kept pressing y and then approving a forced rewrite, as I
thought it was just a few blocks, but after approving 40 or so
rewrites, I got cold feet, cancelled fsck, and tried to remount md0
through nautilus. But it wouldn't. Instead, I get this message:

Error mounting /dev/md0 at
/media/ubuntu/be265e78-0c46-41fb-96ba-fda269e74a60: Command-line
`mount -t "ext4" -o "uhelper=udisks2,nodev,nosuid" "/dev/md0"
"/media/ubuntu/be265e78-0c46-41fb-96ba-fda269e74a60"' exited with
non-zero exit status 32: mount: wrong fs type, bad option, bad
superblock on /dev/md0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

Naturally, I ran dmesg | tail, and got this;
[104349.032352] EXT4-fs (md0): can't read group descriptor 378
[104350.997625] EXT4-fs (md0): can't read group descriptor 250
[104739.002433] EXT4-fs (md0): can't read group descriptor 250
[104780.612995] EXT4-fs (md0): can't read group descriptor 250

I then stopped the array, and restarted it, which gave me this message:
mdadm: clearing FAULTY flag for device 1 in /dev/md0 for /dev/sdb1

Note that this is not the device that was giving me trouble before,
nor is it the on I replaced it with.

What have I done wrong here?

Nicholas Ipsen
