Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792897662;
	b=h1fe7Ah0QUYpB18JWZIph3ZlJULwpV8pcC+Gd12TOXsWW0VVTj+fivhNk+AXpBRFwSYc
	 26uq8T2A/qRKliRZ9v0xYBX8RhuWZx5ujD7GaIUKb1SbRKoW7L7MdqNYlTCezKe98oFdd
	 I/SzX24Ah83F2Z6LEY5T3mTTcBWQSriQXjPKSWURr6JGS6ly4L4QEosGM+KrFRqKOm22Z
	 N7w7ivLqI0SEBk4ELPfJ/0HAqHK86IR6Rf1XoPOYJxOOpVTbFxt+kxQuPVg425NuT8krC
	 CdzC/n4CeL5rmu2Szjf8KT/my+TpcqXYaDqctyD8v28b9XU1Q1O+xmG9DUbYEVptz4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792897662;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=sU46yUAf9fpl1+G8OJsmObxc7Moi9Q2vShnNQxEzeYk=;
	b=sWcn9BmmKA83Snzl/Dp3tSBEi1tkyRHOTsADojhYZ8z5ecB3uXjMEArXinn8nQ+vuI7N
	 gCjb+MgtZLB7kafKrY5whPN92+haTYcvgdUeiFgnMXZF1D52IdcXbYWKcHGlmwNDOBhPH
	 a9miuF2H3NJFCOTV37jVzo+RyFHLDssz9LQRLgYI9uxqO/3+qox4JWZ6G/bQletc7ZfDn
	 om8mMLTKaAbsYfFKSEGyKHjAPgnTHe/Gru6hBftuVzHqsXXnJRlbacWYJbogeVaXL8u1l
	 jRlyy1mvdXLye15pQ+7hazcEX3vo9D27YGgu6w4ve6NVsUl2I9E/6itlseiTCnrsVJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=MuMSfX8I;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A182606A323
	for <linux-raid@vger.kernel.org>; Sun, 25 Oct 2026 03:07:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A182606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=MuMSfX8I
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-19305bcb72cso1163472c88.1
        for <linux-raid@vger.kernel.org>; Sat, 24 Oct 2026 20:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1792897660; x=1793502460; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sU46yUAf9fpl1+G8OJsmObxc7Moi9Q2vShnNQxEzeYk=;
        b=MuMSfX8I91h5yDHghR0un5ZmkgrgW6gXpPePZvjdFb0KZKvzOgsncReAQ7R4Q6gctg
         eBvHpKbpF9ElNGR7lScAldiz09zNUX9HrBQdjwok1xWYtUCuYtqvdF4PyYA0aKP837FU
         Lz9HlNJP65M7YQJyDuQ7oVJ+Vu983zwumqHY6fMmGJEofPnVxeL5UfDNwgKj+VEcLm0N
         WrY6n2pHDvPKk0CoQsES1rECZWNuo41Xms83ZQ1iHbCDq9mhah1NqgXMQB2C7sos5DX2
         Mm/7NOkmZtOAXvA/uXU1ISJuLjvb7KydFW2m5bZlVW8MOzb8G9IDLFsV8daSoSd2lgxD
         pZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792897660; x=1793502460;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sU46yUAf9fpl1+G8OJsmObxc7Moi9Q2vShnNQxEzeYk=;
        b=q33qECni6UrowRsCfdCNeARXLyS5mNWdJb8YDlN3N0sP75hbKtjgHg1V9JDeHSPuNP
         W7JT7sG+t/tbHpiBg12cJ6RFO5br1f5HhA/lx2O4chnl7El6VENJ8h/QFJesJyjQvhnN
         I2l2kjYwx0fALFC07jA+/E8s9jAiaW0RRjVLH07e/DqYnfVn6hwiUo3ZQ3n4SMX+RBrc
         +gI/yZZ4vV3HPn29Y5Xbyf58irI2LWq3BxF85UtQ18gcKOrClMc5tHH8F1XV6TBLIqeW
         7TFJ5Xmq3O2si+5vnulYEvT59y+hN99iXkHmjjwXOgqvTklPflEaseXfaDJ892+SyGyp
         JyJA==
