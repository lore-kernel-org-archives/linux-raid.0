Received: from va-2-51.ptr.blmpb.com (va-2-51.ptr.blmpb.com [209.127.231.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B7138BF9C
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 06:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762951; cv=none; b=i/CQgB0z/p9BFanPm+YK5BtJGcmfo9fDuqxvZ0mEBRTOxfgnz/6PQjj94+j+P5v9YHIJkZRusRh0LCI4auJv6rf8kZtjyTUfDPbMbrYiN9PcOnA+tjeaUifFdxuymzzf7p+GjHdBZfc5Mh1S8/xYKpmmZs7GO9eRpTjZFPJIzaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762951; c=relaxed/simple;
	bh=erausLEaZYfQyVhT+1fhvRlt/PyADFF1K69ceUD3C7c=;
	h=Content-Type:Date:Message-Id:References:Mime-Version:In-Reply-To:
	 Cc:From:To:Subject; b=ZSp+5XFnTapr6dyvHo1RubVsMEaAyeTZEvZ1wEfLEiP03XqZsg8el1wsU97666fh8/qWjKpRfnK0dD5Q21WWB4SSCte/1RWw7yMqjCQzKtA2R+Sb9VdhSgNLc1PxbejmHIK4EaYLxq+23L2MgiHQYF6wElFvikyYg4q9gYm4tao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=NdaveWod; arc=none smtp.client-ip=209.127.231.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="NdaveWod"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788762939;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ALIfe2KFmHm/GZ+77nw/pKD7pycaH98L8Iit1Jfgxek=;
 b=NdaveWodGDkZfyzSrlP9UXsCPfFqEuH/rePHeeEy18sdfwb0SGJlBETSz4M2vqijHcGoBH
 ZfvE2Q8/0BObhGrUUUNzJ6vHBHYqxcslKe9y5hek9dKgkEUQ14vj/z7zLCwYewryZYVjX5
 Pey8w4TLx6FsmhdOVtWGDdfZj0gY2SPhMdaouMYCLxI4r41XkZU37fE0jt17oWkBfGj/Gz
 dpwVrgupEYJ6LC+trm+SFTm/s192ftNae80HfmxBtTsj1bmVMbKHu+wmuHkz9RPnBr3/uC
 HB7POCcDa9lThgbDRqXKV35PfAmv8mJwyDHQnloLPzyOPCDwr80a9ZORUb5GjA==
Content-Type: text/plain; charset=UTF-8
Date: Mon, 7 Sep 2026 14:35:33 +0800
Message-Id: <35ada20d-3d39-4db5-802e-f478d052cf3f@fygo.io>
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Mon, 07 Sep 2026 06:35:37 +0000
References: <20260905104323.2202902-1-chencheng@fnnas.com> <20260905110026.5C0571F00A3D@smtp.kernel.org>
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260905110026.5C0571F00A3D@smtp.kernel.org>
X-Lms-Return-Path: <lba+26a9e5b3a+7030e2+vger.kernel.org+yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
To: <sashiko-reviews@lists.linux.dev>, "Chen Cheng" <chencheng@fnnas.com>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2] md/raid5: reject raid4/5 arrays with too few disks

Hi,

=E5=9C=A8 2026/9/5 19:00, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index b91545ce090de..4d8bb0cf26055 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -7657,9 +7657,12 @@ static struct r5conf *setup_conf(struct mddev *md=
dev)
>>   			mdname(mddev), mddev->new_layout);
>>   		return ERR_PTR(-EIO);
>>   	}
>> -	if (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4) {
>> -		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n"=
,
>> -			mdname(mddev), mddev->raid_disks);
>> +	if ((mddev->new_level =3D=3D 4 && mddev->raid_disks < 2) ||
>> +	    (mddev->new_level =3D=3D 5 && mddev->raid_disks < 3) ||
> [Severity: High]
> Does this unintentionally break 2-disk RAID5 arrays?
>
> The md driver supports and intentionally creates 2-disk RAID5 arrays duri=
ng a
> RAID1-to-RAID5 reshape. For example, in drivers/md/raid5.c
> raid5_takeover_raid1() creates a 2-disk RAID5:
>
>      mddev->new_level =3D 5;
>      mddev->new_layout =3D ALGORITHM_LEFT_SYMMETRIC;
>      mddev->new_chunk_sectors =3D chunksect;
>
>      ret =3D setup_conf(mddev);
>
> By unconditionally rejecting mddev->new_level =3D=3D 5 && mddev->raid_dis=
ks < 3
> here, doesn't this cause valid reshape operations and assembly of legitim=
ate
> 2-disk RAID5 arrays to fail with -EINVAL?

This make sense, 2 disks raid1 reshape to raid5 should not be broken.

--=20
Thanks,
Kuai
