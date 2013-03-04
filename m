From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Mon, 04 Mar 2013 06:20:15 -0600
Message-ID: <5134917F.8060903@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/3/2013 11:32 AM, Adam Goryachev wrote:
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>> 1) Make sure stripe_cache_size is as least 8192.  If not:
>>> ~$ echo 8192 > /sys/block/md0/md/stripe_cache_size
>>> Currently using default 256.
> 
> Done now

I see below that this paid some dividend.  You could try increasing it
further and may get even better write throughput for this FIO test, but
keep in mind large stripe_cache_size values eat serious amounts of RAM:

Formula:  stripe_cache_size * 4096 bytes * drive_count = RAM usage.  For
your 5 drive array:

 8192 eats 160MB
16384 eats 320MB
32768 eats 640MB

Considering this is an iSCSI block IO server, dedicating 640MB of RAM to
md stripe cache isn't a bad idea at all if it seriously increases write
throughput (and without decreasing read throughput).  You don't need RAM
for buffer cache since you're not doing local file operations.  I'd even
go up to 131072 and eat 2.5GB of RAM if the performance is substantially
better than lower values.

Whatever value you choose, make it permanent by adding this entry to
root's crontab:

@reboot		/bin/echo 32768 > /sys/block/md0/md/stripe_cache_size

>>> top -b -n 60 -d 0.25|grep Cpu|sort -n > /some.dir/some.file
> 
> Done now
> 
> There seems to be only one row from the top output which is interesting:
> Cpu0 : 3.6%us, 71.4%sy, 0.0%ni, 0.0%id, 10.7%wa, 0.0%hi, 14.3%si, 0.0%,st
>
> Every other line had a high value for %id, or %wa, with lower values for %sy. This was during the second 'stage' of the fio run, earlier in the fio run there was no entry even close to showing the CPU as busy.

I expended the the time/effort walking you through all of this because I
want to analyze the complete output myself.  Would you please pastebin
it or send me the file?  Thanks.

> READ: io=131072MB, aggrb=2506MB/s, minb=2566MB/s, maxb=2566MB/s, mint=52303msec, maxt=52303msec
> WRITE: io=131072MB, aggrb=1262MB/s, minb=1292MB/s, maxb=1292MB/s, mint=103882msec, maxt=103882msec

Even better than I anticipated.  Nice, very nice.  2.3x the write
throughput.

Your last AIO single threaded streaming run:
READ:   2,200 MB/s
WRITE:    560 MB/s

Multi-threaded run with stripe cache optimization and compressible data:
READ:   2,500 MB/s
WRITE: *1,300 MB/s*

> Is this what I should be expecting now?

No, because this FIO test, as with the streaming test, isn't an accurate
model of your real daily IO workload, which entails much smaller, mixed
read/write random IOs.  But it does give a more accurate picture of the
peak aggregate write bandwidth of your array.

Once you have determined the optimal stripe_cache_size, you need to run
this FIO test again, multiple times, first with the LVM snapshot
enabled, and then with DRBD enabled.

The DRBD load on the array on san1 should be only reads at a maximum
rate of ~120MB/s as you have a single GbE link to the secondary.  This
is only 1/20th of the peak random read throughput of the array.  Your
prior sequential FIO runs showed a huge degradation in write performance
when DRBD was running.  This makes no sense, and should not be the case.
 You need to determine why DRBD on san1 is hammering write performance.

> To me, it looks like it is close enough, but if you think I should be able to get even faster, then I will certainly investigate further.

There may be some juice left on the table.  Experiment with
stripe_cache_size until you hit the sweet spot.  I'd use only power of 2
values.  If 32768 gives a decent gain, then try 65536, then 131072.  If
32768 doesn't gain, or decreases throughput, try 16384.  If 16384
doesn't yield decent gains or goes backward, stick with 8192.  Again,
you must manually stick the value as it doesn't survive reboots.
Easiest route is cron.

>>> 4) Try to connect the SSD's direct to the HBA, bypassing the hotswap
>>> device in case this is limiting to SATA II or similar.

<snippety sip snip>  Put palm to forehead.

FIO 2.5GB/s read speed.  2.5GBps / 5 = 500MB/s per drive, ergo your link
speed must be 6Gbps on each drive.  If it were 3Gbps you'd be limited to
300MB/s per drive, 1.5GB/s total.

> I'll have to find some software to run benchmarks within the windows VM's

FIO runs on Windows:  http://www.bluestop.org/fio/

> READ: io=32768MB, aggrb=237288KB/s, minb=237288KB/s, maxb=237288KB/s, mint=141408msec, maxt=141408msec
> WRITE: io=32768MB, aggrb=203307KB/s, minb=203307KB/s, maxb=203307KB/s, mint=165043msec, maxt=165043msec
> 
> So, 230MB/s read and 200MB/s write, using 2 x 1Gbps ethernet seems pretty good. 

So little left it's not worth optimization time.

> The TS VM's have dedicated 4 cores, and the physical machines have dedicated 2 cores. I don't think the TS are CPU limited, this was for me to watch this on the DC to ensure it's single CPU was not limiting performance

I understand the DC issue.  I was addressing a different issue here.  If
the TS VMs have 4 cores there's nothing more you can do.

> I only run a single windows VM on each xen box (unless the xen boxes started failing, then I'd run multiple VM's on one xen box until it was repaired). 

From your previous msgs early in the thread I was under the impression
you were running two TS VMs per Xen box.  I must have misread something.

> As such, I have 2 CPU cores dedicated to the dom0 (xen, physical box) and 4 cores dedicated to the windows VM (domU). I can drop the physical box back to a single core and add an additional core to windows, but I don't think that will make much of a difference. I don't tend to see high CPU load on the TS boxes... 

You may see less than peak averages in Munin due to the capture interval
of munin-node, but still have momentary peaks that bog users down.  I'm
not saying this is the case, but it's probably worth investigating
further, via methods other than studying Munin graphs.

> Mostly I see high memory utilisation more than CPU, and that is one of the reasons to upgrade them to Win2008 64bit so I can allocate more RAM. I'm hoping that even with the virtualisation overhead, the modern CPU's are faster than the previous physical machines which were about 5 years old.

MS stupidity:		x86 	x64

W2k3 Server Standard	4GB	 32GB
XP			4GB	128GB

> So, overall, I haven't achieved anywhere near as much as I had hoped... 

You doubled write throughput to 1.3GB/s, at least WRT FIO.  That's one
fairly significant achievement.

> I've changed the stripe_cache_size, and disabled HT on san1.

Remember to test other sizes and make the optimum value permanent.

> Seems to be faster than before, so will see how it goes today/this week.

The only optimization since your last FIO test was increasing
stripe_cache_size (the rest of the FIO throughput increase was simply
due to changing the workload profile and using non random data buffers).
 The buffer difference:

stripe_cache_size	buffer space		full stripes buffered

  256 (default)		  5 MB			  16
 8192			160 MB			 512

To find out how much of the 732MB/s write throughput increase is due to
buffering 512 stripes instead of 16, simply change it back to 256,
re-run my FIO job file, and subtract the write result from 1292MB/s.

-- 
Stan

