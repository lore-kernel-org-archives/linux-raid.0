Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8206FEB64D9
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 17:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbjFORVF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjFORVE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 13:21:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC2E2710
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 10:21:03 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-51873d9a75dso2148780a12.1
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 10:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686849661; x=1689441661;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=89OWlLb12qF4fu/WDUODGipsVfSvG5X9eqNDSpK+tao=;
        b=R9lB7sIXEXbfafv/0Vz/9pmP9CWyFpFCJveuzij098xVAC41/U4/w4ZImNI4d4oSZw
         EGYfWeHwV3BIFPCz6bV4J8mbqZDopnZDGCJf9kgsFW3LyTB3udBIFWTlLvdUCkJsPj8f
         4EOQvrtUdB0OkP9ZTZ3Sle0aVz4JEiH43YC5fXsOsasRXoykab590E2u/Nkxe9AcbUv3
         fgMRYYSY7piBwIqoLlc5rgxfa6Ny3CxVfhWpBZPUynhAn5mqxDPwoMFyP5ZAaLox0840
         wNWvWGXf89Ff7FB3PLjKlCRR+/J/tQx/ZgTm+qvDbBf3goZr99hYpnkugdZJihZMP/50
         9o6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686849661; x=1689441661;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=89OWlLb12qF4fu/WDUODGipsVfSvG5X9eqNDSpK+tao=;
        b=dGOpswlzbpZKE9zhGqE9r5Vc+utdkocyHN4AbJRVQDHoutXNacBOl+FBj7IEOwErzc
         hbRv23HxwrExQbGCkp6hYddCTR5OotA7aXn0Ch9wr6XQh1Qy8hDJfjjNA9072FsaKkCf
         OrjRo8CYhXNEP4U8PX6AS8F8QvUjKDvRSnjZoHYxE2xDLr408vIKpXopUxrVT5nfp47E
         eSB43JYj17Qwx61ofuFV/TiIYCbWr4ov4ruzNGhMBqbyPOs8dUmZvE+s6lJMzvze9wEL
         GjtTYwzTJ8qnLzKK8ZAy5eV6ICcK80MYxsPgq0DUdeuUMj5UaL1XBCBDjT2E8AKWfVKX
         HR6Q==
X-Gm-Message-State: AC+VfDw5sQ48W9VcRckiDfKUZYuR8ESPKHifD5K7yAXFuKFxrBvPXp2V
        4OtyIx3JWJhdH/43PYvNwnqIhweFTxM=
X-Google-Smtp-Source: ACHHUZ7ZtDwrVQ/rDERJyJJVyqKEl67WGOsUjle4YrrZaDnc7VUSEx3fvmGYuED3ojN3lQGOOlO4bA==
X-Received: by 2002:a05:6402:11d4:b0:516:a279:1c1b with SMTP id j20-20020a05640211d400b00516a2791c1bmr6106060edw.4.1686849660595;
        Thu, 15 Jun 2023 10:21:00 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id u3-20020aa7d543000000b00514bddcb87csm9305559edr.31.2023.06.15.10.20.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Jun 2023 10:20:59 -0700 (PDT)
Date:   Thu, 15 Jun 2023 20:38:32 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231506203832@laper.mirepesht>
In-Reply-To: <CALTww29UZ+WewVrvFDSpONqTHY=TR-Q7tobdRrhsTtXKtXvOBg@mail.gmail.com>
References: <20231506112411@laper.mirepesht>
        <CALTww29UZ+WewVrvFDSpONqTHY=TR-Q7tobdRrhsTtXKtXvOBg@mail.gmail.com>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Xiao Ni <xni@redhat.com> wrote:
> Because it can be reproduced easily in your environment. Can you try
> with the latest upstream kernel? If the problem doesn't exist with
> latest upstream kernel. You can use git bisect to find which patch can
> fix this problem.

I just tried the upstream.  I get almost the same result with 1G ramdisks.

Without RAID (writing to /dev/ram0)
READ:  IOPS=15.8M BW=60.3GiB/s
WRITE: IOPS= 6.8M BW=27.7GiB/s

RAID1 (writing to /dev/md/test)
READ:  IOPS=518K BW=2028MiB/s
WRITE: IOPS=222K BW= 912MiB/s

> > We are actually executing hundreds of VMs on our hosts.  The problem
> > is that when we use RAID1 for our enterprise NVMe disks, the
> > performance degrades very much compared to using them directly; it
> > seems we have the same bottleneck as the test described above.
> 
> So those hundreds VMs run on the raid1, and the raid1 is created with
> nvme disks. What's /proc/mdstat?

At the moment we do not use raid1 due to this performance issue.
Since the machines are in production, I can not change their disk
layout.  If I find the opportunity, I will set up raid1 on real
disks and report the contents of /proc/mdstat.

Thanks,
Ali

