Received: from e234-53.smtp-out.ap-northeast-1.amazonses.com (e234-53.smtp-out.ap-northeast-1.amazonses.com [23.251.234.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F57D236437;
	Thu, 18 Sep 2025 14:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758207409; cv=none; b=lj92RBnkYZEImq6pbgG5NaxP2XGmNqf4/TviLFMB2nS5UZHlab5v4Z0fSUC2vySdPLvj8knJmU5kAwS3wZnyJdw31Z+UJ4XKGYoSYY6DMpMduJFMbHbB5LOn6wkEr5yqVivdMHb31Ngbbr5XEslErQACNPonWoNbdJoHjCq5vFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758207409; c=relaxed/simple;
	bh=mc5mz3FO6pRf5Hb1/8DjP0+gZ1L6uZ0XtJDpM4X/F08=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=E5NxHjMewMQl99Hv1nqoS/X9ZLAQ0ml46X7VFaUbWhHGyaQs6iiXJ1iV6C92dELJp7eopY7JStB+MUyE65k38XdHc940BFVXgfOlgGs3995gtTiWIVMPl9y2jWeccEsMmks6/cmHSZRLPS3259nVYg9ja5x++xU05P9sO8R4qQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=fPj0rIWN; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=5wsXgSa5; arc=none smtp.client-ip=23.251.234.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="fPj0rIWN";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="5wsXgSa5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1758207403;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=mc5mz3FO6pRf5Hb1/8DjP0+gZ1L6uZ0XtJDpM4X/F08=;
	b=fPj0rIWN8PGiMJ+dc9KdmD+tYRuy9BxIfSYrSIk5wHOjF3Z9POH9Lg87t4SmKkLA
	xjMRO+5mafp2yannsdQWXXjGrxUo0zzhW3wN/DerQXuoX9nkY1zjI4Qp8kfmiFkcUwl
	Z6QLRVDsHC5gUnBbXt61ZhnzoqDJDUYmiy9F6nu0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1758207403;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=mc5mz3FO6pRf5Hb1/8DjP0+gZ1L6uZ0XtJDpM4X/F08=;
	b=5wsXgSa5AQS68lA5ZFNaNyqZEKddaUUYpnt0lr4r28IYsImXIO9XDortEe+RB1FW
	bB9V3ewdoh69kzEDvCUv22dlmLAW3PPx0yFLVJuS5odJWn0w2YYns8YbLjzKZ2FdPo8
	YSD2+MnPM6kFmjIo3CpKukUXhxFHbbKRAQt1w1/U=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <bfe630fa-7668-4a11-6033-20dca0c112f9@huaweicloud.com>
From: Kenta Akagi <k@mgml.me>
To: yukuai1@huaweicloud.com, song@kernel.org, mtkaczyk@kernel.org, 
	shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, k@mgml.me
Subject: Re: [PATCH v4 3/9] md: introduce md_bio_failure_error()
Message-ID: <010601995d53e601-62141e26-a228-405c-a145-728744b06616-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Sep 2025 14:56:43 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.09.18-23.251.234.53



On 2025/09/18 10:09, Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2025/09/15 =
11:42, Kenta Akagi =E5=86=99=E9=81=93:
>> Add a new helper function =
md_bio_failure_error().
>> It is serialized with md_error() under the same =
lock and works
>> almost the same, but with two differences:
>>
>> * Takes the failed bio as an argument
>> * If MD_FAILFAST is set in =
bi_opf and the target rdev is LastDev,
>> =C2=A0=C2=A0 it does not mark the=
 rdev faulty
>>
>> Failfast bios must not break the array, but in the =
current implementation
>> this can happen. This is because MD_BROKEN was =
introduced in RAID1/RAID10
>> and is set when md_error() is called on an =
rdev required for mddev
>> operation. At the time failfast was introduced, =
this was not the case.
>>
>> Before this commit, md_error() has already =
been serialized, and
>> RAID1/RAID10 mark rdevs that must not be set Faulty=
 by Failfast
>> with the LastDev flag.
>>
>> The actual change in bio error=
 handling will follow in a later commit.
>>
>> Signed-off-by: Kenta Akagi =
<k@mgml.me>
>> ---
>> =C2=A0 drivers/md/md.c | 42 +++++++++++++++++++++++++=
+++++++++++++++++
>> =C2=A0 drivers/md/md.h |=C2=A0 4 +++-
>> =C2=A0 2 files changed, 45 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 5607578a6db9..=
65fdd9bae8f4 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8297,6 +8297,48 @@ void md_error(struct mddev *mddev, struct md_rdev=
 *rdev)
>> =C2=A0 }
>> =C2=A0 EXPORT_SYMBOL(md_error);
>> =C2=A0 +/** md_bio_failure_error() - md error handler for MD_FAILFAST =
bios
>> + * @mddev: affected md device.
>> + * @rdev: member device to fail=
.
>> + * @bio: bio whose triggered device failure.
>> + *
>> + * This is almost the same as md_error(). That is, it is serialized at
>> + * the same level as md_error, marks the rdev as Faulty, and changes
>> + * the mddev status.
>> + * However, if all of the following conditions=
 are met, it does nothing.
>> + * This is because MD_FAILFAST bios must not=
 stopping the array.
>> + *=C2=A0 * RAID1 or RAID10
>> + *=C2=A0 * LastDev - if rdev becomes Faulty, mddev will stop
>> + *=C2=A0 * The failed bio has MD_FAILFAST set
>> + *
>> + * Returns: true if _md_error() was called, false if not.
>> + */
>> +bool md_bio_failure_error(struct mddev *mddev, struct md_rdev *rdev, =
struct bio *bio)
>> +{
>> +=C2=A0=C2=A0=C2=A0 bool do_md_error =3D true;
>> +
>> +=C2=A0=C2=A0=C2=A0 spin_lock(&mddev->error_handle_lock);
>> +=C2=A0=C2=A0=C2=A0 if (mddev->pers) {
>=20
> With the respect this is =
only called from IO path, mddev->pers must be
> checked already while =
submitting the bio. You can add a warn here like:
>=20
> if (WARN_ON_ONCE(!mddev->pers))
> =C2=A0=C2=A0=C2=A0=C2=A0/* return true =
because we don't want caller to retry */
> =C2=A0=C2=A0=C2=A0=C2=A0return =
true;

Thank you, Understood. I will fix it.

>> +=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 if (mddev->pers->head.id =3D=3D ID_RAID1 ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
mddev->pers->head.id =3D=3D ID_RAID10) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(LastDev, =
&rdev->flags) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test_bit(FailFast, &rdev->flags)=
 &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio !=3D NULL && (bio->bi_opf & =
MD_FAILFAST))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_md_error =3D false;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> As I suggested in patch 1, this can be:
> =C2=A0=C2=A0=C2=A0=C2=A0if (!=
mddev->pers->lastdev ||
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !=
mddev->pers->lastdev(mddev, rdev, bio)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 __md_error(mddev, rdev);
> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return true;
> =C2=A0=C2=A0=C2=A0=C2=A0}

Understood this too.

Thanks,
Akagi

>=20
> Thanks,
> Kuai
>=20
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 if (do_md_error)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _md_error(mddev, rdev);
>> +=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
pr_warn_ratelimited("md: %s: %s didn't do anything for %pg\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
mdname(mddev), __func__, rdev->bdev);
>> +
>> +=C2=A0=C2=A0=C2=A0 =
spin_unlock(&mddev->error_handle_lock);
>> +=C2=A0=C2=A0=C2=A0 return =
do_md_error;
>> +}
>> +EXPORT_SYMBOL(md_bio_failure_error);
>> +
>> =C2=A0 /* seq_file implementation /proc/mdstat */
>> =C2=A0 =C2=A0 static void status_unused(struct seq_file *seq)
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 5177cb609e4b..=
11389ea58431 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -283,7 +283,8 @@ enum flag_bits {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 LastDev,=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* This is the last working rdev=
.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so don't use FailFast any more=
 for
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * metadata.
>> =
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * metadata and don't Fail rdev
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * when FailFast bio failure.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 CollisionCheck,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * check if there is collision =
between raid1
>> @@ -906,6 +907,7 @@ extern void md_write_end(struct mddev =
*mddev);
>> =C2=A0 extern void md_done_sync(struct mddev *mddev, int blocks=
, int ok);
>> =C2=A0 void _md_error(struct mddev *mddev, struct md_rdev =
*rdev);
>> =C2=A0 extern void md_error(struct mddev *mddev, struct md_rdev =
*rdev);
>> +extern bool md_bio_failure_error(struct mddev *mddev, struct =
md_rdev *rdev, struct bio *bio);
>> =C2=A0 extern void =
md_finish_reshape(struct mddev *mddev);
>> =C2=A0 void =
md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 struct bio *bio, sector_t start, sector_t size);
>>
>=20
>=20

