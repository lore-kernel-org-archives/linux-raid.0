From: =?iso-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Howto avoid full re-sync
Date: Fri, 7 Sep 2012 11:41:38 +0200
Message-ID: <81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de>
References: <50497AE6.2010005@websitemanagers.com.au>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50497AE6.2010005@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Am 07.09.2012 um 06:41 schrieb Adam Goryachev:

> I have a MD raid6 with 5 drives, and every now and then one (random)
> drive will fail. I've done all sorts of checks, and the drive is
> actually working fine, so I suspect an issue with the Linux driver
> and/or SATA controller (onboard).
> 
> It isn't really relevant to the question, but I'll run through the sata
> stuff, in case anyone can point out a simple solution to stop this from
> happening (yes, a new server is on the way, but with budgets etc, that
> could be some time away. This issue has happened for years, but we are
> becoming more active with these failures now).
> 
> 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
> (rev a1)
> 00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
> (rev a1)
> 01:07.0 RAID bus controller: Silicon Image, Inc. Adaptec AAR-1210SA SATA
> HostRAID Controller (rev 02)
> 
> cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md2 : active raid6 sdh1[5] sdg1[4] sdf1[0] sdd1[6](F) sde1[2] sda1[1]
>      5860535808 blocks level 6, 64k chunk, algorithm 2 [5/4] [UUU_U]
>      [>....................]  recovery =  1.4% (28663240/1953511936)
> finish=486.5min speed=65938K/sec
> 
> 
> 
> Since I know sdh is actually almost up to date, is there some way to
> re-add it, and only have to sync the portions of the disk which have
> changed?


Besides all the stuff about fix your server, a raid is not a backup and you risk your data - simply add a write intent bitmap:

# mdadm /dev/md2 --grow bitmap=internal

Best regards
Ralf