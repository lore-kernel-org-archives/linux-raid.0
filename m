Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F7D2222CC
	for <linux-raid@vger.kernel.org>; Tue, 27 Jan 2026 02:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769480007; cv=none; b=l2UVRC/WIOByGNaxMyj7wdr/veOn5CSPIIr7UbA/n6bDC17/KcjJg/LM2tWtxp/YhCDS38il7efJgmBZGDoxjS2uBwaAXrVjdOeNVzuwqKLS3BFr4zw3nG2EPONHzw6n+KiLNHC3lXLjVxr1AAV60KoytX0KnGAKMnbP/ODEByU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769480007; c=relaxed/simple;
	bh=sNWTldzpvJ1rYHTdevRruR2YKOtaXPUJHCsfYimfoRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g36FDaqQ8tsVCK1tuPN9DWmtGp0A/h8HIICwWWFwYR/JqkTHSv3U97aFpgqwl9IW82lIMW8/HaPnQ8qI2ptUkXyAPqbePyCPBu59URgBg/9VvvaRuhw25mmehqILwuqT4LkrkkA+t+5wea/H5N0jzIFCSz4ZCgVFmUG3KeRZu7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=U0KAv38u; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="U0KAv38u"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f0TTd2lMFzlgyFw;
	Tue, 27 Jan 2026 02:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769480003; x=1772072004; bh=Ge5/tK+J3ueoDDWpAmMwR2ZO
	GbEvMJv1HaaY6ItcQEI=; b=U0KAv38uGzlFD/gcTKPwXfo19aLg1KVzYYoyUYnf
	XTYGEPEZ7ffTWiQ25PsldpWhXCkV11UzHvkqdgBg7/rlgBudnKUANtFuV4jGklb2
	My3DcbHv1yh4qnpgntPXnWagacGHo8RaM6uerI086BJEcoC0GoCkqSBYEKGNiFvP
	ZoP+RXX6epUacAaTsZXxXwGcMbPkV8MsbRODVvZcvCiYpsu/YBizBItJc8rsckLU
	ruH1DiwA9vm0vUxmABnwPIi0M33Ldt/qxhUxr/nEzmQPOT2M9UJ9J5+0SunGuT1o
	A7lJ+QkZsgdd1zzC6FYqJoOAxY1Gv8Snl8AEBiX5Ldigcw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yhHV81zHJBj7; Tue, 27 Jan 2026 02:13:23 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f0TTZ21Qqzlgy27;
	Tue, 27 Jan 2026 02:13:21 +0000 (UTC)
Message-ID: <c0510f92-900d-4d63-aeae-85b2b8f5d59a@acm.org>
Date: Mon, 26 Jan 2026 18:13:20 -0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] md: call del_gendisk in control path
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com, ncroxon@redhat.com, song@kernel.org,
 yukuai1@huaweicloud.com
References: <20250611073108.25463-1-xni@redhat.com>
 <20250611073108.25463-2-xni@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250611073108.25463-2-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 12:31 AM, Xiao Ni wrote:
>   static inline int mddev_trylock(struct mddev *mddev)
>   {
> -	return mutex_trylock(&mddev->reconfig_mutex);
> +	int ret;
> +
> +	ret = mutex_trylock(&mddev->reconfig_mutex);
> +	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
> +		ret = -ENODEV;
> +		mutex_unlock(&mddev->reconfig_mutex);
> +	}
> +	return ret;
>   }

This change seems wrong to me. This change will cause mutex_unlock() to
be called if mutex_trylock() *failed*. Additionally, returning -ENODEV
from the failure path will cause the caller to call mutex_unlock() a
second time if mutex_trylock() failed. Please fix this!

As a reminder, from include/linux/mutex.h:

/*
  * NOTE: mutex_trylock() follows the spin_trylock() convention,
  *       not the down_trylock() convention!
  *
  * Returns 1 if the mutex has been acquired successfully, and 0 on 
contention.
  */

Bart.
