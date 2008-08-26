From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Tue, 26 Aug 2008 11:27:45 +0300 (EEST)
Message-ID: <alpine.DEB.1.10.0808260921030.3708@kurp.hut.fi>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi> <18597.64737.508658.390657@notabene.brown> <alpine.DEB.1.10.0808181339010.365@kurp.hut.fi> <18601.25349.670500.530839@notabene.brown> <alpine.DEB.1.10.0808181501010.698@kurp.hut.fi>
 <alpine.DEB.1.10.0808201506440.7882@kurp.hut.fi> <18605.6769.44592.478277@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18605.6769.44592.478277@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Thu, 21 Aug 2008, Peter Grandi wrote:
>> [ ... ] For the 3 x 4disk raid0s the values were ~390MB
>> Writeback and ~14MB Dirty. Aggretate write rate 690MB/sec.
>
>> For the 1 x 12disk raid0 just ~14MB Writeback and ~190MB
>> Dirty. Write rate 473 MB/sec. [ ... ]

There was an old Microsoft research article from 2004/2005:
http://research.microsoft.com/barc/Sequential_IO/

Linear scaling with more drives. Versus kernel 2.6.22/.24 on our test 
machine where the rate saturates already with ~5 drives in raid0. I'm not 
familiar enough with md source to know what to fix.

> That coincides with my own experience. But note that it is a very
> special case, where optimum speed is reached only if requests hit
> the member block devices in exactly the "right" way. In most
> workloads latency also is a big part, so the ability to issue long
> sequential streams of back-to-back requests is less important.

Data streaming is quite commonplace. The kernel should be able to handle 
it efficiently.

Getting requests hit the "right" way should be deterministic. Achievable 
with correct settings. I have already tried a few tunings, to no avail. 
Specifically:

QT=64
NCQD=8
for drv in $@; do
  echo $QT > /sys/block/${drv}/queue/iosched/quantum
  cat /sys/block/${drv}/queue/max_hw_sectors_kb > /sys/block/${drv}/queue/max_sectors_kb
  blockdev --setra 16384 /dev/${drv}
  echo "noop" > /sys/block/${drv}/queue/scheduler
  echo "${NCQD}" > /sys/block/${drv}/device/queue_depth
  echo "$(($NCQD * 2))" > /sys/block/${drv}/device/nr_requests
done

On average this doubles the sequential read performance. But not with 
sequential write.

Set "nop" elevator on the md slaves. No difference.

