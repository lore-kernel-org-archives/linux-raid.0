From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Reliability of bitmapped resync
Date: Tue, 24 Feb 2009 20:39:31 +0100
Message-ID: <20090224193931.GB3470@lazy.lzy>
References: <20090223194019.GA3488@lazy.lzy> <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name> <20090223201905.GA7585@lazy.lzy> <e3d195aab8b8de113e146e2932996777.squirrel@neil.brown.name> <20090223214016.GB18555@lazy.lzy> <16ff0082259ce384e30c4a7f9a0e66fb.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16ff0082259ce384e30c4a7f9a0e66fb.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> I'll wait for these details before I start hunting further.

OK, here we are.
Some forewords, the last disk to fail at boot was
/dev/sda, this data was collected after a "clean"
add of the /dev/sda3 to the RAID.
This means the superblock was zeroed and the device
added, so it should be clean.

mdadm --examine /dev/sda3

/dev/sda3:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : b601d547:b62e9563:2c68459c:22db163f
           Name : root
  Creation Time : Tue Feb 10 15:43:09 2009
     Raid Level : raid10
   Raid Devices : 2

 Avail Dev Size : 483941796 (230.76 GiB 247.78 GB)
     Array Size : 483941632 (230.76 GiB 247.78 GB)
  Used Dev Size : 483941632 (230.76 GiB 247.78 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : f3665458:d51d27f5:87724fb8:529f91f1

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb 24 09:03:46 2009
       Checksum : 68a2de81 - correct
         Events : 6541

         Layout : near=1, far=2
     Chunk Size : 64K

    Array Slot : 3 (failed, failed, 1, 0)
   Array State : Uu 2 failed


mdadm --examine-bitmap /dev/sda3

        Filename : /dev/sda3
           Magic : 6d746962
         Version : 4
            UUID : b601d547:b62e9563:2c68459c:22db163f
          Events : 6541
  Events Cleared : 6540
           State : OK
       Chunksize : 256 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 241970816 (230.76 GiB 247.78 GB)
          Bitmap : 945199 bits (chunks), 524289 dirty (55.5%)

Now, one thing I do not understand, but maybe it is
anyway OK, and it is this last line:

          Bitmap : 945199 bits (chunks), 524289 dirty (55.5%)

Because the array status was fully recovered (in sync)
and /dev/sdb3 showed:

          Bitmap : 945199 bits (chunks), 1 dirty (0.0%)

Confirmed somehow by /proc/mdstat

How it could be 55.5% dirty? Is this expected?

Further note.

I tested, on an identical PC, with a slightly different
RAID (metadata 1.0 vs. 1.1), the following:

mdadm --fail /dev/md2 /dev/sdb3
wait a little
mdadm --remove /dev/md2 /dev/sdb3
do something to make the bitmap a bit dirty
mdadm --re-add /dev/md2 /dev/sdb3
wait for resync to finish with "watch cat /proc/mdstat"
echo check > /sys/block/md/md2/sync_action
watch cat /proc/mdstat /sys/block/md/md2/mismatch_cnt

Now, immediatly the mismatch count went to something
like 1152 (or similar).
After around 25% of the check it was around 1440,
then I issued an "idle" and re-added the disk cleanly.

This repeats the experience I already had.

This is still a RAID-10 f2, with header 1.0, chunk 64KB
and bitmap chunksize of 16MB (or 16384KB).

Somehow it seems, at least on this setup, that
the bitmap does not track everything or the
resync does not consider all the bitmap chunk.

Thanks,

bye,

-- 

piergiorgio
