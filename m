From: Berkey B Walker <berk@panix.com>
Subject: Re: [md PATCH 00/16] bad block list management for md and RAID1
Date: Sun, 06 Jun 2010 20:28:04 -0400
Message-ID: <4C0C3D14.6020206@panix.com>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Excellent start Neil.  This will be much appreciated.
b-

NeilBrown wrote:
> In the spirit of "release early" I thought I would post some patches
> that I have been working on lately.
>
> Please don't try these on a system with valuable data - they are very
> early code and will probably do the wrong thing.
>
> The goal of these patches is to add a 'bad block list' to each device
> and use it to allow us to fail single blocks rather than whole
> devices.
>
> This is particularly useful in arrays will multiple redundancy
> (e.g. RAID6 or 3-device RAID1).  In such cases, bad blocks in
> different places on different devices can leave an array that still
> has at-least single redundancy on all stripes.  Without this support,
> such arrays could become non-fuinctional.
>
> This is also a necessary preparation to being able to support
> 'hot-replace' where we build a new device while the old device is
> still in service.  Such a process is only really needed if the old
> device is potentially faulty, and having the bad-block-list in place
> allows it to continue to provide the best service it can even when it
> cannot provide 100% service.
>
> These patches have only seen limited testing, and are posted primarily
> for review rather than testing, though testing is always valuable,
> especially if you use the md/faulty module to simulate errors, or have
> a drive that provides you with real errors...
>
> This series provides infrastructure and integration into raid1.c only.
> raid5.c and raid10.c support are still to be written.
>
> NeilBrown
>
>
> ---
>
> NeilBrown (16):
>        md: beginnings of bad block management.
>        md/bad-block-log: add sysfs interface for accessing bad-block-log.
>        md: don't allow arrays to contain devices with bad blocks.
>        md: load/store badblock list from v1.x metadata
>        md: reject devices with bad blocks and v0.90 metadata.
>        md/raid1: clean up read_balance.
>        md: simplify raid10 read_balance
>        md/raid1: avoid reading from known bad blocks.
>        md/raid1: avoid reading known bad blocks during resync
>        md: add 'write_error' flag to component devices.
>        md/multipath: discard ->working_disks in favour of ->degraded
>        md: make error_handler functions more uniform and correct.
>        md: make it easier to wait for bad blocks to be acknowledged.
>        md/raid1: avoid writing to known-bad blocks on known-bad drives.
>        md/raid1: clear bad-block record when write succeeds.
>        md/raid1:  Handle write errors by updating badblock log.
>
>
>   drivers/md/dm-raid456.c   |    6
>   drivers/md/md.c           |  725 +++++++++++++++++++++++++++++++++++++++++++--
>   drivers/md/md.h           |   76 ++++-
>   drivers/md/multipath.c    |   60 ++--
>   drivers/md/multipath.h    |    1
>   drivers/md/raid1.c        |  714 +++++++++++++++++++++++++++++++++++---------
>   drivers/md/raid1.h        |   14 +
>   drivers/md/raid10.c       |  123 ++++----
>   drivers/md/raid5.c        |   48 ++-
>   include/linux/raid/md_p.h |   13 +
>   10 files changed, 1475 insertions(+), 305 deletions(-)
>
>    
