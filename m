Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EA3129A7E
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 22:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718229714; cv=none; b=YpvNoPyGdLRmTlQwLheRl1lvEfVnPN3ECJGBcdwqQgw5GF9TK8LODBN3ijo9A/scwxsAdqxCjIeOQJx7sNKhgLU3FjjN2w48yOFvsziwelCoCgcESHIKAfnXRGwUwynZ7zx6JL06b2T2wF8PLk+sjZBdVqZUEPpGJ/LAdNlEodc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718229714; c=relaxed/simple;
	bh=iwGnkbEKv0mAcxHMDdo54+5NTS4PotqVeRvuFOuXRqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OkhcEWuMsX90aq5GrAGmLvI7R4gwZOJ7kCJrjnPG3Vm9b98kA6YsF+VIw7aaDEf7YS8HbYe8dAKxOuBWhFubW+tnwui7Q+gYY8CLHws5qG7BEca16lDYmZwQKoMAjtVcHp9h/xjDwVw/ijsXkYNQ3Qq1zvdTDILvNGxI2n9bTOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nwYaQewa; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nwYaQewa"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-64ecc2f111dso48787a12.2
        for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 15:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718229711; x=1718834511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uaWc1f4x9VT6WI/CkuMDNNJNIaznWqN3qR7/I+/QteU=;
        b=nwYaQewaHikFm7ryLNJsucMoNSCXZcx9CQtKWRIFZ+51uuDU0Girb4wWKRay2XUsSr
         zh4/eQG55ySBJ0SBn6zSSdeQY63YX+4kbFOs62F9vsajLZ+A/7vfXmduliqDhnX98q8j
         gHMAxhLKnx6EC2PdjcRkyvWiF0FBY3ZDmPLlygsT4Zln+yJ2o0cU1XwXKrMbxspD4i5b
         OjAfEBDjt5GHihm9sN9udNDLc2aFeriwdK7gJeak1gOMvxNilMnhRXhnHdZDVLnP41T4
         nUGTg0qbqKgy5RrNK51K8BY1d5r9CtsC49mvsTc9dPVVuHw9BwV2psYuPZgT1tnv6cTR
         qWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718229711; x=1718834511;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uaWc1f4x9VT6WI/CkuMDNNJNIaznWqN3qR7/I+/QteU=;
        b=YBj7u8+2eLRsTWSba5zmNzAUbSEPRmyWxCh0iUgxkVkksS6fFLfMqPNuIzbFDoywRG
         iBXg8WXrL0jUcLE2aI3g4Oy06DmpiVEqraMfC/BMDDxzSmJsnfO6NqE2thMRxGWZNYSu
         L2ZRjlCwVq5dqB6R8bNCiBkTFEuvBPJids4PGrUKobp1jn/NBQeRIPdFleRXDXfap27W
         QvyGgNkUR8aO5bZq2Dj7MsBrKhxkALquijgfVUnYP0m+I57nAGmI6Oa7ITW9GM/J9UW4
         Kw91/xXegKEn4c1x8mj7DTvH/gaMMxXUTUr6ZGJW6cbLfmVNNlrw3xIKutI5pBqTHg51
         qxnw==
X-Forwarded-Encrypted: i=1; AJvYcCW0K0BqxZv7qz24Q6zXnxnArk7JhbMoS2+83x5cSFunhsnATXdSBkhYAc3gfm/GP2+IL64/zZY38R9S@vger.kernel.org
X-Gm-Message-State: AOJu0YwVNOmxym/eLKzoKppNMqsRjzH5v2jekopSNqkCHOPjf1Volcug
	Fg8RVKIbooFCJ1Szmyu3fM18jm/hrWJoNU0Ci3/T6nl+HXjBqoYw6mI2eU9TaLI=
X-Google-Smtp-Source: AGHT+IGeKIj3iEWGAoO8F6TtUykQ3kyLp+C1y3x+6zGg3NGzcNvZXBBzY0nnEPUDEsV5B8QVse1bNw==
X-Received: by 2002:a17:902:dac8:b0:1f6:d81e:cf3 with SMTP id d9443c01a7336-1f83b51bebamr33613595ad.1.1718229710539;
        Wed, 12 Jun 2024 15:01:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6f7864c5csm85443365ad.275.2024.06.12.15.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 15:01:49 -0700 (PDT)
Message-ID: <c914c279-9a1b-4216-a78d-63ea2f862045@kernel.dk>
Date: Wed, 12 Jun 2024 16:01:48 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.11 20240612
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Christoph Hellwig <hch@lst.de>, Li Nan <linan122@huawei.com>,
 Ofir Gal <ofir.gal@volumez.com>
References: <D2932D51-D0A0-4072-876A-D02CE0A8CCC8@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <D2932D51-D0A0-4072-876A-D02CE0A8CCC8@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/24 3:30 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.11. The major 
> change in this PR are:
> 
> - sync_action fix and refactoring, by Yu Kuai;
> - Various small fixes by Christoph Hellwig, Li Nan, and Ofir Gal.
> 
> Thanks,
> Song
> 
> 
> PS: I noticed that you haven't created the for-6.11/block branch, 
> so I used upstream v6.10-rc3 as the base. Please let me know if 
> this doesn't work. 

That's fine, kicked it off with this one. Thanks, pulled.

-- 
Jens Axboe


