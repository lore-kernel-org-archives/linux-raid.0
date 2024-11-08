Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07401D356C
	for <linux-raid@vger.kernel.org>; Fri,  8 Nov 2024 09:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731057292; cv=none; b=uMWZDAhUMs6Jn0KfrlFFuLwK2m4q4EWG7db4oxsokx2+uESkXKb0hjSMUz7235WW9TKDAZarI96n60SEC1n45L9+rEsy/8zSdgHkkJnCkorPrXDxEEZBJUbfcvg5HEWqoIuPep6MDQAV50jl2V6bU06Azn3svhfTjak5o1KqffU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731057292; c=relaxed/simple;
	bh=c8koVKN0B6Zq+aF5Q6bhMH5HZPqXyOyzat0DNrkiMSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVhNVtjAeEDBoXIBPdhauO9Tc85bezXTamlvMEcxpiVncX8jPFRAFb0/0K099gZlmHDYCuzha8Wg0XHCioyKwFe+fmUsczBlVsJ+cyWKKXX8ZIm4IPY4zsAGIPueKSi41FWnlm8hM+nqteiuo5T7DxaClys3Q9Dt096+IAqHVoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.2] (unknown [95.90.242.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 50497600AA6A1;
	Fri, 08 Nov 2024 10:14:16 +0100 (CET)
Message-ID: <48c541c0-0530-4d8c-8cbe-566ca664b242@molgen.mpg.de>
Date: Fri, 8 Nov 2024 10:14:15 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/3] mdadm: remove bitmap file support
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org,
 yukuai3@huawei.com, yangerkun@huawei.com
References: <20241107125839.310633-1-yukuai1@huaweicloud.com>
 <20241107125839.310633-3-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20241107125839.310633-3-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Thank you for your patch.

Am 07.11.24 um 13:58 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Because it's marked deprecated for a long time now, and it's not worthy
> to support it for new bitmap.

It’d be great if you added the commit marking it a deprecated.

Also, could you please elaborate on why bitmap file support is removed, 
and what users should do, who are currently using it?

> Now that we don't need to store filename for bitmap, also declare a new
> enum type bitmap_type to simplify code.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   Assemble.c    | 33 +-----------------
>   Build.c       | 35 +------------------
>   Create.c      | 39 ++++-----------------
>   Grow.c        | 94 ++++++---------------------------------------------
>   Incremental.c | 37 +-------------------
>   bitmap.c      | 44 +++++++++++++-----------
>   config.c      | 17 +++++++---
>   mdadm.c       | 76 ++++++++++++++++++-----------------------
>   mdadm.h       | 18 ++++++----
>   9 files changed, 99 insertions(+), 294 deletions(-)

[…]


Kind regards,

Paul
