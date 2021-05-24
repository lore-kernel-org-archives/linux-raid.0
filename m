Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFB1C04FF3
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 11:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C584610C7
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 11:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbhEXLCG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 May 2021 07:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbhEXLCF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 May 2021 07:02:05 -0400
Received: from wp118.webpack.hosteurope.de (wp118.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:847d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F950C061574;
        Mon, 24 May 2021 04:00:36 -0700 (PDT)
Received: from 91.141.3.207.wireless.dyn.drei.com ([91.141.3.207] helo=[10.120.169.88]); authenticated
        by wp118.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ll8K0-0005Md-Js; Mon, 24 May 2021 13:00:32 +0200
Date:   Mon, 24 May 2021 13:00:31 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <CAPhsuW7W7NfBTHY3A87py1No=FOPZgxMP4Ms43Re3uRnT0JzkQ@mail.gmail.com>
References: <20210519062215.4111256-1-hch@lst.de> <1102825331.165797.1621422078235@ox.hosteurope.de> <CAPhsuW7W7NfBTHY3A87py1No=FOPZgxMP4Ms43Re3uRnT0JzkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH] md/raid5: remove an incorect assert in in_chunk_boundary
To:     Song Liu <song@kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
From:   "Florian D." <spam02@dazinger.net>
Message-ID: <5C3BA4F9-DBA4-49AF-9F2C-D469BCA9E1A0@dazinger.net>
X-bounce-key: webpack.hosteurope.de;spam02@dazinger.net;1621854037;a224ce19;
X-HE-SMSGID: 1ll8K0-0005Md-Js
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

As you like... if it's better in the 'tested by:' line, you can also take my full name: Florian Dazinger.
 I use the e- mail address regularly, so that's ok.

Thanks for the quick patch!
Florian

On 24 May 2021 06:38:35 CEST, Song Liu <song@kernel.org> wrote:
>On Wed, May 19, 2021 at 4:36 AM wp1083705-spam02 wp1083705-spam02
><spam02@dazinger.net> wrote:
>>
>>
>> > Christoph Hellwig <hch@lst.de> hat am 19.05.2021 08:22 geschrieben:
>> >
>> >
>> > Now that the original bdev is stored in the bio this assert is
>incorrect
>> > and will trigge for any partitioned raid5 device.
>> >
>> > Reported-by:  Florian D. <spam02@dazinger.net>
>> > Fixes: 309dca309fc3 ("block: store a block_device pointer in struct
>bio"),
>> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>> > ---
>> >  drivers/md/raid5.c | 2 --
>> >  1 file changed, 2 deletions(-)
>> >
>> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> > index 841e1c1aa5e6..7d4ff8a5c55e 100644
>> > --- a/drivers/md/raid5.c
>> > +++ b/drivers/md/raid5.c
>> > @@ -5311,8 +5311,6 @@ static int in_chunk_boundary(struct mddev
>*mddev, struct bio *bio)
>> >       unsigned int chunk_sectors;
>> >       unsigned int bio_sectors = bio_sectors(bio);
>> >
>> > -     WARN_ON_ONCE(bio->bi_bdev->bd_partno);
>> > -
>> >       chunk_sectors = min(conf->chunk_sectors,
>conf->prev_chunk_sectors);
>> >       return  chunk_sectors >=
>> >               ((sector & (chunk_sectors - 1)) + bio_sectors);
>> > --
>> > 2.30.2
>>
>> yes, this solves it, I can confirm with this patch the error/warning
>message when booting linux-5.12 is gone!
>
>Applied to md-fixes. Thanks all.
>
>@ Florian, would you like to update the Reported-by tag (with your
>full name and/or
>different email)?
>
>Thanks,
>Song

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
