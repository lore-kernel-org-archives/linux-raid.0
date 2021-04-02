Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95068C433ED
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 14:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E07361006
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 14:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhDBOpr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbhDBOpr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Apr 2021 10:45:47 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47512C0613E6;
        Fri,  2 Apr 2021 07:45:46 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id g8so7855361lfv.12;
        Fri, 02 Apr 2021 07:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4L8O9R+b3yxpyXZWZYDFuq/gdZ5zPognKIR1rH6oTng=;
        b=l2MaDNhNcxkm/UMV/ZuFb/LtA5kV0diO7St9qdz8d8QmutyoPWqSLYJgIwxrpyoYAn
         I0tGM2no+l8y3vFC/ygEwXOIqcebgVrH4IPM64mQjPrb3qsKWvN8XRft8P9anE9N+Iv/
         fXG8aqs/4EmD30d1od/4EXag8dbe3pz18QvXBB+Pq/Kpu1GRsZT3jqgIv46geJ9WX3JI
         2xqQxEd7AEKx9qlZ2ME6VKD5ssHk486e1piPr5arbT03XIDPj6ZrDdyCOo0zLZKt2T1J
         6z0ENXcDcSijzDQHuUBNGwK8NgWIh2g7sWmgm+rChAQxe30Xu9GQa6vewnfYgVHnIX0p
         t8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4L8O9R+b3yxpyXZWZYDFuq/gdZ5zPognKIR1rH6oTng=;
        b=YKN3c0J/oAADLXKa/rLn2N0EnmoioEAdzd3icR4HAU0lhJaKcO/FGun+FoNnLzCUzp
         R/THDSnCsWK5+LD4PjOXJTHCEA6MYI0NfdyTsN39ZApztX9yYfvRaOX3Im9VXw6lkoVR
         r0GKdHG2d9rhefKZwwDzSW+AcCVa5JsucEwpCbj6sOqkzyNLHoF/f/s7oVRQfaWtEAMW
         jYieCI3cePQbyVAr7upipLherYfmr1LbYAsMw/gCsfXYt/G/U6QB/q5rVvZWjoV6FHNY
         lhl/nR6L3wpwnVutDMUMVx8Vf2ztyK1yFQmxw2sHadpqS0iV7dTA/moGeyc2orgX/z/Q
         YJAQ==
X-Gm-Message-State: AOAM533nczesq09qCOdVhNhsYm/dXIAtduX7usr70SPDMje+smWOXuAK
        rufUrBnj9gBDGxryrteVcv4zJdY6NB7ol+OnzVr4ULr5vJM=
X-Google-Smtp-Source: ABdhPJy1+4Hin00DaqW1l//jBwnZzIPQeswhbDJmhR8PYzmFP0Z642KTd/28afaSvr4/Wl3Y7sNf4jbsUkemtteeztk=
X-Received: by 2002:a19:6d0:: with SMTP id 199mr9207233lfg.18.1617374744738;
 Fri, 02 Apr 2021 07:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <16ceff73-1257-fc3d-aade-43656c7216e7@molgen.mpg.de>
 <12e8f7f1-6655-9f0b-72b1-0908f229dcac@molgen.mpg.de> <b5eb567d-9866-8f0f-ea61-83ae97d4d21f@molgen.mpg.de>
In-Reply-To: <b5eb567d-9866-8f0f-ea61-83ae97d4d21f@molgen.mpg.de>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 2 Apr 2021 09:45:33 -0500
Message-ID: <CAAMCDedmGUcWY=9Nb36gXoo0+F82rhq=-6yKZ1xPf74Gj0mq7Q@mail.gmail.com>
Subject: Re: OT: Processor recommendation for RAID6
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Apr 2, 2021 at 4:13 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Linux folks,
>
>

