Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931EF331A52
	for <linux-raid@vger.kernel.org>; Thu,  6 Nov 2025 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762433353; cv=none; b=a7G+RmrMCSL7X7DhTnDvsfXqoPtj7p8MxU604MZ9cMsz/eqs4Y6ysSTJfzitCAUEfGq/tM5TPgY8zeHVKwty58+ul9u8qo18QYRwPm0bNKXXadGsBHqRhGTg3COO83vEKyIkEIL/jZNw0qG6KO9KMrUtbWJuLPtu/tE47MFK69A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762433353; c=relaxed/simple;
	bh=GKXbji7k05YppF65+qHELPqY1emyl1XkYE/dO1Ao37o=;
	h=Date:In-Reply-To:Cc:From:References:Message-Id:Mime-Version:
	 Content-Type:To:Subject; b=SzGe2YMWBEecC0NTZe34CViF4JNQRyJalK9Q4EU2dczzp+5AYO+SuvJ5XCy9Ju9KwN82xow/FqrtDKD4ox0PlmYdYTKu0gL7nMqCQb0z2sY4Th1hUwDPP20TBIFQsmm13CMxrCjFIPtKLbFnM+92VNtFdAlD0UdlP4Kb0oP1YmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=JYOVOvsl; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="JYOVOvsl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762433341;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2cL2TYe+qhVX+jnRJHpmMecoGm9Nq2zKGwJMjDndggY=;
 b=JYOVOvslSSUJ1b8ASox2v7Dfs5iBjuXZuSHACMw7hn8UH9flRwBON7O7rTe6zdikqWipcD
 rDNJlUmYPp7je1wTPlcWV02VSduN1hcYB39DreFpHuvHXIm6FfKHMISSQVaRa9Le0GA2PP
 l7S9V63UkaR/ozuPWVXJn3lEkTjjz0cCNrxuzH0h8/1njqzMNSL/+Mhni46ItnqCK9q1H0
 HHH3P9StcqUfg5CB0ceXTvCzhDfzT0n5ilNyjljOaECpZ/YKWo3+4nijkIxw0bmnbCQoqR
 FoalISnFf8bGSele9k9MyydWLv6/tlALoRxq0nBspcE5vVkaBFKclkZkOQDYSA==
Date: Thu, 6 Nov 2025 20:48:55 +0800
In-Reply-To: <CALTww289ZzZP5TmD5qezaYZV0Mnb90abqMqR=OnAzRz3NkmhQQ@mail.gmail.com>
Cc: "Li Nan" <linan666@huaweicloud.com>, <corbet@lwn.net>, <song@kernel.org>, 
	<hare@suse.de>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
References: <20251103125757.1405796-1-linan666@huaweicloud.com> <20251103125757.1405796-5-linan666@huaweicloud.com> <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com> <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com> <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com> <2c1ab8fc-99ac-44fd-892c-2eeedb9581f4@fnnas.com> <CALTww289ZzZP5TmD5qezaYZV0Mnb90abqMqR=OnAzRz3NkmhQQ@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 06 Nov 2025 20:48:58 +0800
Reply-To: yukuai@fnnas.com
Message-Id: <5396ce6f-ba67-4f5e-86dc-3c9aebb6dc20@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+2690c993b+68151b+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: "Xiao Ni" <xni@redhat.com>
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter

Hi,

