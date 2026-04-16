Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566562C028F
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 07:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776325154; cv=none; b=cNUlZAnllnab7xqRDvtzXzQJM3ymaPMhInLHhhSghKPLGGX8TOo8k+rYaLkGphsYnlap6Ms0AF8My305KsJRm+YqulYtn1YGpuGMl2ret2V140qqxi4wZvwAijDLEYBJdL7KrJnZRGgc7TdqCOfG4BQ78QjiwZLQf7+PJFJeMJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776325154; c=relaxed/simple;
	bh=z2hx6ivnJiU7UzNIvjw5YPMUdSUH2CtVMHSJEfKOCFo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Y3rlNkVx/o9FIfZmLva3NXuTZU7+qMq5v0z5Qw515ZFlyo+aZS5osRW9auFT9Ni6CQWBplH4SQi47gjWtFcaBynA0Lz4gwkXR3jLeJoa5zzhIkJ3G6RyseQ0podYtkSdYLLyglN2G3QmjzI4M/UN3zzLUfAJIpB5nHd9tbkPBVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qXjdwJpE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qXjdwJpE"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-483487335c2so83892455e9.2
        for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 00:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776325152; x=1776929952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CDKFAyjNNZbEVBu27h7dEu+gaClTVdkwmkLAaz3gL9s=;
        b=qXjdwJpEoWBt2iyzqhEKIwp3LFZcy2INhYf9esfcrn2hzt+3aN2A2ogsgyWZN7eW0s
         y2rqujFhbLoSwP4Y7cK0grXknNo0WE1WjMgOmzx8nHa8IP6HWdf+zs3M1hyHmghvRfj3
         wTrdBRGTOArL1Ic1jKNP1+mdMKIui8Mxp6n11eHnIxlgRqzeqqAIdMgogLJ1I/eTaPdb
         MZgVPst5zv/m4pEc8TgbWQRRT9A9TTrKL1lYq5zVRSBE9hp2U6speZldow5JYaMMdlqC
         ja4gVelArGNuHX11BtKAy1M4utRPKMbS3WJ4MiVirSKhv+vFOxx2Rt5EPBk0huaN/Hdo
         gavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776325152; x=1776929952;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CDKFAyjNNZbEVBu27h7dEu+gaClTVdkwmkLAaz3gL9s=;
        b=qE7NB+2GTfq4Nejlr82HSkwK16p4pK3aGbCs7/eMOVSd4OuLllomBgzGjIuh+ootEr
         2l2vhfalRbjXUbf4DdcN92RUzvHy7+os+WE/OYjW3Tgo8CvO6WQGvZGzhGHaXBZ/EwAx
         lw9JDEaEyE/LXo/g1DESWwG+94JcXp4wmmfuayJjbatNwqyiwhbFURAvMNeu5YmQlb2n
         jm6BSC1un+OIC0wxYdrZS6xBwkDZmei0JDstmsMoFib30DabeUfjv+SOnlzbmKpwrtPa
         mIZhzO+g05mr/3WCysIayKFM9veJBWU3JPOLAKHgKDjyMhaXvg8RtOCB09OHKR+cH11M
         okaQ==
X-Gm-Message-State: AOJu0YwrALz4srjgqrPzEdUFgvX22AUhE3VPPF8YbUETC5eKG3vXoc3C
	JZS3SjaPM0cyosY4tgsqKV5klhtz9z/8Be0bJuCyyLSmfEtv9swDsLgC
X-Gm-Gg: AeBDieuGAoqJD+UlKzqrAn21bJfEiT0zk1GpgKB21H0E6DnAiKa6wlTV/s/8a8H1x2v
	vjwwh7UAIdacHQo7jvDhWTOLGmY7f/u8NkOEpwcz2reLou/ITz/HeZx3a0ppQv2rR6EYIoJf/AS
	BYwDk2ilDr877V9V9NGxyrIsqiQ0Saegy+eMVnrdESmzINITsHjllNIzx3HtF5vsztuIhDTu/mp
	rbHWDf+8jfSm4Np/MwY5PAa+ghxkS3HCFiK8cewlw7t9uPVrkZ4gfDWK23FSgIqaaT6+vb4a/Z/
	1KeaGJXbrBQJYZq+Ix6kfw2bzuOjOeN3e87Z6aKix0Iqdyj4Oqh+37ffURcoh7tirffEhK3XljP
	3xnl12G4uNMB+j3qZqMFK5RqFnHOk6MmTWqMrJtx30h7hxt9BPbmhNqRXBf/rGELtrI81WD0r9E
	6ZIK5mToMAzDFNh9hIi454jKmNt92ytpcouBi5sK6BXj3NpHkBqMrFDtdG98KmzfuXVECU5+WQH
	SaNAquoVSGw
