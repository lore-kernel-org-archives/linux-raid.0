Received: from e234-57.smtp-out.ap-northeast-1.amazonses.com (e234-57.smtp-out.ap-northeast-1.amazonses.com [23.251.234.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED79225390;
	Thu, 18 Sep 2025 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208956; cv=none; b=DCgQ6ljjahzne+XIsKrPuFQPj5lRJrmxY505dQM/HOyDrgDMeT9v5a5gvlDTKyLAjYNttVRGt5307Q1Dq00QIkgm0csYJvFqvJWL6itK0etig81DADpNDlBGlPS5o/mEPSTC5pBlMfpYJMmBSZuZ6GzWPWekmxJ+ypRVoUxvUE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208956; c=relaxed/simple;
	bh=+wRW5r809KImjAJ3ytI5cjMx82R3BkcF+tuNTLxsXeU=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=GyToZA5DJx5sh7cy7JXpRvlACfuAgrEWn6wxhPGO6+442dPEUTrAYQAlw6q0hA88dcoBSllf6HExtShv6y8qg5fXN+fV2Bv3DqSa/tGXMnQjQDh0goV4RT8uwRITUTQq3KQnKfdlYGjE07f0GPyjTiECU1Mnvn8LTwEIcLqmPFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=UL1zNQD0; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=cWZlU5sm; arc=none smtp.client-ip=23.251.234.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="UL1zNQD0";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="cWZlU5sm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1758208952;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=+wRW5r809KImjAJ3ytI5cjMx82R3BkcF+tuNTLxsXeU=;
	b=UL1zNQD0h6aEKc965I1WJaXXD7qhxX1dJqLUUz5vcKugqOC6uJ6vxEKIwwqKI7eP
	c6SJKa3lHD0xGbcQ8M0UKDuz1CngneOvXRYOdzoKGrXrr9NghoowxC1QDfRrsetzZpQ
	BjTD7leZBZClgxu3aptA3BBVUHsCaHqqBNd1rMlk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1758208952;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=+wRW5r809KImjAJ3ytI5cjMx82R3BkcF+tuNTLxsXeU=;
	b=cWZlU5smWzUAFDvVSrI2KBRoC2A0dFtPKtgRJZ5BWvXQkQ+iMSAgTDeUTTEEOaYj
	e+2LP91XNsg4EKELomvDm6+PBH+4Gb/wXkhaK/QAhhUCRVvDoS1A/CDdKBZ1XxXeO2L
	VXle3ouuu5Ke3Lm7iasM7DwjL5pU13HkJ5zlZYX0=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <1c71d0c8-dc3a-9dbf-4e69-e444f94c7ab8@huaweicloud.com>
From: Kenta Akagi <k@mgml.me>
To: yukuai1@huaweicloud.com, song@kernel.org, mtkaczyk@kernel.org, 
	shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, k@mgml.me
Subject: Re: [PATCH v4 4/9] md/raid1,raid10: Don't set MD_BROKEN on
 failfast bio failure
Message-ID: <010601995d6b88a4-423a9b3c-3790-4d65-86a4-20a9ddea0686-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Sep 2025 15:22:32 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.09.18-23.251.234.57



On 2025/09/18 10:26, Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2025/09/15 =
11:42, Kenta Akagi =E5=86=99=E9=81=93:
>> Failfast is a feature implemented=
 only for RAID1 and RAID10. It instructs
>> the block device providing the =
rdev to immediately return a bio error
>> without retrying if any issue =
occurs. This allows quickly detaching a
>> problematic rdev and minimizes =
IO latency.
>>
>> Due to its nature, failfast bios can fail easily, and md =
must not mark
>> an essential rdev as Faulty or set MD_BROKEN on the array =
just because
>> a failfast bio failed.
>>
>> When failfast was introduced, =
RAID1 and RAID10 were designed to continue
>> operating normally even if =
md_error was called for the last rdev. However,
>> with the introduction of=
 MD_BROKEN in RAID1/RAID10
>> in commit 9631abdbf406 ("md: Set MD_BROKEN =
for RAID1 and RAID10"), calling
>> md_error for the last rdev now prevents =
further writes to the array.
>> Despite this, the current failfast error =
handler still assumes that
>> calling md_error will not break the array.
>>
>> Normally, this is not an issue because MD_FAILFAST is not set when a bio
>> is issued to the last rdev. However, if the array is not degraded and a
>> bio with MD_FAILFAST has been issued, simultaneous failures could
>> potentially break the array. This is unusual but can happen; for example=
,
>> this can occur when using NVMe over TCP if all rdevs depend on
>> a single Ethernet link.
>>
>> In other words, this becomes a problem =
under the following conditions:
>> Preconditions:
>> * Failfast is enabled =
on all rdevs.
>> * All rdevs are In_sync - This is a requirement for bio to=
 be submit
>> =C2=A0=C2=A0 with MD_FAILFAST.
>> * At least one bio has been=
 submitted but has not yet completed.
>>
>> Trigger condition:
>> * All underlying devices of the rdevs return an error for their failfast
>> =C2=A0=C2=A0 bios.
>>
>> Whether the bio is a read or a write makes =
little difference to the
>> outcome.
>> In the write case, md_error is =
invoked on each rdev through its bi_end_io
>> handler.
>> In the read case, losing the first rdev triggers a metadata
>> update. Next, md_super_write, unlike raid1_write_request, issues the bio
>> with MD_FAILFAST if the rdev supports it, causing the bio to fail
>> immediately - Before this patchset, LastDev was set only by the failure
>> path in super_written. Consequently, super_written calls md_error on the
>> remaining rdev.
>>
>> Prior to this commit, the following changes were =
introduced:
>> * The helper function md_bio_failure_error() that skips the =
error handler
>> =C2=A0=C2=A0 if a failfast bio targets the last rdev.
>> * Serialization md_error() and md_bio_failure_error().
>> * Setting the LastDev flag for rdevs that must not be lost.
>>
>> This commit uses md_bio_failure_error() instead of md_error() for =
failfast
>> bio failures, ensuring that failfast bios do not stop array =
operations.
>>
>> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and =
RAID10")
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>> =C2=A0 drivers/md/md.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 +----
>> =C2=A0 drivers/md/raid1.c=C2=A0 | 37 ++++++++++++++++++-----------------=
--
>> =C2=A0 drivers/md/raid10.c |=C2=A0 9 +++++----
>> =C2=A0 3 files changed, 24 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 65fdd9bae8f4..=
65814bbe9bad 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1004,11 +1004,8 @@ static void super_written(struct bio *bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bio->bi_status) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("md: %s =
gets error=3D%d\n", __func__,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
blk_status_to_errno(bio->bi_status));
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 md_error(mddev, rdev);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (!test_bit(Faulty, &rdev->flags)
>> =
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 && =
(bio->bi_opf & MD_FAILFAST)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (!md_bio_failure_error(mddev, rdev, bio))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
bio_put(bio);
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 32ad6b102ff7..8fff9dacc6e0 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -470,7 +470,7 @@ static void =
raid1_end_write_request(struct bio *bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (bio->bi_opf & =
MD_FAILFAST) &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 /* We never try FailFast to WriteMostly devices */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 !test_bit(WriteMostly, &rdev->flags)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
md_error(r1_bio->mddev, rdev);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_bio_failure_error(r1_bio->mddev, rdev, =
bio);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> Can following check of faulty replaced with return value?

In the case where raid1_end_write_request is called for a non-failfast IO,
and the rdev has already been marked Faulty by another bio, it must not =
retry too.
I think it would be simpler not to use a return value here.

>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> @@ -2178,8 +2178,7 @@ static int fix_sync_read_error(struct r1bio =
*r1_bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(FailFast, =
&rdev->flags)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/* Don't try recovering from here - just fail it
>> =
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * ... unless =
it is the last working device of course */
>> -=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 md_error(mddev, rdev);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (test_bit(Faulty, &rdev->flags))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (md_bio_failure_error(mdd=
ev, rdev, bio))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 /* Don't try to read from here, but make sure
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 * put_buf does it's thing
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> @@ -2657,9 +2656,8 @@ static void handle_write_finished(struct r1conf =
*conf, struct r1bio *r1_bio)
>> =C2=A0 static void handle_read_error(struct=
 r1conf *conf, struct r1bio *r1_bio)
>> =C2=A0 {
>> =
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mddev *mddev =3D conf->mddev;
>> -=C2=A0=C2=A0=C2=A0 struct bio *bio;
>> +=C2=A0=C2=A0=C2=A0 struct bio =
*bio, *updated_bio;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev;
>> -=C2=A0=C2=A0=C2=A0 sector_t sector;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 clear_bit(R1BIO_ReadError, &r1_bio->state);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* we got a read error. Maybe the drive =
is bad.=C2=A0 Maybe just
>> @@ -2672,29 +2670,30 @@ static void =
handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0 =
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio =3D r1_bio->bios[r1_bio->read_disk];
>> -=C2=A0=C2=A0=C2=A0 bio_put(bio);
>> -=C2=A0=C2=A0=C2=A0 =
r1_bio->bios[r1_bio->read_disk] =3D NULL;
>> +=C2=A0=C2=A0=C2=A0 =
updated_bio =3D NULL;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev =3D =
conf->mirrors[r1_bio->read_disk].rdev;
>> -=C2=A0=C2=A0=C2=A0 if (mddev->ro=
 =3D=3D 0
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 && !=
test_bit(FailFast, &rdev->flags)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 freeze_array(conf, 1);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 fix_read_error(conf, r1_bio);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 unfreeze_array(conf);
>> -=C2=A0=C2=A0=C2=A0 } else if =
(mddev->ro =3D=3D 0 && test_bit(FailFast, &rdev->flags)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_error(mddev, rdev);
>> +=C2=A0=C2=A0=C2=A0 if (mddev->ro =3D=3D 0) {
>> =
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!test_bit(FailFast, =
&rdev->flags)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 freeze_array(conf, 1);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fix_read_error(conf, r1_bio);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
unfreeze_array(conf);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else=
 {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
md_bio_failure_error(mddev, rdev, bio);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r1_bio->bios[r1_bio->read_di=
sk] =3D IO_BLOCKED;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
updated_bio =3D IO_BLOCKED;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> I'll suggest a separate patch to cleanup the conditions first, it's
> better for code review.

Thank you for your guidance. I will split the =
commit.

>=20
> BTW, I'll prefer if else chain insted of nested if else, =
perhaps
> following is better:
>=20
> if (mddev->ro !=3D 0) {
> =C2=A0/* read-only */
> } else if (!test_bit(FailFast, &rdev->flags) {
> =C2=A0/* read-write and failfast is not set */
> } else {
> =C2=A0/* read-write and failfast is set */
> }

Ah, this looks much =
readable. I'll fix. Thanks.

>> =C2=A0 +=C2=A0=C2=A0=C2=A0 bio_put(bio);
>> +=C2=A0=C2=A0=C2=A0 r1_bio->bios[r1_bio->read_disk] =3D updated_bio;
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev_dec_pending(rdev, conf->mddev);
>> -=C2=A0=C2=A0=C2=A0 sector =3D r1_bio->sector;
>> -=C2=A0=C2=A0=C2=A0 =
bio =3D r1_bio->master_bio;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* =
Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r1_bio->state =3D 0;
>> -=C2=A0=C2=A0=C2=A0 raid1_read_request(mddev, bio, r1_bio->sectors, =
r1_bio);
>> -=C2=A0=C2=A0=C2=A0 allow_barrier(conf, sector);
>> +=C2=A0=C2=A0=C2=A0 raid1_read_request(mddev, r1_bio->master_bio, =
r1_bio->sectors, r1_bio);
>> +=C2=A0=C2=A0=C2=A0 allow_barrier(conf, =
r1_bio->sector);
>> =C2=A0 }
>> =C2=A0 =C2=A0 static void raid1d(struct =
md_thread *thread)
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.=
c
>> index dc4edd4689f8..b73af94a88b0 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -488,7 +488,7 @@ static void =
raid10_end_write_request(struct bio *bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dec_rdev =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (test_bit(FailFast, &rdev->flags) &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (bio->bi_opf & MD_FAILFAST)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 md_error(rdev->mddev, rdev);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 md_bio_failure_error(rdev->mddev, rdev, bio);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
>> =C2=A0
>=20
> Same as raid1, can following check of =
faulty replaced of return value.

Same as RAID1, non-Failfast IO must also =
be handled. Therefore, the Faulty
bit should be checked instead of relying =
on the return value.

>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> @@ -2443,7 +2443,7 @@ static void =
sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>> =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (test_bit(FailFast, =
&rdev->flags)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Just give up on this device */
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
md_error(rdev->mddev, rdev);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_bio_failure_error(rdev->mddev, rdev, =
tbio);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 continue;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* Ok, we need to write this bio, either to correct an
>> @@ -2895,8 +2895,9 @@ static void handle_read_error(struct mddev *mddev,=
 struct r10bio *r10_bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 freeze_array(conf, 1);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 fix_read_error(conf, mddev, r10_bio);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
unfreeze_array(conf);
>> -=C2=A0=C2=A0=C2=A0 } else
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_error(mddev, rdev);
>> +=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 md_bio_failure_error(mddev, rdev, bio);
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev_dec_pending(rdev, mddev);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r10_bio->state =3D 0;
>>
>=20
> And please split this patch for raid1 and raid10.

Understood, I will split it.

Thanks,
Akagi

>=20
> Thanks
> Kuai
>=20
>=20

