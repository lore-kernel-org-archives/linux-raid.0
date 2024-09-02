Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9004613D897
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 10:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725272012; cv=none; b=BvexCl7nuVLcYI/Y/K9vwZsq8ZwYnmA1mtdrV8sOI9aZdjn0f199gPnwAGyu7oDSakt7yBmctxJkO1qiqylYdYqy528hsKdQlm+99yvh3u6W6dASN+jSqKUfffxYxisEpOPmg0i5m5tZx+O6Ymoh0Sm1qM9DKa7EbEjNOmIAYaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725272012; c=relaxed/simple;
	bh=+guLu8nQNhaTy4KdocN10r0QORGXwG8bXixYmiaEQwU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SoZG2Vvgu7L7bwaRSsMxKZ4egyjiMG8HwA76UvxwFdRUae3iSpBAsYSwU4uDyjpOK09jStJsNJ896VOSRE8h5Fcku2YcnZCVzA91SROmzA0pIKf7aHfr44QaThKf6LOIHdDy4JujWEkNrsLJj1cppoy5gimlg8Za7BZP/C+kTCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mpSnXg45; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mpSnXg45"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725272011; x=1756808011;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+guLu8nQNhaTy4KdocN10r0QORGXwG8bXixYmiaEQwU=;
  b=mpSnXg45vzVJp07ChfF8ZWD2J5GEsaOwSUJklU2biiU/xd9EnByrvA1N
   RmKdnVdKWzOPrRyqnp+31f1AM9Umrg61plIMvyrYp1ofXMiaUW/3zUYbp
   7SG2FwKp2kpE9hGA12Cg/eQFPhUZtx7yiTX/ZKbfY54VxTRsNnGSSQKZC
   XxcrEGOHUcbqqp0zxTSZs4/NRr+PjFj2qGSNI9+gQTTDaHB1lD4Tf6U9L
   8vrVmSw3gIM4/z+U5IpbM8QJlI+6kGSBIHKeLKSYtHIWoHTrBEVz8qRaq
   JGTMEckuG2AF1OFNvdSBK6wRQl1J+LciT8teBR7UJGzmkNQvEsAT/1ne+
   A==;
X-CSE-ConnectionGUID: xzx/UXwnSFGCF7YaOL/hiw==
X-CSE-MsgGUID: 3oppDMSVR4Gz70PbNJn9VA==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23978902"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="23978902"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:13:31 -0700
X-CSE-ConnectionGUID: wP6W5YiTRI+bn3zp/N1PfQ==
X-CSE-MsgGUID: dZMmo/vsT7yvNibgLn8bKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="69362041"
Received: from unknown (HELO localhost) ([10.217.182.6])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:13:29 -0700
Date: Mon, 2 Sep 2024 12:13:23 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, yukuai1@huaweicloud.com
Subject: Re: [PATCH md-6.12 1/1] md: add new_level sysfs interface
Message-ID: <20240902121323.0000589d@linux.intel.com>
In-Reply-To: <20240828021828.63447-1-xni@redhat.com>
References: <20240828021828.63447-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Aug 2024 10:18:28 +0800
Xiao Ni <xni@redhat.com> wrote:

> This interface is used to updating new level during reshape progress.
> Now it doesn't update new level during reshape. So it can't know the
> new level when systemd service mdadm-grow-continue runs. And it can't
> finally change to new level.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/md.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3a837506a36..c639eca03df9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf,
> size_t len) static struct md_sysfs_entry md_level =
>  __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
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

I don't see any code behind mddev->new_level handling so I suspect that
md_update_sb() does nothing in this case. Is there something I'm missing?

Thanks,
Mariusz

> +
> +	mddev_unlock(mddev);
> +	return err ?: len;
> +}
> +static struct md_sysfs_entry md_new_level =
> +__ATTR(new_level, 0664, new_level_show, new_level_store);
> +
>  static ssize_t
>  layout_show(struct mddev *mddev, char *page)
>  {
> @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR,
> serialize_policy_show, 
>  static struct attribute *md_default_attrs[] = {
>  	&md_level.attr,
> +	&md_new_level.attr,
>  	&md_layout.attr,
>  	&md_raid_disks.attr,
>  	&md_uuid.attr,

