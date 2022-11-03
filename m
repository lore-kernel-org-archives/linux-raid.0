Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC15FC433FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Nov 2022 15:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiKCPVl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Nov 2022 11:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiKCPVk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Nov 2022 11:21:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A404E35
        for <linux-raid@vger.kernel.org>; Thu,  3 Nov 2022 08:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667488848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i/tpcJ89AOrmrdAlY3Lm5DgosQHILD4ceWkQ4LRfyIM=;
        b=h7tMPkjQy5oFsJO5Onlm3Ep2uQUtXq7WOcpvR5DJu4sDnPEFHprx8V7qF9/lyiCjBelj3r
        Epg7sLHGJdtzpc+afJekIE4OPGRx/XDyfugeB9sl1SmAgi2WlnxoN+Ww5xEOUsWtp3OKfk
        K283xdxhQoBk3CXwX0HYKzY90wl9Ulw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-BUP1PA8cMc-L7lHh974aaA-1; Thu, 03 Nov 2022 11:20:45 -0400
X-MC-Unique: BUP1PA8cMc-L7lHh974aaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C9E7858282;
        Thu,  3 Nov 2022 15:20:44 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27CEA1415123;
        Thu,  3 Nov 2022 15:20:44 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2A3FKiSv024692;
        Thu, 3 Nov 2022 11:20:44 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2A3FKhog024688;
        Thu, 3 Nov 2022 11:20:44 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 3 Nov 2022 11:20:43 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zdenek Kabelac <zkabelac@redhat.com>
cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
In-Reply-To: <alpine.LRH.2.21.2211030851090.10884@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.21.2211031018030.18305@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com> <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev> <alpine.LRH.2.21.2211030851090.10884@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185206533-393482532-1667485781=:18305"
Content-ID: <alpine.LRH.2.21.2211031109110.18305@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-393482532-1667485781=:18305
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.2211031109111.18305@file01.intranet.prod.int.rdu2.redhat.com>



On Thu, 3 Nov 2022, Mikulas Patocka wrote:

> > BTW, is the mempool_free from endio -> dec_count -> complete_io?
> > And io which caused the crash is from dm_io -> async_io / sync_io
> >  -> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
> > suppose the io is for mirror image.
> > 
> > Thanks,
> > Guoqing
> 
> I presume that the bug is caused by destruction of a bio set while bio 
> from that set was in progress. When the bio finishes and an attempt is 
> made to free the bio, a crash happens when the code tries to free the bio 
> into a destroyed mempool.
> 
> I can do more testing to validate this theory.
> 
> Mikulas

When I disable tail-call optimizations with "-fno-optimize-sibling-calls", 
I get this stacktrace:

[  200.105367] Call Trace:
[  200.105611]  <TASK>
[  200.105825]  dump_stack_lvl+0x33/0x42
[  200.106196]  dump_stack+0xc/0xd
[  200.106516]  mempool_free.cold+0x22/0x32
[  200.106921]  bio_free+0x49/0x60
[  200.107239]  bio_put+0x95/0x100
[  200.107567]  super_written+0x4f/0x120 [md_mod]
[  200.108020]  bio_endio+0xe8/0x100
[  200.108359]  __dm_io_complete+0x1e9/0x300 [dm_mod]
[  200.108847]  clone_endio+0xf4/0x1c0 [dm_mod]
[  200.109288]  bio_endio+0xe8/0x100
[  200.109621]  __dm_io_complete+0x1e9/0x300 [dm_mod]
[  200.110102]  clone_endio+0xf4/0x1c0 [dm_mod]
[  200.110543]  bio_endio+0xe8/0x100
[  200.110877]  brd_submit_bio+0xf8/0x123 [brd]
[  200.111310]  __submit_bio+0x7a/0x120
[  200.111670]  submit_bio_noacct_nocheck+0xb6/0x2a0
[  200.112138]  submit_bio_noacct+0x12e/0x3e0
[  200.112551]  dm_submit_bio_remap+0x46/0xa0 [dm_mod]
[  200.113036]  flush_expired_bios+0x28/0x2f [dm_delay]
[  200.113536]  process_one_work+0x1b4/0x320
[  200.113943]  worker_thread+0x45/0x3e0
[  200.114319]  ? rescuer_thread+0x380/0x380
[  200.114714]  kthread+0xc2/0x100
[  200.115035]  ? kthread_complete_and_exit+0x20/0x20
[  200.115517]  ret_from_fork+0x1f/0x30
[  200.115874]  </TASK>

The function super_written is obviously buggy, because it first wakes up a 
process and then calls bio_put(bio) - so the woken-up process is racing 
with bio_put(bio) and the result is that we attempt to free a bio into a 
destroyed bio set.

When I fix super_written, there are no longer any crashes. I'm posting a 
patch in the next email.

Mikulas
--185206533-393482532-1667485781=:18305--

