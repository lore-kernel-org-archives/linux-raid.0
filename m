Received: from mail1.g17.pair.com (mail1.g17.pair.com [216.92.2.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDF3163
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 04:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.92.2.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756961688; cv=none; b=RMQIK2coqrPdBI+tzL194ptahXh10COBvWHzikp2zw7VzLoqr0Mzx6kqU6ml2xk9ve5IAmM9PFtfjxFWN1nUwEzPvR3Dgrxv0PNHsGWbQX7ZZIDeOy3y4ZlPqB1g5V9dYcdAVuD25QbtIjxSTNfvBc5PUCHxUYSx9rdPuMfEnfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756961688; c=relaxed/simple;
	bh=jXt9aZvE0+bNgdMxwQzJkAhuUm43Uz21YgAR/efKSy8=;
	h=To:From:Subject:Date:Message-ID:References; b=bvGj1xNemgbvTCTDwukbNqAKSA2/CjVDuSrSYXAFgNL6SY4kpSCBNJOsDF66auUgkpsz5skNQENAOSnVyTfq5hUTAmLyry9U2vQbOhpXUtUakUzzeOZP44LFnxYBWvDpQjbX6c3DyOgbIORm5DU7oSspJeqZaXs5ohduo2HTkzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cjsa.com; spf=pass smtp.mailfrom=cjsa.com; dkim=pass (2048-bit key) header.d=cjsa.com header.i=@cjsa.com header.b=Qrbdl/Rw; arc=none smtp.client-ip=216.92.2.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cjsa.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cjsa.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cjsa.com header.i=@cjsa.com header.b="Qrbdl/Rw"
Received: from mail1.g17.pair.com (localhost [127.0.0.1])
	by mail1.g17.pair.com (Postfix) with ESMTP id 82B231682D2
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 00:54:44 -0400 (EDT)
Received: from dymaxion.cjsa2.com (c-67-168-59-2.hsd1.wa.comcast.net [67.168.59.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g17.pair.com (Postfix) with ESMTPSA id 405E91682C8
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 00:54:44 -0400 (EDT)
Received: from dymaxion.cjsa2.com (localhost.cjsa2.com [127.0.0.1])
	by dymaxion.cjsa2.com (8.18.1/8.18.1/Debian-2) with ESMTPS id 5844sgkQ273892
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Wed, 3 Sep 2025 21:54:43 -0700
Received: (from news@localhost)
	by dymaxion.cjsa2.com (8.18.1/8.18.1/Submit) id 5844sgYP273867
	for linux-raid@vger.kernel.org; Wed, 3 Sep 2025 21:54:42 -0700
To: linux-raid@vger.kernel.org
Path: jeff
From: Jeffery Small <jeff@cjsa.com>
Newsgroups: local.linux.raid
Subject: Re: What is the best way to set up RAID-1 on new Ubuntu install
Date: Thu, 4 Sep 2025 04:54:42 -0000 (UTC)
Organization: CJSA LLC
Distribution: local
Message-ID: <109b62i$e2l$1@dymaxion.cjsa2.com>
References: <109aahg$34jlp$1@dymaxion.cjsa2.com> <37f99719-4bb1-489c-8246-e6dffc8b0bf9@youngman.org.uk>
User-Agent: nn/6.7.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjsa.com; h=to:from:subject:date:message-id:references; s=pair-202402141545; bh=lsv1e9wrL0O5Vh02Bx8a4Di92eG8DMtsSSl8G1dg26g=; b=Qrbdl/RwxTrqslqUVWIgl3dFe3em69Ix7hRK9NpBCBsLB8+G1gWwYNswSMH6WKF0H/Cxasn62x8Jeh600PJj9w6sSXFUu+TvEJ45EQ19EfNcFhzj5loI/oQ1P//VqgfzU58eBar88slQ6q22Nrcc8MBrq9l+i8AvfeQCrZ8PUc94oKBoFi5Sfjk4xA0OqC0DxgwnDEQNrpcY4hoqTlVt4sB11TnLikvUEchE550KCt2eXdlda5wO6hzliNDWmglhVZ28S3VytyQCCWEhDQZbdynSbNmiGfZvWgQBoBxKWQeA0n3UnLSvGFErbE0T2Tl8A7EcesBZQ0mIwdRIvKyqBg==
X-Scanned-By: mailmunge 3.10 on 216.92.2.65
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Wol <antlists@youngman.org.uk> writes:

>On 03/09/2025 22:04, Jeffery Small wrote:
>> I will be installing Xubuntu 24.04.3 on a newly built system having two
>> 4TB Samsung M.2 SSDs which will be mirrored using RAID-1.  My question is
>> what is the better way to set up the mirror.  I'll have 128GB of RAM and
>> will be using a swapfile after installation.
>> 
>> Method #1: After the UEFI partition is created on both disks, create GPT
>>             /boot, / and /home partitions on each SSD and then create
>> 	   three separate mirrors:
>> 
>> 	   md0: /boot
>> 
>> 	   md1: /
>> 
>> 	   md2: /home
>> 
>> Method #2: After the UEFI partition is created on both disks, mirror md0
>> 	   using the rest of the free space.  Then create GPT partitions
>> 	   directly on the mirror:
>> 
>> 	   md0p1: /boot
>> 
>> 	   md0p2: /
>> 
>> 	   md0p3: /home
>> 
>> This will be a straightforward desktop workstation, with no encryption or
>> support for multiple OS installs.  Are there advantages or possible pitfalls
>> with either approach?
>> 
>> I'm also considering eliminating the boot and home partitions and just
>> using a single root partition which feels strange after using UNIX for over
>> 40 years. From a raid perspective does this also have advantages/pitfalls?
>> 
>DON'T mirror /boot. Unless you use 0.9 layout. It just makes setting up 
>the boot more complicated. If anything goes wrong, 0.9 allows you to 
>boot with no raid support.

>128GB of ram? Why bother with a swapfile? Okay, I would create two 128GB 
>swap partitions and set them equal priority, but that's me.

>And what are you doing about /var? Does it really belong in the / partition?

>With a 4TB setup, especially with a workstation, combining /, /var. and 
>/home might be a sensible option. As I say, keep /boot out of it, but a 
>single 3.5TB partition for everything else makes a lot of sense. How 
>likely are you to run out of disk space? Highly unlikely? Then go for 
>it! Remember most of the advice about Unix partitioning stems from the 
>fact that K&R or T or whoever it was created the initial partitioning 
>scheme simply because they were running out of space on a (by today's 
>standards) tiny disk drive. Why stick with what they were forced to do?

>Cheers,
>Wol

Wol, thanks for the reply.  What is a 0.9 layout?  I've never heard of
that before.  I'm confused about why to not mirror the boot partition.
Other articles I've read on the subject suggest doing this.  What is the
problem?

Now maybe we are having a communication problem mixing up the initial
UEFI partition (mounted at /boot/efi) which does get set up on each SSD
independently and is definitely NOT mirrored, and the actual boot partition
(mounted as /boot) which is where GRUB and kernel are installed.  If I
made one big mirrored / partition, /boot could just be included along with
everything else.

As I say, I'm just trying to avoid future problem from something that I
didn't anticipate from the start.

Regards,
--
Jeff
