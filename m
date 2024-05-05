Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B6243AA5
	for <linux-raid@vger.kernel.org>; Sun,  5 May 2024 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714929786; cv=none; b=JSfDnT1EmvmqS88LH0gQ7em/i6AufDixNo9l0HemdPTH9muCCVeECgKMEsezgXuwBjmdvPWurmeh9LnAn7FO+PXPY1K4LyUZ9VfkjRI+q8hZV+ukfXBwH8q9wWyogZtrt781k33QsoazWRNOHxbsCgoggbkEXUn+tc31O4LAiHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714929786; c=relaxed/simple;
	bh=bnoHsnrVGcZrl3WQo0QmE45uP04oPIPyc1AK9S+t5zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZ4rX/daMIwMbB5E7lhHMefd5c5A8VZ6f7MH3z/qL9IRMbb5ZNMbcMylpMyv9tzXosOAn96vTwefi6jd5K9x/zP7KUTRwu6RxfoQR7skt2NSyEdkt5yAHC9w0R1bi28h1zQSzQKDAPPFyCLAQEoNDmsh8HuGYMCUmlj0zzGp31A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.2] (ip5f5af438.dynamic.kabel-deutschland.de [95.90.244.56])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id DA34061E5FE05;
	Sun,  5 May 2024 19:22:37 +0200 (CEST)
Message-ID: <4ddf4e3b-cdf0-4e15-8070-42b20253eeca@molgen.mpg.de>
Date: Sun, 5 May 2024 19:22:34 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Makefile: add USE_PIE
To: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc: Jes Sorensen <jes@trained-monkey.org>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, linux-raid@vger.kernel.org
References: <20240505133923.267977-1-fontaine.fabrice@gmail.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240505133923.267977-1-fontaine.fabrice@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Fabrice,


Thank you for your patch.

Am 05.05.24 um 15:39 schrieb Fabrice Fontaine:
> Do not hardcode -pie and allow the user to drop it (e.g. PIE could be
> enabled or disabled by the buildsystem such as buildroot)

This sounds reasonable, but it changes the current default behavior, 
doesn’t it? Could you please elaborate, when this was added, and if the 
new default would break systems?

A formal nit pick for the commit messages would be to please add a 
dot/period at the end of sentences.)

> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> ---
>   Makefile | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 7c221a89..a5269687 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -137,7 +137,11 @@ LDFLAGS = -Wl,-z,now,-z,noexecstack
>   # If you want a static binary, you might uncomment these
>   # LDFLAGS += -static
>   # STRIP = -s
> -LDLIBS = -ldl -pie
> +LDLIBS = -ldl
> +USE_PIE = 1
> +ifdef USE_PIE
> +LDLIBS += -pie
> +endif
>   
>   # To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
>   ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))


Kind regards,

Paul
