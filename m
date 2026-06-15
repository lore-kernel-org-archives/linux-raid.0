Received: from lf-2-44.ptr.blmpb.com (lf-2-44.ptr.blmpb.com [101.36.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F073F99F2
	for <linux-raid@vger.kernel.org>; Mon, 15 Jun 2026 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781540421; cv=none; b=Bm0+b0gETSdmjIPmDHj9IjfQSgdQUanmGWnLCWjeT0szXCzs1MMumS0G9KiiAqAPxAuBiWBz8Z+QLzinXrT2G8zq4TYMfej/QAIeN26k1PCNDQYhioYZTe0uFsWTkXlnmoBsC4pnHfNyaO/2zDq6IeVP85DC0EK57vfBuqMcTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781540421; c=relaxed/simple;
	bh=SnwT/mCvv2Z+8opY/A/sGRiDMDXWiEn6n1J977hmmFw=;
	h=References:From:Subject:Date:In-Reply-To:To:Message-Id:
	 Mime-Version:Content-Type:Cc; b=hrSryajVg/LTf5uJYwFP6qfUhoeQozach+QcG9OWkg0WJdgpbqaLzlIqmqDusUWeb2p7EecrfVj4fQG9m2u/tTtWVOC+qQERV64JNEu/EnDamQQHOclIb55vwGGxVf3c6cF7ZEm/+lYZKcTTCfd2GuydYfWD0X4+LdYgIsCgJK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Jh0YMauy; arc=none smtp.client-ip=101.36.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Jh0YMauy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781540370;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=SnwT/mCvv2Z+8opY/A/sGRiDMDXWiEn6n1J977hmmFw=;
 b=Jh0YMauyY79gxlv+QqnqGimqZj1033qWQs9YCJZspwED5KfL29vrXM0bhbPNj4gdNPW9vU
 DgpfBOqnBeRiYUVrUYJEZnqbbDNbtfaxDnBfkTJ2V76p6YYoRuFdKpM78+9S0p9aKsOjK6
 zH5u9xBrs4qVi42Le9Iv8qp0ktM+tPcAgUfEQlm3tcNcsnaUUQ0VqS6KKK20RStVRwidhv
 u1Iz+GGJsoyQkFkvrnlLtVSpmMU2Nc07huemQqdjNBPc/Yxv0+/Mc5Gesognw9qLtZI6OD
 jHXC15okbA2tNmMg7uSqUORI6N2mUkQPLnt4lssDmEt95aNnJCHtbiajrLD9QA==
References: <20260605091527.2463539-1-yukuai@kernel.org> <20260605091527.2463539-7-yukuai@kernel.org> <8q8gawaz.fsf@damenly.org>
Content-Transfer-Encoding: quoted-printable
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/md-llbitmap: grow the page cache in place for reshape
Date: Tue, 16 Jun 2026 00:19:25 +0800
In-Reply-To: <8q8gawaz.fsf@damenly.org>
To: "Su Yue" <l@damenly.org>, "Yu Kuai" <yukuai@kernel.org>
Message-Id: <d8d9c6a8-a333-424e-98e4-22140735d885@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a302611+c97b11+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Cc: "Song Liu" <song@kernel.org>, "Li Nan" <magiclinan@didiglobal.com>, 
	"Xiao Ni" <xiao@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.180]) by smtp.larksuite.com with ESMTPS; Mon, 15 Jun 2026 16:19:29 +0000

Hi,

