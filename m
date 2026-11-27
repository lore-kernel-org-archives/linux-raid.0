Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=141.14.17.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795771561;
	b=fqhQpgIspCRqWeWf9S3YlvUG/xd8Hvj6x7xdzwNnwKGJ5O8C5ncxBAW8gUcfyWnvxcRw
	 bfbKtOWChxY0phj7nfnguk5qqNMog/3b2h9ErdDS3R+Xm+PhiZDB3JRJELU/2McJH0qCF
	 LwAAgnNG34aW2rf1GR+24zbN3XeXOW//6BEzD3k0pxHcTitJLz7iyczvFDZhuNnwcOvW/
	 e+jszHNLdvBqReDElt2kdvpk8Tna5pNLuH9xo46siBINRN58cMLDCo724HASOXXG+2fJR
	 6vQjFOK5NDCuCm00hhK70z4r0m/b4p8/TilSpQHk0grMTONwjpdzO3Asz7o4/WyiI7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771561;
	h=DMARC-Filter:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:DKIM-Signature;
	bh=M7iOEXxeOOVBAEHIvYftyFT0gfk/utBYXJJcaTFZH8g=;
	b=pM1FZ+Lr4RYxqcGp8M1Dk7s7eFaxrmf00IGlmjWYBTD87OeKTT2qsYrqB0I9Ioqv1uAt
	 q9GiNP24TtidarM1Phwlf7WoHSSAwI7brKXa11ldUUIZsPJHHs+gg2ol0TwWe+IBc2tJK
	 KqO7WnL2O2503RuU/VFzCeCjPqpMPhbOHJwlypVtSgVJHoxF1xt1j6RjqVJQJb5899fUq
	 YJZMrsnEBi2jsfO6BK/Zk56uIKuh7TC4U2lZafRUIN6P9WaezcXiGejEbHaRUBay0vPcW
	 y7QC1ErI7F8zf1OMTQexTX+b3jwY9S1M4ShYQPejH4K2ASEciRJtj/hxeXTMQMyfWGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=molgen.mpg.de;
	spf=pass smtp.mailfrom=molgen.mpg.de;
	dkim=pass header.d=molgen.mpg.de header.i=@molgen.mpg.de header.a=rsa-sha256 header.s=20260906 header.b=Enq6ANa6;
	arc=none smtp.remote-ip=141.14.17.11
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2088B606A31C;
	Fri, 27 Nov 2026 09:25:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2088B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=molgen.mpg.de header.i=@molgen.mpg.de header.a=rsa-sha256 header.s=20260906 header.b=Enq6ANa6
Received: from [192.168.44.124] (unknown [185.238.219.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 40DC74C2F400F4;
	Fri, 27 Nov 2026 10:23:34 +0100 (CET)
Message-ID: <39caa86d-91ef-41be-ab28-38e9c5bc8436@molgen.mpg.de>
Date: Fri, 27 Nov 2026 10:23:30 +0100
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] MAINTAINERS: Change email address
To: Ni Xiao <nixiao@fygo.io>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org
References: <20261127092024.79116-1-nixiao@fygo.io>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20261127092024.79116-1-nixiao@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=molgen.mpg.de; s=20260906; 
	t=1795771414; 
	h=from:from:subject:date:message-id:mime-version:content-type:content-transfer-encoding; 
	bh=M7iOEXxeOOVBAEHIvYftyFT0gfk/utBYXJJcaTFZH8g=; 
	b=Enq6ANa6Rtpat6ZXaGN40hIWS81av2b9LaWVFb/wOFY1z8pKPyBjnRWnUHpsJ+qXREn45pO7QQLn
	m7r9TB6wPeP5yaZg5g0/wT2csXbiUOaLIhcu6tXcYzAyzjG+Y5G1/FszDIRyHLWB/z8PR2qjQKOyYr
	JrSyNXGRECEUmQ6pl7kieea2xZImnmqKKIcP96yqUwIqp5PJQnsaFOJq4y2qBOa050Wy0wqMr7hEI9
	uYjkDc+ulG8c34zpTY1v3oymCp2w6DQP8em0V7seDezoAfq6tM+WihidIt6cRnF4+HsanP86SeKg42
	RWiOm1q0KBf/lRiVQ7T7duTDvmYlnwGg==

Dear Ni,


Am 27.11.26 um 10:19 schrieb Ni Xiao:
> Use new email address.

For the short log, I’d add your name to the summary/title:

MAINTAINERS: Update Ni Xiao’s email address

> Signed-off-by: Ni Xiao <nixiao@fygo.io>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c72a281a8167..6bbee57334b1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26061,7 +26061,7 @@ SOFTWARE RAID (Multiple Disks) SUPPORT
>   M:	Song Liu <song@kernel.org>
>   M:	Yu Kuai <yukuai@fygo.io>
>   R:	Li Nan <magiclinan@didiglobal.com>
> -R:	Xiao Ni <xiao@kernel.org>
> +R:	Ni Xiao <nixiao@fygo.io>
>   L:	linux-raid@vger.kernel.org
>   S:	Supported
>   Q:	https://patchwork.kernel.org/project/linux-raid/list/

Either way:

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
