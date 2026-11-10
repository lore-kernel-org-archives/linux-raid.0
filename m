Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794330474;
	b=PNK6BtQll1H9Hy/IKdaIEwcMN6xJvjtf5MCbLgHpSfj770CBL9ke+VzjLysH1njHJXA3
	 XaassizpsGomyO1zq8o4ibAQKMpeIdE/tD9cJSp/vzojHtobcEdqRPnqjLrX/S6PlqCaM
	 mSsJRwutX7AqPMZ8Cu44jRr9yXsPUMFU55Jy4H+W6I8uTxAFUBccq1WAuQ7o/Xe63tmVT
	 WdvX8w+3WyM/KiUev3d4ezye3jpYwiNxZanJ0uCXQx/7uF2wD4SMZ8cYk1wWvaguIJjvs
	 pPGHh6QDm1khdDegLF9LIZKKcJO0thYL0HmmDYsmziZcYnPG4h77eaHD5Xn5qB0HGLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=4UqpTQzGg2Tm6ildp3Ld3mTJDr8pE07qdBhc/UfxXyY=;
	b=RojPFiBCWQVXFzd2OZVlv7vGISHy4s/C0ANCBVwimby2+213KicpWR+sVm5tqpyJ56eC
	 XCOpjFbEn9KPdY5png/Ea3fwIRWlnq42SkZBYVgpHK4Vb37XjQ8dAsx0fxA8yi99Po7AG
	 Ag6ZYXmbZaDDMkSEfDyqvHM8MzQvBKkVkLnY0TXNB9RV8Ei091WyN5urQpltqhqEAswHM
	 78rKBQ9aaoFakHI1CA0F1Wbe+8UzYE27jUnz0XIdGoVawjLBUZDvM1B6q7AS34xfvf5Fv
	 xQiI8noi9BacmiWEJMeMjWynWLgB8bGjRPg4RTU3qYwdspNevZtYFn3CmTsvuL5bYUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cDQQzqEm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614C2606A323
	for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 17:07:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 614C2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cDQQzqEm
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c40f29667e6so335908066b.0
        for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 09:07:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794330473; cv=none;
        d=google.com; s=arc-20260327;
        b=s+rZNEXB5PAhShKeGRN9tLWGM6lPQc7SPZkGR9672nigvcjGcBkQNI19IjxHNGoVck
         Ennb2nCAfk+ZJJMi+NYeySbpx1UZGbJ898D60FmreEeF1A3tnPECFM5wIyl+bxGxiKN3
         +nDPTJMsZ/GpKaHynZo4RXstbnUvPBaZMqzeyrhfMfqPIMI66G/AgaXpOoeLFmGpyssf
         S/4Y0+PZTwROFdnjIwChO//hbh0AZEbWESxgNzckO10pRDrDhMnCKsoocNOkWJ/5NySM
         41IfsqT0k9BGXd+MGBo6RjmP3h24K+jDRIq5dlwkQp5NGS6TEAnxqMzimb5g7HZWX55g
         k1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4UqpTQzGg2Tm6ildp3Ld3mTJDr8pE07qdBhc/UfxXyY=;
        fh=8SXUz0wrNpP/mjN7u0Z01DNmVYG1RudRsUZ7HGzykAA=;
        b=fKLefDOqTCrdLih26qCqgyL1tvEMK9rAahWt3afj7jED9Q+uwKQc7cX9lXUIQGq0K6
         JXzXCz9EIu56rIYCMv0mn+z4x/l8FbOalhi/sDf79Yz1ZTM+k9igM+HV0VMfQ2n7Dh3F
         QjwrYKjskLwIgU7vJtH/9VdGBaGp2WqZihJQCsOASrZyoqDviz+5ZnRtXsgCq9JBItUl
         aHEKjZH6MfYiY+/k9oRHjV+wBKg6P/q+kjwYeyWIZoGE4FfK0th1/x/koTNm+ZyxU9e1
         5WA3MyAuAYH1/oWz3k1ycLFVoFeCum1/AxJvBpaYT1kkBw2iLzdO3JhaLuDNqDR3kYNr
         46Ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794330473; x=1794935273; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4UqpTQzGg2Tm6ildp3Ld3mTJDr8pE07qdBhc/UfxXyY=;
        b=cDQQzqEmfrQYyWPrUgd7H+QiRGXdQYD2V2jFxReHjqa96Pq8mOU26ijdNCFLsbeW9j
         8YQu6Wpbhre27UMTUovB6RYABdShzP1kXLNQiY1pmvXfMKkQZBd65nYBNmwIrD/Tb8ob
         lURH4G7Ujx5iosyQoU1BlMp8SizCWAURKkSHc2UZ5CTSsHWLo0AnQXBB75J/bV4Rxijg
         +J9qafO8SL7/z+xLDcMlqHQZNXO1S0Qi+NIcWZOGK+f0yG42LtFvhz2ONIt88YfXVY1p
         N8TozZFmyPfdQQBYNZJyHF9Fh/zB5Ji1NUI9jbkwJFpPJi5Wc8kuEjqJDsy26kzNRCHD
         JIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794330473; x=1794935273;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4UqpTQzGg2Tm6ildp3Ld3mTJDr8pE07qdBhc/UfxXyY=;
        b=XqENOQjm6Wb8VtvaopKavyVHjolOoAYQ/HgF5YV8vt6KfzdZJjGqHFfzhpSci3OklC
         omyS0wtmekiQMLG8Fom29t6OqVAQ+n1etbSKCYss9ynFwNdKjpDhCtULVrlsM/uJ5QN4
         FVzN66M9TJTXEMKGvsMOk2RPucOcZHmFSEebiRnYFB/+o2OO9au9AZuzFycyU9raM4wS
         /cyUbYZ24v6cwuIdvCVEmHihudcn2I7qJFYkJPDbvlJNNgSi4xj5wl7vVoziR0m4MpBm
         vvcGqf2b7yU9QXVAhxGaS5FQrarNlsHhefVlDyAn5B8+5N3XflS2YTCFCRJxDIVtW80k
         sAsQ==
