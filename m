From: Neil Brown <neilb@suse.de>
Subject: Re: Using 2.6.31 liveCD to grow (reshape) raid5 into raid6, then bacck
 to old kernel?
Date: Fri, 13 Nov 2009 15:37:05 +1100
Message-ID: <19196.57969.529323.360914@notabene.brown>
References: <20091112220351.22a2ad1b@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janek Kozicki on Thursday November 12
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 12, janek_listy@wp.pl wrote:
> Hi,
> 
> I have an old debian etch backup server. It has 5 drives in raid4.
> I want to add a sixth drive to jump to raid6. I don't want to upgrade
> debian etch, because the server is working real fine, and doing an
> upgrade would be too much problems.
> 
> Here it is:
> 
>   backup:~# uname -a
>   Linux backup 2.6.24-etchnhalf.1-686 #1 SMP Sat Aug 15 16:51:49 UTC 2009 i686 GNU/Linux
> 
>   backup:~# mdadm -D /dev/md1
> /dev/md1:
>         Version : 01.01.03
>   Creation Time : Fri Nov  2 23:35:37 2007
>      Raid Level : raid5
>      Array Size : 1933614592 (1844.04 GiB 1980.02 GB)
>     Device Size : 966807296 (461.01 GiB 495.01 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Thu Nov 12 21:59:15 2009
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>            Name : backup:1  (local to host backup)
>            UUID : 22f22c35:99613d52:31d407a6:55bdeb84
>          Events : 718938
> 
>     Number   Major   Minor   RaidDevice State
>        5      22        3        0      active sync   /dev/hdc3
>        1       8        3        1      active sync   /dev/sda3
>        3       3        3        2      active sync   /dev/hda3
>        4       8       35        3      active sync   /dev/sdc3
>        6       8       19        4      active sync   /dev/sdb3
> backup:~# 
> 
> 
> And so my plan is to get some liveCD with 2.6.31 (or maybe 2.6.32 ?).
> Connect the sixth drive, boot liveCD, perform the migration:
> 
> mdadm --add /dev/md2 /dev/sdd3
> mdadm --grow /dev/md2 --level=raid6 --raid-disks=6
> 
> Then reboot back into linux 2.6.24.
> 
> Will this work?

In principle, yes.
However:
  1/ you need linux 2.6.32 (not yet released).  Don't try with 2.6.31
  2/ you need mdadm 3.1.1 (not yet released).  Don't try with 3.1,
     which has been withdrawn.
  3/ You need a "--backup-file=/some/file" argument.  The /some/file
     must be on a different device.
  
> 
> Will 2.6.24 understand such raid6 ?

Yes.
  mdadm will first convert the RAID5 to a RAID6 in which the Q blocks
  are all on the last disk.  This is done instantly.
  Then mdadm will start and manage a process of re-laying out each
  stripe to have the Q blocks rotated around the various devices.
  This will take a while, approximately 1 day.  Once this is complete,
  you can then access the array from 2.6.24.

NeilBrown