=E5=9C=A8 2026/6/15 19:16, Su Yue =E5=86=99=E9=81=93:
> On Fri 05 Jun 2026 at 17:15, Yu Kuai <yukuai@kernel.org> wrote:
>
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> Use the page-control helpers to grow llbitmap's cached pages in place
>> for resize and later reshape preparation, instead of rebuilding the
>> whole cache.
>>
>> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>> ---
>> =C2=A0drivers/md/md-llbitmap.c | 139 =C2=A0+++++++++++++++++++++++++++++=
++++++----
>> =C2=A01 file changed, 127 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>> index 2f2896fe4d6f..91d3dec43d48 100644
>> --- a/drivers/md/md-llbitmap.c
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -414,10 +414,23 @@ static char=20
>> state_machine[BitStateCount][BitmapActionCount] =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [BitmapActionClearUnwri=
tten]=C2=A0=C2=A0=C2=A0 =3D BitUnwritten,
>> =C2=A0=C2=A0=C2=A0=C2=A0 },
>> =C2=A0};
>>
>> =C2=A0static void __llbitmap_flush(struct mddev *mddev);
>> +static void llbitmap_flush(struct mddev *mddev);
>> +static void llbitmap_update_sb(void *data);
>> +
>> +static void llbitmap_resize_chunks(struct mddev *mddev, sector_t=20
>> blocks,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long *chunksize,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long *chunks)
>>
> NIT: I would like call it llbitmap_calculate_chunks.

Agreed this is better, will change it.

>
>> +{
>> +=C2=A0=C2=A0=C2=A0 *chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, *chunksize=
);
>> +=C2=A0=C2=A0=C2=A0 while (*chunks > mddev->bitmap_info.space << SECTOR_=
SHIFT) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *chunksize =3D *chunksize <<=
 1;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *chunks =3D DIV_ROUND_UP_SEC=
TOR_T(blocks, *chunksize);
>> +=C2=A0=C2=A0=C2=A0 }
>> +}
>>
>> =C2=A0static enum llbitmap_state llbitmap_read(struct llbitmap =C2=A0*ll=
bitmap,=20
>> loff_t pos)
>> =C2=A0{
>> =C2=A0=C2=A0=C2=A0=C2=A0 unsigned int idx;
>> =C2=A0=C2=A0=C2=A0=C2=A0 unsigned int offset;
>> @@ -653,10 +666,52 @@ static unsigned int=20
>> llbitmap_reserved_pages(struct llbitmap *llbitmap)
>> =C2=A0{
>> =C2=A0=C2=A0=C2=A0=C2=A0 return DIV_ROUND_UP(llbitmap->mddev->bitmap_inf=
o.space <<=20
>> =C2=A0SECTOR_SHIFT,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 PAGE_SIZE);
>> =C2=A0}
>>
>> +static int llbitmap_expand_pages(struct llbitmap *llbitmap,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long chunks)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct llbitmap_page_ctl **pctl;
>> +=C2=A0=C2=A0=C2=A0 unsigned int old_nr_pages =3D llbitmap->nr_pages;
>> +=C2=A0=C2=A0=C2=A0 unsigned int nr_pages =3D llbitmap_used_pages(llbitm=
ap, chunks);
>> +=C2=A0=C2=A0=C2=A0 int i;
>> +=C2=A0=C2=A0=C2=A0 int ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (nr_pages <=3D old_nr_pages)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> +
>> +=C2=A0=C2=A0=C2=A0 pctl =3D kcalloc(nr_pages, sizeof(*pctl), GFP_KERNEL=
);
>> +=C2=A0=C2=A0=C2=A0 if (!pctl)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (llbitmap->pctl)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(pctl, llbitmap->pctl,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 array_size(old_nr_pages, sizeof(*pctl)));
>> +
>> +=C2=A0=C2=A0=C2=A0 for (i =3D old_nr_pages; i < nr_pages; i++) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pctl[i] =3D llbitmap_alloc_p=
age_ctl(llbitmap, i);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(pctl[i]))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto=
 err_alloc_ptr;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 kfree(llbitmap->pctl);
