Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74661115
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 12:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709296687; cv=none; b=koiCa9LGO654bWyFGgfWV2ZtAn/aaHhxWQICnGYk+nBO7PM3rWZrYpbUJ76fLyANIblJP7vz71bqBEnK/QuOvvy4fuzymLWzPEOcI7toHJy6lYyiE+Z9fRZSVJ0zM+QErfRwJXVs5Ru4O9E04efJiG1sj9wleTKFFP+YloaGLyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709296687; c=relaxed/simple;
	bh=qRSA2Tx9twNIlEEDbgCQLa9BqzwPhepmakUD94pshPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HexF17fUDQsAOQUKQXB46kEUcaBKkMwrvOdIY5bqIHBh6kgg5LdT6HN9+FEmKGrLdvjWHu0DItsgEqJq2K2c4Kn0C2GFiT+pTquQezd3UnLuAbjw9vD2fTnGZOFX6XndtGrm/3C/0/PLRkk9g637uym0LmbcV5L2kow3BmjrUFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=l4Jf9TEa; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="l4Jf9TEa"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dc9d4a81eeso1505785ad.0
        for <linux-raid@vger.kernel.org>; Fri, 01 Mar 2024 04:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709296682; x=1709901482; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LK48qnzEt/Z7SGSZEMaJv91Hf3z9wJUiPpZN21GOESw=;
        b=l4Jf9TEaN2NHaOQhbv5adQSPOAc+A0BBLZb75o0vf6TPLxci50LYoW0qAWidJ7hn/V
         vE4Hgp5p9vOjftKSyhDL1OqALAuX0y3Rq7uZXF6n0E7ql9sNcqwfX4K5R/iTJS6RdWcJ
         MP/58BXmwbjEECIZd9xhQukKV/xg+7fbJfZTOJuEvYMmDnF9WF8/BjcS5zMH1BcA7+Jk
         Xbr3SNu/votKob6xMcFpNQmMEX1F2rYZAg+fleyQ4B6O55I+Zhd2yL7CiflnxGCdhi03
         6ZStYh/TChyU9whuj8uHEX50IF5mxVSlnH2RbwMImApUOtZ30tiVdjPVpX2QEEmmQEEr
         HiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709296682; x=1709901482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LK48qnzEt/Z7SGSZEMaJv91Hf3z9wJUiPpZN21GOESw=;
        b=HAoTOU3qIIqDa0P5yBQ/LxAAD0Am4ByQfyAo/sgCf7kO6VOtS1ARDv246v4/zTChJk
         fNJU14ZrTqeFpS2ioYeq6Ktx5VmFbLwwU7D46vc11PulmEGG46LyADhRmHK7BHOzgFQZ
         NdNnPTewmSDLmSHYjwKjPTknZOlf1yMlDW+hsk02z6KyfDGTuRFXquJas6ZhUBonq8u1
         56iN5RkbRogxZv26O57M/qhXx6TLARzxE7W7vsHos5akgZRdZKp3LcVP+tG660pkeXvU
         WoVr95zClwaex0KUBIFqCvqo/jL/uRWr61Ro5NzavavWc50rrmvkMJ1eytJhN1B8nY1+
         A4Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUeMDO2jNCFqXvsZjQM9utiKDCUBEU4G9yvGD0KhxTtbny54fOkMSjLM+5sxP45N8IXMjbdosYAMjocjtKnCihXSjNtU4E0Y2o2aw==
X-Gm-Message-State: AOJu0YweI330HwWIVCk3uC+34sihlWAyV90WjOXHyn1xAjWzg9BFu+xm
	fK6pAQP1i4hGJQEenHXVYr7zpmOVy28nhZ8Qgoxu7d9D+P28iAYJSqCQBGzTUNw=
X-Google-Smtp-Source: AGHT+IG0DpdxhgTmZzLpNlFLWAce9o8Qrs+orn4xpbEU4ts6c07Daj9hYqP3xqgN7IUH66nbfNDETQ==
X-Received: by 2002:a17:902:db05:b0:1db:a770:81a4 with SMTP id m5-20020a170902db0500b001dba77081a4mr1391261plx.1.1709296682666;
        Fri, 01 Mar 2024 04:38:02 -0800 (PST)
Received: from ?IPV6:2600:380:7622:adea:8166:3ce1:c424:99d5? ([2600:380:7622:adea:8166:3ce1:c424:99d5])
        by smtp.gmail.com with ESMTPSA id b8-20020a170903228800b001db81640315sm3325483plh.91.2024.03.01.04.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 04:38:01 -0800 (PST)
Message-ID: <c7304166-2d56-4327-bd3f-0124dbf4b299@kernel.dk>
Date: Fri, 1 Mar 2024 05:37:59 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.9 20240301
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Heming Zhao <heming.zhao@suse.com>, Li Nan <linan122@huawei.com>,
 Paul Luse <paul.e.luse@linux.intel.com>
References: <B6EB79F8-7936-49A6-940A-0053DE38AB20@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <B6EB79F8-7936-49A6-940A-0053DE38AB20@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/24 12:44 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.9 on top of your
> for-6.9/block branch. The major changes are:
> 
> 1. Refactor raid1 read_balance, by Yu Kuai and Paul Luse.
> 2. Clean up and fix for md_ioctl, by Li Nan.
> 3. Other small fixes, by Gui-Dong Han and Heming Zhao.

Pulled, thanks.

-- 
Jens Axboe


