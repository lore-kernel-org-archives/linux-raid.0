Return-Path: <SRS0=BPCQ=CN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FEBC43461
	for <linux-raid@archiver.kernel.org>; Fri,  4 Sep 2020 04:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C489520748
	for <linux-raid@archiver.kernel.org>; Fri,  4 Sep 2020 04:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SoT6xM90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgIDEYX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:24:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725812AbgIDEYW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Sep 2020 00:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599193461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jro31doAIbnEfq9VSXuUv7ubTg9lNQ3S7aUUgtwg/6M=;
        b=SoT6xM90ITP5muo39hSD7lVDeTMfwSdKxhVU23KmjOPzrZP1pSs72T3Tgm7C4721TYPJOz
        O7O3hms85SCccT5118emPahJymBDq//L4xRn1eeb/qlkMzRk1uLYz0cqhDyH+Of9GwD0AT
        QJChkyoLIKCHfUp3Vd1IbVJlGX94su4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Sd48_06INp6xZZRGiN_bEQ-1; Fri, 04 Sep 2020 00:24:18 -0400
X-MC-Unique: Sd48_06INp6xZZRGiN_bEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A2241DDE2;
        Fri,  4 Sep 2020 04:24:17 +0000 (UTC)
Received: from T590 (ovpn-12-109.pek2.redhat.com [10.72.12.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F8201002D5A;
        Fri,  4 Sep 2020 04:24:06 +0000 (UTC)
Date:   Fri, 4 Sep 2020 12:24:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        linux-block@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report for
 kernel 5.9.0-rc3-020ad03.cki (block)
Message-ID: <20200904042403.GB808936@T590>
References: <cki.538AE6A321.BMB0X5ZYG5@redhat.com>
 <0f92c40e-b234-896c-0810-af36ee95e259@redhat.com>
 <18db2772-3f37-55a7-d92e-dbcbe92d2cc4@kernel.dk>
 <ad1bf306-6f23-9b7c-842f-766a6efbda3e@redhat.com>
 <1300213431.10047993.1599163090152.JavaMail.zimbra@redhat.com>
 <cc956f4c-9b71-2b02-80be-dd387316dad8@kernel.dk>
 <20200904032244.GA808936@T590>
 <9066ba15-f60e-50af-719b-691651449cf4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9066ba15-f60e-50af-719b-691651449cf4@kernel.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 03, 2020 at 09:37:40PM -0600, Jens Axboe wrote:
> On 9/3/20 9:22 PM, Ming Lei wrote:
> > It is one MD's bug, and percpu_ref_exit() may be called on one ref not
> > initialized via percpu_ref_init(), and the following patch can fix the
> > issue:
> 
> I really (REALLY) think this should be handled by percpu_ref_exit(), if

OK, we can do that by return immediately from percpu_ref_exit() if
percpu_count_ptr(ref) is 0 just like before.

> it worked before. Otherwise you're just setting yourself up for a world
> of pain with other users, and we'll be fixing this fallout for a while.
> I don't want to carry that. So let's just make it do the right thing,
> needing to do this:
> 
> > +       if (mddev->writes_pending.percpu_count_ptr)
> > +               percpu_ref_exit(&mddev->writes_pending);
> 
> is really nasty.

Yeah, it is as mddev_init_writes_pending():

        if (mddev->writes_pending.percpu_count_ptr)
                return 0;
        if (percpu_ref_init(&mddev->writes_pending, no_op,
                            PERCPU_REF_ALLOW_REINIT, GFP_KERNEL) < 0)
                return -ENOMEM;

thanks,
Ming

