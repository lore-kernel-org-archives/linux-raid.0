From: Luca Berra <bluca@comedia.it>
Subject: Re: 2 HBA's and Multipath.
Date: Fri, 19 Apr 2002 23:58:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020419215843.GB21753@colombina.comedia.it>
References: <20020408190441Z313735-22651+2113@vger.kernel.org> <20020408200445Z313701-22651+2147@vger.kernel.org> <20020411094959.GE3256@colombina.comedia.it> <20020419162031Z312453-22651+11469@vger.kernel.org>
Reply-To: bluca@comedia.it
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020419162031Z312453-22651+11469@vger.kernel.org>
To: SoulBlazer <soul@lamp-post.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 19, 2002 at 12:18:11PM -0400, SoulBlazer wrote:
> Well I applied those modifications however I am noticing the following :
> 
> --BEGIN SNIPPIT--
> 
> # : mdadm -D /dev/md/1
> /dev/md/1:
>         Version : 00.90.00
>   Creation Time : Fri Apr 19 12:14:13 2002
>      Raid Level : multipath
>      Array Size : 17688448 (16.86 GiB 18.11 GB)
>    Raid Devices : 1
>   Total Devices : 2
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>     Update Time : Fri Apr 19 12:14:13 2002
>           State : dirty, no-errors
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 1
> 
>     Number   Major   Minor   RaidDevice State
>        0      65      113        0      active sync   
> /dev/scsi/host3/bus0/target1/lun0/part1
>        1       8       17        1        
> /dev/scsi/host2/bus0/target1/lun0/part1
> 

Oops,
seems i forgot about spares :(

multipath.c sets all disks as spares to start with.
a dirty hack could be:

look for:
        /*
         * Mark all disks as spare to start with, then pick our
         * active disk.  If we have a disk that is marked active
         * in the sb, then use it, else use the first rdev.
         */

below you will find:
       if (disk_active(desc)) {
            if(!conf->working_disks) { //remove this line
                printk(OPERATIONAL, partition_name(rdev->dev),
                    desc->raid_disk);
                disk->operational = 1;
                disk->spare = 0;
                conf->working_disks++;
                def_rdev = rdev;
            } else { //remove this line
                mark_disk_spare(desc); //remove this line
            } //remove this line
        } else
            mark_disk_spare(desc);

remove the lines i market with //remove this line
and it should activate the disks

i wont have a system at hand to test this, so please let me know
if it works

we then need to clean up the logic for initialization
since is nonsense to set a disk as spare then reset it back
again as operational, but this could work for a start

good luck

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
