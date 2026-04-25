Received: from mail-108-mta23.mxroute.com (mail-108-mta23.mxroute.com [136.175.108.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E3C35A384
	for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 08:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777106532; cv=none; b=ZyEAEkd4kSv5c6QA6lIS9u92TKAJdAwvwt25SUb1F288wXElgb022F+p+tl8BaW8raV3DSS5PkM7Egdx2ebS1QOR97Q5geHCIzoxaCSD9mxYr74vn9ni2psZWg8Q/9h29TbePP8XztiJYjAk8qiqcNeiYuQYCHXSOE/mn6DGFF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777106532; c=relaxed/simple;
	bh=ZtO0dnVnSVpoZteHtGcq7qw15KNSN0V5tiFp7/uGLRY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YY8LTfAljcSxJilnY2X2A/wyvcwR+r4+IYd4LusMAL3tKUIuxErxhmgS21ku5+SHYxHDt+IfV7/AwAL1vK78EretFfj5o8sHFP48u9cAD6B4b23wLRqltebFrEbj1RGuBnXrI+5WWz4Uf+yMqfE5EybFSqZ2l26gCWLtzW4x4vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=szj0byck; arc=none smtp.client-ip=136.175.108.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="szj0byck"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta23.mxroute.com (ZoneMTA) with ESMTPSA id 19dc3c8e20e00067f7.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sat, 25 Apr 2026 08:36:55 +0000
X-Zone-Loop: 7664c527ce2c703e365c3c0f7de001090c99a33170a3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FDqi+lenkBcuGyWfH80GutHjg0GFF70Q9jfhyCEP5x8=; b=szj0byck5DLDJzmLmVb7nV9u/j
	aVBAKEjc/VVufWVxT1W67FJeisWZHRhEGTJpr/OQvkv3XtMTCTadf97SiEboBdSCzTQ5rpLGBfXWI
	u98Nf9d3g1G0M7Evw7jkK1BRA0xyTLULBydlLR2dju9kgFBYIeQGXs/KaieW2ZSpL817XWirqk0N5
	3t8uVD8pwEBoVNR+xLIVqoeYP1UeIt/ge7xNnyyLoVaQ7jvnIuTYjQxhhAzRwM9fqQ8Ka+UVveRJu
	4Zunn0q+uWfl1y3I7u9ojjq3GSsWXuXrE9kvcL7RNKsAXpeCv84KYc8E74cIgWGGRiVhGCmyCSn6H
	cIrbouNQ==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Song Liu <song@kernel.org>,  glass.su@suse.com,  Li Nan
 <linan122@huawei.com>,  Xiao Ni <xiao@kernel.org>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 2/3] md/md-bitmap: split bitmap sysfs groups
In-Reply-To: <20260425024615.1696892-3-yukuai@fnnas.com> (Yu Kuai's message of
	"Sat, 25 Apr 2026 10:46:14 +0800")
References: <20260425024615.1696892-1-yukuai@fnnas.com>
	<20260425024615.1696892-3-yukuai@fnnas.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Sat, 25 Apr 2026 16:36:42 +0800
Message-ID: <eck377xh.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Sat 25 Apr 2026 at 10:46, Yu Kuai <yukuai@fnnas.com> wrote:

> Split the classic bitmap sysfs files into a common bitmap group 
> with
> the location attribute and a separate internal bitmap group for 
> the
> remaining files.
>
> At the same time, convert bitmap operations from a single sysfs 
> group
> to a sysfs group array so backends can share part of their sysfs
> layout while adding backend-specific attributes separately.
>
> Switch the bitmap sysfs helpers to use sysfs_update_groups() for 
> the
> add and update path, and remove groups in reverse order so 
> shared named
> groups are unmerged before the last group removes the directory.
>
> Also make bitmap operation lookup depend only on the currently 
> selected
> bitmap id matching the installed backend. This prepares the 
> lookup path
> for a later registered none backend.
>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md-bitmap.c   | 23 +++++++++++++++++++----
>  drivers/md/md-bitmap.h   |  2 +-
>  drivers/md/md-llbitmap.c |  7 ++++++-
>  drivers/md/md.c          | 21 ++++++++++++++-------
>  4 files changed, 40 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 83378c033c72..eba649703a1c 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2955,8 +2955,12 @@ static struct md_sysfs_entry 
> max_backlog_used =
>  __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
>         behind_writes_used_show, behind_writes_used_reset);
>
> -static struct attribute *md_bitmap_attrs[] = {
> +static struct attribute *md_bitmap_common_attrs[] = {
>  	&bitmap_location.attr,
> +	NULL
> +};
> +
> +static struct attribute *md_bitmap_internal_attrs[] = {
>  	&bitmap_space.attr,
>  	&bitmap_timeout.attr,
>  	&bitmap_backlog.attr,
> @@ -2967,9 +2971,20 @@ static struct attribute 
> *md_bitmap_attrs[] = {
>  	NULL
>  };
>
> -static struct attribute_group md_bitmap_group = {
> +static struct attribute_group md_bitmap_common_group = {
> +	.name = "bitmap",
> +	.attrs = md_bitmap_common_attrs,
> +};
> +
> +static struct attribute_group md_bitmap_internal_group = {
>  	.name = "bitmap",
> -	.attrs = md_bitmap_attrs,
> +	.attrs = md_bitmap_internal_attrs,
> +};
> +
> +static const struct attribute_group *bitmap_groups[] = {
> +	&md_bitmap_common_group,
> +	&md_bitmap_internal_group,
> +	NULL,
>  };
>
>  static struct bitmap_operations bitmap_ops = {
> @@ -3013,7 +3028,7 @@ static struct bitmap_operations bitmap_ops 
> = {
>  	.set_pages		= bitmap_set_pages,
>  	.free			= md_bitmap_free,
>
> -	.group			= &md_bitmap_group,
> +	.groups			= bitmap_groups,
>  };
>
>  int md_bitmap_init(void)
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index b42a28fa83a0..214f623c7e79 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -125,7 +125,7 @@ struct bitmap_operations {
>  	void (*set_pages)(void *data, unsigned long pages);
>  	void (*free)(void *data);
>
> -	struct attribute_group *group;
> +	const struct attribute_group **groups;
>  };
>
>  /* the bitmap API */
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 9e7e6b1a6f15..1adc5b117821 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1738,6 +1738,11 @@ static struct attribute_group 
> md_llbitmap_group = {
>  	.attrs = md_llbitmap_attrs,
>  };
>
> +static const struct attribute_group *md_llbitmap_groups[] = {
> +	&md_llbitmap_group,
> +	NULL,
> +};
> +
>  static struct bitmap_operations llbitmap_ops = {
>  	.head = {
>  		.type	= MD_BITMAP,
> @@ -1774,7 +1779,7 @@ static struct bitmap_operations 
> llbitmap_ops = {
>  	.dirty_bits		= llbitmap_dirty_bits,
>  	.write_all		= llbitmap_write_all,
>
> -	.group			= &md_llbitmap_group,
> +	.groups			= md_llbitmap_groups,
>  };
>
>  int md_llbitmap_init(void)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 99aa1367c991..0ef81d116191 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -681,7 +681,7 @@ static void no_op(struct percpu_ref *r) {}
>
>  static void md_bitmap_sysfs_add(struct mddev *mddev)
>  {
> -	if (sysfs_create_group(&mddev->kobj, 
> mddev->bitmap_ops->group))
> +	if (sysfs_update_groups(&mddev->kobj, 
> mddev->bitmap_ops->groups))
>  		pr_warn("md: cannot register extra bitmap attributes for 
>  %s\n",
>  			mdname(mddev));
>  	else
> @@ -694,16 +694,23 @@ static void md_bitmap_sysfs_add(struct 
> mddev *mddev)
>
>  static void md_bitmap_sysfs_del(struct mddev *mddev)
>  {
> -	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
> +	int nr_groups = 0;
> +
> +	for (nr_groups = 0; mddev->bitmap_ops->groups[nr_groups]; 
> nr_groups++)
> +		;
> +
> +	while (--nr_groups >= 1)
> +		sysfs_unmerge_group(&mddev->kobj,
> +				    mddev->bitmap_ops->groups[nr_groups]);
>
Amazing magic here!

Reviewed-by: Su Yue <glass.su@suse.com>

> +	sysfs_remove_group(&mddev->kobj, 
> mddev->bitmap_ops->groups[0]);
>  }
>
>  static bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
>  {
> -	struct bitmap_operations *old = mddev->bitmap_ops;
>  	struct md_submodule_head *head;
>
> -	if (mddev->bitmap_id == ID_BITMAP_NONE ||
> -	    (old && old->head.id == mddev->bitmap_id))
> +	if (mddev->bitmap_ops &&
> +	    mddev->bitmap_ops->head.id == mddev->bitmap_id)
>  		return true;
>
>  	xa_lock(&md_submodule);
> @@ -6581,7 +6588,7 @@ static int md_bitmap_create(struct mddev 
> *mddev)
>  	if (err)
>  		return err;
>
> -	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group)
> +	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->groups)
>  		md_bitmap_sysfs_add(mddev);
>
>  	return 0;
> @@ -6599,7 +6606,7 @@ static void 
> md_bitmap_destroy_nosysfs(struct mddev *mddev)
>  static void md_bitmap_destroy(struct mddev *mddev)
>  {
>  	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
> -	    mddev->bitmap_ops->group)
> +	    mddev->bitmap_ops->groups)
>  		md_bitmap_sysfs_del(mddev);
>
>  	md_bitmap_destroy_nosysfs(mddev);
