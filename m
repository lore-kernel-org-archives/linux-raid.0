Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62723B799
	for <linux-raid@vger.kernel.org>; Mon, 12 Feb 2024 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.238.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707754763; cv=none; b=L0OF976nsaD2zpolULzVdzygLfM5pNb75fFOnrMRhTzeDDXvcuXzRfKnsUC7NtHkV1vywbeY61cRZsnFLRZxMuS3fYRW1wtEF38EyXfr8nSrADqk7N2/nML00vq3GAfp/gJqKfmTa81/QfMyjnvDZhq9jzC7oL2w/J4BD1nMR9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707754763; c=relaxed/simple;
	bh=6INu10iYBY7hxtmL++lS6NKnEGmkakm/bIsKIDZSflc=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=F3xwemPrU3mt6YFPAMiHl9YFs19uDJ1HPvLay3RaADSNw5thh8k8maauFcVWqaAobv2/ZrNVtLUrpPXBYTYWRmOLicvLPerylD50V9TwQMamP+xTsfs/akbc07w2+ZjadKNheWOwahugFTWzfMIocqFUELdobpqGXRucUe5xJhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net; spf=none smtp.mailfrom=vps.thesusis.net; arc=none smtp.client-ip=34.202.238.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=vps.thesusis.net
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id B511D230DF; Mon, 12 Feb 2024 11:19:15 -0500 (EST)
From: Phillip Susi <phill@thesusis.net>
To: Juan P C <audioprof2002@hotmail.com>, "linux-raid@vger.kernel.org"
 <linux-raid@vger.kernel.org>
Subject: Re: missing Levels.
In-Reply-To: <BN0PR20MB4088BAB7BB75BACB62A29567B2492@BN0PR20MB4088.namprd20.prod.outlook.com>
References: <BN0PR20MB4088BAB7BB75BACB62A29567B2492@BN0PR20MB4088.namprd20.prod.outlook.com>
Date: Mon, 12 Feb 2024 11:19:15 -0500
Message-ID: <87o7clmz98.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Juan P C <audioprof2002@hotmail.com> writes:

> Enmotus FuzeDrive 1.6TB its actually a QLC 2TB M.2 NVMe PCIe
> that Requires Windows Raid drivers.
>
> Has built-in different technologies, All-in-one.
>
> #1. Smart Cache RAID mode...
> Small fast SSD + Larger HDD.
> Similar to intel Optane or Apple Fusion Drive,
> But both solid, smarter,
> defrag the ssd,
> moves most access files to Cache drive,
> and files with less access to Main/Large storage.

Caching isn't RAID.  If you want caching, see dm-cache or bcache.

> #2. RAID2 mode.

RAID2 isn't something that really exists in the industry.  According to
wikipedia, it was once used to refer to a bit level, rather than block
level type of striping with parity.  These people seem to be making up
their own system and it sounds like snakeoil.

> the drive is partitioned in 2.
> 1/4 of the 2TB QLC is used in Raid level=2 mode.
>
> The reason is to emulate an SLC with QLC.
> Increase speed & longevity by 4x
> By reducing size 1/4.

I can't tell if you are talking about one drive, or two.  You can't
magically speed up a single drive nor increase its longetivity.

> Real SLC are very expensive & power hungry.
> QLC are cheap.
>
> Basically 2 Raids in 1.
> Inception.

Which two?  raid10 is "2 raids in 1" ( raid0 and raid1 ).