X-Received: by 2002:a05:600c:c10d:b0:488:ae4e:51a5 with SMTP id 5b1f17b1804b1-488d683d633mr236535575e9.15.1776325151418;
        Thu, 16 Apr 2026 00:39:11 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:62f:6885:b8ea:cbdc:574d:dff0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f5818d70sm53581085e9.4.2026.04.16.00.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 00:39:10 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Li Nan <linan666@huaweicloud.com>, song@kernel.org, yukuai@fnnas.com,
 linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] md: use md_free_cloned_bio() in md_end_clone_io()
In-Reply-To: <7f82e3ae-bb2b-96fc-af9c-632fa6ae07af@huaweicloud.com>
References: <20260415081941.352389-1-abd.masalkhi@gmail.com>
 <7f82e3ae-bb2b-96fc-af9c-632fa6ae07af@huaweicloud.com>
Date: Thu, 16 Apr 2026 09:39:09 +0200
Message-ID: <m27bq72w2q.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Nan,

thank you for the feedback.

On Thu, Apr 16, 2026 at 14:47 +0800, Li Nan wrote:
> =E5=9C=A8 2026/4/15 16:19, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> md_end_clone_io() and md_free_cloned_bio() share identical teardown
>> logic. Use md_free_cloned_bio() in md_end_clone_io() for cleanup and
>> call bio_endio() afterwards.
>>=20
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>> Changes in v2:
>>   - Reuse md_free_cloned_bio() instead of introducing a new helper
>>   - Link to v1: https://lore.kernel.org/linux-raid/20260414103813.307601=
-1-abd.masalkhi@gmail.com
>> ---
>>   drivers/md/md.c | 13 +------------
>>   1 file changed, 1 insertion(+), 12 deletions(-)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index ac71640ff3a8..8565566a447b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9212,20 +9212,9 @@ static void md_end_clone_io(struct bio *bio)
>>   {
>>   	struct md_io_clone *md_io_clone =3D bio->bi_private;
>>   	struct bio *orig_bio =3D md_io_clone->orig_bio;
>> -	struct mddev *mddev =3D md_io_clone->mddev;
>> -
>> -	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mddev, fa=
lse))
>> -		md_bitmap_end(mddev, md_io_clone);
>> -
>> -	if (bio->bi_status && !orig_bio->bi_status)
>> -		orig_bio->bi_status =3D bio->bi_status;
>> -
>> -	if (md_io_clone->start_time)
>> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>>=20=20=20
>> -	bio_put(bio);
>> +	md_free_cloned_bio(bio);
>>   	bio_endio(orig_bio);
>
> Is it safe to end orig_bio after putting active_io?

As I understand it, active_io is primarily used to account for
in-flight bios, allowing the array to be safely suspended once no
bios are outstanding.

I have made a diagram, while i am reviewing the md driver:

mddev->active_io

md driver:
md_handle_request()
    mddev->active_io +1
	    pers->make_request()
            md_account_bio() +1
			    if (err)
				    md_free_cloned_bio -1
    mddev->active_io -1

lower driver:
bio_endio()
    md_end_clone_io -1

As shown, it incremented in two places, the first is before passing
orig_bio to pers->make_request(), and decremented after it returns
(regardless of what make_request() does with it). and the second
is when cloning the original bio, and it should be decremented after
the cloned bio is released.

In this context, it should not matter whether bio_endio(orig_bio) is
called before or after decrementing active_io, as long as the cloned
bio teardown is completed correctly.

Am I missing anything that would make this unsafe?

>
>> -	percpu_ref_put(&mddev->active_io);
>>   }
>>=20=20=20
>>   static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>
> --=20
> Thanks,
> Nan
>

--=20
Best Regards,
Abd-Alrhman
