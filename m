Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA25315990C;
	Mon, 12 May 2025 05:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747027049; cv=none; b=Zxp8bH2LwhRzj59iitDDzrvOWyh2gPl/dPekeD5dPn1Hqbp3zDrdrfOaZ+Q+qQATja4MKEhBEHZcwILlnxh2gTsC7jLIIbiMSw2nUpute0b/xLkWQtTBAiYrIZawvXIMpB6R9BM0rxY89+foedVyKptufDWTKJ2HixmmKTOZObQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747027049; c=relaxed/simple;
	bh=oKZ6fQ0lEQ/OEEwLVInzPIoIpvS34AB+dlup+t+pdXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nd0GNpRLqAxmNqAmFZTZJbC2EouCXqKeAt8twNV6bNcdua4sydhnncrZBP1TRAZYepQaY3M742NUmV+GQfUpgQAKBomG7gN927Zk7ArQCaLtsbQcMK2bCqspyg9W+BRbZGqhd+rcgM3SvYBxbTjfBlwn6YxHT7TY80W44TJyfps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA23168AA6; Mon, 12 May 2025 07:17:22 +0200 (CEST)
Date: Mon, 12 May 2025 07:17:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 15/19] md/md-llbitmap: implement APIs to
 dirty bits and clear bits
Message-ID: <20250512051722.GA1667@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-16-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-16-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:23AM +0800, Yu Kuai wrote:
> +static void llbitmap_unplug(struct mddev *mddev, bool sync)
> +{
> +	DECLARE_COMPLETION_ONSTACK(done);
> +	struct llbitmap *llbitmap = mddev->bitmap;
> +	struct llbitmap_unplug_work unplug_work = {
> +		.llbitmap = llbitmap,
> +		.done = &done,
> +	};
> +
> +	if (!llbitmap_dirty(llbitmap))
> +		return;
> +
> +	INIT_WORK_ONSTACK(&unplug_work.work, llbitmap_unplug_fn);
> +	queue_work(md_llbitmap_unplug_wq, &unplug_work.work);
> +	wait_for_completion(&done);
> +	destroy_work_on_stack(&unplug_work.work);

Why is this deferring the work to a workqueue, but then synchronously
waits on it?

