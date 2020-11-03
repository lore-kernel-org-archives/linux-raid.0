Return-Path: <SRS0=1EIv=EJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622A5C2D0A3
	for <linux-raid@archiver.kernel.org>; Tue,  3 Nov 2020 08:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF7A22264
	for <linux-raid@archiver.kernel.org>; Tue,  3 Nov 2020 08:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eq5l+fd+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgKCIcq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Nov 2020 03:32:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727239AbgKCIcq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Nov 2020 03:32:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604392365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0AVrrnFk2LK6xv5QQDL/L5IslzwzGSKzr0bCkym7Zn8=;
        b=Eq5l+fd+VKF6HkfsP/HWOmzC/VRokebi+TMHAhFuJOPRPnxdkXObT5BhTVNalFgGM5XAzc
        o5kkbogs6o3gqb4kdnCsDp9Qis4l6tM2zrt+IToQf8Zq7HRCPod0zr3qwaClTwvSEtLrzz
        STaRzHtfm50lw+4pupKqgkXB8xfWG9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-msbyy7JzMaanGxALteOV5Q-1; Tue, 03 Nov 2020 03:32:43 -0500
X-MC-Unique: msbyy7JzMaanGxALteOV5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAF5E8030C4;
        Tue,  3 Nov 2020 08:32:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C21E5C5DE;
        Tue,  3 Nov 2020 08:32:39 +0000 (UTC)
Subject: Re: [PATCH 0/3] mdraid sb and bitmap write alignment on 512e drives
To:     Chris Unkel <cunkel@drivescale.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Song Liu <song@kernel.org>
References: <20201023033130.11354-1-cunkel@drivescale.com>
 <f5ba4699-5620-d30d-2b0b-51b39b46b589@redhat.com>
 <CAHFUYDpFeK+mkRSkzAydu9emGSzpPxu3QuTN73uatADvfRqzgw@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <b6071554-6e5f-bd4c-bc4a-ced9a0dbf403@redhat.com>
Date:   Tue, 3 Nov 2020 16:32:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAHFUYDpFeK+mkRSkzAydu9emGSzpPxu3QuTN73uatADvfRqzgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/03/2020 02:59 AM, Chris Unkel wrote:
> Hi Xiao,
>
> That particular array is super1.2.  The block trace was captured on
> the disk underlying the partition device on which the md array member
> resides, not on the partition device itself.  The partition starts
> 2048 sectors into the disk (1MB).  So the 2048 sectors offset to the
> beginning of the partition, plus the 8 sector superblock offset for
> super1.2 ends up at 2056.
>
> Sorry for the confusion there.
>
> Regards,
>
>   --Chris

Thanks for the explanation. I still have some questions in other emails 
about
your patch. Could you have a look when you are free.

Regards
Xiao

