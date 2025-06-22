Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA475BE5E
	for <linux-raid@vger.kernel.org>; Sun, 22 Jun 2025 21:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750629362; cv=none; b=Tif6i1sYH6O+Xbhj7G3o5zN1l8PmgSC3wezsXIOIkXeXRm/F3/oFfh62pveblBsr5Bfk+kdKXEJx6wENWA7iiXoYGchGjWRArOR2kqtjwFsJ8h02MRRJPhfZYTK1SznI6CEvqmGZE6Z6yt6e0EsQPofoPsmk+eK9KPazfcsxZBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750629362; c=relaxed/simple;
	bh=mzdVe9tQ7w+jcIwbv7cDtBn28/hGzTCy7cZo6H0/Ld0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=arlXeooUWwsVWF4yn5rLDJmqVcdGVYc0/5HuBYD/3+ptjCorroGjAfhWNxl/r99wpyaWyOB5h3gUNt/YDjl+yEBzTcDw5CCr3COD79WO5KX30gNLbkKJTY37WzKk0bYimNL1uVn12mj6hhVnE7MYSqwM25KEANSqTi9IEfLBsMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=pass smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=youngman.org.uk
Received: from host86-158-182-88.range86-158.btcentralplus.com ([86.158.182.88] helo=[192.168.1.171])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1uTR8m-000000008ld-9LVI;
	Sun, 22 Jun 2025 21:18:12 +0100
Message-ID: <27dca314-e6b4-4cb8-8d4d-a3ae8dcdc685@youngman.org.uk>
Date: Sun, 22 Jun 2025 21:20:09 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Kernel mistakenly "starts" resync on fully-degraded,
 newly-created raid10 array
To: Omari Stephens <xsdg@xsdg.org>, Wol <antlists@youngman.org.uk>,
 linux-raid@vger.kernel.org
References: <b696bee2-3c10-45be-8f5a-be3c607d0676@xsdg.org>
 <7bccda92-7b27-44ed-a240-b124c99a3b53@youngman.org.uk>
 <c700ab1f-9e62-49a6-807c-3a37023a0b9e@xsdg.org>
Content-Language: en-US
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <c700ab1f-9e62-49a6-807c-3a37023a0b9e@xsdg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/06/2025 19:03, Omari Stephens wrote:
> On 6/22/25 09:30, Wol wrote:
>> On 22/06/2025 02:39, Omari Stephens wrote:

>>> |At that point, /proc/mdstat showed the following, which makes no 
>>> sense:|
>>>
>> Why doesn't it make any sense? to)
>>
>> Don't forget a raid-10 in linux is NOT a two raid-0s in a raid-1, it's 
>> its own thing entirely.
> 
> Understood.  I've been using Linux MD raid10 for over a decade.  I've 
> read through this (and other references) in depth:
> https://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
> 
> My question is this: Suppose you create a 4-drive array.  2 drives are 
> missing.  What data is there to synchronize?  What should get copied 
> where, or what should get recomputed and written where?

Ah - I get that. But presumably raid *always* fires up a resync (unless 
told not to) when an array is created - and see below ...
> 
> To my understanding, in that situation, each block in the array only 
> appears in one place on the physical media, and there is no redundancy 
> or parity for any block that could be out of sync.

No. It's trying to resync a *broken* array. Unless you had explicitly 
asked for just one mirror (which I don't think you did). A raid-10 needs 
"no of mirrors plus one". I can see why you would think "why doesn't it 
just fire up as a plain raid-1?", but I guess it just doesn't. I've 
never tried to create an array in a broken state.
> 
> When you read from the array, yes, you're going to get interleaved bits 
> of whatever happened to be on the physical media to start with, but 
> that's basically the same as reading directly from any new physical 
> media -- it's not initialized until it's initialized, and until it is, 
> you don't know what you're going to read.
> 
Yup. Read-before-write is going to return random junk - not particularly 
a good idea - but I don't think you can assume that --assume-clean will 
actually create a clean array. My fu isn't up to guessing what will 
happen when, in particular for higher raids even with zeroed data the 
parity will be one. (And I would never assume a new drive was zeroed. To 
me it has as much evidence behind it as an old wive's tale. Other people 
may have real evidence -I don't.)

What you did worked, and in hindsight you can see how, but with just two 
drives, I personally wouldn't even have tried. Anyways, all's well that 
ends well, as they say ...

Cheers,
Wol
