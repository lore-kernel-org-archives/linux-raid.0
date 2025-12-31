Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893CB2DF12F;
	Wed, 31 Dec 2025 11:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767179882; cv=none; b=oBMMtC2DxDPY2nF6iU8PMQ50x3AJA3FVAp+4SnmzPTpDqsIr3Nk+EmkC8DAGEY47BmEmKCg4+CNUg3vHYGeA2Z/wVy99Pho3HUg290ADYPUINi0EgBA+wgZZ3QvE8UtTIShwP2xydzqkS1u23w9PaDSmY+H+Ei0hsG7BctGjoQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767179882; c=relaxed/simple;
	bh=fQkZgp07l8EaM4ZneN8Q3mlpAQjW3ZTgXiH4KTXwUxM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYphBFsFVwXFy4QchmvLU22pX554D8SVcJRhUaiyVwUbn5mp7e325FTbtJlbV2+V3beCoxO6qFFUgRC6isooZ3vcq21atfuheODdt9rMeUoW/KLJPvKx9dV+2+pMsBgGzWXFdvbpVAlfYCYrjq4bmmTiCzWXXPo/M2xSYVEGkdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 7C74F40919;
	Wed, 31 Dec 2025 11:11:31 +0000 (UTC)
Date: Wed, 31 Dec 2025 16:11:30 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, zhengqixing@huawei.com, linan122@h-partners.com
Subject: Re: [RFC PATCH 0/5] md/raid1: introduce a new sync action to repair
 badblocks
Message-ID: <20251231161130.21ffe50f@nvm>
In-Reply-To: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 Dec 2025 15:09:47 +0800
Zheng Qixing <zhengqixing@huaweicloud.com> wrote:

> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> In RAID1, some sectors may be marked as bad blocks due to I/O errors.
> In certain scenarios, these bad blocks might not be permanent, and
> issuing I/Os again could succeed.
> 
> To address this situation, a new sync action ('rectify') introduced
> into RAID1 , allowing users to actively trigger the repair of existing
> bad blocks and clear it in sys bad_blocks.
> 
> When echo rectify into /sys/block/md*/md/sync_action, a healthy disk is
> selected from the array to read data and then writes it to the disk where
> the bad block is located. If the write request succeeds, the bad block
> record can be cleared.

Could you also check here that it reads back successfully, and only then clear?

Otherwise there are cases when the block won't read even after rewriting it.

Side note, on some hardware it might be necessary to rewrite a larger area
around the problematic block, to finally trigger a remap. Not 512B, but at
least the native sector size, which is often 4K.

-- 
With respect,
Roman
