Received: from e234-55.smtp-out.ap-northeast-1.amazonses.com (e234-55.smtp-out.ap-northeast-1.amazonses.com [23.251.234.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664702C3261;
	Wed, 17 Sep 2025 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116036; cv=none; b=AQ5+h8xiXX8Vu9maUj+FbJjitMnx2XnNq5/2B+v5ms+oV69LuxUDJSKXBSuo/22+/OJVgyEpHSCKd4CL3b6c/odnaTxR2imIoORIKzI4cmaQy5qCryN3ybw7Cjc8I/m0Ag/IF6XoEAVQ/WvoI71BBJbgCQApSFcM7y+5eIrkbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116036; c=relaxed/simple;
	bh=Cjh4v+J2bFRLHvfsScP46gK0Iythz2QHOXpvMuzppN0=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=WWPX2bdh5Wp1j6fOz75nB1lhBedECT/T9vJOZD85CXpkZk1MvM0njPxqG4dY9HHOh8HT9LYTqT5LZkOZnAqW2C9p/qkWNtXS81YYvMzzBJRMWCoCAy/5c5PAlNFZbbVnws56l2wGLzUWoc7UM6YfNbw6B+FIJcfG80s9gMr6uxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=F9PlF/PF; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=fsKV0Qo0; arc=none smtp.client-ip=23.251.234.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="F9PlF/PF";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="fsKV0Qo0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1758116033;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=Cjh4v+J2bFRLHvfsScP46gK0Iythz2QHOXpvMuzppN0=;
	b=F9PlF/PFmpWDT+Ps1Yfz6OO7a7rSxs076AkLpSrncHwE5A6RLhP3OyuxxtKFH8uh
	9cbGDhyMp4pmSz9SH4rodeTHar3xm4Hs0WwUJz3A3g6u+ImS/b9/2wdghxJx8uY+anN
	jBVNCDcPUgJ7EPkbOz3MpYHKHa9me6k4Se4VV1ZA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1758116033;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=Cjh4v+J2bFRLHvfsScP46gK0Iythz2QHOXpvMuzppN0=;
	b=fsKV0Qo01bb2avUyYgv0K+lSYSzxp/9MWEJ6L6ZxHpZEbnyVSZSYaZV4BHndK4WD
	PyFt48nm4hVDCcFqwWX9MSZ+jEW9vYZbwJ/mGbBaE3Wiu7aH4VhpbCMtmVC/kvXtiJm
	/RnUg9yQXsd0mGiLFLB3b3QsCNcKsttpxaCT+NZU=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <cd9aa561-7a0a-3400-1896-8afed3d7cbb3@huaweicloud.com>
From: Kenta Akagi <k@mgml.me>
To: linan666@huaweicloud.com, song@kernel.org, yukuai3@huawei.com, 
	mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, k@mgml.me
Subject: Re: [PATCH v4 6/9] md/raid1,raid10: Fix missing retries Failfast
 write bios on no-bbl rdevs
Message-ID: <0106019957e1b14a-9a2f2aec-fca2-40f9-9c65-bcdabac6299b-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Sep 2025 13:33:52 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.09.17-23.251.234.55



On 2025/09/17 19:06, Li Nan wrote:
>=20
>=20
> =E5=9C=A8 2025/9/15 11:42,=
 Kenta Akagi =E5=86=99=E9=81=93:
>> In the current implementation, write =
failures are not retried on rdevs
>> with badblocks disabled. This is =
because narrow_write_error, which issues
>> retry bios, immediately returns=
 when badblocks are disabled. As a result,
>> a single write failure on =
such an rdev will immediately mark it as Faulty.
>>
>=20
> IMO, there's no need to add extra logic for scenarios where badblocks
> is not enabled. Do you have real-world scenarios where badblocks is
> disabled?

No, badblocks are enabled in my environment.
I'm fine if it's not added, but I still think it's worth adding WARN_ON =
like:

@@ -2553,13 +2554,17 @@ static bool narrow_write_error(struct r1bio =
*r1_bio, int i)
  fail =3D true;
+ WARN_ON( (bio->bi_opf & MD_FAILFAST) && =
(rdev->badblocks.shift < 0) );
  if (!narrow_write_error(r1_bio, m))

What do you think?


Thanks,
Akagi

>> The retry mechanism appears to have =
been implemented under the assumption
>> that a bad block is involved in =
the failure. However, the retry after
>> MD_FAILFAST write failure depend =
on this code, and a Failfast write request
>> may fail for reasons =
unrelated to bad blocks.
>>
>> Consequently, if failfast is enabled and =
badblocks are disabled on all
>> rdevs, and all rdevs encounter a failfast =
write bio failure at the same
>> time, no retries will occur and the entire=
 array can be lost.
>>
>> This commit adds a path in narrow_write_error to =
retry writes even on rdevs
>> where bad blocks are disabled, and failed =
bios marked with MD_FAILFAST will
>> use this path. For non-failfast cases,=
 the behavior remains unchanged: no
>> retry writes are attempted to rdevs =
with bad blocks disabled.
>>
>> Fixes: 1919cbb23bf1 ("md/raid10: add =
failfast handling for writes.")
>> Fixes: 212e7eb7a340 ("md/raid1: add =
failfast handling for writes.")
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>> =C2=A0 drivers/md/raid1.c=C2=A0 | 44 ++++++++++++++++++++++++++++=
+---------------
>> =C2=A0 drivers/md/raid10.c | 37 =
++++++++++++++++++++++++-------------
>> =C2=A0 2 files changed, 53 =
insertions(+), 28 deletions(-)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !=
test_bit(Faulty, &rdev->flags) &&
>=20
> --=C2=A0
> Thanks,
> Nan
>=20
>=20

