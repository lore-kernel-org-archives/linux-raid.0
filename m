From: Jeff Meininger <jeffm@boxybutgood.com>
Subject: RUN_ARRAY vs. START_ARRAY ioctls
Date: Fri, 21 Jun 2002 20:42:32 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206211847480.2157-100000@spaz.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm looking at the kernel/user interface md_u.h and trying to figure out
how to start a linear raid, not persistant, no superblock, from my little
test program.

My current plan of attack is to do 3 steps...

#1. do ioctl SET_ARRAY_INFO.  Which fields of mdu_array_info_t should I 
fill out before passing it into ioctl? 

#2. Add disks with ADD_NEW_DISK... one mdu_disk_info_t per disk for 
nr_disks (or raid_disks??) in mdu_array_info_t.

#3. RUN_ARRAY or START_ARRAY ioctl.  I can't figure out which to use.  It 
seems that RUN_ARRAY requires a mdu_param_t arg.

Are personality and 'level' the same thing?  Is "linear" mode represented 
as 1?

So many variables here... I want to give this a shot, but I also don't 
want to trash my system doing something stupid!

One more question... I seem to remember that you can only have something 
like 12 or 27 devices per set a while back.  Does this limitation still 
stand for non-superblock linear raids?  If so, will I be able to 
effectively use more devices by creating multiple raids of 12 devices, and 
then making a raid of the raids?

Thanks for your help!
-Jeff

