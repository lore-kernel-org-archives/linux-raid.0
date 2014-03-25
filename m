From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing RAID5 SSD Array
Date: Tue, 25 Mar 2014 15:31:39 -0500
Message-ID: <5331E7AB.9080904@hardwarefreak.com>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au> <532A0200.3070000@hardwarefreak.com> <532A5868.8060209@websitemanagers.com.au> <532DE6FC.5010301@hardwarefreak.com> <5331804B.6010708@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5331804B.6010708@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/25/2014 8:10 AM, Adam Goryachev wrote:
> I'll respond to the other email later on, but in between, I've found something else that seems just plain wrong.
> 
> So, right now, I've shutdown most of the VM's (just one Linux VM left, which should be mostly idle since it is after 11pm local time). I'm trying to create a duplicate copy of one LV to another as a backup (in case I mess it up). So, I've shutdown DRBD, so we are operating independently (not that there is any change if DRBD is connected), I'm running on the storage server itself (so no iscsi or network issues).
> 
> So, two LV's:
>   LV VG   Attr     LSize   Pool Origin Data%  Move Log Copy%  Convert
>   backup_xptserver1_d1_20140325_224311 vg0  -wi-ao-- 453.00g
>   xptserver1_d1                                              vg0 -wi-ao-- 452.00g

So you're copying 452 GB of raw bytes from one LV to another.

> running the command:

This is part of the problem:
> dd if=/dev/vg0/xptserver1_d1 of=/dev/vg0/backup_xptserver1_d1_20140325_224311

Using the dd defaults of buffered IO and 512 byte block size is horribly inefficient when copying 452 GB of data, especially to SSD.  Buffered IO consumes 904 GB of extra memory bandwidth.  Using 512 byte IOs requires much work of the raid5 write thread and more stripe cache bandwidth.  Use this instead:

dd if=/dev/vg0/xxx of=/dev/vg0/yyy iflag=direct oflag=direct bs=1536k

This eliminates 904 GB of RAM b/w in memcpy's and writes out to the block layer in 1.5 MB IOs, i.e. four full stripes.  This decreases the amount of work required of md as it receives 4 stripes of ligned IO at once, instead of 512 byte IOs which it must assemble.

> from another shell I run:
> while pidof dd > /dev/null;do kill -USR1 `pidof dd`;sleep 10;done
> 
> dd shows this output:
> 99059692032 bytes (99 GB) copied, 2515.43 s, 39.4 MB/s
> 99403235840 bytes (99 GB) copied, 2525.45 s, 39.4 MB/s
> 99817538048 bytes (100 GB) copied, 2535.47 s, 39.4 MB/s
> 100252660224 bytes (100 GB) copied, 2545.49 s, 39.4 MB/s

Yes, that is very low, worse than single rust.  Using the dd options above should bump this up substantially.  However I have read claims that LVM2 over md tends to decrease performance.  I'm still looking into that for verification.

When you performed the in depth FIO testing last year with the job files I provided, was the target the md RAID device or an LV?

> iostat -dmx 1 shows this output:
> 
> sda - sdg are the RAID5 SSD drives, single partition, used by md only
> dm-8 is the source for the dd copy
> dm-17 is the destination of the dd copy,
> dm-12 is the Linux VM which is currently running...
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdg             957.00  6767.00  930.00  356.00     8.68    27.65 57.85     0.65    0.50    0.16    1.39   0.37  48.00
> sdd             956.00  6774.00  921.00  313.00     8.69    27.50 60.06     0.26    0.21    0.08    0.60   0.17  20.80
> sda             940.00  6781.00  927.00  326.00     8.65    27.57 59.20     0.28    0.22    0.09    0.60   0.17  20.80
> sdf             967.00  6768.00  927.00  320.00     8.70    27.50 59.46     0.29    0.23    0.12    0.55   0.16  20.00
> sde             943.00  6770.00  933.00  369.00     8.69    27.71 57.26     0.74    0.57    0.16    1.60   0.44  57.20
> sdc             983.00  6790.00  937.00  317.00     8.86    27.55 59.46     1.58    1.27    0.71    2.90   0.49  61.60
> sdb             966.00  6813.00  929.00  313.00     8.76    27.57 59.92     1.20    0.97    0.34    2.84   0.49  61.20 
                  ^^^^^^^ ^^^^^^^
