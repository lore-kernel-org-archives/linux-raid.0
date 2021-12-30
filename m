Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2E6C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 30 Dec 2021 21:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242193AbhL3VlP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Dec 2021 16:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242191AbhL3VlP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 30 Dec 2021 16:41:15 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEBDC061574
        for <linux-raid@vger.kernel.org>; Thu, 30 Dec 2021 13:41:15 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e202so32974691ybf.4
        for <linux-raid@vger.kernel.org>; Thu, 30 Dec 2021 13:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mU9QCxP8EZ/FrlvyFXOh6+zS+kOIuM++UDwDYPuGu3I=;
        b=yCaN1g4T23HfGjucvDitFY5gSgmkLeCWk6blLBZUv8jcd9NF/bWa2uEYN2AzCuHRT/
         /fBmQcda54Vi8s3WCzeLDQB8TDGFXSJrJ5V72ladCmHus1bhRcoiwQoLa+wVWy9C9bk9
         YP/kpdyuSv9ES2S47Tnwv8eQ3NbI6po3MHRSlnVcO8MCFKZtL96IHe1jHq3woKCkje3E
         5E7Bxxnsq9FLgPhkNmRsNtW2WN1wzgSm5Oo5qet7C4pS8hIbe5g1MaHkBjQp6ejwdZxb
         7LYCBid/6ixQG7YIEbE/Y1uwOY8dWJsp3pz20flow7aApHjT0j5y7okUzAzHLzB1xrcV
         m+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mU9QCxP8EZ/FrlvyFXOh6+zS+kOIuM++UDwDYPuGu3I=;
        b=ciolSKXn/8H2ZdMGD0zn/QXyfG/ZPCExNIsQ7Ds85Xa8yCZaFDCTZ5oO6ZMxDcIcSD
         Vx8jJ69kEunzLWCpUGxeoLAuYo7A5sWsHAtl3mfPkmPF6G3a7frEdG9pVjqpYQMFI0/o
         cCt+RITdfMwEGrBgLwTrAw0TIhoXDClgdZO0W4GVi3K4JTTX53MzRPeyrb300Tu4C9Yj
         tJt3jIVBRKiGQ1FkWD24gnrPUGp2ggxEZVyiywIy9u0CZMUQyrko+g0n7upG4e4ytcxO
         Y/aI/+HK3MTyamsNlOWzR5VAsqDCornv1mL747mwW0Cfpy35HPUkFoQVtkffLLF1Ff88
         8//g==
X-Gm-Message-State: AOAM5311PNvjXiGWZe+DurKMUXeUIFMZN3dVBYmCppf3d5BplCPw1QJ2
        wSI0beBSS8lg81aE8uycHmt1wsOjnqDMAg49OJ0KVZBwLUZlew==
X-Google-Smtp-Source: ABdhPJwLaWe0+mt760ImHWn7Bka+kFoQUGUjldjkbqkm/vCDoJGeYki00jie1ih7G8P0mI+i3blZP0iyqJNGL3Q0A18=
X-Received: by 2002:a25:bd89:: with SMTP id f9mr37955253ybh.618.1640900474431;
 Thu, 30 Dec 2021 13:41:14 -0800 (PST)
MIME-Version: 1.0
References: <28fdbc45-96ca-7cdb-3ced-a5f65d978048@trained-monkey.org>
In-Reply-To: <28fdbc45-96ca-7cdb-3ced-a5f65d978048@trained-monkey.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 30 Dec 2021 14:40:58 -0700
Message-ID: <CAJCQCtQJ6QNxy8hX42UaUuucgCEmTyuScJRs0GbJnGFi-t_S5w@mail.gmail.com>
Subject: Re: ANNOUNCE mdadm-4.2
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

\o/
