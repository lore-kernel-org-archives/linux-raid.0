Received: from mail-108-mta96.mxroute.com (mail-108-mta96.mxroute.com [136.175.108.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489CA20D514
	for <linux-raid@vger.kernel.org>; Wed,  5 Mar 2025 10:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741171968; cv=none; b=da2hGGYrfLZklECKaoc0qekHOxOpwI0AWSNk1VaGJ0uGBLxBHVjR8OizJQkmYYIYId46qwOluDW4YZLLe4kQ/2HvcrXw9kswf3t2P61B8yHubPGXWP+YqhoZKrkeRt/14ebYzUZ0bALqtpP6VQrze4N4O7p7sDNNL1m+RPodFOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741171968; c=relaxed/simple;
	bh=D/gWWnqCmwMIida++PFUgYDYTyXvTrN4kjVdCsSe8pw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jTtr60QZcpx59TDcpgN3GgbpGXyz2U2EGCRE1qkG6dQsbKXjNpeLIXfp5jWbFgkPuk0MaMVWSCmnInKpunocdO3YR64HRWrcI2Jq2FlhRpZkOkIuoXwXb9L88KrvHMJr79cosyFhAM1Zx3QM6/PPbgrb6wrdoaYx091apBHS870=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=FyD+puyu; arc=none smtp.client-ip=136.175.108.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="FyD+puyu"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta96.mxroute.com (ZoneMTA) with ESMTPSA id 19565eb022a000310e.006
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Wed, 05 Mar 2025 10:47:35 +0000
X-Zone-Loop: 2e2aabe8b19eac75119dd00092a0e64a4031d9445859
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TGwaw6zOrXw6HRtH7vpWFRUKw/DUFlBd0I3CNVX+e5k=; b=FyD+puyua6Mv83vwHEv9k5L+uZ
	22ob/8YOSNM1/9fcKkmjaowWQBmdSEUz0KUpGXaIE8N9qy19kmDgQrFYCnJBvfsNA4PjX8FrtoCmX
	oA9fTzSMlZ0kAUXnv3ejLMl3V/XaXXTNgMH1UvpbcUbx7hqK0GHbHtkRoZ01zxKTYqmwvoJ7QxOOw
	GDdyJlcphbmOjvwyRl7C0PR/v7xRAFDuZBIZE5hQKT6A8GcuMTKMLGjRFgPYdSQoiEXO0NSF1anH1
	9cZm3AAeTYDwcl6A5hCaUyTjBAiUvTpx7Zx9xkDuUbq7ZOyp9YOG/HTo6l1congnOg2RF0lShnRCS
	E6NJiAzQ==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Su Yue <glass.su@suse.com>,  linux-raid@vger.kernel.org,  hch@lst.de,
  ofir.gal@volumez.com,  heming.zhao@suse.com,  "yukuai3 >> yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: [PATCH v3] md/md-bitmap: fix wrong bitmap_limit for clustermd
 when write sb
In-Reply-To: <47caca95-7bd9-69d0-6a28-231e0b0f1831@huaweicloud.com> (Yu Kuai's
	message of "Wed, 5 Mar 2025 09:25:40 +0800")
References: <20250303033918.32136-1-glass.su@suse.com>
	<47caca95-7bd9-69d0-6a28-231e0b0f1831@huaweicloud.com>
User-Agent: mu4e 1.12.7; emacs 30.1
Date: Wed, 05 Mar 2025 18:47:28 +0800
Message-ID: <zfhzpxdr.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Wed 05 Mar 2025 at 09:25, Yu Kuai <yukuai1@huaweicloud.com>=20
wrote:

> =E5=9C=A8 2025/03/03 11:39, Su Yue =E5=86=99=E9=81=93:
>> In clustermd, separate write-intent-bitmaps are used for each=20
>> cluster
>> node:
>> 0                    4k                     8k=20
>> 12k
>> -------------------------------------------------------------------
>> | idle                | md super            | bm super [0] +=20
>> bits |
>> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]=20
>> |
>> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] +=20
>> bits  |
>> | bm bits [3, contd]  |                     |=20
>> |
>> So in node 1, pg_index in __write_sb_page() could equal to
>> bitmap->storage.file_pages. Then bitmap_limit will be=20
>> calculated to
>> 0. md_super_write() will be called with 0 size.
>> That means the first 4k sb area of node 1 will never be updated
>> through filemap_write_page().
>> This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.
>> Here use (pg_index % bitmap->storage.file_pages) to make=20
>> calculation
>> of bitmap_limit correct.
>> Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap=20
>> pages")
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>> Changelog:
>> v3:
>>      Amend commit message suggested by Heming.
>> v2:
>>      Remove unintended change calling md_super_write().
>> ---
>>   drivers/md/md-bitmap.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>
> Applied to md-6.15
>
Since it's a bug fix, could you please queue it to 6.14 if the=20
merge window
is still open?

--
Su
> Thanks,
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 23c09d22fcdb..9ae6cc8e30cb 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -426,8 +426,8 @@ static int __write_sb_page(struct md_rdev=20
>> *rdev, struct bitmap *bitmap,
>>   	struct block_device *bdev;
>>   	struct mddev *mddev =3D bitmap->mddev;
>>   	struct bitmap_storage *store =3D &bitmap->storage;
>> -	unsigned int bitmap_limit =3D (bitmap->storage.file_pages -=20
>> pg_index) <<
>> -		PAGE_SHIFT;
>> +	unsigned long num_pages =3D bitmap->storage.file_pages;
>> +	unsigned int bitmap_limit =3D (num_pages - pg_index %=20
>> num_pages) << PAGE_SHIFT;
>>   	loff_t sboff, offset =3D mddev->bitmap_info.offset;
>>   	sector_t ps =3D pg_index * PAGE_SIZE / SECTOR_SIZE;
>>   	unsigned int size =3D PAGE_SIZE;
>> @@ -436,7 +436,7 @@ static int __write_sb_page(struct md_rdev=20
>> *rdev, struct bitmap *bitmap,
>>     	bdev =3D (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>>   	/* we compare length (page numbers), not page offset. */
>> -	if ((pg_index - store->sb_index) =3D=3D store->file_pages - 1)=20
>> {
>> +	if ((pg_index - store->sb_index) =3D=3D num_pages - 1) {
>>   		unsigned int last_page_size =3D store->bytes &=20
>>   (PAGE_SIZE - 1);
>>     		if (last_page_size =3D=3D 0)
>>
