From: Bart Kus <me@bartk.us>
Subject: Re: Increasing maxsect of md devices?
Date: Wed, 02 Mar 2011 16:45:54 -0800
Message-ID: <4D6EE4C2.4030306@bartk.us>
References: <4D6EC3FA.4030809@bartk.us> <20110303095929.25b800da@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110303095929.25b800da@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/2/2011 2:59 PM, NeilBrown wrote:
> On Wed, 02 Mar 2011 14:26:02 -0800 Bart Kus<me@bartk.us>  wrote:
>
>> Hello,
>>
>> This seems contradictory:
>>
>> jo ~ # blockdev --getiomin /dev/md5
>> 524288
>> jo ~ # blockdev --getioopt /dev/md5
>> 4194304
>> jo ~ # blockdev --getmaxsect /dev/md5
>> 255
>> jo ~ # blockdev --getbsz /dev/md5
>> 4096
>> jo ~ # blockdev --getss /dev/md5
>> 512
>> jo ~ #
>>
>> Optimal IO size is reported as 4MB (and that is indeed the stripe size),
>> but maximum sectors per request is only 128kB?  How can software do
>> optimal 4MB IOs with the maxsect limit?  Does XFS care about this limit?
> md/raid doesn't use 'requests' the any maximum is meaningless.
> raid4/5/6 does have a 'stripe cache' which is a vaguely similar thing.  There
> can sometimes be value in changing that.
>
> The devices that the array are built from may have a 'maximum sectors per
> request', but that probably isn't particularly related to chunk size.
>
> BTW, where do you find "maximum sectors per request in only 128kB" in the
> details you quoted - I don't see it.
>

I got the notion from seeing blockdev's help text:

         --getmaxsect                   get max sectors per request

Seeing 255 sectors there, and multiplying by sector size (512B), you get 
128kB (ok, 127.5kB).

The reason for my curiosity here is that I have a large linear write 
load to this RAID6 md array, and I'm seeing about 25% of the IOs being 
reads!  I've configured the stripe cache size to 6553: 4096*6553 is 
about 26MB/device, and there's 10 devices, so let's say 256MB total 
stripe cache size.  During this large linear write I mostly see "128" in 
stripe_cache_active, which is 128*4096 = 512kB, which is the same as 
chunk size.  So given all this, here are the reads I'm seeing in "sar 
-pd 1":

14:06:20          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  
avgqu-sz     await     svctm     %util
[...snip!...]
14:06:21          sde    219.00  11304.00  30640.00    191.53      
1.15      5.16      2.10     46.00
14:06:21          sdf    209.00  11016.00  29904.00    195.79      
1.06      5.02      2.01     42.00
14:06:21          sdg    178.00  11512.00  28568.00    225.17      
0.74      3.99      2.08     37.00
14:06:21          sdh    175.00  10736.00  26832.00    214.67      
0.89      4.91      2.00     35.00
14:06:21          sdi    206.00  11512.00  29112.00    197.20      
0.83      3.98      1.80     37.00
14:06:21          sdj    209.00  11264.00  30264.00    198.70      
0.79      3.78      1.96     41.00
14:06:21          sds    214.00  10984.00  28552.00    184.75      
0.78      3.60      1.78     38.00
14:06:21          sdt    194.00  13352.00  27808.00    212.16      
0.83      4.23      1.91     37.00
14:06:21          sdu    183.00  12856.00  28872.00    228.02      
0.60      3.22      2.13     39.00
14:06:21          sdv    189.00  11984.00  31696.00    231.11      
0.57      2.96      1.69     32.00
14:06:21          md5    754.00      0.00 153848.00    204.04      
0.00      0.00      0.00      0.00
14:06:21    DayTar-DayTar    753.00      0.00 153600.00    203.98     
15.73     20.58      1.33    100.00
14:06:21         data    760.00      0.00 155800.00    205.00   
4670.84   6070.91      1.32    100.00

The setup is md5 -> /dev/DayTar/DayTar (LVM2 VG / LV) -> 
/dev/mapper/data (cryptsetup) -> XFS.

The avgrq-sz column shows about 205 (in sectors), which is about 105kB.  
You can see there are NO reads in the layers leading up to the hard 
drives.  The reads look to be getting generated inside md, and look to 
represent about 25% of IO load to the HDs.  For large linear writes, 
should there really be these reads?  Shouldn't avgrq-sz be showing about 
8192 sectors (4MB)?  This data is what prompted my question about 
maxsect since it seems to indicate 128kB is a limit.

Thanks for any insight,

--Bart

PS: I tried to force XFS to write big with the following mount options:
/dev/mapper/data on /data type xfs 
(rw,noatime,nodiratime,allocsize=256m,nobarrier,noikeep,inode64,logbufs=8,logbsize=256k,sunit=1024,swidth=8192)

