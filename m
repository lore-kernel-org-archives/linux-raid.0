Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A23B6346
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 21:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785445290; cv=none; b=aD5mUtW1hhk9AduhMqojFNqCaZH3oAR3t50tRTEVOhDQDF82937X+rxrE/TIVQEEAfRnZEMxGEYJPFobdIPG97li6YETcbovZ+LX7ZbXsO+cOhwp602L35klKWZeEayppHuUTr9x/aJ08H0tKzeT7cEkcQvCDZE7wb68qjmxQ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785445290; c=relaxed/simple;
	bh=TwlGVyvZH9hAxj4srgk3QENaMoolKIhoZT2Um/wJUtQ=;
	h=References:In-Reply-To:To:From:Subject:Cc:Message-Id:Mime-Version:
	 Date:Content-Type; b=hRCKe5en6dJo3V4/3WW8i1YYXiGgbDoGu4iDhT2+Wlj7rSM80sA/9uOWBYsh1EKreLVg5OtwQqDfGWemagbBZ2fWKUbWhrGbwWycuo8KuiU6erj7pGov4hG3EaBGja5J4i4A6ntJE4Znha/f5jZIhBdDNi+ck15PpqUTlh+SfNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=atrSs7q1; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="atrSs7q1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785445281;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vLT2ArLXN140LZcTLPJVLJUAFiI0nxQ0QETAGvsf2S4=;
 b=atrSs7q1SLLjLlj5qxk97zD0M/jhQ0CsJ+P2EB6fAjjzdI/UARfzdrJ6L48zHIUKmbHH1V
 sxDBw0J3K1km31HAdaHlqS3lucu52kjBxQ6X4IAiX67olPsdKJ7EgIbrYmwJEFB7Yegl1F
 8BCmL2umjHhee1S/f8kVOFR7w9xi7MqIGNiQW0mZFV/gHCvmNHl2q2cT9vfv9fFhZYquPP
 9DR6HjvBdKVElYfDkDy3Pddjyrr4IJDt1KjI7MUuyfmZdlDxRClfFbXcTaBJdj8iziF9na
 BHpiuJt4+CsGZfx7f/iCHs098LxYHSmrsiR4brXkDzs9B3NatR04rDPGM9/OGw==
Reply-To: yukuai@fygo.io
References: <20260710132346.7295-1-nishidafmly@gmail.com> <20260710132346.7295-4-nishidafmly@gmail.com>
In-Reply-To: <20260710132346.7295-4-nishidafmly@gmail.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 21:01:19 +0000
User-Agent: Mozilla Thunderbird
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 3/6] md/raid5: scale the stripe_cache_size limit with system memory
X-Lms-Return-Path: <lba+26a6bbba0+9db503+vger.kernel.org+yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-Id: <0f8ac1af-6cf8-4024-b950-250c2c765113@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Fri, 31 Jul 2026 05:01:16 +0800
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:
> raid5_set_cache_size() caps how far the per-array stripe_cache_size sysfs
> knob may be raised at a fixed 32768 stripes.  The stripe cache costs
> roughly max_nr_stripes * (sizeof(stripe_head) + pool_size * (sizeof(bio) =
+
> PAGE_SIZE)), so 32768 stripes is about 1.5GB on a 12-disk array.  That
> fixed limit is wrong at both ends: a host with hundreds of GB of RAM
> backing a wide array cannot grow the cache past ~1.5GB even though it has
> the memory to spare, while on a small box 32768 stripes can already excee=
d
> total RAM.

Firstly, I have no idea how this magic number is chosen, and I don't like i=
t either.
However, in theory, 32768 stripes means 4k * 32768 =3D 128 MB, is there rea=
lly such
device that can handle so much IO in the hardware queue? For example, if IO=
 size is
128k, you'll have to issue 1024 IO to disk at a time. I don't think this is=
 possible
for now, or even for a long time in the future.

>
> Derive the limit from memory instead.  When the new stripe_cache_size_max
> module parameter is 0 (the default), the ceiling is the stripe count that
> fits in at most 1/8 of RAM for this array's width, but never less than th=
e
> historical 32768 -- so the limit only ever grows relative to today and
> small systems are unchanged.  A non-zero stripe_cache_size_max pins a fix=
ed
> ceiling for administrators who want one.
>
> The default stripe count (256), and thus the default memory footprint, is
> unchanged; this only changes how high an administrator may raise
> stripe_cache_size.
>
> Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
> ---
>   drivers/md/raid5.c | 37 ++++++++++++++++++++++++++++++++++++-
>   1 file changed, 36 insertions(+), 1 deletion(-)
>
--=20
Thanks,
Kuai
