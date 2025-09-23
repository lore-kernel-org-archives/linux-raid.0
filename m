Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742AB261B8F;
	Tue, 23 Sep 2025 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758643386; cv=none; b=Wfk6NAJFSfSrfZbrYJ+jN5itKoGMWRq1IvaKSqlNGRJDteD/cXJhN/NFYEM8jEmrfKd9fe2sAb+m7GGnzM53pyj0mmF9g1jRhm67gIBKvl8W4XtW0AxG957IbUH5KwUAvnzfzsMdbc2uaoptbNtqlA2VxTBDXiqfcu+vszTc1+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758643386; c=relaxed/simple;
	bh=vLOGdTF7+Ao+lLx+LrCuOeAv9i6cbYC906WiQVFjOPk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=brtepBASGdcSVFfO70Zu04uStoOBtRvo79LCQUO7eGLbPNRKTahLRBxz3K7M9voOjXV1dfIq3lZD2DgUntfE/iMQ/2Rvlne73BepBCuKWRgtY6I65kcVxmXtnEnSrlW4OkEY53JxFj9Qf5nAEFLGz2ggqmbznjBerfev/raJrjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fwd.mgml.me; spf=pass smtp.mailfrom=fwd.mgml.me; dkim=pass (2048-bit key) header.d=fwd.mgml.me header.i=@fwd.mgml.me header.b=ZalnO+BT; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fwd.mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fwd.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fwd.mgml.me header.i=@fwd.mgml.me header.b="ZalnO+BT"
Received: from NEET (p3732025-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [153.172.109.25])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58NFsirj056416
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 24 Sep 2025 00:54:44 +0900 (JST)
	(envelope-from k@fwd.mgml.me)
DKIM-Signature: a=rsa-sha256; bh=1P58MihQU86aaurMmACMThCi4OU+oioqc88edmmWJTQ=;
        c=relaxed/relaxed; d=fwd.mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250919; t=1758642884; v=1;
        b=ZalnO+BTF8F2LtEt9Y9qGHR0Ps3Yl2kT3AxBPUJ10JQ0ftWw1iV4LUgcqfX331WS
         hWcrJ6y6TYqp+YCF+s5yAEkzQJlRmgDeBGhPogfkfWDmzrl+3JI8q3kQ7wsk2IOu
         ZuK/fsOSz/DtP6t8IN6Y9nlfZGRPqwhQnfs3cGetp7VxlPUoP5HcFAKK32JziiFD
         NyQJFaISd47M1YNsExp9v5SbjKL7QXfCKVChSBiOlgPamK8vYOJ27IRROitiF1St
         VhEKNGroSdahKaxtR1YK1nEb+XIpaH+EDd1R8+20ph+WznDZV5NzvHKWvajejd4a
         tYYoRJHNorlkuse/ek5MxQ==
Message-ID: <d0de7500-eac0-4d02-9b48-887cdefab4c1@fwd.mgml.me>
Date: Wed, 24 Sep 2025 00:54:44 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, Kenta Akagi <k@fwd.mgml.me>
Subject: Re: [PATCH v4 4/9] md/raid1,raid10: Don't set MD_BROKEN on failfast
 bio failure
To: Yu Kuai <hailan@yukuai.org.cn>, yukuai1@huaweicloud.com, song@kernel.org,
        mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
References: <010601995d6b88a4-423a9b3c-3790-4d65-86a4-20a9ddea0686-000000@ap-northeast-1.amazonses.com>
 <6ce45082-2913-4ca2-b382-5beff6a799c6@yukuai.org.cn>
 <e88ac955-9733-4e57-830b-d326557d189a@fwd.mgml.me>
 <0813d9d7-a0be-419b-a067-66854d35373a@yukuai.org.cn>
Content-Language: en-US
From: Kenta Akagi <k@fwd.mgml.me>
In-Reply-To: <0813d9d7-a0be-419b-a067-66854d35373a@yukuai.org.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 2025/09/20 18:51, Yu Kuai wrote:
> Hi,
> 
> 在 2025/9/20 14:30, Kenta Akagi 写道:
>> Hi,
>>
>> I have changed my email address because our primary MX server
>> suddenly started rejecting non-DKIM mail.
>>
>> On 2025/09/19 10:36, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2025/9/18 23:22, Kenta Akagi 写道:
>>>>>> @@ -470,7 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>>>>>                 (bio->bi_opf & MD_FAILFAST) &&
>>>>>>                 /* We never try FailFast to WriteMostly devices */
>>>>>>                 !test_bit(WriteMostly, &rdev->flags)) {
>>>>>> -            md_error(r1_bio->mddev, rdev);
>>>>>> +            md_bio_failure_error(r1_bio->mddev, rdev, bio);
>>>>>>             }
>>>>> Can following check of faulty replaced with return value?
>>>> In the case where raid1_end_write_request is called for a non-failfast IO,
>>>> and the rdev has already been marked Faulty by another bio, it must not retry too.
>>>> I think it would be simpler not to use a return value here.
>>> You can just add Faulty check inside md_bio_failure_error() as well, and both
>>> failfast and writemostly check.
>> Sorry, I'm not sure I understand this part.
>> In raid1_end_write_request, this code path is also used for a regular bio,
>> not only for FailFast.
>>
>> You mean to change md_bio_failure_error as follows:
>> * If the rdev is Faulty, immediately return true.
>> * If the given bio is Failfast and the rdev is not the lastdev, call md_error.
>> * If the given bio is not Failfast, do nothing and return false.
> 
> Yes, doesn't that apply to all the callers?

