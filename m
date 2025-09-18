Received: from e234-51.smtp-out.ap-northeast-1.amazonses.com (e234-51.smtp-out.ap-northeast-1.amazonses.com [23.251.234.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA0C212566;
	Thu, 18 Sep 2025 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758204151; cv=none; b=nN4Hd9KUky0ekX5ekDv1m6gqHSUaSQ5wWILICiCTlfWT0osfGAmcFSgosqtDa6OHwWpu24iQxMukH2gtiFFUoRMk9vgFj3SvC/15nyD2n5nHXCe1G4WXY/2fRN+FXGWwMLVjaO2OXzfFFK4Yi0kJrenYKKebN+0Pz73WfyPGaOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758204151; c=relaxed/simple;
	bh=bVHzuRt80hSLf1PUL/bKwCBioVAjpVm/ohkwJoUKhoE=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=ZHjzYdmIgutNvIeu6oGuJPNOTENWGLmzBzIrUQj57CGSbXMKKAGtakiTe8MJZoKX014GHByRvWimRcCWsPtznyd4Zc7SMa+59KR3Ac4xkLJKmTJtEjQGBI1wbOaTa+gULHv5QcCLz5WocJRGOHNKSEfWTqm031d0ZUj1cDJR14k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=uXuD8uEl; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=tK3Jkuwd; arc=none smtp.client-ip=23.251.234.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="uXuD8uEl";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="tK3Jkuwd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1758204147;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=bVHzuRt80hSLf1PUL/bKwCBioVAjpVm/ohkwJoUKhoE=;
	b=uXuD8uEl0JhbBj4BITQ7qmDiRiSiA9hZhZDTOXQ8o8RZxfgMGguQJpTNivBO5sTr
	TfsPPUU2/dkpA1WqC25YgNrt46xHv2Eowb6aoIVY3SGCx78jwTDfN3RmlDGxDBFHkKf
	zrpzF7XAJF3PH0Irqi3+cO697g1ZDFkafqf5WdF8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1758204147;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=bVHzuRt80hSLf1PUL/bKwCBioVAjpVm/ohkwJoUKhoE=;
	b=tK3JkuwdiDvpR8Gj8uE1JEdj5WVDugpuZWCv3PW+w2xIJC8GSMY37pMbXTqKiRxZ
	0qeS3BqVEjDXyAZuTpTDGZcPaBB3PdIpbeUBKIJvOI4hbnhw9ZXVsGmch2nUN4NyQ5k
	tCw8KVJQYU49Ub+b39v6jopumPskoEOs554odxH8=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <b86ac820-7864-5ec0-fa19-2887d5b44c69@huaweicloud.com>
From: Kenta Akagi <k@mgml.me>
To: yukuai1@huaweicloud.com, song@kernel.org, mtkaczyk@kernel.org, 
	shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, k@mgml.me
Subject: Re: [PATCH v4 1/9] md/raid1,raid10: Set the LastDev flag when the
 configuration changes
Message-ID: <010601995d223615-9dce9a18-2920-4097-8374-2fd4e873fff0-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Sep 2025 14:02:27 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.09.18-23.251.234.51

Hi,
Thank you for reviewing.

On 2025/09/18 10:00, Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2025/09/15 11:42, Kenta Akagi =E5=86=99=E9=81=93:
>> Currently, the LastDev flag is set on an rdev that failed a failfast
>> metadata write and called md_error, but did not become Faulty. It is
>> cleared when the metadata write retry succeeds. This has problems for
>> the following reasons:
>>
>> * Despite its name, the flag is only set =
during a metadata write window.
>> * Unlike when LastDev and Failfast was =
introduced, md_error on the last
>> =C2=A0=C2=A0 rdev of a RAID1/10 array =
now sets MD_BROKEN. Thus when LastDev is set,
>> =C2=A0=C2=A0 the array is =
already unwritable.
>>
>> A following commit will prevent failfast bios =
from breaking the array,
>> which requires knowing from outside the =
personality whether an rdev is
>> the last one. For that purpose, LastDev =
should be set on rdevs that must
>> not be lost.
>>
>> This commit ensures that LastDev is set on the indispensable rdev in a
>> degraded RAID1/10 array.
>>
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>> =C2=A0 drivers/md/md.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +---
>> =C2=A0 drivers/md/md.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 +++---
>> =C2=A0 drivers/md/raid1.c=C2=A0 | 34 +++++++++++++++++++++++++++++++++-
>> =C2=A0 drivers/md/raid10.c | 34 +++++++++++++++++++++++++++++++++-
>> =C2=A0 4 files changed, 70 insertions(+), 8 deletions(-)
>>
> After md_error() is serialized, why not check if rdev is the last rdev
> from md_bio_failure_error() in patch 3 directly? I think it is cleaner
> and code changes should be much less to add a new method like
> pers->lastdev.

That makes sense. I'll proceed that way.

Thanks,
Akagi

>=20
> Thanks,
> Kuai
>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.=
c
>> index 4e033c26fdd4..268410b66b83 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1007,10 +1007,8 @@ static void =
super_written(struct bio *bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (!test_bit(Faulty, &rdev->flags)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 && (bio->bi_opf & MD_FAILFAST)) {
>> =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>> -=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(LastDev, =
&rdev->flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 } else
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 clear_bit(LastDev, &rdev->flags);
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio_put(bio);
>> =C2=A0 diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 51af29a03079..ec598f9a8381 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -281,9 +281,9 @@ enum flag_bits {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * It is expects that no bad =
block log
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * is present.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> -=C2=A0=C2=A0=C2=A0 =
LastDev,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Seems to be the last =
working dev as
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * it didn't fail, so don't use =
FailFast
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * any more for metadata
>> +=C2=A0=C2=A0=C2=A0 LastDev,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/* This is the last working rdev.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so =
don't use FailFast any more for
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * metadata.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 CollisionCheck,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * check if there is collision =
between raid1
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index bf44878ec640..32ad6b102ff7 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1733,6 +1733,33 @@ static void =
raid1_status(struct seq_file *seq, struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(seq, "]");
>> =C2=A0 }
>> =C2=A0 +/**
>> + * update_lastdev - Set or clear LastDev flag for all =
rdevs in array
>> + * @conf: pointer to r1conf
>> + *
>> + * Sets LastDev if the device is In_sync and cannot be lost for the =
array.
>> + * Otherwise, clear it.
>> + *
>> + * Caller must hold =
->device_lock.
>> + */
>> +static void update_lastdev(struct r1conf *conf)
>> +{
>> +=C2=A0=C2=A0=C2=A0 int i;
>> +=C2=A0=C2=A0=C2=A0 int alive_disks =
=3D conf->raid_disks - conf->mddev->degraded;
>> +
>> +=C2=A0=C2=A0=C2=A0 =
for (i =3D 0; i < conf->raid_disks; i++) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev =3D conf->mirrors[i].rdev;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rdev) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(test_bit(In_sync, &rdev->flags) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 alive_disks =
=3D=3D 1)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(LastDev, &rdev->flags);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 clear_bit(LastDev, &rdev->flags);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 }
>> +}
>> +
>> =C2=A0 /**
>> =C2=A0=C2=A0 * raid1_error() - RAID1 error =
handler.
>> =C2=A0=C2=A0 * @mddev: affected md device.
>> @@ -1767,8 +1794,10 @@ static void raid1_error(struct mddev *mddev, =
struct md_rdev *rdev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 set_bit(Blocked, &rdev->flags);
>> -=C2=A0=C2=A0=C2=A0 if =
(test_and_clear_bit(In_sync, &rdev->flags))
>> +=C2=A0=C2=A0=C2=A0 if =
(test_and_clear_bit(In_sync, &rdev->flags)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->degraded++;
>> =
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 update_lastdev(conf);
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(Faulty, =
&rdev->flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&co=
nf->device_lock, flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> @@ -1864,6 +1893,7 @@ static int raid1_spare_active(struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
mddev->degraded -=3D count;
>> +=C2=A0=C2=A0=C2=A0 update_lastdev(conf);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&conf->device_lock=
, flags);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print_conf(conf);
>> @@ -3290,6 +3320,7 @@ static int raid1_run(struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rcu_assign_pointer(conf->thread, NULL);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->private =3D conf;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(MD_FAILFAST_SUPPORTED, =
&mddev->flags);
>> +=C2=A0=C2=A0=C2=A0 update_lastdev(conf);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_set_array_sectors(mddev, =
raid1_size(mddev, 0, 0));
>> =C2=A0 @@ -3427,6 +3458,7 @@ static int =
raid1_reshape(struct mddev *mddev)
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 spin_lock_irqsave(&conf->device_lock, flags);
>> =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 mddev->degraded +=3D (raid_disks - conf->raid_disks);
>> +=C2=A0=C2=A0=C2=A0 update_lastdev(conf);
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 spin_unlock_irqrestore(&conf->device_lock, flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 conf->raid_disks =3D mddev->raid_disks =
=3D raid_disks;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->delta_disks =3D 0;
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index b60c30bfb6c7..dc4edd4689f8 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1983,6 +1983,33 @@ static int =
enough(struct r10conf *conf, int ignore)
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _enough(conf, 1, ignore);
>> =C2=A0 }
>> =C2=A0 +/**
>> + * update_lastdev - Set or clear LastDev flag for all =
rdevs in array
>> + * @conf: pointer to r10conf
>> + *
>> + * Sets LastDev if the device is In_sync and cannot be lost for the =
array.
>> + * Otherwise, clear it.
>> + *
>> + * Caller must hold =
->reconfig_mutex or ->device_lock.
>> + */
>> +static void =
update_lastdev(struct r10conf *conf)
>> +{
>> +=C2=A0=C2=A0=C2=A0 int i;
>> +=C2=A0=C2=A0=C2=A0 int raid_disks =3D max(conf->geo.raid_disks, =
conf->prev.raid_disks);
>> +
>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < =
raid_disks; i++) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct =
md_rdev *rdev =3D conf->mirrors[i].rdev;
>> +
>> +=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 if (rdev) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(In_sync, &rdev->flags) &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 !enough(conf, i))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
set_bit(LastDev, &rdev->flags);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
clear_bit(LastDev, &rdev->flags);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 }
>> +}
>> +
>> =C2=A0 /**
>> =C2=A0=C2=A0 * raid10_error() - RAID10 error handler.
>> =C2=A0=C2=A0 * @mddev: affected md device.
>> @@ -2013,8 +2040,10 @@ =
static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 if =
(test_and_clear_bit(In_sync, &rdev->flags))
>> +=C2=A0=C2=A0=C2=A0 if =
(test_and_clear_bit(In_sync, &rdev->flags)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->degraded++;
>> =
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 update_lastdev(conf);
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 set_bit(Blocked, &rdev->flags);
>> @@ -2102,6 +2131,7 @@ static int =
raid10_spare_active(struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
}
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irqsave(&conf->device_lock, =
flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->degraded -=3D count;
>> +=C2=A0=C2=A0=C2=A0 update_lastdev(conf);
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 spin_unlock_irqrestore(&conf->device_lock, flags);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print_conf(conf);
>> @@ -4159,6 +4189,7 @@ static int raid10_run(struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_set_array_sectors(mddev, size);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->resync_max_sectors =3D size;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(MD_FAILFAST_SUPPORTED, =
&mddev->flags);
>> +=C2=A0=C2=A0=C2=A0 update_lastdev(conf);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (md_integrity_register(mddev))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto =
out_free_conf;
>> @@ -4567,6 +4598,7 @@ static int raid10_start_reshape(str=
uct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irq(&conf->device_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->degraded =3D calc_degraded(conf);
>> +=C2=A0=C2=A0=C2=A0 update_lastdev(conf);
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 spin_unlock_irq(&conf->device_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 mddev->raid_disks =3D conf->geo.raid_disks;
>> =
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->reshape_position =3D =
conf->reshape_progress;
>>
>=20
>=20

