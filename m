From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v3] block: refactor duplicated macros
Date: Wed, 11 Mar 2020 19:20:11 +0800
Message-ID: <89925759-cbc1-e8f0-b9b3-23fd062ebbcd@suse.de>
References: <20200311002254.121365-1-mcroce@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200311002254.121365-1-mcroce@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Matteo Croce <mcroce@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Ulf Hansson <ulf.hansson@linaro.org>, Anna Schumaker <anna.schumaker@netapp.com>, Dan Williams <dan.j.williams@intel.com>, Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

On 2020/3/11 8:22 上午, Matteo Croce wrote:
> The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
> several times in different flavours across the whole tree.
> Define them just once in a common header.
> 
> While at it, replace replace "PAGE_SHIFT - 9" with "PAGE_SECTORS_SHIFT" too
> and rename SECTOR_MASK to PAGE_SECTORS_MASK.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Hi Matteo,

For the bcache part, it looks good to me.

Acked-by: Coly Li <colyli@suse.de>

> ---
> v3:
> As Guoqing Jiang suggested, replace "PAGE_SHIFT - 9" with "PAGE_SECTORS_SHIFT"
> 
> v2:
> As Dan Williams suggested:
> 
>  #define PAGE_SECTORS_MASK            (~(PAGE_SECTORS - 1))
> 
>  block/blk-lib.c                  |  2 +-
>  block/blk-settings.c             |  4 ++--
>  block/partition-generic.c        |  2 +-
>  drivers/block/brd.c              |  3 ---
>  drivers/block/null_blk_main.c    | 14 +++++---------
>  drivers/block/zram/zram_drv.c    |  8 ++++----
>  drivers/block/zram/zram_drv.h    |  2 --
>  drivers/dax/super.c              |  2 +-
>  drivers/md/bcache/util.h         |  2 --
>  drivers/md/dm-bufio.c            |  6 +++---
>  drivers/md/dm-integrity.c        | 10 +++++-----
>  drivers/md/dm-table.c            |  2 +-
>  drivers/md/md.c                  |  4 ++--
>  drivers/md/raid1.c               |  2 +-
>  drivers/md/raid10.c              |  2 +-
>  drivers/md/raid5-cache.c         | 10 +++++-----
>  drivers/md/raid5.h               |  2 +-
>  drivers/mmc/core/host.c          |  3 ++-
>  drivers/nvme/host/fc.c           |  2 +-
>  drivers/nvme/target/loop.c       |  2 +-
>  drivers/scsi/xen-scsifront.c     |  4 ++--
>  fs/erofs/internal.h              |  2 +-
>  fs/ext2/dir.c                    |  2 +-
>  fs/iomap/buffered-io.c           |  2 +-
>  fs/libfs.c                       |  2 +-
>  fs/nfs/blocklayout/blocklayout.h |  2 --
>  fs/nilfs2/dir.c                  |  2 +-
>  include/linux/blkdev.h           |  4 ++++
>  include/linux/device-mapper.h    |  1 -
>  mm/page_io.c                     |  4 ++--
>  mm/swapfile.c                    | 12 ++++++------
>  31 files changed, 56 insertions(+), 65 deletions(-)
> 

[snipped]

> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index c029f7443190..55196e0f37c3 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -15,8 +15,6 @@
>  
>  #include "closure.h"
>  
> -#define PAGE_SECTORS		(PAGE_SIZE / 512)
> -
>  struct closure;
>  
>  #ifdef CONFIG_BCACHE_DEBUG

[snipped]


-- 

Coly Li
