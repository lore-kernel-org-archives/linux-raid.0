Received: from sg-1-18.ptr.blmpb.com (sg-1-18.ptr.blmpb.com [118.26.132.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA86263F2D
	for <linux-raid@vger.kernel.org>; Thu,  6 Nov 2025 03:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762400706; cv=none; b=Jrcs8EMhUQmF5dJUe5H6y/85CUBtIvzs18v+JQSXGDlQ1VdNWykaAUKlbt61n+RPAilkGowdGsPjs2bcvYszC8j1UoHy41B/fixaSbzSSzK2vKO78Nuw76oVbZoqb2P0/hfEyd2Wtphk0GQr4uceKTVi+PpserNciYY6Ugi4ykE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762400706; c=relaxed/simple;
	bh=Do+sv32JRcqdfksgmI5pdC8DcgydpqdBgIxqCojJvc4=;
	h=Cc:From:Mime-Version:Content-Type:To:Subject:Date:In-Reply-To:
	 Message-Id:References; b=o2uiD2YDcJa/IYPeOJud6BjvAxHD1siZy0GdpoEawqyYC00POZUQBHZ+TNLA2n53/aE0dL6oqK5wPzgCpDzsplyQteiXEJ5lcK6/eaDhT816fM3JgIHQ1GA5sSXg8Fy/PTTBGpbMrXr0BeLsiFsTAjo2Z9NWYDeIEhE3zLPT5lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=I6EoVb+t; arc=none smtp.client-ip=118.26.132.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="I6EoVb+t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762400696;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=EiW9nRHb8Mbz7qGQdlY2Kw3uUegK7QOWWArHXK3yj70=;
 b=I6EoVb+tqogX+QqsIKVz9yjRExPq8/IAr/KauQblSIO4r8ZA1DQVO7lFsUnlmRrApQu5va
 wdTY7irJZG+QrUwQ1kL4voYaI1ESewX9DvHeXTDaqFD9TWaiZsAYi2VrfClmFe+D4UI7XX
 +Iq55N8oHDNdcIsGEC4XSCBeNoUikbHnnDhSeoO8N8ifkhr4Z8WIX4P92kkd5jGyZ9aHmK
 ORWViumUtMUW5VOfLeY2U81mzJCCbTtERgNVPqTvX9TchuS+ld2XFxxcT1Tr3LPP4eMXv0
 OFMWqAny1lNt8Z1v88l7Jt48XYFB7EfSqL28GzBotGEEObigX2s81yyzqU6THw==
Cc: <corbet@lwn.net>, <song@kernel.org>, <hare@suse.de>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 06 Nov 2025 11:44:53 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2690c19b6+3e32cb+vger.kernel.org+yukuai@fnnas.com>
To: "Xiao Ni" <xni@redhat.com>, "Li Nan" <linan666@huaweicloud.com>
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
Date: Thu, 6 Nov 2025 11:44:51 +0800
In-Reply-To: <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Message-Id: <2c1ab8fc-99ac-44fd-892c-2eeedb9581f4@fnnas.com>
Content-Transfer-Encoding: quoted-printable
References: <20251103125757.1405796-1-linan666@huaweicloud.com> <20251103125757.1405796-5-linan666@huaweicloud.com> <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com> <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com> <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com>

Hi,

=E5=9C=A8 2025/11/4 15:17, Xiao Ni =E5=86=99=E9=81=93:
> On Tue, Nov 4, 2025 at 10:52=E2=80=AFAM Li Nan <linan666@huaweicloud.com>=
 wrote:
>>
>>
>> =E5=9C=A8 2025/11/4 9:47, Xiao Ni =E5=86=99=E9=81=93:
>>> On Mon, Nov 3, 2025 at 9:06=E2=80=AFPM <linan666@huaweicloud.com> wrote=
:
>>>> From: Li Nan <linan122@huawei.com>
>>>>
>>>> Raid checks if pad3 is zero when loading superblock from disk. Arrays
>>>> created with new features may fail to assemble on old kernels as pad3
>>>> is used.
>>>>
>>>> Add module parameter check_new_feature to bypass this check.
>>>>
>>>> Signed-off-by: Li Nan <linan122@huawei.com>
>>>> ---
>>>>    drivers/md/md.c | 12 +++++++++---
>>>>    1 file changed, 9 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index dffc6a482181..5921fb245bfa 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -339,6 +339,7 @@ static int start_readonly;
>>>>     */
>>>>    static bool create_on_open =3D true;
>>>>    static bool legacy_async_del_gendisk =3D true;
>>>> +static bool check_new_feature =3D true;
>>>>
>>>>    /*
>>>>     * We have a system wide 'event count' that is incremented
>>>> @@ -1850,9 +1851,13 @@ static int super_1_load(struct md_rdev *rdev, s=
truct md_rdev *refdev, int minor_
>>>>           }
>>>>           if (sb->pad0 ||
>>>>               sb->pad3[0] ||
>>>> -           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb-=
>pad3[1])))
>>>> -               /* Some padding is non-zero, might be a new feature */
>>>> -               return -EINVAL;
>>>> +           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb-=
>pad3[1]))) {
>>>> +               pr_warn("Some padding is non-zero on %pg, might be a n=
ew feature\n",
>>>> +                       rdev->bdev);
>>>> +               if (check_new_feature)
>>>> +                       return -EINVAL;
>>>> +               pr_warn("check_new_feature is disabled, data corruptio=
n possible\n");
>>>> +       }
>>>>
>>>>           rdev->preferred_minor =3D 0xffff;
>>>>           rdev->data_offset =3D le64_to_cpu(sb->data_offset);
>>>> @@ -10704,6 +10709,7 @@ module_param(start_dirty_degraded, int, S_IRUG=
O|S_IWUSR);
>>>>    module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
>>>>    module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
>>>>    module_param(legacy_async_del_gendisk, bool, 0600);
>>>> +module_param(check_new_feature, bool, 0600);
>>>>
>>>>    MODULE_LICENSE("GPL");
>>>>    MODULE_DESCRIPTION("MD RAID framework");
>>>> --
>>>> 2.39.2
>>>>
>>> Hi
>>>
>>> Thanks for finding this problem in time. The default of this kernel
>>> module is true. I don't think people can check new kernel modules
>>> after updating to a new kernel. They will find the array can't
>>> assemble and report bugs. You already use pad3, is it good to remove
>>> the check about pad3 directly here?
>>>
>>> By the way, have you run the regression tests?
>>>
>>> Regards
>>> Xiao
>>>
>>>
>>> .
>> Hi Xiao.
>>
>> Thanks for your review.
>>
>> Deleting this check directly is risky. For example, in configurable LBS:
>> if user sets LBS to 4K, the LBS of a RAID array assembled on old kernel
>> becomes 512. Forcing use of this array then risks data loss -- the
>> original issue this feature want to solve.
> You're right, we can't delete the check.
> For the old kernel, the array which has specified logical size can't
> be assembled. This patch still can't fix this problem, because it is
> an old kernel and this patch is for a new kernel, right?
> For existing arrays, they don't have such problems. They can be
> assembled after updating to a new kernel.
> So, do we need this patch?

There is a use case for us that user may create the array with old kernel, =
and
then if something bad happened in the system(may not be related to the arra=
y),
user may update to mainline releases and later switch back to our release. =
We
want a solution that user can still use the array in this case.

>
>> Future features may also have similar risks, so instead of deleting this
>> check directly, I chose to add a module parameter to give users a choice=
.
>> What do you think?
> Maybe we can add a feature bit to avoid the kernel parameter. This
> feature bit can be set when specifying logical block size.

The situation still stand, for unknown feature bit, we'd better to forbid
assembling the array to prevent data loss by default.

Thanks,
Kuai

>
> Regards
> Xiao
>> --
>> Thanks,
>> Nan
>>