X-Gm-Message-State: APuU4Z9t7rbhTuo3nIB8oEF1Y8goCS9D9/suivGoEKlouZ6S3M9Z5L/d
	725UDosDcPQaVn8r33t+CtyDx0o4P1BZmioDLqPhHBTlD+FPg6axJbYEvJunPCBKrivBAhNH1CW
	KYVqxOMnkltAJbzbSexYPdAr9RucaO17D4j7P
X-Gm-Gg: AYBFou3eHQw+jEv/OF1DLkGyCsIFB6sqqAjyko9Hd9gA5FMjQr+yg6DzGUumyKkERfp
	rNEqJDjTsDwVq09FFk2aS2qKKEmsGPx+nVVYar6pxzSFD1PsfuUrKdxCMHIQIhKyuuinroLGBut
	lNBZTfG/qb1AI4F+5tcNSVp5CE8RZUHZnzkrHjC/tCfKDtrZPbyyQPcDdMPGjlOPfs6qf5VCySW
	43q0jcL+/7I9pKGKY34HDLPPcXCXvmpXoXmZJGn1kk6HGcfySLNTsg9R1J2Iv3ltrnqyHqzAkbY
	yG260tcbHt/KsoXBkgd0cUpUdu2vh0A23Fsmn/KveUllHMnm5UOGI68fQ5JGXvSp8/kGnnMt9k1
	CMeAcfN3FS5eqmBDp3ZYXbN5eqxRsi3EbYoPi0A==
X-Received: by 2002:a17:906:4796:b0:c26:1648:a06b with SMTP id
 a640c23a62f3a-c50496205c7mr292295666b.38.1794330472316; Tue, 10 Nov 2026
 09:07:52 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAiJnjr6fxY1LKmrYbradXPoxW+cS28uLo6VxYkwLxXsTcY4gg@mail.gmail.com>
 <20261110133756.63676-1-mc@raidlab.org>
