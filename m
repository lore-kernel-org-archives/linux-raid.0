From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID5 Performance
Date: Tue, 2 Aug 2016 17:09:31 +1000
Message-ID: <36cb010d-0b77-964e-fae5-5494e5f7766b@websitemanagers.com.au>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
 <22424.50313.900162.715200@tree.ty.sabi.co.uk>
 <CAFx4rwSRYDACX631eLpX7Jr9jB2u4jbC7dr-0rdi9U1nV9og3Q@mail.gmail.com>
 <22425.63565.439521.592849@tree.ty.sabi.co.uk>
 <22426.2167.369879.756599@tree.ty.sabi.co.uk>
 <a0921a51-d841-7fbd-0f31-21f5ba8c6f4b@websitemanagers.com.au>
 <22426.16080.579831.750402@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22426.16080.579831.750402@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/07/16 03:20, Peter Grandi wrote:
> [ ... ]
>
>>> * Replace the flash SSDs with those that are known to deliver
>>>    high (at least > 10,000 single threaded) small synchronous
>>>    write IOPS.
>> Is there a "known" SSD that you would suggest? My problem is
>> that Intel spec sheets seem to suggest that there is little
>> performance difference across the range of SSD's, so it's
>> really not clear which SSD model I should buy.
> The links I wrote earlier have lists:
Thanks for reminding me of that. I see that the list reflects my 
experience (if we assume the 530 model is equivalent to the 535 model on 
the list, and my 520 480GB is equivalent to the 520 on the list).

However, I can't get the budget for those really awesome drives up the 
top of the list, that would require around $20k... or more.

For now, I've got 16 x 545s TB drives, and have replaced the first half 
(ie, all drives in one server). Now I can see that the drives themselves 
don't seem to be the bottleneck (the drives don't run at 100% util, 
while the DRBD device does run at 100%).

