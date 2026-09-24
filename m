Received: from e234-54.smtp-out.ap-northeast-1.amazonses.com (e234-54.smtp-out.ap-northeast-1.amazonses.com [23.251.234.54])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BE9423EA4;
	Thu, 24 Sep 2026 16:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790267256; cv=none; b=gkS75wRoZocrJWeHZJhxENe+als4+WpaYszJJQrMVzX6e7t7SrqXkThtCKTIQyWs8r/J72/+WqE2M5L9MmuUu8Nwo2VLFfXbMHXNORQXr3RaRuibER5cWiGJiteer3Vnpwnt1bzUXcytUsyUguBXccBdFCXp1n97D0zyUw77lA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790267256; c=relaxed/simple;
	bh=D5fmlYHgu6bInzKbO/gT2e4guhDZrEjqQ5ws5YwiuzQ=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=siyq656o8cmncd3y31qtePqcJa9ofJhnfi9aXTEUxT1vFe5tNSNSssV9f542Uv50Z6TIpo8fl92WXwsBAEpgb8EPxFxoJbw3Y6A7owjQ8RfJWncUavQbLsts2nQVZkrnU7KSjNBC51bEnrEDiqP6N6BpSDw8ZZ7PqjsSPJIyrfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=d46EQSOk; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=FI6i9qFX; arc=none smtp.client-ip=23.251.234.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="d46EQSOk";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="FI6i9qFX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1790267253;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=D5fmlYHgu6bInzKbO/gT2e4guhDZrEjqQ5ws5YwiuzQ=;
	b=d46EQSOkGGx9bamR4JwefsJBQ1eKwA28KIMAPAzZ573Krqd9e8NU1NvrQjmW9v8c
	yf2Nuj1GkHVwQfDfN4XU1BTb+Te2R3fH2IoCSGKj1PX95Co+GZ7veiEYJ3civAA83sc
	k3hrRoLUkPL/EvFO+hTNgqJXaOwjQnasME6Rw6L0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=zh4gjftm6etwoq6afzugpky45synznly; d=amazonses.com; t=1790267253;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=D5fmlYHgu6bInzKbO/gT2e4guhDZrEjqQ5ws5YwiuzQ=;
	b=FI6i9qFXHUW1ISg1dabWpEU2S7cUPbDCMVFAfZEZbdKudrVecA4s26O15AVwygbT
	iFcauHii9NyRYlL+vDuy7I5/r+Zcm4rRWkRystW2rAt/oFlhdhy2NhqXt4+UCaEbx6q
	unlWliEb1dETSBkt4/gq9sPCFxcf9Wf3D/vBqkjE=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <adf11fcf1435728f98b4f94c1821d86b83866c14.camel@suse.com>
From: Kenta Akagi <k@mgml.me>
To: martin.wilck@suse.com, xiao@kernel.org, magiclinan@didiglobal.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	song@kernel.org, yukuai@fnnas.com, shli@fb.com, mtkaczyk@kernel.org
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10
 when using FailFast
Message-ID: <010601a0d43e61ad-9dfd0eee-a057-45eb-b5cd-dfe9d892d4cf-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Sep 2026 16:27:33 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: :1.ap-northeast-1.SskAFE1oaJ7KCjyyJFCV37nkSRmUZttpeGoevLE2CszduPSq19CK0OWqrkMmPMemkYWmFvQfvS6+lCR9ETv8vDWvEFaQZtUQ69n4DuGGNbGH4U7i+CnKWCHWm/HpilUFxPcCpCRFiQTHPHnKlfimqanQj7AjyJ2y8XQuaQGs83Sl+MS5tJ/lS6+Uh2zwyhRo:1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2026.09.24-23.251.234.54



On 2026/09/23 17:29, Martin Wilck wrote:
> Hi Kenta,
> 
> On Wed, 2026-09-23 at 04:08 +0000, Kenta Akagi wrote:
>>
>>
>> Hi Martin,
>>
>> I have not given up on it, but I have not managed to post v7 yet.
>> I still think failfast should be usable even in setups like that.
>>
>> It has been a while, but I intend to resume work on it.
> 
> My thinking is that, in the fastfail case, code to prevent total
> failure could be placed in the end-IO code code path, e.g. by
> attempting a retry directly from the md layer when the last rdev fails,
> instead of setting failing the device. But I haven't thought it
> through.

Hi Martin,

I may be misunderstanding your suggestion, but Neil's original failfast 
implementation already retries a failed failfast I/O to the last rdev. 
But a later change introduced a regression, which I intend to fix.

So the sequence should be:

1. The failfast bios to all mirrored rdevs fail.
2. The first rdev is marked faulty because its bio failed.
3. The other rdev is now the last, so it is not marked faulty.
4. Since the last rdev remains usable, its bio error handler 
   retries the I/O without failfast.

Thanks,
Akagi

