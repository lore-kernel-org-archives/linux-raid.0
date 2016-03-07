From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/2] Fix wrong bitmap output for cluster raid
Date: Mon, 07 Mar 2016 15:53:43 -0500
Message-ID: <wrfjmvqaj9go.fsf@redhat.com>
References: <1457343063-14884-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457343063-14884-1-git-send-email-gqjiang@suse.com> (Guoqing
	Jiang's message of "Mon, 7 Mar 2016 17:31:02 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com, neilb@suse.de
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> For cluster raid, we need to displays bitmap related
> contents from different bitmaps which are based on node
> num. So bitmap_file_open and locate_bitmap are changed a
> little bit for the purpose.
>
> Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> Fixes: b98043a2f8 ("Show all bitmaps while examining bitmap")
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  bitmap.c | 18 +++++++++---------
>  mdadm.h  |  2 +-
>  super0.c |  2 +-
>  super1.c | 12 ++++++------
>  4 files changed, 17 insertions(+), 17 deletions(-)

Applied!

Thanks,
Jes

>
> diff --git a/bitmap.c b/bitmap.c
> index dab674b..5ad7401 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -194,7 +194,7 @@ out:
>  	return info;
>  }
>  
> -int bitmap_file_open(char *filename, struct supertype **stp)
> +int bitmap_file_open(char *filename, struct supertype **stp, int node_num)
>  {
>  	int fd;
>  	struct stat stb;
> @@ -222,7 +222,7 @@ int bitmap_file_open(char *filename, struct supertype **stp)
>  				st->ss->name);
>  			return -1;
>  		} else {
> -			if (st->ss->locate_bitmap(st, fd)) {
> +			if (st->ss->locate_bitmap(st, fd, node_num)) {
>  				pr_err("%s doesn't have bitmap\n", filename);
>  				fd = -1;
>  			}
> @@ -267,7 +267,7 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
>  	int fd, i;
>  	__u32 uuid32[4];
>  
> -	fd = bitmap_file_open(filename, &st);
> +	fd = bitmap_file_open(filename, &st, 0);
>  	if (fd < 0)
>  		return rv;
>  
> @@ -348,11 +348,11 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
>  		printf("   Cluster nodes : %d\n", sb->nodes);
>  		printf("    Cluster name : %-64s\n", sb->cluster_name);
>  		for (i = 0; i < (int)sb->nodes; i++) {
> -			if (i) {
> -				free(info);
> -				info = bitmap_fd_read(fd, brief);
> -				sb = &info->sb;
> -			}
> +			st = NULL;
> +			free(info);
> +			fd = bitmap_file_open(filename, &st, i);
> +			info = bitmap_fd_read(fd, brief);
> +			sb = &info->sb;
>  			if (sb->magic != BITMAP_MAGIC)
>  				pr_err("invalid bitmap magic 0x%x, the bitmap file appears to be corrupted\n", sb->magic);
>  
> @@ -367,7 +367,7 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
>  			printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
>  			       info->total_bits, info->dirty_bits,
>  			       100.0 * info->dirty_bits / (info->total_bits?:1));
> -
> +			 close(fd);
>  		}
>  	}
>  
> diff --git a/mdadm.h b/mdadm.h
> index 72888e2..355c455 100755
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -904,7 +904,7 @@ extern struct superswitch {
>  	/* Seek 'fd' to start of write-intent-bitmap.  Must be an
>  	 * md-native format bitmap
>  	 */
> -	int (*locate_bitmap)(struct supertype *st, int fd);
> +	int (*locate_bitmap)(struct supertype *st, int fd, int node_num);
>  	/* if add_internal_bitmap succeeded for existing array, this
>  	 * writes it out.
>  	 */
> diff --git a/super0.c b/super0.c
> index 59a6a03..6fc1ac4 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -1156,7 +1156,7 @@ static int add_internal_bitmap0(struct supertype *st, int *chunkp,
>  	return 1;
>  }
>  
> -static int locate_bitmap0(struct supertype *st, int fd)
> +static int locate_bitmap0(struct supertype *st, int fd, int node_num)
>  {
>  	unsigned long long dsize;
>  	unsigned long long offset;
> diff --git a/super1.c b/super1.c
> index 9b877e5..f8a35ac 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1548,7 +1548,7 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
>  }
>  #endif
>  
> -static int locate_bitmap1(struct supertype *st, int fd);
> +static int locate_bitmap1(struct supertype *st, int fd, int node_num);
>  
>  static int store_super1(struct supertype *st, int fd)
>  {
> @@ -1622,7 +1622,7 @@ static int store_super1(struct supertype *st, int fd)
>  		struct bitmap_super_s *bm = (struct bitmap_super_s*)
>  			(((char*)sb)+MAX_SB_SIZE);
>  		if (__le32_to_cpu(bm->magic) == BITMAP_MAGIC) {
> -			locate_bitmap1(st, fd);
> +			locate_bitmap1(st, fd, 0);
>  			if (awrite(&afd, bm, sizeof(*bm)) != sizeof(*bm))
>  				return 5;
>  		}
> @@ -2062,7 +2062,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
>  	 * valid.  If it doesn't clear the bit.  An --assemble --force
>  	 * should get that written out.
>  	 */
> -	locate_bitmap1(st, fd);
> +	locate_bitmap1(st, fd, 0);
>  	if (aread(&afd, bsb, 512) != 512)
>  		goto no_bitmap;
>  
> @@ -2334,7 +2334,7 @@ add_internal_bitmap1(struct supertype *st,
>  	return 1;
>  }
>  
> -static int locate_bitmap1(struct supertype *st, int fd)
> +static int locate_bitmap1(struct supertype *st, int fd, int node_num)
>  {
>  	unsigned long long offset;
>  	struct mdp_superblock_1 *sb;
> @@ -2353,7 +2353,7 @@ static int locate_bitmap1(struct supertype *st, int fd)
>  	else
>  		ret = -1;
>  	offset = __le64_to_cpu(sb->super_offset);
> -	offset += (int32_t) __le32_to_cpu(sb->bitmap_offset);
> +	offset += (int32_t) __le32_to_cpu(sb->bitmap_offset) * (node_num + 1);
>  	if (mustfree)
>  		free(sb);
>  	lseek64(fd, offset<<9, 0);
> @@ -2408,7 +2408,7 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
>  
>  	init_afd(&afd, fd);
>  
> -	locate_bitmap1(st, fd);
> +	locate_bitmap1(st, fd, 0);
>  
>  	if (posix_memalign(&buf, 4096, 4096))
>  		return -ENOMEM;
