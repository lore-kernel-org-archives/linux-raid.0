From: SoulBlazer <soul@lamp-post.net>
Subject: Re: 2 HBA's and Multipath.
Date: Fri, 19 Apr 2002 12:18:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020419162031Z312453-22651+11469@vger.kernel.org>
References: <20020408190441Z313735-22651+2113@vger.kernel.org> <20020408200445Z313701-22651+2147@vger.kernel.org> <20020411094959.GE3256@colombina.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020411094959.GE3256@colombina.comedia.it>
To: bluca@comedia.it, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well I applied those modifications however I am noticing the following :

--BEGIN SNIPPIT--

# : mdadm -D /dev/md/1
/dev/md/1:
        Version : 00.90.00
  Creation Time : Fri Apr 19 12:14:13 2002
     Raid Level : multipath
     Array Size : 17688448 (16.86 GiB 18.11 GB)
   Raid Devices : 1
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Apr 19 12:14:13 2002
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

    Number   Major   Minor   RaidDevice State
       0      65      113        0      active sync   
/dev/scsi/host3/bus0/target1/lun0/part1
       1       8       17        1        
/dev/scsi/host2/bus0/target1/lun0/part1

--END SNIPPIT--

Additionally during a write operation to the volume I noticed the following 
during a dd(1) on the multipath device:

--BEGIN SNIPPIT--
# cd /proc/scsi/isp
# until [ 1 -gt 2 ] ; do grep Request 2 3; sleep 1; done
2: Req In 159   Req Out 158   Result 82 Nactv 0 HiWater 1 QAVAIL 1022 WtQHi 0
3: Req In 222   Req Out 226   Result 82 Nactv 255 HiWater 295 QAVAIL 3 WtQHi 0

2: Req In 159   Req Out 158   Result 82 Nactv 0 HiWater 1 QAVAIL 1022 WtQHi 0
3: Req In 744   Req Out 869   Result 82 Nactv 53 HiWater 295 QAVAIL 124 WtQHi

2: Req In 159   Req Out 158   Result 82 Nactv 0 HiWater 1 QAVAIL 1022 WtQHi 0
3: Req In 1001 Req Out 1016 Result 82 Nactv 295 HiWater 295 QAVAIL 14 WtQHi 0

2: Req In 159   Req Out 158   Result 82 Nactv 0 HiWater 1 QAVAIL 1022 WtQHi 0
3: Req In 592   Req Out 595   Result 82 Nactv 256 HiWater 295 QAVAIL 2 WtQHi 0
--END SNIPPIT--

This confirms what mdadm reported, in that only 1 of my FCAL Hba's (host3) 
was doing the work (active).

Is it possible to activate the spare device, I realize that multipath is for 
failover.. however could you not multiplex or trunk the FCAL hba's ?  The 
intended goal is to get 2gbps out of this sun a5200 22 disk fcal array in 
linux (the a5200 has 2 FCAL SES Gbic ports .. I am connecting 1 Hba per a5200 
port from my Linux box, each hba registers its own private loop to the array).

-- Off topic --
I am using the Qlogic FCAL driver written by Feral Softwares Matthew Jacob 
which is LGPL v2 for linux.  This driver is infinitely better then the 
bundled driver in the stock linux kernels and so far better then the 4.27B 
drivers from Qlogic themselves which seem riddled with bugs.  Why this has 
not been merged as of yet is beyond me as the other drivers seem unusable.

ftp://ftp.feral.com/pub/isp/isp_dist.tgz <-- the source.

Kudos again to Matthew Jacob for such an excellent driver for without which I 
would be forced to use Solaris and disksuite (ugh).


On April 11, 2002 05:49 am, Luca Berra wrote:
> On Mon, Apr 08, 2002 at 03:03:00PM -0500, SoulBlazer wrote:
> > What about write balancing ?
> >
> > I would also be interested in discussing a possible patch to the raid
> > code to do write/read balancing over N hba's if it is that trivial.
>
> the multipath_read_balance routine is actually used both for reading and
> writing besides with multipath we don't need to check the head position of
> the disk since they are supposed to be the same (if the concept of head
> position has any sense with your storage, which i strongly doubt).
>
> what we would need is adding an
> int last_used;
> to struct multipath_private_data
> in include/linux/raid/multipath.h
>
> then rewrite multipath_read_balance in drivers/md/multipath.c
> to look something like this.
>
> static int multipath_read_balance (multipath_conf_t *conf)
> {
>     int disk;
>
>     for (disk = conf->last_used + 1; disk != conf->last_used; disk++) {
> 	if (disk > conf->raid_disks)
> 	    disk = 0;
>         if (conf->multipaths[disk].operational)
> 	    return disk;
> 	}
>     BUG();
>     return 0;
> }
>
> that's all folks, unless i did some very big fuck-up in the code
