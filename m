Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AA11B85C1
	for <linux-raid@vger.kernel.org>; Fri,  6 Sep 2024 20:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725655545; cv=none; b=J6KW09L+4VsxFBqSaQd+8/1K9Cm2So6DzJZQE1u79YdivXUZkxXLMxMdzjRK82J4DlnTWCTwtNAJe0ui0umavcuIJ3mWH7LUQVL+MVvvvAYwQFDOjYttX246HUswMd7y4vlhKc7ULRbh7kTBCw5mT8A572+1nXdQDAoEhhAuzbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725655545; c=relaxed/simple;
	bh=uRL+f7zz9B1mj+YZPxj8hrJ6HavrsGGig3OJPPUbFtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o0BR68M8slrdl9LY+sjEyg4RxYkDPCLJIswYxlrAItzE3FDcZKuxbxeWXwkhBgzrdrpWFnxtG0CQM1ZG4Of6ZU2J7tiQ3JFkHoGOrePUB5w40Fh6WH6+DKCKwD+S/xcwbtfKdQrKNletRslI9kRamkCK3y5AqFr/3Oruc+DOocM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H4DYpiDE; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H4DYpiDE"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2068acc8b98so23377165ad.3
        for <linux-raid@vger.kernel.org>; Fri, 06 Sep 2024 13:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725655543; x=1726260343; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFP7QeMJ4G7PGXeCMuGVR9OU6C/+Enebm+No9EEH8t4=;
        b=H4DYpiDEkiMSDVem1MUWdHcNGPupAYxxIWe4+mQgkQnUBloIfk2jbldhMdJnBVRpIX
         R2HgM5ZLYqn6deEud5nKmpLvw7BVLQQD8lBEfXuz9vyI1ew+UFpD5k81XgIDKGtEn23L
         UUvxFGh/Je8rizA+qk2g43Kya8UlJdaznPNFKyjR7GqYXxsyw1IVB4zO98IUvEJ12BxT
         pEoG8k5vCX4tA9yIsMC6Xkv1MnsPQAQNnFesK8sYu8uOSgFayQ3kCQOTgSQ62+LpU9Z6
         2VvM+ZAABWvo+d+EIGg5htMEuvuhmsxL5kT3LtfnZ2be0Ogn7xNgotdjL8nXOFRtGzv2
         RCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725655543; x=1726260343;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JFP7QeMJ4G7PGXeCMuGVR9OU6C/+Enebm+No9EEH8t4=;
        b=NH8POp2oRc5zAqU/Mr0pjewy61HO8Rs6pQvh6DHDP2Jt7IEH+H8Fmfc7hCJHy06/LU
         z/uHy+Kl2dXS5s0WVa2p9843jbHnEavqcAsntzJMvIg/IAmvsDrqFUq6yZ4a0/wprY9Y
         sGEQRR+NBPCx+ze9Fe5r3w5tXVn4EiBKlM9lQsV8PR3J8+EZ/+2bwnWikyQ3ffA7bEGI
         XNqZQS3+s/W+GPeQPIFc89oTGC96MhW78tkFrZ+UHkgT4xJ8FPn0CBrZXNnXe3SLPFhV
         DqDNywktgi1dxS0t1fgNREObMzC43+ni8ez0lulAPZlPgSe3NuvY9N2y/xCDGagaRm6e
         oAfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgLrV/GHFAifRv6/BXJN/+b3BIiWdgvVQIFqlAgaNDTJmqxkQzUnMcq2xknvpxL7PDBwl/iVkB9/jy@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0mL9wUd8bCA8OQKfLSX6xFdkX4dTO7kEeBXN7A3PORhcP/Pns
	qoOpZknKstlleayPiFyaHZWsfQ+ppPKjrZpjx1Yud4nWQtK1Dobai29Yl+NyRw0=
X-Google-Smtp-Source: AGHT+IHXP/aUuDJk3PlqC+3NBBK81Wwckt6GrxsHxt9gGhBlMABe2gB3F67sF0G4RL1GKY50bKndvA==
X-Received: by 2002:a17:903:2cb:b0:206:9060:c452 with SMTP id d9443c01a7336-2070c0eb1fcmr5768655ad.33.1725655542705;
        Fri, 06 Sep 2024 13:45:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206ae955918sm47041615ad.86.2024.09.06.13.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 13:45:42 -0700 (PDT)
Message-ID: <35576b52-cfb0-43fd-8eee-3ffddfbc0d0b@kernel.dk>
Date: Fri, 6 Sep 2024 14:45:40 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.12 20240906
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>
References: <7EA0AC98-64A3-4DC9-B204-8533DA2DDE5F@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7EA0AC98-64A3-4DC9-B204-8533DA2DDE5F@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/6/24 1:43 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-6.12 on top of your 
> for-6.12/block branch. This patch, by Xiao Ni, adds a sysfs  entry 
> "new_level". 

Pulled, thanks.

-- 
Jens Axboe


