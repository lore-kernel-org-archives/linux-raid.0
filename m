Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6510C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Mar 2022 09:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345388AbiCHJmR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 04:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237159AbiCHJmQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 04:42:16 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0068931511
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 01:41:19 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id j26so17137840wrb.1
        for <linux-raid@vger.kernel.org>; Tue, 08 Mar 2022 01:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=jrNNpWlY0stgMR4quabXg7igmoHPmedwMyUXaBM7TZ4=;
        b=bUPTeTCWMUNbZiVpTV3ySj27HasaXAPEonSBbYlnb2/o5zfhLnxeMkxyKedcmY0JzP
         ThJX/kceldj/k+o/Uqg71Krwdxj/Q86al5qI1Sr6dvOAcJCa4PGYY9H7I4RIQFJZXWOe
         a5dI7ODOthkcmdQ+4+2Z0mg5/RdvfdUxZALAqe8EKOm3o0AYW+TJEwfoSNdjRHGqYO9Q
         aTGUoOR8MRXv5uaiS+kF+ja/1Yue27SVFbGMqsf41KmQ4Y5/3iZ8E5WwtFjhwYreBnrQ
         2jMf0AIBsVKEACcZo0WGzyc9tgu90N/XfGd2DNU3m0ZsPVF64C1A2C7NZNwpRDyOwA9v
         lnjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=jrNNpWlY0stgMR4quabXg7igmoHPmedwMyUXaBM7TZ4=;
        b=FfxIBtOomId5JYpb34I3sLkUz1raVfCCWSK/RcbCzvIO7K8dkj+tVeF6FQS8/2gYaU
         jymVUbPezYkzGgYu/9fOX0gdhdsbQHwF5M+6WWIqhWWTqPqV0KzQlXLut+CzBtfE7oI0
         v23WP/SxxGEV8t069g6+nlBVHXIFNJ7DenPbnknuwuxg9bUR2gGgTFJJNO4LxjbI58eL
         VZWw1yrC+w9iB8QZefmUZOsmjoJUKSXvLqTTrV/kG7C3O2ytU8TuVibT1UAEGC7LXqs/
         splrvEf8r38xHoK8+0qIYwY0R6Fn4e5C09OfWzZCPXz63CT7YrcAw472rvyXweGBunjR
         S40A==
X-Gm-Message-State: AOAM5316bmz++LU60rdzLpBARkdSWSXvRFB7b4LW6ldU6qV3pGgAT/sm
        uciPCobVdVyZNqxGwkW6/MB34OVRvqs=
X-Google-Smtp-Source: ABdhPJzymZ+8XinX+gGfmkEwincNU36hSYMqFoK+y8Ucg0LW9FCBe//zn3Jsa239x1iR2QhwnGF4YA==
X-Received: by 2002:adf:ab09:0:b0:1f0:1208:5123 with SMTP id q9-20020adfab09000000b001f012085123mr11367270wrc.146.1646732478406;
        Tue, 08 Mar 2022 01:41:18 -0800 (PST)
Received: from www.Debian-Testing-WilsonJTR4 ([213.31.80.52])
        by smtp.gmail.com with ESMTPSA id o11-20020adf9d4b000000b001f0077ea337sm13897118wre.22.2022.03.08.01.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 01:41:18 -0800 (PST)
Message-ID: <1da6073c37b772a7171504272030af642e72b1d1.camel@gmail.com>
Subject: Re: Raid6 check performance regression 5.15 -> 5.16
From:   Wilson Jonathan <i400sjon@gmail.com>
To:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        linux-raid <linux-raid@vger.kernel.org>
Date:   Tue, 08 Mar 2022 09:41:17 +0000
In-Reply-To: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
References: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.43.2-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 2022-03-07 at 13:15 -0500, Larkin Lowrey wrote:
> I am seeing a 'check' speed regression between kernels 5.15 and 5.16.
> One host with a 20 drive array went from 170MB/s to 11MB/s. Another
> host=20
> with a 15 drive array went from 180MB/s to 43MB/s. In both cases the=20
> arrays are almost completely idle. I can flip between the two kernels
> with no other changes and observe the performance changes.

I am also seeing a huge slowdown on Debian using 5.16.0-3-amd64.
Normally my monthly scrub would take from 1am till about 10am.

This was a consistent timing which its been doing for close to two
years without fail. The check speed would start in the 130MB-ish range
and eventually slow to about 90MB-ish the closer to finishing it got.
The disks are WD RED's (the non-dodgy ones) WDC WD40EFRX-68N32N0 and
there are 6 of them in raid6 (no spares). There are no abnormal
smartctl figures (such as RRER, MZER, etc.) showing so its not one
starting to fail.

The current speed is now down to 54,851K with at least 4 hours to go
and has been running from 8PM to 9AM already (I kicked it off manually
last night as I could see it was going to take forever at the weekend
and granddaughter doesn't deal with "its going slow" very well so I
killed it).

The problem is not limited to hard drives. I also run 3
arrays/partitions on NVME (set up as 3 drives, one spare, raid10-far2
which are used for /, /var, *swap) which instead of taking about 2 mins
are taking in excess of 10 mins to complete.

Before running the current mdadm check(s) the kernel was upgraded. I
try to apt-get update, apt-get dist-upgrade at the weekend but some
times forget so I can't tell if a check was run under the previous
version or a version prior to that... The previous version was 5.16.0-
3-amd64 which as far as I can tell had no issues (I tend access my
computer around 9 on a Sunday and get hit once a month by programs
"hanging"/being slow which reminds me to check if a mdadm check is
running, cat /proc/mdstat, which it usually is and it usually tells me
that I should be fine by 10-ish (I do the mins/60).

In the time its taken me to type this, and run commands to check
figures etc, and then check it and amend things (about 30-40 mins) the
speed is now down to 52,187K. I'm going to let it finish as I don't
like the idea of not having the monthly scrub complete, but boy does it
suck when I can see it getting much slower than usual the closer it
gets to finishing.

>=20
> Is this a known issue?

Well you and me makes two noticing an issue so...

>=20
> --Larkin

Jon.
