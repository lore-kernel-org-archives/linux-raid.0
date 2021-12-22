Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B87C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Dec 2021 03:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242032AbhLVDIg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 22:08:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhLVDIf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 21 Dec 2021 22:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640142513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DYRqB0QfSIuZAewsOcbkXnRNUolflmLMPaP8jiyFjRA=;
        b=USAZYBlLuIaB4PbdRQQZ+722Y5wNUuhRUs0yaB5srD5m0bzjTFHfpG1glVXeWLbn4JWET9
        p23qh1eJWpXq1wLhzEMPh5fQRotmCUhzyN5gT3TK3ImD7mTO0WbsSLi6YNDjGx6JHu/Pgt
        gcRp3bQVmaA/0ZWnqQINva92jxwLz6A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-ZDrA8G9ONtuomEkloen23w-1; Tue, 21 Dec 2021 22:08:32 -0500
X-MC-Unique: ZDrA8G9ONtuomEkloen23w-1
Received: by mail-ed1-f71.google.com with SMTP id s7-20020a056402520700b003f841380832so654516edd.5
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 19:08:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYRqB0QfSIuZAewsOcbkXnRNUolflmLMPaP8jiyFjRA=;
        b=WzAkEaoxKTuz5wjlkrhXVFzb+6PNEohd7Te32K4W9HHUBkuTCLz6hSfqrkBV+qwIUR
         1jg1ow7NED5yq5rb4DfSEph+hldozqyP2erhDAkLINxG9w/TDqA1stNoZkx4TId4GMt3
         7HQuFnh+PS+Cg8XCWAhaz1eYVx7pmT96wDycAmhZMexaqQTd+od9sVraL96YRutwwal0
         DBXPiimw4egt7b4qM3JbSLGlR/OZlTqemSY+Ap14XXPvkzqlY525Ldv9n2DWwUFldWLE
         tFIaRKbUhu7dRFRPizZlzUiLyI/OCPCTh3gNWrdz/ciq6N8NLzO85/91C9Pyu9tCy/q/
         ForA==
X-Gm-Message-State: AOAM530mfjA8eRdyc2/U4QioPN0cf6Dz0j5Z7mi4nKCTIjxHBF+hlSz+
        i2aV9/JbfxDkLLqijlAF3j5O2L9CtSMY4B2iky/HFBPgx9hKZQuoY2Ks8iOxJf0VNPv3qQbOvbm
        QDB/gr9aevLQyFd97/xJaQA2qckx6D6Ey6Pavfg==
X-Received: by 2002:aa7:c481:: with SMTP id m1mr1085536edq.204.1640142511343;
        Tue, 21 Dec 2021 19:08:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1OzOSZFUWFyzmXbZGA1b4rB8ADwv2UNKCCRUy+/dg4D1iwqARVwZ072A1Ecx9WZiBcSVQQYdJgEakJz3p5/8=
X-Received: by 2002:aa7:c481:: with SMTP id m1mr1085522edq.204.1640142511129;
 Tue, 21 Dec 2021 19:08:31 -0800 (PST)
MIME-Version: 1.0
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com> <CALTww2818H-T5W4oOSG_o_SU1MRAp+_=u9J824V0w1JcX8zZ8Q@mail.gmail.com>
 <20211220094519.000013d0@linux.intel.com> <CALTww28wmeuXA5V4ReTLjH-=AZ3VbR-qHEbBMEktHRU8PQQiVg@mail.gmail.com>
 <20211221145628.0000144f@linux.intel.com>
In-Reply-To: <20211221145628.0000144f@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 22 Dec 2021 11:08:20 +0800
Message-ID: <CALTww2_WVGq16d0u3iuKL-ZWFHdN50Q6iKsrQtu+sdspVuMzAg@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 21, 2021 at 9:56 PM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Xiao,
> On Tue, 21 Dec 2021 09:40:50 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > Now for a raid0, it can't remove one member disk from raid0. It
> > returns EBUSY and the raid0 still can work well. It makes sense.
> > Because all member disks are busy, the admin can't remove the member
> > disk and mdadm gives a proper error.
>
> EBUSY means that drive is busy but it is not. Just drive cannot be
> safety removed. As I wrote in patch 2:
>
> If "faulty" was not set then -EBUSY was returned to
> userspace. It causes that mdadm expects -EBUSY if the array
> becomes failed. There are some reasons to not consider this mechanism
> as correct:
> - drive can't be failed for different reasons.
> - there are path where -EBUSY is not reported and drive removal leads
> to failed array, without notification for userspace.
> - in the array failure case -EBUSY seems to be wrong status. Array is
> not busy, but removal process cannot proceed safe.
>
> For compatibility reasons i cannot remove EBUSY. I left more detailed
> explanation in patch 2.
>
> > With this patch, it changes the situation. In raid0_error, it sets
> > MD_BROKEN. In fact, it isn't broken. So is it really good to set
> > MD_BROKEN here? In patch 62f7b1989c0 ("md raid0/linear: Mark array as
> > 'broken'...), MD_BROKEN is introduced
> > when the member disk disappears and the disk is really broken. For
> > raid0/linear, the raid device can't work anymore.
>
> It is broken, any md_error() call should end with appropriate action:
> - drive removal (if possible)
> - failing array (if cannot degrade array)
>
> We cannot trust drive if md_error() was called, so writes will be
> blocked. IMO it is reasonable- to not engage level stack, because one
> or more members cannot be trusted (even if it is still accessible). Just
> allow to read old data (if still possible).
>

Thanks for the explanation. It's ok for me. Just want to have the same
understanding. Now raid0 works
in the way that it will fail when calling md_error.

Regards
Xiao

