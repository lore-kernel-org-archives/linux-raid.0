Received: from e234-58.smtp-out.ap-northeast-1.amazonses.com (e234-58.smtp-out.ap-northeast-1.amazonses.com [23.251.234.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF751F583D;
	Wed, 17 Sep 2025 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115236; cv=none; b=o+uziDyygMXJXkoMC+rfadzETAHzO/j2CY1cnPMMCHwlkjjl1wRsBmKrs65rbnAPhF102Ty6imbsb9k2MG5NU1mpG5JxqA48lLPzS4wXSgVC+HSxX7RoUoTFviMKhCgi7SRK+ilDFJVeMU66xI/XVtKqkDqHwcxs8EZkr7l+brM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115236; c=relaxed/simple;
	bh=N2GLUV+AX85e+F04tql32n0Mp67Yd7wpzerXq4DqFz8=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=A3eBU2QQmy/dGiWvCwq8pWf01H34cpvpu5+AIn+v12PqfDAn6aPmxovl1pWtosF6V+Sv3icAkCghmTajt7W7tG/iW49J9JBWmu02S3RcuM0LlXHKN6TljkTk2cYhJaPgb0slntppkHf4i2JrBDF8ccLHH+6AtXwM3PCzivj2SCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=wD92EWGk; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=fxNnneOz; arc=none smtp.client-ip=23.251.234.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="wD92EWGk";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="fxNnneOz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1758115232;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=N2GLUV+AX85e+F04tql32n0Mp67Yd7wpzerXq4DqFz8=;
	b=wD92EWGk44//Ydsa2pG05BXe4i/IjElZC2ZF83sksRwqCGCH2Segk1RvOaS5NhL2
	9zq/UaYG4um5cEb7Uz5cx/jnl8B93qb5up832TSURaqL5yLzrvtV5CFCEaj3u1qouMt
	wm1XbQi6ajjjZgNfxb0fVK72v/wfVf4gK3KmgEmE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1758115232;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=N2GLUV+AX85e+F04tql32n0Mp67Yd7wpzerXq4DqFz8=;
	b=fxNnneOzBZoKAke5WDWiZWVe37n8ri2bq2nm1dGTHE5jIwqhBgmQGzSe0SaPJNkv
	JT31JAKjsPfrTTwSv2fj2O5KIkGOXFyuNHPGQnxwfpi52ZkGPnMmvve3Y072xLRB4bL
	1pId5bhkPemSdH+SPcS4mRIw2Uec4jLUZxF+Ja38=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <837a4dd4-045f-a956-a241-cab1e8bc20fe@huaweicloud.com>
From: Kenta Akagi <k@mgml.me>
To: linan666@huaweicloud.com, song@kernel.org, yukuai3@huawei.com, 
	mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, k@mgml.me
Subject: Re: [PATCH v4 5/9] md/raid1,raid10: Set R{1,10}BIO_Uptodate when
 successful retry of a failed bio
Message-ID: <0106019957d57c2f-0a8ed8f8-adad-4351-b86e-368f0bbd7069-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Sep 2025 13:20:32 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.09.17-23.251.234.58

Hi,
Thank you for reviewing.

On 2025/09/17 18:24, Li Nan wrote:
>=20
>=20
> =E5=9C=A8 2025/9/15 11:42, Kenta Akagi =E5=86=99=E9=81=93:
>> In the current implementation, when a write bio fails, the retry flow
>> is as follows:
>> * In bi_end_io, e.g. raid1_end_write_request, =
R1BIO_WriteError is
>> =C2=A0=C2=A0 set on the r1bio.
>> * The md thread calls handle_write_finished corresponding to this r1bio.
>> * Inside handle_write_finished, narrow_write_error is invoked.
>> * narrow_write_error rewrites the r1bio on a per-sector basis, marking
>> =C2=A0=C2=A0 any failed sectors as badblocks. It returns true if all =
sectors succeed,
>> =C2=A0=C2=A0 or if failed sectors are successfully =
recorded via rdev_set_badblock.
>> =C2=A0=C2=A0 It returns false if =
rdev_set_badblock fails or if badblocks are disabled.
>> * handle_write_finished faults the rdev if it receives false from
>> =C2=A0=C2=A0 narrow_write_error. Otherwise, it does nothing.
>>
>> This can cause a problem where an r1bio that succeeded on retry is
>> incorrectly reported as failed to the higher layer, for example in the
>> following case:
>> * Only one In_sync rdev exists, and
>> * The write bio initially failed but all retries in
>> =C2=A0=C2=A0 narrow_write_error succeed.
>>
>> This commit ensures that =
if a write initially fails but all retries in
>> narrow_write_error succeed=
, R1BIO_Uptodate or R10BIO_Uptodate is set
>> and the higher layer receives=
 a successful write status.
>>
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>> =C2=A0 drivers/md/raid1.c=C2=A0 | 32 ++++++++++++++++++++++++++--=
----
>> =C2=A0 drivers/md/raid10.c | 21 +++++++++++++++++++++
>> =C2=A0 2 files changed, 47 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 8fff9dacc6e0..806f5cb33a8e 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2517,6 +2517,21 @@ static void =
fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 }
>> =C2=A0 +/**
>> + * narrow_write_error() - Retry write and set badblock
>> + * @r1_bio:=C2=A0=C2=A0=C2=A0 the r1bio containing the write error
>> + * @i:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 which device to retry
>> + *
>> + * Rewrites the bio, splitting it at the least common multiple =
of the logical
>> + * block size and the badblock size. Blocks that fail to=
 be written are marked
>> + * as bad. If badblocks are disabled, no write =
is attempted and false is
>> + * returned immediately.
>> + *
>> + * Return:
>> + * * %true=C2=A0=C2=A0=C2=A0 - all blocks were written =
or marked bad successfully
>> + * * %false=C2=A0=C2=A0=C2=A0 - bbl disabled=
 or
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 one or =
more blocks write failed and could not be marked bad
>> + */
>> =C2=A0 static bool narrow_write_error(struct r1bio *r1_bio, int i)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mddev *mddev =3D =
r1_bio->mddev;
>> @@ -2614,9 +2629,9 @@ static void =
handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int m, idx;
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 bool fail =3D false;
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 for (m =3D 0; m <=
 conf->raid_disks * 2 ; m++)
>> +=C2=A0=C2=A0=C2=A0 for (m =3D 0; m < =
conf->raid_disks * 2 ; m++) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 struct md_rdev *rdev =3D conf->mirrors[m].rdev;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(r1_bio->bios[m] =3D=3D IO_MADE_GOOD) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev =3D =
conf->mirrors[m].rdev;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev_clear_badblocks(rdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 r1_bio->sector,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r1_bio->sectors, 0);
>> @@ -2628,12 +2643,17 @@ static void handle_write_finished(struct r1conf =
*conf, struct r1bio *r1_bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 fail =3D true;
>=20
> 'fail' should be false when re-write is =
successful.

Thanks, it seems there is no need to handle it with =
bio_end_io_list when successful re-write.
I will fix it.
>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (!narrow_write_error(r1_bio, m))
>> =
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 md_error(conf->mddev,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 conf->mirrors[m].rdev);
>> =
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 md_error(conf->mddev, rdev);
>> =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 /* an I/O failed, we can't clear the bitmap */
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
rdev_dec_pending(conf->mirrors[m].rdev,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 conf->mddev);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else if (test_bit(In_sync, =
&rdev->flags) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !test_bit(Faulty, =
&rdev->flags) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev_has_badblock(rdev,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 r1_bio->sector,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r1_bio->sectors) =
=3D=3D 0)
>=20
> Clear badblock and set R10BIO_Uptodate if rdev has =
badblock.

narrow_write_error returns true when the write succeeds, or when=
 the write
fails but rdev_set_badblocks succeeds. Here, it determines that =
the re-write
succeeded if there is no badblock in the sector to be written =
by r1_bio.
So we should not call rdev_clear_badblocks here.

>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(R1BIO_Uptodate, &r1_bio->state);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
rdev_dec_pending(rdev, conf->mddev);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (fail) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irq(&conf->device_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index b73af94a88b0..21c2821453e1 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -2809,6 +2809,21 @@ static void =
fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 }
>> =C2=A0 +/**
>> + * narrow_write_error() - Retry write and set badblock
>> + * @r10_bio:=C2=A0=C2=A0=C2=A0 the r10bio containing the write error
>> + * @i:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 which device to retry
>> + *
>> + * Rewrites the bio, splitting it at the least common multiple =
of the logical
>> + * block size and the badblock size. Blocks that fail to=
 be written are marked
>> + * as bad. If badblocks are disabled, no write =
is attempted and false is
>> + * returned immediately.
>> + *
>> + * Return:
>> + * * %true=C2=A0=C2=A0=C2=A0 - all blocks were written =
or marked bad successfully
>> + * * %false=C2=A0=C2=A0=C2=A0 - bbl disabled=
 or
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 one or =
more blocks write failed and could not be marked bad
>> + */
>> =C2=A0 static bool narrow_write_error(struct r10bio *r10_bio, int i)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bio *bio =3D =
r10_bio->master_bio;
>> @@ -2975,6 +2990,12 @@ static void =
handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fail =3D true;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!narrow_write_error(r10_bio, m))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
md_error(conf->mddev, rdev);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else if =
(test_bit(In_sync, &rdev->flags) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 !test_bit(Faulty, &rdev->flags) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
rdev_has_badblock(rdev,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
r10_bio->devs[m].addr,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
r10_bio->sectors) =3D=3D 0)
>=20
> Same as raid1.

I think it is the same =
as RAID1. should not call rdev_clear_badblocks.


Thanks,
Akagi

>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(R10BIO_Uptodate, =
&r10_bio->state);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
rdev_dec_pending(rdev, conf->mddev);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 bio =3D r10_bio->devs[m].repl_bio;
>=20
> --=C2=A0
> Thanks,
> Nan
>=20
>=20

