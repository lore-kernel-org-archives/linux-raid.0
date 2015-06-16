From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 11/11] Reuse the write_bitmap for update uuid
Date: Wed, 17 Jun 2015 09:54:07 +1000
Message-ID: <20150617095407.14d4ed4e@home.neil.brown.name>
References: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
	<1433914934-21195-12-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1433914934-21195-12-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

On Wed, 10 Jun 2015 13:42:14 +0800
Guoqing Jiang <gqjiang@suse.com> wrote:

> To handle different situations, it can support updating the uuid of
> the bitmap. This patch also removes the redundant bitmap_update_uuid.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Hi,
 I have applied all patches except this one to a new branch called
 'cluster' in git://neil.brown.name/mdadm/
 I'll merge it with the master branch after the next point release.

 I made a few changes on the way - mostly fixing indenting.  One more
 significant change is that I made it compile if /usr/include/corosync
 doesn't exist.

 I didn't apply this change because it doesn't make sense to me.  The
 format of the bitmap is independent of the metadata used, so using a
 ->ss method to update t he bitmap doesn't make sense.

 If you can explain what problem you are trying to fix, I'm sure we can
 find a solution that we are both happy with.

Thanks,
NeilBrown

> ---
>  Assemble.c |  5 ++---
>  bitmap.c   | 20 --------------------
>  mdadm.h    |  2 +-
>  super0.c   | 11 +++++++++++
>  super1.c   |  4 ++++
>  5 files changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index d163eaa..2662261 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -662,9 +662,8 @@ static int load_devices(struct devs *devices, char *devmap,
>  
>  			if (strcmp(c->update, "uuid")==0 &&
>  			    ident->bitmap_fd >= 0 && !bitmap_done) {
> -				if (bitmap_update_uuid(ident->bitmap_fd,
> -						       content->uuid,
> -						       tst->ss->swapuuid) != 0)
> +				copy_uuid(tst->devs->uuid, content->uuid, tst->ss->swapuuid);
> +				if (tst->ss->write_bitmap(tst, dfd, UUIDUpdate))
>  					pr_err("Could not update uuid on external bitmap.\n");
>  				else
>  					bitmap_done = 1;
> diff --git a/bitmap.c b/bitmap.c
> index d21e5cc..575fcb9 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -457,23 +457,3 @@ out:
>  		unlink(filename); /* possibly corrupted, better get rid of it */
>  	return rv;
>  }
> -
> -int bitmap_update_uuid(int fd, int *uuid, int swap)
> -{
> -	struct bitmap_super_s bm;
> -	if (lseek(fd, 0, 0) != 0)
> -		return 1;
> -	if (read(fd, &bm, sizeof(bm)) != sizeof(bm))
> -		return 1;
> -	if (bm.magic != __cpu_to_le32(BITMAP_MAGIC))
> -		return 1;
> -	copy_uuid(bm.uuid, uuid, swap);
> -	if (lseek(fd, 0, 0) != 0)
> -		return 2;
> -	if (write(fd, &bm, sizeof(bm)) != sizeof(bm)) {
> -		lseek(fd, 0, 0);
> -		return 2;
> -	}
> -	lseek(fd, 0, 0);
> -	return 0;
> -}
> diff --git a/mdadm.h b/mdadm.h
> index 97892e6..7b9bb28 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -358,6 +358,7 @@ enum bitmap_update {
>      NoUpdate,
>      NameUpdate,
>      NodeNumUpdate,
> +    UUIDUpdate,
>  };
>  
>  /* structures read from config file */
> @@ -1273,7 +1274,6 @@ extern int CreateBitmap(char *filename, int force, char uuid[16],
>  			int major);
>  extern int ExamineBitmap(char *filename, int brief, struct supertype *st);
>  extern int Write_rules(char *rule_name);
> -extern int bitmap_update_uuid(int fd, int *uuid, int swap);
>  extern unsigned long bitmap_sectors(struct bitmap_super_s *bsb);
>  extern int Dump_metadata(char *dev, char *dir, struct context *c,
>  			 struct supertype *st);
> diff --git a/super0.c b/super0.c
> index 6ad9d39..49267d1 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -1180,12 +1180,23 @@ static int write_bitmap0(struct supertype *st, int fd, enum bitmap_update update
>  	unsigned long long dsize;
>  	unsigned long long offset;
>  	mdp_super_t *sb = st->sb;
> +	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MD_SB_BYTES);
>  
>  	int rv = 0;
>  
>  	int towrite, n;
>  	void *buf;
>  
> +	switch (update) {
> +	case UUIDUpdate:
> +		memset((char *)bms->uuid, 0, sizeof(bms->uuid));
> +		strncpy((char *)bms->uuid, (char *)st->devs->uuid, sizeof(bms->uuid));
> +		break;
> +	case NoUpdate:
> +	default:
> +		break;
> +	}
> +
>  	if (!get_dev_size(fd, NULL, &dsize))
>  		return 1;
>  
> diff --git a/super1.c b/super1.c
> index 8128750..4ce7773 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2232,6 +2232,10 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
>  
>  		bms->nodes = __cpu_to_le32(st->nodes);
>  		break;
> +	case UUIDUpdate:
> +		memset((char *)bms->uuid, 0, sizeof(bms->uuid));
> +		strncpy((char *)bms->uuid, (char *)st->devs->uuid, sizeof(bms->uuid));
> +		break;
>  	case NoUpdate:
>  	default:
>  		break;

