Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5DFC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 18 May 2022 10:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbiERKvq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 May 2022 06:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbiERKvo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 May 2022 06:51:44 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2773517E5
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 03:51:40 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id y32so2911899lfa.6
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 03:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ANawzlUCoSJEuK6DLlpl9q1LujzNi0TzK2AIexWjEIQ=;
        b=PIL0wu72MF+Z34c8dKJ9AjxihQ9l0e6Jr08xK1irgX49gPsCYspYE0t9dohzG5+aWF
         r2pIxcMLY4nL3ypsFsHomIz+vPMdlhmc5SzpWOwwCIhxs2BhX4LAOaOBPOj7rKHygCF0
         QAeANYaHlBJR1gwzDbudsGiZgaVvSD82/eYJYC3VqZRNLnG7jR01ffU8N0zfvV/54kvh
         2iHcyUgSqkjvUnjqm/RF+7TQFKbeU0Pd5oXy9SdicsYMqlBijDrvaALpfGT4f/hrE4mI
         EMOIGat0Rwefhv99Zr6GnAOdqO5ct406bpd0wF1F6ZqFzIBKbvJU24rUirhVjsUZQ98N
         gv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ANawzlUCoSJEuK6DLlpl9q1LujzNi0TzK2AIexWjEIQ=;
        b=pvS+4zbh1mUzqHH+NKT7LpVhPLI9CDEoR91kjTfY3IOCl/8KtWiReTlQuDfCMyhxqf
         mTOzkn1VNQtnQkUxBB6aUIXVU02IGQIUO6YBs/LTE4JAmLkQVMUaVUOS+Se2r5MVuYgF
         UoLEsNIMixmY96tsTuJXF3B+ATKflvFwbNtvzcrpTgOA63XVXTrq1uBKHP+Oflm5+i/G
         UjzZ+RFeFcFKpHMoqIKLv7gzhPNDR4VdeBB+pzutSty+o6EcWi5h65BhNVtGV3Sewy8h
         ObmVRyAsM/tHlVTXt+qjeaYvZSNf71aPLddfIA/YjKZs1Fs7iy0MnAyTcz5mgE+5pMwk
         daxA==
X-Gm-Message-State: AOAM530AYh24lQY/SczV02dltg3ivdekhuQiAEiQZohywXz6WF1ZUBDu
        RtkOMvSAUrt9SdObhnm/l5aOpcBQKDY7FNCYzEZHYrXnLJU=
X-Google-Smtp-Source: ABdhPJxogee5hOXVQQhyXGJH+5Nkh5OW7+OV26lWyT0L47EB5mfBOe1yTOhRgzOPkR57Xg99s6PRIlcp6GamS53Aofk=
X-Received: by 2002:a05:6512:20cc:b0:471:f6fb:dac9 with SMTP id
 u12-20020a05651220cc00b00471f6fbdac9mr19926931lfr.475.1652871098836; Wed, 18
 May 2022 03:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
 <Yn6BEym8s0kVLhD0@lazy.lzy> <994cb384-3782-dac2-898b-ea02816a904f@youngman.org.uk>
In-Reply-To: <994cb384-3782-dac2-898b-ea02816a904f@youngman.org.uk>
From:   Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date:   Wed, 18 May 2022 12:51:27 +0200
Message-ID: <CAJH6TXgKFCs+OTeZP5zV9D_19ymYQ+Gg2OXVpXBj7hFVkmnFeA@mail.gmail.com>
Subject: Re: failed sector detected but disk still active ?
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Il giorno sab 14 mag 2022 alle ore 15:46 Wols Lists
<antlists@youngman.org.uk> ha scritto:
> Correct. If the underlying disk returns an error, raid recovery kicks
> in. The missing block is calculated, returned to the caller and written
> back to the disk.

but in this case i would expect md to log something somewhere,
not a total silence.

> The error message is "critical medium error" - we have a real problem
> with the disk I suspect.
>
> FIRST run SMART on the disk and see what that reports. If that's not
> happy, REPLACE THE DRIVE PRONTO.
>
> If SMART is happy, run a raid scrub.

When this happens, i'll replace drives ASAP, it doesn't matter if it's
a transient failure or similar.
A working disk, for me, is a disk that NEVER returns any kind of
issue. Usually I replace disks even
when there is a single recovered sector.

> And whatever, if you haven't replaced the drive, start monitoring SMART.
> If disk errors start climbing, that's a cause for concern and replacing
> the drive.

All disks are under smart monitoring with both short and long tests
(weekly) and also weekly (or monthly?  I don't remember) md
consistency check

Anyway, as our new servers has some free slots (we keep free slots
with intentions) out replacements doesn't
mean to remove the old drive (loosing part of redundancy) and then
adding a new one, but we always use a replace:
mdadm /dev/md0 --add /dev/NEW --replace /dev/OLD --with /dev/NEW
it's MUCH safer, but what happens in case of /dev/OLD failure during
the replacement ? the rebuild will be done reading from other drivers
transparently ?
And normally, reads are done FROM old in this case or from the full array ?
