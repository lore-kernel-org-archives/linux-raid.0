Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BFF4C92;
	Tue,  6 Jan 2026 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767715961; cv=none; b=oiSaYmpYEzVfd+4Hd+pyaVCLoHrbhbT8X8Yt1MJm9jP0l/35FAHxHXuRc67urlCvo/BXA9L3Fgu8rf79/crJm5fk8hlwG1sSe1P367VTjjQadxEIZPBNaq3+nF/T3KP8AveDeZU6PIX0oVQ+OH0N//3aoeFJI8WsopHXofmAO1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767715961; c=relaxed/simple;
	bh=e2ekluiWwOYJI6kHIAZ8/6/mgwJACLcXFeBW1oSDlqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=irJmExHyzAa3jwioCENoix+gBHPNj5NCqIIaN/fa5YsDIBgd9+oXdqyiaBP8yPtDAmSS6Qafm31WjGyCLmWCfW7EQEUMCuq3GMVsbJLLEIWpO6fqmedemhi8WC1ys/kL2w7Onp2E/2M79x8Oa2+6kEC0HfRzqD0D+Yn9Fk4fgV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.247]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1vd97C-0006EX-VL; Tue, 06 Jan 2026 16:36:58 +0100
Message-ID: <be20c929-4a81-49fe-9c0d-67f2e116732a@plouf.fr.eu.org>
Date: Tue, 6 Jan 2026 16:36:52 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] md/raid1: introduce a new sync action to repair
 badblocks
Content-Language: fr
To: Zheng Qixing <zhengqixing@huaweicloud.com>, Roman Mamedov <rm@romanrm.net>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, linan122@h-partners.com, zhengqixing@huawei.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231161130.21ffe50f@nvm>
 <d00be167-741a-4569-a51e-38b36325826e@huaweicloud.com>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <d00be167-741a-4569-a51e-38b36325826e@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/01/2026 at 03:44, Zheng Qixing wrote:
> 在 2025/12/31 19:11, Roman Mamedov 写道:
>> On Wed, 31 Dec 2025 15:09:47 +0800
>>
>> Could you also check here that it reads back successfully, and only 
>> then clear?
>>
>> Otherwise there are cases when the block won't read even after 
>> rewriting it.

I confirm. The rewrite is reported successful but SMART reallocation 
attributes did not change and a further read still fails.

> I'm a bit worried that reading the data again before clearing the bad 
> blocks might affect the performance of the bad block repair process.

Isn't it more worrying to clear bad blocks while they may still be bad ?
Bad blocks should be rare anyway, so performance impact should be low.

>> Side note, on some hardware it might be necessary to rewrite a larger area
>> around the problematic block, to finally trigger a remap. Not 512B, but at
>> least the native sector size, which is often 4K.
> 
> Are you referring to the case where we have logical 512B sectors but 
> physical 4K sectors?

Yes. Writing a single logical sector implies a read-modify-write of the 
whole underlying physical sector and will not complete if the read fails.

> Can a physical 4K block have partial recovery (e.g., one 512B sector 
> succeeds while the other 7 fail)?

Not in my experience. There seems to be a single ECC for the whole 
physical sector.
