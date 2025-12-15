Received: from e234-57.smtp-out.ap-northeast-1.amazonses.com (e234-57.smtp-out.ap-northeast-1.amazonses.com [23.251.234.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5408C31196D;
	Mon, 15 Dec 2025 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814891; cv=none; b=ZZxgra6t3cBNqHx3KZdB3i1D/A6GQbxCtVQbwmu1zfgAnZQD9arLR5ZdvNAR5FHYGZfioeeYzP98WoxxE5zswHL5Q3FASaWHx4sGANKxiebO7K766PMhk88tNhrInNngPcvo2ZLrVUrmQRqZ9BTsluCEcvewE220oI7IzaneYUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814891; c=relaxed/simple;
	bh=AbtsDMw8s30o4MM4tjcWqFF2/fX+N2xHLMfv0iEZG4E=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=K6gAyWr2tZbn4mMFL9nkAPm832t4BscJ0XZgddMf1nTk8iNL532OoggOD1vJsyqpmp9ZDrZKbx+WThD19dGX4SASw+YApwWT0AFOsSDRdx/alq6arOoDn8yzsQtjwFbRR1KThzYhHpnmbQyU9pP7IAZJuXeTUcJJRT0JswKt4ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=csf+7lIu; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=NCs+5hUN; arc=none smtp.client-ip=23.251.234.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="csf+7lIu";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="NCs+5hUN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1765814887;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=AbtsDMw8s30o4MM4tjcWqFF2/fX+N2xHLMfv0iEZG4E=;
	b=csf+7lIuLmeAhUBdav3B+l6w4OxFJ5JFS4rk0fi/JcieF2cBUOwzTuUlcToDIyWm
	dvIM7qSHmRsISHikOw0KcMPpZA0CRhBhix60HblTFCblScENgCneYcycDWlpcEN+F9x
	s1cLLnzMF20EcPr9rpfMIiFHUepUaK5DFhJDGykg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1765814887;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=AbtsDMw8s30o4MM4tjcWqFF2/fX+N2xHLMfv0iEZG4E=;
	b=NCs+5hUNOlTi8/u67rb2MAQ9fzxh/qAeS6UkZP1SJxJAPeXZFsM9tNkmaKFNvmHE
	sJ6zVe+lZcOXwZiGGcxHBFbCg0PC/19NkfeFWTcmZCJ0WktpqiJ/M2a4/wIltZSCgbm
	CJWzcjc0fPuvTGYgeoU1LVqiqJqUj/7UJsjLvEeY=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To:
 <CALTww29S+fk2WcR6_Rm1h7X3ktCsi=exp5ZuwKnFGgEBYOAXLA@mail.gmail.com>
From: Kenta Akagi <k@mgml.me>
To: Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, yukuai3@huawei.com, mtkaczyk@kernel.org, 
	jgq516@gmail.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on
 failfast io failure
Message-ID: <0106019b22c4e290-8379f848-c04a-4737-8fcc-baf9aa897164-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Dec 2025 16:08:07 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.12.15-23.251.234.57

Hi, Xiao
Sorry for late reply.

On 2025/11/19 12:13, Xiao Ni wrote:
> Hi Kenta
>=20
> I know the patch set is already V5 now. I'm looking at =
all the emails to understand the evolution process. Because v5 is much more=
 complicated than the original version. I understand the problem already. =
We don't want to set MD_BROKEN for failfast normal/metadata io. Can't it =
work that check FailFast before setting MD_BROKEN, such as:
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 202e510f73a4..7acac7eef514 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1755,12 +1755,13 @@ static void =
raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(In_sync, &rdev->flags) &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (conf->raid_disks - =
mddev->degraded) =3D=3D 1) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 set_bit(MD_BROKEN, &mddev->flags);
>=20
> - =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mddev->fail_last_dev) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!=
mddev->fail_last_dev || test_bit(FailFast, &rdev->flags)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 conf->recovery_disabled =3D mddev->recovery_disabled;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 return;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
set_bit(MD_BROKEN, &mddev->flags);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_bit(Blocked, &rdev->flags);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_and_clear_bit(In_sync, =
&rdev->flags))
>=20
> I know mostly this way can't resolve this problem. =
Because you, Linan and Kuai already talked a lot about this problem. But I =
don't know why this change can't work.=C2=A0

I may have been too concerned=
 with maintaining the behavior seen from the user space.
and I think this method is good.

We may need to consider that raid1/raid10=
 will never MD_BROKEN when rdev has failfast.
