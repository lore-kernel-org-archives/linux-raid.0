Received: from sg-1-34.ptr.blmpb.com (sg-1-34.ptr.blmpb.com [118.26.132.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D03E25783A
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 02:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772591558; cv=none; b=ne0G+rArjWAox0GUPwhJoWdPFnUyCTt7iXxpIjBhEgyDqNk15/JfW3jqi4O8CjoVjO2RqWqkr2I/NJ/lmV4IPXErZ8Drxjl3+49QGE/f3tK/UQhRN5LiIP1Edlna5Z0AMUUmzf0LnLXmS7y4HjZsCBCx2tm91DFUxuMD5M4tGsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772591558; c=relaxed/simple;
	bh=1Yus1EKPRcQRQrJLV9X8EnX0k6MjeJ8INzkMHb2NQxY=;
	h=Cc:To:Mime-Version:Subject:Message-Id:References:In-Reply-To:From:
	 Date:Content-Type; b=maE4ZhgDeJ4V3C3XL4Jav5XOSz8eVcrdfsGTNQnQNoL/2DhCk/c5ax1KMNE3tR+WdSgyYoNyQwyh7+hmrwwthKqWqBebBf7JoZw6GjW5f4eTV+UjF+zEQeEAe6l/RW9khyp2RrZO+3narZhRLiZ3lalCCMOEZE4ppwZfDocH5oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ybE14KSx; arc=none smtp.client-ip=118.26.132.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ybE14KSx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772591425;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=SVZMs5e/ZXV76gO9TONqSZL+5lKEyDSPo7l71ONjg/4=;
 b=ybE14KSxlOeyYnZ7deNLWhCXbN0b/u6xtwVj/+X1Hy2C18dzYjvqvBFGxQ0xcz9hE7zkPW
 z6fold4TPW3uo4p/QQqMm4GWZPSrpx5w0DnIjF4BzI2V71mHCkr9803res3UIylab4yUE/
 7jssys1iLfKwiMaYdwr8k/WnGzBwMWSh4Zypc9B/5/9hR8zDAcUrIXXx4KQbpBK8tLFqYl
 T8L13i7VTNVjLrL4dqKRTWOLdWPjOYjWIDArRmT1RCPZ7fpkzq4qjItKPWcpD9rDgwQHN5
 FzMaO7y7pSGxijaN/dy7Fu40CDqjDFGVEqp5vgOZEu5uX7Hj3Lc5jb8sCFmyiA==
Cc: <song@kernel.org>, <xni@redhat.com>, <linan122@huawei.com>, 
	<heming.zhao@suse.com>, <l@damenly.org>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.182]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 10:30:22 +0800
To: "Su Yue" <glass.su@suse.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
Subject: Re: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap offset while growing
User-Agent: Mozilla Thunderbird
Message-Id: <20fcd6f0-b27d-49aa-8064-79f58f109d5d@fnnas.com>
References: <20260303033731.83885-1-glass.su@suse.com> <20260303033731.83885-2-glass.su@suse.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269a7993f+b6e7e3+vger.kernel.org+yukuai@fnnas.com>
In-Reply-To: <20260303033731.83885-2-glass.su@suse.com>
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Wed, 4 Mar 2026 10:30:20 +0800
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/3/3 11:37, Su Yue =E5=86=99=E9=81=93:
> Before commit fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_o=
ps until creating bitmap")
> if CONFIG_MD_BITMAP is enabled, both bitmap none, internal and clustered =
have
> the sysfs file bitmap/location.
>
> After the commit, if bitmap is none, bitmap/location doesn't exist anymor=
e.
> It breaks 'grow' behavior of a md array of madam with MD_FEATURE_BITMAP_O=
FFSET.
> Take level=3Dmirror and metadata=3D1.2 as an example:
>
> $ mdadm  --create  /dev/md0 -f --bitmap=3Dnone --raid-devices=3D2 --level=
=3Dmirror \
>    --metadata=3D1.2 /dev/vdd /dev/vde
> $ mdadm --grow /dev/md0 --bitmap=3Dinternal
> $ cat /sys/block/md0/md/bitmap/location
> Before:+8
> After: +2
>
> While growing bitmap from none to internal, clustered and llbitmap,
> mdadm/Grow.c:Grow_addbitmap() tries to detect bitmap/location first.
> 1)If bitmap/location exists, it sets bitmap/location after getinfo_super(=
).
> 2)If bitmap/location doesn't exist, mdadm just calls md_set_array_info() =
then
> mddev->bitmap_info.default_offset will be used.
> Situation can be worse if growing none to clustered, bitmap offset of the=
 node
> calling `madm --grow` will be changed but the other node are reading bitm=
ap sb from
> the old location.

Now that we have a new sysfs attribute bitmap_type, can we fix this by:
- in the kernel, allow writing to this file in this case;
- in mdadm and the grow case above, write to this file first, and change
bitmap_type from none to bitmap(For llbitmap, there is still more work to d=
o).

