Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52DB2DC79B
	for <linux-raid@vger.kernel.org>; Sat, 12 Sep 2026 03:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789185042; cv=none; b=by0aSELRHIR1JqB2muUpxcufV2yz1RRwcN2uiUDQeuBwXQL1WlLhSCfgjpY6SfL97VbhNT98qInssl0J/23WYumlwr0CL7ICQnEfIoLcPnFy1a3xVYnZRCZsGLdOXo1/impFRnz2zAT4I8LM53lD/0aQ14IHJwdWJwBmB2B38HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789185042; c=relaxed/simple;
	bh=4o925DALVw25gz9ZYUk134NNYbdKqqKyT2lUap2qosM=;
	h=To:Mime-Version:In-Reply-To:Message-Id:Content-Type:Cc:From:
	 Subject:Date:References; b=JKJCBmIhh2bBJ7gk+WpLlp9cPv7RVl/yvbYSAgbyvLLSByLIBEnVJx87+LnVFHSJVxxoGoDyyM4I21QjXg4nL4jW2xIfvejEqEO/jTjYgDcxO/dZAhux0WndXnooBd8dO7XvxXslhiRfWX8yKStGr3RINObgfQAqkX69Y5+AvPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=lbCKW74D; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="lbCKW74D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789185024;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=R3M9abTi3oUtUA6nLaxK+oWiJ+8z0RVyv1x23gam2Nc=;
 b=lbCKW74DbtUOS48Xb75YQquUZhLCmWK5wMjxl/XoaRsx19i8hMxdoj9E3r4a82U22uszKO
 M8zi/wacNj0yYybo4/PggvDvAwm6qFew0JWBGRIyb21LPfinY1cZAuRT19XOqzmu9GZjpe
 ABKwnrCz/7wrJLkbxRyJtDg2/6C9M1LB1hoI8lJeOuyWw9fK+eSRYMJvEwiPWap4oBK+2S
 Y1senjOhxye7ko4+Zo2XFmfESqNvvVahOZciweQK6XZjP1HtUDvdiv4g3s9byhM6wkqQ+x
 BBXTD1KTxLLFPXZmme9qRYxzrWNMJyrWrp9Z1K762sdtiMzXVZDjIGCivgFPnw==
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260907132936.6677-1-chandradhar.2003@gmail.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Message-Id: <2ab91209-d26b-402a-abed-952b6ddfbda2@fygo.io>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Sat, 12 Sep 2026 03:50:23 +0000
X-Lms-Return-Path: <lba+26aa4cc00+482439+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3] md/raid0: validate device count before allocating devlist
Date: Sat, 12 Sep 2026 11:50:19 +0800
Content-Transfer-Encoding: quoted-printable
References: <20260907132936.6677-1-chandradhar.2003@gmail.com>

=E5=9C=A8 2026/9/7 21:29, Chandradhar Kumar =E5=86=99=E9=81=93:

> create_strip_zones() allocates conf->devlist based on mddev->raid_disks
> before verifying that number of devices matches raid_disks. Move the
> existing device count validation before allocation to reject invalid
> configurations before attempting a potentially excessive allocation.
>
> Fixes: 078d1d8e688d ("md/raid0: use kvzalloc/kvfree for strip_zone and de=
vlist allocations")
> Reported-by:syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com
> Closes:https://syzbot.org/bug?extid=3Da32ff75e417c0f49a8e9
> Signed-off-by: Chandradhar Kumar<chandradhar.2003@gmail.com>
> ---
> v2 -> v3:
> - Move the existing device count validation before the allocation
> - Add the requested fixes tag
>
> v1:https://lore.kernel.org/all/20260906143928.105165-1-chandradhar.2003@g=
mail.com/
> v2:https://lore.kernel.org/all/20260906184406.2141-1-chandradhar.2003@gma=
il.com/
>
>   drivers/md/raid0.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
Applied to md-7.3

--=20
Thanks,
Kuai
