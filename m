Received: from mail-108-mta133.mxroute.com (mail-108-mta133.mxroute.com [136.175.108.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E956F347C6
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 01:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776735110; cv=none; b=D9GJH8Hgj/Fk/gUSO/Wq6IaV5z4IwjwTrx08ObCpY36mraMw95XKr2vGvNRa00mMRPvJwT72Zr/PDVBTDEEIzJGbFL+KwQyLSBI6yaxi+rXnOXW6ZHFJUVDSd5C1DVe9F0J6p4l5Y190JFKAoPJJGAcFLMnHi3bMiJm+fBbX08I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776735110; c=relaxed/simple;
	bh=zCTHwI99t/2Y5RQBEpCEwv+Vf5YFbRuvwS7NSC2NgAM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=biemGrn8nFr+PxaqzwpPx4argf/VkDSL5CGKiL5Mvv3v/SW8NzALdA3mvbzolbFiowGONFoutKXrYaCP3sigjJgNAT0+FvfrafYUlEpQh4YCzypJl2kr02eCj/o/mgbJHcUm7xSk4ycgocJdYt8t9/YVw6AXjQmUx8Nt7UTlAJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=JY4mG721; arc=none smtp.client-ip=136.175.108.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="JY4mG721"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta133.mxroute.com (ZoneMTA) with ESMTPSA id 19dada57bb600032bf.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 21 Apr 2026 01:26:36 +0000
X-Zone-Loop: 4d3f97c9eee7c01478dcfc1681bbb0d1b2e1512f56da
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=51d+L8NGXFyhoDIYCGq4Y6Q/VSOaFrR7QXKg7t8sg+4=; b=JY4mG721uny63VJAqqI1tN+Mnf
	6dVohFkO4UrAO+Bz0BEQSB1r5h9rnWWdSW9Yh+FKml/4DDkqPv6raws8LRQy787uf4fjzbQTm7TEh
	lmvh7r4PXPULfiAvF2TztBiqlT9AzYLgobfZCCFvf80w7+2O/cLDCFNHzrCRtSUqMZ9pCB0qRn73M
	JD10pV25yuPfRXi0bbxqs1Prsi57k7qc82t8SjDLnngXTza0e+bCqctsFS/+o4TOtazgoTIJObVRk
	oRfnA4X9BYpYuQVWxHg4fEjOeEWPLXq4ZsPn0QOZtw7M5QuZxU7dBEssex154L8Ivm+F/pjS/fv9z
	sKvIfsGg==;
From: Su Yue <l@damenly.org>
To: Xiao Ni <xni@redhat.com>
Cc: Su Yue <glass.su@suse.com>,  linux-raid@vger.kernel.org,
  song@kernel.org,  linan122@huawei.com,  yukuai@fnnas.com,
  heming.zhao@suse.com
Subject: Re: [PATCH v2 1/5] md/md-bitmap: call md_bitmap_create,destroy in
 location_store
In-Reply-To: <CALTww28=dKKbx+jrED_e3dzQYRtC=Vh9qk04JPy=rjpE2OA7ww@mail.gmail.com>
 (Xiao
	Ni's message of "Mon, 20 Apr 2026 13:21:03 +0800")
References: <20260407102625.5686-1-glass.su@suse.com>
	<20260407102625.5686-2-glass.su@suse.com>
	<CALTww28wN=9R2RMApc89M=cRtHmrFYgc8qgakR6LwcyXeQNdDw@mail.gmail.com>
	<h5pb6lqs.fsf@damenly.org>
	<CALTww28=dKKbx+jrED_e3dzQYRtC=Vh9qk04JPy=rjpE2OA7ww@mail.gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 21 Apr 2026 09:26:25 +0800
Message-ID: <5x5l6r3y.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Mon 20 Apr 2026 at 13:21, Xiao Ni <xni@redhat.com> wrote:

> On Thu, Apr 16, 2026 at 10:09=E2=80=AFPM Su Yue <l@damenly.org> wrote:
>>
>> On Wed 15 Apr 2026 at 18:34, Xiao Ni <xni@redhat.com> wrote:
>>
>> > On Tue, Apr 7, 2026 at 6:26=E2=80=AFPM Su Yue <glass.su@suse.com>=20
>> > wrote:
>> >>
>> >> If bitmap/location is present, mdadm will call
>> >> update_array_info()
>> >> while growing bitmap from none to internal via
>> >> location_store().
>> >> md_bitmap_create() is needed to set mddev->bitmap_ops=20
>> >> otherwise
>> >> mddev->bitmap_ops->get_stats() in update_array_info() will
>> >> trigger
>> >> kernel NULL pointer dereference.
>> >
>> >
>> > Hi Su Yue
>> >
>> > How can bitmap/location be present when bitmap is none? Could
>> > you
>> > provide the test commands that reproduce this problem?
>> >
>> Sorry for the misleading commit message. It can only be=20
>> reproduced
>> patch 3 is appiled.
>> I adjusted the sequence of this patch for easy review because
>> md_bitmap_create,destroy
>> are touched in patch1,2 and 3. Also if put the patch after 3rd
>> patch,
>> it will break ability to bisect.
>>
>> # mdadm --create --assume-clean /dev/md0 -f --bitmap=3Dinternal
>>   --raid-devices=3D2 --level=3Dmirror --metadata=3D1.2 /dev/vdc=20
>>   /dev/vdd
>> # mdadm --grow /dev/md0 --bitmap=3Dnone
>> # mdadm --grow /dev/md0 --bitmap=3Dinternal # step 3
>> # mdadm --grow /dev/md0 --bitmap=3Dnone # step 4
>> [1]    2325 killed     mdadm --grow /dev/md0 --bitmap=3Dnone
>>
>> When step 3 is called,
>> md_bitmap_destroy() is called in update_array_info() to set=20
>> NULL
>> mddev->bitmap_ops
>> then in step 4 kernel Oops is triggered.
>>
>>
>> I am willing to amend commit message or move it after patch 3=20
>> if
>> you would like.
>
> Hi Su
>
> Thanks for the detail explanation. After reading patch3, I=20
> totoally
> understand. The sequence is good to me. And yes, it's better to
> explain that this is needed after patch3.
>
Sure. I will do it in next version.

--
Su
>
> Best Regards
> Xiao
>>
>> --
>> Su
>>
>> >
>> > mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1=20
>> > --bitmap=3Dnone
>> > (There
>> > is not bitmap/location, because bitmap directory is not=20
>> > created)
>> > mdadm /dev/md0 --grow --bitmap=3Dinternal
>> > Grow.c md_set_array_info runs
>> >  451             array.state |=3D (1 << MD_SB_BITMAP_PRESENT);
>> >  452             rv =3D md_set_array_info(fd, &array);
>> > In kernel space, it runs
>> >  8125             rv =3D md_bitmap_create(mddev);
>> >  8126             if (!rv)
>> >  8127                 rv =3D mddev->bitmap_ops->load(mddev);
>> >
>> > Best Regards
>> > Xiao
>> >
>> >>
>> >> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of
>> >> bitmap_ops until creating bitmap")
>> >> Signed-off-by: Su Yue <glass.su@suse.com>
>> >> ---
>> >>  drivers/md/md-bitmap.c | 11 ++++++++---
>> >>  drivers/md/md.c        |  4 ++--
>> >>  drivers/md/md.h        |  2 ++
>> >>  3 files changed, 12 insertions(+), 5 deletions(-)
>> >>
>> >> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> >> index 83378c033c72..2f24aae05552 100644
>> >> --- a/drivers/md/md-bitmap.c
>> >> +++ b/drivers/md/md-bitmap.c
>> >> @@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev,=20
>> >> const
>> >> char *buf, size_t len)
>> >>                         goto out;
>> >>                 }
>> >>
>> >> -               bitmap_destroy(mddev);
>> >> +               md_bitmap_destroy(mddev);
>> >>                 mddev->bitmap_info.offset =3D 0;
>> >>                 if (mddev->bitmap_info.file) {
>> >>                         struct file *f =3D
>> >>                         mddev->bitmap_info.file;
>> >> @@ -2653,15 +2653,20 @@ location_store(struct mddev *mddev,
>> >> const char *buf, size_t len)
>> >>                                 goto out;
>> >>                         }
>> >>
>> >> +                       /*
>> >> +                        * lockless bitmap shoudle have set
>> >> bitmap_id
>> >> +                        * using bitmap_type, so always
>> >> ID_BITMAP.
>> >> +                        */
>> >> +                       mddev->bitmap_id =3D ID_BITMAP;
>> >>                         mddev->bitmap_info.offset =3D offset;
>> >> -                       rv =3D bitmap_create(mddev);
>> >> +                       rv =3D md_bitmap_create(mddev);
>> >>                         if (rv)
>> >>                                 goto out;
>> >>
>> >>                         rv =3D bitmap_load(mddev);
>> >>                         if (rv) {
>> >>                                 mddev->bitmap_info.offset =3D=20
>> >>                                 0;
>> >> -                               bitmap_destroy(mddev);
>> >> +                               md_bitmap_destroy(mddev);
>> >>                                 goto out;
>> >>                         }
>> >>                 }
>> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> >> index 3ce6f9e9d38e..8b1ecc370ad6 100644
>> >> --- a/drivers/md/md.c
>> >> +++ b/drivers/md/md.c
>> >> @@ -6447,7 +6447,7 @@ static void md_safemode_timeout(struct
>> >> timer_list *t)
>> >>
>> >>  static int start_dirty_degraded;
>> >>
>> >> -static int md_bitmap_create(struct mddev *mddev)
>> >> +int md_bitmap_create(struct mddev *mddev)
>> >>  {
>> >>         if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>> >>                 return -EINVAL;
>> >> @@ -6458,7 +6458,7 @@ static int md_bitmap_create(struct=20
>> >> mddev
>> >> *mddev)
>> >>         return mddev->bitmap_ops->create(mddev);
>> >>  }
>> >>
>> >> -static void md_bitmap_destroy(struct mddev *mddev)
>> >> +void md_bitmap_destroy(struct mddev *mddev)
>> >>  {
>> >>         if (!md_bitmap_registered(mddev))
>> >>                 return;
>> >> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> >> index ac84289664cd..ed69244af00d 100644
>> >> --- a/drivers/md/md.h
>> >> +++ b/drivers/md/md.h
>> >> @@ -895,6 +895,8 @@ static inline void safe_put_page(struct
>> >> page *p)
>> >>
>> >>  int register_md_submodule(struct md_submodule_head *msh);
>> >>  void unregister_md_submodule(struct md_submodule_head=20
>> >>  *msh);
>> >> +int md_bitmap_create(struct mddev *mddev);
>> >> +void md_bitmap_destroy(struct mddev *mddev);
>> >>
>> >>  extern struct md_thread *md_register_thread(
>> >>         void (*run)(struct md_thread *thread),
>> >> --
>> >> 2.53.0
>> >>
>>