I've written a small script to keep track of the number of seconds each 
drive util value fits into each bracket (increments of 10%). Let me know 
if you would like a copy (it's just a perl script which reads iostat 
output, I'm sure it could be written much nicer).
So far, this is what I get on the secondary (with the new 8 x 845s 1TB 
drives):
Drive          10        20       30       40    50    60    70 80    
90   100
md1        19265         0        0        0      0      0 0      0      
0    0
sda         17029    1579    404    137    49    45    13 4      4    1
sdb         16983    1453    477    179    77    63    22      6 3     2
sdc         16867    1579    492    182    76    40    17      8 1     3
sdd         17043    1499    445    154    59    40    14      6 3     2
sde         17064    1506    415    152    68    32    15      4 6     3
sdf          17138    1467    396    152    46    37    11    10 4     4
sdg         17118    1493    401    139    56    31    14      7 2     4
sdh         16997    1577    407    138    62    45    11    10 7     6
sdi          19236        12        4        4      2      0      2      
3     0     1

Hopefully that will line up right !
So, out of the last 19265 seconds, each of the underlying drives was at 
100% for only a couple of seconds (sdi is the OS drive). ie, the last 
column shows the number of seconds the drive was at 90 to 100% util as 
reported by iostat. The 10 column shows number of seconds between 0 and 
10%, etc...

Looking at the primary, with all 520 series drives (except sda which is 
a 545s series) and the DRBD drives I see this:

Drive           10         20        30     40     50    60    70 80    
90    100
drbd0        19971    108       54     36     13      2      0 2      1 
      1
drbd1        19842    165       77     48     34      4      6 5      3  
     3
drbd10      19766    279       62     35     23      7      6 4      
2      1
drbd11      20081    37         32     21     12      1      3 1      
0      0
drbd12      20041    79         38     19       9      1      0 0      
1      0
drbd13      16195    2335   758   338   220  131    77    39 32    58
drbd14      19765    230       90     49     30      9      4 6      2   
    1
drbd15        3473    6323 4136 2250 1390  913  614  443  418  220
drbd17      20175    9             1       0       3      0      0      
0      0      0
drbd18      19878    170       65     29     23    10      4 0      6      1
drbd19      19255    368     138     86     87  100    39    35 44    35
drbd2        20188    0             0       0       0      0      0     
0      0      0
drbd3        17457    1276   610   316   175  140    66    43 33    56
drbd4        20154    17          6        6       5      0      0     
0      0      0
drbd5        19859    141      59      38     26    10      4 5      3    42
drbd6        20112    39        20        9       3      1      1   1    
   1      0
drbd7        20188    0            0        0       0      0      0     
0      0      0
drbd8        19894    136      78      44     22      5      3 2      0  
     2
drbd9        19476    289    211    123     41    21      9      6     
3      7
md1          20188    0            0        0       0      0      0     
0      0      0
sda           16948    1696   439    286   213  206  316    81 3      0
sdb           16059    2177   844    402   290  352    50    13 1      0
sdc           16141    2132   852    388   312  328    30      5    0      0
sdd           15914    2182   956    395   300  362    72      6    1      0
sde           16099    2137   801    393   256  366  124    10 1      1
sdf            16000    2169   898    408   322  340    39      9    3   
    0
sdg           15929    2265   822    418   259  290  195      8 2      0
sdh           16107    2129   822    419   324  337    41      9    0      0
sdi            20155    3             3        7     14      6 0      
0      0      0

So on the primary, I see even less of a bottleneck on the underlying 
drives, which doesn't make a lot of sense to me. The secondary has less 
read load (since all reads are handled by the primary), and should only 
need to deal with raid rmw. Also, I'm not sure, but I think the 
secondary does less meta data updates for DRBD. So I can only presume 
the new drives are much better than the 530 series, but still not as 
good as the 520 series. I'll need to run some tests before I put the 
drives live next time.

However, the point of note is that DRBD devices are showing high util 
levels much more frequently than the underlying devices, so I can only 
assume that the current limitation is caused by DRBD rather than the 
drives. Though probably solving the DRBD issue will then go back to the 
drives being the limit, with not a lot of difference. See below for my 
(your) ideas on improving both of those things.....

>>>>    https://www.sebastien-han.fr/blog/2014/10/10/ceph-how-to-test-if-your-ssd-is-suitable-as-a-journal-device/
>>>>    http://www.spinics.net/lists/ceph-users/msg25928.html
>>>>    https://www.redhat.com/en/resources/ceph-pcie-ssd-performance-part-1
> As one of those pages says the Samsung SM863 looks attractive,
> but for historical reasons so far I have only seen Intel DCs in
> similar use. There discussions of other models in various posts
> related to Ceph journal SSD usage.
>
>> Obviously it's not something I can afford to buy one of each
>> and test them either.
> In addition to the lists above I have justed tested my three
> home flash SSDs:
>
> * Micron M4 256GB:
>      #  dd bs=4k count=100000 oflag=direct,dsync if=/dev/zero of=/var/tmp/TEST
>      100000+0 records in
>      100000+0 records out
>      409600000 bytes (410 MB) copied, 1200.3 s, 341 kB/s
> * Samsung 850 Pro 256GB:
>      #  dd bs=4k count=100000 oflag=direct,dsync if=/dev/zero of=/var/tmp/TEST
>      100000+0 records in
>      100000+0 records out
>      409600000 bytes (410 MB) copied, 1732.93 s, 236 kB/s
> * Hynix SK SH910 256GB:
>      #  dd bs=4k count=100000 oflag=direct,dsync if=/dev/zero of=/var/tmp/TEST
>      100000+0 records in
>      100000+0 records out
>      409600000 bytes (410 MB) copied, 644.742 s, 635 kB/s
>
> So I would not recommend any of them for "small sync writes"
> workloads :-), but they are quite good otherwise. I do notice
> they are slow on small sync writes when downloading mail, as
> each message is duly 'fsync'ed.
>
> BTW as bonus material, I have done on the SH910 an abbreviated
> test with block sizes between 4KiB and 1024KiB:
>
>    #  for N in 4k 16k 64k 128k 256k 512k 1024k; do echo -n "$N: "; dd bs=$N count=1000 oflag=dsync if=/dev/zero of=/var/tmp/TEST |& grep copied; done
>    4k: 4096000 bytes (4.1 MB) copied, 6.23481 s, 657 kB/s
>    16k: 16384000 bytes (16 MB) copied, 6.29379 s, 2.6 MB/s
>    64k: 65536000 bytes (66 MB) copied, 6.09223 s, 10.8 MB/s
>    128k: 131072000 bytes (131 MB) copied, 6.5487 s, 20.0 MB/s
>    256k: 262144000 bytes (262 MB) copied, 6.93361 s, 37.8 MB/s
>    512k: 524288000 bytes (524 MB) copied, 7.73957 s, 67.7 MB/s
>    1024k: 1048576000 bytes (1.0 GB) copied, 12.8671 s, 81.5 MB/s
>
> Note how the time to write 1000 blocks is essentially the same
> betweeen 4KiB and 128KiB, which is quite amusing. Probably the
> flash-page size is around 256KiB.
>
> For additional bonus value the same on a "fastish" consumer 2TB
> disk, a Seagate ST2000DM001:
>
>    #  for N in 4k 16k 64k 128k 256k 512k 1024k; do echo -n "$N: "; dd bs=$N count=1000 oflag=dsync if=/dev/zero of=/fs/sdb6/tmp/TEST |& grep copied; done
>    4k: 4096000 bytes (4.1 MB) copied, 44.9177 s, 91.2 kB/s
>    16k: 16384000 bytes (16 MB) copied, 38.131 s, 430 kB/s
>    64k: 65536000 bytes (66 MB) copied, 35.8263 s, 1.8 MB/s
>    128k: 131072000 bytes (131 MB) copied, 35.8188 s, 3.7 MB/s
>    256k: 262144000 bytes (262 MB) copied, 36.6838 s, 7.1 MB/s
>    512k: 524288000 bytes (524 MB) copied, 37.0612 s, 14.1 MB/s
>    1024k: 1048576000 bytes (1.0 GB) copied, 42.0844 s, 24.9 MB/s
>

Yep, definitely won't be going backwards to spinning disks :)

