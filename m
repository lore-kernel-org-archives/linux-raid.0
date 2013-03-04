From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Tue, 05 Mar 2013 03:26:33 +1100
Message-ID: <5134CB39.8050000@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com> <5134917F
 .8060903@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5134917F.8060903@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/03/13 23:20, Stan Hoeppner wrote:
> On 3/3/2013 11:32 AM, Adam Goryachev wrote:
>> Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>>> 1) Make sure stripe_cache_size is as least 8192.  If not:
>>>> ~$ echo 8192 > /sys/block/md0/md/stripe_cache_size
>>>> Currently using default 256.
>>
>> Done now
> 
> I see below that this paid some dividend.  You could try increasing it
> further and may get even better write throughput for this FIO test, but
> keep in mind large stripe_cache_size values eat serious amounts of RAM:
> 
> Formula:  stripe_cache_size * 4096 bytes * drive_count = RAM usage.  For
> your 5 drive array:
> 
>  8192 eats 160MB
> 16384 eats 320MB
> 32768 eats 640MB
> 
> Considering this is an iSCSI block IO server, dedicating 640MB of RAM to
> md stripe cache isn't a bad idea at all if it seriously increases write
> throughput (and without decreasing read throughput).  You don't need RAM
> for buffer cache since you're not doing local file operations.  I'd even
> go up to 131072 and eat 2.5GB of RAM if the performance is substantially
> better than lower values.
> 
> Whatever value you choose, make it permanent by adding this entry to
> root's crontab:
> 
> @reboot		/bin/echo 32768 > /sys/block/md0/md/stripe_cache_size

Already added to /etc/rc.local along with the config to set the deadline
scheduler for each of the RAID drives.

I will certainly test with higher numbers, I've got 8GB of RAM, and
there is really not much else that needs the RAM for anything near as
important as this. I'd honestly be happy to dedicate at least 4 or 5GB
of RAM if it was going to improve performance... I'll try values up to
262144 which should be 5120MB of RAM, leaving well over 2GB for the OS
and minor monitoring/etc...
Current memory usage:
             total       used       free     shared    buffers     cached
Mem:       7904320    1540692    6363628          0     130284     856148
-/+ buffers/cache:     554260    7350060
Swap:      3939324          0    3939324

Will advise results of testing ...

>>>> top -b -n 60 -d 0.25|grep Cpu|sort -n > /some.dir/some.file
>>
>> Done now
>>
>> There seems to be only one row from the top output which is interesting:
>> Cpu0 : 3.6%us, 71.4%sy, 0.0%ni, 0.0%id, 10.7%wa, 0.0%hi, 14.3%si, 0.0%,st
>>
>> Every other line had a high value for %id, or %wa, with lower values for %sy. This was during the second 'stage' of the fio run, earlier in the fio run there was no entry even close to showing the CPU as busy.
> 
> I expended the the time/effort walking you through all of this because I
> want to analyze the complete output myself.  Would you please pastebin
> it or send me the file?  Thanks.

I'll send the file off-list due to size... I was working on-site with a
windows box, I wasn't logged into my email from there...

>> READ: io=131072MB, aggrb=2506MB/s, minb=2566MB/s, maxb=2566MB/s, mint=52303msec, maxt=52303msec
>> WRITE: io=131072MB, aggrb=1262MB/s, minb=1292MB/s, maxb=1292MB/s, mint=103882msec, maxt=103882msec
> 
> Even better than I anticipated.  Nice, very nice.  2.3x the write
> throughput.
> 
> Your last AIO single threaded streaming run:
> READ:   2,200 MB/s
> WRITE:    560 MB/s
> 
> Multi-threaded run with stripe cache optimization and compressible data:
> READ:   2,500 MB/s
> WRITE: *1,300 MB/s*
> 
>> Is this what I should be expecting now?
> 
> No, because this FIO test, as with the streaming test, isn't an accurate
> model of your real daily IO workload, which entails much smaller, mixed
> read/write random IOs.  But it does give a more accurate picture of the
> peak aggregate write bandwidth of your array.
> 
> Once you have determined the optimal stripe_cache_size, you need to run
> this FIO test again, multiple times, first with the LVM snapshot
> enabled, and then with DRBD enabled.
> 
> The DRBD load on the array on san1 should be only reads at a maximum
> rate of ~120MB/s as you have a single GbE link to the secondary.  This
> is only 1/20th of the peak random read throughput of the array.  Your
> prior sequential FIO runs showed a huge degradation in write performance
> when DRBD was running.  This makes no sense, and should not be the case.
>  You need to determine why DRBD on san1 is hammering write performance.

