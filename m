Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77A026F478;
	Thu, 21 Aug 2025 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755789579; cv=none; b=YMrX95/OAeIAlXAv+Y37QDIxCc6WNevIRFf1dLP49qkgL2zkborahynnqhr1cIPX1vgAssxCYYiZVMCd62g2KnlvsdBCL2Z9+XvK6wAmsajp6XpqrPViyxo328qPFLgRLaVO/qk5TDxxw/kyzKowAOoEvAl3YyQ/CTusqq+3/gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755789579; c=relaxed/simple;
	bh=VC4qjsZ3MEo8QaA1QgVMJAUhqHdjAqrVUijCqfg6Jks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0J18hxabP6vkpfpvEaEbXNf649Y4mqelqnfkcdchgl0fx+B4ho3e3ihZBeOg54AUGG6ncw4T7dS3vp/PQZhEKFcqELAvhw5gi3g/PzvkqN3h6I6cB9Ts/bIcB7uut2YyaouGhYWiBDcG7y9qno4mJSTGuVoEQxeLlfEigasI8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mPCjw5At; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mPCjw5At"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c76S83CQ3zm0jvS;
	Thu, 21 Aug 2025 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755789573; x=1758381574; bh=ZPRYKHTLITA6EOWfqyakX0/X
	0x9PVSTh0noiErdLpJM=; b=mPCjw5At/IkVkeW5BdofaVGtchTzbMSNqHa86mjm
	5eTef7oKiwt/ZYWKeyBZLQBlPXZExyHzKHaChRAgYBV3kFdjl3vdGkCv2puPrXJ2
	w7hbY1J+RAvZQn9aHxPqZfz3FW+ORD/NcRj8M8B0ix++Iv7ur5QELgSsL39vYrZJ
	bju+n32HWXlVIkNyBvRZecDYD3WRTMIQaY1ibsV7jgYjS0XZvehKw7qDjEI3Eksg
	Do6xeyYe3zne2psHnstgucdkJgWQ4mLhktPMMRW5er8qcLbsU8lTLDf2p6eKjs2p
	ypIg32Yw76/uAg3LstU7sLYZZpystypODvvrK8IDfxdEEg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oTApmSAUhJfw; Thu, 21 Aug 2025 15:19:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c76Rv0HhDzm0jvP;
	Thu, 21 Aug 2025 15:19:22 +0000 (UTC)
Message-ID: <f3c5067f-af90-4491-86c0-06eaa24e2946@acm.org>
Date: Thu, 21 Aug 2025 08:19:21 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, neil@brown.name, akpm@linux-foundation.org,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, colyli@kernel.org, xni@redhat.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
 <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
 <aKbgqoF0UN4_FbXO@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aKbgqoF0UN4_FbXO@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/21/25 2:02 AM, Christoph Hellwig wrote:
> On Thu, Aug 21, 2025 at 04:56:33PM +0800, Yu Kuai wrote:
>> BTW, for all the io split case, should this order be fixed? I feel
>> we should, this disorder can happen on any stack case, where top
>> max_sector is greater than stacked disk.
> 
> Yes, I've been trying get Bart to fix this for a while instead of
> putting in a workaround very similar to the one proposed here,
> but so far nothing happened.

Does the above comment refer to the block/blk-crypto-fallback.c code? I
will leave it to Eric Biggers to move the bio splitting call from that
code into the filesystems that need it.

Bart.
