From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] block: refactor duplicated macros
Date: Tue, 10 Mar 2020 14:06:02 -0700
Message-ID: <CAPhsuW6DOkyvscJhxXPE+KLsw=WH6CQ=8_5uThzf7_pmD3E8JA@mail.gmail.com>
References: <20200223165724.23816-1-mcroce@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200223165724.23816-1-mcroce@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matteo Croce <mcroce@redhat.com>
Cc: linux-block@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-mmc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Ulf Hansson <ulf.hansson@linaro.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-Id: linux-raid.ids

On Sun, Feb 23, 2020 at 8:58 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
> several times in different flavours across the whole tree.
> Define them just once in a common header.
>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  block/blk-lib.c                  |  2 +-
>  drivers/block/brd.c              |  3 ---
>  drivers/block/null_blk_main.c    |  4 ----
>  drivers/block/zram/zram_drv.c    |  8 ++++----
>  drivers/block/zram/zram_drv.h    |  2 --
>  drivers/dax/super.c              |  2 +-
>  drivers/md/bcache/util.h         |  2 --
>  drivers/md/dm-bufio.c            |  6 +++---
>  drivers/md/dm-integrity.c        | 10 +++++-----
>  drivers/md/md.c                  |  4 ++--
>  drivers/md/raid1.c               |  2 +-
>  drivers/mmc/core/host.c          |  3 ++-
>  drivers/scsi/xen-scsifront.c     |  4 ++--
>  fs/iomap/buffered-io.c           |  2 +-
>  fs/nfs/blocklayout/blocklayout.h |  2 --
>  include/linux/blkdev.h           |  4 ++++
>  include/linux/device-mapper.h    |  1 -
>  17 files changed, 26 insertions(+), 35 deletions(-)

For md:

Acked-by: Song Liu <song@kernel.org>
