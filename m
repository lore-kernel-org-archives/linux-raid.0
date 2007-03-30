From: Neil Brown <neilb@suse.de>
Subject: Re: is this raid5 OK ?
Date: Fri, 30 Mar 2007 10:22:07 +1000
Message-ID: <17932.22575.558925.535963@notabene.brown>
References: <237230840.20070329193857@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rainer Fuegenstein on Thursday March 29
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 29, rfu@kaneda.iguw.tuwien.ac.at wrote:
> hi,
> 
> I manually created my first raid5 on 4 400 GB pata harddisks:
> 
> [root@server ~]# mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 --spare-devices=0 /dev/hde1 /dev/hdf1 /dev/hdg1 /dev/hdh1
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 64K
> mdadm: size set to 390708736K
> mdadm: array /dev/md0 started.
> 
> but, mdstat shows:
> 
> [root@server ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 hdh1[4] hdg1[2] hdf1[1] hde1[0]
>       1172126208 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
> 
> unused devices: <none>
> 
> I'm surprised to see that there's one "failed" device [UUU_] ?
> shouldn't it read [UUUU] ?

It should read "UUU_" at first while building the 4th drive
(rebuilding a missing drive is faster that calculating and writing all
the parity blocks).  But it doesn't seem to be doing that.

What kernel version?  Try the latest 2.6.x.y in that series.

NeilBrown
