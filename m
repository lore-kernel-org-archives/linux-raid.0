Received: from mail-108-mta181.mxroute.com (mail-108-mta181.mxroute.com [136.175.108.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56C3290AE
	for <linux-raid@vger.kernel.org>; Tue, 10 Mar 2026 05:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773120319; cv=none; b=PAoZ0SdvM25at1V+9mLcYOAzhF/Wo6M8NjYyEVUcVh3f2hWfCpHXNilBcd9F/X3KRFxfeQoyPiJmJX67NmIXtYPfsPa7bxZRKUiJTJ2mod/Xj3TEma1DQ/1+koc7pfz+O+NparkrUjQ/tGu2x9a6qQIGF4zfC4t/lnE/yGO+i1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773120319; c=relaxed/simple;
	bh=6zIUSxIBURL9otFwsUlI8yfyXm6/ydJjBezv/6rGcZY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nPKXWVR1H+AKhFSCsjIdAK4DpjSHoH1E0hxtkzJaSWiAlnnTDOFfzvwfkEkLy3fZx9AWsPMr4ko9+eJIOe6MxvaGSiYqMxjnZkE7hgIXpPBg6LFU30dCTeuZm/Q3dVUiuotA+9rFuCyPWlfMbyxWCpXBZzG7yFDeYaKaXHHVnZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=WsRtBtaE; arc=none smtp.client-ip=136.175.108.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="WsRtBtaE"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta181.mxroute.com (ZoneMTA) with ESMTPSA id 19cd63013b00007228.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 10 Mar 2026 05:20:00 +0000
X-Zone-Loop: 7e277e40ce8ea81aa2b8635cc859c801eb1b8d9f27f5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6zIUSxIBURL9otFwsUlI8yfyXm6/ydJjBezv/6rGcZY=; b=WsRtBtaEC448wQ2+EclbLvnSO4
	q2YsRmRm8X3Sqn8xdYqkQ1RiX5POv7VAqdBXuNVySmfakNSp7tjMt7aW+FEYsrGoizkgIJjKjJxuC
	ozV+idVo9FyZnJLruj7pBaOLAs6+cGgLUDa68dS/TRAK4v5TbtMSYEQdKOelowb9dQznq9l6CQsSw
	QbxafYMAwHpm5QbkYqfa7/lFT92sGaUGnFvyrFIOnUo9q9wathzd8zRH/Jf9F+E3IX5+aEd/AsLf7
	StIv88jC9pznbDDc6ErSgvcGktHvG9nrAYbqKa9NTzOGHD9vXPEDIXc6aznCQ531oQF8ofbBTMUFB
	7/sVobmg==;
From: Su Yue <l@damenly.org>
To: Xiao Ni <xni@redhat.com>
Cc: Yu Kuai <yukuai@fnnas.com>,  song@kernel.org,  linan122@huawei.com,
  colyli@fnnas.com,  linux-raid@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] md: add fallback to correct bitmap_ops on version
 mismatch
In-Reply-To: <cd987627-5255-4d43-918e-a59e2237d188@redhat.com> (Xiao Ni's
	message of "Tue, 10 Mar 2026 09:15:26 +0800")
References: <20260214061013.2335604-1-yukuai@fnnas.com>
	<20260214061013.2335604-4-yukuai@fnnas.com> <h5rf7nsv.fsf@damenly.org>
	<d8598163-f684-4a88-bde7-bef795a3a584@fnnas.com>
	<bjhe7vsu.fsf@damenly.org>
	<cd987627-5255-4d43-918e-a59e2237d188@redhat.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 10 Mar 2026 13:19:40 +0800
Message-ID: <wlzk5kib.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Tue 10 Mar 2026 at 09:15, Xiao Ni <xni@redhat.com> wrote:

> =E5=9C=A8 2026/2/24 09:52, Su Yue =E5=86=99=E9=81=93:
>> On Mon 23 Feb 2026 at 10:22, "Yu Kuai" <yukuai@fnnas.com>=20
>> wrote:
>>
>>> Hi,
>>>
>>> =E5=9C=A8 2026/2/17 16:54, Su Yue =E5=86=99=E9=81=93:
>>>> On Sat 14 Feb 2026 at 14:10, Yu Kuai <yukuai@fnnas.com>=20
>>>> wrote:
>>>>
>>>>> If default bitmap version and on-disk version doesn't match,=20
>>>>> and mdadm
>>>>> is not the latest version to set bitmap_type, set bitmap_ops=20
>>>>> based on
>>>>> the disk version.
>>>>>
>>>> Why not just let old version mdadm fails=C2=A0 since llbitmap is a=20
>>>> new
>>>> feature.
>>>
>>> The original use case is that we found llbitmap array fails to=20
>>> assemble in
>>> some corner cases, and with the respect I'm not quite familiar=20
>>> with mdadm
>>> code, so I think this patch is the best solution for now.
>>>
>> Would you please elaborate which corner cases that llbitmap=20
>> array fails to
>> assemble
>> in? Do they happen in mdadm <=3D 4.5?
>>
>>> On the other hand, this should also be helpful if we decide to=20
>>> make llbitmap
>>> the default option in the future.
>>>
>> But it's so far, right? llbitmap support is still on the=20
>> way(mdadm 4.6 is not
>> released).
>>
>> I am not opposed to the patch. It just looks strange to me that=20
>> changing
>> kernel code to
>> let old userspace work with *new* feature.
>> Maybe the mdadm maintainers have words in another angles?
>
>
> Yes. Is it better to upgrade mdadm to the version which supports=20
> llbitmap?
>

Yes. This's what I mean.

--
Su
>
> Regards
>
> Xiao
>
>>
>> -- Su
>>>
>>>>
>>>>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>>>>> ---
>>>>> =C2=A0drivers/md/md.c | 103=20
>>>>> =C2=A0+++++++++++++++++++++++++++++++++++++++++++++++-
>>>>> =C2=A01 file changed, 102 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>> index 59cd303548de..d2607ed5c2e9 100644
>>>>> --- a/drivers/md/md.c
>>>>> +++ b/drivers/md/md.c
>>>>> @@ -6447,15 +6447,116 @@ static void=20
>>>>> md_safemode_timeout(struct
>>>>> timer_list *t)
>>>>>
>>>>> =C2=A0static int start_dirty_degraded;
>>>>>
>>>>> +/*
>>>>> + * Read bitmap superblock and return the bitmap_id based on=20
>>>>> disk
>>>>> version.
>>>>> + * This is used as fallback when default bitmap version and=20
>>>>> on-disk
>>>>> version
>>>>> + * doesn't match, and mdadm is not the latest version to=20
>>>>> set
>>>>> bitmap_type.
>>>>> + */
>>>>> +static enum md_submodule_id md_bitmap_get_id_from_sb(struct=20
>>>>> mddev
>>>>> *mddev)
>>>>> +{
>>>>> +=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev;
>>>>> +=C2=A0=C2=A0=C2=A0 struct page *sb_page;
>>>>> +=C2=A0=C2=A0=C2=A0 bitmap_super_t *sb;
>>>>> +=C2=A0=C2=A0=C2=A0 enum md_submodule_id id =3D ID_BITMAP_NONE;
>>>>> +=C2=A0=C2=A0=C2=A0 sector_t sector;
>>>>> +=C2=A0=C2=A0=C2=A0 u32 version;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 if (!mddev->bitmap_info.offset)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ID_BITMAP_NONE;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 sb_page =3D alloc_page(GFP_KERNEL);
>>>>> +=C2=A0=C2=A0=C2=A0 if (!sb_page)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ID_BITMAP_NONE;
>>>>> +
>>>>>
>>>> Personally I don't like the way treating error as=20
>>>> ID_BITMAP_NONE.
>>>> When wrong things happen everything looks fine, no error=20
>>>> code, no
>>>> error message.
>>>
>>> Ok, sounds reasonable.
>>>
>>>>
>>>>> +=C2=A0=C2=A0=C2=A0 sector =3D mddev->bitmap_info.offset;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 rdev_for_each(rdev, mddev) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 iosize;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!test_bit(In_sync, &r=
dev->flags) ||
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 t=
est_bit(Faulty, &rdev->flags) ||
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 t=
est_bit(Bitmap_sync, &rdev->flags))
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
ontinue;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iosize =3D roundup(sizeof=
(bitmap_super_t),
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bdev_logical_block_size(rdev->bdev));
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sync_page_io(rdev, se=
ctor, iosize, sb_page,=20
>>>>> REQ_OP_READ,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 true))
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 g=
oto read_ok;
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>
>>>> And here.
>>>>
>>>>> +=C2=A0=C2=A0=C2=A0 goto out;
>>>>> +
>>>>> +read_ok:
>>>>> +=C2=A0=C2=A0=C2=A0 sb =3D kmap_local_page(sb_page);
>>>>> +=C2=A0=C2=A0=C2=A0 if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC))
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_unmap;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 version =3D le32_to_cpu(sb->version);
>>>>> +=C2=A0=C2=A0=C2=A0 switch (version) {
>>>>> +=C2=A0=C2=A0=C2=A0 case BITMAP_MAJOR_LO:
>>>>> +=C2=A0=C2=A0=C2=A0 case BITMAP_MAJOR_HI:
>>>>> +=C2=A0=C2=A0=C2=A0 case BITMAP_MAJOR_CLUSTERED:
>>>>>
>>>> For BITMAP_MAJOR_CLUSTERED, why not ID_CLUSTER ?
>>>
>>> Because there is no optional bitmap_ops for md-cluster, it's=20
>>> still
>>> the old bitmap, and llbitmap does not support md-cluster for=20
>>> now.
>>>
>>>>
>>>> -- Su
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 id =3D ID_BITMAP;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>> +=C2=A0=C2=A0=C2=A0 case BITMAP_MAJOR_LOCKLESS:
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 id =3D ID_LLBITMAP;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>> +=C2=A0=C2=A0=C2=A0 default:
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_warn("md: %s: unknown =
bitmap version %u\n",
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 m=
dname(mddev), version);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +
>>>>> +out_unmap:
>>>>> +=C2=A0=C2=A0=C2=A0 kunmap_local(sb);
>>>>> +out:
>>>>> +=C2=A0=C2=A0=C2=A0 __free_page(sb_page);
>>>>> +=C2=A0=C2=A0=C2=A0 return id;
>>>>> +}
>>>>> +
>>>>> =C2=A0static int md_bitmap_create(struct mddev *mddev)
>>>>> =C2=A0{
>>>>> +=C2=A0=C2=A0=C2=A0 enum md_submodule_id orig_id =3D mddev->bitmap_id;
>>>>> +=C2=A0=C2=A0=C2=A0 enum md_submodule_id sb_id;
>>>>> +=C2=A0=C2=A0=C2=A0 int err;
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (!mddev_set_bitmap_ops(mddev))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOENT;
>>>>>
>>>>> -=C2=A0=C2=A0=C2=A0 return mddev->bitmap_ops->create(mddev);
>>>>> +=C2=A0=C2=A0=C2=A0 err =3D mddev->bitmap_ops->create(mddev);
>>>>> +=C2=A0=C2=A0=C2=A0 if (!err)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>>>
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Create failed, if default bitmap version =
and on-disk=20
>>>>> version
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * doesn't match, and mdadm is not the lates=
t version=20
>>>>> to set
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * bitmap_type, set bitmap_ops based on the =
disk=20
>>>>> version.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +=C2=A0=C2=A0=C2=A0 mddev_clear_bitmap_ops(mddev);
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 sb_id =3D md_bitmap_get_id_from_sb(mddev);
>>>>> +=C2=A0=C2=A0=C2=A0 if (sb_id =3D=3D ID_BITMAP_NONE || sb_id =3D=3D o=
rig_id)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 pr_info("md: %s: bitmap version mismatch, switchi=
ng=20
>>>>> from %d to
>>>>> %d\n",
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdname(mddev), orig_id, s=
b_id);
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 mddev->bitmap_id =3D sb_id;
>>>>> +=C2=A0=C2=A0=C2=A0 if (!mddev_set_bitmap_ops(mddev)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_id =3D orig=
_id;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOENT;
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 err =3D mddev->bitmap_ops->create(mddev);
>>>>> +=C2=A0=C2=A0=C2=A0 if (err) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev_clear_bitmap_ops(md=
dev);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_id =3D orig=
_id;
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 return err;
>>>>> =C2=A0}
>>>>>
>>>>> =C2=A0static void md_bitmap_destroy(struct mddev *mddev)
>>
