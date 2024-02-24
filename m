Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB7813FE2
	for <linux-raid@vger.kernel.org>; Sat, 24 Feb 2024 08:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708764131; cv=none; b=pA6l0yosOLuMY+RQu+yeJ1CHZ3CiGPVyiTBCrefyx5EdtFLxGNDOnXXt6dBeEmQEmakGACWQQ7gGSDdV7acwHRFd0b6FOg3oIK2B1gpaAj4PbdSgL4DE9niTYg8sJnbG9/M258etOuaZPaZGItpTF1AuuThnsR9uZP2so/4/tTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708764131; c=relaxed/simple;
	bh=aHFcnx2oDav0QvcjVywRRh+2giSw9VZ2ZwRFQ+d9jGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pNfqnwkYWsAWhAm4gbUHyqaY1PoFfiee3ckAWcXZq5wQngNb17xmfCnAOyUtdUniWGcxUN3dYMTcO2d8umcXK+4rYyT1dVAiXRDDfDGzzATUa3KZ8KOjhFmUy87Unt9coULH8MVJu4Ox79LJzDf4WVJBSvf97HBGq4yFHdu/yAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HTfNzUQK; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HTfNzUQK"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-512bb2ed1f7so1462522e87.3
        for <linux-raid@vger.kernel.org>; Sat, 24 Feb 2024 00:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1708764127; x=1709368927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u4XLjWmwl245CesMJFh3xd6BnZxMGWYBM9CrBd99Ooo=;
        b=HTfNzUQKywc7G+OLlCvaItVl1OzpWs7laNuwSthGrSy5yOnoqgPnIOnEARpZ6iMv75
         vtexB7D1NqFvr3XyYCg6n5xp4roz1UhsF8DjHdNC1JFFKcLpkb7CaA7pRGahDspRjwBV
         SazOs3c9wzR/iq1Q5J/mRbnflXhsEipLr9DMupUb/WOKVIvrHYTf/3jzJPtcp9bXQJSC
         ch7a2EAFZde4BWYWAyNpxnQt8CbHp9LxNAtZnYbYoHDrjKhegkDj1v7NkWt3QmYeDeie
         kVBRxmfup8eg49rmQoIwHZ25rti5y0U9MSMwrpkrTQJDEbTp383vko0GBqjlf8Q+dana
         U+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708764127; x=1709368927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u4XLjWmwl245CesMJFh3xd6BnZxMGWYBM9CrBd99Ooo=;
        b=qneLL6RgIY//VJkR42U9cmLafOLyh6m9FY5zZLK+EY5wsH0cUt/nNzoorQX/E2BybD
         JHjpSztdGfl62pFPDdw+nfojMlNe1zuDkW2dC4UCx35gA0PPUT+ezh6jp3pBqCOlssPh
         eGV8SL7rU80V4aErTlE8X4J9CeaFr9G1iMsA7NIcCupiGbXY3A5buQ8VzUVSgJGx3mhP
         ejfUtT4U86cLHjTxZw5MBZ6iz/wJ6LJUBMyltzIIxzjmgwL/nqppgdHLVep9QuC/TkDE
         kZaYSBknSG+l+Ni/XKE+8lUXiCCWCf7lHsW9wJ2pIRFNva/jH6gkvpNkoZ3LixK3CpMu
         tlKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSLqYdTlKll4r1jtKsGjJG5UEXqtX21l2iFORdhNIed6pnBTUDQOpDbvVldLb8ZopMtGfL1SnwkrDXV2oeAgVGSd32ns91V35i/g==
X-Gm-Message-State: AOJu0YyVuYdXvfgXx4PTR7fdZwUFaBylliwBU/f1nGJgGVVZCxilo4eK
	rCdq5PtLgqo/+BHW5CIAd9BaCeUBzLtKIJtleJrQ5x9JDbsY7CDSeKnvl6ojMmg=
X-Google-Smtp-Source: AGHT+IHe/X/B+Zbxk+zG4LOkJ6rylGf3xGaPLuSAYYD85YJbxsl4jN+xJRVqsm6E+fv8R/ntJW6zsQ==
X-Received: by 2002:ac2:4ac1:0:b0:512:a52f:468a with SMTP id m1-20020ac24ac1000000b00512a52f468amr1070377lfp.46.1708764126777;
        Sat, 24 Feb 2024 00:42:06 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id c2-20020a63a402000000b005e45b337b34sm688964pgf.0.2024.02.24.00.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 00:42:06 -0800 (PST)
Message-ID: <a19824b2-f1c5-460f-9688-35d8c4c1605e@suse.com>
Date: Sat, 24 Feb 2024 16:41:43 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-bitmap: fix incorrect usage for sb_index
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: song@kernel.org, guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
 colyli@suse.de, hare@suse.de
References: <20240223121128.28985-1-heming.zhao@suse.com>
 <20240223153713.GA1366@lst.de>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240223153713.GA1366@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/24 23:37, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for your view.

> 
> ... but if you're actually still actively using the bitmap code,
> any chance you could try to look into updating it so that it doesn't
> rely on ->bmap?
> 

maybe I misunderstood your meaning, do you mean: you don't like the design of the bitmap, and you hope/plan to drop it?
bitmap is a journal-like stuff. we could get an idea from filesystem journal, just write data status to the bitmap area, rather than managing it in kernel memory. with this idea, writing data protection may involve more simpler code, the replay will become more complex.

Thanks,
Heming
