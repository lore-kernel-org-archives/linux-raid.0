From: Neil Brown <neilb@suse.de>
Subject: Re: Crash during raid6 reshape, now cannot restart?
Date: Sat, 11 Dec 2010 07:43:05 +1100
Message-ID: <20101211074305.5f55c4b4@notabene.brown>
References: <AANLkTimk7Ecth7n+qPZ7R-JOAmCmJUJbCTAw3uY8FpPO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimk7Ecth7n+qPZ7R-JOAmCmJUJbCTAw3uY8FpPO@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Genera <pg@fivesevenfive.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Dec 2010 09:05:47 -0800 Phil Genera <pg@fivesevenfive.org> wrote:

> I had a power failure during a large raid6 reshape (6->8 disks) on one
> of my arm systems last night, and can't seem to get it going again.
> 
> I did this:
> # mdadm --grow --backup-file=./backup.mdadm --array-size=8 /dev/md0
> 
> which (I've now noticed) didn't seem to write a backup file. There was
> a read error during the reshape, but it claimed recovery:
> Dec  9 20:48:07 love kernel: sd 2:0:0:0: [sda] Unhandled sense code
> Dec  9 20:48:07 love kernel: sd 2:0:0:0: [sda] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> Dec  9 20:48:07 love kernel: sd 2:0:0:0: [sda] Sense Key : Medium
> Error [current]
> Dec  9 20:48:07 love kernel: sd 2:0:0:0: [sda] Add. Sense: Unrecovered
> read error
> Dec  9 20:48:07 love kernel: sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00
> 02 09 60 00 00 20 00
> Dec  9 20:48:07 love kernel: end_request: I/O error, dev sda, sector 133472
> Dec  9 20:48:08 love kernel: raid5:md0: read error corrected (8
> sectors at 133472 on sda)
> Dec  9 20:48:08 love kernel: raid5:md0: read error corrected (8
> sectors at 133480 on sda)
> Dec  9 20:48:08 love kernel: raid5:md0: read error corrected (8
> sectors at 133488 on sda)
> Dec  9 20:48:08 love kernel: raid5:md0: read error corrected (8
> sectors at 133496 on sda)
> 
> Some time during the night, the electricity went away, and on reboot I get this:
> 
> raid5: reshape_position too early for auto-recovery - aborting.

Something must be going wrong with the math in raid5:

               if (mddev->delta_disks < 0
                    ? (here_new * mddev->new_chunk_sectors <=
                       here_old * mddev->chunk_sectors)
                    : (here_new * mddev->new_chunk_sectors >=
                       here_old * mddev->chunk_sectors)) {
                        /* Reading from the same stripe as writing to - bad */
                        printk(KERN_ERR "raid5: reshape_position too early for "
                               "auto-recovery - aborting.\n");
                        return -EINVAL;
                }

there 'here_new* new_chunk_size' must be over-flowing.  So the size of the
array must only just fit into sector_t.
On and arm5 you would need to have CONFIG_LBD set - do you know if it is?

I guess I need to make that code more robust when sector_t doesn't have lots
more bits that the size of the device...

If you can compile your own kernel, you should be able to get it to work
easily.  If not ... complain to whoever provided you with a kernel.

NeilBrown



> 
> as well as when I try to assemble the array manually. There's nothing
> critical I don't have backed up, but there's a lot of TV on there I
> was planning to watch :).
> 
> Any good ideas? I'd sure appreciate some help. I'm guessing this is
> just a crash in the critical section, and without a backup file I'm
> screwed. I'm surprised the backup file is still needed 200gb into the
> reshape though. Thanks!
> 
> 
> Versions & status:
> 
> # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md0 : inactive sdg[0] sdj[7] sdi[6] sdf[5] sde[4] sdd[3] sdc[2] sdh[1]
>       3125690368 blocks super 0.91
> 
> # uname -a
> Linux love 2.6.32-5-kirkwood #1 Sun Oct 31 11:19:32 UTC 2010 armv5tel GNU/Linux
> # mdadm --version
> mdadm - v3.1.4 - 31st August 2010
> 
> 
> More details (and --examine of all disks attached):
> 
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.91
>   Creation Time : Fri Oct  9 09:32:08 2009
>      Raid Level : raid6
>   Used Dev Size : 390711296 (372.61 GiB 400.09 GB)
>    Raid Devices : 8
>   Total Devices : 8
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Fri Dec 10 05:52:35 2010
>           State : active, Not Started
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>   Delta Devices : 2, (6->8)
> 
>            UUID : 81ddccd8:5abf5b03:181548d9:47e92625
>          Events : 0.1048248
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       96        0      active sync   /dev/sdg
>        1       8      112        1      active sync   /dev/sdh
>        2       8       32        2      active sync   /dev/sdc
>        3       8       48        3      active sync   /dev/sdd
>        4       8       64        4      active sync   /dev/sde
>        5       8       80        5      active sync   /dev/sdf
>        6       8      128        6      active sync   /dev/sdi
>        7       8      144        7      active sync   /dev/sdj
> 
> --
> Phil

