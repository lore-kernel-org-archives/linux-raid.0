Received: from sg-1-13.ptr.blmpb.com (sg-1-13.ptr.blmpb.com [118.26.132.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38DB2253EB
	for <linux-raid@vger.kernel.org>; Mon, 23 Feb 2026 02:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771814216; cv=none; b=QaDqCTX3qIlEajfErQH1aiHC+FdwWvXlY7oWpNoGyTrFgMhQNmiT4BJaarvF5eOfV4MK1uF4mHoa1FqU8nJN3rfImmnR3rfy6SGFyQK1P2FLW3yx9uGTLLL0CQYOkTD3/NEULYIciLLjvUmzWbURfCnIMS29cWEPGxg1ub9Ik04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771814216; c=relaxed/simple;
	bh=2kFPGuIFmZkMZw851Y/MUIT1hsvWPXJKEKjnx0/iUI4=;
	h=Message-Id:In-Reply-To:From:Date:References:Content-Type:To:Cc:
	 Subject:Mime-Version; b=FB0IJ/+alVtp1mUISWwf0JZvVl/BQCqMxWdwSeYf1Z88z+Rg35ssV6pwY9i9sZo+KuS2z2nIpo+d81RhclWoA3kerqHyKoSwkUuLfplU0zcD6sB/ZsC28Og2Dy+HaghZp/w/jV89XXPI2s8lDmFvKQD3zrP6SeySEwcTXJqlmf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=3wXD3/qr; arc=none smtp.client-ip=118.26.132.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="3wXD3/qr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1771813373;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2kFPGuIFmZkMZw851Y/MUIT1hsvWPXJKEKjnx0/iUI4=;
 b=3wXD3/qrgnps5STq9U3LoyvX7Gh/clzjqXzAGJaHKDhyfxiuH503PC2Bvc02o5VasZj6ZR
 zW8666rm/WQwwodm6I+LHYvryBj5CG5aOiZDOxJO7RUgqqvbJFQCfMtmh9szI5dUh2tRIQ
 +LfJS/iG2Hl0qxUrygFZnaBuehzc6f6tFctXjDObdL02ueD/CD5CXqueAF7MTBpumn6aep
 WZL5JOlkeXF8BeGd1CFdE9ABPy0kpWtshQmSJhYsCb9OIFPSVapQhbm6h6nkrA3+EYR2+c
 uIN4oy19oL4UcJnEby5+DXrF/EmPXpTlyYZJvhpemL2mPe5iYiwQSbYpHn9l5g==
Message-Id: <d8598163-f684-4a88-bde7-bef795a3a584@fnnas.com>
In-Reply-To: <h5rf7nsv.fsf@damenly.org>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Mon, 23 Feb 2026 10:22:49 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+2699bb9fb+8dd786+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.132]) by smtp.feishu.cn with ESMTPS; Mon, 23 Feb 2026 10:22:50 +0800
Reply-To: yukuai@fnnas.com
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260214061013.2335604-1-yukuai@fnnas.com> <20260214061013.2335604-4-yukuai@fnnas.com> <h5rf7nsv.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8
To: "Su Yue" <l@damenly.org>
Cc: <song@kernel.org>, <linan122@huawei.com>, <xni@redhat.com>, 
	<colyli@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
Subject: Re: [PATCH 3/5] md: add fallback to correct bitmap_ops on version mismatch
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

=E5=9C=A8 2026/2/17 16:54, Su Yue =E5=86=99=E9=81=93:
> On Sat 14 Feb 2026 at 14:10, Yu Kuai <yukuai@fnnas.com> wrote:
>
>> If default bitmap version and on-disk version doesn't match, and mdadm
>> is not the latest version to set bitmap_type, set bitmap_ops based on
>> the disk version.
>>
> Why not just let old version mdadm fails=C2=A0 since llbitmap is a new=20
> feature.

The original use case is that we found llbitmap array fails to assemble in
some corner cases, and with the respect I'm not quite familiar with mdadm
code, so I think this patch is the best solution for now.

On the other hand, this should also be helpful if we decide to make llbitma=
p
the default option in the future.

>
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>> ---
>> =C2=A0drivers/md/md.c | 103 =C2=A0++++++++++++++++++++++++++++++++++++++=
+++++++++-
>> =C2=A01 file changed, 102 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 59cd303548de..d2607ed5c2e9 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6447,15 +6447,116 @@ static void md_safemode_timeout(struct=20
>> timer_list *t)
>>
>> =C2=A0static int start_dirty_degraded;
>>
>> +/*
>> + * Read bitmap superblock and return the bitmap_id based on disk=20
>> version.
>> + * This is used as fallback when default bitmap version and on-disk=20
>> version
>> + * doesn't match, and mdadm is not the latest version to set=20
>> bitmap_type.
>> + */
>> +static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev=20
>> *mddev)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev;
>> +=C2=A0=C2=A0=C2=A0 struct page *sb_page;
>> +=C2=A0=C2=A0=C2=A0 bitmap_super_t *sb;
>> +=C2=A0=C2=A0=C2=A0 enum md_submodule_id id =3D ID_BITMAP_NONE;
>> +=C2=A0=C2=A0=C2=A0 sector_t sector;
>> +=C2=A0=C2=A0=C2=A0 u32 version;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (!mddev->bitmap_info.offset)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ID_BITMAP_NONE;
>> +
>> +=C2=A0=C2=A0=C2=A0 sb_page =3D alloc_page(GFP_KERNEL);
>> +=C2=A0=C2=A0=C2=A0 if (!sb_page)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ID_BITMAP_NONE;
>> +
>>
> Personally I don't like the way treating error as ID_BITMAP_NONE.
> When wrong things happen everything looks fine, no error code, no=20
> error message.

