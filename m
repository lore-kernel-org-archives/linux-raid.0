Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6577314B6E
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785702700; cv=none; b=fVizNQs0rR6YdK6p0cPuj3uJ8EU6mg03n6UoGlDqtxdsRAiEf31HBsvohafFQ/XXIw4GSY+zuz4ecgXwnfUozpxQ//beKSj4rjj+T0ZOYlwyh1VPZPWSBmLvo98dqsB/fpiFWRtvT27tTi2mq2CUooSt9oz8Hq+AHHrd8iTB1k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785702700; c=relaxed/simple;
	bh=kP//uyCuzqM7Iwt2NaGHDdyF/1R6fNqCIQm8w0lENLE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b6g8NJGl1hRbX+7gTyzk4nAX5VIlJt8WZnN2ALbJp9RBieB4FP9aSmEq922NWElvy5Pd+zJV5LFK+mOCJMUgaeQv86tyJXK5ZCzMKIY8S8efZNb67EEYh6qjYmoTXsNuXI8bN/9vyrveh0A1c/GNx5Dz1ZL/j5EoOdBfv55ZtvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dqgmou9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dqgmou9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6321F000E9;
	Sun,  2 Aug 2026 20:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785702699;
	bh=lK7chAejk6zstBV0nW4LKRQOLrBW+QVJ8awF2CHrMos=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dqgmou9NJMeOwuJsJUXfG2S6pSFK/r0u7FIab8QxCL0/ayPtNfvAldUqQSqXeUf1/
	 n8jhtdZGg0WcOiorVXcjo01jV2ueTVrRUGgjT7y7q4GctmEC8T4t5q3NxLaqHW7q0n
	 K2hvP2XK1X4vsknhu5XbvvOMZkQnqDHyOVLCkHwlG4v3yAoInWE19AnL2nyU/rCToo
	 Ww5WZ32Qtc0MWI8FsgEblk30v/y64zREAa0VPO8xtIWaR5zSXAzuF+oer5iKmK1QTT
	 W9eA+fjg5oRhyFH//+Ox/KIoQTtC5aIuY+TOAwPf/tcWwtkkxIv/uqov51AbBqX0FD
	 qrvRI9H0cwfKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/29] md/raid5: reject zero-sector reshape chunks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-5-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-5-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:31:38 +0000
Message-Id: <20260802203139.2F6321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Incomplete Fix / Integer Overflow and Validation Bypass
- [Critical] State Corruption / Incorrect Error Handling during Reshape Res=
ume
--

--- Patch [4]: [PATCH v5 04/29] md/raid5: reject zero-sector reshape chunks=
 ---
commit 7e4615eab2a0600f99886ba69199c0ee0d8cd320
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: reject zero-sector reshape chunks
   =20
Sashiko reported that RAID5 can accept a reshape chunk size that becomes
zero sectors. chunk_size_store() stores the sysfs byte value as n >> 9, so
writing a value below 512 bytes sets mddev->new_chunk_sectors to zero.
RAID5 then accepted that pending reshape geometry and raid5_start_reshape()
installed it into conf->chunk_sectors, letting reshape code divide by zero.

[ ... ]

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e2c5a7072aca0..d128d238e1daa 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8548,6 +8548,8 @@ static int check_reshape(struct mddev *mddev)
>  		return 0; /* nothing to do */
>  	if (has_failed(conf))
>  		return -EINVAL;
> +	if (!mddev->new_chunk_sectors)
> +		return -EINVAL;

[Severity: Critical]
This is a pre-existing issue, but does this check adequately prevent invalid
chunk sizes if mddev->new_chunk_sectors is negative?

If a privileged user writes an excessively large value to the chunk_size sy=
sfs
attribute (like 0x10000000200), chunk_size_store() in drivers/md/md.c shifts
it by 9 and stores it into the 32-bit signed integer mddev->new_chunk_secto=
rs.
This can result in a negative value (e.g., -2147483647).

Since negative values are non-zero, they bypass this check. Will this negat=
ive
value then bypass the validation in raid5_check_reshape() which only checks
positive values?

drivers/md/raid5.c:raid5_check_reshape() {
    ...
    if (new_chunk > 0) {
        if (!is_power_of_2(new_chunk))
            return -EINVAL;
    ...
}

Could this also cause a 32-bit shift overflow in check_stripe_cache(),
passing the limit checks, and eventually lead to a divide-by-zero panic in
make_discard_request() due to a 32-bit multiplication overflow when
calculating stripe_sectors?

[Severity: Critical]
This isn't a bug introduced by this patch, but could returning an error
code like -EINVAL here cause state corruption during a reshape resume?

Looking at mddev_start_reshape() in drivers/md/md.c, it evaluates the return
value of check_reshape() in a boolean context:

drivers/md/md.c:mddev_start_reshape() {
    ...
    if (mddev->reshape_position =3D=3D MaxSector ||
        mddev->pers->check_reshape =3D=3D NULL ||
        mddev->pers->check_reshape(mddev)) {
        clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
        ret =3D mddev->pers->start_reshape(mddev);
    ...
}

If check_reshape() returns -EINVAL (or -ENOMEM), the condition evaluates
to true in C, causing mddev_start_reshape() to call
mddev->pers->start_reshape(mddev).

If this happens during a resume, won't calling raid5_start_reshape()
incorrectly reset conf->reshape_progress and double-apply the delta_disks?

drivers/md/raid5.c:raid5_start_reshape() {
    ...
    conf->previous_raid_disks =3D conf->raid_disks;
    conf->raid_disks +=3D mddev->delta_disks;
    ...
}

Since conf->raid_disks is already set to the target size in setup_conf()
during resume, would this result in an out-of-bounds access on conf->disks?

>  	if (mddev->delta_disks < 0 && mddev->reshape_position =3D=3D MaxSector)=
 {
>  		/* We might be able to shrink, but the devices must

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D4
