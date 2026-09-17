Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8553DA7C5
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 06:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789626401; cv=none; b=SuEm0gEX7XqQXdHhgnEzk7NJILvXifAs2upuPYFaAtJNhgt3Wta0r1IMJGn4NuE4aXuZbGJan+iYpGRBeSoQP1AltbWRCcpUjXMMCep/g013acRHVxC0DFzbd5E7L6eVWlsvaAUY/6/0Wfx4lrdajj1Ko0NMIc+WAQlslTchLOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789626401; c=relaxed/simple;
	bh=ILiVyg8+6YLMeqY60B64k49374KXRjjZE3oVWLDpoow=;
	h=From:Message-Id:To:Mime-Version:Subject:Cc:References:
	 Content-Type:In-Reply-To:Date; b=L3xxKe4/OaeluQ0tadtat31ZTOfCLuFMY0axKzN4uKjS1TrQe1d8e76m5zz957PfffkjmYl6G++9Bjp5XMGA7gU/BXlWqJwgG8o/5hOScxjgUQmnrPGBlVE/uFLG43OV2pmjR5AP2THL2dAH2L8ySrno6fg5V+qwzZBcWkAvPgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=dUlb4Chh; arc=none smtp.client-ip=209.127.231.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="dUlb4Chh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789626391;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=q9MN/pbFfh46oJfXN3YCcT64DX0HXtLINWr7ccWWP4A=;
 b=dUlb4ChhREAKtNmDl7VpdCnRs9qvEr6VA+sDWS8Nsi99CBeexkbxHq0LfPixbQHPYnrkge
 WcSC7cnjAieT8we4aaQkTxZkR57B75c7SjN24Vu4w1QV7SEWqtWFX7pufvjMNhlXDji2KQ
 VjJlclfYEOSifJR234ZlwSb6TNuQ7BDEDfAjxpvnIST6vQ2ZMOLMAFnlajH+G2Zfqg6pgL
 UAcXIOTzIhsCou0yEV4t1DcVgwShppjVbEZd7HmEfBX9YkpuFvnXfN/ZBh8HYQ83kYZDTw
 cSuHhJYmpWfFjpKCqey3S6DSSDamoeccEksjxpC0h4DKX7WvJzcXKLE7n59Nmw==
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <5e214547-0993-4219-a6b7-b64b5fcc8e48@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26aab8817+bbf298+vger.kernel.org+yukuai@fygo.io>
To: <sashiko-reviews@lists.linux.dev>, 
	"Deepanshu Kartikey" <kartikey406@gmail.com>, "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] md: fix out-of-bounds access to superblock disk array
Cc: <linux-raid@vger.kernel.org>
References: <20260914055619.32929-1-kartikey406@gmail.com> <20260914060656.937B01F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Thu, 17 Sep 2026 06:26:30 +0000
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260914060656.937B01F000FF@smtp.kernel.org>
Date: Thu, 17 Sep 2026 14:26:27 +0800

Hi,

=E5=9C=A8 2026/9/14 14:06, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Skipping devices with an out-of-bounds `desc_nr` in `super_90_sy=
nc()` leaves `rdev2->desc_nr` stale, silently corrupting the superblock's `=
this_disk` field.
>
> Pre-existing issues:
> - [High] The patch fails to validate `sb->this_disk.number` in `super_90_=
load()`, allowing an unvalidated value to be assigned to `rdev->desc_nr`, w=
hich subsequently leads to out-of-bounds array reads in `super_90_validate(=
)`.
> --
>
> commit b64c4503567571cb6b3f8a25617dfc053378beea
> Author: Deepanshu Kartikey <kartikey406@gmail.com>
> md: fix out-of-bounds access to superblock disk array
>
> This commit adds bounds checks for raid_disks and desc_nr when loading an=
d
> syncing v0.90 superblocks. It aims to prevent out-of-bounds array accesse=
s
> to the 27-element sb->disks array caused by maliciously crafted or
> corrupted metadata.
>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 680b34a63cb3d..81588c3fee49a 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1393,7 +1393,8 @@ static int super_90_load(struct md_rdev *rdev, str=
uct md_rdev *refdev, int minor
>>   		goto abort;
>>   	}
>>  =20
>> -	if (sb->raid_disks <=3D 0)
>> +	if (sb->raid_disks <=3D 0 ||
>> +	    sb->raid_disks > MD_SB_DISKS)
>>   		goto abort;
>>  =20
>>   	if (md_csum_fold(calc_sb_csum(sb)) !=3D md_csum_fold(sb->sb_csum)) {
> [Severity: High]
> This is a pre-existing issue, but while we are adding bounds checks to
> super_90_load(), does this function still leave a critical path vulnerabl=
e?
>
> Slightly further down in super_90_load(), the code does:
>
>      rdev->desc_nr =3D sb->this_disk.number;
>
> Since sb->this_disk.number is read from the untrusted superblock without
> validation against MD_SB_DISKS, an unvalidated value is assigned directly
> to rdev->desc_nr. Later during array assembly, super_90_validate()
> unconditionally uses rdev->desc_nr to index the 27-element sb->disks arra=
y:
>
>      desc =3D sb->disks + rdev->desc_nr;
>      if (desc->state & (1<<MD_DISK_FAULTY))
>
> Can a maliciously crafted MD superblock still trigger an out-of-bounds
> memory read through this unvalidated rdev->desc_nr?
>
> [ ... ]
>
>> @@ -1693,6 +1694,13 @@ static void super_90_sync(struct mddev *mddev, st=
ruct md_rdev *rdev)
>>   			desc_nr =3D rdev2->raid_disk;
>>   		else
>>   			desc_nr =3D next_spare++;
>> +
>> +		if (desc_nr < 0 || desc_nr >=3D MD_SB_DISKS) {
>> +			pr_warn("md: %s: desc_nr %d out of range for rdev %pg, skipping\n",
>> +				mdname(mddev), desc_nr, rdev2->bdev);
>> +			continue;
>> +		}
>> +
> [Severity: High]
> Does skipping out-of-bounds devices here leave rdev2->desc_nr with a stal=
e
> value?
>
> By using continue to early-exit the loop, we skip the subsequent
> rdev2->desc_nr =3D desc_nr assignment. Later in this same function, the
> superblock's this_disk field is populated using rdev->desc_nr:
>
>      if (rdev->desc_nr >=3D 0 && rdev->desc_nr < MD_SB_DISKS)
>          sb->this_disk =3D sb->disks[rdev->desc_nr];
>
> If the target device was skipped during the rdev_for_each loop, will it
> reuse its stale desc_nr and copy the descriptor of whichever other active
> device took that slot, potentially causing metadata corruption?
This looks like a real issue.
>
>>   		rdev2->desc_nr =3D desc_nr;
>>   		d =3D &sb->disks[rdev2->desc_nr];
>>   		nr_disks++;

--=20
Thanks,
Kuai
