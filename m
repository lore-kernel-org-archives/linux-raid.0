Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FF2C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  6 May 2022 10:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391048AbiEFKqY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 May 2022 06:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiEFKqX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 May 2022 06:46:23 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C998A65402
        for <linux-raid@vger.kernel.org>; Fri,  6 May 2022 03:42:40 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso6628892wma.0
        for <linux-raid@vger.kernel.org>; Fri, 06 May 2022 03:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jstephenson-me.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ZVgBJCiAwlAjZZYxKqnSoFMko549nxt+0Pz8kg/AF/A=;
        b=IUWWKEyj5xtMIhveTL4kXDU5mo97hURDw1EK967DeuQvDgVnqCHoLR+ELz3p6JHPBR
         BiR1ryN4Nms1V/tV8jhwwT4LuHrw39GVZcVEZC+BMBZhzNPIdkepluZ4M22V2UyGvChA
         O1beOsMuH2lQsyagd5Uz/eCjG2pE9rORKpiZAAKF5dTfkb5MYaI5qxcjhRwJCFtxRMEz
         kVkMt67NqKn1PvxuOjBGJH+JVYYDxkIozRETMLzEWo+aVDXwa9mkfujJYkKU/QTT8dpH
         /H4Ch3goixNMBxM3G+WUJGvdwmRMX68SP9HIXKhhed8KV6V/6unp9zAKAbKLlwE1pedr
         B1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ZVgBJCiAwlAjZZYxKqnSoFMko549nxt+0Pz8kg/AF/A=;
        b=OzrnCrftlmx6E76/SBYQ+3ko9ct6kiFj/fHRnwY53tCwoeEDha48I3v75H3LUyGOF2
         i4d8OczBzxvjcIfz9CX6zOPbwjJIUBW1d+RCjzdZQxzPxbO6kZ3E269u4F3OmE6tPbS3
         DA38i66foQMG9+Jd8kK7opcny5Pl6BjT6GN8XfgAEuCxcf6UyU8Gw9CWmRAUM5VveXUx
         1yvUsyjnc54HjUBjqcVxjm47ATefEs9oU42CIzI/WkacONwhTzeH05MLfowPSGrZBYym
         mhjKfztqVaTh4ur/20VEq9riLqd4sCdba5Vonb8LulShCsy3mqe0Yv+o55d1I/J9k6K7
         x4fQ==
X-Gm-Message-State: AOAM5305gEK2iQddcEZWyRfKZr7QDgueXUUu852eTC54BQB2wUN+LoB/
        R+sZes9W3to08k/NFYUW5n+mp0plJQU9su6mCAb3G/pSneGI4A==
X-Google-Smtp-Source: ABdhPJz/hkIWmV2Xmced0N7P6csIE/KkvvfSZgVQsgcIQi+QiPDHrWAcvSPBMPJ5xopy0SJVbKYZVlp3T0vabotsTz8=
X-Received: by 2002:a7b:cb8f:0:b0:394:30b5:edab with SMTP id
 m15-20020a7bcb8f000000b0039430b5edabmr2699051wmi.148.1651833758335; Fri, 06
 May 2022 03:42:38 -0700 (PDT)
MIME-Version: 1.0
From:   James Stephenson <inbox@jstephenson.me>
Date:   Fri, 6 May 2022 11:42:27 +0100
Message-ID: <CA+an+MoM_Vb4Z3FSRcTo+ykmFTW5cwh1CQWCN9BMT45CdW_P0g@mail.gmail.com>
Subject: Unable to add journal device to RAID 6 array
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

First time using this (and indeed any) mailing list, so apologies if I
violate any etiquette I'm not aware of!

I'm trying to add a write-back journal device to an existing RAID 6
array, and it's proving difficult. Essentially I did this:

1. Put the array in read-only
2. Attempt to add a journal device to the array
3. md said no because the array has a bitmap
4. I tried to remove the bitmap, and it said no: 'md: couldn't update
array info. -16'
5. I rebooted
6. The array wouldn't start, and to my surprise was listed as having a
journal device. Here's what it looked like:
https://gist.github.com/jstephenson/1db2008c4243c2539d029f1f4706dc14
7. It was _very_ unhappy, and refused to do anything: 'md/raid:md126:
array cannot have both journal and bitmap'
8. The only thing I could do was to zero the superblock on the journal
device, and then fortunately everything assemble again nicely (with
bitmap still in place)

So, after a bit of messing around the array is back to where I
started=E2=80=94RAID 6 with internal bitmap. However, I still cannot remove
its bitmap.

1. sudo mdadm --grow /dev/md126 --bitmap=3Dnone
2. md: couldn't update array info. -16

I would greatly appreciate any thoughts on why this might be.

Kernel 5.10.106, mdadm 4.1

Thanks,

James
