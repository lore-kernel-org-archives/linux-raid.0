Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60299C433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 01:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3EE064DE7
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 01:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhBDBwm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 20:52:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231735AbhBDBwl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 20:52:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612403475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vTQf9IgFDRu5MDGTRnMtz1tUIbnlxC3Nf9CNsDWvQi8=;
        b=CSb8JEj9GkEzTqzkkglY/m51pPslS2B3khvO6sPnMZPwQF1wAMF+g/Wm3sWhJjYIIGfGBx
        rXVF/zax+whw80o2uDiCYqkPPx2T+6GNbXXeiQZTaZoIPDDq1WK6r4vScGnOgpZIALOzSw
        mF+3sAmMGDw1toRSmy8sOclfarxYyfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-HsXCgnKuPai8PIk5OjaGFg-1; Wed, 03 Feb 2021 20:51:12 -0500
X-MC-Unique: HsXCgnKuPai8PIk5OjaGFg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D304192CC40;
        Thu,  4 Feb 2021 01:51:10 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE1D65D762;
        Thu,  4 Feb 2021 01:51:06 +0000 (UTC)
Subject: Re: [PATCH 1/5] md: add md_submit_discard_bio() for submitting
 discard bio
To:     Christoph Hellwig <hch@infradead.org>
Cc:     songliubraving@fb.com, linux-raid@vger.kernel.org,
        matthew.ruffell@canonical.com, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
 <1612359931-24209-2-git-send-email-xni@redhat.com>
 <20210203154425.GA4078626@infradead.org>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <e6dc3ca8-2a74-a630-87c7-a08dd73048f1@redhat.com>
Date:   Thu, 4 Feb 2021 09:51:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20210203154425.GA4078626@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 02/03/2021 11:44 PM, Christoph Hellwig wrote:
> On Wed, Feb 03, 2021 at 09:45:27PM +0800, Xiao Ni wrote:
>> +	if (__blkdev_issue_discard(rdev->bdev, start, size,
>> +		GFP_NOIO, 0, &discard_bio) || !discard_bio)
>> +		return;
> Very odd indentation.  Normally this would be:
>
> 	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, 0,
> 			&discard_bio) || !discard_bio)
> 		return;
>
>> +
>> +	bio_chain(discard_bio, bio);
>> +	bio_clone_blkg_association(discard_bio, bio);
>> +	if (mddev->gendisk)
>> +		trace_block_bio_remap(discard_bio,
>> +				disk_devt(mddev->gendisk),
>> +				bio->bi_iter.bi_sector);
>> +	submit_bio_noacct(discard_bio);
>> +}
>> +EXPORT_SYMBOL(md_submit_discard_bio);
> EXPORT_SYMBOL_GPL like all the other exports in md.c, please.
>
>> +extern void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>> +			struct bio *bio, sector_t start, sector_t size);
> no need for the extern.
>
Thanks for these suggestions. I'll fix them in the next version.

Regards
Xiao