Ok, sounds reasonable.

>
>> +=C2=A0=C2=A0=C2=A0 sector =3D mddev->bitmap_info.offset;
>> +
>> +=C2=A0=C2=A0=C2=A0 rdev_for_each(rdev, mddev) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 iosize;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!test_bit(In_sync, &rdev=
->flags) ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test=
_bit(Faulty, &rdev->flags) ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test=
_bit(Bitmap_sync, &rdev->flags))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cont=
inue;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iosize =3D roundup(sizeof(bi=
tmap_super_t),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 bdev_logical_block_size(rdev->bdev));
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sync_page_io(rdev, secto=
r, iosize, sb_page, REQ_OP_READ,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 true))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto=
 read_ok;
>> +=C2=A0=C2=A0=C2=A0 }
>>
> And here.
>
>> +=C2=A0=C2=A0=C2=A0 goto out;
>> +
>> +read_ok:
>> +=C2=A0=C2=A0=C2=A0 sb =3D kmap_local_page(sb_page);
>> +=C2=A0=C2=A0=C2=A0 if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_unmap;
>> +
>> +=C2=A0=C2=A0=C2=A0 version =3D le32_to_cpu(sb->version);
>> +=C2=A0=C2=A0=C2=A0 switch (version) {
>> +=C2=A0=C2=A0=C2=A0 case BITMAP_MAJOR_LO:
>> +=C2=A0=C2=A0=C2=A0 case BITMAP_MAJOR_HI:
>> +=C2=A0=C2=A0=C2=A0 case BITMAP_MAJOR_CLUSTERED:
>>
> For BITMAP_MAJOR_CLUSTERED, why not ID_CLUSTER ?

Because there is no optional bitmap_ops for md-cluster, it's still
the old bitmap, and llbitmap does not support md-cluster for now.

>
> --=20
> Su
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 id =3D ID_BITMAP;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> +=C2=A0=C2=A0=C2=A0 case BITMAP_MAJOR_LOCKLESS:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 id =3D ID_LLBITMAP;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> +=C2=A0=C2=A0=C2=A0 default:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_warn("md: %s: unknown bit=
map version %u\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdna=
me(mddev), version);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +out_unmap:
>> +=C2=A0=C2=A0=C2=A0 kunmap_local(sb);
>> +out:
>> +=C2=A0=C2=A0=C2=A0 __free_page(sb_page);
>> +=C2=A0=C2=A0=C2=A0 return id;
>> +}
>> +
>> =C2=A0static int md_bitmap_create(struct mddev *mddev)
>> =C2=A0{
>> +=C2=A0=C2=A0=C2=A0 enum md_submodule_id orig_id =3D mddev->bitmap_id;
>> +=C2=A0=C2=A0=C2=A0 enum md_submodule_id sb_id;
>> +=C2=A0=C2=A0=C2=A0 int err;
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0 if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 if (!mddev_set_bitmap_ops(mddev))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOENT;
>>
>> -=C2=A0=C2=A0=C2=A0 return mddev->bitmap_ops->create(mddev);
>> +=C2=A0=C2=A0=C2=A0 err =3D mddev->bitmap_ops->create(mddev);
>> +=C2=A0=C2=A0=C2=A0 if (!err)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>
>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Create failed, if default bitmap version and=
 on-disk version
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * doesn't match, and mdadm is not the latest v=
ersion to set
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * bitmap_type, set bitmap_ops based on the dis=
k version.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 mddev_clear_bitmap_ops(mddev);
>> +
>> +=C2=A0=C2=A0=C2=A0 sb_id =3D md_bitmap_get_id_from_sb(mddev);
>> +=C2=A0=C2=A0=C2=A0 if (sb_id =3D=3D ID_BITMAP_NONE || sb_id =3D=3D orig=
_id)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
>> +
>> +=C2=A0=C2=A0=C2=A0 pr_info("md: %s: bitmap version mismatch, switching =
from %d to=20
>> %d\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdname(mddev), orig_id, sb_i=
d);
>> +
>> +=C2=A0=C2=A0=C2=A0 mddev->bitmap_id =3D sb_id;
>> +=C2=A0=C2=A0=C2=A0 if (!mddev_set_bitmap_ops(mddev)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_id =3D orig_id=
;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOENT;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 err =3D mddev->bitmap_ops->create(mddev);
>> +=C2=A0=C2=A0=C2=A0 if (err) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev_clear_bitmap_ops(mddev=
);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_id =3D orig_id=
;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 return err;
>> =C2=A0}
>>
>> =C2=A0static void md_bitmap_destroy(struct mddev *mddev)

--=20
Thansk,
Kuai
