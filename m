From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Reason for md raid1 max_sectors_kb limited to 127?
Date: Tue, 08 May 2012 18:07:13 +0200
Message-ID: <4FA944B1.3010509@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/05/12 17:33, Sebastian Riemer wrote:
> O.K., I've also tested 3.2.16 and there the problem still exists.
> Bernd pinpointed me to commit b1bd055d397e09f99dcef9b138ed104ff1812fcb
> (block: Introduce blk_set_stacking_limits function).
>
> After cherry-picking it on 3.2.16 it worked. Tomorrow I'll test the
> performance impact and verify it by block tracing.
>
> Cheers,
> Sebastian
>   

I've measured the performance impact today.

This is my test system:
Supermicro H8DGi mainboard
2 x 8-core Opteron 6128, 2 GHz
32 GB RAM
LSI MegaRAID 9260-4i
16 x SEAGATE ST31000424SS nearline SAS
NFS root

Each HDD is exported by the HW RAID controller write through, direct, no
read-ahead.
These virtual drives have max_sectors_kb 320 only, but should be O.K.
for a first test.

I've got 8 x md raid1 and md raid0 on top, because we consider the md
raid10 driver to be worse in performance especially with >= 24 HDDs with
kernel 3.2. I've got also LVM on top with a 50 GiB LV. The LV has ext4
on it.

First I've tested the file copy on unpatched 3.2.16 kernel:
*312 MB/s* in average

Now, patched with the fix:
*379 MB/s* in average

That's a clear improvement, because of the big chunks! With a SAS HBA
and max_sectors_kb 512 this could be even better.

My copy test creates the file to be copied with fio and direct IO in
order to get random data into the file and to bypass all caching. Here
is the simple code:

#!/bin/bash
SIZES="1G"
FILE="test"
FILE2="test2"
MOUNTPOINT="/mnt/bench1"

for size in $SIZES; do
    rm -f $MOUNTPOINT/$FILE $MOUNTPOINT/$FILE2
    fio -name iops -rw=write -size="$size" -iodepth 1 -filename
$MOUNTPOINT/$FILE -ioengine libaio -direct=1 -bs=1M
    echo -e "\n*** Starting Copy Test ***"
#    blktrace /dev/md119 -b 4096 &
#    pid=$!
    time $(cp $MOUNTPOINT/$FILE $MOUNTPOINT/$FILE2; sync)
#    kill -2 $pid
done

Cheers,
Sebastian