MD_BROKEN was introduced to =
raid1/raid10 in 2023, and I believe there are
almost no cases where people =
expect it to become "broken" when the last rdev behaves strangely.
So, rather than complicating error handling for failfast, it seems better =
to have a way of not
set MD_BROKEN when failfast is configured.

I'll sending the next patch using this approach.

Thanks!
Akagi

>=20
> Best Regards
>=20
> Xiao
>=20
> On Fri, Aug 29, 2025 at 12:39=E2=80=AFAM =
Kenta Akagi <k@mgml.me <mailto:k@mgml.me>> wrote:
>=20
>     This commit ensures that an MD_FAILFAST IO failure does not put
>     the array into a broken state.
>=20
>     When failfast is enabled on=
 rdev in RAID1 or RAID10,
>     the array may be flagged MD_BROKEN in the =
following cases.
>     - If MD_FAILFAST IOs to multiple rdevs fail =
simultaneously
>     - If an MD_FAILFAST metadata write to the 'last' rdev =
fails
>=20
>     The MD_FAILFAST bio error handler always calls md_error on=
 IO failure,
>     under the assumption that raid{1,10}_error will neither =
fail
>     the last rdev nor break the array.
>     After commit =
9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>     calling md_error on the 'last' rdev in RAID1/10 always sets
>     the MD_BROKEN flag on the array.
>     As a result, when failfast IO =
fails on the last rdev, the array
>     immediately becomes failed.
>=20
>     Normally, MD_FAILFAST IOs are not issued to the 'last' rdev, so this =
is
>     an edge case; however, it can occur if rdevs in a non-degraded
>     array share the same path and that path is lost, or if a metadata
>     write is triggered in a degraded array and fails due to failfast.
>=20
>     When a failfast metadata write fails, it is retried through the
>     following sequence. If a metadata write without failfast fails,
>     the array will be marked with MD_BROKEN.
>=20
>     1. MD_SB_NEED_REWRITE is set in sb_flags by super_written.
>     2. md_super_wait, called by the function executing md_super_write,
>     =C2=A0 =C2=A0returns -EAGAIN due to MD_SB_NEED_REWRITE.
>     3. The caller of md_super_wait (e.g., md_update_sb) receives the
>     =C2=A0 =C2=A0negative return value and retries md_super_write.
>     4. md_super_write issues the metadata write again,
>     =C2=A0 =C2=A0this time without MD_FAILFAST.
>=20
>     Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
>     Signed-off-by: Kenta Akagi <k@mgml.me <mailto:k@mgml.me>>
>     ---
>     =C2=A0drivers/md/md.c=C2=A0 =C2=A0 =C2=A0| 14 +++++++++-----
>     =C2=A0drivers/md/md.h=C2=A0 =C2=A0 =C2=A0| 13 +++++++------
>     =C2=A0drivers/md/raid1.c=C2=A0 | 18 ++++++++++++++++--
>     =C2=A0drivers/md/raid10.c | 21 ++++++++++++++++++---
>     =C2=A04 files changed, 50 insertions(+), 16 deletions(-)
>=20
>     diff --git a/drivers/md/md.c b/drivers/md/md.c
>     index ac85ec73a409..547b88e253f7 100644
>     --- a/drivers/md/md.c
>     +++ b/drivers/md/md.c
>     @@ -999,14 +999,18 @@ static void =
super_written(struct bio *bio)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 if =
(bio->bi_status) {
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 pr_err("md: %s gets error=3D%d\n", __func__,
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0blk_status_to_errno(bio->bi_status));
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if =
(bio->bi_opf & MD_FAILFAST)
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_bit(FailfastIOFailure, =
&rdev->flags);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 md_error(mddev, rdev);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 if (!test_bit(Faulty, &rdev->flags)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 && (bio->bi_opf & MD_FAILFAST)) {
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_warn("md: %s: =
Metadata write will be repeated to %pg\n",
>     +=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0mdname(mddev), rdev->bdev);
>     =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>     -=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0set_bit(LastDev, &rdev->flags);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0} else
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0clear_bit(LastDev, &rdev->flags);
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0}=
 else {
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>=20
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
bio_put(bio);
>=20
>     @@ -1048,7 +1052,7 @@ void md_super_write(struct =
mddev *mddev, struct md_rdev *rdev,
>=20
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
if (test_bit(MD_FAILFAST_SUPPORTED, &mddev->flags) &&
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 test_bit(FailFast, =
&rdev->flags) &&
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!=
test_bit(LastDev, &rdev->flags))
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0!test_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio->bi_opf =
|=3D MD_FAILFAST;
>=20
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
atomic_inc(&mddev->pending_writes);
>     @@ -1059,7 +1063,7 @@ int =
md_super_wait(struct mddev *mddev)
>     =C2=A0{
>     =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /* wait for all superblock writes that were scheduled to complete =
*/
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_event(mddev->sb_wait, =
atomic_read(&mddev->pending_writes)=3D=3D0);
>     -=C2=A0 =C2=A0 =C2=A0 =
=C2=A0if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_bit(MD_SB_NEED_REWRITE, =
&mddev->sb_flags))
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return -EAGAIN;
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>     =C2=A0}
>     diff --git a/drivers/md/md.h b/drivers/md/md.h
>     index 51af29a03079..52c9fc759015 100644
>     --- a/drivers/md/md.h
>     +++ b/drivers/md/md.h
>     @@ -281,9 +281,10 @@ enum flag_bits {
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* It is expects that no =
bad block log
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* is present=
.
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0LastDev,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Seems to be the last working dev as
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * it didn't fail, so don't=
 use FailFast
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * any more =
for metadata
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0FailfastIOFailure,=C2=A0 =
=C2=A0 =C2=A0 /* rdev with failfast IO failure
>     +=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 * but md_error not yet completed.
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If the last rdev has =
this flag,
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * error_handler =
must not fail the array
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0*/
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 CollisionCheck,=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0/*
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0* check if there is collision between raid1
>     @@ -331,8 +332,8 @@=
 struct md_cluster_operations;
>     =C2=A0 * @MD_CLUSTER_RESYNC_LOCKED: =
cluster raid only, which means node, already took
>     =C2=A0 *=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 resync lock, need to release the lock.
>     =C2=A0 * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes=
 is supported as
>     - *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0calls to md_error() will never =
cause the array to
>     - *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0become failed.
>     + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0calls to md_error() with FailfastIOFailure will
>     + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0never cause the array to become failed.
>     =C2=A0 * @MD_HAS_PPL:=C2=A0 The raid array has PPL feature set.
>     =C2=A0 * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs =
feature set.
>     =C2=A0 * @MD_NOT_READY: do_md_run() is active, so =
'array_state', ust not report that
>     @@ -360,7 +361,7 @@ enum =
mddev_sb_flags {
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 MD_SB_CHANGE_DEVS,=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Some device status has =
changed */
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 MD_SB_CHANGE_CLEAN,=C2=A0 =
=C2=A0 =C2=A0/* transition to or from 'clean' */
>     =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 MD_SB_CHANGE_PENDING,=C2=A0 =C2=A0/* switch from 'clean' to =
'active' in progress */
>     -=C2=A0 =C2=A0 =C2=A0 =
=C2=A0MD_SB_NEED_REWRITE,=C2=A0 =C2=A0 =C2=A0/* metadata write needs to be =
repeated */
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0MD_SB_NEED_REWRITE,=C2=A0 =
=C2=A0 =C2=A0/* metadata write needs to be repeated, do not use failfast */
>     =C2=A0};
>=20
>     =C2=A0#define NR_SERIAL_INFOS=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 8
>     diff --git a/drivers/md/raid1.c=
 b/drivers/md/raid1.c
>     index 408c26398321..8a61fd93b3ff 100644
>     --- a/drivers/md/raid1.c
>     +++ b/drivers/md/raid1.c
>     @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio =
*bio)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 (bio->bi_opf & MD_FAILFAST) &&
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* We never try FailFast to =
WriteMostly devices */
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 !test_bit(WriteMostly, &rdev->flags)) {
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0set_bit(FailfastIOFailure, &rdev->flags);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 md_error(r1_bio->mddev, rdev);
>     =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=20
>     @@ -1746,8 +1747,12 @@ =
static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>     =C2=A0 *=C2=A0 =C2=A0 =C2=A0- recovery is interrupted.
>     =C2=A0 *=C2=A0 =C2=A0 =C2=A0- &mddev->degraded is bumped.
>     =C2=A0 *
>     - * @rdev is marked as &Faulty excluding case when =
array is failed and
>     - * &mddev->fail_last_dev is off.
>     + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
>     + * then @mddev and @rdev will not be marked as failed.
>     + *
>     + * @rdev is marked as &Faulty excluding any cases:
>     + *=C2=A0 =C2=A0 =C2=A0- when @mddev is failed and =
&mddev->fail_last_dev is off
>     + *=C2=A0 =C2=A0 =C2=A0- when @rdev is =
last device and &FailfastIOFailure flag is set
>     =C2=A0 */
>     =C2=A0static void raid1_error(struct mddev *mddev, struct md_rdev =
*rdev)
>     =C2=A0{
>     @@ -1758,6 +1763,13 @@ static void =
raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>=20
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(In_sync, &rdev->flags) &&
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (conf->raid_disks - =
mddev->degraded) =3D=3D 1) {
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if (test_and_clear_bit(FailfastIOFailure, =
&rdev->flags)) {
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(&conf->device_lock=
, flags);
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0pr_warn_ratelimited("md/raid1:%s: Failfast IO =
failure on %pg, "
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"last device =
but ignoring it\n",
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0mdname(mddev), rdev->bdev);
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
set_bit(MD_BROKEN, &mddev->flags);
>=20
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mddev->fail_last_dev) {
>     @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio =
*r1_bio)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(FailFast, =
&rdev->flags)) {
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* Don't try recovering from here - just fail it
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* ... =
unless it is the last working device of course */
>     +=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_bit(FailfastIOFailure, =
&rdev->flags);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 md_error(mddev, rdev);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 if (test_bit(Faulty, &rdev->flags))
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* Don't try to read from here, but make sure
>     @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf =
*conf, struct r1bio *r1_bio)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 fix_read_error(conf, r1_bio);
>     =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unfreeze_array(conf);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (mddev->ro =3D=3D 0 && =
test_bit(FailFast, &rdev->flags)) {
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0set_bit(FailfastIOFailure, &rdev->flags);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
md_error(mddev, rdev);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
>     diff --git =
a/drivers/md/raid10.c b/drivers/md/raid10.c
>     index b60c30bfb6c7..=
530ad6503189 100644
>     --- a/drivers/md/raid10.c
>     +++ b/drivers/md/raid10.c
>     @@ -488,6 +488,7 @@ static void =
raid10_end_write_request(struct bio *bio)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dec_rdev =3D 0;
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 if (test_bit(FailFast, &rdev->flags) &&
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (bio->bi_opf & MD_FAILFAST)) {
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_bit(FailfastIOFailure, =
&rdev->flags);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
md_error(rdev->mddev, rdev);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=20
>     @@ -1995,8 +1996,12 @@ static int enough(struct r10conf *conf, int =
ignore)
>     =C2=A0 *=C2=A0 =C2=A0 =C2=A0- recovery is interrupted.
>     =C2=A0 *=C2=A0 =C2=A0 =C2=A0- &mddev->degraded is bumped.
>     =C2=A0 *
>     - * @rdev is marked as &Faulty excluding case when =
array is failed and
>     - * &mddev->fail_last_dev is off.
>     + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
>     + * then @mddev and @rdev will not be marked as failed.
>     + *
>     + * @rdev is marked as &Faulty excluding any cases:
>     + *=C2=A0 =C2=A0 =C2=A0- when @mddev is failed and =
&mddev->fail_last_dev is off
>     + *=C2=A0 =C2=A0 =C2=A0- when @rdev is =
last device and &FailfastIOFailure flag is set
>     =C2=A0 */
>     =C2=A0static void raid10_error(struct mddev *mddev, struct md_rdev =
*rdev)
>     =C2=A0{
>     @@ -2006,6 +2011,13 @@ static void =
raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&conf->device_lock, =
flags);
>=20
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(In_sync, =
&rdev->flags) && !enough(conf, rdev->raid_disk)) {
>     +=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_and_clear_bit(FailfastIOF=
ailure, &rdev->flags)) {
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(&conf->devi=
ce_lock, flags);
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_warn_ratelimited("md/raid10:%s: =
Failfast IO failure on %pg, "
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0"last device but ignoring it\n",
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0mdname(mddev), rdev->bdev);
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
set_bit(MD_BROKEN, &mddev->flags);
>=20
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mddev->fail_last_dev) {
>     @@ -2413,6 +2425,7 @@ static void sync_request_write(struct mddev =
*mddev, struct r10bio *r10_bio)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 continue;
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 } else if (test_bit(FailFast, &rdev->flags)) {
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* Just give up on this device */
>     +=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0set_bit(FailfastIOFailure, &rdev->flags);
>     =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
md_error(rdev->mddev, rdev);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>     @@ -2865,8 +2878,10 @@ static void handle_read_error(struct mddev =
*mddev, struct r10bio *r10_bio)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 freeze_array(conf, 1);
>     =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fix_read_error(conf, mddev, r10_bio);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
unfreeze_array(conf);
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0} else
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
>     +=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_bit(FailfastIOFailure, &rdev->flags);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
md_error(mddev, rdev);
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>=20
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 rdev_dec_pending(rdev, mddev);
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 r10_bio->state =3D 0;
>     --=20
>     2.50.1
>=20
>=20