=E5=9C=A8 2025/11/6 20:35, Xiao Ni =E5=86=99=E9=81=93:
> On Thu, Nov 6, 2025 at 11:45=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>> Hi,
>>
>> =E5=9C=A8 2025/11/4 15:17, Xiao Ni =E5=86=99=E9=81=93:
>>> On Tue, Nov 4, 2025 at 10:52=E2=80=AFAM Li Nan <linan666@huaweicloud.co=
m> wrote:
>>>>
>>>> =E5=9C=A8 2025/11/4 9:47, Xiao Ni =E5=86=99=E9=81=93:
>>>>> On Mon, Nov 3, 2025 at 9:06=E2=80=AFPM <linan666@huaweicloud.com> wro=
te:
>>>>>> From: Li Nan <linan122@huawei.com>
>>>>>>
>>>>>> Raid checks if pad3 is zero when loading superblock from disk. Array=
s
>>>>>> created with new features may fail to assemble on old kernels as pad=
3
>>>>>> is used.
>>>>>>
>>>>>> Add module parameter check_new_feature to bypass this check.
>>>>>>
>>>>>> Signed-off-by: Li Nan <linan122@huawei.com>
>>>>>> ---
>>>>>>     drivers/md/md.c | 12 +++++++++---
>>>>>>     1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>>> index dffc6a482181..5921fb245bfa 100644
>>>>>> --- a/drivers/md/md.c
>>>>>> +++ b/drivers/md/md.c
>>>>>> @@ -339,6 +339,7 @@ static int start_readonly;
>>>>>>      */
>>>>>>     static bool create_on_open =3D true;
>>>>>>     static bool legacy_async_del_gendisk =3D true;
>>>>>> +static bool check_new_feature =3D true;
>>>>>>
>>>>>>     /*
>>>>>>      * We have a system wide 'event count' that is incremented
>>>>>> @@ -1850,9 +1851,13 @@ static int super_1_load(struct md_rdev *rdev,=
 struct md_rdev *refdev, int minor_
>>>>>>            }
>>>>>>            if (sb->pad0 ||
>>>>>>                sb->pad3[0] ||
>>>>>> -           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(s=
b->pad3[1])))
>>>>>> -               /* Some padding is non-zero, might be a new feature =
*/
>>>>>> -               return -EINVAL;
>>>>>> +           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(s=
b->pad3[1]))) {
>>>>>> +               pr_warn("Some padding is non-zero on %pg, might be a=
 new feature\n",
>>>>>> +                       rdev->bdev);
>>>>>> +               if (check_new_feature)
>>>>>> +                       return -EINVAL;
>>>>>> +               pr_warn("check_new_feature is disabled, data corrupt=
ion possible\n");
>>>>>> +       }
>>>>>>
>>>>>>            rdev->preferred_minor =3D 0xffff;
>>>>>>            rdev->data_offset =3D le64_to_cpu(sb->data_offset);
>>>>>> @@ -10704,6 +10709,7 @@ module_param(start_dirty_degraded, int, S_IR=
UGO|S_IWUSR);
>>>>>>     module_param_call(new_array, add_named_array, NULL, NULL, S_IWUS=
R);
>>>>>>     module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
>>>>>>     module_param(legacy_async_del_gendisk, bool, 0600);
>>>>>> +module_param(check_new_feature, bool, 0600);
>>>>>>
>>>>>>     MODULE_LICENSE("GPL");
>>>>>>     MODULE_DESCRIPTION("MD RAID framework");
>>>>>> --
>>>>>> 2.39.2
>>>>>>
>>>>> Hi
>>>>>
>>>>> Thanks for finding this problem in time. The default of this kernel
>>>>> module is true. I don't think people can check new kernel modules
>>>>> after updating to a new kernel. They will find the array can't
>>>>> assemble and report bugs. You already use pad3, is it good to remove
>>>>> the check about pad3 directly here?
>>>>>
>>>>> By the way, have you run the regression tests?
>>>>>
>>>>> Regards
>>>>> Xiao
>>>>>
>>>>>
>>>>> .
>>>> Hi Xiao.
>>>>
>>>> Thanks for your review.
>>>>
>>>> Deleting this check directly is risky. For example, in configurable LB=
S:
>>>> if user sets LBS to 4K, the LBS of a RAID array assembled on old kerne=
l
>>>> becomes 512. Forcing use of this array then risks data loss -- the
>>>> original issue this feature want to solve.
>>> You're right, we can't delete the check.
>>> For the old kernel, the array which has specified logical size can't
>>> be assembled. This patch still can't fix this problem, because it is
>>> an old kernel and this patch is for a new kernel, right?
>>> For existing arrays, they don't have such problems. They can be
>>> assembled after updating to a new kernel.
>>> So, do we need this patch?
>> There is a use case for us that user may create the array with old kerne=
l, and
>> then if something bad happened in the system(may not be related to the a=
rray),
>> user may update to mainline releases and later switch back to our releas=
e. We
>> want a solution that user can still use the array in this case.
> Hi all
>
> Let me check if I understand right:
> 1. a machine with an old kernel has problems
> 2. update to new kernel which has new feature
> 3. create an array with new kernel
> 4. switch back to the old kernel, so assemble fails because sb->pad3
> is used and not zero.
>
> The old kernel is right to do so. This should be expected, right?

Not quite what I mean, for example
1. old kernel create an array md0;
2. something bad happened(not related to md0), for example, file system fro=
m other device crashed, or another array can't assembled;
3. user might update to new kernel and try to copy data, however, md0 will =
be assembled and sb->pad3 will be set;
4. user switch back to old kernel, the md0 assemble failed and can't not be=
 used in old kernel anymore.

>
>>>> Future features may also have similar risks, so instead of deleting th=
is
>>>> check directly, I chose to add a module parameter to give users a choi=
ce.
>>>> What do you think?
>>> Maybe we can add a feature bit to avoid the kernel parameter. This
>>> feature bit can be set when specifying logical block size.
>> The situation still stand, for unknown feature bit, we'd better to forbi=
d
>> assembling the array to prevent data loss by default.
> If I understand correctly, the old kernel already refuses to assemble it.

The problem is that if array is created from old kernel, and user still
want to use it in the old kernel, then the user can't assemble this array
in new kernel. However, this is real use case for us :(

> Regards
> Xiao
>
>> Thanks,
>> Kuai
>>
>>> Regards
>>> Xiao
>>>> --
>>>> Thanks,
>>>> Nan
>>>>
