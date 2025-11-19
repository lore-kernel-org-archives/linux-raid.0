Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB9130B53F
	for <linux-raid@vger.kernel.org>; Wed, 19 Nov 2025 09:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763542853; cv=none; b=PVZEfnJlQ37aHFSPhykfJ6lBZqoRMYNB2rknv6JKRVc+j4PaPphG2vPxvhdkkpW7Q3C8a6Toe9Tb6M6BwdM23kQnSpPVAGX4mOD9Tuqs5O1iXd1X3Od5+TKP+TuNmBpSUt/uGIpi/4J7vRT16J/mIBofijCOLbP9OJVBdz4gFGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763542853; c=relaxed/simple;
	bh=XrD4NdEXQ/qGZDX9NnecHADH5ttRzcJjZQzBRoK/vKM=;
	h=Subject:In-Reply-To:To:From:Mime-Version:References:Content-Type:
	 Cc:Date:Message-Id; b=H0caj1OtHh411hxXRp7QUZWqjpSGr1xxM5Ij1gMcoDO/YfDhonrJpJ8F753gOFEMVz1Z/REjvhpD/1VQuDtRItm7gBA07Gp0ba29iHnv30t+eCJwwB1F4Geo0ln/llwpEkBKqqHI4e9Ehi6eDvfJfJDS/xbkvfdtyUR6YpDrTFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=zTxBrqBs; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="zTxBrqBs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1763542839;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=XrD4NdEXQ/qGZDX9NnecHADH5ttRzcJjZQzBRoK/vKM=;
 b=zTxBrqBsNFwlWRaBuA1qMbtxT099/VXY/5393MhfZFCkXkGcPDv0yPHBgqAiuXt1BBex5I
 7BNDItuZt89ozNsM2BoaYN5tcNP/PHNMixxuMv/tk63BTqLUMUFJ+0Z2jT/IXwSqkqS1Kw
 y+zpBecDD4CGcNP7QTd18axbX2ukjdmpm1HL6HL5VynQl3yWHvTEG/6rZXHx+/7YXxyHra
 ePQS4G8gMceT4qCzaLetbimY8OHeoDNTHq4v89Czq2wlthxsoxU5+I9Tc0DSKWgJpcVJyy
 cqzvyCzzLtuqwbE5MGatyzoTKr/hdfPHP/XxUgXK9/Z6KzlKG9YbNfCVVgSa7A==
Subject: Re: [PATCH 2/2] md/raid5: fix IO hang when array is broken with IO inflight
In-Reply-To: <d760721e-face-7a19-ba3b-7cc59475ef77@huaweicloud.com>
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: "Li Nan" <linan666@huaweicloud.com>, <linux-raid@vger.kernel.org>, 
	"Yu Kuai" <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251117085557.770572-1-yukuai@fnnas.com> <20251117085557.770572-3-yukuai@fnnas.com> <d760721e-face-7a19-ba3b-7cc59475ef77@huaweicloud.com>
X-Lms-Return-Path: <lba+2691d8735+ddef68+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Organization: fnnas
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 19 Nov 2025 17:00:34 +0800
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Wed, 19 Nov 2025 17:00:36 +0800
Reply-To: yukuai@fnnas.com
Message-Id: <58e61f51-6a28-4d24-a385-4546b7c61a93@fnnas.com>

Hi,

=E5=9C=A8 2025/11/19 16:29, Li Nan =E5=86=99=E9=81=93:
>
>
> =E5=9C=A8 2025/11/17 16:55, Yu Kuai =E5=86=99=E9=81=93:
>> Following test can cause IO hang:
>>
>> mdadm -CvR /dev/md0 -l10 -n4 /dev/sd[abcd] --assume-clean --chunk=3D64K=
=20
>> --bitmap=3Dnone
>> sleep 5
>> echo 1 > /sys/block/sda/device/delete
>> echo 1 > /sys/block/sdb/device/delete
>> echo 1 > /sys/block/sdc/device/delete
>> echo 1 > /sys/block/sdd/device/delete
>>
>> dd if=3D/dev/md0 of=3D/dev/null bs=3D8k count=3D1 iflag=3Ddirect
>>
>> Root cause:
>>
>> 1) all disks removed, however all rdevs in the array is still in sync,
>> IO will be issued normally.
>>
>> 2) IO failure from sda, and set badblocks failed, sda will be faulty
>> and MD_SB_CHANGING_PENDING will be set.
>>
>> 3) error recovery try to recover this IO from other disks, IO will be
>> issued to sdb, sdc, and sdd.
>>
>> 4) IO failure from sdb, and set badblocks failed again, now array is
>> broken and will become read-only.
>>
>> 5) IO failure from sdc and sdd, however, stripe can't be handled anymore
>> because MD_SB_CHANGING_PENDING is set:
>>
>> handle_stripe
>> =C2=A0 handle_stripe
>> =C2=A0 if (test_bit MD_SB_CHANGING_PENDING)
>> =C2=A0=C2=A0 set_bit STRIPE_HANDLE
>> =C2=A0=C2=A0 goto finish
>> =C2=A0=C2=A0 // skip handling failed stripe
>>
>> release_stripe
>> =C2=A0 if (test_bit STRIPE_HANDLE)
>> =C2=A0=C2=A0 list_add_tail conf->hand_list
>>
>> 6) later raid5d can't handle failed stripe as well:
>>
>> raid5d
>> =C2=A0 md_check_recovery
>> =C2=A0=C2=A0 md_update_sb
>> =C2=A0=C2=A0=C2=A0 if (!md_is_rdwr())
>> =C2=A0=C2=A0=C2=A0=C2=A0 // can't clear pending bit
>> =C2=A0=C2=A0=C2=A0=C2=A0 return
>> =C2=A0 if (test_bit MD_SB_CHANGING_PENDING)
>> =C2=A0=C2=A0 break;
>> =C2=A0=C2=A0 // can't handle failed stripe
>>
>> Since MD_SB_CHANGING_PENDING can never be cleared for read-only array,
>> fix this problem by skip this checking for read-only array.
>>
>> Fixes: d87f064f5874 ("md: never update metadata when array is=20
>> read-only.")
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>> ---
>> =C2=A0 drivers/md/raid5.c | 6 ++++--
>> =C2=A0 1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index cdbc7eba5c54..e57ce3295292 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -4956,7 +4956,8 @@ static void handle_stripe(struct stripe_head *sh)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto finish;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (s.handle_bad_blocks ||
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test_bit(MD_SB_CHANGE_PENDIN=
G, &conf->mddev->sb_flags)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (md_is_rdwr(conf->mddev) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test_bit(MD_SB_CHANGE_=
PENDING, &conf->mddev->sb_flags))) {
>
>
> I am not sure where mddev->ro is set to MD_RDONLY =E2=80=94 is it via a u=
ser's=20
> ioctl?

It's from user space daemon, once the array is broken, it'll set array to
read-auto by sysfs api array_state.

>
>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(STRIPE_HA=
NDLE, &sh->state);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto finish;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> @@ -6768,7 +6769,8 @@ static void raid5d(struct md_thread *thread)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int batch_size, r=
eleased;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int offs=
et;
>> =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(MD_SB_CH=
ANGE_PENDING, &mddev->sb_flags))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (md_is_rdwr(mddev) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test=
_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 break;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 released =
=3D release_stripe_list(conf,=20
>> conf->temp_inactive_list);
>

--=20
Thanks,
Kuai
