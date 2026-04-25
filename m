Received: from mail-108-mta59.mxroute.com (mail-108-mta59.mxroute.com [136.175.108.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9411EA7CE
	for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 08:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777106173; cv=none; b=kpUHeZ/ORzOFiEsszc+YOF3WIfglnFa2a+exDf8CnzQ1FekF/8zqvEzRgcmAPRgYkLRMV4iOB++U2y9VEcyn4LdWa+9owXa7ob9YIXVJ9q+OqRYL6AiftixQk1B2DAVFUxcT6H7zs74FoER0Vj/R3/uI+mqwkmCipdjVKmbMFGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777106173; c=relaxed/simple;
	bh=1/TNskuyJGcPbvxitzxVW3lzZ5q30h4cIMbECV1vbKo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HXMgBd5U97k9d/qlp3nmlLrl6D1rnCtLpX1iNhboRMlE8Gbha/J2QCqACIB53q8j7bM5sH4NwG3Lcl9tRUbYlCyKrHJ+zq7Bc/UZH7xlOqJDlFik00lUSNp+PjtNTMSHnL+HGePzjJ0ojc3dRxH8fu7igDN0uMa11fTgPKwpZZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=oidl0mE1; arc=none smtp.client-ip=136.175.108.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="oidl0mE1"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta59.mxroute.com (ZoneMTA) with ESMTPSA id 19dc3c3762100067f7.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sat, 25 Apr 2026 08:31:00 +0000
X-Zone-Loop: 3102a580545f1d4c3dc7d28549e24e1056e530d96968
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AGwxGV38P7J6uK6cFXbWbABZUjtMG92aVMWcfvf7bUg=; b=oidl0mE1hBiziyOT5ZGhKkwXZX
	IucA4YTSMPo+2RYtqUKLzOnoZe5C7LqWbeEF9D1QrkwBX4Z/dU1guWQ2ZoyO0Yg8VYjBfKRfTZElt
	JVywqZ3cqF54o3n5uT7dehSBHmPDOrUpUKyKjIAequPqSsyCPoH4a52trxyhZyIlNs3huYQNnCiN2
	xWmvxoSUjDNiNk2j3OAZGVl8vuR8tvgNr1hx05Ixr9rlZ72mHeYFFsHtczmZVnjGpKq6uVhgaTQlm
	bkfcY518G60bh02xsWGOpzO1inTCwDVMLLHt4ysOkwCwZd+xw+RfiZhbEl2IifBwE6eHKMj1GkX0i
	fp/6mdrw==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Song Liu <song@kernel.org>,  glass.su@suse.com,  Li Nan
 <linan122@huawei.com>,  Xiao Ni <xiao@kernel.org>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 1/3] md: factor bitmap creation away from sysfs
 handling
In-Reply-To: <20260425024615.1696892-2-yukuai@fnnas.com> (Yu Kuai's message of
	"Sat, 25 Apr 2026 10:46:13 +0800")
References: <20260425024615.1696892-1-yukuai@fnnas.com>
	<20260425024615.1696892-2-yukuai@fnnas.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Sat, 25 Apr 2026 16:30:46 +0800
Message-ID: <jytv787d.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Sat 25 Apr 2026 at 10:46, Yu Kuai <yukuai@fnnas.com> wrote:

> Factor bitmap creation and destruction into helpers that do not 
> touch
> bitmap sysfs registration.
>
> This prepares the bitmap sysfs rework so callers such as the 
> sysfs
> bitmap location path can create or destroy a bitmap backend 
> without
> coupling that to sysfs group lifetime management.
>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>
Reviewed-by: Su Yue <glass.su@suse.com>

> ---
>  drivers/md/md.c | 78 
>  +++++++++++++++++++++++++++++++------------------
>  1 file changed, 49 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ebaf47fb9de6..99aa1367c991 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -679,7 +679,25 @@ static void active_io_release(struct 
> percpu_ref *ref)
>
>  static void no_op(struct percpu_ref *r) {}
>
> -static bool mddev_set_bitmap_ops(struct mddev *mddev)
> +static void md_bitmap_sysfs_add(struct mddev *mddev)
> +{
> +	if (sysfs_create_group(&mddev->kobj, 
> mddev->bitmap_ops->group))
> +		pr_warn("md: cannot register extra bitmap attributes for 
> %s\n",
> +			mdname(mddev));
> +	else
> +		/*
> +		 * Inform user with KOBJ_CHANGE about new bitmap
> +		 * attributes.
> +		 */
> +		kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
> +}
> +
> +static void md_bitmap_sysfs_del(struct mddev *mddev)
> +{
> +	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
> +}
> +
> +static bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
>  {
>  	struct bitmap_operations *old = mddev->bitmap_ops;
>  	struct md_submodule_head *head;
> @@ -703,18 +721,6 @@ static bool mddev_set_bitmap_ops(struct 
> mddev *mddev)
>
>  	mddev->bitmap_ops = (void *)head;
>  	xa_unlock(&md_submodule);
> -
> -	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
> -		if (sysfs_create_group(&mddev->kobj, 
> mddev->bitmap_ops->group))
> -			pr_warn("md: cannot register extra bitmap attributes 
> for %s\n",
> -				mdname(mddev));
> -		else
> -			/*
> -			 * Inform user with KOBJ_CHANGE about new bitmap
> -			 * attributes.
> -			 */
> -			kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
> -	}
>  	return true;
>
>  err:
> @@ -722,15 +728,6 @@ static bool mddev_set_bitmap_ops(struct 
> mddev *mddev)
>  	return false;
>  }
>
> -static void mddev_clear_bitmap_ops(struct mddev *mddev)
> -{
> -	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
> -	    mddev->bitmap_ops->group)
> -		sysfs_remove_group(&mddev->kobj, 
> mddev->bitmap_ops->group);
> -
> -	mddev->bitmap_ops = NULL;
> -}
> -
>  int mddev_init(struct mddev *mddev)
>  {
>  	int err = 0;
> @@ -6531,7 +6528,7 @@ static enum md_submodule_id 
> md_bitmap_get_id_from_sb(struct mddev *mddev)
>  	return id;
>  }
>
> -static int md_bitmap_create(struct mddev *mddev)
> +static int md_bitmap_create_nosysfs(struct mddev *mddev)
>  {
>  	enum md_submodule_id orig_id = mddev->bitmap_id;
>  	enum md_submodule_id sb_id;
> @@ -6540,7 +6537,7 @@ static int md_bitmap_create(struct mddev 
> *mddev)
>  	if (mddev->bitmap_id == ID_BITMAP_NONE)
>  		return -EINVAL;
>
> -	if (!mddev_set_bitmap_ops(mddev))
> +	if (!mddev_set_bitmap_ops_nosysfs(mddev))
>  		return -ENOENT;
>
>  	err = mddev->bitmap_ops->create(mddev);
> @@ -6552,7 +6549,7 @@ static int md_bitmap_create(struct mddev 
> *mddev)
>  	 * doesn't match, and mdadm is not the latest version to set
>  	 * bitmap_type, set bitmap_ops based on the disk version.
>  	 */
> -	mddev_clear_bitmap_ops(mddev);
> +	mddev->bitmap_ops = NULL;
>
>  	sb_id = md_bitmap_get_id_from_sb(mddev);
>  	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
> @@ -6562,27 +6559,50 @@ static int md_bitmap_create(struct mddev 
> *mddev)
>  		mdname(mddev), orig_id, sb_id);
>
>  	mddev->bitmap_id = sb_id;
> -	if (!mddev_set_bitmap_ops(mddev)) {
> +	if (!mddev_set_bitmap_ops_nosysfs(mddev)) {
>  		mddev->bitmap_id = orig_id;
>  		return -ENOENT;
>  	}
>
>  	err = mddev->bitmap_ops->create(mddev);
>  	if (err) {
> -		mddev_clear_bitmap_ops(mddev);
> +		mddev->bitmap_ops = NULL;
>  		mddev->bitmap_id = orig_id;
>  	}
>
>  	return err;
>  }
>
> -static void md_bitmap_destroy(struct mddev *mddev)
> +static int md_bitmap_create(struct mddev *mddev)
> +{
> +	int err;
> +
> +	err = md_bitmap_create_nosysfs(mddev);
> +	if (err)
> +		return err;
> +
> +	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group)
> +		md_bitmap_sysfs_add(mddev);
> +
> +	return 0;
> +}
> +
> +static void md_bitmap_destroy_nosysfs(struct mddev *mddev)
>  {
>  	if (!md_bitmap_registered(mddev))
>  		return;
>
>  	mddev->bitmap_ops->destroy(mddev);
> -	mddev_clear_bitmap_ops(mddev);
> +	mddev->bitmap_ops = NULL;
> +}
> +
> +static void md_bitmap_destroy(struct mddev *mddev)
> +{
> +	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
> +	    mddev->bitmap_ops->group)
> +		md_bitmap_sysfs_del(mddev);
> +
> +	md_bitmap_destroy_nosysfs(mddev);
>  }
>
>  int md_run(struct mddev *mddev)
