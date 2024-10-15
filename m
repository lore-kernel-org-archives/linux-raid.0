Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D464A1F6690
	for <linux-raid@vger.kernel.org>; Tue, 15 Oct 2024 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729014107; cv=none; b=ZnrZzpGGdmY/KKTeTk7u8h6HbarUJikxMH1iR5lv6UHhYKa6q3M+JaoXO15xkyMbMfmyddPj73XbdxC5CArTFGpwKy2I2D6Ydo8bM0vxd6MSvEJQee86kWAhztDefKaL9m2K3D3PgNKwfPLJCbIx4jM83wlJuF8SJPhSvUlSnIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729014107; c=relaxed/simple;
	bh=BRhKg7We4y2dEZ9+iGR0mYXxpUcxayzORLNlkThWr7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sJSRDvtV93AgjqtsJzYrmZnn5P/TDF1FlIu3HAk8dvybRRU1s7PSFXuGcSJEVPZ5NYTKgUs9+Ksud9dDQJKfZeqykfpACGG+4bWFJAPADUW9WnZ7BLdFQyU1xMIs0nwuWq2wBqyHSbbHxi1iuxsGSBGmrd8BV0zz2OXpJ84dV1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0zHUic0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0zHUic0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729014103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gyuy+g9+FENpJ6Zj4WgRyTm38+Oy+xaRvvGY3wiwXD4=;
	b=N0zHUic0YdlB+Z5I43fzXK7M9AAhRf6aFCbqaMT6HGWXRXTH5ypn+kyMqcLms+Tj73pu3/
	g0Eq+bKsKjX2YjvpUMGG+Qoc+hwSK+Via2vy249kGrb9n568csVAmccjPrlCbipD5+GAQN
	aqjCdGEkhTRg7x+Tz/a39fMGYaldy5k=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-jSotxesjNze9pQJm4Url3Q-1; Tue, 15 Oct 2024 13:41:41 -0400
X-MC-Unique: jSotxesjNze9pQJm4Url3Q-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7ac8f684d9bso1452737785a.1
        for <linux-raid@vger.kernel.org>; Tue, 15 Oct 2024 10:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729014101; x=1729618901;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gyuy+g9+FENpJ6Zj4WgRyTm38+Oy+xaRvvGY3wiwXD4=;
        b=BU2ARXYCEMC1lKj3YHOFn65DehC+UK2ECuBvO4nefwneo0vZWIfqKy9QpQ3NoTbxSf
         g1UO++Nb7PXNFZzxZ68sMlYss1h9rjVEllqE1x/jTtOKMMXfz4RGLpbvuE0OUr3Rszuz
         hk2s3n4qs/zKhuLAipERlXuno5m1NnbB4OiLMfz8sCxjCedfDeAj7lOqw/B0qdgfwrAE
         ewQzh6ZeL3RMfP0MKEbFVlok1XKdmRuVE2urA7YzaAT/Ot/Rrs6g3nW9OhX7WM8dUL75
         veRu1M+J6lxbhA9UDQltxL7M7I2oDwY+8dZUWFBWh1DdQPU35bRo4qlT0oJbENUV+64C
         BDGw==
X-Forwarded-Encrypted: i=1; AJvYcCV661P0x+9FgN8jMQJIOZ4a65PbNsMzeJr1YihUyve8d101GoUY2VvEXn2veIPsGynPiDoFwRanOGyB@vger.kernel.org
X-Gm-Message-State: AOJu0YxzOBpp/uAK4Wb5MdkZXCz1E5Qy++lUrmULUuJsoikzH5EgOKU/
	wuWQHDTm65MjcKiC2nVEArknU5ZiVNCky1NSu9Vh25mbWW1OCh5ltd479UzMEaSzCpAbFyD429y
	RE+TzdzDcAf7bod8KsCCgqJzdu5mxy4bg+SoOig4IJi+90yooU9s2WQBd51k=
X-Received: by 2002:a05:620a:1d08:b0:7b1:3e41:849f with SMTP id af79cd13be357-7b13e418582mr182850185a.47.1729014101358;
        Tue, 15 Oct 2024 10:41:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGB3f+Vm1xP/e5R2/SmZ5g9D+gCoQWPmkwwCJtptAA1IZiPQgPk2ZAY71Y9elhoKxLnUEuabw==
X-Received: by 2002:a05:620a:1d08:b0:7b1:3e41:849f with SMTP id af79cd13be357-7b13e418582mr182848485a.47.1729014100974;
        Tue, 15 Oct 2024 10:41:40 -0700 (PDT)
Received: from [192.168.50.31] ([134.195.185.129])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b136395171sm93895485a.84.2024.10.15.10.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 10:41:40 -0700 (PDT)
Message-ID: <78206cb4-c4e3-4b3a-a57b-8dac43c12237@redhat.com>
Date: Tue, 15 Oct 2024 13:41:39 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with the
 latest POSIX changes
To: Laurence Oberman <loberman@redhat.com>, linux-raid@vger.kernel.org
References: <20241015173553.276546-1-loberman@redhat.com>
Content-Language: en-US
From: Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <20241015173553.276546-1-loberman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/15/24 1:35 PM, Laurence Oberman wrote:
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
>   lib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib.c b/lib.c
> index f36ae03a..cb4b6a0f 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -485,7 +485,7 @@ bool is_name_posix_compatible(const char * const name)
>   {
>   	assert(name);
>   
> -	char allowed_symbols[] = "-_.";
> +	char allowed_symbols[] = "-_.:";
>   	const char *n = name;
>   
>   	if (!is_string_lq(name, NAME_MAX))

Reviewed-by: Nigel Croxon <ncroxon@redhat.com>


