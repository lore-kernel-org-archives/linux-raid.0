Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AAA35EDD4
	for <linux-raid@vger.kernel.org>; Tue, 27 Jan 2026 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769533772; cv=none; b=uTgEX/2z5bTx2LfMIypvWnkyFF/Prm7ni69dN5AylUgg21bvTMmsUPCABO+ZFiBBXMnWpMvEPiuU5DdXoSOScLc41dGjha1tKAcias+Q+tHU9OYcl2uVNLeDkqUgxNe/30x+Pn6cSQmBltq2dTEf+6XzoPDtXKC6hcmU0EjzAnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769533772; c=relaxed/simple;
	bh=0FsXCuyO0a+3oyQoYCHJALECwKqJ4C9AG+/g9IK4aZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+q4YQewbUVPLfEeGy8iH57zx4m26gM7hGjWIZ66yxKcPSLtzVFdUsK5FUfJ19N8015XM4BxZGim3VubDCz90vJH1DYVMdlB5LoZoccmVjXVKp2xidVFNdIZN4lBgQC4wY6SjFVplNFqLbOkwXFc33p0Fs3vqfdSFbBF8dvQ4qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oJ2za0wD; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oJ2za0wD"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f0sMT2MdBzllB6t;
	Tue, 27 Jan 2026 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769533764; x=1772125765; bh=3pA/0mgmiXs7dFxBHmMnNIEJ
	0c6jrTYMjP+cpaMxSeo=; b=oJ2za0wDEulVNk/BPyxZlp4unRFGxnRp8KtSafqw
	Iq+G1ygGGmi8082gHUVwGOz4N8DVEeE0mjva4v0M0BK6l9B7dtimPj3P7otmMMHg
	iy5T6VlLkrGMGoh4z7mjlNhBBJejM59OYzOogSjKrWVBcb92kbWA7xZ6eEknpfGv
	0i94FlPd4mSuEiYMmUjtS3h8y39EbV9ugGcd9kH7U/TQhwRT3AHCGgXokNFwoh97
	gguaS7atMz8rmWq03Es4jNsHM/SMIM7aqJkkZ5lU1Tlq0hX4g2eO9zLC93mBazk4
	p2F3sY3YYtJHHEKG4P5wJrcOyYYbmJmsize8TV10IQJS5A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yx8PXEjMdD2F; Tue, 27 Jan 2026 17:09:24 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f0sMR3HKgzlffvQ;
	Tue, 27 Jan 2026 17:09:23 +0000 (UTC)
Message-ID: <665c3fa7-4c5a-40ff-b5ef-eb26ab52b799@acm.org>
Date: Tue, 27 Jan 2026 09:09:22 -0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] md: fix return value of mddev_trylock
To: Xiao Ni <xni@redhat.com>, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org
References: <20260127073951.17248-1-xni@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260127073951.17248-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/26/26 11:39 PM, Xiao Ni wrote:
> A return value of 0 is treaded as successful lock acquisition. In fact, a
> return value of 1 means getting the lock successfully.
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Reported-by: Bart Van Assche <bvanassche@acm.org>
> Closes: https://lore.kernel.org/linux-raid/20250611073108.25463-1-xni@redhat.com/T/#mfa369ef5faa4aa58e13e6d9fdb88aecd862b8f2f
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6985f2829bbd..3bfbee595156 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -737,8 +737,8 @@ static inline int mddev_trylock(struct mddev *mddev)
>   	int ret;
>   
>   	ret = mutex_trylock(&mddev->reconfig_mutex);
> -	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
> -		ret = -ENODEV;
> +	if (ret && test_bit(MD_DELETED, &mddev->flags)) {
> +		ret = 0;
>   		mutex_unlock(&mddev->reconfig_mutex);
>   	}
>   	return ret;

Maybe this is a good time to add some documentation above
mddev_trylock() that explains the meaning of the return value? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
