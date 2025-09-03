Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DE02EBB83
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 21:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756935175; cv=none; b=M84x9cIYZuuu2JUdAxIIYxv7aucr0uDa3MXQzx9P/jL5DdG4St1zV+mdbL1pcoDtTO5NlgsXamoFYWDOlFJ1eKkbajfNXsk+ooUztfXKe2cv4aNYo0Lo9H11zW9m5s7u2ST1t86vqTrLWPi0Zz3jvykeR9PvjMwbeZlQdQPomZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756935175; c=relaxed/simple;
	bh=BPalHFa1TAgUDXwHzGxVcX4rYzqY+upy8GhU+yW8fDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N6bah5E5VNul3+E/S9Fh87aqyV99S+QjStIpSMt9M2TexZh9wASHLsVvaVSTSo1AuEkbtZ3ZaadxgrD0zbewsxZe7Y1d8zsV2A1DbtDRVWA2dLXi8BklQBOSn2UdPlaVbUygmEl9Etk56FH0NI2D26bPe66BBKBF4ZJ9ZiQZcdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=fail smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=youngman.org.uk
Received: from host51-14-94-149.range51-14.btcentralplus.com ([51.14.94.149] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1utv63-00000000AOE-6Pr3;
	Wed, 03 Sep 2025 22:32:51 +0100
Message-ID: <37f99719-4bb1-489c-8246-e6dffc8b0bf9@youngman.org.uk>
Date: Wed, 3 Sep 2025 22:32:50 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: What is the best way to set up RAID-1 on new Ubuntu install
To: Jeffery Small <jeff@cjsa.com>, Linux RAID <linux-raid@vger.kernel.org>
References: <109aahg$34jlp$1@dymaxion.cjsa2.com>
Content-Language: en-GB
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <109aahg$34jlp$1@dymaxion.cjsa2.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/09/2025 22:04, Jeffery Small wrote:
> I will be installing Xubuntu 24.04.3 on a newly built system having two
> 4TB Samsung M.2 SSDs which will be mirrored using RAID-1.  My question is
> what is the better way to set up the mirror.  I'll have 128GB of RAM and
> will be using a swapfile after installation.
> 
> Method #1: After the UEFI partition is created on both disks, create GPT
>             /boot, / and /home partitions on each SSD and then create
> 	   three separate mirrors:
> 
> 	   md0: /boot
> 
> 	   md1: /
> 
> 	   md2: /home
> 
> Method #2: After the UEFI partition is created on both disks, mirror md0
> 	   using the rest of the free space.  Then create GPT partitions
> 	   directly on the mirror:
> 
> 	   md0p1: /boot
> 
> 	   md0p2: /
> 
> 	   md0p3: /home
> 
> This will be a straightforward desktop workstation, with no encryption or
> support for multiple OS installs.  Are there advantages or possible pitfalls
> with either approach?
> 
> I'm also considering eliminating the boot and home partitions and just
> using a single root partition which feels strange after using UNIX for over
> 40 years. From a raid perspective does this also have advantages/pitfalls?
> 
DON'T mirror /boot. Unless you use 0.9 layout. It just makes setting up 
the boot more complicated. If anything goes wrong, 0.9 allows you to 
boot with no raid support.

128GB of ram? Why bother with a swapfile? Okay, I would create two 128GB 
swap partitions and set them equal priority, but that's me.

And what are you doing about /var? Does it really belong in the / partition?

With a 4TB setup, especially with a workstation, combining /, /var. and 
/home might be a sensible option. As I say, keep /boot out of it, but a 
single 3.5TB partition for everything else makes a lot of sense. How 
likely are you to run out of disk space? Highly unlikely? Then go for 
it! Remember most of the advice about Unix partitioning stems from the 
fact that K&R or T or whoever it was created the initial partitioning 
scheme simply because they were running out of space on a (by today's 
standards) tiny disk drive. Why stick with what they were forced to do?

Cheers,
Wol
