From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RUN_ARRAY vs. START_ARRAY ioctls
Date: Sat, 22 Jun 2002 12:40:26 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15635.58266.69356.389004@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0206211847480.2157-100000@spaz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Meininger on Friday June 21
To: Jeff Meininger <jeffm@boxybutgood.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 21, jeffm@boxybutgood.com wrote:
> 
> I'm looking at the kernel/user interface md_u.h and trying to figure out
> how to start a linear raid, not persistant, no superblock, from my little
> test program.

You might find reading Build.c from
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/mdadm-1.0.0.tgz
helpful.

> 
> My current plan of attack is to do 3 steps...
> 
> #1. do ioctl SET_ARRAY_INFO.  Which fields of mdu_array_info_t should I 
> fill out before passing it into ioctl? 

Any that make sense.
 level, size=0, nr_disk==raid_disks md_minor not_persistent,
 state=0 active_disks=working_disks=raid_disks
 spare_disks=failed_disks=0.
 chunk_size

> 
> #2. Add disks with ADD_NEW_DISK... one mdu_disk_info_t per disk for 
> nr_disks (or raid_disks??) in mdu_array_info_t.

Yes

> 
> #3. RUN_ARRAY or START_ARRAY ioctl.  I can't figure out which to use.  It 
> seems that RUN_ARRAY requires a mdu_param_t arg.

RUN_ARRAY.  Parameter is ignored.

> 
> Are personality and 'level' the same thing?  Is "linear" mode represented 
> as 1?

linear == -1.   Different personalities impliment different levels.
personality raid5 implements levels 4 and 5.

> 
> So many variables here... I want to give this a shot, but I also don't 
> want to trash my system doing something stupid!

You learn by making mistakes... live a little!!!

> 
> One more question... I seem to remember that you can only have something 
> like 12 or 27 devices per set a while back.  Does this limitation still 
> stand for non-superblock linear raids?  If so, will I be able to 
> effectively use more devices by creating multiple raids of 12 devices, and 
> then making a raid of the raids?

27 on recent kernels.  Limit still applies with non-superblock.
You could do a raid of 27 arrays each with 27 devices if you like.

NeilBrown

> 
> Thanks for your help!
> -Jeff
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
