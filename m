Received: from e234-58.smtp-out.ap-northeast-1.amazonses.com (e234-58.smtp-out.ap-northeast-1.amazonses.com [23.251.234.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5130302769;
	Thu, 18 Sep 2025 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758212624; cv=none; b=hMBTg1JVShI1G5C1UxtD3TaJi0BqzI2lpBX0TKad5E4BSe+SI7h6l+ulyN32/dimYXt/Yx5hkfBSEO1mwDoMvi15wVOyfWLMde9j6mDUEdEWpdxXbEZCfRFf9YdUB2969mVOMO9oddPuqy+voN0uHKIb3UDhnnaIQL3gSkrFKWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758212624; c=relaxed/simple;
	bh=u/TIKGWb90UND1Ifu9ImpXpO7j7JXL1d5NVo7EjQykE=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=FFTlCIN+XC+ogixo7pIaZrbeusxaJdaU6o2NoA9QwciAo1T1S8PCzXZyOZM00ETplfWjGfjxRJOyMHEHDBCnOZmyilDjJ/2cbR+mmyWRFT2S7iqw4jkWN90OIP2hQilR+kARpQLlp792SMDsEhl7REOOJEcHfAZaur1iJJ+DHrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=RNfVg4an; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=lefDCXN3; arc=none smtp.client-ip=23.251.234.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="RNfVg4an";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="lefDCXN3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1758212620;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=u/TIKGWb90UND1Ifu9ImpXpO7j7JXL1d5NVo7EjQykE=;
	b=RNfVg4anWMzSDxPLwJJVFK7US9FBqHFQHOYSc497AXYQp9F2y3lX4SJqlvYFeSWx
	Z8m8M4R8F+ICf/2UVLdfxnICF9av7Q5Ai9LaPG5BQPDUky3c7A7dPe2V3agcWOKRH0R
	RAK8j6wExssfZvcOsrEHy1VJRkqj+RBY7aOK9SXA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1758212620;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=u/TIKGWb90UND1Ifu9ImpXpO7j7JXL1d5NVo7EjQykE=;
	b=lefDCXN3p6jbeP1CQZinNzC26iPawQVjsj26yBar8Pm1advK1EV/NWwYLKFn04ze
	uAeZ5ZErKmx56kc9YMSRvPRMDcXKTEYqjeP99vevECrQp6t3UU6Q27le0ANYmZsKYka
	SW345WigslNrBv//F3kEfdW6nDL8i9tS1MsuohSw=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <5da5e4c7-47d7-be71-0724-7b03af33324a@huaweicloud.com>
From: Kenta Akagi <k@mgml.me>
To: linan666@huaweicloud.com, song@kernel.org, yukuai3@huawei.com, 
	mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, k@mgml.me
Subject: Re: [PATCH v4 6/9] md/raid1,raid10: Fix missing retries Failfast
 write bios on no-bbl rdevs
Message-ID: <010601995da37ff4-b47cc6d9-a75b-4ef0-bced-e5a9a55c3f77-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Sep 2025 16:23:40 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.09.18-23.251.234.58



On 2025/09/18 15:58, Li Nan wrote:
>=20
>=20
> =E5=9C=A8 2025/9/17 21:33,=
 Kenta Akagi =E5=86=99=E9=81=93:
>>
>>
>> On 2025/09/17 19:06, Li Nan =
wrote:
>>>
>>>
>>> =E5=9C=A8 2025/9/15 11:42, Kenta Akagi =
=E5=86=99=E9=81=93:
>>>> In the current implementation, write failures are =
not retried on rdevs
>>>> with badblocks disabled. This is because =
narrow_write_error, which issues
>>>> retry bios, immediately returns when =
badblocks are disabled. As a result,
>>>> a single write failure on such an=
 rdev will immediately mark it as Faulty.
>>>>
>>>
>>> IMO, there's no need=
 to add extra logic for scenarios where badblocks
>>> is not enabled. Do =
you have real-world scenarios where badblocks is
>>> disabled?
>>
>> No, badblocks are enabled in my environment.
>> I'm fine if it's not =
added, but I still think it's worth adding WARN_ON like:
>>
>> @@ -2553,13 +2554,17 @@ static bool narrow_write_error(struct r1bio =
*r1_bio, int i)
>> =C2=A0=C2=A0 fail =3D true;
>> + WARN_ON( (bio->bi_opf &=
 MD_FAILFAST) && (rdev->badblocks.shift < 0) );
>> =C2=A0=C2=A0 if (!=
narrow_write_error(r1_bio, m))
>>
>> What do you think?
>>
>=20
> How about this?
>=20
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.=
c
> @@ -2522,10 +2522,11 @@ static bool narrow_write_error(struct r1bio =
*r1_bio, int i)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool ok =3D =
true;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rdev->badblocks=
.shift < 0)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
> +=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block_sectors =
=3D bdev_logical_block_size(rdev->bdev) >> 9;
> +=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block_sectors =3D roundup(1 << =
rdev->badblocks.shift,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bdev_logical_block_size(rdev->bd=
ev) >> 9);
>=20
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block_sectors =3D =
roundup(1 << rdev->badblocks.shift,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 bdev_logical_block_size(rdev->bdev) >> 9);
> =
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sector =3D r1_bio->sector;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectors =3D ((sector + =
block_sectors)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 & =
~(sector_t)(block_sectors - 1))
>=20
> rdev_set_badblocks() checks shift, =
too. rdev is marked to Faulty if setting
> badblocks fails.

Sounds good. If badblocks are disabled, rdev_set_badblocks() returns false,=
 so there
should be no problem.

Can this be included in the cleanup?
https://lore.kernel.org/linux-raid/20250917093508.456790-3-linan666@huaweic=
loud.com/T/#u

or should I resend this patch as proposed?

Thanks,
Akagi

>=20
>=20
>>
>> Thanks,
>> Akagi
>>
>>>> The retry mechanism appears to =
have been implemented under the assumption
>>>> that a bad block is =
involved in the failure. However, the retry after
>>>> MD_FAILFAST write =
failure depend on this code, and a Failfast write request
>>>> may fail for reasons unrelated to bad blocks.
>>>>
>>>> Consequently, if failfast is enabled and badblocks are disabled on all
>>>> rdevs, and all rdevs encounter a failfast write bio failure at the =
same
>>>> time, no retries will occur and the entire array can be lost.
>>>>
>>>> This commit adds a path in narrow_write_error to retry writes =
even on rdevs
>>>> where bad blocks are disabled, and failed bios marked =
with MD_FAILFAST will
>>>> use this path. For non-failfast cases, the =
behavior remains unchanged: no
>>>> retry writes are attempted to rdevs =
with bad blocks disabled.
>>>>
>>>> Fixes: 1919cbb23bf1 ("md/raid10: add =
failfast handling for writes.")
>>>> Fixes: 212e7eb7a340 ("md/raid1: add =
failfast handling for writes.")
>>>> Signed-off-by: Kenta Akagi <k@mgml.me>
>>>> ---
>>>> =C2=A0=C2=A0 drivers/md/raid1.c=C2=A0 | 44 =
+++++++++++++++++++++++++++++---------------
>>>> =C2=A0=C2=A0 =
drivers/md/raid10.c | 37 ++++++++++++++++++++++++-------------
>>>> =C2=A0=C2=A0 2 files changed, 53 insertions(+), 28 deletions(-)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !test_bit(Faulty, &rdev->flags) &&
>>>
>>> --=C2=A0
>>> Thanks,
>>> Nan
>>>
>>>
>>
>>
>>
>> .
>=20
> --=C2=A0
> Thanks,
> Nan
>=20
>=20