Note the difference between read merges and write merges, about 7:1, whereas the bandwidth is about 3:1.  That's about 7K read merges/s and 48K write merges/s.  Telling dd to use 1.5 MB IOs should reduce merges significantly, increasing throughout by a non negligible amount.  It should also decrease %util substantially, as less CPU time is required for merging, and less for md to assemble stripes from tiny 512 byte writes.

> md1               0.00     0.00 12037.00 42030.00    56.42 164.04     8.35     0.00    0.00    0.00    0.00   0.00   0.00
> drbd2             0.00     0.00 12034.00 41989.00    56.41 164.02     8.36   177.73    3.31    0.46    4.13   0.02  91.60
> dm-8              0.00     0.00 5955.00    0.00    23.26 0.00     8.00     4.43    0.74    0.74    0.00   0.01   6.40
> dm-12             0.00     0.00  254.00    5.00    10.39     0.02 82.38     0.28    1.08    1.01    4.80   0.59  15.20
> dm-17             0.00     0.00 5813.00 41984.00    22.71 164.00     8.00   174.87    3.65    0.15    4.13   0.02 100.00
... 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdg            1472.00     0.00 1681.00    0.00    14.70     0.00 17.90     0.14    0.08    0.08    0.00   0.08  13.60
> sdd            1472.00     0.00 1668.00    0.00    14.64     0.00 17.98     0.12    0.07    0.07    0.00   0.07  11.20
> sda            1472.00     0.00 1673.00    0.00    14.66     0.00 17.95     0.12    0.07    0.07    0.00   0.07  11.60
> sdf            1472.00     0.00 1680.00    0.00    14.69     0.00 17.91     0.13    0.08    0.08    0.00   0.07  12.40
> sde            1472.00     0.00 1685.00    0.00    14.71     0.00 17.88     0.12    0.07    0.07    0.00   0.07  11.60
> sdc            1478.00     0.00 1687.00    0.00    14.72     0.00 17.87     0.12    0.07    0.07    0.00   0.07  11.20
> sdb            1487.00     0.00 1679.00    0.00    14.69     0.00 17.92     0.14    0.08    0.08    0.00   0.08  13.20
> md1               0.00     0.00 22182.00    0.00   103.29 0.00     9.54     0.00    0.00    0.00    0.00   0.00   0.00
> drbd2             0.00     0.00 22244.00    0.00   103.66 0.00     9.54     5.76    0.26    0.26    0.00   0.03  59.60
> dm-8              0.00     0.00 10945.00    0.00    42.75 0.00     8.00     5.74    0.50    0.50    0.00   0.00   4.00
> dm-12             0.00     0.00  446.00    0.00    18.51     0.00 84.99     0.07    0.15    0.15    0.00   0.07   3.20
> dm-17             0.00     0.00 10836.00    0.00    42.33 0.00     8.00     0.58    0.05    0.05    0.00   0.05  57.60

No clue here.  You're reading exactly the same amount from the drives, drbd2, dm-8, and dm-17.  Given your description of a dd copy from dm-8 to dm-17, it seems odd that dm-8 and dm-17 are being read nearly the same number of bytes here, with no writes.

... 
> Another 15 seconds of 0.00 wMB/s on dm-17

These periods of no write activity suggest that your iostat timing didn't fully coincide with your dd copy.  If it's not that, then something is causing your write IO to stall entirely.  Any stack traces in dmesg?

> In fact, the peak value is 180.00 and the minimum is 0.00, with a total of 44 seconds of 0.00 and 16seconds over 100.00 and 16 seconds between 0 and 100.
> 
> Here is a look at top -b -d 0.5 -n 60|grep ^\%Cpu
>>>>   95.9% --  %Cpu0  :  2.1 us, 29.2 sy,  0.0 ni,  4.2 id, 64.6 wa,  0.0 hi,  0.0 si,  0.0 st
>>>>   91.1% --  %Cpu0  :  0.0 us, 24.4 sy,  0.0 ni,  6.7 id, 66.7 wa,  0.0 hi,  2.2 si,  0.0 st
>>>>   82.9% --  %Cpu0  :  0.0 us, 25.5 sy,  0.0 ni, 14.9 id, 57.4 wa,  0.0 hi,  2.1 si,  0.0 st
>>>>   91.3% --  %Cpu0  :  2.2 us, 32.6 sy,  0.0 ni,  4.3 id, 56.5 wa,  0.0 hi,  4.3 si,  0.0 st
>>>>  100.0% --  %Cpu0  :  4.0 us, 42.0 sy,  0.0 ni,  0.0 id, 54.0 wa,  0.0 hi,  0.0 si,  0.0 st
>>>>  100.0% --  %Cpu0  :  2.2 us, 39.1 sy,  0.0 ni,  0.0 id, 58.7 wa,  0.0 hi,  0.0 si,  0.0 st
>>>>   93.5% --  %Cpu0  :  2.2 us, 34.8 sy,  0.0 ni,  4.3 id, 56.5 wa,  0.0 hi,  2.2 si,  0.0 st

