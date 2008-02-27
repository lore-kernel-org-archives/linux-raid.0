From: Andreas Dilger <adilger@sun.com>
Subject: Re: very poor ext3 write performance on big filesystems?
Date: Wed, 27 Feb 2008 12:03:35 -0800
Message-ID: <20080227200335.GB9331@webber.adilger.int>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de>
 <20080218141640.GC12568@mit.edu> <47C54773.4040402@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <47C54773.4040402@wpkg.org>
Content-disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>, LKML <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm CCing the linux-raid mailing list, since I suspect they will be
interested in this result.

I would suspect that the "journal guided RAID recovery" mechanism
developed by U.Wisconsin may significantly benefit this workload
because the filesystem journal is already recording all of these
block numbers and the MD bitmap mechanism is pure overhead.

On Feb 27, 2008  12:20 +0100, Tomasz Chmielewski wrote:
> Theodore Tso schrieb:
>> On Mon, Feb 18, 2008 at 03:03:44PM +0100, Andi Kleen wrote:
>>> Tomasz Chmielewski <mangoo@wpkg.org> writes:
>>>> Is it normal to expect the write speed go down to only few dozens of
>>>> kilobytes/s? Is it because of that many seeks? Can it be somehow
>>>> optimized? 
>>>
>>> I have similar problems on my linux source partition which also
>>> has a lot of hard linked files (although probably not quite
>>> as many as you do). It seems like hard linking prevents
>>> some of the heuristics ext* uses to generate non fragmented
>>> disk layouts and the resulting seeking makes things slow.
>
> A follow-up to this thread.
> Using small optimizations like playing with /proc/sys/vm/* didn't help 
> much, increasing "commit=" ext3 mount option helped only a tiny bit.
>
> What *did* help a lot was... disabling the internal bitmap of the RAID-5 
> array. "rm -rf" doesn't "pause" for several seconds any more.
>
> If md and dm supported barriers, it would be even better I guess (I could 
> enable write cache with some degree of confidence).
>
> This is "iostat sda -d 10" output without the internal bitmap.
> The system mostly tries to read (Blk_read/s), and once in a while it
> does a big commit (Blk_wrtn/s):
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             164,67      2088,62         0,00      20928          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             180,12      1999,60         0,00      20016          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             172,63      2587,01         0,00      25896          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             156,53      2054,64         0,00      20608          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             170,20      3013,60         0,00      30136          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             119,46      1377,25      5264,67      13800      52752
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             154,05      1897,10         0,00      18952          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             197,70      2177,02         0,00      21792          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             166,47      1805,19         0,00      18088          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             150,95      1552,05         0,00      15536          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             158,44      1792,61         0,00      17944          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             132,47      1399,40      3781,82      14008      37856
>
>
>
> With the bitmap enabled, it sometimes behave similarly, but mostly, I
> can see as reads compete with writes, and both have very low numbers then:
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             112,57       946,11      5837,13       9480      58488
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             157,24      1858,94         0,00      18608          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             116,90      1173,60        44,00      11736        440
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              24,05        85,43       172,46        856       1728
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              25,60        90,40       165,60        904       1656
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              25,05       276,25       180,44       2768       1808
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              22,70        65,60       229,60        656       2296
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              21,66       202,79       786,43       2032       7880
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              20,90        83,20      1800,00        832      18000
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              51,75       237,36       479,52       2376       4800
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              35,43       129,34       245,91       1296       2464
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              34,50        88,00       270,40        880       2704
>
>
> Now, let's disable the bitmap in the RAID-5 array:
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             110,59       536,26       973,43       5368       9744
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             119,68       533,07      1574,43       5336      15760
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             123,78       368,43      2335,26       3688      23376
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             122,48       315,68      1990,01       3160      19920
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             117,08       580,22      1009,39       5808      10104
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             119,50       324,00      1080,80       3240      10808
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             118,36       353,69      1926,55       3544      19304
>
>
> And let's enable it again - after a while, it degrades again, and I can
> see "rm -rf" stops for longer periods:
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             162,70      2213,60         0,00      22136          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             165,73      1639,16         0,00      16408          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             119,76      1192,81      3722,16      11952      37296
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             178,70      1855,20         0,00      18552          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             162,64      1528,07         0,80      15296          8
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             182,87      2082,07         0,00      20904          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             168,93      1692,71         0,00      16944          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             177,45      1572,06         0,00      15752          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             123,10      1436,00      4941,60      14360      49416
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             201,30      1984,03         0,00      19880          0
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda             165,50      1555,20        22,40      15552        224
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              25,35       273,05       189,22       2736       1896
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              22,58        63,94       165,43        640       1656
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              69,40       435,20       262,40       4352       2624
>
>
>
> There is a related thread (although not much kernel-related) on a BackupPC 
> mailing list:
>
> http://thread.gmane.org/gmane.comp.sysutils.backup.backuppc.general/14009
>
> As it's BackupPC software which makes this amount of hardlinks (but hey, I 
> can keep ~14 TB of data on a 1.2 TB filesystem which is not even 65% full).
>
>
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

