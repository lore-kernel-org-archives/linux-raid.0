Received: from va-2-52.ptr.blmpb.com (va-2-52.ptr.blmpb.com [209.127.231.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F6846D2A1
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 19:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785440593; cv=none; b=ELh4y7RkWfgVbcIvYmHl3TCeqVSZ8eaGnmPAnGIeT2pCgZpw1P7jJNB8/8VwEaWxCWToU5mbxnfFC45Xkx6LUhFiadC+qWux1UlU4Ue2+/Q/8XPJkMcmRx0b9pXKki7Ry4nDH/LJpe92D4QExw3X1Q0EIH3mrOsfZM7b2bKQLgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785440593; c=relaxed/simple;
	bh=CyulsAKeMPUHEoORLfc5BdVZUmVkJtAq2CZKLvPhITs=;
	h=To:Date:References:Message-Id:Content-Type:Mime-Version:From:
	 Subject:Cc:In-Reply-To; b=lj8S9D1EdO6HqLrSG4cm2RfS6ywHfr17c+oh5yerDzCxX0VkVFmBXbJLxHTu/jxuGRoZeWcu1tMU4hrURX9gUMTJpWn3LCXk+eRjmjjoe3EeqKTSwXQPYh6r3liY8MJslZaai8Pq4aDm6TupmZylQre0zgIMDDRKZZDgY9aPtqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=nFESdyyt; arc=none smtp.client-ip=209.127.231.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="nFESdyyt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785440464;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=7XwmLuNRukYOQ38ZsnqkcM2TwgqDx7W0Ukki0JvDNbY=;
 b=nFESdyytQx08WP8dN1umXVLINTXTQm7/DnzpuaN3OvKP4AZ1GSLRTz7lzCJ9QukA1cCCbj
 qC1wwP1v9kZUcHdhEzIk2C6Jwk3PjVGVt+w6GxoL9S2rFB5HcPYJY93FwNy0/QSv0Trotr
 aMbN3CxoH8tqOl98tssBkPBWrADowpcPkJUr/qE++VYBs5P/lRZ94jSnkBUzr98/3m7+Ct
 RGwPGOkTiGmYBr/TbpY6JuJ4uqlo/XnaBGmkvsfY4rxmDpyVzpx1U2HJsphYIAgIuLcWUR
 cv+T8+PT3cIy6SrZ/GYmKu11A5GikX9sI4ii2jaYMgigkaFhGej8weVTFYI54Q==
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Date: Fri, 31 Jul 2026 03:41:00 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260710132329.7273-1-nishidafmly@gmail.com> <20260710132329.7273-3-nishidafmly@gmail.com>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 19:41:03 +0000
X-Lms-Return-Path: <lba+26a6ba8d0+844f6d+vger.kernel.org+yukuai@fygo.io>
Message-Id: <3d500f0c-bd26-4b02-9437-fc1c44ab3bbe@fygo.io>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 2/2] md: widen badblock sectors param from int to sector_t
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20260710132329.7273-3-nishidafmly@gmail.com>

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:

> The badblocks core API -- badblocks_set(), badblocks_clear() and
> badblocks_check() -- and the is_badblock() helper all take the range
> length as sector_t.  The md wrappers rdev_set_badblocks(),
> rdev_clear_badblocks() and rdev_has_badblock(), however, declared the
> same length as int, narrowing sector_t to int and back again in the
> middle of an otherwise 64-bit clean path.
>
> Change the sectors parameter to sector_t in these three wrappers so it
> matches the core API and is_badblock().  No functional change: current
> callers pass per-I/O or per-resync-chunk lengths well within int range.
> This just removes a gratuitous truncation point and keeps the type
> consistent end to end.
>
> Signed-off-by: Hiroshi Nishida<nishidafmly@gmail.com>
> ---
>   drivers/md/md.c | 4 ++--
>   drivers/md/md.h | 6 +++---
>   2 files changed, 5 insertions(+), 5 deletions(-)
Applied patch 2 to md-7.3

--=20
Thanks,
Kuai
