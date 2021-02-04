Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FCDC433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 01:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 365E964DDE
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 01:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhBDBzm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 20:55:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234250AbhBDBzk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 20:55:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612403654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gYxywuEC9akOg/fyUmStZEAkXyf5plY1drOdEYqoLho=;
        b=GASO2zGOfTTo+OKUwxww1JC6FDlq9UzcRDpE5UsBXahwe7KQwNl5PbL/kREpKO3/4Mlayg
        Hvmjwv7d2Grsr/sO4G7/0IsdciVU7HaY1pE2/d8G7tfyMIMdznuv0pC13mzBKamwz8Q70e
        d5XjrOB8y8Q3dfi5UewDIB6QDmYeMJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-KXWz7U8sPC6RadLWjopiaA-1; Wed, 03 Feb 2021 20:54:13 -0500
X-MC-Unique: KXWz7U8sPC6RadLWjopiaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF0E88030C1;
        Thu,  4 Feb 2021 01:54:11 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DE0627C23;
        Thu,  4 Feb 2021 01:54:08 +0000 (UTC)
Subject: Re: [PATCH 3/5] md/raid10: pull codes that wait for blocked dev into
 one function
To:     Christoph Hellwig <hch@infradead.org>
Cc:     songliubraving@fb.com, linux-raid@vger.kernel.org,
        matthew.ruffell@canonical.com, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
 <1612359931-24209-4-git-send-email-xni@redhat.com>
 <20210203154648.GC4078626@infradead.org>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <f8df46a8-c069-7de9-78d4-5c4d27e298b4@redhat.com>
Date:   Thu, 4 Feb 2021 09:54:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20210203154648.GC4078626@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 02/03/2021 11:46 PM, Christoph Hellwig wrote:
> s/codes/the code/
>
>> +			/* Discard request doesn't care the write result
>> +			 * so it doesn't need to wait blocked disk here.
>> +			 */
> The normal kernel comment style would be:
>
> 			/*
> 			 * Discard request doesn't care the write result so it
> 			 * doesn't need to wait for the blocked disk here.
> 			 */
>
Ok. Thanks for pointing out the style problem. I'll fix it and check 
other comments.

