Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B42C433E0
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 01:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B01564F78
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 01:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhBCBpM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 20:45:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhBCBpL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 20:45:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612316625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11xjxPEHKvfx8iE79y189ZKTRIQekUJs8xI62FTi8WA=;
        b=hycFVo6scLlZujcUXKCqRKHOhqGi767NPknJTpZte0Y7KZx5kckXVExaT9PKl3GcN8reC2
        CAV9SCTgIdUvzskhDYkmesOHXGYCSmz57lnvXy0+4UTXTz4zBlwGoKXVPkM/mpoppRDkc7
        yLaBbJF+qaw06k1ZgRjqgxpTIvjWijo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-vcd3ov6kP5asN4yu6jKW9g-1; Tue, 02 Feb 2021 20:43:41 -0500
X-MC-Unique: vcd3ov6kP5asN4yu6jKW9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75502DF8AA;
        Wed,  3 Feb 2021 01:43:39 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EE0C6EF53;
        Wed,  3 Feb 2021 01:43:34 +0000 (UTC)
Subject: Re: PROBLEM: Recent raid10 block discard patchset causes filesystem
 corruption on fstrim
To:     Matthew Ruffell <matthew.ruffell@canonical.com>,
        Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "khalid.elmously@canonical.com" <khalid.elmously@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <dbd2761e-cd7d-d60a-f769-ecc8c6335814@canonical.com>
 <EA47EF7A-06D8-4B37-BED7-F04753D70DF5@fb.com>
 <a85943ed-60d4-05ad-9f6d-d76324fa5538@redhat.com>
 <71b9c9df-93a8-165a-d254-746a874f2238@canonical.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <7fb182e0-a03f-4125-e3db-e9f819e099e4@redhat.com>
Date:   Wed, 3 Feb 2021 09:43:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <71b9c9df-93a8-165a-d254-746a874f2238@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 02/02/2021 11:42 AM, Matthew Ruffell wrote:
> Hi Xiao,
>
> On 24/12/20 11:18 pm, Xiao Ni wrote:> The root cause is found. Now we use a similar way with raid0 to handle discard request
>> for raid10. Because the discard region is very big, we can calculate the start/end address
>> for each disk. Then we can submit the discard request to each disk. But for raid10, it has
>> copies. For near layout, if the discard request doesn't align with chunk size, we calculate
>> a start_disk_offset. Now we only use start_disk_offset for the first disk, but it should be
>> used for the near copies disks too.
> Thanks for finding the root cause and making a patch that corrects the offset
> addresses for multiple disks!
>
>> [  789.709501] discard bio start : 70968, size : 191176
>> [  789.709507] first stripe index 69, start disk index 0, start disk offset 70968
>> [  789.709509] last stripe index 256, end disk index 0, end disk offset 262144
>> [  789.709511] disk 0, dev start : 70968, dev end : 262144
>> [  789.709515] disk 1, dev start : 70656, dev end : 262144
>>
>> For example, in this test case, it has 2 near copies. The start_disk_offset for the first disk is 70968.
>> It should use the same offset address for second disk. But it uses the start address of this chunk.
>> It discard more region. The patch in the attachment can fix this problem. It split the region that
>> doesn't align with chunk size.
> Just wondering, what is the current status of the patchset? Is there anything
> that I can do to help?
>
>> There is another problem. The stripe size should be calculated differently for near layout and far layout.
>>
> I can help review the patch and help test the patches anytime. Do you need help
> with making a patch to calculate the stripe size for near and far layouts?
>
> Let me know how you are going with this patchset, and if there is anything I
> can do for you.
>
> Thanks,
> Matthew
>
Hi Matthew

I'm doing the test for the new patch set. I'll send the patch soon 
again. Thanks for the help.

Regards
Xiao

