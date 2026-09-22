Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71284CDDFC
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 07:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061812; cv=none; b=qpyS+5Ibc5BSW2VOkoc3KT0ICpGb3ySQfkKrsXHoSBeTG5z+euInXw0k/AHASD2tdXfBR9q24igIThvxCbEqj6Yqszma3FsF/OT1Zc5ABbLYKV8q2XDEKXkD686gdzcl6OdsMN+i3iRXIKcH8IzbSHd75X9hoLX9Bx7Pmnd6XgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061812; c=relaxed/simple;
	bh=bXDTgazGzylVCglsWlSCmG/65ewRiBClHZ2hwJst8x8=;
	h=From:Date:To:Message-Id:Mime-Version:In-Reply-To:Subject:
	 Content-Type:References; b=noS8ROnosfmp3f8IAnBs26qbKWmuqrMU6Wsr67jZng5c6rO3I9+T5Uy/VdNER12hhmelsK4PGnHItYgHLZqoFt92+HpDsHscGiFPgx4n6tsaazQGEDrZv/JxB3NUgCs3e0Nu0AxzYEpnY3K6jF2UiZ4QbDDGbnOlDt/VTfREU/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=jFZFywp/; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="jFZFywp/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790061792;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZnxEyDvzE5OVwk3VeXY/YSIyyYtOiF/d4JbUKZdl06s=;
 b=jFZFywp/WZJIKsoKAMDQO6vcsMfYMDpcXS2oxsfoS1EQUMcLO/abVA/A2ybQo7GA/FPhBP
 JQyvqFW/fOIMnOhoHA4KBilOGMb1aiWkXltedMOO/wNgvItSzCaLZea3AfnQeCro53h3Jz
 PyIXpxf9yY9Fj8/9PmIGGxpx/hx1U/lh4ngU+k0vTT1cVSS/364GaXOaBzxG8hRx0Q5byg
 NQJMEzJFf2UImPrA5/Sgw7sWwBeghkl2yPQMW09z199PVBcRvDi1HOAwwxyIu6qJr9W1WJ
 FWCRL3osXZZzYAQ569Yw3o1x75j+n7f0Q39pJ4DzXWdfX2EX+dn2ZNz27F7rrA==
From: "yu kuai" <yukuai@fygo.io>
Date: Tue, 22 Sep 2026 15:23:08 +0800
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <nixiao@fygo.io>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Message-Id: <004b2d3e-73ab-4d9b-bbc8-c9f1ca800193@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ab22ce0+3b8eba+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.179]) by smtp.larksuite.com with ESMTPS; Tue, 22 Sep 2026 07:23:11 +0000
In-Reply-To: <cover.1789974245.git.chencheng@fnnas.com>
Subject: Re: [PATCH v2 0/2] md/raid5: validate disk count before reshape assembly
Content-Type: text/plain; charset=UTF-8
References: <cover.1789974245.git.chencheng@fnnas.com>

=E5=9C=A8 2026/9/21 15:16, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> The previous patch rejects raid4/5 arrays with too few disks in
> setup_conf(). During reshape assembly, raid5_run() still divides by the
> data-disk count before that check, so a crafted superblock can hit
> division by zero.
>
> Extract min_raid_disks() and reject invalid reshape geometries in
> raid5_run() first.
>
> v1 -> v2:
> - Added Link
>
> Chen Cheng (2):
>    md/raid5: extract min_raid_disks()
>    md/raid5: reject invalid reshape disks in raid5_run()
>
>   drivers/md/raid5.c | 28 ++++++++++++++++++----------
>   1 file changed, 18 insertions(+), 10 deletions(-)
Applied to md-7.4

--=20
Thanks,
Kuai
