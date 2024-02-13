Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2A21E4A2
	for <linux-raid@vger.kernel.org>; Tue, 13 Feb 2024 10:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707818628; cv=none; b=Pqz86CKHmI50+EJ4dxuYuUGbPFB3ly3J4r6rM2FSf8XqTwgbfLUawpCpodxezLtoI4lRvz6jExGMFEA9A3pA8j1O7YUxQWYU7qouZwcMNSIWieQJJY10IRpDPinlf1NX2FKsS23gFlYiZrZ2r9dZjQZkrTi4tQw4kqpI+XcsWbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707818628; c=relaxed/simple;
	bh=O8pRPh7seuFGBwTrviuKa9VPf1UUFR+keIrQsuu0CQw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S61O2JSV9Nv7klj4QCIvkc86vMKiUZJ85BGTPAcZcauqaLCbi2s1r7n06TJkiKWRqq6AQ38LAkGvrkicQMRDnQdN8FOzcE5zanva3L26YQb71+zKYDF39LlQTbqx9ZP9uOhxHhqrOuUozaJVWzELV7QQrFI8H/Sh8XZzg3WFn1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nF6+YY1E; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nF6+YY1E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707818627; x=1739354627;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O8pRPh7seuFGBwTrviuKa9VPf1UUFR+keIrQsuu0CQw=;
  b=nF6+YY1EgqxtFCOrJY8bvZnLbJIhfuOp4EfmktYETHzNsYDGrt0JcBzI
   Ax38F5e48JvLvpJ2HqH8Vk0NSVX4Vs6GKcHZ7zj2s0rGekqOPuZci7aCp
   C2Rvb/cMS25Y0yX5076W8AJ26a2ybOR5o+oomQndB52sffq7ybKJVglaQ
   ij9EiAhAT5kLCFyEFA0g80R6SJeRLNK1sUOPaDeTGoROUvHLUUziOtkY7
   V7FOejZ7e4yVJ5elU5W9Du9U0To6ooEt8Khn2ZQaVldnkpjZr48xo3wEU
   pLr0gVOJmo+Jdy9fmrzg4fExDmsyxAMKTI0VrHrhsvgdD08MXfW1MJGkf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="12908595"
X-IronPort-AV: E=Sophos;i="6.06,156,1705392000"; 
   d="scan'208";a="12908595"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 02:03:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,156,1705392000"; 
   d="scan'208";a="2890013"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 02:03:46 -0800
Date: Tue, 13 Feb 2024 11:03:40 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Juan P C <audioprof2002@hotmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: missing Levels.
Message-ID: <20240213110340.00003b37@linux.intel.com>
In-Reply-To: <BN0PR20MB4088BAB7BB75BACB62A29567B2492@BN0PR20MB4088.namprd20.prod.outlook.com>
References: <BN0PR20MB4088BAB7BB75BACB62A29567B2492@BN0PR20MB4088.namprd20.prod.outlook.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Feb 2024 18:58:00 +0000
Juan P C <audioprof2002@hotmail.com> wrote:

> Seems odd, there are missing Raid levels.

what is the point here? Why it is odd? Implementation is driven by needs so we
care of what is wanted on the market. We don't have to implement all invented
raid levels.

> 
> dont know the history of linux-raid changes log,
> but seems someone made a bad decision in the past.

Bad decision? I don't think so. You are using strong words as a new person in
this community. Why you are trying to judge was is better? I don't feel that
you are right person to make any statements especially attacking previous
maintainers of this product.

> 
> Let me explain:
> 
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
> 
> #2. RAID2 mode.
> the drive is partitioned in 2.
> 1/4 of the 2TB QLC is used in Raid level=2 mode.
> 
> The reason is to emulate an SLC with QLC.
> Increase speed & longevity by 4x
> By reducing size 1/4.

Oh, here is the trade-off.

I don't think that performance (speed?) is increased because you need to update
multiple chunks to save data which is obviously memory and time consuming.
Full stripe writes are not limited with this solution. At a first glance, it is
a performance killer.

> 
> Real SLC are very expensive & power hungry.
> QLC are cheap.

So you expect features to repair you budget? Well, that is not a purpose of
RAID array. We cares to not make situation worse, not to fix media issues.
It can be done in firmware if needed. We can make some low-cost
optimization but we cannot risk huge performance impact.
 
> 
> Basically 2 Raids in 1.
> Inception.

Did you heard about MD stacked raid or IMSM matrix raid?
> 
> 
> Linux-Raid, should have at least Raid level=2
> To create SLC, MLC or TLC from QLC, TLC, MLC ssd drives.
> 

Go ahead and implement it then, it is open source but.. We will decide if it is
worthy. There is no data that can prove efficient of your solution, it is more
marketing speaking now.

> for example:
> Samsung 970 Pro is MLC "2-Bit" PCIe v3.0
> Samsung 980 Pro is TLC "3-Bit" PCIe v4.0
> Crucial MX500 is TLC, 
> Crucial BX500 is QLC "4-Bit", No Dram. 
> etc...
> 
> Smart Cache Raid is interesting,
> But more complex, 
> would requiere creating a second Journaled log file, or an enhanced version.
> 
> Temp folders are usually better on Ram drives of 4GB.
> 
> There is a ramdrive for linux, with Cache or Not, just drive.
> Called rapiddisk on github.
> By pkoutoupis
> But the lack of Raid level = 2 is devastating for Linux.
> 

It is not devastating, that is not true. You came here to say "I have a great
solution for QLC drive, you have to do this". You cannot demand that. If you
want something you are free to write it and we together will decide if it is
good.

For me, this is a trade-off between performance, size and nvme lifetime. There
are reasons why RAID2 is dead, binary layout is not efficient. Dividing raid
array into 3/4 for data and 1/4 for RAID2 seems weird to me.. Why not 3/5 and
2/5? It is always trade-off between multiple factors. You care the most about
SSD lifetime, I have different opinion and I see performance as crucial.

Thanks,
Mariusz
