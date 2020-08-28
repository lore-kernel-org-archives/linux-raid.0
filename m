Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B99C433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 09:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914A82078A
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 09:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GllGhqQM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgH1JuX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 05:50:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38048 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728218AbgH1JuW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Aug 2020 05:50:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598608220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oif2lpSV3JHBpsDA+49p+/+tCEVmIjyAioUncCOU2ic=;
        b=GllGhqQM98AjH3tLd/6BEcAJBaOf2r8tFQN0fb0tzydx7+1HVWGpcMdvF4Kry4gUxpOeYG
        vuUMuiOc2TF6avZIOzLQXqqoDrwlrJ3tVmltMCMhDZ3Mf3Vs08fNWlFsVxFz+REl4HrAXZ
        A/xuEC2QqcPhLllkSpQ0y78MQ+X8914=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-flJ7_leCMSaqXYGg6SOb2Q-1; Fri, 28 Aug 2020 05:50:18 -0400
X-MC-Unique: flJ7_leCMSaqXYGg6SOb2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A68C357052;
        Fri, 28 Aug 2020 09:50:17 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A85827D66D;
        Fri, 28 Aug 2020 09:50:13 +0000 (UTC)
Subject: Re: [PATCH V5 5/5] md/raid10: improve discard request for far layout
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Coly Li <colyli@suse.de>
References: <1598334183-25301-1-git-send-email-xni@redhat.com>
 <1598334183-25301-6-git-send-email-xni@redhat.com>
 <CAPhsuW5X7XnNX9UHiEv5wUzCNUtXG36gWz+pgZ2HPNf7NFN5Sg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <37a21aa1-c23d-754f-e786-72d979bd54bd@redhat.com>
Date:   Fri, 28 Aug 2020 17:50:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5X7XnNX9UHiEv5wUzCNUtXG36gWz+pgZ2HPNf7NFN5Sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 08/28/2020 03:03 PM, Song Liu wrote:
> On Mon, Aug 24, 2020 at 10:43 PM Xiao Ni <xni@redhat.com> wrote:
>> For far layout, the discard region is not continuous on disks. So it needs
>> far copies r10bio to cover all regions. It needs a way to know all r10bios
>> have finish or not. Similar with raid10_sync_request, only the first r10bio
>> master_bio records the discard bio. Other r10bios master_bio record the
>> first r10bio. The first r10bio can finish after other r10bios finish and
>> then return the discard bio.
>>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>   drivers/md/raid10.c | 87 +++++++++++++++++++++++++++++++++++++++--------------
>>   drivers/md/raid10.h |  1 +
>>   2 files changed, 65 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 257791e..f6518ea 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1534,6 +1534,29 @@ static struct bio *raid10_split_bio(struct r10conf *conf,
>>          return bio;
>>   }
>>
>> +static void raid_end_discard_bio(struct r10bio *r10bio)
> Let's name this raid10_*
Ok
>
>> +{
>> +       struct r10conf *conf = r10bio->mddev->private;
>> +       struct r10bio *first_r10bio;
>> +
>> +       while (atomic_dec_and_test(&r10bio->remaining)) {
> Should this be "if (atomic_*"?
>
The usage of while is right here. For far layout, it needs far copies 
r10bio. It needs to find a method
to know all r10bios finish. The first r10bio->remaining is used to 
achieve the target. It adds the first
r10bio->remaining when preparing other r10bios. I was inspired by 
end_sync_request. So it should
use while here. It needs to decrease the first r10bio remaining for 
other r10bios in the second loop.

Are there more things you want me to modify or add? If not, I'll send 
the v6 to rename the function
name.  Thanks for reviewing these patches :)

Regards
Xiao

