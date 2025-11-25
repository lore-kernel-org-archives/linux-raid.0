Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A3132AABB
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092298; cv=none; b=WWYBgLRb6Lyh4Adxp1af9Vz5YNWsqqbMhNvBmEnnIHnfiRV84wnv4WtEm27I5LrhB3cqoiuCIc0Nkeu30/pAyCYQ/cs6tvZbCgJbJXIs2PbVsxUCnQmlaJV32xv9S9zKp3dilegOntSrBz5fLY0DZKDVcaiIdsQbXI2vUYxyBh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092298; c=relaxed/simple;
	bh=iPGMl91c7t5RGa6luUsGuLLK2Y4Uq1XKEbahe9phnZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PjXmBwE2/wHTj9Vi9Jz0Q7o7ufPxyYpvZBmTfwLjkPa//L6FZh61Zl8PgX0iuvk+x7ppNpgCvklnbAWtcnuY1xNqGODCW+niljpt1w2ZDnCnta+fPFYl0FYsbwHGD6UhTuU3T7OhunlUz6VRs1LBhqPrOdixgGBov6894aB8YPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MP3eRqnj; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MP3eRqnj"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-948e1ec34afso221115639f.3
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 09:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764092296; x=1764697096; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/RYkXbjr0Zws5PkDP81koxcOw7wQafJJolXOcPbtL0=;
        b=MP3eRqnjDMu+VfgIgoXsIjZip2LrEx1us53r4meudiB9JGUbZ72aOCwHVqeWpcZFMf
         brjS7X4GVj403fOyNyRKQvVZgImprMv3zy3CchjzM+GyfO9KuAvEZRo5BLVq7yb1JW5q
         SDs7kehGdkBeTBcTdxTsopwd7wvwVVqvy408yKdzW0gEqgdkhuketmjwGMzY7tz/Z1Oo
         RAYaSxGergG2kfyxRGyXiE5ezp35bLfalGIF4hzgKt+PdBqUIvuhfIChYxFmyuaIhCVf
         CD81Odhm44Ln9mP2TZF0/SRi6UX6k8xoOAJQc44N7ZQHA+ovauUoXEg2ucKX0zVJe694
         35EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764092296; x=1764697096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/RYkXbjr0Zws5PkDP81koxcOw7wQafJJolXOcPbtL0=;
        b=HRWx7eOx8LvjvMrZrnICbRJiEp32AT2pSMfeV54jdpLmInoptFMG388JxOCYQoFLk1
         3LlWpUVUh6wiIOnqYGSdDplgvoeX7PJgu6xvqf1/U5pbtIDjsLZRcLLfQ2Tmqk5J7haA
         NK7V+BDPnymYDFuqPkgtWtaAET01ZLvTd36JTlMAXTt0cI4EgzTZLLC3HkXLYy9Jo+l5
         uy8laKO4B93jGGqruqZIMLX/XJXITE9rzGdNZPa7TNTl7JjLhSPQz/cS4qwPZvzyfWIE
         nFu+i3EWk/eNV3kG1Sbi4Q4pw+PO3SwYzrBoEqx+KL3wNLGPSCfSCbDdtVFkcE0zcMX2
         Yx8w==
X-Forwarded-Encrypted: i=1; AJvYcCVxyIz5EhOk10b4LJOo2474l+cls6nPlJKXPum/KGIv9t7LNtXlOt5Of+Z5G8xYSbwXi8ysbJ4NqooE@vger.kernel.org
X-Gm-Message-State: AOJu0YxT2QIsDC7ZkMTnspz+dnAQW2DGzEpDJrZvmolu4MR364LfLpik
	zdGXwMzPWLAwhUNNCnNjaroNET1zPma86DA6WOxfdwrXtgCb8gR2TT9fkwjewJUVMHM=
X-Gm-Gg: ASbGncvvP+t8917CVZlTYMXRyPqPijOocubTS0xutKTEnsw8IWjXJ7ye50763C8EFXL
	hv7nIIQTamtZTlHvgJNR2p6MMagYaH80zZuCkwB7r+A3hEcwxmFWisZSOq3paGoa6CyUaNVwgwB
	isw5uxFsaAteYETtywg40jwRipdnLzbJJfkF0bYt7DaCtsKjNU27SmqpyVlE1+xoKzzmIXwMLS4
	16JSI/YRO/+WCi56GC3TGA+6Ju0fQ0T0NVJ9ZAjIbQDK7vwl8KvziqkNx/UHo9mTENDSx7UREKw
	okYVFHyvU0oTIFy8gYR23hzZR9h/4GcUuSa7MWsv7tJI2mKcYR/EfSgTmFK3W9ZuAqGt07/BmDj
	bm16RUQCfDO8bHc3JE3D9rCNpLS8iQCYBB4EG4GIjmIRCW9pq3MzLNFSQ7GDmdbZY92o=
X-Google-Smtp-Source: AGHT+IEIHRk7SwMmVS4xtcTCAS6Qp+OrN5pgC4aYwqKQ9jNrDNwsm/zNssFdQ4CwiXZVR7EmZb+prg==
X-Received: by 2002:a05:6638:c0fb:b0:5ac:cd9a:4c4c with SMTP id 8926c6da1cb9f-5b999555c41mr3179432173.2.1764092295677;
        Tue, 25 Nov 2025 09:38:15 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b48bdcsm6970840173.45.2025.11.25.09.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 09:38:15 -0800 (PST)
Message-ID: <e3f09e0c-63f4-4887-8e3a-1fb24963b627@kernel.dk>
Date: Tue, 25 Nov 2025 10:38:13 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251124234806.75216-2-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/24/25 4:48 PM, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making the error check
> in blkdev_issue_discard() dead code.

Shouldn't it be a void instead then?

-- 
Jens Axboe

