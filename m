Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A64946B8B
	for <linux-raid@vger.kernel.org>; Mon,  4 Mar 2024 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709564468; cv=none; b=YGrY02rZXlBHhO/TqhKGtrTESCEbvAKUN1yTv3U1dIt97c9Unnj2+LQsewmq4/D4u/NGo7RbRItSbCyLC+kfWhTq2hCmFKUju31iopVokb5bRBpz6a+AFp0sUMj0A9bgB+t3zRYvhCscV2qsnr6N9dIGcNlnq65rV2RuypcOREI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709564468; c=relaxed/simple;
	bh=gudjzYHutrrl1pDWYjaVVbYekNWuJO9I8LuZFggfMa0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KR+kUkiZGPZWuyeofXKtJd4I2Rmn9ZpXqZ+IQm5TNEbr/RfsFizb26uiEyo1W5IQ/NfBoRiJZouqVQM17RPZUkI2f8Hpfjj8Q8j9Jqz81diI/b0jzKSGjHTz44nCH0Lc1mKIskq5rZMWrSfVCioJZVD3/EyTrrOY7H3/5UVAKqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iYrVYos8; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iYrVYos8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709564466; x=1741100466;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gudjzYHutrrl1pDWYjaVVbYekNWuJO9I8LuZFggfMa0=;
  b=iYrVYos8eZFEkYhizkkwzVE5jk67U70zAvKiYBgpINFlrdE9zkpJVqlE
   i3dNDIp3s7BpTCaNUa+g+R9tKQwPkqUwsS4D8kgu4Voju8olTEuqnOdIN
   wft5TD2RupAA4d5CvJpfqVV0ptYQ5GUm5TxG0o+45xgEwfypKm16irAzG
   3qygJ9SDPG4VGgEeZMrDA2oQPH6DG4Kzd8Nq6H9gBKRVyy+sbDLII6Z69
   MXdU+dITWtvufo9d+FiyKay1MqT8k6Mie79vj30sV7+L4Vf65bT6sWncU
   KUPiub/0faEbM2+Ys7H4RYc1g7r8cucu5AUjlgM3uQbuMbxk+3qjLX6UL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="3914863"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="3914863"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 07:00:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="8967318"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.43])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 07:00:56 -0800
Date: Mon, 4 Mar 2024 16:00:51 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: mdadm 4.3 rejects /dev/md128 and larger numbers
Message-ID: <20240304160051.000037a7@linux.intel.com>
In-Reply-To: <ZeXKYbxagk7SD0UH@metamorpher.de>
References: <ZeXKYbxagk7SD0UH@metamorpher.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Mar 2024 14:19:29 +0100
Andreas Klauer <Andreas.Klauer@metamorpher.de> wrote:

> Hello,
> 
> since mdadm 4.3, trying to use numbers larger than 127 results in:
> 
>   mdadm: Value "/dev/md3032" cannot be set as devname. 
>   Reason: Not POSIX compatible. Value ignored.
> 
> Because in util.c :: is_devname_numbered() (commit 25aa73291):
> 
>   if (val > 127)
>     return false;
> 
> The kernel seems to be fine with MINORMASK (2^20 - 1).
> If so, instead of 127, the limit here should be 1048575?
> 
> I don't need a million arrays. But I do have more arrays than 
> average because I use partitions instead of one big array 
> for everything. And some flexibility in using distinct number 
> ranges per group of arrays makes /proc/mdstat easier to read.
> 
> Regards,
> Andreas Klauer
> 

Hello Andreas,
Indeed, that it the case I missed. Sorry for bringing regression.

In the longer term, for better user experience I would like promote conception
called "named arrays", so could you please try to create "/dev/md/md_3032" and
test and see if that works for you?

The difference is that you will not be restricted to numbered devices, you can
also use asci letters like: "md_myarray", "md_do_not_touch".

Of course, it is kind of regression so I'm open to fix it for you but if I will
be able to convince you to use named arrays format (and help me fix issues!)
then whole community will gain.

You have to enable it first, but please note that it is not widely used now:

echo CREATE name=yes > /etc/mdadm.conf

Please test it and let me know!

Thanks,
Mariusz
