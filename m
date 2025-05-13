Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2691F0E20;
	Tue, 13 May 2025 07:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747122190; cv=none; b=oLaroz+gS8DbzaC5bKdGTNaq7vDN/Uzi1RhnVHasCc/6y+wPS+H44iMy10JX6gDGp3Ew0VCIhY+7W7Xsszmh10allp99pcb7WgTxiiFi9xFNO6uzGoqFv+g3wDXIxzcaIpSJ5dla7c4oDrweSYX3qCiLualKJMS9SGysZnW7zDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747122190; c=relaxed/simple;
	bh=w4B1ltj8LagoePaHqXTe8flh/f45AYpyZfW68YSvziY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lE9BKZPLgS3s5emjwdCHS7Joz7i7Oa5oZUBEtifhPSHqd15dkrODsBZ24hPKRsjTqSZzgAxlX/FQ+OE1ZN9GkLRRg0af4Y6VRivsp6mGZVELzqjJ8lBsy4G0m1OP70q1nIgMkLWGuTleZvk4Xlw152NexBq4xbVX5aysspvWl3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 46EAC67373; Tue, 13 May 2025 09:43:04 +0200 (CEST)
Date: Tue, 13 May 2025 09:43:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC md-6.16 v3 15/19] md/md-llbitmap: implement APIs to
 dirty bits and clear bits
Message-ID: <20250513074304.GA2696@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-16-yukuai1@huaweicloud.com> <20250512051722.GA1667@lst.de> <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com> <20250512132641.GC31781@lst.de> <20250512133048.GA32562@lst.de> <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com> <03f64fc7-4e57-2f32-bffc-04836a9df790@huaweicloud.com> <20250513064803.GA1508@lst.de> <87a53ae0-c4d6-adff-8272-c49d63bf30db@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a53ae0-c4d6-adff-8272-c49d63bf30db@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 13, 2025 at 03:14:03PM +0800, Yu Kuai wrote:
> Yes, following change can work as well.
>
> Just wonder, if the array is created by another array, and which is
> created by another array ...  In this case, the stack depth can be
> huge. :(  This is super weird case, however, should we keep the old code
> in this case?

Yeah, that's a good question.  Stacking multiple arrays using bitmaps
on top of each other is weird.  But what if other block remappers
starting to use this for other remapping and they are stacked?  That
seems much more likely unfotunately, so maybe we can't go down this
route after all, sorry for leading you to it.

So instead just write a comment documenting why you switch to a
different stack using the workqueue.
