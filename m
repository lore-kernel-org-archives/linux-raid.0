From: Coly Li <colyli@suse.de>
Subject: Re: raid0 vs. mkfs
Date: Mon, 28 Nov 2016 01:09:46 +0800
Message-ID: <470ba5d0-e54d-3e5e-c639-4591549b9574@suse.de>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2016/11/27 下午11:24, Avi Kivity wrote:
> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large
> disk that supports TRIM/DISCARD (erase whichever is inappropriate). 
> That is because mkfs issues a TRIM/DISCARD (erase whichever is
> inappropriate) for the entire partition. As far as I can tell, md
> converts the large TRIM/DISCARD (erase whichever is inappropriate) into
> a large number of TRIM/DISCARD (erase whichever is inappropriate)
> requests, one per chunk-size worth of disk, and issues them to the RAID
> components individually.
> 
> 
> It seems to me that md can convert the large TRIM/DISCARD (erase
> whichever is inappropriate) request it gets into one TRIM/DISCARD (erase
> whichever is inappropriate) per RAID component, converting an O(disk
> size / chunk size) operation into an O(number of RAID components)
> operation, which is much faster.
> 
> 
> I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, with
> the operation taking about a quarter of an hour, continuously pushing
> half-megabyte TRIM/DISCARD (erase whichever is inappropriate) requests
> to the disk. Linux 4.1.12.

It might be possible to improve a bit for DISCARD performance, by your
suggestion. The implementation might be tricky, but it is worthy to try.

Indeed, it is not only for DISCARD, for read or write, it might be
helpful for better performance as well. We can check the bio size, if,
	bio_sectors(bio)/conf->nr_strip_zones >= SOMETHRESHOLD
it means on each underlying device, we have more then SOMETHRESHOLD
continuous chunks to issue, and they can be merged into a larger bio.

IMHO it's interesting, good suggestion!

Coly

