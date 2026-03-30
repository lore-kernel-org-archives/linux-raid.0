Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA120373C19
	for <linux-raid@vger.kernel.org>; Mon, 30 Mar 2026 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774885663; cv=pass; b=j6Zfx6ZZnSnBOzE04yepy2yN/Hwp7Lmf0JWtINn2Ko1zJgzvF8JY/Y8CR/PyIr5mdHFAKo4xNhqZbwDZsleS/FANERu0Zutqm386YVlNJR6y/+KDOOYi/kiTDHIs3JGhNxQ+Gy3g3/6bqO1Bl10i77gBei9kKOvuS/5IXuMKOuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774885663; c=relaxed/simple;
	bh=zsnKn8C+SNi1K701Ve6Z4/0CSbH9v0trSmRuFkIABcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZmsAOf3mcwtXNO2IHxkCW7cIQPTda2z2sKFRYPRNIB7FIdEm9gcbgeA/1P7CD/NC2nbtTBFxEtBXQu7eSGKSIFVSo/ayZCab/vjzLjm8FqqEmxX2vNzWgr84viw275oG+0um5e3PW6eG252q31H+PtaVy3XK9+tkMGcLNBQsBmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SAGCI9/P; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PRt6GuUM; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAGCI9/P";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRt6GuUM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774885661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lzgimHn3jW7T2pmk/9nBPAMjfI95GhXkbD2DBCG0TeY=;
	b=SAGCI9/P81leY7ttjJxBAp9iUMMtSxnP0xK4clhZUj4ebeQo/2A9IxV9lTrr1I2S9cXqER
	EtILx4eLHQmbukDlijv3n9luU+XYg0OYWYc8lFG0h5PGPlV1xdjb31ZJOC3jI4dHQwoxll
	EG5B934qnH7KYXIF9qaGaCRIXsAy+/4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-zvJJtaxROwyjJ07ctRrVuA-1; Mon, 30 Mar 2026 11:47:39 -0400