Additionally tried telling the kernel that sequential I/O is expected 
(madvise, posix_fadvise) and trying to bypass some caching w O_DIRECT, 
even tested mmap() and msync(), and tuned /proc/sys/vm/* settings. Always 
doing raw I/O to /dev/mdX.

But the kernel or md or pdflush do not "get" any of the obvious hints that 
they could dispatch requests optimally.

About elevators, MD itself has no "input side" elevator setting AFAICT.

Perhaps this is the problem (?)

> Overall the current Linux block layer instead of being based on
> streaming seems to be based on batching of requests, and this
> interacts pooly with MD, as the batch sizes and their passing on
> timing might not be those that can best keep several MD member
> block devices busy.

Sounds plausible.

> To see the detailed effects of all these layers of "brilliant"
> policies, IO rates on individual devices should be looked at, and
> I use something like this command line (with a very tall terminal
> window).
>
>  watch -n2 iostat -d -m /dev/mdXXX /dev/sdNNN /dev/sdMMM ... 1 2

Hmm, I tried it. With a single 4-disk raid0 2048k chunk, all disks behind 
same PMP:

$ grep MemTotal /proc/meminfo
MemTotal:      4044384 kB

screen1$ dd if=/dev/zero of=/dev/md0 bs=2048k
screen2$ watch -n2 iostat -d -m /dev/sd{b,c,d,e} 1 2
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb             865.00         0.00        45.80          0         45
sdc             881.00         0.00        45.95          0         45
sdd             881.00         0.00        45.87          0         45
sde             898.00         0.00        45.55          0         45

With the 12-disk raid0, with linear scaling expected to do 12*46MB/s 
or 552MB/s:

screen1$ dd if=/dev/zero of=/dev/md0 bs=2048k
screen2$ watch -n2 iostat -d -m /dev/sd{b,c,d,e,f,g,h,i,j,k,l,m} 1 2
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb             473.00         0.00        17.71          0         17
sdc             513.00         0.00        18.88          0         18
sdd             495.00         0.00        19.41          0         19
sde             520.00         0.00        19.12          0         19
sdf             536.00         0.00        19.37          0         19
sdg             479.00         0.00        19.39          0         19
sdh             489.00         0.00        19.10          0         19
sdi             440.00         0.00        19.43          0         19
sdj             468.00         0.00        18.68          0         18
sdk             428.00         0.00        17.40          0         17
sdl             404.00         0.00        17.58          0         17
sdm             464.00         0.00        17.14          0         17
screen1$ # 42960158720 bytes (43 GB) copied, 210.794 s, 204 MB/s

So the rates are quite evenly distributed within maybe +-1.5 MB/s from the 
mean.

> My experience is that often the traffic is not quite evenly
> balanced across the member drives, and when it is, the rate
> sometimes is well below the one at which the member device
> can operate.

Perhaps what I see here is yet another problem.

Now, things get curious and fast with O_DIRECT and a block size up to half 
of the available 4GB memory. Without O_DIRECT the rates are always quite 
low.

screen1$ dd if=/dev/zero of=/dev/md0 bs=16M oflag=direct
screen2$ watch -n2 iostat -d -m /dev/sd{b,c,d,e,f,g,h,i,j,k,l,m} 1 2
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb              56.00         0.00        28.00          0         28
...
sdm              52.00         0.00        26.00          0         26
screen1$ # 14612955136 bytes (15 GB) copied, 44.7189 s, 327 MB/s
screen1$ sudo dd if=/dev/md0 of=/dev/null bs=16M iflag=direct
screen1$ # 14092861440 bytes (14 GB) copied, 31.681 s, 445 MB/s
------------------------------------------------------------------
screen1$ dd if=/dev/zero of=/dev/md0 bs=64M oflag=direct
screen2$ watch -n2 iostat -d -m /dev/sd{b,c,d,e,f,g,h,i,j,k,l,m} 1 2
Device:           tps     MB_read/s    MB_wrtn/s    MB_read     MB_wrtn
sdb             70.00          0.00        35.00          0          35
...
sdm             65.00          0.00        34.50          0          34
screen1$ # 12683575296 bytes (13 GB) copied, 28.4022 s, 447 MB/s
screen1$ sudo dd if=/dev/md0 of=/dev/null bs=64M iflag=direct
screen1$ # 79054241792 bytes (79 GB) copied, 128.795 s, 614 MB/s
------------------------------------------------------------------
screen1$ dd if=/dev/zero of=/dev/md0 bs=512M oflag=direct
screen2$ watch -n2 iostat -d -m /dev/sd{b,c,d,e,f,g,h,i,j,k,l,m} 1 2
sdb              25.00         0.00        42.00          0         42
...
sdm              23.00         0.00        42.00          0         42
screen1$ # 25769803776 bytes (26 GB) copied, 53.3836 s, 483 MB/
screen1$ sudo dd if=/dev/md0 of=/dev/null bs=512M iflag=direct
screen1$ # 23622320128 bytes (24 GB) copied, 36.4848 s, 647 MB/s
------------------------------------------------------------------
screen1$ sudo dd if=/dev/zero of=/dev/md0 bs=1024M oflag=direct
screen2$ watch -n2 iostat -d -m /dev/sd{b,c,d,e,f,g,h,i,j,k,l,m} 1 2
sdb              17.00         0.00        24.50          0         24
...
sde              14.00         0.00        19.50          0         19
sdf              17.00         0.00        24.50          0         24
...
sdk              14.00         0.00        11.50          0         11
sdl              15.00         0.00        26.50          0         26
sdm              15.00         0.00        26.50          0         26
screen1$ # the rates jump around between 20MB/s, 60MB/s
screen1$ # 20401094656 bytes (20 GB) copied, 41.9148 s, 487 MB/s
screen1$ sudo dd if=/dev/md0 of=/dev/null bs=1024M iflag=direct
screen1$ # 23622320128 bytes (24 GB) copied, 36.4848 s, 647 MB/s
------------------------------------------------------------------
screen1$ dd if=/dev/zero of=/dev/md0 bs=2048M oflag=direct
screen2$ watch -n2 iostat -d -m /dev/sd{b,c,d,e,f,g,h,i,j,k,l,m} 1 2
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb              72.00         0.00        53.00          0         53
...
sdm              74.00         0.00        52.00          0         52
screen1$ # the above happens in bursts and there are pauses with 0MB/s
screen1$ # 19327315968 bytes (19 GB) copied, 41.8337 s, 462 MB/s
screen1$ sudo dd if=/dev/md0 of=/dev/null bs=2048M iflag=direct
screen1$ # 27917234176 bytes (28 GB) copied, 46.4147 s, 601 MB/s

I guess large writes "force" something in the vm...

  - Jan