I've re-run the fio test from above just now, except all the VM's are
online, should be mostly idle, and also the secondary DRBD is connected:
stripe_cache_size = 2048
>    READ: io=131072MB, aggrb=2502MB/s, minb=2562MB/s, maxb=2562MB/s, mint=52397msec, maxt=52397msec
>   WRITE: io=131072MB, aggrb=994MB/s, minb=1018MB/s, maxb=1018MB/s, mint=131803msec, maxt=131803msec

stripe_cache_size = 4096
>    READ: io=131072MB, aggrb=2504MB/s, minb=2564MB/s, maxb=2564MB/s, mint=52348msec, maxt=52348msec
>   WRITE: io=131072MB, aggrb=1590MB/s, minb=1628MB/s, maxb=1628MB/s, mint=82455msec, maxt=82455msec

stripe_cache_size = 8192
>    READ: io=131072MB, aggrb=2487MB/s, minb=2547MB/s, maxb=2547MB/s, mint=52697msec, maxt=52697msec
>   WRITE: io=131072MB, aggrb=1521MB/s, minb=1557MB/s, maxb=1557MB/s, mint=86188msec, maxt=86188msec

stripe_cache_size = 16384
>    READ: io=131072MB, aggrb=2494MB/s, minb=2554MB/s, maxb=2554MB/s, mint=52556msec, maxt=52556msec
>   WRITE: io=131072MB, aggrb=1368MB/s, minb=1401MB/s, maxb=1401MB/s, mint=95779msec, maxt=95779msec

stripe_cache_size = 32768
>    READ: io=131072MB, aggrb=2489MB/s, minb=2549MB/s, maxb=2549MB/s, mint=52661msec, maxt=52661msec
>   WRITE: io=131072MB, aggrb=1138MB/s, minb=1165MB/s, maxb=1165MB/s, mint=115209msec, maxt=115209msec

(let me know if you want the full fio output....)
This seems to show that DRBD did not slow things down at all... I don't
remember exactly when I did the previous fio tests with drbd connected,
but perhaps I've made changes to the drbd config since then and/or
upgraded from the debian stable drbd to 8.3.15

Let's re-run the above tests with DRBD stopped:
stripe_cache_size = 256
>    READ: io=131072MB, aggrb=2496MB/s, minb=2556MB/s, maxb=2556MB/s, mint=52508msec, maxt=52508msec
>   WRITE: io=131072MB, aggrb=928148KB/s, minb=950424KB/s, maxb=950424KB/s, mint=144608msec, maxt=144608msec

stripe_cache_size = 512
>    READ: io=131072MB, aggrb=2497MB/s, minb=2557MB/s, maxb=2557MB/s, mint=52484msec, maxt=52484msec
>   WRITE: io=131072MB, aggrb=978170KB/s, minb=978MB/s, maxb=978MB/s, mint=137213msec, maxt=137213msec

stripe_cache_size = 2048
>    READ: io=131072MB, aggrb=2502MB/s, minb=2562MB/s, maxb=2562MB/s, mint=52382msec, maxt=52382msec
>   WRITE: io=131072MB, aggrb=996MB/s, minb=1020MB/s, maxb=1020MB/s, mint=131631msec, maxt=131631msec

stripe_cache_size = 4096
>    READ: io=131072MB, aggrb=2498MB/s, minb=2558MB/s, maxb=2558MB/s, mint=52465msec, maxt=52465msec
>   WRITE: io=131072MB, aggrb=1596MB/s, minb=1634MB/s, maxb=1634MB/s, mint=82126msec, maxt=82126msec

stripe_cache_size = 8192
>    READ: io=131072MB, aggrb=2498MB/s, minb=2558MB/s, maxb=2558MB/s, mint=52469msec, maxt=52469msec
>   WRITE: io=131072MB, aggrb=1514MB/s, minb=1550MB/s, maxb=1550MB/s, mint=86565msec, maxt=86565msec

stripe_cache_size = 16384
>    READ: io=131072MB, aggrb=2482MB/s, minb=2542MB/s, maxb=2542MB/s, mint=52807msec, maxt=52807msec
>   WRITE: io=131072MB, aggrb=1377MB/s, minb=1410MB/s, maxb=1410MB/s, mint=95191msec, maxt=95191msec

stripe_cache_size = 32768
>    READ: io=131072MB, aggrb=2498MB/s, minb=2557MB/s, maxb=2557MB/s, mint=52481msec, maxt=52481msec
>   WRITE: io=131072MB, aggrb=1139MB/s, minb=1166MB/s, maxb=1166MB/s, mint=115102msec, maxt=115102msec

I was actually going to use 65536 as well, but actually that value
doesn't work at all:
echo 65536 > /sys/block/md1/md/stripe_cache_size
-bash: echo: write error: Invalid argument

