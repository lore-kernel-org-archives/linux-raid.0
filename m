Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794360216;
	b=4STNezn3dYVDZOovQ6g2IYJ76pyAEyPFQq1FDA3e3jPRTqIyHooM/wx9kA9mvh3q+fbi
	 kehqekzAHSCzgSOuoeO8LdkP+rHMP9LaL2a/yGUurJX5U16wfsUq7xQSA2atrUMq8Dtd+
	 oZu2fYymjq3M7o7AYSmKEjzebjiT6DhwhwnbqYK8xU96ihhEt8exL4pi3mg7wnWBJeRDW
	 bnDA7D5QUqO8/p7d/zShWVed0ApsKeuGWXuJc00NnBw2vOzcjcoyYf16lFZzneEbX3LBk
	 BYMM0xoNI6zURNsDAhO/60IHKj/gsudPSV8NYMoKZRq5aKgk+zcgp4AWATccpsEnnXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794360216;
	h=DMARC-Filter:DKIM-Signature:Received:X-Lms-Return-Path:Reply-To:
	 Content-Type:User-Agent:In-Reply-To:X-Original-From:To:From:
	 Mime-Version:Content-Transfer-Encoding:Subject:Date:Message-Id:Cc:
	 References;
	bh=0H+W0HPmixahWIpeGI6YK6MKbTmWm73hXKwXxAW352U=;
	b=4Ig8AGutuFBXapDqqirvaG1yxSM1I5hPR6SYudNIvfWCS+COQ2AQrDxe7GF9iI6kLbpV
	 FzpxvPaxt1sYbpoqjqbNq5NORWSQlVV6oLwMNYO7jSAMVpmJkhu3v7wCS9mNqIt10hEBf
	 Vg82Ho/LvY1ZTKnHnW+AwN3HP9uchIn/g3C2E70lM0PArYnloRgwcTH41kHZ1KL3hAbKK
	 loVpsqPuWiuc+XvlYstJAPD/FOWwvN9NMxSrWC3N1Sj7l0Ji+G+UrFVt3bXyGq3h3DMhD
	 UulYMdB/bnCwqH/e9WggbRyW8yXgOM4kHjSeMeyPuxSlF7pkvkp3r8Aq/NkgaXsJSGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=dJLLFVeq;
	arc=none smtp.remote-ip=209.127.231.51
Received: from va-2-51.ptr.blmpb.com (va-2-51.ptr.blmpb.com [209.127.231.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F71606A320
	for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2026 01:23:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10F71606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=dJLLFVeq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794360207;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0H+W0HPmixahWIpeGI6YK6MKbTmWm73hXKwXxAW352U=;
 b=dJLLFVequZelmbG1n9x5lafkSCgUcUtaF4O9RBkZu1aY+0G8MaiJGAfUo+JsceGFvJMKEG
 pwEzPwQevMW+s/LP7IfqwpS6d3c87g4VJ+qwbO9jqNSjtqU80csOJMv+nyYfySTZ1JIxqV
 y0zr5CDu/5ouxn6hua2xP5bPZ2Su0/05RwCXskye9mCs4eECYAKKOyF/sCdRib24aZrnbB
 gk/MNUsZrZmlZ3Gl7dnoi/t9pDpgN1/dibGb8o2CRTiKZC1ffqm7ds0usplk7HJTtSPL8Q
 KaCtEf5Pib0rPq4bXTnrnuSSUG5LBwMEA1YxzIK6h9I+glZU8w8uv921uy2LDg==
Received: from [192.168.1.104] ([39.182.0.55]) by smtp.larksuite.com with ESMTPS; Wed, 11 Nov 2026 01:23:26 +0000
X-Lms-Return-Path: <lba+26af3c38e+7eb3b7+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
In-Reply-To: <20261107175734.25918-1-lui2012qwq@gmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Chengyu Liu" <lui2012qwq@gmail.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] md/bitmap: fix missing_pages restore in resize rollback
Date: Wed, 11 Nov 2026 09:23:23 +0800
Message-Id: <d4a8a13b-46a9-41a8-b702-4865940d7abc@fygo.io>
Cc: <song@kernel.org>
References: <20261107175734.25918-1-lui2012qwq@gmail.com>

=E5=9C=A8 2026/11/8 1:57, Chengyu Liu =E5=86=99=E9=81=93:

> The rollback for a failed clustered-raid bitmap preallocation copies
> old_counts.pages into missing_pages instead of old_counts.missing_pages.
> The counter then reports every page as missing and can grow past the
> page count as pages are freed later, making the used_pages stat in
> /proc/mdstat wrap around.  Accounting only, no corruption.
>
> Fixes: c9d650322829 ("md-cluster: always setup in-memory bitmap")
> Signed-off-by: Chengyu Liu<lui2012qwq@gmail.com>
> ---
> v2: add Fixes tag (spotted by sashiko)
> v1:https://lore.kernel.org/linux-raid/20261107164305.11476-1-lui2012qwq@g=
mail.com/
>
>   drivers/md/md-bitmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Applied

--=20
Thanks,
Kuai
