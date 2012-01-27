From: Piergiorgio Sartor <piergiorgio.sartor@arcor.de>
Subject: Re: RAID-6 recovery questions
Date: Fri, 27 Jan 2012 18:56:18 +0100
Message-ID: <20120127175618.GA3341@lazy.lzy>
References: <20120127081025.GA22388@jurassic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120127081025.GA22388@jurassic>
Sender: linux-raid-owner@vger.kernel.org
To: Mukund Sivaraman <muks@banu.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 27, 2012 at 01:40:25PM +0530, Mukund Sivaraman wrote:
> Hi all
> 
> I am interested in building a 3TB * 8 disk RAID-6 array for
> personal use. I am looking for info related to md recovery in the case
> of failure.
> 
> I want to rely on the md RAID-6 array to some extent. It is a large
> capacity array, and it is not financially feasible for me to have an
> external mirror of it.
> 
> It seems that distributions like Fedora have a raid-check script for
> periodic patrol read check, which is bound to reduce the risk of
> surprise read errors during recovery.
> 
> In the unlikely case of 2 disk failure, a RAID-6 array loses redundancy,
> but the array is still available.
> 
> When a disk reports errors reading blocks, it's likely that the rest of
> the disk is readable, save for the bad blocks. In large capacity disks
> available today, bad blocks are very common (as SMART output on year-old
> disks will show). (Rewriting these bad blocks should make the disk remap
> them and make them available again.)
> 
> My questions:
> 
> 1. During recovery after 1-disk failure, what happens if there are
> read errors on more than one disk? From what I've understood it seems
> that if there is a read error during recovery, the entire disk is marked
> as failed. It's very probable that these bad blocks are in different
> places on different disks. Is it mathematically possible (RAID-6) to
> recover such an array completely (rewriting the bad blocks with data
> from other disks)? What options are available to recover from such a
> situation?
> 
> Figure:
> 
> +---+---+---+---+---+---+---+---+
> | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |  RAID-6 array
> +---+---+---+---+---+---+---+---+
>   ^   ^   ^  \---------v-------/
>   |   |   |           ok
> dead  |   |
>       |   +- partial read errors
>       +----- partial read errors
> 
> {read_error_blocks(3)} intersect {read_error_blocks(2)} = NUL.
> 
> 
> 2. During recovery after 2-disk failure, what happens if there are
> read errors?  Is it possible to overwrite the bad blocks with zeros (so
> they are remapped and don't error anymore) and force them back into the
> same array configuration so that most of the filesystem can be recovered
> (except for the data in the bad blocks) ?
> 
> 3. What is the raid6check(8) tool useful for, which checks non-degraded
> arrays?  Doesn't "echo check > /sys/block/$dev/md/sync_action" do the
> same?

The check using the sysfs will tell you *only* how many
blocks have a mismatch, that is, how many times the parity
is not correct.

The "raid6check" will tell you which stripe have mismatches
and, if possible, which HDD is responsible for the mismatches.
It can happen the parity is fine, but one HDD has problems.
This is done exploiting the RAID6 double parity and, of
course, can work only on non-degraded arrays.

Hope this helps,

bye,

pg

> 
> 
> Kind regards,
> 
> Mukund
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
