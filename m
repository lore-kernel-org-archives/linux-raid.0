From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID-10 initial sync is CPU-limited
Date: Tue, 04 Jan 2011 14:54:28 +0000
Message-ID: <4D2334A4.4040109@anonymous.org.uk>
References: <20110103163213.GC17455@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110103163213.GC17455@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2011 16:32, Jan Kasprzak wrote:
[...]
> 	My hardware is apparently able to keep all the disks busy most
> of the time (verified by running dd if=/dev/sd$i bs=1M of=/dev/null
> in parallel - iostat reports 99-100 % utilization of each disk and about
> 55 MB/s read per disk). All the disks are connected by a four-lane
> SAS controller, so the maximum theoretical throughput is 4x 3 Gbit/s
> = 12 Gbit/s = 0.5 Gbit/s per disk = 62.5 MByte/s per disk).

This is part of your limit. You're able to read from your discs at about 
1320MB/s (24*55MB/s), but you're throwing the data away. Doing the 
resync, you'd be reading two chunks for each one that's written, so 
reading about 880MB/s and writing about 440MB/s. Modern 7200rpm discs 
ought to be able to read at perhaps 125MB/s and write at over 100MB/s, 
but because you're throttled by the PCIe x4 interface, you're only 
getting about half of what your discs could do.

Check how fast one disc can go on its own with access to the whole PCIe 
interface with a single dd invocation.

Cheers,

John.


