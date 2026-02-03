Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8383F2F39B9;
	Tue,  3 Feb 2026 20:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770151031; cv=none; b=CxXtGbkX/ZzsfW1fp9Zz0LlpvFqCm/POxWPhbwC104yajsxyLDvAU5P9BE1xOxQY9B7mE2dafb/pD4TODw84ig2h4YbYekQOC4TaJPCHmO6sjwqEF64qKwgr3Gt8IevUZuQuuuKrs8NcN6IMfTPXMbtisYKmg8CULQtbxCVvucE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770151031; c=relaxed/simple;
	bh=jOm2CTG+VoY0yRxl6eYzC0pCIPi/cEROzYdxuovgx+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dMrVktD+zPHp8zCoSb62pEsEpxqY2tksCPeLVv74nBP8b2Mm9YUanOvtFRwDUR6bpTDS6Mg3BRFlkYa8V0JCYs951x1R4tASZiRMdR1DibSueOdcA/eFo4YWLQLNO2cvI7eYUzMspKVgGLdHTQrtOmTKQZgOPjFUcDFMacT6abc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.247]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1vnN8e-0006Km-LT; Tue, 03 Feb 2026 21:36:44 +0100
Message-ID: <9eba8de0-c3b5-47a8-8729-205e0000fc23@plouf.fr.eu.org>
Date: Tue, 3 Feb 2026 21:36:38 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/5] md/raid1: introduce a new sync action to repair
 badblocks
Content-Language: fr
To: Christoph Hellwig <hch@infradead.org>
Cc: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai@fnnas.com, linan122@huawei.com, xni@redhat.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
 <aYGkSwDZTLLbjm6p@infradead.org>
 <40f37494-cf9c-4bc3-aa38-75c76b5d988e@plouf.fr.eu.org>
 <aYIirWALBGrMxmbw@infradead.org>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <aYIirWALBGrMxmbw@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/02/2026 at 17:30, Christoph Hellwig wrote:
> On Tue, Feb 03, 2026 at 09:08:18AM +0100, Pascal Hambourg wrote:
>> On 03/02/2026 à 08:31, Christoph Hellwig wrote:
>>> Just curious, but what kind of devices do you see that have
>>> permanent bad blocks at a fixed location that are not fixed by
>>> rewriting the sector?
>>
>> I have seen this with several hard disk drives of various brands, even
>> though SMART attribute #5 (reallocated sector count) had not reached the
>> limit.
> 
> Weird.  Can you share the models?  I'm especially curious if these
> are consumer of enterprise drives and of what vintage.

I did not keep track of the models and do not remember them, it was a 
long time ago. They were mostly hard disk drives from Dell and HP 
professional desktop and laptop series, so consumer grade I guess, 
manufactured around 2010.
