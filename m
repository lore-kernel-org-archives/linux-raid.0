From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH V2] MD: add doc for raid5-cache
Date: Sun, 12 Feb 2017 00:16:40 +0000
Message-ID: <87k28wi7pz.fsf@esperi.org.uk>
References: <cac53388fd5903a006792c0165063d63eb66079d.1486408891.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cac53388fd5903a006792c0165063d63eb66079d.1486408891.git.shli@fb.com>
        (Shaohua Li's message of "Mon, 6 Feb 2017 11:23:29 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, antlists@youngman.org.uk, philip@turmel.org, songliubraving@fb.com, neilb@suse.com, jure.erznoznik@gmail.com, rramesh2400@gmail.com
List-Id: linux-raid.ids

On 6 Feb 2017, Shaohua Li stated:

> +write-back mode:
> +
> +write-back mode fixes the 'write hole' issue too, since all write data is
> +cached on cache disk. But the main goal of 'write-back' cache is to speed up
> +write. If a write crosses all RAID disks of a stripe, we call it full-stripe
> +write. For non-full-stripe writes, MD must read old data before the new parity
> +can be calculated. These synchronous reads hurt write throughput. Some writes
> +which are sequential but not dispatched in the same time will suffer from this
> +overhead too. Write-back cache will aggregate the data and flush the data to
> +RAID disks only after the data becomes a full stripe write. This will
> +completely avoid the overhead, so it's very helpful for some workloads. A
> +typical workload which does sequential write followed by fsync is an example.
> +
> +In write-back mode, MD reports IO completion to upper layer (usually
> +filesystems) right after the data hits cache disk. The data is flushed to raid
> +disks later after specific conditions met. So cache disk failure will cause
> +data loss.
> +
> +In write-back mode, MD also caches data in memory. The memory cache includes
> +the same data stored on cache disk, so a power loss doesn't cause data loss.
> +The memory cache size has performance impact for the array. It's recommended
> +the size is big. A user can configure the size by:
> +
> +echo "2048" > /sys/block/md0/md/stripe_cache_size

I'm missing something. Won't a big stripe_cache_size have the same
effect on reducing the read size of RMW as the writeback cache has?
That's the entire point of it: to remember stripes so you don't need to
take the R hit so often. I mean, sure, it won't survive a power loss: is
this just to avoid RMWs for the first write after a power loss to
stripes that were previously written before the power loss? Or is it
because the raid5-cache can be much bigger than the in-memory cache,
caching many thousands of stripes? (in which case, the raid5-cache is
preferable for any workload in which random or sub-stripe sequential
writes are scattered across very many distinct stripes rather than being
concentrated in a few, or a few dozen. This is probably a very common
case even for things like compilations or git checkouts, because new
file creation tends to be fairly scattered: every new object file might
well be in a different stripe from every other, so virtually every write
of less than the stripe size would have to block on the completion of a
read.)

(... this question is because I'm re-entering the world of md5 after
years wandering in the wilderness of hardware RAID: the writethrough
mode looks very compelling, particularly now your docs have described
how big it needs to be, or rather how big it doesn't need to be. But I
don't quite see the point of writeback mode yet.)

Hm. This is probably also a reason to keep your stripes not too large:
it's more likely that smallish writes will fill whole stripes and avoid
the read entirely. I was considering it pointless to make the stripe
size smaller than the average size of a disk track (if you can figure
that out these days), but making it much smaller seems like it's still
worthwhile.

Does anyone have recentish performance figures on the effect of changing
chunk, and thus, stripe sizes on things like file creations for a range
of sizes, or is picking a stripe size, stripe cache size, and readahead
value still basically guesswork like it was when I did this last? The
RAID performance pages show figures all over the shop, with most people
apparently agreeing on chunk sizes of 128--256KiB and *nobody* agreeing
on readahead or stripe cache sizes :( is there anything resembling a
consensus here yet?

-- 
NULL && (void)
