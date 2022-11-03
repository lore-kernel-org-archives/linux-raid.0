Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A6FC433FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Nov 2022 13:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiKCNCW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Nov 2022 09:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiKCNB4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Nov 2022 09:01:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3831120B4
        for <linux-raid@vger.kernel.org>; Thu,  3 Nov 2022 06:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667480452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yaTl0Ka2PyO2VP65u5456+Ypg6Kh2H5CA7ojdCH2r/w=;
        b=WczFhn6i+SZmBa7+yD3C4jnpIyLuYUkljxrMqTnNUMVJOSA/gnz0moquSxNukW4nOwqohN
        kkK2ifcdKumgIlcG/L06720ard0rRwUcbAUMr7JZ1n2ImOviaeIA1JEawDUhuQqQvEhYzR
        Cp16IAePTf8j5I0qFvk4jQdoEpA2zt0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-MJWmtoHLOVC9s5z0upRW8A-1; Thu, 03 Nov 2022 09:00:49 -0400
X-MC-Unique: MJWmtoHLOVC9s5z0upRW8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BB24857FAB;
        Thu,  3 Nov 2022 13:00:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A9641121325;
        Thu,  3 Nov 2022 13:00:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2A3D0ntR011491;
        Thu, 3 Nov 2022 09:00:49 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2A3D0nBl011487;
        Thu, 3 Nov 2022 09:00:49 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 3 Nov 2022 09:00:49 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zdenek Kabelac <zkabelac@redhat.com>
cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
In-Reply-To: <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
Message-ID: <alpine.LRH.2.21.2211030851090.10884@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com> <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185206533-311995707-1667479929=:10884"
Content-ID: <alpine.LRH.2.21.2211030854150.10884@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-311995707-1667479929=:10884
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.2211030854151.10884@file01.intranet.prod.int.rdu2.redhat.com>



On Thu, 3 Nov 2022, Guoqing Jiang wrote:

> Hi,
> 
> On 11/3/22 12:27 AM, Mikulas Patocka wrote:
> > Hi
> > 
> > There's a crash in the test shell/lvchange-rebuild-raid.sh when running
> > the lvm testsuite. It can be reproduced by running "make check_local
> > T=shell/lvchange-rebuild-raid.sh" in a loop.
> 
> I have problem to run the cmd (not sure what I missed), it would be better if
> the relevant cmds are extracted from the script then I can reproduce it with
> those cmds directly.

Ask Zdenek Kabelac to help you with running the testsuite. He has better 
understanding of the testsuite than me.

> BTW, is the mempool_free from endio -> dec_count -> complete_io?
> And io which caused the crash is from dm_io -> async_io / sync_io
>  -> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
> suppose the io is for mirror image.
> 
> Thanks,
> Guoqing

I presume that the bug is caused by destruction of a bio set while bio 
from that set was in progress. When the bio finishes and an attempt is 
made to free the bio, a crash happens when the code tries to free the bio 
into a destroyed mempool.

I can do more testing to validate this theory.

Mikulas
--185206533-311995707-1667479929=:10884--

