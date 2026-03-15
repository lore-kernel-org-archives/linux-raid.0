Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE7935A927
	for <linux-raid@vger.kernel.org>; Sun, 15 Mar 2026 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773594127; cv=none; b=LTg247rCU1jrnZ/EgBfbvQ4dZA6e6lRNIiL5JI8FJPkf/Jot3USAiGVIiip5c3dLd1O9rzbYfOSpMy7mVsaDTJXRJa6URB2bClMbv41A1YFc7rnw0wW+V+t51L9R/VR8tlo7G6TbYNMQItxMr36UBzuxGH4OXOGB7F/kl9giLxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773594127; c=relaxed/simple;
	bh=bL1WsGztdhOMRGdn0PBMYWuicQ+V67Ox1Hw/I8V7JMI=;
	h=To:From:Mime-Version:Message-Id:Subject:In-Reply-To:Cc:Date:
	 References:Content-Type; b=b3t3xI05qWjapE8mUTGFsvtVYHNCYImDSINbuwqoMBWLSrVNOyG/n/QtWg0//OxqdhApPMlDsmFwn2ySeSSkpxE+AVFAg5/ungAT9CjERl+rDhvHOtGrKIJliwA/Kl8B47nyJQUMAkkGWGVNrHvTKqAuFxBsgQ6IJSDC1tuUvJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=iUKTnQJh; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="iUKTnQJh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773594120;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UZrJN6WnKB0agetdvXnpFSs4VjiMClmGGdqFhaEgzDA=;
 b=iUKTnQJhMvpvMYd1HsfbwOZkaD5HtgeQny2DVlnsSdXQNUsR08FT9wHR9KxWAZ0/UuRSeJ
 05MyszAkrdVmI6p3TIoqWp32zWKpPbuHgeD2uWL+PQ7rTQRjBJIoHlpBNHJAvNI6tsgE+i
 P58Jpa5XmECOfuZPws/h+oIyqq9uClBGrrTnqKdMl7fIQm3G3IrzzHra8+g0tw2zfJoRA2
 +0a5Qz3LOK89AmH11oWF+ylfVpYAkOIcPrM2D2SraV6KU7jI+/5yt12O0Plcq/eNmaBbIi
 W0avx7i3VtheV+uRCsHX85aA7T6GUwXNaiCAecn1fJj/8j+xWfx3NeWgs7HszQ==
To: "Xiao Ni" <xni@redhat.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Message-Id: <3af32442-5783-41fb-85c4-1e68d2ef2149@fnnas.com>
Content-Language: en-US
Subject: Re: [PATCH v2 3/5] md: add fallback to correct bitmap_ops on version mismatch
In-Reply-To: <CALTww28rtki9J=_GB1zf4N5FBcdz+vzSvB1bNb-O2-AgrUzgSA@mail.gmail.com>
Received: from [192.168.1.104] ([39.182.0.175]) by smtp.feishu.cn with ESMTPS; Mon, 16 Mar 2026 01:01:58 +0800
Cc: <song@kernel.org>, <linan122@huawei.com>, <colyli@fnnas.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 16 Mar 2026 01:01:55 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260223024038.3084853-1-yukuai@fnnas.com> <20260223024038.3084853-4-yukuai@fnnas.com> <CALTww28rtki9J=_GB1zf4N5FBcdz+vzSvB1bNb-O2-AgrUzgSA@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269b6e607+75ac56+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/3/10 9:06, Xiao Ni =E5=86=99=E9=81=93:
> On Mon, Feb 23, 2026 at 10:43=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote=
:
>> If default bitmap version and on-disk version doesn't match, and mdadm
>> is not the latest version to set bitmap_type, set bitmap_ops based on
>> the disk version.
> Hi Kuai
>
> How can I do test to check if this patch works?
>
> 1. Create array with llbitmap
> 2. Stop the array
> 3. uninstall mdadm with llbitmap support and install mdadm without llbitm=
ap
> 4. assemble the array

At first, my colleague met this problem during power off and reboot test, h=
owever
I can't reproduce this, after adding some debug info, I'm quite sure this i=
s still
an mdadm issue, that somewhere write llbitmap to sysfs bitmap_type file is =
missing.

Also, this way can be check as well if this patch works.