So, it looks like the ideal value is actually smaller (4096) although
there is not much difference between 8192 and 4096. It seems strange
that a larger cache size will actually reduce performance... I'll change
to 4096 for the time being, unless you think "real world" performance
might be better with 8192?

Here are the results of re-running fio using the previous config (with
drbd connected with the stripe_cache_size = 8192):
>    READ: io=4096MB, aggrb=2244MB/s, minb=2298MB/s, maxb=2298MB/s, mint=1825msec, maxt=1825msec
>   WRITE: io=4096MB, aggrb=494903KB/s, minb=506780KB/s, maxb=506780KB/s, mint=8475msec, maxt=8475msec

Perhaps the old fio test just isn't as well suited to the way drbd
handles things. Though the issue would be what sort of data the real
users are doing, because if that matches the old fio test or the new fio
test, it makes a big difference.

So, it looks like it is the stripe_cache_size that is affecting
performance, and that DRBD makes no difference whether it is connected
or not. Possibly removing it completely would increase performance
somewhat, but since I actually do need it, and that is somewhat
destructive, I won't try that :)

>> To me, it looks like it is close enough, but if you think I should be able to get even faster, then I will certainly investigate further.
> 
> There may be some juice left on the table.  Experiment with
> stripe_cache_size until you hit the sweet spot.  I'd use only power of 2
> values.  If 32768 gives a decent gain, then try 65536, then 131072.  If
> 32768 doesn't gain, or decreases throughput, try 16384.  If 16384
> doesn't yield decent gains or goes backward, stick with 8192.  Again,
> you must manually stick the value as it doesn't survive reboots.
> Easiest route is cron.

Will stick with 4096 for the moment based on the above results.

>>>> 4) Try to connect the SSD's direct to the HBA, bypassing the hotswap
>>>> device in case this is limiting to SATA II or similar.
> 
> <snippety sip snip>  Put palm to forehead.
> 
> FIO 2.5GB/s read speed.  2.5GBps / 5 = 500MB/s per drive, ergo your link
> speed must be 6Gbps on each drive.  If it were 3Gbps you'd be limited to
> 300MB/s per drive, 1.5GB/s total.

Of course, thank you for the blindingly obvious :)

>> I'll have to find some software to run benchmarks within the windows VM's
> 
> FIO runs on Windows:  http://www.bluestop.org/fio/

Will check into that, it will be the ultimate end-to-end test.... Also,
I can test the difference between the windows 2003 and windows 2000 to
see if there is any difference there....

>> Mostly I see high memory utilisation more than CPU, and that is one of the reasons to upgrade them to Win2008 64bit so I can allocate more RAM. I'm hoping that even with the virtualisation overhead, the modern CPU's are faster than the previous physical machines which were about 5 years old.
> 
> MS stupidity:		x86 	x64
> 
> W2k3 Server Standard	4GB	 32GB
> XP			4GB	128GB

Hmmm, good point, I realised I could try and upgrade to the x64 windows
2003, but I think I'd prefer to just move up to 2008 x64 (or 2012)...
For now, I'll just keep using my hacky 4GB RAM drive for the pagefile...

>> So, overall, I haven't achieved anywhere near as much as I had hoped... 
> You doubled write throughput to 1.3GB/s, at least WRT FIO.  That's one
> fairly significant achievement.

I meant I hadn't crossed off as many items from my list of things to
do... Not that I hadn't improved performance significantly :)

>> Seems to be faster than before, so will see how it goes today/this week.
> 
> The only optimization since your last FIO test was increasing
> stripe_cache_size (the rest of the FIO throughput increase was simply
> due to changing the workload profile and using non random data buffers).
>  The buffer difference:
> stripe_cache_size	buffer space		full stripes buffered
>   256 (default)		  5 MB			  16
>  8192			160 MB			 512
> 
> To find out how much of the 732MB/s write throughput increase is due to
> buffering 512 stripes instead of 16, simply change it back to 256,
> re-run my FIO job file, and subtract the write result from 1292MB/s.

So, running your FIO job file with the original 256 give a write speed
of 950MB/s and the previous FIO file gives 509MB/s. So it would seem the
increase in stripe_cache_size from 256 to 4096 give an increase in your
FIO job from 950MB/s to 1634MB/s which is a significant speed boost. I
must wonder why we have a default of 256 when this can make such a
significant performance improvement? A value of 4096 with a 5 drive raid
array is only 80MB of cache, I suspect very few users with a 5 drive
RAID array would be concerned about losing 80MB of RAM, and a 2 drive
RAID array would only use 32MB ...

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
