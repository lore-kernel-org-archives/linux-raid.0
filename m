Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA062379C43
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 17:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783706066; cv=none; b=YwGS3cxIXBBxQOLiItqcFTVl/o8MwLqs6Ub+jnm8PmUED/NDXQcfu2IyUPqgJGbeoRp0E1Ng66sXiHPEP/pIXc5hD4XsKVWI+Uq+exsobsgd57BeFbMFdSGkA4KXh/7oonFcVQk/6QnLEOS2Vi3pFWetJhHiArFqUt94jOXVo7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783706066; c=relaxed/simple;
	bh=wvaqtvCvWS6xsAQNv2MOkjd3OXslkqEhWgMr/A8+3W0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wpd32i1DtMmoxDzkod7zEh4ZR7OBCuYNR9PH1EZeYn8vPN6DizaROGC4LoCt3Jc/SPRcUDNrT83ADX581LwwvmR5vvHMyg8EqWDGW2OCKncoZ7lp1oi6FACj2hlU38wA6hUODSlNNibYAcf5nRikgZP9Q102i3MViDd5n6VaAIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=fail smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=youngman.org.uk
Received: from host86-157-72-216.range86-157.btcentralplus.com ([86.157.72.216] helo=[192.168.1.70])
	by smtp.hosts.co.uk with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1wiEkQ-0000000GHEW-0frN;
	Fri, 10 Jul 2026 18:10:46 +0100
Message-ID: <811c24a5-0c72-4b83-af19-609e42e12613@youngman.org.uk>
Date: Fri, 10 Jul 2026 18:10:47 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LBS setup
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
References: <ahLSj1Ua5WJ0GTgY@lazy.lzy> <alEb50Nmqt8IW2Nu@lazy.lzy>
Content-Language: en-GB
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <alEb50Nmqt8IW2Nu@lazy.lzy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/2026 17:20, Piergiorgio Sartor wrote:
> Hi again,
> 
> not sure, but has anybody comments
> on the topic?

I don't understand what you're asking, but I do think I remember the 
events you're talking about.

Basically, some change accidentally slipped into the wild with a kernel, 
probably a 6.x, and people started creating kernels with the new kernel.

Then, as people started upgrading kernels, they suddenly realised that 
this change affected the raid format, such that  new kernels couldn't 
read old arrays, and vice versa. More importantly, and more dangerously, 
it led to arrays being trashed!

What to do? They couldn't pull old kernels obviously, there were too 
many arrays out there. They couldn't pull new kernels, there were 
already some arrays out there.

So they rushed out a fix, such that if a new kernel created an array, it 
flagged it as being a new array. If you booted a new kernel with an 
array that didn't have the flag IT WOULDN'T LOAD THE ARRAY. And they 
trusted to luck that people wouldn't downgrade an array and try to load 
a new array on an old kernel.

So this now meant that all of a sudden new kernels wouldn't boot on old 
systems, until the user explicitly set the flag on the array to say 
"this is an old-style array". If they happened to be upgrading from one 
of the few early new-style kernels, they could set the flag to "this is 
a new-style array".

Point is, this code was meant to make it very hard to upgrade your 
kernel without being prompted what sort of array you had, so that the 
kernel devs could try to ensure you didn't lose your array.

A pretty awful way of doing it, but nobody could think of anything better.

Hopefully that explains what's going on there, and you'll be able to 
work out your own answer from this information.

Cheers,
Wol
