Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFF7C433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 02:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D6C164E0F
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 02:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhBDCBq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 21:01:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231709AbhBDCBm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 21:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612404016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R+140Jx6HLyG+2AWeb83zmH/Bqvr98kq0gdxYEIec8w=;
        b=E6s3ei+mspZghv4eSDyXHyhm3C+17BjtUTLMKRsn8QFCGX3mkXFbSeH3+pgQBWrwFu1+69
        WEQs8vKeBiO26435Gcbp6L78bJfoO8Ut6qL6MG0yHjFnmcnnB3tUnRk22cbw0I3aem8OMI
        OAbeuQwAn9qw+squ42CetDwPkYmACTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125--qwKZ9HkNkypDGwy8qfTdA-1; Wed, 03 Feb 2021 21:00:14 -0500
X-MC-Unique: -qwKZ9HkNkypDGwy8qfTdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00F60801969;
        Thu,  4 Feb 2021 02:00:13 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C28A2100AE4B;
        Thu,  4 Feb 2021 02:00:09 +0000 (UTC)
Subject: Re: [PATCH 4/5] md/raid10: improve raid10 discard request
To:     Christoph Hellwig <hch@infradead.org>
Cc:     songliubraving@fb.com, linux-raid@vger.kernel.org,
        matthew.ruffell@canonical.com, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
 <1612359931-24209-5-git-send-email-xni@redhat.com>
 <20210203155051.GD4078626@infradead.org>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <32522765-973f-8381-75a9-c8386dd44528@redhat.com>
Date:   Thu, 4 Feb 2021 10:00:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20210203155051.GD4078626@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 02/03/2021 11:50 PM, Christoph Hellwig wrote:
> On Wed, Feb 03, 2021 at 09:45:30PM +0800, Xiao Ni wrote:
>> +static struct bio *raid10_split_bio(struct r10conf *conf,
>> +			struct bio *bio, sector_t sectors, bool want_first)
>> +{
>> +	struct bio *split;
>> +
>> +	split = bio_split(bio, sectors,	GFP_NOIO, &conf->bio_split);
>> +	bio_chain(split, bio);
>> +	allow_barrier(conf);
>> +	if (want_first) {
>> +		submit_bio_noacct(bio);
>> +		bio = split;
>> +	} else
>> +		submit_bio_noacct(split);
>> +	wait_barrier(conf);
>> +
>> +	return bio;
> I'm not sure this helper makes much sense given that the two different
> cases could just be open coded into the two callers.
It makes sense. At first I want to make the codes look like simpler. But 
as you said, they are two
different cases. We can code openly into the two callers.
>
>> +		/* raid10_remove_disk uses smp_mb to make sure rdev is set to
>> +		 * replacement before setting replacement to NULL. It can read
>> +		 * rdev first without barrier protect even replacment is NULL
>> +		 */
> Not the normal kernel comment style.
>
>> +/* There are some limitations to handle discard bio
>> + * 1st, the discard size is bigger than stripe_size*2.
>> + * 2st, if the discard bio spans reshape progress, we use the old way to
>> + * handle discard bio
>> + */
> Same here.
>
>> +static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>> +{
>> +	struct r10conf *conf = mddev->private;
>> +	struct geom *geo = &conf->geo;
>> +	struct r10bio *r10_bio;
>> +
>> +	int disk;
>> +	sector_t chunk;
>> +	unsigned int stripe_size;
>> +	unsigned int stripe_data_disks;
>> +	sector_t split_size;
>> +
>> +	sector_t bio_start, bio_end;
> Empty lines between variabe declarations also are kinda strange.
>
>> +	stripe_data_disks = geo->near_copies ?
>> +				geo->raid_disks / geo->near_copies +
>> +				geo->raid_disks % geo->near_copies :
>> +				geo->raid_disks;
> Normal style would be an if/else here.
>
>> +
>> +	bio_start = bio->bi_iter.bi_sector;
>> +	bio_end = bio_end_sector(bio);
>> +
>> +	/* Maybe one discard bio is smaller than strip size or across one stripe
>> +	 * and discard region is larger than one stripe size. For far offset layout,
> While there are occasional exceptions to the 80 char line rule, a block
> comment should never qualify.
>
>> +	 * if the discard region is not aligned with stripe size, there is hole
>> +	 * when we submit discard bio to member disk. For simplicity, we only
>> +	 * handle discard bio which discard region is bigger than stripe_size*2
>> +	 */
>> +	if (bio_sectors(bio) < stripe_size*2)
> missing whitespaces around the *.
>
I'll fix these style problems.

Thanks
Xiao

