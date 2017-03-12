From: Liu Zhilong <zlliu@suse.com>
Subject: Re: [PATCH 2/4] mdadm:external bitmap only supports ext filesystem
Date: Sun, 12 Mar 2017 10:48:01 -0400
Message-ID: <1dbe7b29-a414-3031-a562-0799750e174c@suse.com>
References: <20170308074831.24683-1-zlliu@suse.com>
 <20170308075144.24873-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170308075144.24873-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


      as this patch's purpose, just wanna improve the prompt when using the
external bitmap mode, and this patch maybe a little redundant.
      For the errno rule, RUN_ARRAY returned EINVAL indeed and the man page
has indicated that external bitmap only works with ext[2-4] file system.
      I think it would be more user-friendly if prints one prompt and 
returned
EINVAL at the same time when the bmap() got failure.
      Such as:

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9fb2cca..0bff96b 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -381,6 +381,7 @@ static int read_page(struct file *file, unsigned 
long index,
                         bh->b_blocknr = bmap(inode, block);
                         if (bh->b_blocknr == 0) {
                                 /* Cannot use this file! */
+                               pr_err("The external bitmap only works 
with ext[2-4] filesystem.\n");
                                 ret = -EINVAL;
                                 goto out;
                         }
Thanks,
-Zhilong

On 03/08/2017 02:51 AM, Zhilong Liu wrote:
> mdadm: ensure that the external bitmap_file is
> stored by ext[2-4] file system, because bmap()
> of linux/driver/md/bitmap.c exits directly when
> the bitmap_file isn't suitable. mdadm should make
> users aware of this scenario and give a prompt.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>
> diff --git a/Create.c b/Create.c
> index 2721884..9a951b0 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -831,11 +831,6 @@ int Create(struct supertype *st, char *mddev,
>   			goto abort_locked;
>   		}
>   		bitmap_fd = open(s->bitmap_file, O_RDWR);
> -		if (bitmap_fd < 0) {
> -			pr_err("weird: %s cannot be openned\n",
> -				s->bitmap_file);
> -			goto abort_locked;
> -		}
>   		if (ioctl(mdfd, SET_BITMAP_FILE, bitmap_fd) < 0) {
>   			pr_err("Cannot set bitmap file for %s: %s\n",
>   				mddev, strerror(errno));
> diff --git a/mdadm.c b/mdadm.c
> index d6ad8dc..19a06db 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -28,6 +28,7 @@
>   #include "mdadm.h"
>   #include "md_p.h"
>   #include <ctype.h>
> +#include <sys/vfs.h>
>   
>   static int scan_assemble(struct supertype *ss,
>   			 struct context *c,
> @@ -1143,6 +1144,21 @@ int main(int argc, char *argv[])
>   			    strcmp(optarg, "none") == 0 ||
>   			    strchr(optarg, '/') != NULL) {
>   				s.bitmap_file = optarg;
> +				if (strchr(s.bitmap_file, '/') != NULL) {
> +					bitmap_fd = open(s.bitmap_file, O_RDWR);
> +					if (bitmap_fd < 0) {
> +						pr_err("weird: %s cannot be openned\n", s.bitmap_file);
> +						exit(2);
> +					}
> +					close(bitmap_fd);
> +					struct statfs ext_bitmap;
> +					statfs(s.bitmap_file, &ext_bitmap);
> +					if (ext_bitmap.f_type != 0xEF53){
> +						pr_err("external bitmap only supports ext[2-4] filesystem, %s.\n",
> +							s.bitmap_file);
> +						exit(2);
> +					}
> +				}
>   				continue;
>   			}
>   			if (strcmp(optarg, "clustered") == 0) {

