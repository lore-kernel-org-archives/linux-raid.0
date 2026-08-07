Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93543418363
	for <linux-raid@vger.kernel.org>; Fri,  7 Aug 2026 08:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786092213; cv=pass; b=CtmxJSkI2oOp9yWtxD4WiQAdCEsj7adRalGN5C5oW85QZboKHswOT07U93OnHn4O9DfmwqFRTOZOUbc2HB02a2Wm5YXhGvNwbk7fe/4rJyb2waX/ntxaxGGoO5EUliHYhw/dT3YpYc+CXq+Yvt3DtMXqZv6Af8qZ+DhlLNAS1YE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786092213; c=relaxed/simple;
	bh=Q7pKjsoycGYUD+hfkdezo/bg0xXRq1C0CK0/ddY2Oes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vELqNWMjWKASzaaeveoBn8cZuHXcPirnkwZ6XKOa4wwsj09wdfsW5NLbShEOz59yMKBEy35lGUGYiPoD4GbTO3wzteWv1EYfQs2g7XAGWM2vHR+FMpXVxgTbkz2t4vGx1J36RlqcJsYW3+nYyS7gFG2xpduh7z0vfiHhy3knbUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilGp4rQk; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilGp4rQk"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a17f91so4928958a12.1
        for <linux-raid@vger.kernel.org>; Fri, 07 Aug 2026 01:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786092208; cv=none;
        d=google.com; s=arc-20260327;
        b=XU6K3EjjOSTDZMHmJpoX7wiqR/Jumz96POfqNA+8cVicdZAiicDwD3Aj7BvBv7xUDZ
         Vx9owVAFh8bljfDs+QxRDJaOe+4i70PzbLcY1aXGfrHcCRY/ckcG5bEF0rmZ0nI/zF4y
         IK8CinTRPoYLTb8aHk67k6EyATTjjqXEhQpU51jGjF3Eec1hKUYPPbXUxWA3uQhB8NP7
         sFSLm80jUQYIMixjThyKtnqPpZmwNfoAggjVn+iHv0l6V75pDmATDAr9YODs/HLO5wve
         SyuSStfqyYmTiBMfCC1WVsmI1oOGHG34VLQCdtRmi/C3FRwExeuyQ31HGX33CotDESCp
         inXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wh4mGRgFOCa9n58OtAmQ5OZvJAf1kiI4SmhGkWGr25Q=;
        fh=U1ZVnqwA4t/XzOX4LaqjP1waZrO/4naDkQvrI1Guh6I=;
        b=QU/AK8qHQtYJJlfiF66gQuwu5jq/JU2nYgC8dwlOzq8b+KkRb5tkaNUwNHW0qSDQh6
         /xbFJEfCfBjDmsj92YzSySzEXn/8n03M6HSjZL+I4GMZFh8zR41Q9gV4d2VFvu8kDm6C
         Ywm41j5QevDbZOMDL0592B7xe4ZN7bj/ysXact8YayjFdoI0RI68kLO4gzqlX8KT2GxT
         9M7dNBBJrPGGXg9JkOZ9KyXCAW+noHTqXaODnFzrSU60OIOIz4qZqHi3CD2H3aDPW+B3
         focbFchZLCPOMzg75YtDcEwFJx0OsAyj3G0y/DBAmw6sN+N5lcszIi/8Tvq8m5QF82Gg
         d7Rw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786092208; x=1786697008; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wh4mGRgFOCa9n58OtAmQ5OZvJAf1kiI4SmhGkWGr25Q=;
        b=ilGp4rQk/kWd+iuqn3mVsqKmjmORqTriLCp8ZTgR4N0/ZZrtfck7pgxw9sV5hfaILC
         Jn137HCJV4OOwspZiMLqBE/cc3FsJCNbduXrCYGzYs32RLX/iWh0m/GV60S65eupNtWA
         2TNdN4VPMtRiNKzK4PXzmiQoKvanP/7d8CN5ORXBdHqHItHWg0jq4zUuxQmXdmd3cJ8I
         eo/sLYV3gSzsMPbUEyiF4YQtB3ymy2V3FpQ09h7+lRqAU+FU1Y+q75fGYejiPdanlxrM
         3FSkWJ3g/MFoyTQEV6p7I/CmrJ35IE+RBGOHQh97oyumdTz1rSTPPAbwPj663/L8tfzA
         vRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786092208; x=1786697008;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wh4mGRgFOCa9n58OtAmQ5OZvJAf1kiI4SmhGkWGr25Q=;
        b=MGc4c4KJSQQUgvQluVyPk4d5C/vchr5BZf8q5UpI20QYO3eGo/145pjovyz0Dq3NPo
         oGSb2QB/HhOP23jvOvESpX+1PKUsZ/CPi9x9Ul61DXAuTUvGqnc3+BCoLratVQDMMtBQ
         h6dA7FZ1ypaqve3cAZJ22BEk7sPbzPrUT5QpmTCqJQfapB/nPX4YcaxhyNN7X5nzPV4M
         R5duRCZO0JFKpqFCsfYOzpmbO+lPiyoeL8xdXfdomOARSq7GUPVdvJcw+5CqWN1asBHA
         a136EAbRQIGAB2xK5kutNLhieM8vrhjKwhy1gaYVzTEl/gKJnD1KeuKhmgdRf40NQxrG
         Xmtg==
X-Gm-Message-State: AOJu0YyZ8F0ReKhIkwdw/o3HTJbNZKoIeyG2xFxnGjnbGmZE9IPt1pOx
	duqWlbHKYoUoJ7m1T3TN2rjhtEmOgjuvuO7eRvYZe0TTb3Xl+LuN5DsdKYjXX4IwWPxQqNgeMY7
	JMvWP6olK9P+cwZkbC74VoGEei19ptHI=
