From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 05:48:38 -0700
Message-ID: <201301110548.38234.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <50EF5A4B.7000502@hardwarefreak.com> <201301110535.12512.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301110535.12512.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri Jan 11, 2013, Thomas Fjellstrom wrote:
> On Thu Jan 10, 2013, Stan Hoeppner wrote:
> > On 1/10/2013 3:36 PM, Chris Murphy wrote:
> > > On Jan 10, 2013, at 3:49 AM, Thomas Fjellstrom <thomas@fjellstrom.ca> 
wrote:
> > >> A lot of it will be streaming. Some may end up being random
> > >> read/writes. The test is just to gauge over all performance of the
> > >> setup. 600MBs read is far more than I need, but having writes at 1/3
> > >> that seems odd to me.
> > > 
> > > Tell us how many disks there are, and what the chunk size is. It could
> > > be too small if you have too few disks which results in a small full
> > > stripe size for a video context. If you're using the default, it could
> > > be too big and you're getting a lot of RWM. Stan, and others, can
> > > better answer this.
> > 
> > Thomas is using a benchmark, and a single one at that, to judge the
> > performance.  He's not using his actual workloads.  Tuning/tweaking to
> > increase the numbers in a benchmark could be detrimental to actual
> > performance instead of providing a boost.  One must be careful.
> > 
> > Regarding RAID6, it will always have horrible performance compared to
> > non-parity RAID levels and even RAID5, for anything but full stripe
> > aligned writes, which means writing new large files or doing large
> > appends to existing files.
> 
> Considering its a rather simple use case, mostly streaming video, and misc
> file sharing for my home network, an iozone test should be rather telling.
> Especially the full test, from 4k up to 16mb
> 
>                                                             random  random 
>   bkwd   record   stride KB  reclen   write rewrite    read    reread   
> read   write    read  rewrite     read   fwrite frewrite   fread  freread
> 33554432       4  243295  221756   628767   624081    1028    4627   16822
>  7468777    17740   233295   231092  582036   579131 33554432       8 
> 241134  225728   628264   627015    2027    8879   25977 10030302    19578
>   228923   233928  591478   584892 33554432      16  233758  228122  
> 633406   618248    3952   13635   35676 10166457    19968   227599  
> 229698  579267   576850 33554432      32  232390  219484   625968   625627
>    7604   18800   44252 10728450    24976   216880   222545  556513  
> 555371 33554432      64  222936  206166   631659   627823   14112   22837 
>  52259 11243595    30251   196243   192755  498602   494354 33554432    
> 128  214740  182619   628604   626407   25088   26719   64912 11232068   
> 39867   198638   185078  463505   467853 33554432     256  202543  185964 
>  626614   624367   44363   34763   73939 10148251    62349   176724  
> 191899  593517   595646 33554432     512  208081  188584   632188   629547
>   72617   39145   84876  9660408    89877   182736   172912  610681  
> 608870 33554432    1024  196429  166125   630785   632413  116793   51904 
> 133342  8687679   121956   168756   175225  620587   616722 33554432   
> 2048  185399  167484   622180   627606  188571   70789  218009  5357136  
> 370189   171019   166128  637830   637120 33554432    4096  198340  188695
>   632693   628225  289971   95211  278098  4836433   611529   161664  
> 170469  665617   655268 33554432    8192  177919  167524   632030   629077
>  371602  115228  384030  4934570   618061   161562   176033  708542  
> 709788 33554432   16384  196639  183744   631478   627518  485622  133467 
> 462861  4890426   644615   175411   179795  725966   734364
> 
> > However, everything is relative.  This RAID6 may have plenty of random
> > and streaming write/read throughput for Thomas.  But a single benchmark
> > isn't going to inform him accurately.
> 
> 200MB/s may be enough, but the difference between the read and write
> throughput is a bit unexpected. It's not a weak machine (core i3-2120, dual
> core 3.2Ghz with HT, 16GB ECC 1333Mhz ram), and this is basically all its
> going to be doing.
> 
> > > You said these are unpartitioned disks, I think. In which case
> > > alignment of 4096 byte sectors isn't a factor if these are AF disks.
> > > 
> > > Unlikely to make up the difference is the scheduler. Parallel fs's like
> > > XFS don't perform nearly as well with CFQ, so you should have a kernel
> > > parameter elevator=noop.
> > 
> > If the HBAs have [BB|FB]WC then one should probably use noop as the
> > cache schedules the actual IO to the drives.  If the HBAs lack cache,
> > then deadline often provides better performance.  Testing of each is
> > required on a system and workload basis.  With two identical systems
> > (hardware/RAID/OS) one may perform better with noop, the other with
> > deadline.  The determining factor is the applications' IO patterns.
> 
> Mostly streaming reads, some long rsync's to copy stuff back and forth,
> file share duties (downloads etc).
> 
> > > Another thing to look at is md/stripe_cache_size which probably needs
> > > to be higher for your application.
> > > 
> > > Another thing to look at is if you're using XFS, what your mount
> > > options are. Invariably with an array of this size you need to be
> > > mounting with the inode64 option.
> > 
> > The desired allocator behavior is independent of array size but, once
> > again, dependent on the workloads.  inode64 is only needed for large
> > filesystems with lots of files, where 1TB may not be enough for the
> > directory inodes.  Or, for mixed metadata/data heavy workloads.
> > 
> > For many workloads including databases, video ingestion, etc, the
> > inode32 allocator is preferred, regardless of array size.  This is the
> > linux-raid list so I'll not go into detail of the XFS allocators.
> 
> If you have the time and the desire, I'd like to hear about it off list.
> 
> > >> The reason I've selected RAID6 to begin with is I've read (on this
> > >> mailing list, and on some hardware tech sites) that even with SAS
> > >> drives, the rebuild/resync time on a large array using large disks
> > >> (2TB+) is long enough that it gives more than enough time for another
> > >> disk to hit a random read error,
> > > 
> > > This is true for high density consumer SATA drives. It's not nearly as
> > > applicable for low to moderate density nearline SATA which has an order
> > > of magnitude lower UER, or for enterprise SAS (and some enterprise
> > > SATA) which has yet another order of magnitude lower UER.  So it
> > > depends on the disks, and the RAID size, and the backup/restore
> > > strategy.
> > 
> > Yes, enterprise drives have a much larger spare sector pool.
> > 
> > WRT rebuild time, this is one more reason to use RAID10 or a concat of
> > RAID1s.  The rebuild time is low, constant, predictable.  For 2TB drives
> > about 5-6 hours at 100% rebuild rate.  And rebuild time, for any array
> > type, with gargantuan drives, is yet one more reason not to use the
> > largest drives you can get your hands on.  Using 1TB drives will cut
> > that to 2.5-3 hours, and using 500GB drives will cut it down to 1.25-1.5
> > hours, as all these drives tend to have similar streaming write rates.
> > 
> > To wit, as a general rule I always build my arrays with the smallest
> > drives I can get away with for the workload at hand.  Yes, for a given
> > TB total it increases acquisition cost of drives, HBAs, enclosures, and
> > cables, and power consumption, but it also increases spindle count--thus
> > performance-- while decreasing rebuild times substantially/dramatically.
> 
> I'd go raid10 or something if I had the space, but this little 10TB nas
> (which is the goal, a small, quiet, not too slow, 10TB nas with some kind
> of redundancy) only fits 7 3.5" HDDs.
> 
> Maybe sometime in the future I'll get a big 3 or 4 u case with a crap load
> of 3.5" HDD bays, but for now, this is what I have (as well as my old
> array, 7x1TB RAID5+XFS in 4in3 hot swap bays with room for 8 drives, but
> haven't bothered to expand the old array, and I have the new one almost
> ready to go).
> 
> I don't know if it impacts anything at all, but when burning in these
> drives after I bought them, I ran the same full iozone test a couple
> times, and each drive shows 150MB/s read, and similar write times
> (100-120+?). It impressed me somewhat, to see a mechanical hard drive go
> that fast. I remember back a few years ago thinking 80MBs was fast for a
> HDD.

I should note, it might do some p2p duties in the future. Not sure about that.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
