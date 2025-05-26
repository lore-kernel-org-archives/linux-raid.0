Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05351876;
	Mon, 26 May 2025 06:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748241153; cv=none; b=nrORrWffYS7zDZopjNhoSqJMfy5634QdtQ+Xq1XrrOqLbPkGED0nEM2ulHUDTyjX1VgCjYzyBoatVt3y5XyHACcbDQPF61von3XnXvxyFrcT2NTrYR8nGTpeWbeevQObrm2uAxYMnPEc6Hr/6FwE9O7PwgooLZROItrs6yUuuhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748241153; c=relaxed/simple;
	bh=HXYRm/rPwjJ6m0cbZ98/6JJOu7MwWGeub5bGzGrcdxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVnGp25050q20APvIT82G6XYZp3VfbAFFsLVTCtHyZEbKf4o0tE02Yecj/ZfyixLkj9V347JT6V1nbduxG/qbFR4YCvlltUi4IUMmJbe7f70g9QQ6qPmxLP90UOPeT123teoaJdN3m3fx/+2xp5jFcqj5Yq+f2odFPkCPeRpYTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2CC8C68AFE; Mon, 26 May 2025 08:32:27 +0200 (CEST)
Date: Mon, 26 May 2025 08:32:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 06/23] md/md-bitmap: add a new sysfs api bitmap_type
Message-ID: <20250526063226.GB12811@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-7-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-7-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 24, 2025 at 02:13:03PM +0800, Yu Kuai wrote:
> +  consistency_policy

.. these doc changes look unrelated, or am I missing something?

> -static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
> +static bool mddev_set_bitmap_ops(struct mddev *mddev)
>  {
>  	xa_lock(&md_submodule);
> -	mddev->bitmap_ops = xa_load(&md_submodule, id);
> +	mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
>  	xa_unlock(&md_submodule);
> -	if (!mddev->bitmap_ops)
> -		pr_warn_once("md: can't find bitmap id %d\n", id);
> +
> +	if (!mddev->bitmap_ops) {
> +		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
> +		return false;
> +	}
> +
> +	return true;

This also looks unrelated and like another prep patch?

