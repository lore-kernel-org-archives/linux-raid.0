From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Raid5 to raid6 reshape or recreate?
Date: Tue, 12 Aug 2014 20:05:53 -0500
Message-ID: <53EAB9F1.5030905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have read several threads about reshaping being very slow. I am seeing 
it myself when I converted 3-disk (2TB each) raid5 to 4-disk (again, 2TB 
each) raid6. I am only getting about 8M rate. I tried all sorts of 
things with /proc and /sys variables. Nothing helped. Each time I set 
something, I get a temporary boost to 10M/s, and after a little while, 
it settles down back to 8M/s rate.

I have currently very little in terms of useful files  in the raid 
(about 100G). I also took a fresh backup before the reshape and 
unmounted md0. Would it be faster if I trash the raid5 and create raid6 
from scratch instead of reshape? Any guess on how much faster? I 
typically got 100+M on checkarray cron jobs.  It would fire around 1-2AM 
and finish by 6-7AM on first Sun. Reshape has been running more than a 
day and has only about 45% done.

BTW, this is really old machine with SATA 3.0G and Athlon 64 X2 (max 
freq 2Ghz).  I also checked that my cpu is not running out of gas. In 
fact on-demand governet has reduced the freq to 1Ghz with about 50% cpu 
load. However uptime shows 2.7 jobs in the ready queue. Here are the 
actual outputs. Please let me know if I missed any optimization.

    lata:/home/rramesh# blockdev --getra /dev/sdb (all other sdx's also
    havethe same value)
    131072
    lata:/home/rramesh# cat /proc/sys/dev/raid/speed_limit_max
    200000
    lata:/home/rramesh# cat /proc/sys/dev/raid/speed_limit_min
    100000
    lata:/home/rramesh# cat /sys/block/md0/md/stripe_cache_active
    0
    lata:/home/rramesh# cat /sys/block/md0/md/stripe_cache_size
    16384
    lata:/home/rramesh# cat /sys/block/md0/md/sync_speed
    9265
    lata:/home/rramesh# cat /sys/block/md0/md/sync_speed_max
    200000 (system)
    lata:/home/rramesh# cat /sys/block/md0/md/sync_speed_min
    200000 (local)
    lata:/home/rramesh# cat /sys/block/md0/md/chunk_size
    524288
    lata:/home/rramesh# cat /proc/mdstat
    Personalities : [raid6] [raid5] [raid4]
    md0 : active raid6 sde1[4] sdb1[0] sdd1[3] sdc1[1]
           3906763776 blocks super 1.2 level 6, 512k chunk, algorithm 18
    [4/3] [UUU_]
           [=========>...........]  reshape = 46.1%
    (902017024/1953381888) finish=1907.6min speed=9184K/sec

    unused devices: <none>

    lata:/home/rramesh# iostat -xd 10 3
    Linux 3.2.0-4-amd64 (lata)      08/12/2014 _x86_64_        (2 CPU)

    Device:         rrqm/s   wrqm/s     r/s     w/s rkB/s    wkB/s
    avgrq-sz avgqu-sz   await r_await w_await  svctm %util
    sda               0.01     0.07    0.09    0.10 2.63     4.15   
    70.84     0.00    8.34    1.67   14.77   0.54 0.01
    sdb            2240.97  2241.60   39.15   23.44 18327.30 9040.86  
    874.57     1.38   22.11   18.74   27.74  10.41  65.16
    sdc            2240.41  2241.53   39.70   23.50 18327.36 9040.80  
    866.07     1.10   17.49   12.23   26.38   9.23  58.36
    sdd            2240.28  2241.47   39.84   23.56 18327.44 9040.83  
    863.38     1.03   16.21   10.96   25.09   8.68  55.03
    sde               0.02  2240.73    0.01   24.08     0.03 9039.95  
    750.62     0.37   15.49    0.91   15.49  10.18  24.53
    sdf               0.00     3.82    0.10   43.64     0.40 18869.21  
    862.92     2.29   52.34    1.37   52.45   5.01  21.93
    md0               0.00     0.00    9.32    0.35 758.03     1.39  
    157.08     0.00    0.00    0.00    0.00 0.00   0.00

    Device:         rrqm/s   wrqm/s     r/s     w/s rkB/s    wkB/s
    avgrq-sz avgqu-sz   await r_await w_await  svctm %util
    sda               0.00     0.00    0.00    0.00 0.00     0.00    
    0.00     0.00    0.00    0.00    0.00   0.00 0.00
    sdb            2155.90  2158.60   37.30   23.10 17561.60 8809.15  
    873.20     1.51   25.11   22.94   28.62  11.33  68.44
    sdc            2155.90  2158.60   37.40   23.00 17579.20 8757.95  
    872.09     1.13   18.74   11.99   29.70  10.11  61.04
    sdd            2155.90  2158.50   37.50   23.10 17630.40 8757.95  
    870.90     0.97   16.09   10.65   24.94   9.27  56.16
    sde               0.00  2158.10    0.00   23.50     0.00 8757.95  
    745.36     0.40   16.95    0.00   16.95  11.78  27.68
    sdf               0.00     2.20    0.00   41.70     0.00 18057.20  
    866.05     1.59   38.25    0.00   38.25   4.78  19.92
    md0               0.00     0.00    0.00    0.00 0.00     0.00    
    0.00     0.00    0.00    0.00    0.00   0.00 0.00

    Device:         rrqm/s   wrqm/s     r/s     w/s rkB/s    wkB/s
    avgrq-sz avgqu-sz   await r_await w_await  svctm %util
    sda               0.00     0.00    0.00    0.00 0.00     0.00    
    0.00     0.00    0.00    0.00    0.00   0.00 0.00
    sdb            1980.20  1980.80   31.80   20.70 15718.40 7989.55  
    903.16     1.52   28.92   24.42   35.85  13.78  72.36
    sdc            1980.20  1980.70   31.70   20.80 15700.80 7989.55  
    902.49     0.99   18.92   14.35   25.88  10.30  54.08
    sdd            1980.00  1980.90   31.70   20.60 15598.40 7989.55  
    902.02     0.89   16.99   11.81   24.95   9.23  48.28
    sde               0.00  1980.10    0.00   21.40     0.00 7989.55  
    746.69     0.35   16.13    0.00   16.13  11.07  23.68
    sdf               0.00     1.80    0.00   34.30     0.00 14774.80  
    861.50     1.53   44.79    0.00   44.79   5.36  18.40
    md0               0.00     0.00    0.00    0.00 0.00     0.00    
    0.00     0.00    0.00    0.00    0.00   0.00 0.00

Thanks in advance for your help. Even the assurance that I have done 
everything except waiting for a finish will make me feel better :-)

I wonder if my reshape is so slow because of constant seeks rather than 
read. All my disks are 5400 rpm (two WD green and two Samsung Ecogreen 5400)

I forgot, I did check SMART data, and did not find anything bad.

Regards
Ramesh

