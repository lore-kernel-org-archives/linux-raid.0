Return-Path: <SRS0=7RKO=EL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C263C00A89
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 03:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2B82078E
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 03:30:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acLj8ecv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732932AbgKEDaI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Nov 2020 22:30:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728511AbgKEDaH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Nov 2020 22:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604547006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p01AHEKh5E8r7noLWT+kIHXAQKyoQ/TUkAAZi622vws=;
        b=acLj8ecvN+cLuxCFPL//t3Wc1y5Zjqjfjk3Vg4Ps1o3exw6HU1/kNuMLxfA3nBbiLXmHAs
        1FiexCNmUpAaPBB1sXzEevUxbj/s181vbWo12rUbLjeivo3hRBxXVat2aHf0E95sv0sFrB
        kd3EL32dJomWPzFV1MGMQeY4OqA67j8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-vQAbCiAuN2yGQvAqZN4Zdg-1; Wed, 04 Nov 2020 22:30:04 -0500
X-MC-Unique: vQAbCiAuN2yGQvAqZN4Zdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DC9557090;
        Thu,  5 Nov 2020 03:30:03 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BB259F64;
        Thu,  5 Nov 2020 03:30:00 +0000 (UTC)
Subject: Re: [PATCH v2 0/3] md superblock write alignment on 512e devices
To:     Chris Unkel <cunkel@drivescale.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20201029201358.29181-1-cunkel@drivescale.com>
 <265efd48-b0c6-cba5-c77e-5efb0e6b9e00@redhat.com>
 <CAHFUYDo23BBq0R5mZBZgcCEzE=rN_ZYHCZp5WEs-nBZwYeyEnA@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <df5a45c9-d286-11af-c206-b0ef5bff79ea@redhat.com>
Date:   Thu, 5 Nov 2020 11:29:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAHFUYDo23BBq0R5mZBZgcCEzE=rN_ZYHCZp5WEs-nBZwYeyEnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/04/2020 04:12 AM, Chris Unkel wrote:
> Hi Xiao,
>
> Thanks for the excellent feedback.  Since bitmap_offset appears to be
> a free-form field, it wasn't apparent to me that the bitmap never
> starts within 4K of the bitmap.
>
> I don't think it's worth worrying about a logical block size that's
> more than 4K here--from what I can see logical block size larger than
> the usual 4K page isn't going to happen.
>
> I do think that it makes sense to handle the case where the physical
> block size is more than 4K.  I think what you propose works, but I
> think in the physical block > MAX_SB_SIZE case it makes more sense to
> align the superblock writes to the physical block size (as now) rather
Is it a typo error? You want to say if physical block > MAX_SB_SIZE, it 
should align the
superblock writes to logical block size? Because I see the comments 
below, your solution
is to align to logical block size when physical block > MAX_SB_SIZE.
> than rejecting the create/assemble.  Mounting with the possible
> performance hit seems like a better outcome for the user in that case
> than refusing to assemble.
> It's the same check that would have to be written to reject the
> assembly in that case and so the code shouldn't really be any more
> complex.
>
> So basically what I propose is:  if the physical block size is no
> larger than MAX_SB_SIZE, pad to that; otherwise pad to to
> logical_block_size, that is, replace queue_logical_block_size()
> with something equivalent to:
>
>      queue_physical_block_size(...) > MAX_SB_SIZE ?
> queue_logical_block_size(...) : queue_physical_block_size(...)
>
> which is simple, safe in all cases, doesn't reject any feasible
> assembly, and generates aligned sb writes on all common current
> devices (512n,4kn,512e.)
>
> What do you think?
Yes, It's a nice solution :)

Regards
Xiao

