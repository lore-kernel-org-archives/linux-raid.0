Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A02023ED5F
	for <linux-raid@vger.kernel.org>; Mon, 13 Jan 2025 14:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777512; cv=none; b=uBFjFDd33NwOYqm14k25BxBjPDqmcu9Cui7PzWtoAhhnwDzOGzj8ld7l7+1GMDD2o2aSJhH2JOklIaEvRc7taPDY3fRaGeXxFal9lUQfC5LSjH+agyL249bSBL4yYtL1Fla/JDt5EUPTcv4EObiFFBKJlOjK1b2uF72Ylp9Tkjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777512; c=relaxed/simple;
	bh=CITCKbSohSrjpd1dhmKYEIAmwjOlz4Bl3bKE74x9T94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VvQ0tW0+HQfXo/gihFvssEdUehcQwLgwQ64lBqiJ4B/HqgEM5TYf2uR1wyxDMx7JIMKkKs5wmmYT4F6y+uSi6HwOAyYYW0PKN/bbI3E7/TV0fmKh/a+FtWwjUoP7W6kDQmIHaJKv2qWYZu2I/TkC1T/zh4ggIKYtJQSDLAXMeaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U4bJqmc6; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U4bJqmc6"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a9d9c86920so10954035ab.2
        for <linux-raid@vger.kernel.org>; Mon, 13 Jan 2025 06:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736777510; x=1737382310; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zkF+tx3Zdf7fEQjB7x96B19ZdO0tM0QqjoFam5UqG08=;
        b=U4bJqmc6t5UHP250xrrQU8OpBtpI6yLcXRXLFlcUvJMryamkJLaejCYltxC7QwNAGm
         EmB9R0sw6V6ka58KIpOROsMmuECc8S72c3PSua1eEDuH5tFH9DiMFD6rjebSpxNc6iIX
         POmqrXgqIa+lmejsv7IvUQouqZgrGCAWNMVOufoEkZ9oUOwXScnmeBI1p4eBw0CkUiLG
         Hi/aNcLyaa9DR87V7mm/QJO2CX9mz3mPdnQMBouk4zWPaMrJSQgWMWygA8fyL+27VPTn
         B3CDYYHkt6JQaVGq13gXRs/EMQYisW4q9xTpjn6p+cZm0pzsTsGegxeqQHvXCTvnhnj8
         E8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736777510; x=1737382310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zkF+tx3Zdf7fEQjB7x96B19ZdO0tM0QqjoFam5UqG08=;
        b=jVMbp+zbtt7I5O5lmNZDHnL8LILp1LwwyZvRAhZVY7WW1g7OYlnBYSBD7dlWqCuRlJ
         IwpZTRt3d3GgoCOl6dS8kGBQQUaDsianblQsCJvAIyenLtKPBsfa+NO7XBGxJr7yQUh1
         4spCVu+cq4KPZ5NUmx98iIMCnT+JHVK1uLnB6BcG1ikCwXEtnjkXcKg7aml1UzkePV9/
         EAwxIyGpyLt2/mNiB9yPQSHw5w7rZHCXyGICaKsZCfvHvd3iz6DzK1FwaXzV4C7ZMVQd
         Bq2JLtSi3sgIW7daSEgE8HuImYsv2hhMRfO4mPbW9+FP2HzGG8cCoeXm3/i5bll+7jOz
         WX/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPBXcMihTRJVUQQqFrn1CQUsYsl/gZtSF1aLXtJNNC9+yt8ynSOKNXOW09hxjgyvwBQXThUd+Yrgwp@vger.kernel.org
X-Gm-Message-State: AOJu0YyL2c2LctQb51R4KEn00K+JIg6z+Ru4CS4FVJRHLrFaDitIEY/s
	QFVb0X0oqszOtnUKYOix2reMos7w6V2PXJfU2JfBcy9n0tnn5YKIoQ60Zv1lOM8=
X-Gm-Gg: ASbGncuvXF8qTAc6PYul5ZYthCUsqLRClb6ivYq5pJyT9Tzv2h7vrANpCoBC9cbNciN
	d8ag3Ri6bOnYQExwyobfcGOEI2mmMPqrU97LnHExp8cKKYHsQkmZf07roUNBMLhepEzTTmWT30K
	1tNx6vrwilzYYWHUOOofSiGE5UFJ1bVkprgzQs02eWY/E5yCX9f5lYtEIEYSYtGxSDDZd8XkXfN
	gXlRVFYuvu33xGDB4RgVd2GZt8InkQP8Z04zClvAUhnieMH1E7P
X-Google-Smtp-Source: AGHT+IErqDdONMGNYb5aIsrvlJ9Mo7LjWyNWe/1sDdXiUkJcdc6j5r60f1YEeV/OOCooDIGRQNFNwg==
X-Received: by 2002:a92:c9c6:0:b0:3ce:64a4:4c44 with SMTP id e9e14a558f8ab-3ce64a44e2cmr43977615ab.1.1736777510602;
        Mon, 13 Jan 2025 06:11:50 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b7459e9sm2749780173.118.2025.01.13.06.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 06:11:49 -0800 (PST)
Message-ID: <9c81af73-df8f-4735-97af-edb2e3544e48@kernel.dk>
Date: Mon, 13 Jan 2025 07:11:49 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: Add missing md-linear.c
To: Song Liu <song@kernel.org>, sfr@canb.auug.org.au,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
 yukuai3@huawei.com
References: <20250113061308.101069-1-song@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250113061308.101069-1-song@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/25 11:13 PM, Song Liu wrote:
> md-linear.c was missed during manual fix-up of a git-am conflict.
> Add it back.

Gah, please resend the pull request. This is too broken to live
in my tree, let alone the main tree.

-- 
Jens Axboe

