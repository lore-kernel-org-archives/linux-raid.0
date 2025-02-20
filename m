Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F16F4C98;
	Thu, 20 Feb 2025 03:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740023138; cv=none; b=jVsrxOCuPqMJBvltFzC0Q1Mpj1ZwxDYU+UhCmpQdRNphpakMfUgEz+I0PMUEWphw0W041wkjsQOL5aGN43dTYOSgyns5xBf/wLL611tSqI1RwL4tY8iHuW2b8x7gIE6QUE3dFBuxWy2PpR6nponTgPkkucLE85KuQ+r11NcNms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740023138; c=relaxed/simple;
	bh=MYDhR5pkMKlUbmACzzPlkOun406rZCvLsd7oICDCOpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PvGh+yAdGfQtpvVZVu2FjJOIpN67AiLPtwTauVfKlq5YhJLY6RwxBmlnRlCWtTDwLOIDITlAKR9rrLr4XQx2actocEoXZbQGBEGYQEoWUeLKpXPwlTa+ah3aLXfHMie0sMOtLgg3WXVy/DJN71mI3G4idvF0UCCKylSR0fz1jYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org; spf=pass smtp.mailfrom=morinfr.org; dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b=kVayVrZ7; arc=none smtp.client-ip=212.27.42.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morinfr.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b="kVayVrZ7"
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id 2280B2003C1;
	Thu, 20 Feb 2025 04:45:28 +0100 (CET)
Authentication-Results: smtp2-g21.free.fr;
	dkim=pass (1024-bit key; unprotected) header.d=morinfr.org header.i=@morinfr.org header.a=rsa-sha256 header.s=20170427 header.b=kVayVrZ7;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1TSHQMXxic8Dk/8gtJBn/BlxJqxqs8YjARGrCZPR4VI=; b=kVayVrZ7Y5y9ptA489uRVXFI40
	/CGj0Nnmexgpxn/18fFbgePpyg7B9e7HwGcfL3P2MekBiMk+mcjN+ICDnNUtZ/VncsdQg0fuB+9B5
	gwEfsoIuXcA3H+BgnrUhfJtvjcCIlRZMMXRQ1ovGtqfA6fjZ8CgF1eLFbkq8Ce7CZe2o=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.96)
	(envelope-from <guillaume@morinfr.org>)
	id 1tkxVA-000E9R-1A;
	Thu, 20 Feb 2025 04:45:28 +0100
Date: Thu, 20 Feb 2025 04:45:28 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: Yu Kuai <yukuai3@huawei.com>
Cc: Guillaume Morin <guillaume@morinfr.org>,
	Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, song@kernel.org
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
Message-ID: <Z7alWBZfQLlP-EO7@bender.morinfr.org>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
 <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
 <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>

On 20 Feb 11:19, Yu Kuai wrote:
>
> Hi,
> 
> 在 2025/02/20 11:05, Guillaume Morin 写道:
> > how it was guaranteed that mddev_get() would fail as mddev_free() does not check or synchronize with the active atomic
> 
> Please check how mddev is freed, start from mddev_put(). There might be
> something wrong, but it's not what you said.

I will take a look. Though if you're confident that this logic protects
any uaf, that makes sense to me.

However as I mentioned this is not what the crash was about (I mentioned
the UAF in passing). The GPF seems to be about deleting the _next_
pointer while iterating over all mddevs. The mddev_get on the
current item is not going to help with this.

-- 
Guillaume Morin <guillaume@morinfr.org>