X-Gm-Message-State: AFq9FYIW4u80mEt89zYHk81MO2PWGG9Yz/LfZZhLx+303KdDd53CekyX
	W1agzMRDjzm2b2y52jAoppxWEOOA4f5wE0KtI8hSZbrBnOrAxKQg2RFBblQ/V1RWK8E=
X-Gm-Gg: AYBFou3+fq3o5QFYnV9L80n56n0OJXcGAzQ/bMGORbIE2oHOAGBOtD9Ervox/phncTZ
	3ZD1KlxD9gRvKn4yhxoz2baX6HW6LPF5rqndFny8Sz9iPIVOKz5unNhsDnzS1TP/xandu1uzdq8
	jS200HNPRjGDfzIOwPEgV0bNvoIkZJCJSziCfxEq02ZEzD9C6ZNuUN+t6lw1OfD/iFGdle7hoWh
	me7eOLtdIwI+0IzdaMii/H/TBROYqjm8u0Uq9dgm0UOFSfg5hDHQ2SoDHVagTTNGTwN8IAbGK2G
	jfFEIa86RCnVcIUMeWn1nDUpjLgU9jfeSzGnFakg9Gp+tN4tyQmlejLJPxpAZ39Ajj/+TCTVGxb
	iN/ANuR6mDVYvDqMaCvUgXMrfXBjqtPUsRUuhcx0uxOZfrfKgVhoV/OhWxfShLGusIodevBRBsE
	LbpDxUcWBDbVjcPJC5a+HS7q32IfzwAIhXSfjNLvciG5Drpz9Q3sPm1UZOXfPm7jPW4zW+m1Qyo
	ZTxICCv4O2e9O0OgMXJXqC2SBu17jXVqEANpasHG8R3npFrF/jw1tdzmloV69MCwzwkuqcdqK7t
	LBSSciM4WIYoD9IgUqSXT46c0sxeo1u0X0D5+n0k6l0n3O+lplAx+Nx4bg2P
X-Received: by 2002:a05:701b:465c:b0:19a:9a93:c9b2 with SMTP id a92af1059eb24-19a9a93cdbbmr3541213c88.13.1792897659938;
        Sat, 24 Oct 2026 20:07:39 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a249c331sm26612823c88.17.2026.10.24.20.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 20:07:39 -0700 (PDT)
Message-ID: <31b5a611-2f6c-4ebc-801d-e1c5677633e1@kernel.dk>
Date: Sat, 24 Oct 2026 21:07:38 -0600
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.4-20261013
To: yukuai@fygo.io, Yu Kuai <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 Cao Guanghui <caoguanghui@kylinos.cn>,
 Chandradhar Kumar <chandradhar.2003@gmail.com>,
 Chen Cheng <chencheng@fnnas.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
 =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 Li Youhong <liyouhong@kylinos.cn>, Martin Wilck <martin.wilck@suse.com>,
 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, Peng Fan
 <peng.fan@nxp.com>, Sang-Hoon Choi <csh0052@gmail.com>,
 Yogesh Gaur <yogeshgaur.83@gmail.com>, Yuchao Zhang <ndaugoing@gmail.com>,
 Zhihao Cheng <chengzhihao1@huawei.com>, Zizhi Wo <wozizhi@huawei.com>
References: <20261013141241.2257621-1-yukuai@kernel.org>
 <c5690a5d-9553-463e-b9f0-617b4d29b011@fygo.io>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c5690a5d-9553-463e-b9f0-617b4d29b011@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/26 9:01 PM, yu kuai wrote:
> Hi Jens
> 
> ? 2026/10/13 22:12, Yu Kuai ??:
>> Hi Jens,
>>
>> Please consider pulling the following changes into your for-7.4/block
>> branch.
> 
> Looks like this pr is missing for 7.4, should I regenerate it for block-7.4
> later?

Oops, pulled now, it'll make 7.4, don't worry.

-- 
Jens Axboe
