Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B91C05027
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjAUBGH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjAUBGG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Jan 2023 20:06:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62683B671
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 17:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674263114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bZzyIDwtonXuT5fMqQc1V3sduGyOOqLZB2RYjhE+2aE=;
        b=auop0jJk90NreghXDZvJ0oXUVkavgnSAWXBYoPcO+AG571ME1tq65HHyO/IOdbd9gHS1SB
        qAQSyog3DUEIjCwV9yXRBpUcMAeLe/nx2jXl/QI8oK+c4wSwXep0J19YHRg/2blNX7e6xl
        Y58brE2vOm4YQHgOn1oR3jcxe5vpkso=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-354-cRK8JdV5NVm9JLoXWKfG7w-1; Fri, 20 Jan 2023 20:05:13 -0500
X-MC-Unique: cRK8JdV5NVm9JLoXWKfG7w-1
Received: by mail-pj1-f70.google.com with SMTP id x8-20020a17090a8a8800b0022941842cc0so5903365pjn.3
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 17:05:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZzyIDwtonXuT5fMqQc1V3sduGyOOqLZB2RYjhE+2aE=;
        b=Jrvhetcnpjz5blasGQBJ+hjuPiJcTYCRUSJX9UWBribReIFBYpMtdZxe6N3/sIpUBq
         R0dG6uhXuYCSTjAQyCHbxR5MMGXBIrgCkceJ9ef+zJpuF0nw+5mm2cZNwbPXWNFOEEwN
         bRk7H5xBT9h4eVY9Iafbm2vBwEg0BpKHBjaknJuBzluESwnP/plO6Qn6/RD5QJhf2eBq
         YOon4fYOsPvi9umk1LDZgRMmX6Bc9AC+egk4RW8wfB2JWBloQstvm18vnxkMVGNJjm4c
         +fdTMjLA5WYpRu9d6I+IEXBHW68YlovT8gwsj8YOwmJY8OBe/fKiYMsByQwvEN1PLTjq
         70RQ==
X-Gm-Message-State: AFqh2krS0BCTiORm7QL3W5zBPle8yQD9vpACSfpQnmrBxGgFMVJU9GOr
        3232QtKuDxgoO5gdCcClspuLWyuMwz6DioclGhxCBQpO6pw938DlfCvHfc3RG/m02tdPEU3p/ti
        zZGLqz0KXQs5o8/Kv6M1Fe+svgjmojYaeL1TDGA==
X-Received: by 2002:aa7:8887:0:b0:57f:1e2b:4c56 with SMTP id z7-20020aa78887000000b0057f1e2b4c56mr1328768pfe.31.1674263112345;
        Fri, 20 Jan 2023 17:05:12 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtED7jRSUgF5y3wL60FzfOY9FW0T2xeyzvk/I09U2+1fXi8+cXK1pKfSuu5f/7uSYMJM2THpAjxSnIDBYc4lBE=
X-Received: by 2002:aa7:8887:0:b0:57f:1e2b:4c56 with SMTP id
 z7-20020aa78887000000b0057f1e2b4c56mr1328766pfe.31.1674263112024; Fri, 20 Jan
 2023 17:05:12 -0800 (PST)
MIME-Version: 1.0
References: <20230118093008.67170-1-xni@redhat.com> <CAPhsuW7b2MNX-8vTb5Gr3smKxzjiYW3qfckX1FQMt9K_K82XiQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7b2MNX-8vTb5Gr3smKxzjiYW3qfckX1FQMt9K_K82XiQ@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sat, 21 Jan 2023 09:05:00 +0800
Message-ID: <CALTww2_z=_AWBEah6Ls_CkuTVgq-2tCsNVW+EVPV01g6ydBxUg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Change some counters to percpu type
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jan 21, 2023 at 1:18 AM Song Liu <song@kernel.org> wrote:
>
> On Wed, Jan 18, 2023 at 1:30 AM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi all
> >
> > There are two main changes in the patch set.
> >
> > The first is to change ->active_io to percpu(patch02). The second
> > one is adding a counter for io_acct(patch03).
> >
>
> Hi Xiao,
>
> If I understand correctly,
>
> > Xiao Ni (4):
> >   Factor out is_md_suspended helper
> >   Change active_io to percpu
>
> Patch 1 and 2 are performance optimization?

Hi Song

Yes. These two patches are optimized for performance. At first, I thought to
use the active_io to fix the raid0 bug. But we can't move acitve_io out from
md_handle_request. So I used a new counter to monitor the bios that raid0
submits to member disks.

>
> >   Add mddev->io_acct_cnt for raid0_quiesce
> >   Free writes_pending in md_stop
>
> And patch 3 and 4 fixes two issues?
>
> It is probably better to send them as 3 separate patches (sets).

Yes, they fix two bugs. I'll divide them into 3 patch sets.

>
> Also, please provide more information on why we need these
> changes.

Sure, I've written the reason in the specific patch.

Best Regards
Xiao

>
> Thanks,
> Song
>
> >
> >  drivers/md/md.c    | 69 ++++++++++++++++++++++++++++++++++------------
> >  drivers/md/md.h    | 11 +++++---
> >  drivers/md/raid0.c |  6 ++++
> >  3 files changed, 65 insertions(+), 21 deletions(-)
> >
> > --
> > 2.32.0 (Apple Git-132)
> >
>