It's difficult because the flow differs depending on the function. 
For example, in raid1_end_write_request, if rdev and bio are Failfast but not Writemostly,
it calls md_error, and then performs a something if it is Faulty regardless
of whether it is Failfast or not. This flow is specific to raid1_end_write_request.

Other functions that need to be changed to md_bio_failure_error are handle_read_error
and fix_sync_read_error, but the path for determining whether these are Faulty,
regardless of whether they are Failfast, is not exists there functions.

It may be possible with some refactoring,
but I think raid1_end_write_request current style, that is
if(Failfast) md_bio_failure_error();
if(Faulty) something;
would be better because We can see at a glance what is happening.

BTW, fix_sync_read_error can use the return value of md_bio_failure_error as
suggested. so I'll revise it as follows:

@@ -2167,8 +2174,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
        if (test_bit(FailFast, &rdev->flags)) {
                /* Don't try recovering from here - just fail it
                 * ... unless it is the last working device of course */
-               md_bio_failure_error(mddev, rdev, bio);
-               if (test_bit(Faulty, &rdev->flags))
+               if (md_bio_failure_error(mddev, rdev, bio))
                        /* Don't try to read from here, but make sure
                         * put_buf does it's thing
                         */

> 
>>
>> And then apply this?
>> This is complicated. Wouldn't it be better to keep the Faulty check as it is?
>>
>> @@ -466,18 +466,12 @@ static void raid1_end_write_request(struct bio *bio)
>>                          set_bit(MD_RECOVERY_NEEDED, &
>>                                  conf->mddev->recovery);
>>
>> -               if (test_bit(FailFast, &rdev->flags) &&
>> -                   (bio->bi_opf & MD_FAILFAST) &&
>> -                   /* We never try FailFast to WriteMostly devices */
>> -                   !test_bit(WriteMostly, &rdev->flags)) {
>> -                       md_error(r1_bio->mddev, rdev);
>> -               }
>> -
>>                  /*
>>                   * When the device is faulty, it is not necessary to
>>                   * handle write error.
>>                   */
>> -               if (!test_bit(Faulty, &rdev->flags))
>> +               if (!test_bit(Faulty, &rdev->flags) ||
>> +                   !md_bio_failure_error(r1_bio->mddev, rdev, bio))
>>                          set_bit(R1BIO_WriteError, &r1_bio->state);
>>                  else {
>>                          /* Finished with this branch */
> 
> Faulty is set with lock held, so check Faulty with lock held as well can
> prevent rdev to be Faulty concurrently, and this check can be added to all
> callers, I think.
> 
>>
>> Or do you mean a fix like this?
>>
>> @@ -466,23 +466,24 @@ static void raid1_end_write_request(struct bio *bio)
>>                          set_bit(MD_RECOVERY_NEEDED, &
>>                                  conf->mddev->recovery);
>>
>> -               if (test_bit(FailFast, &rdev->flags) &&
>> -                   (bio->bi_opf & MD_FAILFAST) &&
>> -                   /* We never try FailFast to WriteMostly devices */
>> -                   !test_bit(WriteMostly, &rdev->flags)) {
>> -                       md_error(r1_bio->mddev, rdev);
>> -               }
>> -
>>                  /*
>>                   * When the device is faulty, it is not necessary to
>>                   * handle write error.
>>                   */
>> -               if (!test_bit(Faulty, &rdev->flags))
>> -                       set_bit(R1BIO_WriteError, &r1_bio->state);
>> -               else {
>> +               if (test_bit(Faulty, &rdev->flags) ||
>> +                   (
>> +                   test_bit(FailFast, &rdev->flags) &&
>> +                   (bio->bi_opf & MD_FAILFAST) &&
>> +                   /* We never try FailFast to WriteMostly devices */
>> +                   !test_bit(WriteMostly, &rdev->flags) &&
>> +                   md_bio_failure_error(r1_bio->mddev, rdev, bio)
>> +                   )
>> +               ) {
>>                          /* Finished with this branch */
>>                          r1_bio->bios[mirror] = NULL;
>>                          to_put = bio;
>> +               } else {
>> +                       set_bit(R1BIO_WriteError, &r1_bio->state);
>>                  }
>>          } else {
>>                  /*
> 
> No, this just make code even more unreadable.

Understood.

Thanks,
Akagi

> 
> Thanks,
> Kuai
> 
>> Thanks,
>> Akagi
>>
>>> Thanks,
>>> Kuai
>>>
>>>
>>>

