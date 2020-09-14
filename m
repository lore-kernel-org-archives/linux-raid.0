Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26977C43461
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 11:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB66121973
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 11:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NrtbG0w9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgINLhL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 07:37:11 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726025AbgINLgv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Sep 2020 07:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600083401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e64r/Q53+KzuVLneli9xL9WomSHGyX9zqVGq6gmuiqI=;
        b=NrtbG0w9gI87J4MycQrsEKCVfYelIvSei71M928dneRaRTEzdFpCftQ9KqzSfrHvBDNMEI
        JeTcyAwrbHoaCCUleRrD91IBMYeVzcn6tquk4NQ8K8tA5tJN+eecNYvfDIou9hhcUzn8rl
        cBR+JeVJ1tdL7TFG9lpU0VxphQdvIYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-slvdL5apNZOVqcweW13oew-1; Mon, 14 Sep 2020 07:36:40 -0400
X-MC-Unique: slvdL5apNZOVqcweW13oew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC3A98B94B4;
        Mon, 14 Sep 2020 11:36:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E115027BBC;
        Mon, 14 Sep 2020 11:36:28 +0000 (UTC)
Subject: Re: [mdadm PATCH 1/2] Check hostname file empty or not when creating
 raid device
To:     anthony <antmbox@youngman.org.uk>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com
References: <1600061895-16330-1-git-send-email-xni@redhat.com>
 <1600061895-16330-2-git-send-email-xni@redhat.com>
 <5ed15812-1d8d-1c40-6746-36cd801b0166@youngman.org.uk>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <f741d0cb-9a9b-2064-eb6c-b5bc2680744f@redhat.com>
Date:   Mon, 14 Sep 2020 19:36:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <5ed15812-1d8d-1c40-6746-36cd801b0166@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 09/14/2020 04:28 PM, anthony wrote:
> On 14/09/2020 06:38, Xiao Ni wrote:
>> If /etc/hostname is empty and the hostname is decided by DHCP. There 
>> is a risk that the raid
>> device can't be active after boot. Maybe the network starts after 
>> storage. The system can
>          ^^^^^
>
> I think you mean "won't" - "the raid device will not be active after 
> boot".
>
> This is a nasty corner case in English Grammar - one verb is "I can, 
> you will, he will", the other is "I will, you can, he can" !?!?!?
>
> If you mean it is possible that the array will not be there after 
> boot, but that the user can just start it manually (ie there's no real 
> problem with it), then it's "the raid device won't be active ..."
>
> Cheers,
> Wol
>
Hi Wol

Thanks for pointing about this.
I need to explain more exactly. The raid will not be in active state for 
boot. It'll be auto-read-only state.
I'll send the patch again.

Thanks
Xiao

