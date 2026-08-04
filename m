Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B9141D215
	for <linux-raid@vger.kernel.org>; Tue,  4 Aug 2026 06:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826687; cv=none; b=awTDgFccHyMJeSdFT2mhFNtZsd4GyUNM9KgIOZTs1daPsIKwJmU7qrWIwt6Rf8WRyBUtcfhiCPen4XAauBWIfUjOgj+vcyuGLrAE+7HByd2LOTdF0rbiC7QUxFEy+byso4Torq79L3lBfbdNk9gCl598lBNtrIWvOXRpYMj7vgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826687; c=relaxed/simple;
	bh=jKWusm+xyakBCvbxlUIqgPBnkoLvNs/gCGqna+lzw9o=;
	h=From:Message-Id:In-Reply-To:To:Cc:Date:Mime-Version:References:
	 Subject:Content-Type; b=EwmirEqOqawZXfmTNhmHT2asApd89HjOxfZXPneMvGFBvWg121VYowAac75N4iCCnlYkeb52NB20NC2A4aVk/XTTCOSWelSi8P9COg9XqwwWcu6vXXW3bdIEv6y89/h6uxC0ytZoMNaS+L1IViegYFbuLu+8LJZOfR1yu62ueQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=PLNuEKDS; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="PLNuEKDS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785826677;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=BFIVioh/dzYQV7FAyD2iZO5C5qALYMaFgxmqyqtsoXI=;
 b=PLNuEKDS/rzh83q9ZjcCsPLhJ8g7ciKSvCNyhMOp4CMmGLAMW/++jjvrAgrN0+VO4fVkxz
 1xeiz2VB7pUweOBVWI/CuGGfYM3WZQ+7aHvwlKawEh3n+FOgyz3NvJrwNDe1EbZmvioVP9
 8eEkdK9sGEJMoXEfO1os38x8gQp15xU8DYDE1NM8/b3r6d2Ut92OzrPk6oZ0xL8+qZcSOb
 JeaQCvdoYvzvjnuCN0Ov/KOXMiyp1Hq+COw8ZJb1XPrJ3KzZfQCFl+WXx8BPyWQam/dUVz
 ZpJvAlyRoyuWiBU4vQnpoJaqtwfUpOnVPzkMbnuMSOTiiWptl6jRsRc8J3323w==
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <67ed4a7f-f250-42e4-8833-662d35a68e75@fygo.io>
X-Lms-Return-Path: <lba+26a718d74+544231+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 06:57:56 +0000
In-Reply-To: <20260804035516.98652-1-yunye.zhao@linux.alibaba.com>
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, "yu kuai" <yukuai@fygo.io>
Cc: <joseph.qi@linux.alibaba.com>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <magiclinan@didiglobal.com>, 
	<song@kernel.org>, <xiao@kernel.org>, <sashiko-bot@kernel.org>
Date: Tue, 4 Aug 2026 14:57:51 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
References: <0650db8f-14d2-4f80-949f-82553fd8485b@fygo.io> <20260804035516.98652-1-yunye.zhao@linux.alibaba.com>
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH v2 3/3] md/raid10: skip clean regions in bulk during recovery
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/8/4 11:55, Yunye Zhao =E5=86=99=E9=81=93:
> Hi Kuai,
>
> On Thu, 31 Jul 2026 at 17:46, Yu Kuai wrote:
>> I'm confused, recovery means replace a new disk ... the whole new disk
>> have to rebuild ... there is nothing to skip
>>
>> So are you talking about the case that the array is already broken?
> The recovery target here is a *re-added existing member*, not a fresh
> spare.

By re-add a disk, this is really a resync, and bitmap can be used in this c=
ase
to skip clean bits. In this case, I still think the correct solution, for o=
ld bitmap,
is to let bitmap_start_sync() return much bigger skipped blocks.

>
> Right, for a fresh spare: saved_raid_disk !=3D slot sets conf->fullsync=
=3D1,
> this skip is bypassed, and the whole disk rebuilds. This patch does not
> touch that.
This is not re-add and it's a real recovery.
>
> The case I fix is a member transiently removed and re-added:
>
>    - a member drops out; its mirror partner stays online, so the array is
>      still redundant and readable (not broken);
>    - nothing is written while it is gone, so the write-intent bitmap
>      stays clean;
>    - the same disk is re-added: valid superblock, saved_raid_disk =3D=3D =
old
>      slot, so conf->fullsync stays 0 and md does a bitmap-based recovery
>      (MD_RECOVERY_RECOVER; /proc/mdstat shows "recovery").
>
> The bitmap is fully clean, every chunk returns must_sync =3D=3D false,
> biolist stays NULL, and we hit the existing "*skipped=3D1; return
> max_sync;" path. Only its step size is wrong.
>
> Reproducer (near=3D2, 4 disks, nothing written while degraded, each pair
> keeps a live copy):
>
>    mdadm --create /dev/md0 -l10 -n4 -p n2 --bitmap=3Dinternal \
>          --bitmap-chunk=3D512M --assume-clean --run <4 x 8T>
>    mdadm /dev/md0 --fail /dev/loop1 --remove /dev/loop1
>    mdadm /dev/md0 --fail /dev/loop3 --remove /dev/loop3
>    # no writes here
>    mdadm /dev/md0 --re-add /dev/loop1
>    mdadm /dev/md0 --re-add /dev/loop3
>
> Thanks,
> Yunye

--=20
Thanks,
Kuai
