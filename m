From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: RAID-10 initial sync is CPU-limited
Date: Tue, 4 Jan 2011 18:13:24 +0100
Message-ID: <20110104171324.GU17455@fi.muni.cz>
References: <20110103163213.GC17455@fi.muni.cz> <20110104162437.31dae9c9@notabene.brown> <20110104082944.GK17455@fi.muni.cz> <4D2332F1.6090205@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D2332F1.6090205@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

John Robinson wrote:
: >	According to dmesg(8) my hardware is able to do XOR
: >at 9864 MB/s using generic_sse, and 2167 MB/s using int64x1. So I assume
: >memcmp+memcpy would not be much slower. According to /proc/mdstat, the 
: >resync
: >is running at 449 MB/s. So I expect just memcmp+memcpy cannot be a 
: >bottleneck
: >here.
: 
: I think it can. Those XOR benchmarks only tell you what the CPU core can 
: do internally, and don't reflect FSB/RAM bandwidth.

	Fair enough.

: My Core 2 Quad 
: 3.2GHz on 1.6GHz FSB with dual-channel memory at 800MHz each (P45 
: chipset) has maximum memory bandwidth of about 4.5GB/s with two sticks 
: of RAM, according to memtest86+. With 4 sticks of RAM it's 3.5GB/s. In 
: real use it'll be rather less.

	My system has 16 1333MHz DIMMs, so I expect the total
available bandwidth would be much higher than 6x 449 MB/s.

: One core can easily saturate the memory bandwidth, so having multiple 
: threads would not help at all.

	I am not sure about that, especially on NUMA systems
(my system is dual-socket Opteron 6128). I would think having at least
two threads (each one running on a core in a different socket) can help.

: (a) if you memcpy it, you go through RAM 4 times instead of 6;

	Yes, I was wondering why the resync does memcpy at all instead
of passing the buffer to the other half of a mirror and doing DMA from it
as soon as memcmp fails.

: In the mean time, wiping your discs before you create the array with `dd 
: if=/dev/zero of=/dev/disk` would only go from RAM to disc twice (once 
: for each disc), then create the array with --assume-clean.

	I think it is possible to do --assume-clean even without
cleaning the disk, provided that the resulting md device is used by a
filesystem. I don't think there is a filesystem that reads blocks which
it did not write before.

	Anyway, I have tried to do "echo check > /sys/block/md1/md/sync_action"
and apparently just checking the array without writing (i.e. just memcmp
without memcpy) is sometimes able to keep the disks with 100% utilization
according to iostat. In /proc/mdstat I can see the rebuild speed of about
520 MB/s.  md1_resync uses about 40-50% of a single CPU, and md1_raid10
still uses 90-100%.

	Another possible source of the overhead is that the resync
uses page-sized chunks instead of something bigger, and relies on the
block layer to do request merging. I observe high variance of
the avgrq-sz value in iostat (varying between about 120 to 280).
Maybe this is what causes the md1_raid10 high CPU utilization?

	Sincerely,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
