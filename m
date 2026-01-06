Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2F633D512;
	Tue,  6 Jan 2026 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767707411; cv=none; b=Sc5AqxfGl5h4s4jLmSHjSRa++TBulfe6cIDHqANx/KgdI96VA/DlCAKp7hUCJaYgyRz1ihMowJQkhEb8cO77QZNhmcXu39+9Q17vFYcgGFIvsGuhPHxwSOW6uPimVhy8A1YpEd/I0H/Fm8YEb0LLhZp1+hNRo3CTneiRTnTl7Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767707411; c=relaxed/simple;
	bh=Vqq/ffodAvCX4osdlyQBA3l4p921hS/FUN2qVvCsrdU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FoXT0Yq+C8TXLgNNC5FlQwCCRHxOLKB/zILDYeD46DwAdKfOfHQ2S2zlNi/FOEb3A30s8Iarbf7QXhxTJbWwPfNdnHe/YOhHafDWqWxkuOW/mGvtysyP5B8EotHbKTZBvLRLHXVRL028nhs+DGvbHGIPDKFQX45bEdZUoSh4j1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 01194401D3;
	Tue,  6 Jan 2026 13:50:02 +0000 (UTC)
Date: Tue, 6 Jan 2026 18:50:02 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, linan122@h-partners.com, zhengqixing@huawei.com
Subject: Re: [RFC PATCH 0/5] md/raid1: introduce a new sync action to repair
 badblocks
Message-ID: <20260106185002.2afbd215@nvm>
In-Reply-To: <d00be167-741a-4569-a51e-38b36325826e@huaweicloud.com>
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
	<20251231161130.21ffe50f@nvm>
	<d00be167-741a-4569-a51e-38b36325826e@huaweicloud.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jan 2026 10:44:38 +0800
Zheng Qixing <zhengqixing@huaweicloud.com> wrote:

> Are you referring to the case where we have logical 512B sectors but 
> physical 4K sectors?

At least that, yes. Such rewriting of bad blocks should happen at least at the
physical sector granularity.

But from my limited experience it feels like the badblock recovery algorithm
in hard drives, in addition to being opaque and proprietary, also highly
indeterministic and possibly buggy. In one case it would take REPEATEDLY
overwriting a full megabyte around a bad block to finally make the drive remap
it. (Maybe less than a megabyte would do, but overwriting only 4K - didn't).
Of course I understand such endeavors are outside of scope for mdraid, hence
it was just a side note.

-- 
With respect,
Roman
