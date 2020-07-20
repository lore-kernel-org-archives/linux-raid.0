From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V1 2/3] extend r10bio devs to raid disks
Date: Mon, 20 Jul 2020 13:15:15 +0800
Message-ID: <eeb6faad-cb05-b831-0108-6222f122d7d3@suse.de>
References: <1595221108-10137-1-git-send-email-xni@redhat.com>
 <1595221108-10137-3-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595221108-10137-3-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, heinzm@redhat.com
List-Id: linux-raid.ids

On 2020/7/20 12:58, Xiao Ni wrote:
> Now it allocs r10bio->devs[conf->copies]. Discard bio needs to submit to all member disks
> and it needs to use r10bio. So extend to r10bio->devs[geo.raid_disks].
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>

Reviewed-by: Coly Li <colyli@suse.de>



Coly Li


> ---
>  drivers/md/raid10.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e45fd56..2a7423e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -91,7 +91,7 @@ static inline struct r10bio *get_resync_r10bio(struct bio *bio)
>  static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
>  {
>  	struct r10conf *conf = data;
> -	int size = offsetof(struct r10bio, devs[conf->copies]);
> +	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
>  
>  	/* allocate a r10bio with room for raid_disks entries in the
>  	 * bios array */
> @@ -238,7 +238,7 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
>  {
>  	int i;
>  
> -	for (i = 0; i < conf->copies; i++) {
> +	for (i = 0; i < conf->geo.raid_disks; i++) {
>  		struct bio **bio = & r10_bio->devs[i].bio;
>  		if (!BIO_SPECIAL(*bio))
>  			bio_put(*bio);
> @@ -327,7 +327,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
>  	int slot;
>  	int repl = 0;
>  
> -	for (slot = 0; slot < conf->copies; slot++) {
> +	for (slot = 0; slot < conf->geo.raid_disks; slot++) {
>  		if (r10_bio->devs[slot].bio == bio)
>  			break;
>  		if (r10_bio->devs[slot].repl_bio == bio) {
> @@ -336,7 +336,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
>  		}
>  	}
>  
> -	BUG_ON(slot == conf->copies);
> +	BUG_ON(slot == conf->geo.raid_disks);
>  	update_head_pos(slot, r10_bio);
>  
>  	if (slotp)
> @@ -1510,7 +1510,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
>  	r10_bio->mddev = mddev;
>  	r10_bio->sector = bio->bi_iter.bi_sector;
>  	r10_bio->state = 0;
> -	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
> +	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->geo.raid_disks);
>  
>  	if (bio_data_dir(bio) == READ)
>  		raid10_read_request(mddev, bio, r10_bio);
> 
