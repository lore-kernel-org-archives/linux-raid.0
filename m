Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93662C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 22 Oct 2021 00:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75FB1610EA
	for <linux-raid@archiver.kernel.org>; Fri, 22 Oct 2021 00:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhJVAkt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Oct 2021 20:40:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231758AbhJVAks (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 21 Oct 2021 20:40:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634863111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFAD2zdQCuYw48MdJBUS0WBhN7xXhYXMR4FaRYIhjIc=;
        b=EwT5bwLbhkrt+Q+LX2Q0pCCHSmT+ivzSvWK2rC2FlIcfTYpWD+fUTSlAtePS3RFN4uZY1c
        ffWYHHwaLMTKb8HQSrBn4sxIdQHkiV1OyBPwfJgLpzKY3y+reIFGBwUqL61nZo+aEB0GcU
        w34qEMgGBBaDzOZ5k9OwjqNHWYBYLrg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-YfmOxIryOgOPqLdIwmJOvg-1; Thu, 21 Oct 2021 20:38:30 -0400
X-MC-Unique: YfmOxIryOgOPqLdIwmJOvg-1
Received: by mail-ed1-f71.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso2059830edj.13
        for <linux-raid@vger.kernel.org>; Thu, 21 Oct 2021 17:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tFAD2zdQCuYw48MdJBUS0WBhN7xXhYXMR4FaRYIhjIc=;
        b=yJZhjBLURyJAV4ergeu80aSSeceWzs4zRxCRZfkyOvQvjxgKdR2zrt/lEK6L8qOloc
         iWJxKn3s3HBrzw8wpDKZeu92aDLbvHTRrVzaWC2YAsLmP9DYlt5RMVDaiJTATs6F5iCv
         Ks8jIRGBlY26z/EbOlI+3HsTKZZy9VK5tTNO6h9Nh19H0inD4veRqg2Hn4lhF6W7NTgM
         tuG7utEs2rCNEpOrMhMq89mL9axpE0Iq4gp/rKCDvfkXP6VtmqYvgraiHgUEk9hnjyZy
         l1F7xY0tN8eM33ssb5YY1yLVhAeIgbl7i0XtJ28eg5Fd/RszLi5FLzpPOxzWJAIiTMMe
         y2gQ==
X-Gm-Message-State: AOAM531ojA3RYOB1KyaFauX42NXJVBG1qJorysiQ8kfOJSXP791lw3U9
        8HIgAVLFvVFbzyBbmRTYg+j5D8gZ4242PIFg9RQqAJSt9o6xbhGJqaq7L2Lbd+j2rTDncI72FA1
        nft0C2Tt3AmOC03wWer5UNtQuOlu1d23VaYhbUw==
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr11482829ejc.239.1634863109178;
        Thu, 21 Oct 2021 17:38:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWpBOWkdXpY00tn7K9yrRLrAD3aCSwFKau+qOfLZVYlNvI35acKf+iGZA4slcscrwp1wEGKh+gXYZXYpaesmc=
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr11482812ejc.239.1634863109019;
 Thu, 21 Oct 2021 17:38:29 -0700 (PDT)
MIME-Version: 1.0
References: <1634740723-5298-1-git-send-email-xni@redhat.com>
 <974e4fc3-f85c-bfa7-176e-a440fbdfc001@linux.intel.com> <CALTww2_3e8-U-s4wkURv=zPATWrKSKcjWgK4EXSV-YtAbMNrkA@mail.gmail.com>
In-Reply-To: <CALTww2_3e8-U-s4wkURv=zPATWrKSKcjWgK4EXSV-YtAbMNrkA@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 22 Oct 2021 08:38:17 +0800
Message-ID: <CALTww28uvQwNUBBVPZ2h6cd5nqxkDnfUGvpw186fGJ0ai1KxVQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, Nigel Croxon <ncroxon@redhat.com>,
        Fine Fan <ffan@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Oct 22, 2021 at 8:09 AM Xiao Ni <xni@redhat.com> wrote:
> >
> > using true/false will require to add #include <stdbool.h>.
> > Jes suggests to use meaningful return values. This is only
> > suggestion so you can ignore it and use 0 and 1.
>
> <stdbool.h> is a c++ header and it needs libstdc++-devel, I don't want
> to include one package only for using true/false.
>
Hi all

Do you think the method is better?

typedef int bool
#define true 1
#define false 0

So we don't need to inlcuce <stdboo.h> and we can use true/false too.
If we include <stdbool.h>, it needs to add the corresponding package in the spec
file too to resolve dependency problems.

Regards
Xiao