X-MC-Unique: zvJJtaxROwyjJ07ctRrVuA-1
X-Mimecast-MFC-AGG-ID: zvJJtaxROwyjJ07ctRrVuA_1774885657
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a1055f8ebdso4369017e87.2
        for <linux-raid@vger.kernel.org>; Mon, 30 Mar 2026 08:47:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774885656; cv=none;
        d=google.com; s=arc-20240605;
        b=DuhwMFhnvopvASA2IpuT5WAfPcoonWOzCs3KwAQ7Yq2Qq3VMyYGdnlc+pls8U39P46
         SbMW6hsctl+vQG8URJdBPpdK8YmjXjQ8V8Eo3h9qKNSz1XG/OxSFOtBzPVOP+EF5dMW1
         n5DTb4LNIdYnqp7egRYz7jtdTYUd9ycUSShqkGnJyoZioAs0HIf3IckIv6KpIuoAdWkL
         rX9Irb8xurZrL1JdZIwrarFTbRIoK3+9IPlMPs85Zis6pnGhUT9ZjsroHiYSUcJlBb+j
         ySU9i4xsFsPOf2pbIcl5J3WSSaoiaR+BjqBFrB4JiVs6oicrry5U09aFMqBWC0obmt+l
         fAdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lzgimHn3jW7T2pmk/9nBPAMjfI95GhXkbD2DBCG0TeY=;
        fh=PBqR8npU3WuG0/ZpUrLHhkkLZsYmI0ZFWtf/UuweVH0=;
        b=Da7g8FmZaWPWlWb7JF0sA3V8/mktHSuyF1PFNcnmNRoyyZrjnxB6OTPWIaVouI0NhY
         HlU8voETRxLTl2zEUrIsXpooI1x1qkQbrSXZbEXuKtdT5rJq0QLf+wI8v1LiLEKWgLGa
         mVWRQdcS4EjhIO5cn2rVT3pg1XAeMrKtGQfxQ6MyU1pjGvSv92d2IBL2UgMlfPt3IFlT
         Z25ihRBIfPovl5/UCWHHmUiZ72LjYhcauZiTdVdbB6jys2bNx5KC6dM8qEPf7r2xAVDK
         UCxB2RRkT3WGP/XnVcddyKOhiRLhpjmzMq/7p7Ca/2IVQdyq/LfuJSGfaQ1G1EsprtKg
         DbuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774885656; x=1775490456; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzgimHn3jW7T2pmk/9nBPAMjfI95GhXkbD2DBCG0TeY=;
        b=PRt6GuUM9+2kZk6KwNzF0mtZe0/XO7Eu1bCLKygQMMbvOrGQCszS/kw5UNnERw4fyf
         1gBLrVTL3vOXjNkXqNADgORj1nObFCRRyj8i4PkcFfuBWylXk1E1YQj8sGVOqcovGl5+
         PnfQMRjUMTd1BNDO24Gs/RjF9NMq7CBep/z8w0CuQrW9/9Ng75sck5YZTXcqOf+8HPth
         av936VbF7DCPaW6d6Lw/4dbej+9FcRcwh/Uldu/BMNnzrsR0LhN8D2vOLuH1EMFtUY/x
         BXZscFD4pe/ODThGsSvr83Q9VVCpWi5gBn0wr/ABk54rs+W1SSbhc13Ag2HJzqpB1L1Y
         I/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774885656; x=1775490456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lzgimHn3jW7T2pmk/9nBPAMjfI95GhXkbD2DBCG0TeY=;
        b=Xn/eZYvjJRRVBQ6XyyAQ/i9tCXUqMBaocRfCEg8Dugm2LUusAOMakSqBK/vSps+Lj8
         gSCjBGfFybt4zEae07/MCek+iM2T1y/qSwMLxmvm7RAnu3I7xH6CRIP0ZVUMv7geeygs
         k0Lvm6A9wLLtuK5LOcraiM2rtjWsD+tNMbzLjOxvuZSQGIHQ8o46SH5rxL/NI/W7ZZsj
         vytTcv3NtqFzNzc9ktJ9Ts3QnwxjbXjfZHkYep8OxzgQ6SkeqNI3eoDPCuL/oU7+gQfj
         xH9DTSdyhNZq8dv854RHVYEYiqcekAOsD7mtmyItWK/aKUXu8y4kLyH4OrIx84/sHpgQ
         bjeg==
X-Forwarded-Encrypted: i=1; AJvYcCVQXsOScB6mEkwFN2I3FIpSskNdifx6RNCS2GwsFekrJov/8EC7WyCtbWReZ21k9wQHahmDrMo2Tb+y@vger.kernel.org
X-Gm-Message-State: AOJu0YwONsrI9dlj95lXStbdLHaie0WJu7LgRfVqDReziwDuO7t/exL/
	KgFzqebrZqpAEIfc/rIqMJtq5F+AeFvq1HgWhg5fdEbWPMFvE/H5UJiQ30CnWeWLugLY6zWLdLb
	Z+wxIifMenuPfFH+vjUDeMVykMNmW5QBxJwPO7Frj7wPixM4DiUCQk8/3mqU7IMqWBAA7rDajXx
	muN0enjcDps2RaEXkm2X0bXNmCyvA+JbaJj1XgSZDDh8e0hA==
X-Gm-Gg: ATEYQzwJ05ZZmKaf8QDNrYmy4LUE3LjM0ImdOB3bH6vKP4+NypiIpxdKxuqRZzicV5F
	0BHNXdJ3riv1jAW7IXmDFfhA/eA63euUB+jbn6vBxwU6kBw1P4uogQ9jHs5gd9bZtBnb9PwGxiF
	0HjO/nRJ6Sk9wONBmHpI8FTFaSqD4Qez+fywaJ2apzne5k/Su+zKzmamQU3ESPSvl6kWttn7Lp+
	ZE45pr6NQhMopx7OLC2vYIUZYqMObR8/k/V4GveLxOAwQpVfCyVR6GSV/d3RR2750udUUnhODjh
	A+hkog==
X-Received: by 2002:a05:6512:1381:b0:5a1:d0d:1ba9 with SMTP id 2adb3069b0e04-5a2ab7e8cbbmr5706190e87.7.1774885656031;
        Mon, 30 Mar 2026 08:47:36 -0700 (PDT)