In-Reply-To: <20261110133756.63676-1-mc@raidlab.org>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Tue, 10 Nov 2026 19:07:40 +0200
X-Gm-Features: AclHuK9UjQui-gNiOfmFdUdp1-BvzlXLH_Gg8Q16XoMtt0SBc7iXBhAWkevu-mI
Message-ID: <CAAiJnjqfp-SvWXERJeB3WECHqxrwm6gvT4bh18v6Vng81Y-PWA@mail.gmail.com>
Subject: Re: xor_gen() md-raid6 performance improvement
To: Miroslav Cimerman <mc@raidlab.org>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T2ssINC/0L7QutCwINC20LTQtdC8LCDQvdC+INC+0LTQvdCwINC90L7QstCw0Y8g0L7RiNC40LHQ
utCwINC/0YDQuCDRgtC10LrRg9GJ0LXQvCDQv9GA0L7Qs9C+0L3QtSDRg9C20LUg0LXRgdGC0Ywu
DQoNCtCi0LXQv9C10YDRjCwg0LLQvdC40LzQsNC90LjQtSwg0YfRgtC+INGPINGF0L7Rh9GDINGB
0LTQtdC70LDRgtGMINCz0LvQvtCx0LDQu9GM0L3QviAtINC/0L7Qu9C90L7RgdGC0YzRjiDQt9Cw
0LzQutC90YPRgtGL0Lkg0LgNCtCw0LLRgtC+0L3QvtC80L3Ri9C5INGG0LjQutC7LCDQsCDQuNC8
0LXQvdC90L4gLQ0KDQoxLiAg0JvQvtC60LDQu9GM0L3QvtC5IExMTSDQuCDQsNCz0LXQvdGC0L7Q
vCDQstGL0L/QvtC70L3Rj9C10YLRgdGPINC60YDQvtGB0YEt0LrQvtC80L/QuNC70Y/RhtC40Y8u
ICDQldGB0LvQuA0K0LfQsNCy0LXRgNGI0LjQu9C+0YHRjCDRg9GB0L/QtdGI0L3Qviwg0YLQviDQ
vtGB0YLQsNC90LDQstC70LjQstCw0LXQvNGB0Y8uDQrQldGB0LvQuCDQt9CwIDgg0L/QvtC/0YvR
gtC+0Log0LrRgNC+0YHRgS3QutC+0LzQv9C40LvRj9GG0LjRjyDRg9GB0L/QtdGI0L3QviDQvdC1
INC30LDQstC10YDRiNC40LvQsNGB0YwsINGC0L4NCtC/0LXRgNC10YXQvtC00LjQvCDQuiDQv9GD
0L3QutGC0YMgMi4NCjIuICDQndCwINC+0L7RgdC90L7QstCw0L3QuNC4INC90L7QstGL0YUg0L7R
iNC40LHQuiDQtNC+0LHQsNCy0LvQtdC90L3Ri9GFDQovbW50L2xsbV9leHBlcmllbmNlL2V4cGVy
aWVuY2VfZGIuanNvbiwg0L/RgNC+0LLQvtC00LjQvCDQv9C+0LvQvdGL0Lkg0YbQuNC60LsNCtC0
0L7QvtCx0YPRh9C10L3QuNGPINC80L7QtNC10LvQuCwg0YHQvtC30LTQsNC90LjRjyDQvdC+0LLQ
vtCz0L4gZ2d1ZiDRhNCw0LnQu9CwINC4INC60LLQsNC90YLQvtCy0LDQvdC40Y8g0LTQviDRg9GA
0L7QstC90Y8NClE4XzAuDQozLiAg0J/QvtCy0YLQvtGA0Y/QtdC8INC30LDQv9GD0YHQuiDQutGA
0L7RgdGBLdC60L7QvNC40LvRj9GG0LjQuCDQvdCwINC00L7Rg9GH0LXQvdC90L7QuSDQvNC+0LTQ
tdC70LguICDQmCDRgdC90L7QstCwLA0K0LXRgdC70Lgg0YPRgdC/0LXRhSwg0YLQviDQvtGB0YLQ
sNC90LDQstC70LjQstCw0LXQvNGB0Y8uICDQldGB0LvQuCDQvdC10YIsINGC0L4g0YHQvdC+0LLQ
sCDQv9C+0LLRgtC+0YDRj9C10Lwg0L/Rg9C90LrRgtGLIDINCtC4IDMg0LDQtiDQv9C+0LrQsCDQ
utGA0L7RgdGBLdC60L7QvNC/0LjQu9GP0YbQuNGPINC90LUg0LfQsNCy0LXRgNGI0LjRgtGB0Y8g
0YPRgdC/0LXRiNC90L4uDQoNCtCl0L7Rh9GDINGH0YLQviDQsdGLINGN0YLQviDQstGL0L/QvtC7
0L3Rj9C70L7RgdGMINCw0LLRgtC+0LzQsNGC0LjRh9C10YHQutC4INC+0LTQvdC40Lwg0YHQutGA
0LjQv9GC0L7QvC4gINCi0L4g0LXRgdGC0YwsINC/0L4NCtGB0YPRgtC4INC90YPQttC90L4g0L/Q
vtGB0LvQtdC00L3QuNC1INGD0YHQv9C10YjQvdGL0LUg0YHQutGA0LjQv9GC0Ysg0L7QsdGM0LXQ
tNC10L3QuNGC0Ywg0LIg0L7QtNC40L0g0LzQtdCz0LAt0YHQutGA0LjQv9GCLg0KDQoNCg0KDQoN
Cg0KDQoNCkhpIE1pcm9zbGF2DQoNCkknbSB2ZXJ5IGludGVyZXN0ZWQgaW4gYSBoaWdoIHBlcmZv
cm1hbmNlIG1kLXJhaWQgc3Vic3lzdGVtLCB0byBiZQ0KYWxpZ25lZCB3aXRoIGN1cnJlbnQgUENJ
ZSA1LjAgYW5kIGNvbWluZyA2LjAgTlZNZSBTU0RzLg0KU28gSSdtIHJlYWR5IHRvIGFzc2lzdCB5
b3UgYXMgbXVjaCBhcyByZXF1aXJlZC4NCg0KVGhlcmUgaXMgdGhlIHNpbmdsZSBzb2NrZXQgYm94
IC0gSFBFIERMMzQ1ZzExLCA2IHggUENJZSA1LjAgTlZNZSBTU0RzDQooQ003LVYgMy4yIFRCKSwg
MTIgeCAxNiBHQiBERFI1IERSQU0gNjQwMCBNVC9zLCBBTUQgWmVuNSA5NDU1IHdpdGgNCnJlLWlu
c3RhbGxlZCAoc2luY2UgbXkgcHJldmlvdXMgZW1haWwpIEZlZG9yYSBTZXJ2ZXIgNDUuDQoNClll
c3RlcmRheSBOVk1lIFNTRHMgZHJpdmVzIHdlcmUgdXNlZCBmb3IgYW5vdGhlciBhY3Rpdml0eSwg
YnV0IG5vdyBJJ20NCnJlYWR5IHRvIHN3aXRjaCBiYWNrIHRvIHRlc3QgbWQtcmFpZCBwZXJmb3Jt
YW5jZS4NCg0KW3Jvb3RAZmFtaWx5IH5dIyBsc2Jsaw0KTkFNRSAgICAgICAgICAgIE1BSjpNSU4g
Uk0gICBTSVpFIFJPIFRZUEUgTU9VTlRQT0lOVFMNCnpyYW0wICAgICAgICAgICAyNTE6MCAgICAw
ICAgICA4RyAgMCBkaXNrIFtTV0FQXQ0KbnZtZTZuMSAgICAgICAgIDI1OToyICAgIDAgNDQ3LjFH
ICAwIGRpc2sNCuKUnOKUgG52bWU2bjFwMSAgICAgMjU5OjQgICAgMCAgIDYwME0gIDAgcGFydCAv
Ym9vdC9lZmkNCuKUnOKUgG52bWU2bjFwMiAgICAgMjU5OjUgICAgMCAgICAgMkcgIDAgcGFydCAv
Ym9vdA0K4pSU4pSAbnZtZTZuMXAzICAgICAyNTk6NiAgICAwIDQ0NC41RyAgMCBwYXJ0DQogIOKU
lOKUgGZlZG9yYS1yb290IDI1MjowICAgIDAgNDQ0LjVHICAwIGx2bSAgLw0KbnZtZTNuMSAgICAg
ICAgIDI1OTozICAgIDAgICAyLjlUICAwIGRpc2sNCm52bWUxbjEgICAgICAgICAyNTk6OCAgICAw
ICAgMi45VCAgMCBkaXNrDQpudm1lNW4xICAgICAgICAgMjU5OjEwICAgMCAgIDIuOVQgIDAgZGlz
aw0KbnZtZTRuMSAgICAgICAgIDI1OToxMiAgIDAgICAyLjlUICAwIGRpc2sNCm52bWUybjEgICAg
ICAgICAyNTk6MTQgICAwICAgMi45VCAgMCBkaXNrDQpudm1lMG4xICAgICAgICAgMjU5OjE2ICAg
MCAgIDIuOVQgIDAgZGlzaw0KW3Jvb3RAZmFtaWx5IH5dIw0KW3Jvb3RAZmFtaWx5IH5dIyBkbWVz
Z3xncmVwIC1pIHJhaWQ2DQpbICAgIDAuNDkyNTc4XSByYWlkNjogdXNpbmcgYXZ4NTEyeDIgcmVj
b3ZlcnkgYWxnb3JpdGhtDQpbICAgIDAuNjA1MjkzXSByYWlkNjogc2tpcHBlZCBwcSBiZW5jaG1h
cmsgYW5kIHNlbGVjdGVkIGF2eDUxMng0DQpbcm9vdEBmYW1pbHkgfl0jDQoNCk9rLCBJIHdpbGwg
Y3JlYXRlIG1kLXJhaWQ2ICg0KzIpIHdpdGggLS1iaXRtYXA9bm9uZSBhbmQgd2l0aG91dA0KbG9j
a2xlc3MuICBCdXQgd2hpY2ggY2h1bmsgc2l6ZSBzaG91bGQgSSBzZWxlY3QsIGRlZmF1bHQgNTEy
SyA/DQoNCldoaWNoIGtlcm5lbCBzaG91bGQgSSBzZWxlY3QgPywNCg0KW3Jvb3RAZmFtaWx5IH5d
IyB1bmFtZSAtcg0KNy4zLjMtMzAwLmZjNDUueDg2XzY0DQoNCk9yIDcuNC1yYzIgPw0KDQpJJ20g
bm90IGEgZGV2ZWxvcGVyLCBwbGVhc2UgcHJvdmlkZSBkZXRhaWxlZCBzdGVwcyBvbiBob3cgdG8g
YXBwbHkgdGhlDQpwYXRjaCB5b3UgbWVudGlvbmVkLg0KDQpBbnRvbg0KDQrQstGCLCAxMCDQvdC+
0Y/QsS4gMjAyNuKAr9CzLiDQsiAxNTozOCwgTWlyb3NsYXYgQ2ltZXJtYW4gPG1jQHJhaWRsYWIu
b3JnPjoNCj4NCj4gSGkgQW50b24sDQo+DQo+IHRoYW5rcyBmb3Igc2hhcmluZyB0aGUgbnVtYmVy
cy4gSSByZWNlbnRseSBzdWJtaXR0ZWQgYSByYWlkNiBwYXRjaCB0aGF0DQo+IG1ha2VzIHJlYWQt
bW9kaWZ5LXdyaXRlcyBmYXN0ZXIsIGF0IGxlYXN0IG9uIHRoZSBJbnRlbCBtYWNoaW5lcyBJIGhh
dmUuDQo+IElmIHlvdSBoYXZlIHRpbWUsIGNvdWxkIHlvdSBwbGVhc2UgdGVzdCBpdCBvbiB5b3Vy
IFplbiA1IGJveD8NCj4NCj4gICBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjExMDkw
MzA4MDUuMjU3MDktMS1tY0ByYWlkbGFiLm9yZy8NCj4NCj4gSXQgY2hhbmdlcyB4b3Jfc3luZHJv
bWUoKSwgd2hpY2ggbWQgdXNlcyBmb3Igc21hbGwgcmVhZC1tb2RpZnktd3JpdGVzLg0KPiBZb3Vy
IDIgTWlCIHNlcXVlbnRpYWwgdGVzdCBkb2VzIG5vdCB1c2UgaXQsIGFzIGZ1bGwtc3RyaXBlIHdy
aXRlcw0KPiBjb21wdXRlIFAgYW5kIFEgd2l0aCBnZW5fc3luZHJvbWUoKS4gUmFuZG9tIDQgS2lC
IHdyaXRlcyBkbyB1c2UgaXQsDQo+IGkuZS4gLS1ydz1yYW5kd3JpdGUgLS1icz00azoNCj4NCj4g
ICBlY2hvIDIgPiAvc3lzL2Jsb2NrL21kMTExL21kL3Jtd19sZXZlbA0KPiAgIGZpbyAtLW5hbWU9
dGVzdCAtLXJ3PXJhbmR3cml0ZSAtLWJzPTRrIC0tZmlsZW5hbWU9L2Rldi9tZDExMSBcDQo+ICAg
ICAgIC0tZGlyZWN0PTEgLS1udW1qb2JzPTEgLS1pb2RlcHRoPTY0IC0tZXhpdGFsbCAtLWdyb3Vw
X3JlcG9ydGluZyBcDQo+ICAgICAgIC0taW9lbmdpbmU9aW9fdXJpbmcgLS1zaXplPTEwMGcgLS1y
dW50aW1lPTYwIC0tdGltZV9iYXNlZD0xDQo+DQo+IHJtd19sZXZlbD0yIGlzIG5lZWRlZCBvbiBh
IDQrMiBhcnJheTogYSByZWFkLW1vZGlmeS13cml0ZSBhbmQNCj4gYSByZWNvbnN0cnVjdC13cml0
ZSBib3RoIG5lZWQgMyByZWFkcyB0aGVyZSwgYW5kIGJ5IGRlZmF1bHQgbWQgcGlja3MNCj4gcmVj
b25zdHJ1Y3Qtd3JpdGUgb24gYSB0aWUgKDEgaXMgdGhlIGRlZmF1bHQpLg0KPg0KPiBPbmUgam9i
IGF0IFFENjQgc2hvdWxkIGJlIGVub3VnaC4gbWQncyBzaW5nbGUgcmFpZDYgdGhyZWFkIHNob3Vs
ZCBiZQ0KPiB0aGUgbGltaXQuIElmIHRoZSBtZDExMV9yYWlkNiB0aHJlYWQgaXMgbm90IG5lYXIg
MTAwJSBpbiAidG9wIC1IIiwgdHJ5DQo+IC0tbnVtam9icz00IC0taW9kZXB0aD0zMi4NCj4NCj4g
SWYgbWQxMTEgaGFzIHRoZSBuZXcgbG9ja2xlc3MgYml0bWFwIGFuZCB3YXMgY3JlYXRlZCB3aXRo
b3V0DQo+IC0tYXNzdW1lLWNsZWFuLCBtZCB1c2VzIHJlY29uc3RydWN0LXdyaXRlcyBpbiByZWdp
b25zIG5vdCB3cml0dGVuIHNpbmNlDQo+IHRoZSBhcnJheSB3YXMgY3JlYXRlZC4gQWRkaW5nIC0t
c2l6ZT0xMDBnIHRvIGZpbyBrZWVwcyB0aGUgd3JpdGVzIGluDQo+IHRoZSBzdGFydCBvZiB0aGUg
YXJyYXksIHdoaWNoIHlvdXIgc2VxdWVudGlhbCB0ZXN0cyBoYXZlIHByb2JhYmx5DQo+IGFscmVh
ZHkgd3JpdHRlbi4NCj4NCj4gQWxzbyBwbGVhc2UgbWFrZSBzdXJlIHRoYXQgbm8gcmVzeW5jIGlz
IGluIHByb2dyZXNzLg0KPg0KPiBNeSBudW1iZXJzIHdlcmUgbWVhc3VyZWQgd2l0aG91dCBhIHdy
aXRlLWludGVudCBiaXRtYXAsIHNvIHRoZQ0KPiBkaWZmZXJlbmNlIG1heSBiZSBzbWFsbGVyIHdp
dGggb25lLg0KPg0KPiBQbGVhc2UgbWFrZSBzdXJlIHRoYXQgYm90aCBydW5zLCB3aXRoIGFuZCB3
aXRob3V0IHRoZSBwYXRjaCwgdXNlDQo+IGF2eDUxMng0Og0KPg0KPiAgIGRtZXNnIHwgZ3JlcCAn
cmFpZDY6IHVzaW5nIGFsZ29yaXRobScgfCB0YWlsIC0xDQo+DQo+IFRoZSBrZXJuZWwgcGlja3Mg
dGhlIGltcGxlbWVudGF0aW9uIGJ5IGdlbl9zeW5kcm9tZSgpIHNwZWVkIHdoZW4NCj4gcmFpZDZf
cHEgaXMgbG9hZGVkLCBhbmQgdGhlIHBhdGNoIG9ubHkgY2hhbmdlcyB0aGUgeDQgdmVyc2lvbnMg
KHgxIGFuZA0KPiB4MiBhbHJlYWR5IHVzZSBub3JtYWwgc3RvcmVzKS4gSWYgYW5vdGhlciBvbmUg
aXMgcGlja2VkLCByZWxvYWRpbmcNCj4gcmFpZDZfcHEgd2l0aCBtZDExMSBzdG9wcGVkIHJ1bnMg
dGhlIGJlbmNobWFyayBhZ2Fpbiwgb3IgSSBjYW4gc2VuZCBhDQo+IHR3by1saW5lIHRlc3Qtb25s
eSBjaGFuZ2UgdGhhdCBmb3JjZXMgYXZ4NTEyeDQuDQo+DQo+IEVpdGhlciB3YXksIHNoYXJpbmcg
eW91ciBudW1iZXJzIHdvdWxkIGhlbHAsIGFuZCBhIHJlcGx5IHdpdGggVGVzdGVkLWJ5DQo+IHRv
IHRoZSBwYXRjaCBpZiBpdCB3b3JrcyBmb3IgeW91IHdvdWxkIGJlIHZlcnkgYXBwcmVjaWF0ZWQu
DQo+DQo+IFRoYW5rcywNCj4gTWlyb3NsYXYNCg==
