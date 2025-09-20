Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077701C700C;
	Sat, 20 Sep 2025 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758362060; cv=pass; b=poFrLeItptevLb0mVKKXh1+2d1EC8YUtPvjPP2Ldorau7UZSouutGnGZy0vmDkPPe8oYqairMO019LleB/x/9sAY3jT78XZkHciXKHm27eOo8Wf2ApS1MU9GHZ7dXQO6Vtk9f+jOH5QK9Z/wUxkKcA6lln7KG9jqQF4qQ/tp7us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758362060; c=relaxed/simple;
	bh=zVox/WXFR5JOOCLeL2a/J1BlFB6BgvlHgpY3ZZNyptI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lJJJnRqxvVMv1Pzps2ISKv3Tiw23OM+3EbjZBxmJLE5fBz7RVjh2FSaCFWBLK7QXgSu6fW+fAR+OmQgwEhtPCPNF0uJZNQ+MU9mN/8QPyNMshWCR259/5gI2DO2mLwUHVjH1nEIJ5/8ciySTIZEWckZFZiKcJTHeDe8RWqcAhPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=XVqn+LOo; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="XVqn+LOo"
ARC-Seal: i=1; a=rsa-sha256; t=1758361918; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=jJXcSyISrslfI26hBoCsSEzh++WfQXnzkKqvI7lnWwwTQCPFlPq8hoBL03RrmfRY0LShkrGwyDhCsj3wXmT1TCFNq4U0/Qf9aNsNr8qEPCfRe9RVCUolk1Z/yVtaxhVzpvxKyz/C9arrLKxX6AltWqyeZtUy1nMkDbdjkW53tZk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1758361918; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=t4p8/YJOx2NEhHJ8IcJih7ZOSEtWMbTmNK5ISMXjmDo=; 
	b=YsuK1nfQjMH1PE1c7Z5htZW8Ajsq3OqxEFFBN5wDjSM9K8Z1oPYmOnZMrDrYBN1G8Z8pndikTixQS6yuD86pK82KngZpEQts70wEFNo1WwplCxMrLGfNVP+tVSybpQ00gIgqUTIuAxmk9uWZqNIiYT3iKdfhoYYiB03OM8xqoNE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1758361918;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=t4p8/YJOx2NEhHJ8IcJih7ZOSEtWMbTmNK5ISMXjmDo=;
	b=XVqn+LOoiCszudQuTJs6vZtEvKAVrRRpTPSNFeZ6oGXCrqeVxtGZvt2MzqgqCwB7
	UPGFfUtfSEPuL7mfpf58tQCbdoO5JgLaMNzWHjYxyaDMdA+p/MLZA6v6BLPpjbF/Mex
	W6BK6KLmGugllUsTBCtYNNSeraYfbRZ2EaPLXw4g=
Received: by mx.zohomail.com with SMTPS id 1758361914670477.56702687582913;
	Sat, 20 Sep 2025 02:51:54 -0700 (PDT)
Message-ID: <0813d9d7-a0be-419b-a067-66854d35373a@yukuai.org.cn>
Date: Sat, 20 Sep 2025 17:51:49 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] md/raid1,raid10: Don't set MD_BROKEN on failfast
 bio failure
To: Kenta Akagi <k@fwd.mgml.me>, Yu Kuai <hailan@yukuai.org.cn>,
 yukuai1@huaweicloud.com, song@kernel.org, mtkaczyk@kernel.org, shli@fb.com,
 jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yukuai3@huawei.com
References: <010601995d6b88a4-423a9b3c-3790-4d65-86a4-20a9ddea0686-000000@ap-northeast-1.amazonses.com>
 <6ce45082-2913-4ca2-b382-5beff6a799c6@yukuai.org.cn>
 <e88ac955-9733-4e57-830b-d326557d189a@fwd.mgml.me>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <e88ac955-9733-4e57-830b-d326557d189a@fwd.mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

