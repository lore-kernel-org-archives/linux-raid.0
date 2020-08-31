Return-Path: <SRS0=7JT0=CJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DE9C433E2
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 14:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 208FC20767
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 14:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DuMa1652"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgHaOgZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Aug 2020 10:36:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726292AbgHaOgV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 31 Aug 2020 10:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598884580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rwd1pOiF6xwFRw0Sf/A8DlUJEcwsmCUmoBISYkRhmho=;
        b=DuMa16526Y5ZaoFlwtP2G9wZ8VAjq21c9/K1sEoXGBxX09UYsYHp9UEMhIvxW8W7jK4iIY
        aP7hjBZCLl/2OYrZxiLX+sDxqUZfs3C9W1Tz6Yw/bD04Nwt1W9Y7pp5CifrjQpYTBYYhV8
        4P0QsgQeUvhRzu3wSk8kLkliScDuobc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-7rqSI46YP6STnEJNWAua4w-1; Mon, 31 Aug 2020 10:36:16 -0400
X-MC-Unique: 7rqSI46YP6STnEJNWAua4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75617195D560;
        Mon, 31 Aug 2020 14:36:15 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D53B78B2A;
        Mon, 31 Aug 2020 14:36:12 +0000 (UTC)
Subject: Re: [PATCH V5 4/5] md/raid10: improve raid10 discard request
From:   Xiao Ni <xni@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Coly Li <colyli@suse.de>
References: <1598334183-25301-1-git-send-email-xni@redhat.com>
 <1598334183-25301-5-git-send-email-xni@redhat.com>
 <CAPhsuW55WD0iNSEtu9xwV4zEDWxAu_ycMM6ecpoz_DXcooeMLw@mail.gmail.com>
 <4ae2de9d-86ad-cb41-243f-bc9859e0165f@redhat.com>
Message-ID: <7a352087-c84b-b263-5138-32ce50ecb0ac@redhat.com>
Date:   Mon, 31 Aug 2020 22:36:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <4ae2de9d-86ad-cb41-243f-bc9859e0165f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 08/31/2020 04:37 PM, Xiao Ni wrote:
>
>
> On 08/29/2020 06:16 AM, Song Liu wrote:
>> On Mon, Aug 24, 2020 at 10:43 PM Xiao Ni <xni@redhat.com> wrote:
>> [...]
>>> ---
>>>   drivers/md/raid10.c | 254 
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 253 insertions(+), 1 deletion(-)
>>>
>> [...]
>>> +
>>> +static void raid10_end_discard_request(struct bio *bio)
>>> +{
>>> +       struct r10bio *r10_bio = bio->bi_private;
>>> +       struct r10conf *conf = r10_bio->mddev->private;
>>> +       struct md_rdev *rdev = NULL;
>>> +       int dev;
>>> +       int slot, repl;
>>> +
>>> +       /*
>>> +        * We don't care the return value of discard bio
>>> +        */
>>> +       if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>>> +               set_bit(R10BIO_Uptodate, &r10_bio->state);
>> We don't need the test_bit(), just do set_bit().
> Coly suggested to do test_bit first to avoid write memory. If there 
> are so many requests and the
> requests fail, this way can improve performance very much.
>
> But it doesn't care the return value of discard bio. So it should be 
> ok that doesn't set R10BIO_Uptodate here.
> I'll remove these codes. What do you think?

Hi Song

Sorry, for this problem, it still needs to set R10BIO_Uptodate. Because 
in function raid_end_bio_io it needs to use this
flag to justify whether set BLK_STS_IOERR or not. So is it ok to test 
this bit first before setting this bit here?

Regards
Xiao


