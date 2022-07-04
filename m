Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC3AC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Jul 2022 17:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiGDRlk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Jul 2022 13:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiGDRlk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Jul 2022 13:41:40 -0400
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4300E11A28
        for <linux-raid@vger.kernel.org>; Mon,  4 Jul 2022 10:41:39 -0700 (PDT)
Received: by mail-il1-f177.google.com with SMTP id m14so3181788iln.10
        for <linux-raid@vger.kernel.org>; Mon, 04 Jul 2022 10:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=75A+mg6uylbEXXXVepLSNPpoEj2GgOKN3gDDBD9yMZ4=;
        b=dUGLSGK/wFNRMRh1dI0K/r5IV4/ntlU/2e8Wqo0q7Kqa88nC8EaM7kxif2/6GKSBZm
         NqwAG3lqGvzrwOD9owXDf3nDfiSB+6lgVKOLo7DxauUDfPC0xcu//lpZKfOPYYBpytnx
         voHXrvY9HzdWi5zqPK2dwo5imhQLa3SEDUGQJtuLSaqcJUP7bOFgWF3exDvXBd0QAmro
         8di0TrMdm/Edb+DO2OGa4a5GU+zyLxCMaaPFGON9BfVfAs6qfe4RXN5AC4VXB2fjnDcj
         VTK/qn7VwbOVkLyJbmhI4VVjr8M41vOub8+VPVdlD1UuDMU0xydCxz1uM7F/cNNTxRRC
         6+xg==
X-Gm-Message-State: AJIora+r12mD81EAUB6LfrB4twBmJx5hFL7M8AHZtoY0u4VVZL1meaUp
        E1gkvoRzri0/SVK7Ek7hDCufdyAH7ZjdyuRdZJ++0Z0=
X-Google-Smtp-Source: AGRyM1u/nsDdRU/G6jKA+Y0JmghRRCPn2MhJJ+grL+7JCY+8jZbosYqkpKdNCMCbjd0i8HoHrD+f0NqQ3XA3DeCe0GY=
X-Received: by 2002:a92:c247:0:b0:2db:ec1e:7f8e with SMTP id
 k7-20020a92c247000000b002dbec1e7f8emr10122050ilo.166.1656956498351; Mon, 04
 Jul 2022 10:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ1ZTG5ornHW87Kis8G3aw0N6Ww+7=JEOdeCdwevoMApcVR-NA@mail.gmail.com>
In-Reply-To: <CAJ1ZTG5ornHW87Kis8G3aw0N6Ww+7=JEOdeCdwevoMApcVR-NA@mail.gmail.com>
From:   Von Fugal <von@fugal.net>
Date:   Mon, 4 Jul 2022 11:41:27 -0600
Message-ID: <CAJ1ZTG58jxn8R7_U88sk+nBF=yrO=wdRBU5pua=FL45N6DOT4g@mail.gmail.com>
Subject: Re: Help recovering a RAID5, what seems to be a strange state
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I did get the array to reassemble. It's still strange to me having all
devices removed, but then listed again. Incremental adds always
resulted in the bad state, but what finally assembled the array was
"mdadm -A --force /dev/md51" started from the array stopped and
without any incremental adds.

It's still doing recovery but it looks good. I may follow up on this
thread again if it goes south.

Cheers!

On Sun, Jul 3, 2022 at 3:57 PM Von Fugal <von@fugal.net> wrote:
>
> Tl;Dr version:
> I restored partition tables with different end sectors initially.
> Started raids to ill effect. Restored correct partition tables and
> things seemed OK but degraded until they weren't.
>
> Current state is 3 devices with the same event numbers, but the raid
> is "dirty" and cannot start degraded *and* dirty. I know the array
> initially ran with sd[abd]4 and I added the "missing" sdc4 whence it
> did something strange while attempting to resync.
>
> sdc4 is now a "spare" but cannot be added after an attempted
> incremental run with the other 3. Either way, after trying to run the
> array, the table from 'mdadm -D' looks similar to this:
>
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        -       0        0        1      removed
>        -       0        0        2      removed
>        -       0        0        3      removed
>
>        -       8       52        2      sync   /dev/sdd4
>        -       8       36        -      spare   /dev/sdc4
>        -       8       20        0      sync   /dev/sdb4
>        -       8        4        1      sync   /dev/sda4
>
> Long story version follows
>
> I have 4 drives partitioned into different raid types. partition 4 is
> a raid5 across all 4 drives. For some reason my gpt partition tables
> were all wiped, and I suspect benchmarking with fio (though I only
> ever gave it an lvm volume to operate on). I boot systemrescuecd and
> testdisk finds the original partitions so I tell it to restore those.
> So far seems good. I start assembling some arrays, others don't work
> yet. lvm is starting to show contents it finds in the so far assembled
> arrays (this is still within systemrescuecd).
>
> Investigating the unassembled arrays, dmesg is complaining about the
> array size changed. I find a suggestion to use "-U devicesize". I
> believe this was my first mistake. The arrays assemble but lvm hangs
> indefinitely at this point.
>
> I desperately search for any info I have on the partitions and arrays
> and I find a spreadsheet on my laptop that contains meticulous
> partition detail. I find that some of the partition ends leave a gap
> before the next partition begins. Whatever. I fix the partition
> tables. This time, all the arrays assemble and lvm is happy!! YES.
>
> However each array has one missing partition member and it's not the
> same disk on each. That's strange. However my server is running. I'm
> able to boot it normally and homeassistant is back up. I then re-add
> each missing partition to each array (I believe this was my second
> mistake). I go to bed while it reconstructs.
>
> In the morning, the array it was reconstructing is back into pending,
> the raid5 array in question is inactive, and it's reconstructing
> something else. I remove each partition that I previously added to
> each array (although the array in question doesn't even let me do
> this) . I stop the array in question and zero the superblock of the
> partition I wanted to remove. I zero the superblocks on each other
> partition removed. I then re-add each partition to each array and let
> them resync. I now have 3 out of 5 fully operational, one more resync
> in progress.
>
> But my array in question is still kinda hosed. Here's where it's
> strange. Rather than explain everything, here's the status from the
> devices (mdadm -E) and the array (mdadm -D).
> https://pastebin.com/Gyj8d7Z7
>
> Note the table at the end of mdadm -D (end of the paste). It shows
> four devices "removed", then a gap, then 3 devices as 'sync' . If I
> incrementally add the drives it shows a "normal" table. Until I try
> --run, then it shows the odd table. If I add --incremental 3 drives
> (not the 'spare') then run, it shows the pasted table. If I try to add
> the fourth (spare) it says "ADD_NEW_DISK not supported" in dmesg. If I
> add 3 drives including the 'spare' it's the same behavior otherwise,
> but adding the fourth drive complains that it can only add it as a
> spare, and I must use force-spare to add it (I suspect this would be
> my 3rd mistake if I did it).
>
> I think I can force run this array with sd[abd]4 but the normal
> commands give errors when trying to do so. What's also strange is that
> devices sd[abd]4 all have the same event count, yet trying to start
> the array results in "cannot start dirty degraded array".



-- 
You keep up the good fight just as long as you feel you need to.
-- Ken Danagger
