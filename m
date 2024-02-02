Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A3814A4DE
	for <linux-raid@vger.kernel.org>; Fri,  2 Feb 2024 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706895017; cv=none; b=NSE3LoaLiU9Q1ELZoaRSnYVRU5dhEU2rSBQNAUp+OlrRalmBe4v4DSDYHM9uTiu/KaXMg/gmw5iT1H+ocejd/bL34rQF8QrghiI6SaQmDp8LxfXajNTFqurmorQObgw7ZAXcn55A1VU5bEnuf3CbNo24EVnAIciANgeCgf4WnB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706895017; c=relaxed/simple;
	bh=J6nZBkTbo5c2pRDHQ1rk9s8u2ECzBxneTtNEXoUTmto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YDsOuSBW8SdHTwsg0e0XGNOC/w5Pii/MK7ATpWv5fhfXXybWXR3giYNkswz5b7YAFAd60n12NWVH31GWn0Za7VgUbZYie8QAt+FTTtzX+39yByCADq3QDYEbK5OJ4LWco0ZFrq2iyWi5x0Zcg87oVoiQMTmfsc8sTI25OhTVLeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.6] (ip5f5af6ca.dynamic.kabel-deutschland.de [95.90.246.202])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7312461E5FE01;
	Fri,  2 Feb 2024 18:27:05 +0100 (CET)
Message-ID: <a4644fb9-17a8-4868-b9d0-11e58707d363@molgen.mpg.de>
Date: Fri, 2 Feb 2024 18:27:04 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] Revert "Fix assembling RAID volume by using
 incremental"
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
References: <20240202163835.9652-1-mariusz.tkaczyk@linux.intel.com>
 <20240202163835.9652-2-mariusz.tkaczyk@linux.intel.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240202163835.9652-2-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Mariusz,


Thank you for the patch.

Am 02.02.24 um 17:38 schrieb Mariusz Tkaczyk:
> This reverts commit d8d09c1633b2f06f88633ab960aa02b41a6bdfb6.

It’d be great if you elaborated. What regressed, and how can it be 
reproduced?

> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>   Assemble.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)

[…]


Kind regards,

Paul
