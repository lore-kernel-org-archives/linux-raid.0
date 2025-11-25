Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FE632D0F3
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 19:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098355; cv=none; b=OSCtmqvOBxupP7uptKoqSqI2CfQxXmovzliqFTkDIwqysKXtRfLMvP0s4QtuHe+9zWcw3m++mXxemhrsSOLB9SjIskL7+ncXTlAQQk80PIjOjXKLpdtLnyAGI3ftP+pRppoxzhhDryBcGwA8SJ6vWJYnRKzq7C2YqgTJCQdrPck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098355; c=relaxed/simple;
	bh=45sbcsoq0xhsn+W5aOkv0g/ik59ollw7OK4nkRDzkZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dKyZ6VA1n0f8vC9xei2iaGs7LhsDAi9E0k4v4GAhbQdVGff9TlBDZPLpIfjfYChPPmtA0oRgmw/eNZJHIpcvselhMOYaBDsVKaBdeZslJGVATTXa3eE6ecfUMHxe2Zq0VKgcHW/jnGOy1CxMDPYAqhXTosV6XDiwYgGoHPKEeXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0RfdHa56; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0RfdHa56"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-434709e7cc9so27433615ab.1
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 11:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764098352; x=1764703152; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mUfqGNY8yNMCOlzV27bzhMu4chO9eJxWxW9kWFtTcZI=;
        b=0RfdHa56HkCqjGft6ZM3f9ZRGWqMxVLGvBYSDJcNW0xBHEb50rtnCPR7S4M8THVjsK
         hqKTu0JqV8a2FMQU6KwQFEdyWHwhVeDhDgtbygr/OSIPPZfgipOsHRVinPBzGrr4VT5o
         KDfEeaM/jqJUiis23wNz2bL1fewwXy7gesBFA6mM1XIdygxsbFF0n5Os1a4GwY0r6l0U
         dP0WR6SJPOFFSUNngFQfQaZwAvGgExdn78Hb/RhCc6mAWeHn7mPINdByL+ZKfjhK9hZQ
         SZizayExk5WDnrH0+TIG5ruvfmevVCu8XY5GvJQKgL1zMi/ngzL5HpSEdTfl1J4FZ0b9
         YrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764098352; x=1764703152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mUfqGNY8yNMCOlzV27bzhMu4chO9eJxWxW9kWFtTcZI=;
        b=MmG2DqsEytuy3gGs4CwyIYtOOQeOH5VRBOqzfgYfpnGQyOFh6tUCXxF2zdL9kW+2Rd
         gjvsONa7eaa1ZgdDwWGwZKxFUMpQhOXQPpSmJ6kUtzQb6+KDQChzlF4LuDe1a9rsLqcG
         OKzzVgKfOWAB/Br23zdxzjevnsmEroHlRPpsBgDeo869jc0Ik9RuZwYGY/NGDEOsveTD
         LZQkzoKe6Ld0idKKmCFp2lsmmvs3pu/fAZGGV7PlbFbtgTdIDiaSUN7UQ0y/zC5DCjHt
         XPmU6WMFsqPiswu5ma52o/XG5+I1d5zo4JQfvOTgHVxlbifSdzXOZE2tMHEcRKSCHQDw
         RpQw==
X-Forwarded-Encrypted: i=1; AJvYcCV+I2Vl9WpASduo/OAuFcpUUvz/cvFUnSHMfNZDL++3Al+CjRLi3Rw1usY97kR4QIqEP4h8su7tp24U@vger.kernel.org
X-Gm-Message-State: AOJu0YzAAADWcjvMDQO1QqciEFrdpIGZWuQAgjMgEd0B27jLf1YALT1k
	42bny4IJst01uD2P1l6fS4XJGkWhTKjZCBX84k0RcQmdGIbdFQAuVfAsmP2ehozC/FE=
X-Gm-Gg: ASbGncsufj/64aJ597Ke3fzSOVmPsnGRJ5Gzpy8dVQkTAvZ0kBexQYsqP+6IaLFbbJ4
	P6xujui5CCNzv/5BBBASKzRhhFwF5YjYDNFoPw7O3utFSTf0YYYNwpZJ/15L1sdj9Z7rQJ9s40b
	GHBeTAmta6POfT17gdbDPUsQQYHbeSx99/bmS/g1sHWiHtG5tq17cz3Dr3/XgX+wT04x0qGwkxE
	HBkgqlThRUaBDWAqed4gzrRrdlv2+E0lVPGruJi+m8yTvqM2muC6tlkboLAVUUDsK8kQmH6C3XC
	eG71U3sIqWoaSRvScH2jfrNBJU+OtE/+7hOJuIKkZDJzX5kpbMMVhquXPeGiL9AfMLa6q1KW9fY
	NAVLg50XLGD6UJ5C3pLOoGAHB+luXZ4SnZC69Bz5P8HJpebH7tSyUtYkFy8Ybv2eP4EI+UfLgF4
	16o88wFQ==
X-Google-Smtp-Source: AGHT+IFQEaswkUqFfWJbDMiqY0I1VozYHdfo1ZahjMrEfHe7a5FmQfgVW6+5KRthy6ytF5ENx/5MzA==
X-Received: by 2002:a05:6e02:330e:b0:434:70cd:e27d with SMTP id e9e14a558f8ab-435b8e6957fmr145921635ab.24.1764098352527;
        Tue, 25 Nov 2025 11:19:12 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b48ed9sm7452092173.50.2025.11.25.11.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 11:19:11 -0800 (PST)
Message-ID: <a192b8dd-6d67-475c-972e-a88d6d8b8e5a@kernel.dk>
Date: Tue, 25 Nov 2025 12:19:10 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/6] block: ignore discard return value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, yukuai@fnnas.com,
 hch@lst.de, sagi@grimberg.me, kch@nvidia.com, jaegeuk@kernel.org,
 chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-2-ckulkarnilinux@gmail.com>
 <e3f09e0c-63f4-4887-8e3a-1fb24963b627@kernel.dk>
 <851516d5-a5e8-47dd-82e0-3e34090e600d@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <851516d5-a5e8-47dd-82e0-3e34090e600d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 12:09 PM, Chaitanya Kulkarni wrote:
> On 11/25/25 09:38, Jens Axboe wrote:
>> On 11/24/25 4:48 PM, Chaitanya Kulkarni wrote:
>>> __blkdev_issue_discard() always returns 0, making the error check
>>> in blkdev_issue_discard() dead code.
>> Shouldn't it be a void instead then?
>>
> Yes, we have decided to clean up the callers first [1]. Once they are
> merged safely, after rc1 I'll send a patch [2] to make it void since
> it touches many different subsystems.

OK, that make sense. I'll queue patch 1.

-- 
Jens Axboe

