Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034641E6DDD
	for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 19:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731699552; cv=none; b=DJifevWnM7X9m/5HntZxe+XxfjqHRmjNtw0UZrAgJgetRSV8oJseqY+RC0a8Dkug+TvDcDc5644GJKQ2qLjDSGwsY9RTVbbbwrex0CJYkZQqwb43Cad2MQZBe2AglSKhz/j57bAHyeknpRSAQ7z/j3WzyIHVwnaE3FhHFhkmKIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731699552; c=relaxed/simple;
	bh=QogTeJSIPoK1X5F92vfTlITS8y17vuK0QTcpPnUw+z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qtBKgd0ccffu0dgrs9DP8HUTHu9+3OZp6fej2RcUcV65AV8fQtQWauWvOM8O1trDnXN1Auv79YtnSQAyHkKM5+FRgDJvs71CWZjLs5FTeFkuVFMwIQprdWzYNAlmh0pnvzf4wvXcZWqFgROZiKFJI36u08VQRqhJMFB3XCJdbeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FKDdlKKw; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FKDdlKKw"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20cb47387ceso25010895ad.1
        for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 11:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731699550; x=1732304350; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TeN9SgVUQqb24ZnccTLcBEop/wL9buWomO4kUfRbbaw=;
        b=FKDdlKKw/GlnUoTyxiY9AbVLimIQR0bJn/0xcp51SCMs3d8PX42bHP53Z+kCvk9uPF
         ibroGRIZu8gz3sE0oEn+2drgpD/SkTqAbqIns0ditnSHFK12YzUhdcH/BuXCogYSBcuj
         cT4Spw7VmVo/IcOld4Pwk4I22B5bpvlae0Pn5A9F0c+KJijobTf3gOcWVokyh893QzOw
         2hU6RlPxVWpfBmXmTbQZ/D11j7q6hMzUy6fqRnckIz+oraubXcozeUTcGOsvuJMjRTdk
         SGNAVyxNdFK5MajgM+99nZ8DOe5rDN6coUfUeQJ97jlMG/Z2cau5xBKj9VgYgDH05w//
         rUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731699550; x=1732304350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TeN9SgVUQqb24ZnccTLcBEop/wL9buWomO4kUfRbbaw=;
        b=nP1nLDR9cS+5H9Y5emsfcMvogLgXLMxnleYhIGk9YmPYVL136NlbG7T1W50rjmuIX5
         hm6ogCug7Q4N12y5cvvZmhIQz84BW9BfDjUSD+WVkRjcZ0ZDRVailfXl882gVmEgEe/7
         OzlpkpbBZjKOgsl18GtnDVyWfJjdMamq6Wex8XPoms+8Pj48V5lJc78N5XHJhU+DG1fS
         yTVpm0Ga8cukxo5xbgIOOIAj0SVH7xOuFfERYd3mvC6CDrx1CbgYrfy2dZYhDclhIWPK
         qLW7h1oIoIWX6SAHsVxLp4+cQltrA9K3HcujA/SaanhgjF9P1zj7JllEZs0nxF4HGQwM
         mRcw==
X-Forwarded-Encrypted: i=1; AJvYcCV3ZuATrA3HRyH3uejHp/a0HCosRPWhATjL8sYow87jOG3Jq58n3KODgMuNacIg+A6jBJJbFBHUMLHk@vger.kernel.org
X-Gm-Message-State: AOJu0YztxKhM0DTdenADvgj8kq1nNGttmIGCqnIORh2mxtRmYl46d/tq
	+Hqc+x5VKTcgQzUhjYgU3ia171RtfKLgAdL7Wd/RJzFE/NNNLWP8gyyXZvnLquw=
X-Google-Smtp-Source: AGHT+IEFAI44xOQQ33GjxVQmmuHLQVrXHXOJVz3rb8kCwK6QlcQWxuX6lNZJHLzr8ztiFEB7mug2xQ==
X-Received: by 2002:a17:902:f54c:b0:20c:8907:908 with SMTP id d9443c01a7336-211d0ebf177mr55641745ad.44.1731699550285;
        Fri, 15 Nov 2024 11:39:10 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f5450bsm16128795ad.248.2024.11.15.11.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 11:39:09 -0800 (PST)
Message-ID: <69646939-fe8a-4eb9-a30e-9ccee4e49f37@kernel.dk>
Date: Fri, 15 Nov 2024 12:39:08 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.13 20241115
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai3@huawei.com>
References: <E1943CC6-7FBF-4C7C-BCFC-914C7FFACFA4@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <E1943CC6-7FBF-4C7C-BCFC-914C7FFACFA4@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/24 11:35 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.13 on top of your
> for-6.13/block tree. This set contains a fix for a W=1 warning, by John 
> Garry, and a MAINTAINERS update (and yes, this is from our new git repo). 

Pulled, thanks.

-- 
Jens Axboe

