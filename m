Received: from mail-108-mta221.mxroute.com (mail-108-mta221.mxroute.com [136.175.108.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50D63AEF53
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776076105; cv=none; b=uNkxG7u/IDdpWW+7PfuCeQAjQw7yhCUnuS+CjlPB64+YDFRx5/vECh+rjorUtLSjv0kTlQlyzoq8ZX6G/sHDTkS2Z+ebKhWxtw4PuaOOe6U6+lmkJdDbRYNGYVqvlrmTpzmVOpxcBPrhPScDuvGL1d86RBRJMGhlOZm8zE/kVAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776076105; c=relaxed/simple;
	bh=qadKiNvjcu5YyTTMIdz4HYxnXbz38vhmcstYZiIR/lU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IWMy1lJTQ7jH9PTfg19UM/MM61VOgDCh7DsYd9l5SNEQAHUhm3vtrCg9nSGN5kaHixDLH7TvBCFUJQOL5V8SjJKFLoh0fxdUn/c42Hw7q43V9oInpO8+V2GudUDuTbMZEvLrnVuARy3kOAWpQoK3pagn7yIBJbpyaYDZohOWti8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=gyFYWVfa; arc=none smtp.client-ip=136.175.108.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="gyFYWVfa"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta221.mxroute.com (ZoneMTA) with ESMTPSA id 19d865dde4200132bf.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 13 Apr 2026 10:23:11 +0000
X-Zone-Loop: e6d81b0f64ab013a9c4ba33d6bc50bc07470afcdd894
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c3ZrXaYN8m2i3o7+hbJgKaCfBttd90Oi1o9hncFKgjU=; b=gyFYWVfaMisGRVWRXSPFwO/ycK
	9kenDOBAuY3jYt1ihoJzqeq6MxeANzC/6W60n7hyhimDOvSB3i0JCzICeQbA95XjLkjbegu/FzUNg
	BWdmysIWJNeoSYEaYopJO2zVm6bOvU1UqljkhsyoBYbW9yy7q5wDvpfPw1mnvPakLmOL+ct2JO5Pr
	Tge6v4r97L8bAx9S+JUuM6NeSlf66CgX3rTEsct/jPWaPkNQPMSlV+vngs3QCgDSHDkfUUrg0ulM6
	P/ORG9VTVIlbzUVUF+UapixUd1/QrQ1EoP9W9dGBL1vZm3ifxwf98l0IZ+tfBGA0t6b7uJ5OibYeL
	MYTPbnHQ==;
From: Su Yue <l@damenly.org>
To: Li Nan <linan666@huaweicloud.com>
Cc: Su Yue <glass.su@suse.com>,  linux-raid@vger.kernel.org,
  song@kernel.org,  xni@redhat.com,  yukuai@fnnas.com,
  heming.zhao@suse.com
Subject: Re: [PATCH v2 4/5] md: skip ID_BITMAP_NONE when show available
 bitmap types
In-Reply-To: <4be300df-3943-acf3-ace1-cf6316f2c936@huaweicloud.com> (Li Nan's
	message of "Mon, 13 Apr 2026 16:15:05 +0800")
References: <20260407102625.5686-1-glass.su@suse.com>
	<20260407102625.5686-5-glass.su@suse.com>
	<4be300df-3943-acf3-ace1-cf6316f2c936@huaweicloud.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Mon, 13 Apr 2026 18:23:03 +0800
Message-ID: <tstf88hk.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Mon 13 Apr 2026 at 16:15, Li Nan <linan666@huaweicloud.com>=20
wrote:

> =E5=9C=A8 2026/4/7 18:26, Su Yue =E5=86=99=E9=81=93:
>> As none_bitmap_ops is introduced, ID_BITMAP_NONE should be=20
>> skipped while
>> iterating md submodules, otherwise:
>> $ cat /sys/block/md0/md/bitmap_type
>> [none] bitmap llbitmap [none]
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>   drivers/md/md.c | 2 ++
>>   1 file changed, 2 insertions(+)
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 55a95b227b83..20a953676319 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4269,6 +4269,8 @@ bitmap_type_show(struct mddev *mddev,=20
>> char *page)
>>   	xa_for_each(&md_submodule, i, head) {
>>   		if (head->type !=3D MD_BITMAP)
>>   			continue;
>> +		if (head->id =3D=3D ID_BITMAP_NONE)
>> +			continue;
>>     		if (mddev->bitmap_id =3D=3D head->id)
>>   			len +=3D sprintf(page + len, "[%s] ", head->name);
>
> If we indeed add ID_BITMAP_NONE as patch 3, would it be better=20
> to delete
> this piece of code instead?
>
I dont' think so. There is one case CONFIG_MD_BITMAP is not=20
enabled which
means register_md_submodule(&none_bitmap_ops.head) is not called=20
but in
mddev_init():

int mddev_init(struct mddev *mddev)=20
|
 {=20
 |
         int err =3D 0;=20
         |
                                                                           =
      |
         if (!IS_ENABLED(CONFIG_MD_BITMAP))=20
         |
                 mddev->bitmap_id =3D ID_BITMAP_NONE;
...
}

--
Su
>
>         if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>                 len +=3D sprintf(page + len, "[none] ");
>         else
>                 len +=3D sprintf(page + len, "none ");
