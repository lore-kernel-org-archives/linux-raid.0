Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B939F155322;
	Tue,  3 Feb 2026 08:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770108263; cv=none; b=kykmsbwHkLG+dnuS0rR9tMjLaY7TbEHWFK2B2Va8+r57eOb4rKAC7fVfetSl6bOeFY+Zc6yEDy4t4bzavlr4IoDLZ5aq/+RqcpY8U6SfYfBxFQMNxlmfscPVdQ0Euk5B+4BO9LP+91VJJzpU4BE21g6qTW7z5jY22XaiU2HYSWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770108263; c=relaxed/simple;
	bh=qApxoQRVQZ7Asxx1IW0TkiPIBPd02OsrDrbCED8RA0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WQqF9eby+3re+5uuvnxQtHVT9fSyGvYKY1RVc3zP93J0VqM5Day7jyFOOMX+8t7kYwvS3ha2SGGkbSAE4VlrSdvbhyajTgytHVHcjZ4/LpuH6C9Ek6e4B2C2pS1kfNmxdN8LqFsdNGfsynbT3iyCOEEWW3PB96yvR85CVKiQTVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.247]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1vnBSW-0004R0-4D; Tue, 03 Feb 2026 09:08:28 +0100
Message-ID: <40f37494-cf9c-4bc3-aa38-75c76b5d988e@plouf.fr.eu.org>
Date: Tue, 3 Feb 2026 09:08:18 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/5] md/raid1: introduce a new sync action to repair
 badblocks
To: Christoph Hellwig <hch@infradead.org>,
 Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, xni@redhat.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
 <aYGkSwDZTLLbjm6p@infradead.org>
Content-Language: fr
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <aYGkSwDZTLLbjm6p@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/02/2026 à 08:31, Christoph Hellwig wrote:
> Just curious, but what kind of devices do you see that have
> permanent bad blocks at a fixed location that are not fixed by
> rewriting the sector?

I have seen this with several hard disk drives of various brands, even 
though SMART attribute #5 (reallocated sector count) had not reached the 
limit.
