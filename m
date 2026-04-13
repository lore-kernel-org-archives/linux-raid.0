Received: from mail-108-mta188.mxroute.com (mail-108-mta188.mxroute.com [136.175.108.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CBE4A32
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 10:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776075837; cv=none; b=BYnoBeNy3P60PILjSlPCBSUwT9CFZPvVC1UiOfVpOkJZyvw+Z2ZplspCD0jsnGzHnZ5vjDy1c2BqylcA+aetkvoNCigq10n2plSjFUtjORh9YWLqOjYQDPwa/mrdmSwd9Xz4qm8Q7pSnztVxxufTjpx8QW49B96RvpukmTXezD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776075837; c=relaxed/simple;
	bh=Qler94RuNJX+BVLPCzaZseRqQweuQCZcBVZxCCb670I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=atvnJ1EDlAKizgjIo0hmPErcmMch5j/lvh4Qsum/soL/D6IzF+3840T3i8OSlbnhTK9C1hRfflWrRQ32ubF1uzAqLh4FsYFNjPPUYZ3w6hyrDATYmohB60pkvkNPtv82zydLa+yf6noEKpS9IFQK6s9nId1l/UGiwG3ya/0oJqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=qOV68qUY; arc=none smtp.client-ip=136.175.108.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="qOV68qUY"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta188.mxroute.com (ZoneMTA) with ESMTPSA id 19d8659c89f00032bf.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 13 Apr 2026 10:18:44 +0000
X-Zone-Loop: 6ce349be5e85636ece594ba1942ea2b7beb66b201e17
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1TmXBA9WLSqkfLil7KeqE0//UTeyS+2ngtSSVr6s+sA=; b=qOV68qUYzVAmX97giisuDC15bx
	PeicFoH/2ZlACq/duQHCKiqBSLQT4irVcqIfJ5JI7SF2uJSlRp4ggmON8/MZeNgH2oMGxiCgfKmZD
	/KuKef6jpTWWhLBrotZ+2oF9v9qjMf+1PLYs03j6po0wxHN54iVyByxI/t0txATvTwKTlt3LXMKik
	51Ic5JzG50vd86KiW3ZgGHNQMDzrPIDieh5HS6GX8RG2izqwmrbnBAgKdGSBdk1oqbDe8rKLt5Fxz
	L00GFCv6tMWXLwuOd2deA/V1U2W//f/mfnwR9D/lRXTvIb+b9Z6kzdqlTqpCEjshUOJUMPUr9QX5r
	xqfcOCfA==;
From: Su Yue <l@damenly.org>
To: Li Nan <linan666@huaweicloud.com>
Cc: Su Yue <glass.su@suse.com>,  linux-raid@vger.kernel.org,
  song@kernel.org,  xni@redhat.com,  yukuai@fnnas.com,
  heming.zhao@suse.com
Subject: Re: [PATCH v2 1/5] md/md-bitmap: call md_bitmap_create,destroy in
 location_store
In-Reply-To: <5fae3215-4280-fc77-f9e0-2f607176fcd3@huaweicloud.com> (Li Nan's
	message of "Mon, 13 Apr 2026 15:47:54 +0800")
References: <20260407102625.5686-1-glass.su@suse.com>
	<20260407102625.5686-2-glass.su@suse.com>
	<5fae3215-4280-fc77-f9e0-2f607176fcd3@huaweicloud.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Mon, 13 Apr 2026 18:18:32 +0800
Message-ID: <340z9n9j.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

aOn Mon 13 Apr 2026 at 15:47, Li Nan <linan666@huaweicloud.com>=20
wrote:

> =E5=9C=A8 2026/4/7 18:26, Su Yue =E5=86=99=E9=81=93:
>> If bitmap/location is present, mdadm will call=20
>> update_array_info()
>> while growing bitmap from none to internal via=20
>> location_store().
>> md_bitmap_create() is needed to set mddev->bitmap_ops otherwise
>> mddev->bitmap_ops->get_stats() in update_array_info() will=20
>> trigger
>> kernel NULL pointer dereference.
>> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of=20
>> bitmap_ops until
>> creating bitmap")
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>   drivers/md/md-bitmap.c | 11 ++++++++---
>>   drivers/md/md.c        |  4 ++--
>>   drivers/md/md.h        |  2 ++
>>   3 files changed, 12 insertions(+), 5 deletions(-)
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 83378c033c72..2f24aae05552 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev, const=20
>> char *buf, size_t len)
>>   			goto out;
>>   		}
>>   -		bitmap_destroy(mddev);
>> +		md_bitmap_destroy(mddev);
>>   		mddev->bitmap_info.offset =3D 0;
>>   		if (mddev->bitmap_info.file) {
>>   			struct file *f =3D mddev->bitmap_info.file;
>> @@ -2653,15 +2653,20 @@ location_store(struct mddev *mddev,=20
>> const char *buf, size_t len)
>>   				goto out;
>>   			}
>>   +			/*
>> +			 * lockless bitmap shoudle have set bitmap_id
>> +			 * using bitmap_type, so always ID_BITMAP.
>> +			 */
>> +			mddev->bitmap_id =3D ID_BITMAP;
>>   			mddev->bitmap_info.offset =3D offset;
>> -			rv =3D bitmap_create(mddev);
>> +			rv =3D md_bitmap_create(mddev);
>>   			if (rv)
>>   				goto out;
>>     			rv =3D bitmap_load(mddev);
>
> mddev->bitmap_ops->load() should also be used here.

/NOD.
location_store() is only used for ID_BITMAP_NONE and ID_BITMAP, so
mddev->bitmap_ops->load() is always bitmap_load().
But for code consistency, mddev->bitmap_ops->load() is better,=20
will fix it.

--
Su
