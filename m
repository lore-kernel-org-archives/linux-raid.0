Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01329FA373E
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 16:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJUQyX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Oct 2022 12:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiJUQxx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Oct 2022 12:53:53 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB55290E1B
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 09:53:38 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id n63so1846800vsc.8
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 09:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RcS87k3V6mg3UgTzT9HUaDRGEgR9Y5s6Cn9zHCFo7E4=;
        b=WSAGkE0Pz0/Jj1VZcQU/OnvMpUNYgEuilDz0kStYxVbPSe197MxqZ0rpsUjYgtDKbE
         3/yDHhXmBwTwRh5ZqdIfBfpIyQCN2QzslbU2CjO9XKYUCg5XTNfVMrgBgm8t0+uAH772
         bO6aW6pdBP86cwODplyVaqMw7vz3QNvmmyaq6MPUXVE7tvtQlb2O+94n/Vxmpv1aDFTq
         d1i6flazy+R00VL/eTTO/i4GnBWMxhWz61w6WrQ9KjhmXung5OSad4c3sjgKRgcxQTBg
         HVdFXy7MyAK9pGrQvU94xFpXVxdgjsarD+a/rE2962tPfOUVP5y4dWPQds8ranyfrtuf
         w2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RcS87k3V6mg3UgTzT9HUaDRGEgR9Y5s6Cn9zHCFo7E4=;
        b=8BQyEKsk5KwXaf3SZlbCwMdK3j8gF+lNH99E8QgxtouR9Nb6J68PP6KDSP8G1mMn2i
         b+lI0qbCBfO7q9Djet6yJw3opotwbbNG9C9Q6FD/+RuHTYJd404qmxGUJ+msZfzv9Ac3
         KTEzB+KbkaCek7WmU/wL6sUcZKu3RI904xdGdGdsSOkELT8/FtrTqDlG4ulf6YdGtYGW
         anSh6XWFUjfwRqZGExWguSK7KuVc3J9wxu12howQAMkPHSEQvHID8TMa7KiR3T81LqcB
         7H71c/62lE7Vu9pXik4++t0po15AWt+Ejve7Xy+Pm7+0ewfmIUHBZrE+UvggxE4CUMuj
         ibFA==
X-Gm-Message-State: ACrzQf2kTcXucxICpf/W8MqQetpS/8fhlxKFU0T1ZRLcvPIPAhgwT7zW
        Ykhthy6Ipgt7zJ9dzFoeqgQ+qDRHnuMh5tBTFbvfvEi+
X-Google-Smtp-Source: AMsMyM69e+l5Eg0BgZmXG3MIOVBsF93M7b5Xh4ge/pl0r7GNMK84HlCeCNWhB7yDSdi/xyXXLphIxm/Yvu7Im17JQms=
X-Received: by 2002:a67:b046:0:b0:3a7:965c:65f1 with SMTP id
 q6-20020a67b046000000b003a7965c65f1mr11066288vsh.40.1666371217186; Fri, 21
 Oct 2022 09:53:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net> <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
 <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
 <CAEQ-dAAYRAg-t3ve9RJV-vJhzqMSe7YOw2bwJVJ_vk0BDp7NZw@mail.gmail.com>
 <20221021001405.2uapizqtsj3wxptb@bitfolk.com> <6c31fc94-b70e-88c5-205a-efff32baf594@plouf.fr.eu.org>
 <20221021105107.nhihftkjck74jg6i@bitfolk.com> <CAAMCDec5k2AvTik6SA_3c48pfH+VxAi9cRb4Qj-xpcAAcOpp0g@mail.gmail.com>
 <20221021152433.jeylw7ynkn4iczyj@bitfolk.com>
In-Reply-To: <20221021152433.jeylw7ynkn4iczyj@bitfolk.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 21 Oct 2022 11:53:25 -0500
Message-ID: <CAAMCDefELG5OkaJbX69p2NBOhvhSr3bR3n7a9FYGmmU1-fsv-A@mail.gmail.com>
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

A performance hit or not depends on exactly how high the IO load is.
If the fully redundant array is running at the iops limit for said
devices then any reads suddenly having to be serviced by a single
device will overload the array.   For any IO's that could go to the
2-disk mirror will have to get handled by a single disk now and will
overload that single disk if the IO load is too much.

For the most part the number of devices just increases the IO capacity
(raid-10 performs as a striped raid-1).

Benchmarking it requires knowing detail about the IO load, iops gets
hard to understand when you say have a write cache and have a 4k
blocks that get written and synced at say 100 bytes at at time (400
IOPS to that single block, but will be merged by the write cache.  And
if your defined benchmark differs from your actual load that results
will not be useful for guessing when the real load will break it.  And
if 2 iops are on the same disk track (sequential IO) then if merged
right there will not need to be an expensive seek between them.    And
nothing is write only, a lot of reads of the underlying fs data has to
be done for a write to happen (allocate blocks-bookkeeping-move from
free list, to the file being writtens data), and those reads will be
using the 2 disk mirror that has a failed disk and all reads are now
being handled by a single device.

If you had the total iops and/or sar data from a few minutes when it
was overloading (the LV's, md* sd* devices) for a few minutes you
could probably see it.  Generally it is almost impossible to get the
benchmark "right" such that it will be useful for telling when the
application will overload the disk devices.

I troubleshoot  a lot of DB io load "issues" and said DB's are all
running the same application code, but each has slightly different
underlying workloads and can look significantly different and overload
the underlying disk array in very different ways, depending on either
what the DB is doing wrong, or how the clients is doing queries and/or
defineds their workflows.

The give way is watching the await times, and %util numbers.

On Fri, Oct 21, 2022 at 10:30 AM Andy Smith <andy@strugglers.net> wrote:
>
> Hello,
>
> On Fri, Oct 21, 2022 at 06:51:41AM -0500, Roger Heflin wrote:
> > The original poster needs to get sar or iostat stat to see what the
> > actual io rates are, but if they don't understand what the spinning
> > disk array can do fully redundant and with a disk failed it is not
> > unlikely that the IO load is higher than a can be sustained with a
> > single disk failed.
>
> Though OP is using RAID-10 not RAID-1, and with more than 2 devices
> IIRC. OP wants to check the performance and I agree they should do
> that for both the normal case and the degraded case, but what are we
> expecting *in theory*? For RAID-10 on 4 devices we wouldn't expect
> much performance hit would we? Since a read is striped across 2
> devices and there's a mirror of each so it'll read from the good
> half of the mirror for each read IO.
>
> --
> https://bitfolk.com/ -- No-nonsense VPS hosting
