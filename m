Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56B5C41604
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 19:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2AEB20760
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 19:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEloznks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgJFT5X (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 15:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgJFT5W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 15:57:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC7AC0613D2
        for <linux-raid@vger.kernel.org>; Tue,  6 Oct 2020 12:57:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id i3so2128304pjz.4
        for <linux-raid@vger.kernel.org>; Tue, 06 Oct 2020 12:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0TlD0kJRp+U8+Y27vNDgURU9ps41ekIpSRVul74ZOs=;
        b=FEloznksgGy8eyzErrNjb9xsxn9FLy3jSO2HH7C8hgaHLe9Qd1RvhrWuIbTVnR1MjS
         hngZKJkMiQ0tEKxqE9WMlgE9QX3gle7T5r0M0oMW+kZkwqxZxAjX0ihN5fCJw2pQ8Koi
         bmuLZlckAsy8TET4rE8xF1WqlsScUWDlysnxCBHSI85v3X8+uwDi4fsUcJ36xxe+NqxJ
         vvfQthFGXHbsUn4oqHzVoMFaFg5RYzzy4q1/w0IZgNtpQqhLz0w0lHK8Jzw5wpLpPYSf
         NsiRr+ipvMZTjx9cOFT/be61B54UreCiBOaRm85oJFPPKxI0tgq+9U2+NG3WP67jLbqp
         tH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I0TlD0kJRp+U8+Y27vNDgURU9ps41ekIpSRVul74ZOs=;
        b=S0N8z9PA0kOHZbQPPd2my++gBd1YffCPqUSxIv/2sRbNlzuKN2zCC8GW4xT0n/CIto
         6i4qOXvb1RAAoQKAVxiAqHyMEvIenr7iyNbk3JoIU0cA8Tbyc0sKtjdXwfadNiyp/0Ib
         F2bAm+I/r5LEX3j5iWKNljXBCARiOtRL4oJlCiwazl/3ngfZI38dhmGgECjA8au/POlh
         Zhp5h65MWH4Y1PtrFNrgVHzUR2y9dlVNUNOAx1wPqlse1/ebNAqWdfSfb9ec6XEhHJih
         QRgX504hfcw/Wm7ITr3CAZvB5W43C5jPTNXujpu5Fqd7I0DRg7XIjIvzLK7x/kRQHg9n
         rtCQ==
X-Gm-Message-State: AOAM530czN6tIDp9P31FRVq3qhkLZtyIz+4+vrZ63wRs/OR6NbSL+Crh
        CmgTQxEcp9hnIjT8Sv6LZMTegagZeiwwCdxsJHPloBSb
X-Google-Smtp-Source: ABdhPJzE9EchYEG91qiAdNXrcMqFCOJAK2HzMHlrgqRVjooHf7I93Aybjony4juD4fQVBjDIXB6uRLgEm0Sfu1d1d9w=
X-Received: by 2002:a17:902:bd8e:b029:d2:ad1a:f477 with SMTP id
 q14-20020a170902bd8eb02900d2ad1af477mr4669068pls.40.1602014241514; Tue, 06
 Oct 2020 12:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <CADzwnhXJBRuCNPsGhPHt-h1J3MU2HmH3_ZWkxW_auJ7FQyqJ0w@mail.gmail.com>
In-Reply-To: <CADzwnhXJBRuCNPsGhPHt-h1J3MU2HmH3_ZWkxW_auJ7FQyqJ0w@mail.gmail.com>
From:   Mark Wagner <carnildo@gmail.com>
Date:   Tue, 6 Oct 2020 12:57:10 -0700
Message-ID: <CAA04aRQwR2J90fb1QUf1cpXsyvwbmrqVZnOT41JE7mLtvyYYOw@mail.gmail.com>
Subject: Re: Need Help with Corrupted RAID6 Array
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc:     Kenneth Emerson <kenneth.emerson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Oct 6, 2020 at 4:06 AM Kenneth Emerson
<kenneth.emerson@gmail.com> wrote:
>
> It's been several years since I asked and received help on this list.
> Once again, I find myself in a bind.  I have accidentally destroyed
> one of my disks in a set of 5 4-TB drives set as RAID6. When I
> rebooted 2 of the three arrays rebuilt correctly; however, the third
> (largest and most important) would not assemble.  I thought, even
> though I had lost one drive, I could rebuild the array by substituting
> a new, partitioned drive but I cannot get the array to start.

> root@MythTV:/home/ken# mdadm --examine /dev/sdb4
> /dev/sdb4:

>      Raid Level : raid6
>    Raid Devices : 7

>      Array Size : 13165485120 (12555.59 GiB 13481.46 GB)
>   Used Dev Size : 5266194048 (2511.12 GiB 2696.29 GB)

>    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

You say this is a five-disk RAID-6 array, but the disk metadata says,
in three different ways, that this is a seven-disk array.  Do you have
any idea what could be causing this discrepancy?

-- 
Mark
