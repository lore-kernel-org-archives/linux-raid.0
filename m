Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B814A59B71
	for <linux-raid@vger.kernel.org>; Tue,  1 Apr 2025 02:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743475314; cv=none; b=IG9lN7k0No+mxuIpoaBePtsu2SMJGAqVgikKnC7SkMM9JCAqtV2Ke+LT2dkRqFHXH8KPGKzebU1q+oNr/MZ8drQK0YQVU4t++mOMGGYIbJg2yJP/rpzuhJT+bnxEXZaREPpxaiasMpNqM54mFlDmfHkt4ieVDy3y2gUVPKEJDAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743475314; c=relaxed/simple;
	bh=6P7JIJrwsq/dBdRa83O6fUo91w4tXdutqMlhC7+Cl54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LeP0gdIIBV+FyDpPkBCaNw1gbD2CxG31rYzwISZYJ8KclAye5ETdbNLMVgXS1qyVxXkPQyp3U3VfAOS0HFgaoBQ0m2cdPKsQoSUnkDnN8YZKIGpKqaR0E507RA64Dtt113visaD/JoBwZRlSJBgT8/oXkuyPftec5xO2iPYjZUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b=YW8yUVvn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gpcj/d3I; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b="YW8yUVvn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gpcj/d3I"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id A581E1140091;
	Mon, 31 Mar 2025 22:41:50 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Mon, 31 Mar 2025 22:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev-mail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1743475310; x=1743561710; bh=ooDMu3oGuwtHR5pLQ8j5ZZbgSs/+q2Kbt8k
	h8Un4a7k=; b=YW8yUVvngHuGZJjUyqwJbUsXhwBHIn3KVaMa82uFNNf2Zanrn1m
	UgZGsW+Z++Cq+lqRa3nVi15ZRqO6pqkek03f+xX0wtLEigm1hyihQI7SG5MS8keU
	ULifRVc1IElqJkrvidgH/BkFamJhbinYy9WfPpcY1SE5rVBXOLNBaC1AGDBXc863
	mvJ2RANOqcDTFM4R+n4Jkv5ldpkkqbWeOpuBs+8P1pc7T4wrWl+SpYO/oLWwlBaH
	f48GowM2aNvFegSkUqahlkkSqRQa3aJlIzoY5Dc1A2PrH4m5TvawXkpEAUnzwgNe
	CSsvd0jh/C9Gti/cwOHy5R6J8TigkMLeQQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1743475310; x=
	1743561710; bh=ooDMu3oGuwtHR5pLQ8j5ZZbgSs/+q2Kbt8kh8Un4a7k=; b=g
	pcj/d3ItFXhYF6gRqUcjUjXyYLyIeNahvjZ/EFDCeWlycDfLZBwBEK7y/2/VdBC6
	fdV7hLydWW0qUast9SGkGM0tZUTULTBFIp7vdndwIx7DyJFtWK/imIacrnasPePw
	2HBvIfa7KfwPLIjzmF8rM33tcOjrL+Wuu9oySKDT/SgTTuZFZhKeN8yh5lwbcCFC
	RsRzLS3SSmYs89/9jD+ZEtHi74+76gXj94L5GIn4QL09Hj57hVaw3/QVb/5RUL5v
	xN98qekgBndtnrGI6VarNshqde9nycKwORjrowrmdelJJYhTwLSs8KFPcoP8W9b5
	orqy9GX/tZcShpKIWVn7Q==
X-ME-Sender: <xms:blLrZ4A_Gj7wIRt7mQdQiDaTjGgsJvXl7xe-ioL1Ueeh7c5imEXYMg>
    <xme:blLrZ6glMNjzeyKD9RQB5Ro6Ej_6eiZdT17ahk37WiP9YaOa2WhaIZh6vrAkbnRwt
    FgFX3RsGoKP2UXt>
X-ME-Received: <xmr:blLrZ7lQlaz8SsaZWZbQGMyE3_s3QbBN19ETwjGnXadygiRJGGKORHD96qZ2HmW_t7o1RFKaFQADb-ccOOypUBgujft5VSkdI6kK7BHF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddukeduiedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfghruffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpehpghhnugcuoehpghhn
    ugesuggvvhdqmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpedukeeiteeviedugf
    egudefgefgteejffefvdetvdehhfehfeffkeduuddvieefvdenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehpghhnugesuggvvhdqmhgrihhlrd
    hnvghtpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    peignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdhrrghiugesvh
    hgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:blLrZ-wAib_5UqjSGJVfZd-NPtVl0DFPaEzsrQKFoEJ8WvuwmsXbNg>
    <xmx:blLrZ9Qw_WFI8KChT9_m37ga3POV8hJ-tkfE8lUF0QufWoL0XCmcwA>
    <xmx:blLrZ5beAo_ryJyIhHmH9FygZeEhOijC_Hwy6YGtNd2rTSS_kYDgQw>
    <xmx:blLrZ2QbGTH9SQUBSdQFOV6SFPgWGTNwh8hr0h5DHvrPVJS8lfC0zg>
    <xmx:blLrZ2JeMMd0nRejeMgoIGjfKhwYrBXhq1VUyu90zJNpxtcVvqzBLz4q>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Mar 2025 22:41:49 -0400 (EDT)
Message-ID: <7a13feed-09b6-49ec-8071-6df3be84abd2@dev-mail.net>
Date: Mon, 31 Mar 2025 22:41:49 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: pgnd@dev-mail.net
Subject: Re: extreme RAID10 rebuild times reported, but rebuild's progressing
 ?
Content-Language: en-US
To: xni@redhat.com
Cc: linux-raid@vger.kernel.org
References: <5fc88c9b-83a7-414c-82da-7cccb1f876f3@dev-mail.net>
 <CALTww2-=QABMBKatYQVJ+VSAVTXvvhn1jJFUqf8ZZZb3+nx0Mw@mail.gmail.com>
 <0d9732b1-84c5-4875-ad22-25e546584fbf@dev-mail.net>
 <CALTww2-V8ADxpQ0+to+gyiUO-YELNwc+Fiw0vV+E-HM32L=mng@mail.gmail.com>
From: pgnd <pgnd@dev-mail.net>
In-Reply-To: <CALTww2-V8ADxpQ0+to+gyiUO-YELNwc+Fiw0vV+E-HM32L=mng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> so everything works well now

the OP question remains unanswered.  namely what the issue is re:

	finish=3918230862.4min speed=0K/sec

, and whether it's an indication of a functional problem with the rebuild, one of the mdadm util, or of config?
