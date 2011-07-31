From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: build warnings after merge of the moduleh tree
Date: Sun, 31 Jul 2011 04:24:05 -0400
Message-ID: <20110731082405.GM31842@windriver.com>
References: <20110729152548.17e093cb01d95077a05d4cec@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110729152548.17e093cb01d95077a05d4cec@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[linux-next: build warnings after merge of the moduleh tree] On 29/07/2011 (Fri 15:25) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> drivers/md/persistent-data/dm-block-manager.c:103:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
[...]
> drivers/md/persistent-data/dm-space-map-disk.c:634:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
[...]
> drivers/md/persistent-data/dm-btree.c:146:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
[...]
> drivers/md/persistent-data/dm-btree-remove.c:569:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> 
> I have added the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 15:16:04 +1000
> Subject: [PATCH] include export.h to use EXPORT_SYMBOL
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/md/persistent-data/dm-block-manager.c  |    1 +
>  drivers/md/persistent-data/dm-btree-remove.c   |    2 ++
>  drivers/md/persistent-data/dm-btree.c          |    1 +
>  drivers/md/persistent-data/dm-space-map-disk.c |    1 +
>  4 files changed, 5 insertions(+), 0 deletions(-)

This one is a bit more interesting.  The above files (and actually their
parent dir) doesn't exist yet in master/HEAD.  So I can't patch them
yet.  And the MD maintainers can't patch in export.h usage, since they
won't have such a header file.

If you didn't want to temporarily carry it, I can think of two things:
I suppose, since the one single commit that creates export.h is totally
standalone, and harmless/inert in itself, we could perhaps get it pulled
independently if it made life easier for others to align to the right
usage?  Or they can just patch in module.h usage and we can downgrade
them to export.h usage shortly thereafter.

Paul.

> 
> diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
> index 4ec480c..7b8e84c 100644
> --- a/drivers/md/persistent-data/dm-block-manager.c
> +++ b/drivers/md/persistent-data/dm-block-manager.c
> @@ -9,6 +9,7 @@
>  #include <linux/dm-io.h>
>  #include <linux/slab.h>
>  #include <linux/device-mapper.h>
> +#include <linux/export.h>
>  
>  #define DM_MSG_PREFIX "block manager"
>  
> diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
> index 72c9705..e7071f6 100644
> --- a/drivers/md/persistent-data/dm-btree-remove.c
> +++ b/drivers/md/persistent-data/dm-btree-remove.c
> @@ -8,6 +8,8 @@
>  #include "dm-btree-internal.h"
>  #include "dm-transaction-manager.h"
>  
> +#include <linux/export.h>
> +
>  /*
>   * Removing an entry from a btree
>   * ==============================
> diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
> index 55b8bf3..7cad5e8 100644
> --- a/drivers/md/persistent-data/dm-btree.c
> +++ b/drivers/md/persistent-data/dm-btree.c
> @@ -9,6 +9,7 @@
>  #include "dm-transaction-manager.h"
>  
>  #include <linux/device-mapper.h>
> +#include <linux/export.h>
>  
>  #define DM_MSG_PREFIX "btree"
>  
> diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
> index de31096..26e6e19 100644
> --- a/drivers/md/persistent-data/dm-space-map-disk.c
> +++ b/drivers/md/persistent-data/dm-space-map-disk.c
> @@ -13,6 +13,7 @@
>  #include <linux/slab.h>
>  #include <linux/bitops.h>
>  #include <linux/device-mapper.h>
> +#include <linux/export.h>
>  
>  #define DM_MSG_PREFIX "space map disk"
>  
> -- 
> 1.7.5.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