>
> Is it the case you want to fix?
>
> Regards
> Xiao
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>> ---
>>   drivers/md/md.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 110 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 72a1c7267851..245785ad0ffd 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6447,15 +6447,124 @@ static void md_safemode_timeout(struct timer_li=
st *t)
>>
>>   static int start_dirty_degraded;
>>
>> +/*
>> + * Read bitmap superblock and return the bitmap_id based on disk versio=
n.
>> + * This is used as fallback when default bitmap version and on-disk ver=
sion
>> + * doesn't match, and mdadm is not the latest version to set bitmap_typ=
e.
>> + */
>> +static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev *mdde=
v)
>> +{
>> +       struct md_rdev *rdev;
>> +       struct page *sb_page;
>> +       bitmap_super_t *sb;
>> +       enum md_submodule_id id =3D ID_BITMAP_NONE;
>> +       sector_t sector;
>> +       u32 version;
>> +
>> +       if (!mddev->bitmap_info.offset)
>> +               return ID_BITMAP_NONE;
>> +
>> +       sb_page =3D alloc_page(GFP_KERNEL);
>> +       if (!sb_page) {
>> +               pr_warn("md: %s: failed to allocate memory for bitmap\n"=
,
>> +                       mdname(mddev));
>> +               return ID_BITMAP_NONE;
>> +       }
>> +
>> +       sector =3D mddev->bitmap_info.offset;
>> +
>> +       rdev_for_each(rdev, mddev) {
>> +               u32 iosize;
>> +
>> +               if (!test_bit(In_sync, &rdev->flags) ||
>> +                   test_bit(Faulty, &rdev->flags) ||
>> +                   test_bit(Bitmap_sync, &rdev->flags))
>> +                       continue;
>> +
>> +               iosize =3D roundup(sizeof(bitmap_super_t),
>> +                                bdev_logical_block_size(rdev->bdev));
>> +               if (sync_page_io(rdev, sector, iosize, sb_page, REQ_OP_R=
EAD,
>> +                                true))
>> +                       goto read_ok;
>> +       }
>> +       pr_warn("md: %s: failed to read bitmap from any device\n",
>> +               mdname(mddev));
>> +       goto out;
>> +
>> +read_ok:
>> +       sb =3D kmap_local_page(sb_page);
>> +       if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC)) {
>> +               pr_warn("md: %s: invalid bitmap magic 0x%x\n",
>> +                       mdname(mddev), le32_to_cpu(sb->magic));
>> +               goto out_unmap;
>> +       }
>> +
>> +       version =3D le32_to_cpu(sb->version);
>> +       switch (version) {
>> +       case BITMAP_MAJOR_LO:
>> +       case BITMAP_MAJOR_HI:
>> +       case BITMAP_MAJOR_CLUSTERED:
>> +               id =3D ID_BITMAP;
>> +               break;
>> +       case BITMAP_MAJOR_LOCKLESS:
>> +               id =3D ID_LLBITMAP;
>> +               break;
>> +       default:
>> +               pr_warn("md: %s: unknown bitmap version %u\n",
>> +                       mdname(mddev), version);
>> +               break;
>> +       }
>> +
>> +out_unmap:
>> +       kunmap_local(sb);
>> +out:
>> +       __free_page(sb_page);
>> +       return id;
>> +}
>> +
>>   static int md_bitmap_create(struct mddev *mddev)
>>   {
>> +       enum md_submodule_id orig_id =3D mddev->bitmap_id;
>> +       enum md_submodule_id sb_id;
>> +       int err;
>> +
>>          if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>>                  return -EINVAL;
>>
>>          if (!mddev_set_bitmap_ops(mddev))
>>                  return -ENOENT;
>>
>> -       return mddev->bitmap_ops->create(mddev);
>> +       err =3D mddev->bitmap_ops->create(mddev);
>> +       if (!err)
>> +               return 0;
>> +
>> +       /*
>> +        * Create failed, if default bitmap version and on-disk version
>> +        * doesn't match, and mdadm is not the latest version to set
>> +        * bitmap_type, set bitmap_ops based on the disk version.
>> +        */
>> +       mddev_clear_bitmap_ops(mddev);
>> +
>> +       sb_id =3D md_bitmap_get_id_from_sb(mddev);
>> +       if (sb_id =3D=3D ID_BITMAP_NONE || sb_id =3D=3D orig_id)
>> +               return err;
>> +
>> +       pr_info("md: %s: bitmap version mismatch, switching from %d to %=
d\n",
>> +               mdname(mddev), orig_id, sb_id);
>> +
>> +       mddev->bitmap_id =3D sb_id;
>> +       if (!mddev_set_bitmap_ops(mddev)) {
>> +               mddev->bitmap_id =3D orig_id;
>> +               return -ENOENT;
>> +       }
>> +
>> +       err =3D mddev->bitmap_ops->create(mddev);
>> +       if (err) {
>> +               mddev_clear_bitmap_ops(mddev);
>> +               mddev->bitmap_id =3D orig_id;
>> +       }
>> +
>> +       return err;
>>   }
>>
>>   static void md_bitmap_destroy(struct mddev *mddev)
>> --
>> 2.51.0
>>
>>
--=20
Thansk,
Kuai
