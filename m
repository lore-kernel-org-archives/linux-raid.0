Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14210C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 12:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiFWML7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 08:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiFWML4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 08:11:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54854DF7E
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 05:11:55 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id pk21so17508529ejb.2
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 05:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=kOkeZYIP3W0p8kcTEuHwNty9rxZ41WnC7YUbE5kO6Y8=;
        b=H8LFUYkQ8W5UHBt5IjjUo4jPKinKKxem0VogVoJA5/f3E/9a5yemJ6RWnv5xMnNS26
         PjweAlKLsXQy2tZrZV2yBcY06DI0CcWXa4mK0yVpxQfHwCAM+ZIchIJY2F3RoTN+6Nph
         Aesw9O8cEhHVjRmFIvp+wdJG2L4Hz/uD2lRCaCRDLgo2pgxjM0nNXyddsVlOWAvxA40C
         QDEFFFPl/8YVAGobmZlne80Azum3bPILP8nGy/fRIAaABxUHIWrBYbTQYcHlYgEWbD69
         wOWhf+PcZGMnogi5TPbSfqtzfpl3dgR8wql3mVDZMU2IJHw0nlmY0CraADphXap2pxCB
         45GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kOkeZYIP3W0p8kcTEuHwNty9rxZ41WnC7YUbE5kO6Y8=;
        b=w837er8QfMIK7udAY3mw5Zi/u0bV1nIXq4maJCDYaPesRWOeSwfkcDC9AGv+L9DZ9d
         8IIxv0Blu+eBnTS+NunUdhW+fAoYlUI995Mdh282l5zK4Cgj5g5n5fwjEius040WQQL4
         s2Scsrp5SkAwLtCoAfyBA/J+Jf5jUIeluotN/o+aLbMFUJ8PpwEXEuICtOPS+a1hzKJD
         eezmazaFOQrfS/A2FEiHUnIlkPczd3Gpicy/8B8uR4rdQNh5O/3OGsyC5P/N4brkCANu
         wEdzzP446u2pA+GBajJfxO2hz/rv1aYUFuGeZZgjNHj4fLZEcOlU9Gt1G1eYldE4rOsf
         nUBA==
X-Gm-Message-State: AJIora+hl9zuE1SzWwVqRM3FSBSmgG5D94itdFGHa1zbhIXdiTZnX6Ar
        xEnx85Vso8aPAMKOuXnlkoJ4gMgU+m09W7+ZUml6nu1L8BY=
X-Google-Smtp-Source: AGRyM1uZBl5UUaq2a1fwsRwDOUcYdyc6EtDO874JHITX3cX8BR8VgWtCi3hvTs3NaYxQvwPK+ocOwcKC/ofoj3I3UCE=
X-Received: by 2002:a17:907:7209:b0:722:e549:bce7 with SMTP id
 dr9-20020a170907720900b00722e549bce7mr7679096ejc.609.1655986314043; Thu, 23
 Jun 2022 05:11:54 -0700 (PDT)
MIME-Version: 1.0
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Thu, 23 Jun 2022 07:11:17 -0500
Message-ID: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
Subject: a new install - - - putting the system on raid
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Greetings

https://raid.wiki.kernel.org/index.php/SATA_RAID_Boot_Recipe

Found the above recipe - - - the preface there is that this is
an existing system.

I am wanting to have all of /efi/boot, /, swap, /tmp, /var, /usr and
/usr/local on one raid-1 array and a second array for /home - - -
on a new install.

I have tried the following:

1. make large partition on each drive
2. set up raid array (2 separate arrays)
3. unable to place partitions on arrays

1. set up the same partitions on each set of drives
    (did allocate unused space between each partition)
2. was only allowed one partition from each drive for the array

Neither option seems able to give me what I want.
(More security - - - less likely to lose both drives (2 M2s and 2 SSDs).)

Is my only option to set up the arrays and then use LVM2 on top?
(One more point of failure so would rather not.)

Is there another option somewhat like the method outlined above - - -
recipe is some over 10 years old - - - or is this the only way to do things?

Please advise.

TIA
