From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 initial sync is CPU-limited
Date: Tue, 4 Jan 2011 16:24:37 +1100
Message-ID: <20110104162437.31dae9c9@notabene.brown>
References: <20110103163213.GC17455@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110103163213.GC17455@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 3 Jan 2011 17:32:13 +0100 Jan Kasprzak <kas@fi.muni.cz> wrote:

> 	Hello, Linux md developers!
> 
> I am trying to build a new md-based RAID-10 array out of 24 disks,
> but it seems that the initial sync of the array is heavily limited
> by CPU:
> 
> 	During the resync only 1-2 CPUs are busy (one for md1_raid10 thread
> which is uses 100 % of a single CPU, and one for md1_resync thread, which
> uses about 80 % of a single CPU).
> 
> 	Are there plans to make this process more parallel? I can imagine
> that for near-copies algorithm there can be a separate thread for each
> pair of disks in the RAID-10 array.

No, no plans to make the resync more parallel at all.

The md1_raid10 process is probably spending lots of time in memcmp and memcpy.
The way it works is to read all blocks that should be the same, see if they
are the same and if not, copy on to the orders and write those other (or in
your case "that other").

In general this is cleaner and easier than always reading one device and
writing another.

It might be appropriate to special-case some layouts and do 'read one, write
other' when that is likely to be more efficient (patches welcome).

I'm surprised that md1_resync has such a high cpu usage though - it is just
scheduling read requests, not actually doing anything with data.


For a RAID10 it is perfectly safe to create with --assume-clean.  If you also
add a write-intent bitmap, then you should never see a resync take much time
at all.


NeilBrown


> 
> 	My hardware is apparently able to keep all the disks busy most
> of the time (verified by running dd if=/dev/sd$i bs=1M of=/dev/null
> in parallel - iostat reports 99-100 % utilization of each disk and about
> 55 MB/s read per disk). All the disks are connected by a four-lane
> SAS controller, so the maximum theoretical throughput is 4x 3 Gbit/s
> = 12 Gbit/s = 0.5 Gbit/s per disk = 62.5 MByte/s per disk).
> 
> 	Here are the performance data from the initial resync:
> 
> # cat /proc/mdstat
> [...]
> md1 : active raid10 sdz2[23] sdy2[22] sdx2[21] sdw2[20] sdu2[19] sdt2[18] sds2[17] sdr2[16] sdq2[15] sdp2[14] sdo2[13] sdn2[12] sdm2[11] sdl2[10] sdk2[9] sdj2[8] sdi2[7] sdh2[6] sdg2[5] sdf2[4] sde2[3] sdd2[2] sdc2[1] sdb2[0]
>       23190484992 blocks super 1.2 512K chunks 2 near-copies [24/24] [UUUUUUUUUUUUUUUUUUUUUUUU]
>       [=>...................]  resync =  7.3% (1713514432/23190484992) finish=796.4min speed=449437K/sec
> 
> # top
> top - 23:05:31 up  8:20,  5 users,  load average: 3.12, 3.29, 3.25
> Tasks: 356 total,   3 running, 353 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.0%us,  8.3%sy,  0.0%ni, 91.1%id,  0.0%wa,  0.0%hi,  0.6%si,  0.0%st
> Mem:  132298920k total,  3528792k used, 128770128k free,    53892k buffers
> Swap: 10485756k total,        0k used, 10485756k free,   818496k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
> 12561 root      20   0     0    0    0 R 99.8  0.0  61:12.61 md1_raid10         
> 12562 root      20   0     0    0    0 R 79.6  0.0  47:06.60 md1_resync         
> [...]
> 
> # iostat -kx 5
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.00    0.00    9.54    0.00    0.00   90.46
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdb              19.20     0.00  573.60    0.00 37939.20     0.00   132.28     0.50    0.87   0.30  17.26
> sdc              19.60     0.00  573.20    0.00 37939.20     0.00   132.38     0.51    0.89   0.31  17.58
> sdd              13.80     0.00  578.20    0.00 37888.00     0.00   131.05     0.52    0.89   0.31  18.02
> sdf              19.20     0.00  572.80    0.00 37888.00     0.00   132.29     0.50    0.88   0.32  18.12
> sde              12.80     0.00  579.40    0.00 37900.80     0.00   130.83     0.54    0.94   0.32  18.38
> sdg              16.60     0.00  575.40    0.00 37888.00     0.00   131.69     0.53    0.93   0.33  18.76
> [...]
> sdy              14.40     0.00  579.20    0.00 37990.40     0.00   131.18     0.52    0.91   0.31  17.78
> sdz             135.00   229.00  458.60  363.00 37990.40 37888.00   184.71     2.30    2.80   0.76  62.32
> md1               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
> 
> 	Thanks,
> 
> -Yenya
> 

