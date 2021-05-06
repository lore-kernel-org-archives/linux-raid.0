Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1F6C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 07:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06425613B4
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 07:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhEFHuB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 03:50:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233340AbhEFHuA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 03:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620287342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WaC/hpqYjNolAbza/MPcBq5qLeUtnj2JsEgIQwz5KKM=;
        b=JS6BMpJh7V0rB53dR7XO+I2mebFceVJxoSF+hWzIKjVKWTNaQ6AXknK47Ywx1FipjsUkvg
        uFj12J4vKxsCBozAuOuHAOopinJJRcKxyRyhYte2qOe/QhRAuFRASYI3XjjbajJqupYTnI
        c39VeGzSiRq1JkTds3BI6j/4C+E8cr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-oGh9FICvPsqkrM8ngimpKg-1; Thu, 06 May 2021 03:49:00 -0400
X-MC-Unique: oGh9FICvPsqkrM8ngimpKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76EE280D696;
        Thu,  6 May 2021 07:48:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21B8E10016F8;
        Thu,  6 May 2021 07:48:57 +0000 (UTC)
Subject: Re: raid10 redundancy
To:     d tbsky <tbskyd@gmail.com>,
        list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
Date:   Thu, 6 May 2021 15:48:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi

It depends on which layout do you use and the copies you specify. There 
is a detailed description in `man md 3`

On 05/06/2021 01:09 PM, d tbsky wrote:
> Hi:
>     I am curious about raid10 redundancy when created with disk numbers below:
>
> 2 disks => 1 disk tolerance
> 3 disks = > 1 disk  tolerance
> 4 disks =>  possible 2 disks?  or still only 1 disk ?
>
> how about 5/6 disks with raid10?
> thanks a lot for confirmation!!
>

