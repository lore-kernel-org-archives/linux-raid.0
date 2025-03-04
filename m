Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC6C24C06C;
	Tue,  4 Mar 2025 16:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741107196; cv=none; b=AIuTsUv0UdNiG4WbZ+XJB5WJWNZOHsAuCZj74NIFPEVn12hf/vN1MKXqbYKxIpLgPbXuBqECso7bIaLKfimPVeVvx14Ww59krnbguhx3PRk/fT2oN0SN9fxJ+w+rZcJkrzeHAXzfNSyYq9Y7bCehsasgd+C3oo0h4BvIa58BMOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741107196; c=relaxed/simple;
	bh=QOXUN+50/43sNcot85Fxk7vXxY+54HLAWMfOoMYvPHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WkDTzBXHLXYoUWMkNufAU5ze5eHe8gwhL4B1X1DTwgf6gqMTzHqLIqb4s7bBEZ0qfWzdcfIK/i5MEMfNtRgv1gxl12dpcbBtyM8nUEY3dUMyaWMkqQnkuVo94FRWQZsPV+4Dk0em/Etv5zzUAszQpB+UauOGiS3g//FOLMKHh6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XBjxOJYk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XBjxOJYk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z6hTt3BW2zlxW5R;
	Tue,  4 Mar 2025 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741106944; x=1743698945; bh=0yF6JFh7nuQ25sPmBfvr71pz
	u5aA76yMnS8lXv52hsA=; b=XBjxOJYkmLxCCif1K5POATpKp8HLrLawLxHhQRtj
	CgvuHWUl81OUmMrYBZsJN2bcXMSqquzLjxuFvZ+0oHTD6j4bSmSZDYXGAxb6YzJe
	8snZjF1jTVQJB82do2kl4T1w3BIAgc7JXZx2Ealg4d0Y00St67QLfxDoUp+NbFNn
	tgQiCJbpcSLntL/+Jv+/BYEHka0wKBg1hzw1ZE1yDbT2cd4PgZyQ5o10I7Jx7vmn
	x1QtcoxfhQ4lwPjyWPAUPtadwstQBvhTVxX26XjZlVDNetVvJGhsBUywa2zN3OaY
	pcKJ5oTNx2hR4TmwFggzPq33HjQIjDYJpU8yu1MKe1Wbmw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PW2LVAGltcYO; Tue,  4 Mar 2025 16:49:04 +0000 (UTC)
Received: from [172.20.1.83] (unknown [192.80.0.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z6dSD4pBLzm2Q1P;
	Tue,  4 Mar 2025 14:32:28 +0000 (UTC)
Message-ID: <2ca75746-c630-4a15-bf5d-e9cb10b6e83c@acm.org>
Date: Tue, 4 Mar 2025 06:32:27 -0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] block: factor out a helper to set logical/physical
 block size
To: linan666@huaweicloud.com, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com, hare@suse.de, martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, zhangxiaoxu5@huawei.com,
 wanghai38@huawei.com
References: <20250304121918.3159388-1-linan666@huaweicloud.com>
 <20250304121918.3159388-2-linan666@huaweicloud.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250304121918.3159388-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 4:19 AM, linan666@huaweicloud.com wrote:
> +EXPORT_SYMBOL(blk_set_block_size);

This function is exported without documenting what the requirements are
for calling this function? Yikes.

Is my understanding correct that it is only safe to apply changes made 
with blk_set_block_size() by calling
queue_limits_commit_update_frozen()?

Thanks,

Bart.
