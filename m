From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Sun, 25 Feb 2007 21:46:58 -0800
Message-ID: <e03b90ae0702252146w400a5a26w31e9bc8f3d81cee@mail.gmail.com>
References: <45DF859B.2050108@eyal.emu.id.au>
	 <Pine.LNX.4.64.0702231929380.31611@p34.internal.lan>
	 <45DF8DE3.2050903@eyal.emu.id.au>
	 <17890.25524.465403.130119@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17890.25524.465403.130119@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ok, so hearing all the excitement I ran a check on a multi-disk
RAID-1. One of the RAID-1 disks failed out, maybe by coincidence
but presumably due to the check. (I also have another disk in
the array deliberately removed as a backup mechanism.) And
of course there is a big mismatch count.

Questions: will repair do the right thing for multidisk RAID-1, e.g.
vote or something? Do I need a special version of mdadm to
do this safely? What am I forgetting to ask?

Jeff


# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdf1[0] sdb1[4] sdd1[6](F) sdc1[2] sde1[1]
      488383936 blocks [6/4] [UUU_U_]

# cat /sys/block/md1/md/mismatch_cnt
128

# cat /proc/version
Linux version 2.6.17-2-amd64 (Debian 2.6.17-7) (waldi@debian.org) (gcc
version 4.1.2 20060814 (prerelease) (Debian 4.1.1-11)) #1 SMP Thu Aug
24 16:13:57 UTC 2006

# dpkg -l | grep  mdadm
ii  mdadm          1.9.0-4sarge1  Manage MD devices aka Linux Software Raid
