From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [PULL REQUEST] md updates for 3.9
Date: Wed, 3 Apr 2013 19:56:34 +0300
Message-ID: <CAGRgLy6XOEy5Aa8OE6t1G3V4MwO6VcTON9hRGgMzgTOxG9V+LQ@mail.gmail.com>
References: <20130304111640.32c428a0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130304111640.32c428a0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: joe.lawrence@stratus.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On Mon, Mar 4, 2013 at 2:16 AM, NeilBrown <neilb@suse.de> wrote:
>
> The following changes since commit
> 19f949f52599ba7c3f67a5897ac6be14bfcb1200:
>
>   Linux 3.8 (2013-02-18 15:58:34 -0800)
>
> are available in the git repository at:
>
>   git://neil.brown.name/md tags/md-3.9
>
> for you to fetch changes up to f3378b48705154b9089affb2d2e939622aea68f1:
>
>   md: expedite metadata update when switching  read-auto -> active
> (2013-02-28 11:59:03 +1100)
>
> Thanks,
> NeilBrown
>
>
>
> ----------------------------------------------------------------
> md updates for 3.9
>
> mostly little bugfixes.
> Only "feature" is a new RAID10 layout which slightly
> improves the number of sets of devices that can concurrently
> fail, without data loss.
>
> ----------------------------------------------------------------
> Joe Lawrence (1):
>       md: raid1,10: Handle REQ_WRITE_SAME flag in write bios

Can this patch be ported to 3.8.x kernel (e.g., 3.8.2)?

Currently, we have code that calls blkdev_issue_zeroout() to an MD
raid1 block device, but it calls blkdev_issue_write_same(), which is
not supported properly by MD raid1 in this kernel:( So we get junk
instead of zeroed data...

Any advice?

Thanks,
Alex.





>
> Jonathan Brassow (4):
>       MD RAID10: Minor non-functional code changes
>       MD RAID10: Improve redundancy for 'far' and 'offset' algorithms
> (part 1)
>       MD RAID10: Improve redundancy for 'far' and 'offset' algorithms
> (part 2)
>       DM RAID: Add support for MD's RAID10 "far" and "offset" algorithms
>
> NeilBrown (6):
>       md: fix two bugs when attempting to resize RAID0 array.
>       md: raid0: fix error return from create_stripe_zones.
>       md/raid0: improve error message when converting RAID4-with-spares to
> RAID0
>       md/raid1,raid10: fix deadlock with freeze_array()
>       md: remove CONFIG_MULTICORE_RAID456
>       md: expedite metadata update when switching  read-auto -> active
>
> Sebastian Riemer (1):
>       md: protect against crash upon fsync on ro array
>
>  Documentation/device-mapper/dm-raid.txt |  44 +++++++++++++---
>  drivers/md/Kconfig                      |  11 ----
>  drivers/md/dm-raid.c                    | 123
> ++++++++++++++++++++++++++++++++++++-------
>  drivers/md/md.c                         |  19 ++++++-
>  drivers/md/raid0.c                      |  13 +++--
>  drivers/md/raid1.c                      |   8 ++-
>  drivers/md/raid10.c                     |  97
> ++++++++++++++++++++++++++--------
>  drivers/md/raid10.h                     |   5 ++
>  drivers/md/raid5.c                      |  38 +------------
>  9 files changed, 256 insertions(+), 102 deletions(-)
