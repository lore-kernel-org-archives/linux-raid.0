Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D759275AF5;
	Fri, 13 Jun 2025 11:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749815635; cv=none; b=ZmRMrqSFRoiZTVfQWLDTZEaqfg4fLR+vIBx37pAd1FGpmpaZxt5H08RzXrv9OAcjcZyX8/8HVPAUfIwPfXtzv4dmroI8B6LQLonGiHbNIdmtFp0fEMUGjhiE7quXKcG1DtfYrFgBF7+oC4oNfBwpPMoOD+S//RQyl9LEt8/Y8w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749815635; c=relaxed/simple;
	bh=QnL8ytapLR81x2Nz1jbjY+e5l7il4Tmxcc1vZfIo0Vk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SlUVRwdjd3KHaNPfYlOGWMT7+Qg2PfAVYsbdWKY+Wg8UdQGuVs689cwX0Fx4RjL/nlYNxASCP0xQii66qhqJzbbHkf+JBpnQROGNan8/o9IFPKBoMVev1XwG/AYFhMYhy6upI6qqIy5rD6HOCmyDM/iEehQLmVfOF71uCJvdJQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QuuM4ESf; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QuuM4ESf"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3ddcbe64d0dso18382595ab.3;
        Fri, 13 Jun 2025 04:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749815633; x=1750420433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9qlMQMsvGVVQjXtoeIDPXQe0n38+nTzrdZ5q+564MV0=;
        b=QuuM4ESfZtJPOqlXaDRR7S6xVgC9ooebj//yKFyC4AMQCD4M8jD+KL4Am6OV28U7GU
         SuMSrkgxTIrb0yctacGPVQov0rj5oLHcBfykWP3picSsGQRPEHfQ4ukd55/ID9Xhby2U
         fPqGkSAWu8qeHLnh/NRNL6jvpJUumlmJl+UTPluk5Zn8gjBr9pMXsyhNQExGWJsVi2RF
         +SMgfgXH6w+CkGEOV0ovZuZdw5h9c9PLETxXraEgqs73ecA0B5+Y6zinKKs1DhSMs84S
         KBG1JmfcKXWcu8NsnO49KSFkSwGMPHS1UjHeCDzt/7rrvil96OcCLlxniYoas8edJRmq
         iRnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749815633; x=1750420433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qlMQMsvGVVQjXtoeIDPXQe0n38+nTzrdZ5q+564MV0=;
        b=aBlO0onkveTH6zu7QzXe9gLQE1SLAWFl1qNZuaNrGlBb4b7uix5ty939W1fv8FnqUM
         ZCQ6376/PSelpiTgaa1H+mQGRWJvxJ8HUd444Sr7DXLlEOszX4OTwdEhI6fSCBCq7CTa
         CIa2ulE0Csaw/p3QtIsJE4sd9YEDDodOIsc6np4jFXl4CnhdNeCoUTUHZ07MqUXywzF8
         QofvegQUNoF/4JvvwiARbuMc9TWD0NFbaCBpK8YPBRRoRnh+vfzWg05G7M/1N4IgvnK/
         P5w4pxp8VZnU+3dWla7jfz8MFgYLHZBZMOpEcRWk8/YBpt87u2pWRUHRE6ZvKaMHP+PX
         oTcw==
X-Forwarded-Encrypted: i=1; AJvYcCUOM1Uj4UTrKJn2DaCawvtvD+O9HPKTJcsKCFEf8XvQ2RzMAf66Dm87KbH2hKK6XQQdBYmWVYKJZVnTs1c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGEeiTC/y9fLyKEeT7dUSfr0asX1JTCDi230yQX5l3M7BggQT1
	tCKJ1TbBeXlCU30V7YCGa42533HeirpKbjGBDxMtRQPZfZGquebqPJ6QE4dCLWau9UfLyw==
X-Gm-Gg: ASbGncsgC83/pf7a5LaiqwdLLZJMwq9FOtgi/jLNemcCw9vp/daua7rlElnOXw9JuIB
	b8lcFvR5QZNnDO9TveqmfU60+K2MLb9ZZnZ9Kf4KN/eMvCDfwLKLZ9UORJkK8l9nMroXVBoTSsL
	DVhVT7JAprD6hnqE/WzwDBbwlVRwKw0FmqqblUQ0HVEnl7n4VJv7Qx+W7k5fn0XYDIexW0jQ/z+
	AgLky84r5iCsmJgbJLfoV9JfU8DMo45H1//bxDNJkSIwtf8EBtk3dkXJ6Ymy5Cm+SmX3yWGmUVt
	yEn3oV1/+m/PqF6uWkGxnO10hPzmfn6RxSLPhrB1jfa1
X-Google-Smtp-Source: AGHT+IE2FOGXxIVGwiqC1AaOCKkaEJj/8WaPBNsHnpbldsx8rEVj3ey5eoMJqIcdwXaI4dGyglM2rQ==
X-Received: by 2002:a05:6a20:3d87:b0:1f5:9098:e448 with SMTP id adf61e73a8af0-21facb4c954mr3358274637.5.1749815622073;
        Fri, 13 Jun 2025 04:53:42 -0700 (PDT)
Received: from [127.0.0.1] ([2604:a840:3::1028])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1642e0asm1494080a12.17.2025.06.13.04.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 04:53:41 -0700 (PDT)
Message-ID: <0ccb9479-92ac-4c8e-afdc-a1e3f14fe401@gmail.com>
Date: Fri, 13 Jun 2025 19:53:36 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
 <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
 <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
 <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
 <938b0969-cace-4998-8e4a-88d445c220b1@gmail.com>
 <8a876d8f-b8d1-46c0-d969-cbabb544eb03@huaweicloud.com>
 <726fe46d-afd5-4247-86a0-14d7f0eeb3b3@gmail.com>
 <c328bc72-0143-d11c-2345-72d307920428@huaweicloud.com>
 <9275145b-3066-41e5-a971-eba219ef0d3c@gmail.com>
 <a4f9b5a2-bf83-482e-e1fe-589f9ff004a1@huaweicloud.com>
Content-Language: en-US
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <a4f9b5a2-bf83-482e-e1fe-589f9ff004a1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/6/13 17:15, Yu Kuai wrote:
> Hi,
> 
> 在 2025/06/12 20:21, Wang Jinchao 写道:
>> BTW, I feel raid1_reshape can be better coding with following：
> 
> And another hint:
> 
> The poolinfo can be removed directly, the only other place to use it
> is r1buf_pool, and can covert to pass in conf or &conf->raid_disks.
Thanks, I'll review these relationships carefully before refactoring.
> 
> Thanks,
> Kuai
> 