>
> Here restore sysfs file bitmap/location for ID_BITMAP_NONE and ID_BITMAP.
> And it d adds the entry for llbitmap too.
>
> New attribute_group md_bitmap_common_group is introduced and created in
> md_alloc() as before commit fb8cc3b0d9db.
> Add New operations register_group and unregister_group to struct bitmap_o=
perations.
>
> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops unti=
l creating bitmap")
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>   drivers/md/md-bitmap.c   | 32 +++++++++++++++++++++++++++++++-
>   drivers/md/md-bitmap.h   |  5 +++++
>   drivers/md/md-llbitmap.c | 13 +++++++++++++
>   drivers/md/md.c          | 16 ++++++++++++----
>   4 files changed, 61 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 83378c033c72..8ff1dc94ed78 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2956,7 +2956,6 @@ __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
>          behind_writes_used_show, behind_writes_used_reset);
>  =20
>   static struct attribute *md_bitmap_attrs[] =3D {
> -	&bitmap_location.attr,
>   	&bitmap_space.attr,
>   	&bitmap_timeout.attr,
>   	&bitmap_backlog.attr,
> @@ -2967,11 +2966,40 @@ static struct attribute *md_bitmap_attrs[] =3D {
>   	NULL
>   };
>  =20
> +static struct attribute *md_bitmap_common_attrs[] =3D {
> +	&bitmap_location.attr,
> +	NULL
> +};
> +
>   static struct attribute_group md_bitmap_group =3D {
>   	.name =3D "bitmap",
>   	.attrs =3D md_bitmap_attrs,
>   };
>  =20
> +static struct attribute_group md_bitmap_common_group =3D {
> +	.name =3D "bitmap",
> +	.attrs =3D md_bitmap_common_attrs,
> +};
> +
> +int md_sysfs_create_common_group(struct mddev *mddev)
> +{
> +	return sysfs_create_group(&mddev->kobj, &md_bitmap_common_group);
> +}
> +
> +static int bitmap_register_group(struct mddev *mddev)
> +{
> +	/*
> +	 * md_bitmap_group and md_bitmap_common_group are using same name
> +	 * 'bitmap'.
> +	 */
> +	return sysfs_merge_group(&mddev->kobj, &md_bitmap_group);
> +}
> +
> +static void bitmap_unregister_group(struct mddev *mddev)
> +{
> +	sysfs_unmerge_group(&mddev->kobj, &md_bitmap_group);
> +}
> +
>   static struct bitmap_operations bitmap_ops =3D {
>   	.head =3D {
>   		.type	=3D MD_BITMAP,
> @@ -3013,6 +3041,8 @@ static struct bitmap_operations bitmap_ops =3D {
>   	.set_pages		=3D bitmap_set_pages,
>   	.free			=3D md_bitmap_free,
>  =20
> +	.register_group		=3D bitmap_register_group,
> +	.unregister_group	=3D bitmap_unregister_group,
>   	.group			=3D &md_bitmap_group,
>   };
>  =20
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index b42a28fa83a0..371791e9011d 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -125,6 +125,9 @@ struct bitmap_operations {
>   	void (*set_pages)(void *data, unsigned long pages);
>   	void (*free)(void *data);
>  =20
> +	int (*register_group)(struct mddev *mddev);
> +	void (*unregister_group)(struct mddev *mddev);
> +
>   	struct attribute_group *group;
>   };
>  =20
> @@ -169,6 +172,8 @@ static inline void md_bitmap_end_sync(struct mddev *m=
ddev, sector_t offset,
>   	mddev->bitmap_ops->end_sync(mddev, offset, blocks);
>   }
>  =20
> +int md_sysfs_create_common_group(struct mddev *mddev);
> +
>   #ifdef CONFIG_MD_BITMAP
>   int md_bitmap_init(void);
>   void md_bitmap_exit(void);
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index bf398d7476b3..24ff5f7f8751 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1561,6 +1561,16 @@ static struct attribute_group md_llbitmap_group =
=3D {
>   	.attrs =3D md_llbitmap_attrs,
>   };
>  =20
> +static int llbitmap_register_group(struct mddev *mddev)
> +{
> +	return sysfs_create_group(&mddev->kobj, &md_llbitmap_group);
> +}
> +
> +static void llbitmap_unregister_group(struct mddev *mddev)
> +{
> +	sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
> +}
> +
>   static struct bitmap_operations llbitmap_ops =3D {
>   	.head =3D {
>   		.type	=3D MD_BITMAP,
> @@ -1597,6 +1607,9 @@ static struct bitmap_operations llbitmap_ops =3D {
>   	.dirty_bits		=3D llbitmap_dirty_bits,
>   	.write_all		=3D llbitmap_write_all,
>  =20
> +	.register_group		=3D llbitmap_register_group,
> +	.unregister_group	=3D llbitmap_unregister_group,
> +
>   	.group			=3D &md_llbitmap_group,
>   };
>  =20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e..ab969e950ea8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -703,8 +703,8 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   	mddev->bitmap_ops =3D (void *)head;
>   	xa_unlock(&md_submodule);
>  =20
> -	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
> -		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
> +	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->register_group) {
> +		if (mddev->bitmap_ops->register_group(mddev))
>   			pr_warn("md: cannot register extra bitmap attributes for %s\n",
>   				mdname(mddev));
>   		else
> @@ -724,8 +724,8 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
>   {
>   	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
> -	    mddev->bitmap_ops->group)
> -		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
> +	    mddev->bitmap_ops->unregister_group)
> +		mddev->bitmap_ops->unregister_group(mddev);
>  =20
>   	mddev->bitmap_ops =3D NULL;
>   }
> @@ -6369,6 +6369,14 @@ struct mddev *md_alloc(dev_t dev, char *name)
>   		return ERR_PTR(error);
>   	}
>  =20
> +	/*
> +	 * md_sysfs_remove_common_group is not needed because mddev_delayed_del=
ete
> +	 * calls kobject_put(&mddev->kobj) if mddev is to be deleted.
> +	 */
> +	if (md_sysfs_create_common_group(mddev))
> +		pr_warn("md: cannot register common bitmap attributes for %s\n",
> +			mdname(mddev));
> +
>   	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>   	mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, "array_st=
ate");
>   	mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, "level");

--=20
Thansk,
Kuai
