Received: from mail-108-mta93.mxroute.com (mail-108-mta93.mxroute.com [136.175.108.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DB91A8F84
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776348848; cv=none; b=oT7LcXdQblDXQppU6K2j9NCyVkVIC/6k+MVIO2ZlcDj5YcVy4hGzGDcETcj1Hs2v6vK1ORQhPh7MI4N2AovOdqvKx20JfHtXOcvgodvL9uzy9xQsYoKSOBRP6nP4otj4P76kwGMEU35fWcybDhlOAgOYyXplypDXAKIt7Zm/+bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776348848; c=relaxed/simple;
	bh=1F/0Dg/2sE0swxRxEkhw/Lr/QaIMdmT/5Q5MK2TiSLc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sSzXCOZb6XqQRzL55bXYj3dOyEHJaD7bBg93cNcmo6AyoBLqNL6Ua0xLQEWabC5Kh9QN7gjF4ueIip3y3mpov7t48X/ZacM+onkVdRIRM4kouv9hnVY3dVttxHvaXd7k4q0AzTqL9rsl59X9n3tkPg+uuA6VVcJDUsqKZuJzN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=f7wqmmel; arc=none smtp.client-ip=136.175.108.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="f7wqmmel"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta93.mxroute.com (ZoneMTA) with ESMTPSA id 19d969f957200032bf.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 16 Apr 2026 14:08:54 +0000
X-Zone-Loop: 3a0022f1701a288f82b8cdb5143afa20d424855bc2a2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NdPUTtHoCHDtxzOOTrYHfDbuCt1/AYQogts4YQi9G/g=; b=f7wqmmelTYR9oxAYn2a0apwo8G
	E19pq17MGchLAtfyhiQo9zaWDEFGwo5Ydk3/tdNEhau7vKz6e+tYioLzRPm0ukG3s9G7TkJ0+z7nC
	Gq1oLpHHQsdG+3pW6OUNQrO7YFhbE7HZGrDNufkZLAITfMFqiP46Tb/6iKEqP9mrV8t9+mWjnH9MX
	9tiZn66kG4gYnrrwVotMAe9xWleXK+gPLyPD0bkOsf6rYqxZRzdHpElslxDpGQNvDADJTE0hnzTrv
	ICEOkFz/k5BYvOoL6QM9oujjYACdz2vSeMe9585VQX5D+/ov2+z7SVRZJ8BVgNk10vaPhsec3ezqo
	gtGSmvdw==;
From: Su Yue <l@damenly.org>
To: Xiao Ni <xni@redhat.com>
Cc: Su Yue <glass.su@suse.com>,  linux-raid@vger.kernel.org,
  song@kernel.org,  linan122@huawei.com,  yukuai@fnnas.com,
  heming.zhao@suse.com
Subject: Re: [PATCH v2 1/5] md/md-bitmap: call md_bitmap_create,destroy in
 location_store
In-Reply-To: <CALTww28wN=9R2RMApc89M=cRtHmrFYgc8qgakR6LwcyXeQNdDw@mail.gmail.com>
 (Xiao
	Ni's message of "Wed, 15 Apr 2026 18:34:53 +0800")
References: <20260407102625.5686-1-glass.su@suse.com>
	<20260407102625.5686-2-glass.su@suse.com>
	<CALTww28wN=9R2RMApc89M=cRtHmrFYgc8qgakR6LwcyXeQNdDw@mail.gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Thu, 16 Apr 2026 22:08:43 +0800
Message-ID: <h5pb6lqs.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Wed 15 Apr 2026 at 18:34, Xiao Ni <xni@redhat.com> wrote:

> On Tue, Apr 7, 2026 at 6:26=E2=80=AFPM Su Yue <glass.su@suse.com> wrote:
>>
>> If bitmap/location is present, mdadm will call=20
>> update_array_info()
>> while growing bitmap from none to internal via=20
>> location_store().
>> md_bitmap_create() is needed to set mddev->bitmap_ops otherwise
>> mddev->bitmap_ops->get_stats() in update_array_info() will=20
>> trigger
>> kernel NULL pointer dereference.
>
>
> Hi Su Yue
>
> How can bitmap/location be present when bitmap is none? Could=20
> you
> provide the test commands that reproduce this problem?
>
Sorry for the misleading commit message. It can only be reproduced=20
patch 3 is appiled.
I adjusted the sequence of this patch for easy review because=20
md_bitmap_create,destroy
are touched in patch1,2 and 3. Also if put the patch after 3rd=20
patch,
it will break ability to bisect.

# mdadm --create --assume-clean /dev/md0 -f --bitmap=3Dinternal=20
  --raid-devices=3D2 --level=3Dmirror --metadata=3D1.2 /dev/vdc /dev/vdd
# mdadm --grow /dev/md0 --bitmap=3Dnone
# mdadm --grow /dev/md0 --bitmap=3Dinternal # step 3
# mdadm --grow /dev/md0 --bitmap=3Dnone # step 4
[1]    2325 killed     mdadm --grow /dev/md0 --bitmap=3Dnone

When step 3 is called,
md_bitmap_destroy() is called in update_array_info() to set NULL=20
mddev->bitmap_ops
then in step 4 kernel Oops is triggered.


I am willing to amend commit message or move it after patch 3 if=20
you would like.

--
Su

>
> mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1 --bitmap=3Dnone=20
> (There
> is not bitmap/location, because bitmap directory is not created)
> mdadm /dev/md0 --grow --bitmap=3Dinternal
> Grow.c md_set_array_info runs
>  451             array.state |=3D (1 << MD_SB_BITMAP_PRESENT);
>  452             rv =3D md_set_array_info(fd, &array);
> In kernel space, it runs
>  8125             rv =3D md_bitmap_create(mddev);
>  8126             if (!rv)
>  8127                 rv =3D mddev->bitmap_ops->load(mddev);
>
> Best Regards
> Xiao
>
>>
>> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of=20
>> bitmap_ops until creating bitmap")
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>  drivers/md/md-bitmap.c | 11 ++++++++---
>>  drivers/md/md.c        |  4 ++--
>>  drivers/md/md.h        |  2 ++
>>  3 files changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 83378c033c72..2f24aae05552 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev, const=20
>> char *buf, size_t len)
>>                         goto out;
>>                 }
>>
>> -               bitmap_destroy(mddev);
>> +               md_bitmap_destroy(mddev);
>>                 mddev->bitmap_info.offset =3D 0;
>>                 if (mddev->bitmap_info.file) {
>>                         struct file *f =3D=20
>>                         mddev->bitmap_info.file;
>> @@ -2653,15 +2653,20 @@ location_store(struct mddev *mddev,=20
>> const char *buf, size_t len)
>>                                 goto out;
>>                         }
>>
>> +                       /*
>> +                        * lockless bitmap shoudle have set=20
>> bitmap_id
>> +                        * using bitmap_type, so always=20
>> ID_BITMAP.
>> +                        */
>> +                       mddev->bitmap_id =3D ID_BITMAP;
>>                         mddev->bitmap_info.offset =3D offset;
>> -                       rv =3D bitmap_create(mddev);
>> +                       rv =3D md_bitmap_create(mddev);
>>                         if (rv)
>>                                 goto out;
>>
>>                         rv =3D bitmap_load(mddev);
>>                         if (rv) {
>>                                 mddev->bitmap_info.offset =3D 0;
>> -                               bitmap_destroy(mddev);
>> +                               md_bitmap_destroy(mddev);
>>                                 goto out;
>>                         }
>>                 }
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 3ce6f9e9d38e..8b1ecc370ad6 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6447,7 +6447,7 @@ static void md_safemode_timeout(struct=20
>> timer_list *t)
>>
>>  static int start_dirty_degraded;
>>
>> -static int md_bitmap_create(struct mddev *mddev)
>> +int md_bitmap_create(struct mddev *mddev)
>>  {
>>         if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>>                 return -EINVAL;
>> @@ -6458,7 +6458,7 @@ static int md_bitmap_create(struct mddev=20
>> *mddev)
>>         return mddev->bitmap_ops->create(mddev);
>>  }
>>
>> -static void md_bitmap_destroy(struct mddev *mddev)
>> +void md_bitmap_destroy(struct mddev *mddev)
>>  {
>>         if (!md_bitmap_registered(mddev))
>>                 return;
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index ac84289664cd..ed69244af00d 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -895,6 +895,8 @@ static inline void safe_put_page(struct=20
>> page *p)
>>
>>  int register_md_submodule(struct md_submodule_head *msh);
>>  void unregister_md_submodule(struct md_submodule_head *msh);
>> +int md_bitmap_create(struct mddev *mddev);
>> +void md_bitmap_destroy(struct mddev *mddev);
>>
>>  extern struct md_thread *md_register_thread(
>>         void (*run)(struct md_thread *thread),
>> --
>> 2.53.0
>>
