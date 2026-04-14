Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CE92222CC;
	Tue, 14 Apr 2026 06:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776147541; cv=none; b=rMNWwGXh+khihMH8X8Jc2Q46kHMhowmY4WaA6CDFEqmI9I4NzCfnqQ0tdhARV6jwXgIDA+agxZuT93lPKqZsaD1rhuIUpe4J8ZmAla0Qea4EKAuLCm0VTi/VrTfxv9rgUbf1W8PPfuYltPmO655YAAqlvE7QshuOn/JMO8ANxtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776147541; c=relaxed/simple;
	bh=ngODkepm1HkUiDtuRCmM5mk6Uf5Kj3LaLwpJzYfpDm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GKwDQm8SK8sbAah19UtvFnO6+QC3Yc78eoY5TCyGeNp8qaiGjKY1HUEr+Q/gUWOHBoaj12njjxWuX9tnoszu3EO1OYgRHACPDsoglhzjVH+IZabVzEmSRjb+2LWSMCv6o4eF4MzC8nf7YI48EvQqI0Bd9ac9rMfk913+KSOD/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af0da.dynamic.kabel-deutschland.de [95.90.240.218])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7FAEC4C28871A7;
	Tue, 14 Apr 2026 08:18:18 +0200 (CEST)
Message-ID: <87436798-a723-4451-9b96-5762fb25ddcc@molgen.mpg.de>
Date: Tue, 14 Apr 2026 08:18:15 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] MAINTAINERS: Add Xiao Ni as md/raid reviewer
To: Xiao Ni <xiaoraid25@gmail.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan666@huaweicloud.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260414022956.48271-1-xiaoraid25@gmail.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260414022956.48271-1-xiaoraid25@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Xiao,


Am 14.04.26 um 04:29 schrieb Xiao Ni:
> From: Xiao Ni <xiao@kernel.org>
> 
> I've been actively involved in the md subsystem, contributing bug
> fixes, performance improvements, and participating in code reviews.
> I will help improve patch review coverage and response time.

Thank you for doing this.

> Signed-off-by: Xiao Ni <xiao@kernel.org>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3adc870d523b..dca564db7cfa 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24562,6 +24562,7 @@ SOFTWARE RAID (Multiple Disks) SUPPORT
>   M:	Song Liu <song@kernel.org>
>   M:	Yu Kuai <yukuai@fnnas.com>
>   R:	Li Nan <linan122@huawei.com>
> +R:	Xiao Ni <xiao@kernel.org>
>   L:	linux-raid@vger.kernel.org
>   S:	Supported
>   Q:	https://patchwork.kernel.org/project/linux-raid/list/

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
