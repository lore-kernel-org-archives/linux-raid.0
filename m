Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE321BC094
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 19:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724960721; cv=none; b=ch5VnOPu4iBCc3gAvvBXupzUFX7PQvRzbNfms9oxOl8mmoAtRAFqNs0Oto32E374o1sVXlcBQNlF7qkCBqpSneZ2loUp8P7bMqjCka7ke+Usdv3WoVq6A7U0bidySt67H4YACpv386hYTkyRCJH4YH2F7mfEw2bZqVzNRssC/j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724960721; c=relaxed/simple;
	bh=sz42Rfj3mSDMK2VynPgivPBWx6ckm/krQ4Df10i8/DQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t0F8/P+ZmTYFWiX857F2fXo4HzonfJCp0bvQyOy+OECv7CiV2hl+MZ82TQXOg/gyFyxedSGDVzKhz8kYYc/5oxk/N1suTaZ3S+/M2dvKUN1rAI4hIQthDO7/JzXnsiLa5LsUyQrSxSq/l4I+GrRfmLekLvdTILirKd5lyZaKo8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tklJf4ig; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tklJf4ig"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-829e3fbcae0so47729439f.0
        for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 12:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724960717; x=1725565517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=brewvk5c5Fy6VXMBCywspI05xecOXrUw91qeAEF4nAA=;
        b=tklJf4igKze3vcX3koQEccUdu5u2FuB9CJ7BS6fIdoxNXdsuTQ8tE6IyOOWaT+3nJK
         v0baZAxpJv+j0R/tB991qson5EKssLAkhMwYHtxIZKEqP/ZqnIuUyVNrvsg394pftyXj
         uD4DXdC9iwWyNU3uFLdOvG08Wr1MdaY00Pz0g2Suqj4BWkAg0qHwpxKaqPB52g2z2Tv7
         cAP6Kia+lODt9CkwbvvoR6q7Q3Z8jCqZslnDDqdbe2SAf0AaU8aNHuXL7FMl54feyhUb
         93NGXo8X6cUzrl1Cc1fB3s4zlDFzg4Pk6BT9rLuGOdSGtwXoRpGu/nrME3azaQ73iZb2
         og6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724960717; x=1725565517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=brewvk5c5Fy6VXMBCywspI05xecOXrUw91qeAEF4nAA=;
        b=ndqdcdom4Fs1ZF1NomVmjdQWujoCiax56F1d5KAR2uxTPZvfoB5+O1XZNLv0RsFsnA
         HSNCJJA1/0wojl/rBzFY+VtDdI8EjqaI9DbATILGvEdaS9MErh2N2w1oxtdYb5yEgSgx
         qt7gJJyjYgDcDEiXc1DrCyak+J32vK5XYk538Wil5VmZg8Plx8tgEyah/vi1DxI8vpZS
         aFAzH/6IJcRFKXuyUMuP8cMWofoBiwodbjpwuOMewPsnXREXP/oHPSBt2wExC4ArvLCg
         dJFSSqSGgW3yKfBzppdjV1+EEDtZlo9vI3P1ZWfdZ5r1m1DXuHEMvQhRL6XNMwgorENx
         npLw==
X-Forwarded-Encrypted: i=1; AJvYcCVAlLXSh/iaSnqTguo09aK+ArR2GcTJD5n/QzWlaWXtt1dX/2XoNDDOc8lw/RpZ3DgGaGfHPtY9GHGP@vger.kernel.org
X-Gm-Message-State: AOJu0YyzIq0+3jxrSTh4EVm3/tYMiCx9ojYePiBA6sHkvhoKgwI8nSnx
	9VKb7PoHqgypLha2t5lOfzaUcp+ZrkeVbwPn3gQ3YllQMPOB24MAcHVDQD/uQKo=
X-Google-Smtp-Source: AGHT+IGmh7IGxwJKG6PUFsduJ1ZkVpq1QP1e57YrV4jZpRWFG+rAlqDpauQ1rTCDewde20VKnC8MrQ==
X-Received: by 2002:a05:6602:130f:b0:7f9:b435:4f5 with SMTP id ca18e2360f4ac-82a11088567mr375897839f.11.1724960717178;
        Thu, 29 Aug 2024 12:45:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82a1a2f0d94sm47448339f.4.2024.08.29.12.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2024 12:45:16 -0700 (PDT)
Message-ID: <7a19b28d-9550-429e-8d13-a5b8f3a4bb74@kernel.dk>
Date: Thu, 29 Aug 2024 13:45:15 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.12 20240829
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai3@huawei.com>, Artur Paszkiewicz
 <artur.paszkiewicz@intel.com>, Chen Ni <nichen@iscas.ac.cn>
References: <2AA457C7-E999-4949-BD8B-8779D3FE9B9A@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2AA457C7-E999-4949-BD8B-8779D3FE9B9A@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/29/24 1:26 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.12 on top of your 
> for-6.12/block branch. Major changes in this set are:
> 
> 1. md-bitmap refactoring, by Yu Kuai;
> 2. raid5 performance optimization, by Artur Paszkiewicz;
> 3. Other small fixes, by Yu Kuai and Chen Ni. 

Pulled, thanks.

-- 
Jens Axboe