> > Are these values a good benchmark for comparing processors?
>
> After two years, yes they are. I created 16 10 GB files in `/dev/shm`,
> set them up as loop devices, and created a RAID6. For resync speed it
> makes difference.
>
> 2 x AMD EPYC 7601 32-Core Processor:    34671K/sec
> 2 x Intel Xeon Gold 6248 CPU @ 2.50GHz: 87533K/sec
>
> So, the current state of affairs seems to be, that AVX512 instructions
> do help for software RAIDs, if you want fast rebuild/resync times.
> Getting, for example, a four core/eight thread Intel Xeon Gold 5222
> might be useful.
>
> Now, the question remains, if AMD processors could make it up with
> higher performance, or better optimized code, or if AVX512 instructions
> are a must,
>
> [=E2=80=A6]
>
>
> Kind regards,
>
> Paul
>
>
> PS: Here are the commands on the AMD EPYC system:
>
> ```
> $ for i in $(seq 1 16); do truncate -s 10G /dev/shm/vdisk$i.img; done
> $ for i in /dev/shm/v*.img; do sudo losetup --find --show $i; done
> /dev/loop0
> /dev/loop1
> /dev/loop2
> /dev/loop3
> /dev/loop4
> /dev/loop5
> /dev/loop6
> /dev/loop7
> /dev/loop8
> /dev/loop9
> /dev/loop10
> /dev/loop11
> /dev/loop12
> /dev/loop13
> /dev/loop14
> /dev/loop15
> $ sudo mdadm --create /dev/md1 --level=3D6 --raid-devices=3D16
> /dev/loop{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md1 started.
> $ more /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> [multipath]
> md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12]
> loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5]266
> loop4[4] loop3[3] lo
> op2[2] loop1[1] loop0[0]
>        146671616 blocks super 1.2 level 6, 512k chunk, algorithm 276
> [16/16] [UUUUUUUUUUUUUUUU]
>        [>....................]  resync =3D  3.9% (416880/10476544)
> finish=3D5.6min speed=3D29777K/sec
>
> unused devices: <none>
> $ more /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> [multipath]
> md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12]
> loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5]
> loop4[4] loop3[3] lo
> op2[2] loop1[1] loop0[0]
>        146671616 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [16/16] [UUUUUUUUUUUUUUUU]
>        [>....................]  resync =3D  4.1% (439872/10476544)
> finish=3D5.3min speed=3D31419K/sec
> $ sudo mdadm -S /dev/md1
> mdadm: stopped /dev/md1
> $ sudo losetup -D
> $ sudo rm /dev/shm/vdisk*.img


I think you are testing something else.  Your speeds are way below
what the raw processor can do. You are probably testing memory
speed/numa arch differences between the 2.

On the intel arch there are 2 numa nodes total with 4 channels, so the
system  has 8 usable channels of bandwidth, but a allocation on a
single numa node will only have 4 channels usable (ddr4-2933)

On the epyc there are 8 numa nodes with 2 channels each (ddr4-2666),
so any single memory allocation will have only 2 channels available
and if the accesses are across the numa bus will be slower.

So 4*2933/2*2666 =3D 2.20 * 34671 =3D 76286 (fairly close to your results).

How the allocation for memory works depends a lot on how much ram you
actually have per numa node and how much for the whole machine.  But
any single block for any single device should be on a single numa node
almost all of the time.

You might want to drop the cache before the test, run numactl
--hardware to see how much memory is free per numa node, then rerun
the test and at the of the test before the stop run numactl --hardware
again to see how it was spread across numa nodes.  Even if it spreads
it across multiple numa nodes that may well mean that on the epyc case
you are running with several numa nodes were the main raid processes
are running against remote numa nodes, and because intel only has 2
then there is a decent chance that it is only running on 1 most of the
time (so no remote memory).  I have also seen in benchmarks I have run
on 2P and 4P intel machines that interleaved on a 2P single thread job
is faster than running on a single numa nodes memory (with the process
pinned to a single cpu on one of the numa nodes, memory interleaved
over both), but on a 4P/4numa node machine interleaving slows it down
significantly.  And in the default case any single write/read of a
block is likely only on a single numa node so that specific read/write
is constrained by a single numa node bandwidth giving an advantage to
fewer faster/bigger numa nodes and less remote memory.

Outside of rebooting and forcing the entire machine to interleave I am
not sure how to get shm to interleave.   It might be a good enough
test to just force the epyc to interleave and see if the benchmark
result changes in any way.  If the result does change repeat on the
intel.  Overall for the most part the raid would not be able to use
very many cpu anyway, so a bigger machine with more numa nodes may
slow down the overall rate.
