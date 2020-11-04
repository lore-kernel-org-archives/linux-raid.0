Return-Path: <SRS0=4QbR=EK=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B958C2D0A3
	for <linux-raid@archiver.kernel.org>; Wed,  4 Nov 2020 02:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D29FA2236F
	for <linux-raid@archiver.kernel.org>; Wed,  4 Nov 2020 02:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yu8uILbq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbgKDCmf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Nov 2020 21:42:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730153AbgKDCme (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Nov 2020 21:42:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604457753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zpo4q12oXG/yCzxI7RWwU0WV11iZu1bOFDfnVLke5Dk=;
        b=Yu8uILbqkHaEv4ka5sEikK8S7hQ9Z2TifA/6qkI6gCnMIjGXi6TlnAvw7BvFud+JxYvNrB
        JvTmNzGW+SFtroN3sfXtYULqP/qW6FHp4CDgZKJrGh+xp2I9CntYpkqMJldSIOgjl/Ku2q
        Zes7kt4ybBeNlxeco9fOKXDNDSiOOk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-r67hww1UPA2Q9cfbXgsIpg-1; Tue, 03 Nov 2020 21:42:31 -0500
X-MC-Unique: r67hww1UPA2Q9cfbXgsIpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8710080365D;
        Wed,  4 Nov 2020 02:42:30 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95F91610F3;
        Wed,  4 Nov 2020 02:42:27 +0000 (UTC)
Subject: Re: The raid device can't be unmount when it can't work
To:     Phillip Susi <phill@thesusis.net>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <9b6db7d5-4a34-a1f9-2314-5e3522555052@redhat.com>
 <87tuu7y0vq.fsf@vps.thesusis.net>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <f51a8b6a-4da7-ca0a-ac35-8bc478c64ada@redhat.com>
Date:   Wed, 4 Nov 2020 10:42:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <87tuu7y0vq.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/03/2020 04:11 AM, Phillip Susi wrote:
> Xiao Ni writes:
>
>> When one raid loses disks that are bigger than the max degraded number,
>> the udev rule[1] tries to stop
>> the raid device. If the raid device is mount, it tries to unmount it
> Why?  If there are open files on it, you won't be able to unmount it
> anyway, and what would you gain by stopping the broken device?
Hi Phillip

This policy was introduced by this patch:

commit 8af530b07fce27f56c56b2ffd254a40b4ab67c6b
Author: NeilBrown <neilb@suse.de>
Date:   Tue Mar 5 09:46:34 2013 +1100

     Enhance incremental removal.

     When asked to incrementally-remove a device, try marking the array
     read-auto first.  That will delay recording the failure in the
     metadata until it is really relevant.
     This way, if the device are just unplugged when the array is not
     really in use, the metadata will remain clean.

     If marking the default as faulty fails because it is EBUSY, that
     implies that the array would be failed without the device.  As the
     device has (presumably gone) - that means the array is dead.  So try
     to stop it.  If that fails because it is in use, send a uevent to
     report that it is gone.  Hopefully whoever mounted it will now let go.

     This means that if  you plug in some devices and they are
     auto-assembled, then unplugging them will auto-deassemble relatively
     cleanly.

     To be complete, we really need the kernel to disassemble the array
     after the last close somehow.  Maybe if a REMOVE has failed and a STOP
     has failed and nothing else much has happened, it could safely stop
     the array on last close.

>
>> first[2]. It uses udisks command to do this.
>> It's a little old. Now the package version is udisks2 which uses
>> udisksctl to do this. I write a patch[3] and do
>> test. It's failed because of "udisksctl error Permission denied".
> Udisks is a GNOME desktop component, and so may not even exist on many
> systems.  When it does, you still can't call it from udev scripts since
> they are not run within the desktop in the context of a logged in user.
> If you want to unmount the device, just use umount.
>
Thanks for sharing the knowledge.

Regards
Xiao

