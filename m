Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD9315F41D
	for <linux-raid@vger.kernel.org>; Fri, 14 Jun 2024 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381074; cv=none; b=dZ27GrvfVVEyJgYzlFmchm8JXBfWNvgZPc9M+8s9cpUY4hFmkrauI5POXM1HZIvKioynml2bbsIDbvlOw5xGsMch8VbdulPkEfgRIUXlUKwsE/3rfj8/R6aGpAnV/Ny+9v1NiOJXlDdufMqldv/evntLU893HFVq2IeARlaJ8/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381074; c=relaxed/simple;
	bh=9K03K1EOb8N+Ye1xk9pBTeEFKwI2LrZ11+DIvfyUMMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EY3h0ZQxxgHweupdyruiBQ5ZrEB99h7gE19EyiycOpkssWMHeZJEeE3UE6QchrUBvh6skiw8lVrQFhDOdzrToN8JYXVM7sM5lA+LzvQe1Ok3F4pLmpHzc8MSXYh7CIRkTxkUwJ6wDJdYhGS32TPZf9c8Hb9DePKMP+Hf5Gp/k14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FaQFEUyn; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FaQFEUyn"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-705c59564eeso46716b3a.2
        for <linux-raid@vger.kernel.org>; Fri, 14 Jun 2024 09:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718381071; x=1718985871; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hCV+IWPk0IvkJKtq2bRF2qxH9qFCYf5hnPfztISGB5o=;
        b=FaQFEUynhkHMl9J/rAt4Z4QUQgbrc7UVEbBDgAhsJ6FkxZhgjmTBnjktvoPg/oE4AV
         CRgb6oqD/4TglpnMU8QyeZSzco3USa9DR+I/d5BJgRh+Gtw8O2F2iIhksc9yGlFj5VOc
         oGgqeb7X5gPmTnoxBzXbJkFo7sB4e/HZAZw3pqpWzr+oPEk1BWGxBxET7PveqWFuhgaN
         CR1LEiUZViJ/V/k8rlI5I88iWpBKQH5ezUGHTmXuAR8TpT9Ugws7DQH4C1ofuNxjc+Bl
         5KWjr3H4fvP/OzpQ45OEmMzT9hpkm5Ys0MbuGixhsLKqDaEvLN3Jywn/YAI4X3Fkqt0L
         mDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718381071; x=1718985871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hCV+IWPk0IvkJKtq2bRF2qxH9qFCYf5hnPfztISGB5o=;
        b=hy8f4IDfwWT3oaMhEC6CWCPpc8vtEaqwiEpYy1u2ezf7oL+pBbaICCnMhf/b/K+7qt
         cLkzzGetGgyrIRHMfm+y/LTS03Cvod0G3SuLbAcMJWXeviXrf5DZ3GVREodh4DZC7faP
         bmWP5UvmttR+01HpP5grwQZkahWmmw8KVfXpQt1OC6BrVhu6r94YWvzldkza+e7N5s4+
         gTHTcG8NozGIsMhvZqKcu+u5+BqKoJc+s1Aa30paulDPPQH6EJOI+58snQkp3HX3rrqb
         62gpg0pv28Yt8WQXcHaXhTXnBcRAqKRLbg8TMg1gDQHqxCJUluUOJ44SHF/MLL6+e6bE
         hBZA==
X-Forwarded-Encrypted: i=1; AJvYcCVhh9+3tGGhTVKgNeh/Aow+eiod+wUHUvrHYt/TaCz0C+QQwY1ehr3Mm/FMIXxEYTFzXwyFKrHVpK2Yn682/cILrLJcd1BGHHwEJw==
X-Gm-Message-State: AOJu0YxstF0ydNDedgyuxZcX83IpDzsIIx2CJJGHxKUOKq5kqRki25AC
	L7A69ea4tOI7ncxKnxjz+yKPwPTYy6sANffK92huwIKf30SOpLyaEe7If87dAwU=
X-Google-Smtp-Source: AGHT+IFcef25ONKjtc899Mq79qjBziTk8bpO5RUNlOaMS9rx17DLdtap7aVVIksBs4B1DV1O5X5XIA==
X-Received: by 2002:aa7:80d7:0:b0:705:daf0:9004 with SMTP id d2e1a72fcca58-705daf091c8mr2211921b3a.3.1718381071337;
        Fri, 14 Jun 2024 09:04:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb8d9acsm3207006b3a.197.2024.06.14.09.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:04:30 -0700 (PDT)
Message-ID: <af0144b5-315e-4af0-a1df-ec422f55e5be@kernel.dk>
Date: Fri, 14 Jun 2024 10:04:28 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move integrity settings to queue_limits v3
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240613084839.1044015-1-hch@lst.de>
 <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
 <20240614160322.GA16649@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240614160322.GA16649@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 10:03 AM, Christoph Hellwig wrote:
> On Fri, Jun 14, 2024 at 06:33:41AM -0600, Jens Axboe wrote:
>>> The series is based on top of my previously sent "convert the SCSI ULDs
>>> to the atomic queue limits API v2" API.
>>
>> I was going to queue this up, but:
>>
>> drivers/scsi/sd.c: In function ?sd_revalidate_disk?:
>> drivers/scsi/sd.c:3658:45: error: ?lim? undeclared (first use in this function)
>>  3658 |                 sd_config_protection(sdkp, &lim);
>>       |                                             ^~~
>> drivers/scsi/sd.c:3658:45: note: each undeclared identifier is reported only once for each function it appears in
> 
> That sounds like you didn't apply the above mentioned
> "convert the SCSI ULDs to the atomic queue limits API v2" series before?

That might indeed explain it... Surprising it applied without.

-- 
Jens Axboe

