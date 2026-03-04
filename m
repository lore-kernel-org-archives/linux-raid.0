Received: from sg-1-40.ptr.blmpb.com (sg-1-40.ptr.blmpb.com [118.26.132.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193871DDC1B
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 02:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772591905; cv=none; b=nZ2smRBW9Uh3ZMTdc1nQxDcVJ54+G1HnGs1JQ32AkoBhhLe3/fOrjijJ7OuplRVBFObDgL7FKtknl3eRtOTF5kQc7YLRCfEBkBRjEKikoCW40bEcpgA+WAWoH48nqmikxIV/ho7seaZ545l0z67UywDzwG72U2l7Q36uRrM6CMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772591905; c=relaxed/simple;
	bh=wjice0ZpfdZEj3p6iNIPqvVKspu3pO8tVFgbPLPfulQ=;
	h=From:Message-Id:In-Reply-To:To:Mime-Version:Content-Type:Subject:
	 Date:References:Cc; b=GIpVw3UiioF+xO6klxA4Ne9wQoQ9GUfxTqNbobztknByPIBklgeC61sv2dTeJ4lED/i8xDxTOMHwf7xpKefOeF1d76cxw7uwMJwLgu16QnApLYvniDoann6UecyzGiH7WN7P6jVNGyCHV2J0idI6s1eaoLgELWV5i2ZdhP8AO8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=f1CnaAG7; arc=none smtp.client-ip=118.26.132.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="f1CnaAG7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772591782;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=wjice0ZpfdZEj3p6iNIPqvVKspu3pO8tVFgbPLPfulQ=;
 b=f1CnaAG7VgpVpFlJlZgZczZ6LEjeTS6znON1HuLVfTiu8bJvNJJxybIdmrU0veXB8ezaPs
 WEA3gjntWMVvi2fZPxiCgGO+Ri5HqohwxZtdfgCUG8BpfIJiIfPh+hKB3/vKvDYcHgf6OU
 68kbV9e97urjouHEtRKEdSX/dTlglf9/eLWvsYS3YVsHy9I2NYQ8iCX8qXHREGM+QdHyFc
 u/0DwNSrh2JAIGW4sYjSvJC5VLRu34/LvfSB7cTyPWyM1uAf9SC+KsK0BEhWln1s2uYS3p
 digASqFeutL8HGcRoq/8eC0P7ybkunowEInUK/Uc3pUHv7Mh5Bd3HZ1cDwfY9w==
X-Original-From: Yu Kuai <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <18c49c55-bc45-4ffd-83cb-4884ac024b54@fnnas.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <a48b64d7-e40f-49e3-a118-b27723b09c39@molgen.mpg.de>
To: "Paul Menzel" <pmenzel@molgen.mpg.de>, <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269a79aa4+79a223+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] md/raid5: set chunk_sectors to enable full stripe I/O splitting
User-Agent: Mozilla Thunderbird
Date: Wed, 4 Mar 2026 10:36:17 +0800
Content-Language: en-US
Received: from [192.168.1.104] ([39.182.0.182]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 10:36:18 +0800
References: <20260223035834.3132498-1-yukuai@fnnas.com> <a48b64d7-e40f-49e3-a118-b27723b09c39@molgen.mpg.de>
Reply-To: yukuai@fnnas.com
Cc: <hch@infradead.org>, <song@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linan122@huawei.com>

Hi,

=E5=9C=A8 2026/2/23 15:26, Paul Menzel =E5=86=99=E9=81=93:
> Dear Kuai,
>
>
> Thank you for your patch.
>
> Am 23.02.26 um 04:58 schrieb Yu Kuai:
>> Set chunk_sectors to the full stripe width (io_opt) so that the block
>> layer splits I/O at full stripe boundaries. This ensures that large
>> writes are aligned to full stripes, avoiding the read-modify-write
>> overhead that occurs with partial stripe writes in RAID-5/6.
>>
>> When chunk_sectors is set, the block layer's bio splitting logic in
>> get_max_io_size() uses blk_boundary_sectors_left() to limit I/O size
>> to the boundary. This naturally aligns split bios to full stripe
>> boundaries, enabling more efficient full stripe writes.
>>
>> Test results with 24-disk RAID5 (chunk_size=3D64k):
>> =C2=A0=C2=A0 dd if=3D/dev/zero of=3D/dev/md0 bs=3D10M oflag=3Ddirect
>> =C2=A0=C2=A0 Before: 461 MB/s
>> =C2=A0=C2=A0 After:=C2=A0 520 MB/s=C2=A0 (+12.8%)
>
> Sweet.
>
>> Suggested-by: Christoph Hellwig <hch@infradead.org>
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>
> Once committed, should this be backported to the longterm and stable=20
> series?

Sorry for the delay, this is just performance improvement, I think this wil=
l
not be backported automatically.This patch need to be send to LTS with some
explanation if someone is interested.

>
>> ---
>> =C2=A0 drivers/md/raid5.c | 1 +
>> =C2=A0 1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 8854e024f311..810d936560d1 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -7783,6 +7783,7 @@ static int raid5_set_limits(struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lim.logical_block_size =3D mddev->logical=
_block_size;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lim.io_min =3D mddev->chunk_sectors << 9;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lim.io_opt =3D lim.io_min * (conf->raid_d=
isks - conf->max_degraded);
>> +=C2=A0=C2=A0=C2=A0 lim.chunk_sectors =3D lim.io_opt >> 9;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lim.features |=3D BLK_FEAT_RAID_PARTIAL_S=
TRIPES_EXPENSIVE;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lim.discard_granularity =3D stripe;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lim.max_write_zeroes_sectors =3D 0;
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
>
> Kind regards,
>
> Paul
>
--=20
Thansk,
Kuai