在 2025/9/20 14:30, Kenta Akagi 写道:
> Hi,
>
> I have changed my email address because our primary MX server
> suddenly started rejecting non-DKIM mail.
>
> On 2025/09/19 10:36, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/9/18 23:22, Kenta Akagi 写道:
>>>>> @@ -470,7 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>>>>                 (bio->bi_opf & MD_FAILFAST) &&
>>>>>                 /* We never try FailFast to WriteMostly devices */
>>>>>                 !test_bit(WriteMostly, &rdev->flags)) {
>>>>> -            md_error(r1_bio->mddev, rdev);
>>>>> +            md_bio_failure_error(r1_bio->mddev, rdev, bio);
>>>>>             }
>>>> Can following check of faulty replaced with return value?
>>> In the case where raid1_end_write_request is called for a non-failfast IO,
>>> and the rdev has already been marked Faulty by another bio, it must not retry too.
>>> I think it would be simpler not to use a return value here.
>> You can just add Faulty check inside md_bio_failure_error() as well, and both
>> failfast and writemostly check.
> Sorry, I'm not sure I understand this part.
> In raid1_end_write_request, this code path is also used for a regular bio,
> not only for FailFast.
>
> You mean to change md_bio_failure_error as follows:
> * If the rdev is Faulty, immediately return true.
> * If the given bio is Failfast and the rdev is not the lastdev, call md_error.
> * If the given bio is not Failfast, do nothing and return false.

Yes, doesn't that apply to all the callers?

>
> And then apply this?
> This is complicated. Wouldn't it be better to keep the Faulty check as it is?
>
> @@ -466,18 +466,12 @@ static void raid1_end_write_request(struct bio *bio)
>                          set_bit(MD_RECOVERY_NEEDED, &
>                                  conf->mddev->recovery);
>
> -               if (test_bit(FailFast, &rdev->flags) &&
> -                   (bio->bi_opf & MD_FAILFAST) &&
> -                   /* We never try FailFast to WriteMostly devices */
> -                   !test_bit(WriteMostly, &rdev->flags)) {
> -                       md_error(r1_bio->mddev, rdev);
> -               }
> -
>                  /*
>                   * When the device is faulty, it is not necessary to
>                   * handle write error.
>                   */
> -               if (!test_bit(Faulty, &rdev->flags))
> +               if (!test_bit(Faulty, &rdev->flags) ||
> +                   !md_bio_failure_error(r1_bio->mddev, rdev, bio))
>                          set_bit(R1BIO_WriteError, &r1_bio->state);
>                  else {
>                          /* Finished with this branch */

Faulty is set with lock held, so check Faulty with lock held as well can
prevent rdev to be Faulty concurrently, and this check can be added to all
callers, I think.

>
> Or do you mean a fix like this?
>
> @@ -466,23 +466,24 @@ static void raid1_end_write_request(struct bio *bio)
>                          set_bit(MD_RECOVERY_NEEDED, &
>                                  conf->mddev->recovery);
>
> -               if (test_bit(FailFast, &rdev->flags) &&
> -                   (bio->bi_opf & MD_FAILFAST) &&
> -                   /* We never try FailFast to WriteMostly devices */
> -                   !test_bit(WriteMostly, &rdev->flags)) {
> -                       md_error(r1_bio->mddev, rdev);
> -               }
> -
>                  /*
>                   * When the device is faulty, it is not necessary to
>                   * handle write error.
>                   */
> -               if (!test_bit(Faulty, &rdev->flags))
> -                       set_bit(R1BIO_WriteError, &r1_bio->state);
> -               else {
> +               if (test_bit(Faulty, &rdev->flags) ||
> +                   (
> +                   test_bit(FailFast, &rdev->flags) &&
> +                   (bio->bi_opf & MD_FAILFAST) &&
> +                   /* We never try FailFast to WriteMostly devices */
> +                   !test_bit(WriteMostly, &rdev->flags) &&
> +                   md_bio_failure_error(r1_bio->mddev, rdev, bio)
> +                   )
> +               ) {
>                          /* Finished with this branch */
>                          r1_bio->bios[mirror] = NULL;
>                          to_put = bio;
> +               } else {
> +                       set_bit(R1BIO_WriteError, &r1_bio->state);
>                  }
>          } else {
>                  /*

No, this just make code even more unreadable.

Thanks,
Kuai

> Thanks,
> Akagi
>
>> Thanks,
>> Kuai
>>
>>
>>
