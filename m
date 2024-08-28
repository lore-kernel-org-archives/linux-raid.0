Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E62142E83
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 05:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724822395; cv=none; b=WjkK/7ImUH5EvYaFMJNe0Z3qnKkoTAywK6Ui3Lz4hfi/sNqflqdsZki4lf4cw2mCPrzsvGCA/368UtkrMt884h+Z8TCTQIrZX6USb2ln5UIOCk//Pp13lQRGedLm2Tp+YQx9cSJJz8qyviwexanZ1YU74NHdF7aBzaFhiiUr7eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724822395; c=relaxed/simple;
	bh=hvZIkpKxBs2BvMGyIO77J4u0GaJLsVe06W4Rg83cepQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3HqF94NtyySh1hLgB7aU56XoGYJuw/2HriAEIeFHYMHyXvI24oZ5v663f0wUVujglmZxdPRQH61C5/Ltc+5JcqetLqQl/5Ik6CFrbMXPf33OtwvflOv5EB5kzyKNOAhuyKB3wXosb3XiXLpu4GQ7jeK+HA+PLb25r0zmmpJLGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.3] (ip5f5af189.dynamic.kabel-deutschland.de [95.90.241.137])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6322C61E64862;
	Wed, 28 Aug 2024 07:19:15 +0200 (CEST)
Message-ID: <810d6b9b-b2fd-4480-a455-413d57a52738@molgen.mpg.de>
Date: Wed, 28 Aug 2024 07:19:14 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.12 1/1] md: add new_level sysfs interface
To: Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, yukuai1@huaweicloud.com
References: <20240828021828.63447-1-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240828021828.63447-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xiao,


Thank you for your patch.

Am 28.08.24 um 04:18 schrieb Xiao Ni:
> This interface is used to updating new level during reshape progress.

to update

> Now it doesn't update new level during reshape. So it can't know the
> new level when systemd service mdadm-grow-continue runs. And it can't
> finally change to new level.

How can this be tested?

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3a837506a36..c639eca03df9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>   static struct md_sysfs_entry md_level =
>   __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
>   
> +static ssize_t
> +new_level_show(struct mddev *mddev, char *page)
> +{
> +	return sprintf(page, "%d\n", mddev->new_level);
> +}
> +
> +static ssize_t
> +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +	unsigned int n;
> +	int err;
> +
> +	err = kstrtouint(buf, 10, &n);
> +	if (err < 0)
> +		return err;
> +	err = mddev_lock(mddev);
> +	if (err)
> +		return err;
> +
> +	mddev->new_level = n;
> +	md_update_sb(mddev, 1);
> +
> +	mddev_unlock(mddev);
> +	return err ?: len;

Can `err` be set? Why return `len` if it’s not modified?

> +}
> +static struct md_sysfs_entry md_new_level =
> +__ATTR(new_level, 0664, new_level_show, new_level_store);
> +
>   static ssize_t
>   layout_show(struct mddev *mddev, char *page)
>   {
> @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>   
>   static struct attribute *md_default_attrs[] = {
>   	&md_level.attr,
> +	&md_new_level.attr,
>   	&md_layout.attr,
>   	&md_raid_disks.attr,
>   	&md_uuid.attr,


Kind regards,

Paul
