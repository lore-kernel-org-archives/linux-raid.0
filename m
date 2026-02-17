Received: from mail-108-mta71.mxroute.com (mail-108-mta71.mxroute.com [136.175.108.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7804F2DE709
	for <linux-raid@vger.kernel.org>; Tue, 17 Feb 2026 08:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771318790; cv=none; b=I63XkeZuX72zak5MWCebw7TlaLQ/tgZFwXSZAx1iAeyT4XGgA2m/2XHo/0lrw0n3KoFgVRA9Fb7Ja3fPAnh8dcxAIGHiSO5DSlxa/ODAI3aeye2eRJyg2DGduW3vBra+4LThg4qpb1IvHkyOvCcJkfh1N4L/zaF8GzVp7ziyIRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771318790; c=relaxed/simple;
	bh=KZHioFvLASCiWeEpom+DtrzHYkuzlEWhhZUr8OnVu6M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lZQJ9t75mULkZ0CJ2awapRrJBiMfwvkP5QJFrbpwTo95cvqPM21AIUjTypwQP/REgfSkn3BbqBfQuPIQM53cUK5GIqRRkw+IPJm2TtrRd2p7MxiMB1gu3CuUnyIVy4Vh2yiyLR1KOPe/mwoaihZ7IJTqVnSxQHwEwuFVcTLUQ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=G2EEWDpV; arc=none smtp.client-ip=136.175.108.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="G2EEWDpV"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta71.mxroute.com (ZoneMTA) with ESMTPSA id 19c6acf10d30009140.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 17 Feb 2026 08:54:41 +0000
X-Zone-Loop: 37087daf19e16be1c3e97cb887a59a0720342355e18e
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U60trGZWCjJzq+nM+DpVrK00Z6HX0kQCbTHe2vbtffU=; b=G2EEWDpVdr0KfWSVEwN/3/rfm5
	bVVhN24YLdsAsFXj7/SHphG830ockp9n/m7csyLRzKy7VHI7yD6qYdCAtlK/6Tecf+ZqGOw2U2cBy
	4sDPJeV08SsFRnIZIYTLoyQhwZqdZYMg/404/MU9GwlFARiEokka5PXgf1ip9H4tJUNJWGR1KjbU1
	LYxNRmev3kavzXQ42WwC18cdjIwA7x36eXq28OZK7jxWQxPMznzA0VMMB5462PGyrnTRH1TzPycgs
	wo5IADmI+NvwtEZxIyLmHgaFXa9of959t3LhPYWQX09q71SoGFZmew090XBhk4Ut4HP8ZQFtGZvOL
	kWChec1w==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org,  linan122@huawei.com,  xni@redhat.com,
  colyli@fnnas.com,  linux-raid@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] md: add fallback to correct bitmap_ops on version
 mismatch
In-Reply-To: <20260214061013.2335604-4-yukuai@fnnas.com> (Yu Kuai's message of
	"Sat, 14 Feb 2026 14:10:11 +0800")
References: <20260214061013.2335604-1-yukuai@fnnas.com>
	<20260214061013.2335604-4-yukuai@fnnas.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 17 Feb 2026 16:54:24 +0800
Message-ID: <h5rf7nsv.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Sat 14 Feb 2026 at 14:10, Yu Kuai <yukuai@fnnas.com> wrote:

> If default bitmap version and on-disk version doesn't match, and 
> mdadm
> is not the latest version to set bitmap_type, set bitmap_ops 
> based on
> the disk version.
>
Why not just let old version mdadm fails  since llbitmap is a new 
feature.

> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md.c | 103 
>  +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 102 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 59cd303548de..d2607ed5c2e9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6447,15 +6447,116 @@ static void md_safemode_timeout(struct 
> timer_list *t)
>
>  static int start_dirty_degraded;
>
> +/*
> + * Read bitmap superblock and return the bitmap_id based on 
> disk version.
> + * This is used as fallback when default bitmap version and 
> on-disk version
> + * doesn't match, and mdadm is not the latest version to set 
> bitmap_type.
> + */
> +static enum md_submodule_id md_bitmap_get_id_from_sb(struct 
> mddev *mddev)
> +{
> +	struct md_rdev *rdev;
> +	struct page *sb_page;
> +	bitmap_super_t *sb;
> +	enum md_submodule_id id = ID_BITMAP_NONE;
> +	sector_t sector;
> +	u32 version;
> +
> +	if (!mddev->bitmap_info.offset)
> +		return ID_BITMAP_NONE;
> +
> +	sb_page = alloc_page(GFP_KERNEL);
> +	if (!sb_page)
> +		return ID_BITMAP_NONE;
> +
>
Personally I don't like the way treating error as ID_BITMAP_NONE.
When wrong things happen everything looks fine, no error code, no 
error message.

> +	sector = mddev->bitmap_info.offset;
> +
> +	rdev_for_each(rdev, mddev) {
> +		u32 iosize;
> +
> +		if (!test_bit(In_sync, &rdev->flags) ||
> +		    test_bit(Faulty, &rdev->flags) ||
> +		    test_bit(Bitmap_sync, &rdev->flags))
> +			continue;
> +
> +		iosize = roundup(sizeof(bitmap_super_t),
> +				 bdev_logical_block_size(rdev->bdev));
> +		if (sync_page_io(rdev, sector, iosize, sb_page, 
> REQ_OP_READ,
> +				 true))
> +			goto read_ok;
> +	}
>
And here.

> +	goto out;
> +
> +read_ok:
> +	sb = kmap_local_page(sb_page);
> +	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
> +		goto out_unmap;
> +
> +	version = le32_to_cpu(sb->version);
> +	switch (version) {
> +	case BITMAP_MAJOR_LO:
> +	case BITMAP_MAJOR_HI:
> +	case BITMAP_MAJOR_CLUSTERED:
>
For BITMAP_MAJOR_CLUSTERED, why not ID_CLUSTER ?

--
Su
> +		id = ID_BITMAP;
> +		break;
> +	case BITMAP_MAJOR_LOCKLESS:
> +		id = ID_LLBITMAP;
> +		break;
> +	default:
> +		pr_warn("md: %s: unknown bitmap version %u\n",
> +			mdname(mddev), version);
> +		break;
> +	}
> +
> +out_unmap:
> +	kunmap_local(sb);
> +out:
> +	__free_page(sb_page);
> +	return id;
> +}
> +
>  static int md_bitmap_create(struct mddev *mddev)
>  {
> +	enum md_submodule_id orig_id = mddev->bitmap_id;
> +	enum md_submodule_id sb_id;
> +	int err;
> +
>  	if (mddev->bitmap_id == ID_BITMAP_NONE)
>  		return -EINVAL;
>
>  	if (!mddev_set_bitmap_ops(mddev))
>  		return -ENOENT;
>
> -	return mddev->bitmap_ops->create(mddev);
> +	err = mddev->bitmap_ops->create(mddev);
> +	if (!err)
> +		return 0;
>
> +
> +	/*
> +	 * Create failed, if default bitmap version and on-disk 
> version
> +	 * doesn't match, and mdadm is not the latest version to set
> +	 * bitmap_type, set bitmap_ops based on the disk version.
> +	 */
> +	mddev_clear_bitmap_ops(mddev);
> +
> +	sb_id = md_bitmap_get_id_from_sb(mddev);
> +	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
> +		return err;
> +
> +	pr_info("md: %s: bitmap version mismatch, switching from %d to 
> %d\n",
> +		mdname(mddev), orig_id, sb_id);
> +
> +	mddev->bitmap_id = sb_id;
> +	if (!mddev_set_bitmap_ops(mddev)) {
> +		mddev->bitmap_id = orig_id;
> +		return -ENOENT;
> +	}
> +
> +	err = mddev->bitmap_ops->create(mddev);
> +	if (err) {
> +		mddev_clear_bitmap_ops(mddev);
> +		mddev->bitmap_id = orig_id;
> +	}
> +
> +	return err;
>  }
>
>  static void md_bitmap_destroy(struct mddev *mddev)
