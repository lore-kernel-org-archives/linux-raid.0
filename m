Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7951E883E
	for <linux-raid@vger.kernel.org>; Fri, 31 Jan 2025 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738343174; cv=none; b=C5cmM1QQ+EY+OafLvBoI7S1kgis33iIDTZOmh2Th7QN/TDx5zkY2HoYXCWxgkppph+kx+EszVFrq2w1AniYwzRrJ6wKcrFHsek4Jtc95aQtbsME2tGYU0dPdjAN23ofZTBvE/jRtp1b9nU3zd1hFEbSbVxNlNjc0fo8vkXOTy00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738343174; c=relaxed/simple;
	bh=1ZCYleoqHgVQiNf4w4SCGhJNKk09atm7uHmp5HD0sHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WJQmjRSO2ezDNES99/0LlE4eVfQcXHuWZ+sjhhHHbz9cmctAXsdTVW3TRS5aQe4ZiB4PyCgO57AtdQd4nR0fhdqBaevZ2rX3LXNT4hkB9XX4d3Pr4yB/N2JWd37sK4Rt0vnuW2AOQuD8QhU/haY9uTxn4JaEd3/9A1dFQSXy7X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2oDpVaNd; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2oDpVaNd"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yl2NG11RhzlgTwB;
	Fri, 31 Jan 2025 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738343162; x=1740935163; bh=o6a64IBc9yLBNHDqXd/Waqs6
	fswqp8HBUxC3aA/OHsc=; b=2oDpVaNdshooPet15Nh6RDhjjGpy1/mHknjP5TNd
	tzc3hs69e3i6oqoYlDCsImBCFOsPOF8nylYd9MMD5zUOgdLg559AIHJd7A2VZmq3
	nqNCa27JFWSaSR8xjG0Szzq3+I/gCtxVPKjTif36vx0EVDVh0PRsBrBbdWyVF78U
	8uMNeoLLMS9q6m8RP5qLrSb/8hx3Rzzl4JufUt4eHM/d4qpd9Q+eybOpbcCfRKBv
	YyXwSkhmf+kKRsnRPTI19AXQP8gZ2YfvJ4CGk46y7ER5BGB1IhwShichvhufCteK
	k5DP0WqfwPdk8iXCipv1gzjuI5eR39f1ek1T4LwV9kzxWw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1Md1MhGBjVqO; Fri, 31 Jan 2025 17:06:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yl2N81k0yzlgTvy;
	Fri, 31 Jan 2025 17:05:59 +0000 (UTC)
Message-ID: <f898d5bf-a037-4fa2-8e1c-a0b177948e7f@acm.org>
Date: Fri, 31 Jan 2025 09:05:59 -0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: Fix linear_set_limits()
To: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 Yu Kuai <yukuai3@huawei.com>, Coly Li <colyli@kernel.org>,
 Mike Snitzer <snitzer@kernel.org>, Nathan Chancellor <nathan@kernel.org>
References: <20250129225636.2667932-1-bvanassche@acm.org>
 <20250131074944.GA16678@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250131074944.GA16678@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 11:49 PM, Christoph Hellwig wrote:
> On Wed, Jan 29, 2025 at 02:56:35PM -0800, Bart Van Assche wrote:
>> This bug was discovered by annotating all mutex operations with clang
>> thread-safety attributes and by building the kernel with clang and
>> -Wthread-safety.
> 
> Can you send patches for that?

Sure, but it will take a few additional days before these will be ready
to be posted. My current plan is as follows:
- In a first phase, annotate struct mutex and the
   mutex_lock()/mutex_unlock() calls and their variants only. This is
   sufficient to detect locking bugs at compile time in error paths and
   also to support GUARDED_BY() if neither the guard() macro nor the
   scoped_guard() macro are used.
- Next, modify the clang compiler such that the guard() macro becomes
   supported. The challenge with the guard() macro is that it creates an
   alias for synchronization object pointers, that the cleanup function
   is passed a pointer to the synchronization object alias and also that
   alias analysis is not supported by the clang thread-safety analysis.
   I have not yet decided how to implement this.
- Evaluate whether it's worth it to annotate other synchronization
   objects than struct mutex.

Bart.


