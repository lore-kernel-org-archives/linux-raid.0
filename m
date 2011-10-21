From: Harry Mangalam <hjm@moo.nac.uci.edu>
Subject: Re: How to free devices held captive by failed arrays
Date: Fri, 21 Oct 2011 15:45:56 -0700
Message-ID: <20111021224556.GA11429@moo.nac.uci.edu>
References: <20111021202736.GA10682@moo.nac.uci.edu>
 <20111022094156.1a2c42ae@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111022094156.1a2c42ae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[continues at bottom]

On Sat, Oct 22, 2011 at 09:41:56AM +1100, NeilBrown wrote:
> > 
> > In doing some tests with an 8-port Supermicro/Marvell-based SATA controller
> > (works fine so far) and some Hitachi 3TB disks, I've run into an odd
> > problem.  One of the disks failed in burn-in, so the RAID5 went into
> > degraded mode.  In replacing the failed disk, I managed to bugger it up; not
> > so awful since it's a test rig and I needed to create 2 smaller arrays for
> > some testing. 
> > 
> > 
> > In trying to do that, I was able to create the first 4-disk RAID5 fine and
> > it's now initializing, but the second fails with the following error:
> > 
> > 
> > $ mdadm --create  --verbose /dev/md1 --level=5 --raid-devices=4
> > /dev/sd[fghi]1
> > mdadm: layout defaults to left-symmetric
> > mdadm: layout defaults to left-symmetric
> > mdadm: chunk size defaults to 512K
> > mdadm: /dev/sdf1 appears to be part of a raid array:
> >     level=raid5 devices=7 ctime=Fri Sep 30 17:47:19 2011
> > mdadm: layout defaults to left-symmetric
> > mdadm: super1.x cannot open /dev/sdg1: Device or resource busy
> > mdadm: /dev/sdg1 is not suitable for this array.
> > mdadm: layout defaults to left-symmetric
> > mdadm: /dev/sdh1 appears to be part of a raid array:
> >     level=raid5 devices=7 ctime=Fri Sep 30 17:47:19 2011
> > mdadm: layout defaults to left-symmetric
> > mdadm: create aborted
> > 
> > 
> > mdstat implies that one of the disks still belongs to the previous RAID5:
> > 
> > 
> > $ cat /proc/mdstat 
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
> > [raid10] 
> > md0 : active raid5 sde1[4] sdd1[2] sdc1[1] sdb1[0]
> >       6442438656 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3]
> > [UUU_]
> >       [========>............]  recovery = 40.1% (861382528/2147479552)
> > finish=292.9min speed=73167K/sec
> >       
> > md_d0 : inactive sdg1[5](S)
> >       2147480704 blocks
> >        
> > unused devices: <none>
> > 
> > 
> > 
> > 
> > but I can't seem to convince md_d0 to surrender this device.  This behavior
> > survives a reboot.
> > 
> > 
> > One wrinkle is that the original RAID was made with the default mdadm from
> > Ubuntu 10.04.3 (2.6.7.1) and the smaller RAID5 above was created with the
> > latest mdadm (v3.2.2).  
> > 
> > 
> > What do I have to do to free this device?
> 
> Doesn't
>  
>    mdadm --stop /dev/md_d0
> 
> release sdg1 ??
> 
> NeilBrown

No, it doesn't.

$ mdadm --stop /dev/md_d0
mdadm: error opening /dev/md_d0: No such file or directory

In fact, that's sort of odd:

 $ ls -l /dev/md*
brw-rw---- 1 root disk 9, 0 2011-10-20 17:18 /dev/md0
lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p1 -> md/d0p1
lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p2 -> md/d0p2
lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p3 -> md/d0p3
lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p4 -> md/d0p4

/dev/md:
total 0
brw------- 1 root root 254, 0 2011-10-20 17:05 d0
brw------- 1 root root 254, 1 2011-10-20 17:05 d0p1
brw------- 1 root root 254, 2 2011-10-20 17:05 d0p2
brw------- 1 root root 254, 3 2011-10-20 17:05 d0p3
brw------- 1 root root 254, 4 2011-10-20 17:05 d0p4

[no record of /dev/md_d0] ...?

hjm


