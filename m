From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Wed, 3 Oct 2007 12:48:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710031248020.8612@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info>
 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@pccl.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Also if it is software raid, when you make the XFS filesyste, on it, it 
sets up a proper (and tuned) sunit/swidth, so why would you want to change 
that?

Justin.

On Wed, 3 Oct 2007, Justin Piszcz wrote:

> Have you checked fragmentation?
>
> xfs_db -c frag -f /dev/md3
>
> What does this report?
>
> Justin.
>
> On Wed, 3 Oct 2007, Andrew Clayton wrote:
>
>> Hi,
>> 
>> Hardware:
>> 
>> Dual Opteron 2GHz cpus. 2GB RAM. 4 x 250GB SATA hard drives. 1 (root file 
>> system) is connected to the onboard Silicon Image 3114 controller. The 
>> other 3 (/home) are in a software RAID 5 connected to a PCI Silicon Image 
>> 3124 card. I moved the 3 raid disks off the on board controller onto the 
>> card the other day to see if that would help, it didn't.
>> 
>> Software:
>> 
>> Fedora Core 6, 2.6.23-rc9 kernel.
>> 
>> Array/fs details:
>> 
>> Filesystems are XFS
>> 
>> Filesystem    Type    Size  Used Avail Use% Mounted on
>> /dev/sda2      xfs     20G  5.6G   14G  29% /
>> /dev/sda5      xfs    213G  3.6G  209G   2% /data
>> none         tmpfs   1008M     0 1008M   0% /dev/shm
>> /dev/md0       xfs    466G  237G  229G  51% /home
>> 
>> /dev/md0 is currently mounted with the following options
>> 
>> noatime,logbufs=8,sunit=512,swidth=1024
>> 
>> sunit and swidth seem to be automatically set.
>> 
>> xfs_info shows
>> 
>> meta-data=/dev/md0               isize=256    agcount=16, agsize=7631168 
>> blks
>>         =                       sectsz=4096  attr=1
>> data     =                       bsize=4096   blocks=122097920, imaxpct=25
>>         =                       sunit=64     swidth=128 blks, unwritten=1
>> naming   =version 2              bsize=4096
>> log      =internal               bsize=4096   blocks=32768, version=2
>>         =                       sectsz=4096  sunit=1 blks, lazy-count=0
>> realtime =none                   extsz=524288 blocks=0, rtextents=0
>> 
>> The array has a 256k chunk size using left-symmetric layout.
>> 
>> /sys/block/md0/md/stripe_cache_size is currently at 4096 (upping this from
>> 256, alleviates the problem at best)
>> 
>> I also have currently set /sys/block/sd[bcd]/queue/nr_requests to 512 
>> (doesn't
>> seem to have made any difference)
>> 
>> Also blockdev --setra 8192 /dev/sd[bcd] also tried 16384 and 32768
>> 
>> IO scheduler is cfq for all devices.
>> 
>> 
>> This machine acts as a file server for about 11 workstations. /home (the 
>> software RAID 5) is exported over NFS where by the clients mount their home 
>> directories (using autofs).
>> 
>> I set it up about 3 years ago and it has been fine. However earlier this 
>> year we started noticing application stalls. e.g firefox would become 
>> unrepsonsive and the window would grey out (under Compiz), this typically 
>> lasts 2-4 seconds.
>> 
>> During these stalls, I see the below iostat activity (taken at 2 second 
>> intervals on the file server). High iowait, high await's. The 
>> stripe_cache_active max's out and things kind of grind to halt for a few 
>> seconds until the stripe_cache_active starts shrinking.
>> 
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           0.00    0.00    0.00    0.25    0.00   99.75
>> 
>> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz 
>> avgqu-sz   await  svctm  %util
>> sda               0.00     0.00  0.00  5.47     0.00    40.80    14.91 
>> 0.05    9.73   7.18   3.93
>> sdb               0.00     0.00  1.49  1.49     5.97     9.95    10.67 
>> 0.06   18.50   9.00   2.69
>> sdc               0.00     0.00  0.00  2.99     0.00    15.92    10.67 
>> 0.01    4.17   4.17   1.24
>> sdd               0.00     0.00  0.50  2.49     1.99    13.93    10.67 
>> 0.02    5.67   5.67   1.69
>> md0               0.00     0.00  0.00  1.99     0.00     7.96     8.00 
>> 0.00    0.00   0.00   0.00
>> sde               0.00     0.00  0.00  0.00     0.00     0.00     0.00 
>> 0.00    0.00   0.00   0.00
>> 
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           0.25    0.00    5.24    1.50    0.00   93.02
>> 
>> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz 
>> avgqu-sz   await  svctm  %util
>> sda               0.00     0.00  0.00 12.50     0.00    85.75    13.72 
>> 0.12    9.60   6.28   7.85
>> sdb             182.50   275.00 114.00 17.50   986.00    82.00    16.24 
>> 337.03  660.64   6.06  79.70
>> sdc             171.00   269.50 117.00 20.00  1012.00    94.00    16.15 
>> 315.35  677.73   5.86  80.25
>> sdd             149.00   278.00 107.00 18.50   940.00    84.00    16.32 
>> 311.83  705.33   6.33  79.40
>> md0               0.00     0.00  0.00 1012.00     0.00  8090.00    15.99 
>> 0.00    0.00   0.00   0.00
>> sde               0.00     0.00  0.00  0.00     0.00     0.00     0.00 
>> 0.00    0.00   0.00   0.00
>> 
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           0.00    0.00    1.50   44.61    0.00   53.88
>> 
>> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz 
>> avgqu-sz   await  svctm  %util
>> sda               0.00     0.00  0.00  1.00     0.00     4.25     8.50 
>> 0.00    0.00   0.00   0.00
>> sdb             168.50    64.00 129.50 58.00  1114.00   508.00    17.30 
>> 645.37 1272.90   5.34 100.05
>> sdc             194.00    76.50 141.50 43.00  1232.00   360.00    17.26 
>> 664.01  916.30   5.42 100.05
>> sdd             172.00    90.50 114.50 50.00   996.00   456.00    17.65 
>> 662.54  977.28   6.08 100.05
>> md0               0.00     0.00  0.50  8.00     2.00    32.00     8.00 
>> 0.00    0.00   0.00   0.00
>> sde               0.00     0.00  0.00  0.00     0.00     0.00     0.00 
>> 0.00    0.00   0.00   0.00
>> 
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           0.25    0.00    1.50   48.50    0.00   49.75
>> 
>> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz 
>> avgqu-sz   await  svctm  %util
>> sda               0.00     0.00  0.00  1.50     0.00     2.50     3.33 
>> 0.00    0.33   0.33   0.05
>> sdb               0.00   142.50 63.50 115.50   558.00  1030.00    17.74 
>> 484.58 2229.89   5.59 100.10
>> sdc               0.00   113.00 63.00 114.50   534.00   994.00    17.22 
>> 507.33 2879.95   5.64 100.10
>> sdd               0.00   118.50 56.50 87.00   482.00   740.00    17.03 
>> 546.09 2650.33   6.98 100.10
>> md0               0.00     0.00  1.00  2.00     6.00     8.00     9.33 
>> 0.00    0.00   0.00   0.00
>> sde               0.00     0.00  0.00  0.00     0.00     0.00     0.00 
>> 0.00    0.00   0.00   0.00
>> 
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           0.00    0.00    1.25   86.03    0.00   12.72
>> 
>> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz 
>> avgqu-sz   await  svctm  %util
>> sda               0.00     0.50  0.00  1.50     0.00     6.25     8.33 
>> 0.00    1.33   0.67   0.10
>> sdb               0.00   171.00  0.00 238.50     0.00  2164.00    18.15 
>> 320.17 3555.60   4.20 100.10
>> sdc               0.00   172.00  0.00 195.50     0.00  1776.00    18.17 
>> 372.72 3696.45   5.12 100.10
>> sdd               0.00   188.50  0.00 144.50     0.00  1318.00    18.24 
>> 528.15 3935.08   6.93 100.10
>> md0               0.00     0.00  0.00  1.50     0.00     6.00     8.00 
>> 0.00    0.00   0.00   0.00
>> sde               0.00     0.00  0.00  0.00     0.00     0.00     0.00 
>> 0.00    0.00   0.00   0.00
>> 
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           0.00    0.00    0.75   73.50    0.00   25.75
>> 
>> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz 
>> avgqu-sz   await  svctm  %util
>> sda               0.00     0.00  0.00  0.00     0.00     0.00     0.00 
>> 0.00    0.00   0.00   0.00
>> sdb               0.50    67.16  1.49 181.59     7.96  1564.18    17.17 
>> 119.48 1818.11   4.61  84.48
>> sdc               0.50    70.65  1.99 177.11     9.95  1588.06    17.84 
>> 232.45 2844.31   5.56  99.60
>> sdd               0.00    77.11  1.49 149.75     5.97  1371.14    18.21 
>> 484.19 4728.82   6.59  99.60
>> md0               0.00     0.00  0.00  1.99     0.00    11.94    12.00 
>> 0.00    0.00   0.00   0.00
>> sde               0.00     0.00  0.00  0.00     0.00     0.00     0.00 
>> 0.00    0.00   0.00   0.00
>> 
>> 
>> When stracing firefox (on the client), during its stall period I see 
>> multi-second stalls in the open,close and unlink system calls. e.g
>> 
>> open("/home/andrew/.mozilla/firefox/default.d9m/Cache/1A190CD5d01", 
>> O_RDWR|O_CREAT|O_LARGEFILE, 0600) = 39 <8.239256>
>> close(39)                               = 0 <1.125843>
>> 
>> When its behaving I get numbers more like:
>> 
>> open("/home/andrew/.mozilla/firefox/default.d9m/sessionstore-1.js",
>> O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0600) = 39 <0.008773>
>> close(39)                               = 0 <0.265877>
>> 
>> Not the same file but sessionstore-1.js is 56K and 1A190CD5d01 is 37K
>> 
>> vim also has noticeble stalls, probably when it is doing its swap file 
>> thing.
>> 
>> My music is stored on the server and it never seems to be affected (player
>> accessing the files straight over nfs).
>> 
>> 
>> I have put up the current kernel config at
>> 
>> http://digital-domain.net/kernel/sw-raid5-issue/config
>> 
>> and the output of mdadm -D /dev/md0 at
>> 
>> http://digital-domain.net/kernel/sw-raid5-issue/mdadm-D
>> 
>> 
>> If anyone has any idea's I'm all ears.
>> 
>> 
>> Having just composed this message, I see this thread:
>> http://www.spinics.net/lists/raid/msg17190.html
>> 
>> I do remember seeing a lot of pdflush activity (using blktrace) around the
>> times of the stalls, but I don't seem to get the high cpu usage.
>> 
>> 
>> Cheers,
>> 
>> Andrew
>> 
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
