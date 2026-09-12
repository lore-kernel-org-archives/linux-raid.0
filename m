Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075D738E11A
	for <linux-raid@vger.kernel.org>; Sat, 12 Sep 2026 07:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199298; cv=none; b=OiytV+2vl4Yt1e1/FFtDcdhYhlfDRHDmW3/3LRpKDV4Rspq19B74YXEvDWqaerKGEHAqIrazpGpgvk7oY05bTviZ9YSsmsTiR866Vc5L1m+JXhfqg+1i6BO0LPyAy8NtGmD0RdiPrAXi35P28DjwV/FJn+4QFuBY6FKYVcJJCsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199298; c=relaxed/simple;
	bh=j7DPIT46L3jwPBs/m4i9dXxYp91/V5WPUKCQ73DO1cs=;
	h=Subject:In-Reply-To:From:Mime-Version:Message-Id:References:Date:
	 To:Cc:Content-Type; b=CqO5zhTSyvtxIW5Z77C96m47XfnZG5CHGJOTWOI64byb0TiF6LvTGib6l/9zkHMK4Oqx887aNs4E6Mx/JvtKQs7YqQNnSCEiW35LHRH8Brx0XWaGRuuq5W4oYUJZueqk9fvZjBJ4SC/l+igj9CWjRa8fA6VBBqGXLtADIDGfceA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=NikpzdR0; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="NikpzdR0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789199285;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1VyD7DaC6wasXE9S7pArhsSgm3Sx7MaWSQX/kiC/gJ4=;
 b=NikpzdR09/F8jjEurW0CDFTH6PkpC4QLjhIWtGTyY2EGlJjBO5bIcO6Bd2yb2gL4q7SfCQ
 xljC87r0sRehHc+iFA1dUhhc6f4MJjddtcf1o9sOkPRHza6hi9M/IYpH29fwaVOtAvrpHK
 srW+p7PHZlNXRg9cPxBtjTU1lwoikkIzQMcx3y91mp2brO1uxFCkEstSTb7jhX0f97McF0
 F9ALnFYNx7/MpiWh/ZKDPO/5yFLiz/EyoUmb04lRICLngIJWhpFRMJT0ngOE7LTovgQ9pO
 aulCGlzLnrh63Ui0JyG9cZKR2LqMMbCUD6NOAKaJCeZlW4HS5+Nlxvs0/d2HIA==
Subject: Re: [PATCH] md/raid5: don't BUG() on an inconsistent reshape state from the superblock
In-Reply-To: <20260910131103.988-1-yogeshgaur.83@gmail.com>
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Sat, 12 Sep 2026 07:48:04 +0000
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <15056940-2572-4395-a72b-8cba7d8d11b7@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260910131103.988-1-yogeshgaur.83@gmail.com>
X-Lms-Return-Path: <lba+26aa503b4+1d33de+vger.kernel.org+yukuai@fygo.io>
Date: Sat, 12 Sep 2026 15:48:00 +0800
To: "Yogesh Gaur" <yogeshgaur.83@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io

=E5=9C=A8 2026/9/10 21:11, Yogesh Gaur =E5=86=99=E9=81=93:

> raid5_run() branches on mddev->reshape_position. When it is MaxSector --
>
> no reshape in progress -- the else branch asserts that nothing else
>
> describes one:
>
>
>
> 	BUG_ON(mddev->level !=3D mddev->new_level);
>
> 	BUG_ON(mddev->layout !=3D mddev->new_layout);
>
> 	BUG_ON(mddev->chunk_sectors !=3D mddev->new_chunk_sectors);
>
> 	BUG_ON(mddev->delta_disks !=3D 0);
>
>
>
> Nothing enforces that invariant. Both superblock validators copy the
>
> reshape fields straight off disk without cross-checking them against
>
> each other: super_1_validate() takes reshape_position, delta_disks,
>
> new_level, new_layout and new_chunk from the superblock whenever
>
> MD_FEATURE_RESHAPE_ACTIVE is set, and super_90_validate() does the same
>
> for minor version 91. A superblock that sets the reshape feature while
>
> leaving reshape_position at the MaxSector sentinel therefore reaches the
>
> else branch with a non-zero delta_disks, and assembling the array takes
>
> the machine down:
>
>
>
>    kernel BUG at drivers/md/raid5.c:8117!
>
>    Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>
>    RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
>
>    Call Trace:
>
>     md_run+0xc2f/0x2510 drivers/md/md.c:6779
>
>     do_md_run+0x36/0x660 drivers/md/md.c:6880
>
>     array_state_store+0x9c5/0xcf0 drivers/md/md.c:4765
>
>     md_attr_store+0x1c5/0x330 drivers/md/md.c:6158
>
>     sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
>
>     kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
>
>
>
> This is reachable by anyone who can present an md superblock, so BUG()
>
> is the wrong response. Refuse to start the array instead, the way the
>
> reshape_position !=3D MaxSector branch a few lines above already refuses =
a
>
> reshape it cannot resume. Nothing has been allocated at this point --
>
> the journal-and-bitmap check just above returns -EINVAL the same way --
>
> so there is nothing to unwind.
>
>
>
> Reported-by:syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
>
> Closes:https://syzkaller.appspot.com/bug?extid=3D1f5a7de91d547763f4c8
>
> Fixes: 91adb56473fe ("md/raid5: refactor raid5 "run"")
>
> Assisted-by: LLM
>
> Signed-off-by: Yogesh Gaur<yogeshgaur.83@gmail.com>
>
> ---
>
>   drivers/md/raid5.c | 16 +++++++++++-----
>
>   1 file changed, 11 insertions(+), 5 deletions(-)
Applied to md-7.3

--=20
Thanks,
Kuai