>>> * Relax the requirement for synchronous writes on *both* the
>>>    primary and secondary DRBD servers, if feeling lucky.
>> I have the following entries for DRBD which were suggested by
>> linbit (which previously lifted performance from abysmal to
>> more than sufficient around 2+ years ago). [ ... ]
> That's an inappropriate use of "performance" here:
>
>>           disk-barrier no;
>>           disk-flushes no;
>>           md-flushes no;
> That "feeling lucky" list seems to me to have made performance
> lower (in the sense that the performance of writing to
> '/dev/null' is zero, even if the speed is really good :->).
>
> With those settings the data sync policy is "disk-drain", which
> also involves some waiting, but somewhat dangerous, except "In
> case your backing storage device has battery-backed write cache"
> (and "device" here means system and host adapter and disk); it
> is not clear to me for metadata what "md-flushes no" gives.
>
> BTW if you have battery-backed everything on the secondary side
> you could use protocol "B".
 From my understanding, the times these settings can cause a problem:
1) When both servers hard power off - possibly all the latest data is 
not written to disk that the VM's expect. If this is the case, all the 
VM's were also hard powered off, and so the VM has no idea about what it 
expects to be written/not. The end user may need to redo some work/etc, 
but that is acceptable. Worst case scenario, a DB file is corrupted and 
needs to be restored from the previous night backup, and users must redo 
all work, which is also "acceptable" (from a risk point of view).
2) One server hard power off, perhaps power supply failure/etc - When it 
powers on again, it should re-sync with the DRBD primary, and 
potentially we do a DRBD verify to confirm everything is good. As long 
as there is no failure on the primary, then everything is good. Worst 
case, catastrophic failure of the primary before the verify is complete, 
or before the secondary comes on-line again, and basically we treat it 
as above.

We can't deal with every possible scenario, as the cost is prohibitive, 
we can only deal with the more common scenarios, and those that are 
cheaper to deal with. eg, all equipment is protected by UPS, using 
redundancy RAID instead of linear/striping, and using DRBD for 
replication. Most likely failures are disk, power supply, or network 
cables (ie, unplugged by accident/etc), and this setup protects well for 
all three of those.
> However given those it looks likely that the bottleneck is also
> on the primary DRBD side.
>
>> Do you have any other suggestions or ideas that might assist?
> * Smaller RAID5 stripes, as in 4+1 or 2+1, are cheaper in space
>    than RAID10 and enormously raise the chances that a full
>    stripe-write can happen (it still has the write-hole problem
>    of parity RAID).
I was planning to upgrade to the 4.4.x kernel, which would kind of solve 
this, since it will only read from 2 drives anyway, but it turns out 
that is more difficult than I expected. (iscsitarget kernel module 
doesn't compile cleanly with the new kernel, and it doesn't seem to be 
well supported into such recent kernel versions. I'll probably wait 
until debian testing becomes stable, or at least a lot closer, before 
going down that path).

I could potentially move to 2 x RAID5 with 3+1 and then linear or stripe 
those, which means I only lose one extra disk of capacity.... Will need 
to think about that further...

> * Make sure the DRBD journal is also on a separate device that
>    allows fast small sync writes.

I think this would be the next option to investigate. Currently the DRBD 
journal is on the same devices.
Reading from: 
http://www.drbd.org/en/doc/users-guide-84/ch-internals#s-internal-meta-data
>
> *Advantage. *For some write operations, using external meta data 
> produces a somewhat improved latency behavior.
>
Do you have any more knowledge on the expected performance advantage? 
ie, would half the writes move from the data drive to the meta data drive?
I'm thinking it might be plausible to purchase 2 x Intel P3700 400GB and 
put one in each DRBD server for the meta data updates. Although if this 
isn't going to make much difference (eg, only 20%) then it is less 
likely to be worthwhile...
Can anyone suggest what kind of performance improvement might I see by 
doing this?
The alternative (for double the cost + a bit more) would be to migrate 
from RAID5 to RAID10, is that likely to produce a better/worse result?

2 x P3700 400GB is probably around $2500, while 12 x 545s 1000GB is 
around $4800, but would need to add another SATA controller card, which 
probably means changing motherboard/CPU/etc as well, so that becomes a 
lot more....

> Also, I have appended a sample DRBD configuration I have used:
>
> ----------------------------------------------------------------
>
>      # http://article.gmane.org/gmane.linux.network.drbd/18348
>      # http://www.drbd.org/users-guide-8.3/s-throughput-tuning.html
>      # https://alteeve.ca/w/AN!Cluster_Tutorial_2_-_Performance_Tuning
>      # http://fghaas.wordpress.com/2007/06/22/performance-tuning-drbd-setups/
>      sndbuf-size		    0;
>      rcvbuf-size		    0;
>      max-buffers		    16384;
>      unplug-watermark	    16384;
>      max-epoch-size	    16384;
I have similar values, but will need to investigate the above options 
further. rcvbuf-size doesn't seem to be well documented, at least in the 
DRBD 8.4 manual, but will research these some more. Then will also need 
to check how to modify the values without causing a system meltdown....

Thanks again for your advice/information, it is very helpful.

Regards,
Adam



-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
