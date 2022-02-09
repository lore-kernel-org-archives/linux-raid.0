Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64EFC433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 13:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiBINCn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 08:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiBINCm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 08:02:42 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F85C0613CA
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 05:02:46 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id fh9so1684151qvb.1
        for <linux-raid@vger.kernel.org>; Wed, 09 Feb 2022 05:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D9Z083AQCLOh1iSNxV9Hsu022fNinTTUoMwtb4oy1qM=;
        b=BqK8UlGTp9SvMruyUd4cbSmd6fwQMrFIKoiTdSuvj2H+jyrhr7Kw88E8TbR4XlwuhK
         ipK1oxuEXWh//0BqxreiwTxauhykv+tSbLs9JZLF/TY/HJTs9zUoo8g17JfHDlEbXWgD
         4azjHk7crq2iTF9bfv7OxI/2iy89sX6+YyQJ/HpvE9CJlreFluOE9a3ByVIRYI97UVpc
         dCuWblOV1PrQGCmGCZRyIzkM1ei/ATvfj0BlmQ25EBfnTXyggf2SjWDe2z0C1Iv96Lby
         xje0XZyzFhJcTYCmuYg9n6HK31Ve9U3z3NQi5NcXQYiwrNJ+9xQ5CDyIycaLdsWoQ6Lm
         9JDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D9Z083AQCLOh1iSNxV9Hsu022fNinTTUoMwtb4oy1qM=;
        b=3IcPiQGqMV5drtCM7N2F+dv43WwgKMBmzXb7J1UPEo5ACFz0SQ6QH6hswrmQRweU18
         +1uFIfxY5GkUfaCsMqgBZY1MfaaeSqhzkmiSiTn7I3++LvjylI/yUiPkMazEXFSpMZ+R
         U+jUDvXQVpxVZZ06xy7Mwv3VSOKD9NP1uEojSLIeKKhAJtbx6knz3YGXq9fEMLo6BMgM
         13JVlDITXPym8pWtMdYqIYEE/xDHu6GUOkDbg/bdYdY7FX1E5KAZBPl/Rh1njuTY4Ogc
         gXMKPoaBZLA4TAj630Fko2PeO1R1SxXX6g6hu7aAYVcRcIlnTgXUGDOrrKnFpgChJxdY
         INpg==
X-Gm-Message-State: AOAM531ioqZLx9Bob0+E1Q4aRTmtWN3wjlY/yGHS4ZJawxBOJRDuAzrR
        OWXiWwbd2Pmoah8ekiszriCz15DE4SYDEDZc0pt3XqN+
X-Google-Smtp-Source: ABdhPJwQz1efYdAgmLe3QrU7pfQVvGleZziVly6Fr3Wz5IT2A4ddqRQprveRpM2U1kmEPYM+YlFuHzmgbBHJXVcRuKs=
X-Received: by 2002:ad4:5ca5:: with SMTP id q5mr1368408qvh.75.1644411765072;
 Wed, 09 Feb 2022 05:02:45 -0800 (PST)
MIME-Version: 1.0
References: <20220207152648.42dd311a@falcon.sitarc.ca>
In-Reply-To: <20220207152648.42dd311a@falcon.sitarc.ca>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 9 Feb 2022 07:02:45 -0600
Message-ID: <CAAMCDed4hGHUTLDKo2JxNwMmEhAk35OHeR0MPKPG7OTNfFVg-w@mail.gmail.com>
Subject: Re: Replacing all disks in a an array as a preventative measure
 before failing.
To:     Red Wil <redwil@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 9, 2022 at 3:12 AM Red Wil <redwil@gmail.com> wrote:
>
> Hello,
>
> It started as the subject said:
>  - goal was to replace all 10 disks in a R6
>  - context and perceived constraints
>    - soft raid (no imsm and or ddl containers)
>    - multiple disk partition. partitions across 10 disks formed R6
>    - downtime not an issue
>    - minimize the number of commands
>    - minimize disks stress
>    - reduce the time spent with this process
>    - difficult to add 10 spares at once in the rig
>    - after a reshape/grow from 6 to 10 disks offset of data in raid
>      members was all over the place from cca 10ksect to 200ksect
>
> Approaches/solutions and critique
>  1- add one by one a 'spare' and 'replace' raid member
>   critique:
>   - seem to me long and tedious process
>   - cannot/will not run in parallel
>  2- add all the spares at once and perform 'replace' on members
>   critique
>   - just tedious - lots of cli commands which can be prone to mistakes.
>  next ones assume I have all the 'spares' in the rig
>  3- create new arrays on spares, fresh fs and copy data.
>  4- dd/ddrescue copy each drive to a new one. Advantage can be done one
>  by one or in parallel. less commands in the terminal.
>
> In the end I decided I will use route (3).
>  - flexibility on creation
>  - copy only what I need
>  - old array is a sort of backup
>

When I did mine I did a combination of 3 and 2.  I bought new disks
that were 2x the size of the devices in the original array, and
partitioned those new disks with partition the correct size for the
old array.  I used 2 of new disks to remove 2 disks that were not
behaving, and I used another new disk to replace a 3rd original device
that was behaving just fine.  I used the 3rd device I replaced to add
to the 3 new disk partitions and created a 4 disk raid6 (3 new + 1
old/replaced device) and rearranged a subset of files from the
original array to its own mount point on the new array.
