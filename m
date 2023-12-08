Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xB1nQtzk"
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361310DF
	for <linux-raid@vger.kernel.org>; Fri,  8 Dec 2023 15:26:47 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1d072f50a44so5890125ad.0
        for <linux-raid@vger.kernel.org>; Fri, 08 Dec 2023 15:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702078007; x=1702682807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNW9zHOZnc1LQJK9WDGidZl65SCa6LOysbAocy7BZu8=;
        b=xB1nQtzkPdzDi53g1CkJtpbm0IDp/AyzUaOfZNw4C0e/hFa96kttOMcdoRW6v+7Rv0
         AOLWq9YbZRJcAZkUUipy40GNDaXSLOh1dPkHpmLD1Cbgguk81KUUtWMTRSkL2UEDDrRN
         mGbxpRJ4c4tz71wISZc4ZIMJCuQ7CTo4t5PtUx10CEYKh9KKdXYqZQvZf9/WUCk29GqM
         xhH74MSmFjvCBZOpLbAPk2vwlfdS6Vs/kQXwzlmbrlrXwOjz9LNMwKAVlRLyqWTw7nRA
         WCqQOZyeTwwsLQqmsBlOkWhsPujbhuLQlLpSMI0/4+Rs+RqUdODgDF97VAp1wDJmDlal
         J6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702078007; x=1702682807;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNW9zHOZnc1LQJK9WDGidZl65SCa6LOysbAocy7BZu8=;
        b=j7aLyzf1CIPnu3V1g5t7OvJIInO18jhnw82l/gpEfCieXXsyMJHs0g8ztKbPeJRrJw
         trOiv6OVsqSRaDvWUJFwTjcRnkABHKwEvuZ/CIJM0bTzyukAiWlxV3ffMPRtHCknpwaz
         Gx/hBMsDDVcB/AhSnk/Z6m3UTWjduoX6zJRhwlitozZP34/7Wfyw88DnRLM5LljnuYcr
         KXAnaPN9ZqR+pEAG5KfIjsXi5eaJa/ugUlolBTTgUWLQQzt9Wfb6RJVmcSQnjpTPgw7P
         3QJv0G/TV0kMQ/H4mtMUspaXUQ2+QpSeOcbEBf+mydD8AXmIDxAWuee9tXNCU5RpIUGx
         GqsA==
X-Gm-Message-State: AOJu0YzRVLn6Q7OGZCuH+hYhK8q7MCbzsOW71g6vZYf7+IxtQAa46I3K
	uCczmi396qxLFfrf95Ly2rh7TQ==
X-Google-Smtp-Source: AGHT+IHMyGDOCiaqMOdnjS/9xrAXyZz+zLTaaj41qOcErgWJ4DJ/oI/Vgf2UqlbAF38GIcfI6GTBiQ==
X-Received: by 2002:a05:6a20:548f:b0:18d:4821:f75d with SMTP id i15-20020a056a20548f00b0018d4821f75dmr1609127pzk.4.1702078007096;
        Fri, 08 Dec 2023 15:26:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id z28-20020a62d11c000000b006ce66866226sm2215502pfg.84.2023.12.08.15.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 15:26:46 -0800 (PST)
Message-ID: <6d1e200b-a75e-45b8-8a97-f427e6fd0c57@kernel.dk>
Date: Fri, 8 Dec 2023 16:26:45 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-next 20231208
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Junxiao Bi <junxiao.bi@oracle.com>, Song Liu <song@kernel.org>
References: <20C9A854-73A4-4FBE-9857-BB52C7701FAE@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20C9A854-73A4-4FBE-9857-BB52C7701FAE@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/8/23 11:52 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.8/block branch. The major changes in this set are:
> 
> 1. Fix/Cleanup RCU usage from conf->disks[i].rdev, by Yu Kuai;
> 2. Fix raid5 hang issue, by Junxiao Bi;
> 3. Add Yu Kuai as Reviewer of the md subsystem. 

Pulled, thanks.

-- 
Jens Axboe


