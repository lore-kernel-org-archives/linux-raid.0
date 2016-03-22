From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Grow: goto release if Manage_subdevs failed
Date: Tue, 22 Mar 2016 13:54:44 -0400
Message-ID: <wrfjwpou9z4r.fsf@redhat.com>
References: <1458637424-13887-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1458637424-13887-1-git-send-email-gqjiang@suse.com> (Guoqing
	Jiang's message of "Tue, 22 Mar 2016 17:03:44 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> If failure happened when add disk to array
> by grow mode, need to goto release instead
> of continue the reshape.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Grow.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index cf2750a..1767a1e 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3003,8 +3003,9 @@ static int reshape_array(char *container, int fd, char *devname,
>  	 * level and frozen, we can safely add them.
>  	 */
>  	if (devlist)
> -		Manage_subdevs(devname, fd, devlist, verbose,
> -			       0,NULL, 0);
> +		if (Manage_subdevs(devname, fd, devlist, verbose,
> +				   0,NULL, 0))
> +			goto release;
>  
>  	if (reshape.backup_blocks == 0 && data_offset != INVALID_SECTORS)
>  		reshape.backup_blocks = reshape.before.data_disks * info->array.chunk_size/512;

Applied with minor mod to add brackets to the outer if() case - I hope
you are OK with this.

Cheers,
Jes

From 31dbeda730ab1c25040f2e9b5bc49008b8519adf Mon Sep 17 00:00:00 2001
From: Guoqing Jiang <gqjiang@suse.com>
Date: Tue, 22 Mar 2016 17:03:44 +0800
Subject: [PATCH] Grow: goto release if Manage_subdevs failed

If failure happened when add disk to array
by grow mode, need to goto release instead
of continue the reshape.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 3204135..5953db2 100755
--- a/Grow.c
+++ b/Grow.c
@@ -3009,9 +3009,11 @@ static int reshape_array(char *container, int fd, char *devname,
 	 * array.  Now that the array has been changed to the right
 	 * level and frozen, we can safely add them.
 	 */
-	if (devlist)
-		Manage_subdevs(devname, fd, devlist, verbose,
-			       0,NULL, 0);
+	if (devlist) {
+		if (Manage_subdevs(devname, fd, devlist, verbose,
+				   0, NULL, 0))
+			goto release;
+	}
 
 	if (reshape.backup_blocks == 0 && data_offset != INVALID_SECTORS)
 		reshape.backup_blocks = reshape.before.data_disks * info->array.chunk_size/512;
-- 
2.5.5