X-Received: by 2002:a05:6512:1381:b0:5a1:d0d:1ba9 with SMTP id
 2adb3069b0e04-5a2ab7e8cbbmr5706170e87.7.1774885655435; Mon, 30 Mar 2026
 08:47:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260330055213.3976052-1-yukuai@fnnas.com>
In-Reply-To: <20260330055213.3976052-1-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 30 Mar 2026 23:47:22 +0800
X-Gm-Features: AQROBzCSskXRpD5cSUXB9p6x64PFcdAfaPyZPB0AntqJLeIAQpCqFP1l_v0tsUQ
Message-ID: <CALTww2_O-yZVmiCqmqUaRnixEJZ9mBQsGH3Yx3EG_Q-6X-_b8g@mail.gmail.com>
Subject: Re: [PATCH] md: fix array_state=clear sysfs deadlock
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2026 at 1:55=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> When "clear" is written to array_state, md_attr_store() breaks sysfs
> active protection so the array can delete itself from its own sysfs
> store method.
>
> However, md_attr_store() currently drops the mddev reference before
> calling sysfs_unbreak_active_protection(). Once do_md_stop(..., 0)
> has made the mddev eligible for delayed deletion, the temporary
> kobject reference taken by sysfs_break_active_protection() can become
> the last kobject reference protecting the md kobject.
>
> That allows sysfs_unbreak_active_protection() to drop the last
> kobject reference from the current sysfs writer context. kobject
> teardown then recurses into kernfs removal while the current sysfs
> node is still being unwound, and lockdep reports recursive locking on
> kn->active with kernfs_drain() in the call chain.
>
> Reproducer on an existing level:
> 1. Create an md0 linear array and activate it:
>    mknod /dev/md0 b 9 0
>    echo none > /sys/block/md0/md/metadata_version
>    echo linear > /sys/block/md0/md/level
>    echo 1 > /sys/block/md0/md/raid_disks
>    echo "$(cat /sys/class/block/sdb/dev)" > /sys/block/md0/md/new_dev
>    echo "$(($(cat /sys/class/block/sdb/size) / 2))" > \
>         /sys/block/md0/md/dev-sdb/size
>    echo 0 > /sys/block/md0/md/dev-sdb/slot
>    echo active > /sys/block/md0/md/array_state
> 2. Wait briefly for the array to settle, then clear it:
>    sleep 2
>    echo clear > /sys/block/md0/md/array_state
>
> The warning looks like:
>
>   WARNING: possible recursive locking detected
>   bash/588 is trying to acquire lock:
>   (kn->active#65) at __kernfs_remove+0x157/0x1d0
>   but task is already holding lock:
>   (kn->active#65) at sysfs_unbreak_active_protection+0x1f/0x40
>   ...
>   Call Trace:
>    kernfs_drain
>    __kernfs_remove
>    kernfs_remove_by_name_ns
>    sysfs_remove_group
>    sysfs_remove_groups
>    __kobject_del
>    kobject_put
>    md_attr_store
>    kernfs_fop_write_iter
>    vfs_write
>    ksys_write
>
> Restore active protection before mddev_put() so the extra sysfs
> kobject reference is dropped while the mddev is still held alive. The
> actual md kobject deletion is then deferred until after the sysfs
> write path has fully returned.
>
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 521d9b34cd9e..02efe9700256 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6130,10 +6130,16 @@ md_attr_store(struct kobject *kobj, struct attrib=
ute *attr,
>         }
>         spin_unlock(&all_mddevs_lock);
>         rv =3D entry->store(mddev, page, length);
> -       mddev_put(mddev);
>
> +       /*
> +        * For "array_state=3Dclear", dropping the extra kobject referenc=
e from
> +        * sysfs_break_active_protection() can trigger md kobject deletio=
n.
> +        * Restore active protection before mddev_put() so deletion happe=
ns
> +        * after the sysfs write path fully unwinds.
> +        */
>         if (kn)
>                 sysfs_unbreak_active_protection(kn);
> +       mddev_put(mddev);
>
>         return rv;
>  }
> --
> 2.51.0
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

