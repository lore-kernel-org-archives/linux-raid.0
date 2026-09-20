Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF72B3DDB03
	for <linux-raid@vger.kernel.org>; Sun, 20 Sep 2026 11:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789902851; cv=none; b=IbAA64iSyU7liSnBshhSTD7MWEa+PaU+dPGb7R6naIpmQwMmqBL6TjtJk2qAP7Mm1weUWdcYg+f5nTUaVifNP5uxvxlNhRhbXTpYyVy1Npa+tR3Bai8arvBn8n0c2uARp4udV5TMND2o8BJtGbd8Qt5Xh+Mb1F4kasO8F0NQEo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789902851; c=relaxed/simple;
	bh=ByWLbEPeo5yVz+wJrR5ArHCuUAiyw6qjPD0MHUBGZAI=;
	h=Cc:Message-Id:Mime-Version:To:Date:Content-Type:From:Subject:
	 References:In-Reply-To; b=r3rMl9CAcRZux4opKLnH1CG6I5VeihjCDeoONynIGdLqI3o3I1Kmz2NfI3aJxr/HrHQ28Sl9IYmjpstB1TJ9xrbTqUAkmHnaWyXMBvB7sPFV5ztg8MjtEhWKxuhUMTSr7KMMALm9P6sOzuER9ftnknjJED4bTIFe5JbgqYtPFFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=mkg9iU7/; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="mkg9iU7/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789902844;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=C2a7tEQI0pWgszXv4LJTTbh0gEvtcUKxS901OP4Qa/w=;
 b=mkg9iU7/C2oXWT7Qh0k0GjEL2SKZt8vzq7/17P9ikVP/dzW8LXIOLwMMMyolg7mlguNRN4
 FGHkwoTW3SQsBPxj1Kf18JVnDjzMUZc4UA1p6O9jLrNM+JAkLq/duNeKm8gPg/LgcNZhlS
 vME3Uz120BUXMbJeelnFkSZ41Q8qWgQ7rFkbcR51Ls66Nn6uISJehiV6pK/xlykQgNXbig
 YmqfrzkYNkvgRQdM6+0I5S2a9odFceKX4rfaPry17V75ltmOe2f3EBhWOMIGCJMYGr+sMA
 6ZzWsi5o7dSyxnAI7QGWAE64Yer6wcOq5pMKucvU1mKhBzSZWXRTgd+mdZ+TMw==
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, "Li Youhong" <liyouhong@kylinos.cn>
X-Original-From: yu kuai <yukuai@fygo.io>
Message-Id: <a0bc5679-2325-426c-8fed-3e0dcac5fbfb@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aafbffb+85b398+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Sun, 20 Sep 2026 11:14:02 +0000
Reply-To: yukuai@fygo.io
To: "Li Youhong" <dayou5941@163.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Date: Sun, 20 Sep 2026 19:13:59 +0800
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 0/3] md: raid helper cleanups
References: <20260827075620.3599227-1-dayou5941@163.com>
In-Reply-To: <20260827075620.3599227-1-dayou5941@163.com>
User-Agent: Mozilla Thunderbird

=E5=9C=A8 2026/8/27 15:56, Li Youhong =E5=86=99=E9=81=93:

> From: Li Youhong <liyouhong@kylinos.cn>
>
> This series factors a few repeated md/raid patterns into small helpers.
> There is no intentional behaviour change; each patch is a mechanical
> extract of existing logic.
>
> Patch 1 adds rdev_record_write_error() in md.h for the
> WriteErrorSeen + WantReplacement + MD_RECOVERY_NEEDED sequence shared by
> raid1, raid10 and raid5.
>
> Patches 2 and 3 move raid1/raid10-only helpers into raid1-10.c, which is
> #included by both drivers:
>
>    - rdev_bb_block_sectors() for the badblocks-aligned block size used in
>      narrow_write_error()
>    - flush_bio_list() for the bitmap plug flush path previously duplicate=
d
>      in raid10's flush_pending_writes() and raid10_unplug()
>
> The helpers in raid1-10.c follow the existing static inline convention
> used by raid1_submit_write(), check_decay_read_errors(), and others in
> that file.
>
> Li Youhong (3):
>        md: add rdev_record_write_error() helper
>        md/raid1-10: add rdev_bb_block_sectors() helper
>        md/raid1-10: share flush_bio_list between raid1 and raid10
> ---
>   drivers/md/md.h       |  7 +++++++
>   drivers/md/raid1-10.c | 27 +++++++++++++++++++++++++++
>   drivers/md/raid1.c    | 42 +++++++-----------------------------------
>   drivers/md/raid10.c   | 50 +++++++-------------------------------------=
------
>   drivers/md/raid5.c    |  5 +----
>   5 files changed, 48 insertions(+), 83 deletions(-)
Applied to md-7.4

--=20
Thanks,
Kuai