It would appear that the raid5 write thread is being scheduled only on Cpu0, which is not good as core0 is the only core on this machine that processes interrupts.  Hardware interrupt load above is zero, but with a real disk and network throughput rate it will eat into the cycles needed by the RAID5 thread.  

The physical IO work does not seem to be spread very well across all 4 cores.  However, the data rates are so low here it's difficult to come to any conclusion.  Cores 1-2 are performing a little work, 5-10% or so.  If you present a workload with bare minimal optimization, removing the choke hold from md and the elevator, as in my dd example up above, I'm sure you'll see much more work done by the other cores, as there will be far more IO to process.
 
> Currently, there are no LVM snapshots at all, the raid array is in sync, operating normally:
> md1 : active raid5 sdd1[7] sdb1[11] sdc1[10] sdf1[9] sdg1[5] sde1[8] sda1[6]
>       2813087616 blocks super 1.2 level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
> 
> mdadm --detail /dev/md1
> /dev/md1:
>         Version : 1.2
>   Creation Time : Wed Aug 22 00:47:03 2012
>      Raid Level : raid5
>      Array Size : 2813087616 (2682.77 GiB 2880.60 GB)
>   Used Dev Size : 468847936 (447.13 GiB 480.10 GB)
>    Raid Devices : 7
>   Total Devices : 7
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Mar 25 23:55:42 2014
>           State : active
>  Active Devices : 7
> Working Devices : 7
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            Name : san1:1  (local to host san1)
>            UUID : 707957c0:b7195438:06da5bc4:485d301c
>          Events : 1713337
> 
>     Number   Major   Minor   RaidDevice State
>        7       8       49        0      active sync   /dev/sdd1
>        6       8        1        1      active sync   /dev/sda1
>        8       8       65        2      active sync   /dev/sde1
>        5       8       97        3      active sync   /dev/sdg1
>        9       8       81        4      active sync   /dev/sdf1
>       10       8       33        5      active sync   /dev/sdc1
>       11       8       17        6      active sync   /dev/sdb1
> 
> 
> Also, the DRBD is disconnected:
>  2: cs:WFConnection ro:Primary/Unknown ds:UpToDate/DUnknown C r-----
>     ns:79767379 nr:0 dw:137515806 dr:388623024 al:37206 bm:6688 lo:0 pe:0 ua:0 ap:0 ep:1 wo:f oos:58639192

According to your iostat output above, drbd2 was indeed still engaged.  And eating over 59.6% and 91.6% of a core.
 
> So, I know dd isn't the ideal performance testing tool or metric, but I'd really like to know why I can't get more than 40MB/s. There is no networking, no iscsi, just a fairly simple raid5, drbd, and lvm.

You can get much more than 40MB/s, but you must know your tools, and gain a better understanding of the Linux IO subsystem.

> So, am I crazy? What totally retarded thing have I done here?

No, not crazy.  Not totally retarded.  You simply shoved a gazillion 512 byte IOs through the block layer.  Even with SSDs that's going to be slow due to the extra work the kernel threads must perform on all those tiny IOs, and all the memory bandwidth consumed by buffered IO and stripe cache operations.

The problem with your dd run here is the same problem you had before I taught you how to use FIO a year ago.  If you recall you were testing back then with a single dd process.  As I explained then, dd is a serial application.  It submits blocks one at a time with no overlap, and thus can't keep the request pipeline full.  With FIO and an appropriate job file, we kept the request pipeline full using parallel requests, and we used large IOs to keep overhead to a minimum.  The only way to increase dd throughput is to use large blocks and O_DIRECT to eliminate the RAM bandwidth of two unneeded memcpy's.

You've simply forgotten that lesson, apparently.  Which is a shame, as I spent so much time teaching you the how and why of Linux IO performance...

Cheers,

Stan

