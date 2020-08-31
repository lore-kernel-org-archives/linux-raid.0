Return-Path: <SRS0=7JT0=CJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E8AC433E6
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 08:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6E42073A
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 08:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AkrsBspM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgHaIiI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Aug 2020 04:38:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57872 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgHaIiH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 31 Aug 2020 04:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598863085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1E2Fd49s7pCCNnTc5xsnll0fP+UNiu8a9XeWlx/dATI=;
        b=AkrsBspMYiA43XYBeP2SeB94Qz9WRhr8/ezHYVfcX/MvH7VyuSgB7vXYJX8CzIrE4xQhmu
        fEO64PITznjYtKiZwxNtR9j9ihZd3j6575IJf732NNS+hr/K5QJre/SZwly+4F/fsuJznE
        Yhhgvwgtor0ocY86+SmloybE0jb3ZbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-EORgqwUzO2m2epTS3l8a9g-1; Mon, 31 Aug 2020 04:38:03 -0400
X-MC-Unique: EORgqwUzO2m2epTS3l8a9g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF62018A2244;
        Mon, 31 Aug 2020 08:38:01 +0000 (UTC)
Received: from [10.72.8.24] (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5C192616B;
        Mon, 31 Aug 2020 08:37:58 +0000 (UTC)
Subject: Re: [PATCH V5 4/5] md/raid10: improve raid10 discard request
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Coly Li <colyli@suse.de>
References: <1598334183-25301-1-git-send-email-xni@redhat.com>
 <1598334183-25301-5-git-send-email-xni@redhat.com>
 <CAPhsuW55WD0iNSEtu9xwV4zEDWxAu_ycMM6ecpoz_DXcooeMLw@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <4ae2de9d-86ad-cb41-243f-bc9859e0165f@redhat.com>
Date:   Mon, 31 Aug 2020 16:37:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW55WD0iNSEtu9xwV4zEDWxAu_ycMM6ecpoz_DXcooeMLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 08/29/2020 06:16 AM, Song Liu wrote:
> On Mon, Aug 24, 2020 at 10:43 PM Xiao Ni <xni@redhat.com> wrote:
> [...]
>> ---
>>   drivers/md/raid10.c | 254 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 253 insertions(+), 1 deletion(-)
>>
> [...]
>> +
>> +static void raid10_end_discard_request(struct bio *bio)
>> +{
>> +       struct r10bio *r10_bio = bio->bi_private;
>> +       struct r10conf *conf = r10_bio->mddev->private;
>> +       struct md_rdev *rdev = NULL;
>> +       int dev;
>> +       int slot, repl;
>> +
>> +       /*
>> +        * We don't care the return value of discard bio
>> +        */
>> +       if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>> +               set_bit(R10BIO_Uptodate, &r10_bio->state);
> We don't need the test_bit(), just do set_bit().
Coly suggested to do test_bit first to avoid write memory. If there are 
so many requests and the
requests fail, this way can improve performance very much.

But it doesn't care the return value of discard bio. So it should be ok 
that doesn't set R10BIO_Uptodate here.
I'll remove these codes. What do you think?
>
>> +
>> +       dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
>> +       if (repl)
>> +               rdev = conf->mirrors[dev].replacement;
>> +       if (!rdev) {
>> +               /* raid10_remove_disk uses smp_mb to make sure rdev is set to
>> +                * replacement before setting replacement to NULL. It can read
>> +                * rdev first without barrier protect even replacment is NULL
>> +                */
>> +               smp_rmb();
>> +               repl = 0;
> repl is no longer used, right?

Right, I'll remove this line
>
>> +               rdev = conf->mirrors[dev].rdev;
> [...]
>
>> +
>> +       if (conf->reshape_progress != MaxSector &&
>> +           ((bio->bi_iter.bi_sector >= conf->reshape_progress) !=
>> +            conf->mddev->reshape_backwards))
>> +               geo = &conf->prev;
> Do we need to set R10BIO_Previous here? Also, please run some tests with
> reshape in progress.
>
> Thanks,
> Song
>
Thanks for pointing about this. Yes, it needs to set R10BIO_Previous 
here. Because it needs to
choose_data_offset when submitting bio to member disks. But it lets me 
think about patch 1/5
has a problem too. It uses rdev->data_offset directly in function 
md_submit_discard_bio. It's ok
for raid0, because it changes other levels during reshape. For raid10, 
it's a bug. Now it's in md-next
branch. Do you want me to resend all patches or a new patch to fix 1/5 
problem?  Sorry for making
this trouble.

Regards
Xiao