X-Gm-Gg: AR+sD112+7k1SRdqRKdsvbwlsRgp38yeS/kngtP4DfTsCqS+A9rt6PVQq2+Qnz2pC/l
	qSVcIUEt7/F7qs54IO8a6nnGODUz81vcAovLilUnKLGUWViFgmO7ZscbF4a82ea8pkRxt1o/JMr
	HIFdH3Au9f3cOJG8JNGuTbJceuKzDAK2+J4Y6BWPXKUTSRePsgIyRwoDAFGYwnijVKLB3cV3hXW
	MGAT2pZ+afVxwem0/KtreZMuZkxJYe3iolsEe2YK2NaTfGftbO3C1BLhmHBO96xmIo7E1P+yO9M
	RlLSohobv9x3h+O95FscRhoZowj6XOAjcynv1lv19s+l
X-Received: by 2002:a17:907:7b83:b0:c15:ffd3:da25 with SMTP id
 a640c23a62f3a-c2039d05581mr1107791766b.28.1786092207505; Fri, 07 Aug 2026
 01:43:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731074729.1885314-1-wale.zhang.ftd@gmail.com>
In-Reply-To: <20260731074729.1885314-1-wale.zhang.ftd@gmail.com>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Fri, 7 Aug 2026 16:43:16 +0800
X-Gm-Features: AUfX_mxP2jLd7Tby93guK4UeINyRG6TKrjt0WrThXBfvqZNhjyUNTypIEaB4_qE
Message-ID: <CAHrEdeubV5fStnEPty9tcJKzKktKDt=E8YQ3xf9FugMu+UxFWA@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: skip discard on unsupported member devices
To: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello song and kuai,

This patch is to fix the following problem. Please help to review how
to fix this issue.

kernel log:
[768337.449125] bcache: bch_count_backing_io_errors() dm-3: IO error
on backing device, unrecoverable
[768337.449149] bcache: bch_cached_dev_error() stop bcache0: too many
IO errors on backing device dm-3
[768337.451175] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 1, rd 0, flush 0, corrupt 0, gen 0
[768337.452326] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 2, rd 0, flush 0, corrupt 0, gen 0
[768337.453512] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 3, rd 0, flush 0, corrupt 0, gen 0
[768337.454287] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 4, rd 0, flush 0, corrupt 0, gen 0
[768337.454993] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 5, rd 0, flush 0, corrupt 0, gen 0
[768337.455869] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 6, rd 0, flush 0, corrupt 0, gen 0
[768337.456643] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 7, rd 0, flush 0, corrupt 0, gen 0
[768337.457336] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 8, rd 0, flush 0, corrupt 0, gen 0
[768337.458014] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 9, rd 0, flush 0, corrupt 0, gen 0
[768337.458658] BTRFS error (device bcache0): bdev /dev/bcache0 errs:
wr 10, rd 0, flush 0, corrupt 0, gen 0
[768337.562394] BTRFS error (device bcache0 state A): Transaction
aborted (error -5)
[768337.562406] BTRFS: error (device bcache0 state A) in
btrfs_create_new_inode:6715: errno=3D-5 IO failure
[768337.562410] BTRFS info (device bcache0 state EA): forced readonly
[768346.923384] btrfs_dev_stat_inc_and_print: 1643 callbacks suppressed
[768346.923388] BTRFS error (device bcache0 state EA): bdev
/dev/bcache0 errs: wr 1653, rd 1, flush 0, corrupt 0, gen 0

storage stack is:
    Btrfs
      -> bcache
        -> device-mapper
          -> RAID0
            -> disk A, discard unsupported
            -> disk B, discard supported

The failing bio completion was:
kworker/u16:12-741243 [001] 768345.120068: block_bio_complete:
dev=3D64771 sector=3D20097083408 nr_sector=3D640 error=3D-95 rwbs=3DDS

error -95 is -EOPNOTSUPP and rwbs=3DDS identifies a synchronous discard
request.  Repeated failures were counted by bcache as backing device
I/O errors, eventually causing bcache to stop after reaching its error
limit.

Thanks.


On Fri, Jul 31, 2026 at 3:47=E2=80=AFPM Wale Zhang <wale.zhang.ftd@gmail.co=
m> wrote:
>
> blk_stack_limits() uses min_not_zero() when stacking discard limits.
> Thus an array containing devices with different discard capabilities can
> expose discard support as long as at least one member has a non-zero
> discard limit.
>
> raid0 and raid10 use md_submit_discard_bio() to submit a discard bio to
> each member covered by the request.  The helper currently also submits
> bios to members whose max_discard_sectors is zero.  The block layer
> completes these bios with BLK_STS_NOTSUPP, and bio chaining propagates
> that status to the original discard request.
>
> Discard is optional, so skip members which do not support it.  Members th=
at
> do support discard continue to receive their portion of the request.
>
> Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> ---
>  drivers/md/md.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c8..77e6e6bd5460 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9350,6 +9350,10 @@ void md_submit_discard_bio(struct mddev *mddev, st=
ruct md_rdev *rdev,
>  {
>         struct bio *discard_bio =3D NULL;
>
> +       /* Discard is optional, so silently skip members that do not supp=
ort it. */
> +       if (unlikely(!bdev_max_discard_sectors(rdev->bdev)))
> +               return;
> +
>         __blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discar=
d_bio);
>         if (!discard_bio)
>                 return;
> --
> 2.47.3
>
