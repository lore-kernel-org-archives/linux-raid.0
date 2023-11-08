Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739E1C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  8 Nov 2023 00:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjKHAuU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 19:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjKHAuT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 19:50:19 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FCA10FE
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 16:50:17 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-7a66bf80fa3so40767139f.0
        for <linux-raid@vger.kernel.org>; Tue, 07 Nov 2023 16:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brooks-nu.20230601.gappssmtp.com; s=20230601; t=1699404616; x=1700009416; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SI2ISN/jAOKQnFOGBfOj/qSF1h5AzP8XqtGZEsJuOlk=;
        b=D8gMYgRiOsjtu/iZxY0M0MMueYK2VMIk+sZu4cbEtlDHUlDWEcwIfiAKr9hGZ5KlND
         zNBCnBMPpsQ/DVlFrjKkweWuOb/I++xsBqucLLf4ky0jBV89c6r3+pkuae2ZolL+I1zp
         eVG8yRvCsQKPaXUlnrWVjtfnZXu9k2gkf+31uoJHEdgSIKUWzQhqJFh86EVN0Z02mBjO
         OJxGJ0vClbjY3OdyOZa/ukB6r4J0Khi9dp5hJWzkqv/AWWLQhBYoipJM7rl8djHOvUNR
         2mWJYZC6e/HKJB5iofGGw8VERgs9mPHOoQUXVuwYGNWiEKxv0ZdkL+IWBUUF5VIITK9A
         0wZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699404616; x=1700009416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SI2ISN/jAOKQnFOGBfOj/qSF1h5AzP8XqtGZEsJuOlk=;
        b=B1+60f0oiZuGWZsgpDF50Rw9B5y2BkvTAK6Atv/Ia9t01BKCvJiMuJtCMo6mhm9Ng5
         9VVWiK8kUS9J+CgJ5gZThoWDh4nVqmScw87NKwjiSvjw3+WXqS7+U+mHb0w5Cla7SYvt
         af+rUu8PyZLHTWTRrPOvyieytbfNimBk/jEZJ8JEiFZWOxAEbr/bpCV34FeN4st2eGiM
         agJAZQbUxI//W/7kffW+3ltJPrgHPpoScNMmupGkuyXSOaW73qeu8i1ab2ckVzIpnVuQ
         nwd6IOwaUyDT+MbEuIDDn9wjkGi7IamVJWyKe+d4j4/ICJ+lsui5Q/3VZBjkeh2gsLJg
         jPZg==
X-Gm-Message-State: AOJu0Yxtfz8tPdJGBfa9//P9H/St6ST5dmBNgC/BIdJ2Qz6MmZfEIeNg
        1PoGs1NGvF5/OSwxdM25AqCaHU0GELC/gYk4QmkYJ9GzRL2jof3F5/TGtw==
X-Google-Smtp-Source: AGHT+IE6KcNnzfWMi1iVpLFtjygJ+CCc/0xJ8cpOwh9yc7vA8JzYdljxMzN63KPU9HTnEwSW8tq3CIvFPrYeg1Z+GfE=
X-Received: by 2002:a05:6602:b93:b0:79f:a8c2:290d with SMTP id
 fm19-20020a0566020b9300b0079fa8c2290dmr619376iob.0.1699404616317; Tue, 07 Nov
 2023 16:50:16 -0800 (PST)
MIME-Version: 1.0
References: <CAE1wYva7ArH+=okXPWBG7r7EYj-3_Ph3OM3OXHvGLEHOp+tK-A@mail.gmail.com>
 <25930.43920.984399.596968@petal.ty.sabi.co.uk>
In-Reply-To: <25930.43920.984399.596968@petal.ty.sabi.co.uk>
From:   Lane Brooks <lane@brooks.nu>
Date:   Tue, 7 Nov 2023 17:50:04 -0700
Message-ID: <CAE1wYvbzPzUzzRcBdSDZeEja2Q99XUxdGZZ0au9hrtibpyCuCA@mail.gmail.com>
Subject: Re: Issues restoring a degraded array
To:     Peter Grandi <pg@mdraid.list.sabi.co.uk>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From the feedback from HTH, I realized I had never checked the system
logs. In there, I saw:

md: sdi does not have a valid v1.2 superblock, not importing

After googling that, I found a stack overflow answer:
https://unix.stackexchange.com/questions/324313/md-raid5-no-valid-superbloc=
k-but-mdadm-examine-says-everything-is-fine

Combining that with the suggestions from Peter, I added
--update=3Ddevicesize to the assemble command and my array is back
together... no corruption or loss. It's rebuilding as we speak.
Amazing. Here is the command I ran in case it helps anyone else:
mdadm --assemble --force --verbose --update=3Ddevicesize /dev/md0
/dev/sda[abcdefghiml]

And just to be clear, it did not work without the --update=3Ddevicesize
as I tried that initially.

Thanks for your help. I'm feeling great now.

Lane

On Tue, Nov 7, 2023 at 2:26=E2=80=AFPM Peter Grandi <pg@mdraid.list.sabi.co=
.uk> wrote:
>
> > I have a 14 drive RAID5 array with 1 spare.
>
> Very brave!
>
> > Each drive is a 2TB SSD. One of the drives failed. I replaced
> > it, and while it was rebuilding, one of the original drives
> > experienced some read errors and seems to have been marked
> > bad. I have since cloned that drive (first using dd and the
> > nddrescue), and it clones without any read errors.
>
> So one drive is mostly missing and one drive (the cloned one) is
> behind on event count.
>
> > But now when I run the 'mdadm --assemble --scan' command, I get:
> > mdadm: failed to add /dev/sdi to /dev/md/0: Invalid argument
> > mdadm: /dev/md/0 assembled from 12 drives and 1 spare - not enough to
> > start the array while not clean - consider --force
> > mdadm: No arrays foudn in config file or automatically
>
> The MD RAID wiki has a similar suggestion:
>
>   https://raid.wiki.kernel.org/index.php/Assemble_Run
>
>   "The problem with replacing a dying drive with an incomplete
>   ddrescue copy, is that the raid has no way of knowing which
>   blocks failed to copy, and no way of reconstructing them even
>   if it did. In other words, random blocks will return garbage
>   (probably in the form of a block of nulls) in response to a
>   read request.
>
>   Either way, now forcibly assemble the array using the drives
>   with the highest event count, and the drive that failed most
>   recently, to bring the array up in degraded mode.
>
>     mdadm --force --assemble /dev/mdN /dev/sd[XYZ]1"
>
>
> Note that the suggestion does not use '--scan'.
>
>   "If you are lucky, the missing writes are unimportant. If you
>   are happy with the health of your drives, now add a new drive
>   to restore redundancy.
>
>     mdadm /dev/mdN --add /dev/sdW1
>
>   and do a filesystem check fsck to try and find the inevitable
>   corruption."