>> +=C2=A0=C2=A0=C2=A0 llbitmap->pctl =3D pctl;
>> +=C2=A0=C2=A0=C2=A0 llbitmap->nr_pages =3D nr_pages;
>> +=C2=A0=C2=A0=C2=A0 return 0;
>> +
>> +err_alloc_ptr:
>> +=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(pctl[i]);
>> +=C2=A0=C2=A0=C2=A0 for (i--; i >=3D (int)old_nr_pages; i--) {
>>
> Confused about why not just declare i as an unsigned int?
>
Yes, this looks better as well.

>
> --=20
> Su
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __free_page(pctl[i]->page);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_ref_exit(&pctl[i]->ac=
tive);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(pctl[i]);
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 kfree(pctl);
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> +}
>> +
>> =C2=A0static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
>> =C2=A0{
>> =C2=A0=C2=A0=C2=A0=C2=A0 unsigned int used_pages =3D llbitmap_used_pages=
(llbitmap,=20
>> =C2=A0llbitmap->chunks);
>> =C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_pages =3D max(used_pages,=20
>> =C2=A0llbitmap_reserved_pages(llbitmap));
>> =C2=A0=C2=A0=C2=A0=C2=A0 int i;
>> @@ -728,10 +783,38 @@ static bool llbitmap_zero_all_disks(struct=20
>> llbitmap *llbitmap)
>> =C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 return true;
>> =C2=A0}
>>
>> +static void llbitmap_mark_range(struct llbitmap *llbitmap,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 unsigned long start,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 unsigned long end,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 enum llbitmap_state state)
>> +{
>> +=C2=A0=C2=A0=C2=A0 while (start <=3D end) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap_write(llbitmap, sta=
te, start);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 start++;
>> +=C2=A0=C2=A0=C2=A0 }
>> +}
>> +
>> +static int llbitmap_prepare_resize(struct llbitmap *llbitmap,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long old_chunks,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long new_chunks,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long cache_chunks)
>> +{
>> +=C2=A0=C2=A0=C2=A0 int ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 llbitmap_flush(llbitmap->mddev);
>> +=C2=A0=C2=A0=C2=A0 ret =3D llbitmap_expand_pages(llbitmap, cache_chunks=
);
>> +=C2=A0=C2=A0=C2=A0 if (ret)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> +=C2=A0=C2=A0=C2=A0 if (new_chunks > old_chunks)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap_mark_range(llbitmap=
, old_chunks, new_chunks - 1,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BitUnwritten);
>> +=C2=A0=C2=A0=C2=A0 return 0;
>> +}
>> +
>> =C2=A0static void llbitmap_init_state(struct llbitmap *llbitmap)
>> =C2=A0{
>> =C2=A0=C2=A0=C2=A0=C2=A0 struct mddev *mddev =3D llbitmap->mddev;
>> =C2=A0=C2=A0=C2=A0=C2=A0 enum llbitmap_state state =3D BitUnwritten;
>> =C2=A0=C2=A0=C2=A0=C2=A0 unsigned long i;
>> @@ -1024,14 +1107,14 @@ static int llbitmap_read_sb(struct llbitmap=20
>> *llbitmap)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("md/llbitmap: %s=
: chunksize not a power of 2",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mdname(mddev));
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_put_page;
>> =C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> -=C2=A0=C2=A0=C2=A0 if (chunksize < DIV_ROUND_UP_SECTOR_T(mddev->resync_=
max_sectors,
>> +=C2=A0=C2=A0=C2=A0 if (chunksize < DIV_ROUND_UP_SECTOR_T(sync_size,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 mddev->bitmap_info.space << =C2=A0SECTOR_SHIFT)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("md/llbitmap: %s=
: chunksize too small %lu < %llu /=20
>> =C2=A0%lu",
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 mdname(mddev), chunksize, mddev->resync_max_sectors,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 mdname(mddev), chunksize, sync_size,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mddev->bitmap_info.space);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_put_page;
>> =C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 daemon_sleep =3D le32_to_cpu(sb->daemon_sleep);
>> @@ -1169,28 +1252,60 @@ static int llbitmap_create(struct mddev *mddev)
>> =C2=A0}
>>
>> =C2=A0static int llbitmap_resize(struct mddev *mddev, sector_t =C2=A0blo=
cks,=20
>> int chunksize)
>> =C2=A0{
>> =C2=A0=C2=A0=C2=A0=C2=A0 struct llbitmap *llbitmap =3D mddev->bitmap;
>> +=C2=A0=C2=A0=C2=A0 sector_t old_blocks =3D llbitmap->sync_size;
>> +=C2=A0=C2=A0=C2=A0 unsigned long old_chunks =3D llbitmap->chunks;
>> =C2=A0=C2=A0=C2=A0=C2=A0 unsigned long chunks;
>> +=C2=A0=C2=A0=C2=A0 unsigned long cache_chunks;
>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>> +=C2=A0=C2=A0=C2=A0 unsigned long bitmap_chunksize;
>> +=C2=A0=C2=A0=C2=A0 bool reshape;
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 if (chunksize =3D=3D 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunksize =3D llbitmap-=
>chunksize;
>>
>> -=C2=A0=C2=A0=C2=A0 /* If there is enough space, leave the chunksize unc=
hanged. */
>> -=C2=A0=C2=A0=C2=A0 chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
>> -=C2=A0=C2=A0=C2=A0 while (chunks > mddev->bitmap_info.space << SECTOR_S=
HIFT) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunksize =3D chunksize << 1=
;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunks =3D DIV_ROUND_UP_SECT=
OR_T(blocks, chunksize);
>> -=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 bitmap_chunksize =3D chunksize;
>> +=C2=A0=C2=A0=C2=A0 llbitmap_resize_chunks(mddev, blocks, &bitmap_chunks=
ize, &chunks);
>>
>> -=C2=A0=C2=A0=C2=A0 llbitmap->chunkshift =3D ffz(~chunksize);
>> -=C2=A0=C2=A0=C2=A0 llbitmap->chunksize =3D chunksize;
>> -=C2=A0=C2=A0=C2=A0 llbitmap->chunks =3D chunks;
>> -=C2=A0=C2=A0=C2=A0 llbitmap->sync_size =3D blocks;
>> +=C2=A0=C2=A0=C2=A0 reshape =3D mddev->delta_disks || mddev->new_level !=
=3D mddev->level ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->new_layout !=3D mddev=
->layout ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->new_chunk_sectors !=
=3D mddev->chunk_sectors;
>> +=C2=A0=C2=A0=C2=A0 if (!reshape && bitmap_chunksize !=3D llbitmap->chun=
ksize)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EOPNOTSUPP;
>> +=C2=A0=C2=A0=C2=A0 if (blocks =3D=3D old_blocks && chunks =3D=3D llbitm=
ap->chunks)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> +
>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&mddev->bitmap_info.mutex);
>>
>> +=C2=A0=C2=A0=C2=A0 cache_chunks =3D reshape ? max(old_chunks, chunks) :=
 chunks;
>> +=C2=A0=C2=A0=C2=A0 ret =3D llbitmap_prepare_resize(llbitmap, old_chunks=
, chunks,=20
>> cache_chunks);
>> +=C2=A0=C2=A0=C2=A0 if (ret)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (reshape) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap->reshape_sync_size =
=3D blocks;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap->reshape_chunksize =
=3D bitmap_chunksize;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap->reshape_chunks =3D=
 chunks;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap->chunks =3D max(old=
_chunks, chunks);
>> +=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (blocks < old_blocks && c=
hunks < old_chunks)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbi=
tmap_mark_range(llbitmap, chunks, old_chunks - 1,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BitUn=
written);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_info.chunksize=
 =3D bitmap_chunksize;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap->chunks =3D chunks;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap->sync_size =3D bloc=
ks;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 llbitmap_update_sb(llbitmap)=
;
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 __llbitmap_flush(mddev);
>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&mddev->bitmap_info.mutex);
>> =C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> +
>> +out:
>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&mddev->bitmap_info.mutex);
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0}
>>
>> =C2=A0static int llbitmap_load(struct mddev *mddev)
>> =C2=A0{
>> =C2=A0=C2=A0=C2=A0=C2=A0 enum llbitmap_action action =3D BitmapActionRel=
oad;

--=20
Thanks,
Kuai
