From: Guoqing Jiang <GQJiang@suse.com>
Subject: Re: [PATCH 4/4] md-cluster: re-add
Date: Fri, 10 Apr 2015 17:43:02 +0800
Message-ID: <55279B26.1090402@suse.com>
References: <20150408192414.GA9693@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150408192414.GA9693@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Goldwyn,
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index d036c83..afffbee 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -50,6 +50,7 @@ struct md_cluster_info {
>  	/* dlm lock space and resources for clustered raid. */
>  	dlm_lockspace_t *lockspace;
>  	int slot_number;
> +	int total_slots;
>   
There are two "nodes"  in bitmap_info and bitmap_super_t, is it possible
to use
the existed nodes? Instead of introduce a new member in md_cluster_info.

drivers/md/bitmap.c:440:    sb->nodes =
cpu_to_le32(bitmap->mddev->bitmap_info.nodes);
drivers/md/bitmap.c:552:    int nodes = 0;
drivers/md/bitmap.c:610:    nodes = le32_to_cpu(sb->nodes);
drivers/md/bitmap.c:688:    bitmap->mddev->bitmap_info.nodes = nodes;
> @@ -653,6 +671,7 @@ static int join(struct mddev *mddev, int nodes)
>  		ret = -ERANGE;
>  		goto err;
>  	}
> +	cinfo->total_slots = nodes;
>   
The nodes is got from "nodes = le32_to_cpu(sb->nodes);", right?
>  	cinfo->sb_lock = lockres_init(mddev, "cmd-super",
>  					NULL, 0);
>  	if (!cinfo->sb_lock) {
> @@ -900,6 +919,34 @@ static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>  	return __sendmsg(cinfo, &cmsg);
>  }
>  
> +static int gather_bitmaps(struct md_rdev *rdev)
> +{
> +	int sn, err;
> +	sector_t lo, hi;
> +	struct cluster_msg cmsg;
> +	struct mddev *mddev = rdev->mddev;
> +	struct md_cluster_info *cinfo = mddev->cluster_info;
> +	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
> +	char *uuid = sb->device_uuid;
> +
> +	for (sn = 0; sn < cinfo->total_slots; sn++) {
>   
The last place which used total_slots.

Thanks,
Guoqing
