Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=141.14.17.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795280695;
	b=l4ayDkl/4ttaoRUIvuc4gGq5BE0tFEdwS7GpjUWsliudpOQqGX1HF3HP0MqiFF0Ru759
	 k+jyaUb+Wh8qepK3Knw2nAoRsSyhfWn+pGAnb7j4n/0No0127gB2e/SvU3sqa6jRZ+yJr
	 bD+1cqeIzacbpx4prEhgdZwcFkFPEn0MBdRlBs79Vy2dlKieLF0seFAqZFfUUSfFnhebY
	 7TyWe14bOVJlbt1T2bhK1vkq7vI3loCAox4LsnCB97nLSlxtCTYEgvlVK+1uVBFoeqC6F
	 lZpC9bBdqpFa30y8nBVKvBxwCaYL7A9bCFqQqtWd4GlonDD+dTRFxXs0Le5Q4ef3PRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795280695;
	h=DMARC-Filter:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:Cc:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:DKIM-Signature;
	bh=wPJhxXGlpysU/AzaHfet/1tbfVQBU4ugVHxXjUuacmE=;
	b=WYCr+7cMSpVhIxXCpgrGQTsEOgplem3UaKV82DOAC6rXtWEamg+ws3YyCkCeRHk0/c3b
	 EhtcsQVowbCSU38JcBu5ezj6PxLRAlaTGY3tdoDbtdGM4NQPG5pIo0BLdllgIhbN2ICEx
	 kNfdVVb/li6/p66kHmMPwtHpTnVOdGo7A7456WqHoQJDXGBB1itmFwDqzzGwRGQROxr6F
	 FX1pNe8GRe4J1LUDuBWd9XCt62j2/2+iJi9nnxt1hOkSYdHbWy5D2viPCUGvR9xvsqOVX
	 /vT2M5YSku4lXX+LrcLYmZAkEGHM8g2vejNgwOJCUMw1X7wYTEi2Ui/drN9E2AvStfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=molgen.mpg.de;
	spf=pass smtp.mailfrom=molgen.mpg.de;
	dkim=pass header.d=molgen.mpg.de header.i=@molgen.mpg.de header.a=rsa-sha256 header.s=20260906 header.b=WCbpyO6r;
	arc=none smtp.remote-ip=141.14.17.11
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E23606A320;
	Sat, 21 Nov 2026 17:04:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7E23606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=molgen.mpg.de header.i=@molgen.mpg.de header.a=rsa-sha256 header.s=20260906 header.b=WCbpyO6r
Received: from [10.0.40.225] (unknown [62.214.191.67])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0C3004C442F7E6;
	Sat, 21 Nov 2026 18:04:22 +0100 (CET)
Message-ID: <72af742a-27cc-4899-b476-6304bc97f5f0@molgen.mpg.de>
Date: Sat, 21 Nov 2026 18:04:17 +0100
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
Subject: Re: [PATCH v2] md/raid0: optimize stripe mapping with bitwise shifts
 for power-of-2 devices
To: Herman Semenoff <germanaizek0@gmail.com>
References: <CAMnMt5YdKe__Q3o3M-og5LnC0To0DOiX80nDosYKNfVbZg1QgQ@mail.gmail.com>
Content-Language: en-US
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAMnMt5YdKe__Q3o3M-og5LnC0To0DOiX80nDosYKNfVbZg1QgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=molgen.mpg.de; s=20260906; 
	t=1795280664; 
	h=from:from:subject:date:message-id:mime-version:content-type:content-transfer-encoding; 
	bh=wPJhxXGlpysU/AzaHfet/1tbfVQBU4ugVHxXjUuacmE=; 
	b=WCbpyO6rrtfPKHQiUp0BaIhpFbFZlN/fS+20NfBhQpAdogCOxtvr9WgJhtgoDfZkXojzERIu+0dI
	p3h3MSEwJYAV118MQs/ClXGAZprznJ5tkGZwL1igObPaTyeoeznCpey65UIAlDjmtLNXf4V9reA+EZ
	gKp8oIZlk1CBnF8nUdhk8wfxWrj9dhW1bw4vD8m4AUuAOYNdmS94OpL37o92e5NN6uw/JwQMCRxrkx
	2KN3yuV29yOECpjCG7x1TcIuaT8Kg/HTjAyw9HgmoAMTQikeJRI2xhJ3b4m2hYjO8jtmy1L4sF6Tfo
	x6y4OJm04LmJMbKqktXh6h1OrVAMIIrg==

Dear Herman,


Thank you for your patch.

Am 21.11.26 um 17:55 schrieb Herman Semenoff:
>  From 450ebc4be1d31f25855c6771e67d27718ab6540f Mon Sep 17 00:00:00 2001
> From: Herman Semenoff <GermanAizek@yandex.ru>
> Date: Sun, 8 Nov 2026 22:43:29 +0300
> Subject: [PATCH] md/raid0: optimize stripe mapping with bitwise shifts
> for power-of-2 devices

[…]

Unfortunately the patch is mangled due to Gmail Web interface wrapping 
lines after 72 characters. Please use git send-email.


Kind regards,

Paul
