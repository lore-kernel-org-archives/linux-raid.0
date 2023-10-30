Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A22C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 30 Oct 2023 16:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjJ3QPI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Oct 2023 12:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjJ3QPG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Oct 2023 12:15:06 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0380D9
        for <linux-raid@vger.kernel.org>; Mon, 30 Oct 2023 09:15:00 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7a693d8de75so138979439f.2
        for <linux-raid@vger.kernel.org>; Mon, 30 Oct 2023 09:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698682500; x=1699287300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocjqNkUSessuFcKJNgsarySwNrH3j0YpBTznUfZ4ZqM=;
        b=mfrnJbuXiLrHuGIz6rHG83P84uv7F+an7CgCBggXWiHUITQBHK/CxgL6+nJ5rU9Rsb
         L8yGvtT5FZWVwaWx9Xf0XS3btspUml5YYngCIqeucCOm5/hBO4vcYewNn/5aDV4gtl27
         pAPbIBKZfxLBOl2RX8TT7BlQ0ciTUmu+oAzAp3bnWqNzErRwcEiZ5nKmWOzDb6024UkQ
         /boXkwekNgqz+9YKJ+wHlzO7TfDACdkwfE+9tQ73zErVJYrGChXoL6zFcBUf6JktAD90
         kddkd4G5XdofrDHOnMkoiov6LHYz9whb0KQVQWtUIoR1SwyTQ4U+VtZRMUY8N/QFwSrJ
         OyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698682500; x=1699287300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocjqNkUSessuFcKJNgsarySwNrH3j0YpBTznUfZ4ZqM=;
        b=QsNDpudaO1N7+2fAtCo3HOJERxaTSZv/hILdrlgWlG1MgiHDnmPlfiiF1IQ/xnsC50
         wq3ZiH7eKZnX8KC6ZYXJfE5X624LFoVa2vjFrT+OVw/mJYdNSXBP0TELOiavtu1v+wLQ
         9hdYV5oAJB/arzXrc+BhZb4fkd48xpL7vZy5YZtXCWBqDslI0hWbM/3GKY2WaT5Ep+5a
         T2wL0ApetqkAVrZJSp33A8XjoDfusluEnO271S0HMXgBL/W+uO+zfR1W06XhqkYcmmqm
         7w/XzaaZ8w1osYqrruwuqVRBxOP9dJ+TUmOxdDSiyntamVC/uXLzzuvFstLC8wuKTewl
         lz1w==
X-Gm-Message-State: AOJu0YxAh2twgwAopWJiU7auT+DCGTEedmt9jtvIyMJ4j0XgC1kQyDqv
        GJezFx7IKkVN+aJuzFckN+oNdEJpfhJucBMuTtxocbd6YwQ=
X-Google-Smtp-Source: AGHT+IG6k5y69Vm8+EOYAkfD+FLKmXqz9Ne7lOJW9pHYQuoj1C6HDSK0xpw5OVjfolklk1NIAyZ9F+wPto8MozPKldQ=
X-Received: by 2002:a6b:fe10:0:b0:7a6:966b:35a6 with SMTP id
 x16-20020a6bfe10000000b007a6966b35a6mr13927640ioh.11.1698682500106; Mon, 30
 Oct 2023 09:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
In-Reply-To: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 30 Oct 2023 11:14:49 -0500
Message-ID: <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
Subject: Re: problem with recovered array
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

look at  SAR -d output for all the disks in the raid6.   It may be a
disk issue (though I suspect not given the 100% cpu show in raid).

Clearly something very expensive/deadlockish is happening because of
the raid having to rebuild the data from the missing disk, not sure
what could be wrong with it.

If you are on a kernel that has a newer version upgrading and
rebooting may change something  If it is one close to the newest
kernel version going back a minor version (if 6.5 go back to the last
6.4 kernel).

You might also install the perf package and run "perf top" and see
what sorts of calls the kernel is spending all of its time in.

On Mon, Oct 30, 2023 at 8:44=E2=80=AFAM <eyal@eyal.emu.id.au> wrote:
>
> F38
>
> I know this is a bit long but I wanted to provide as much detail as I tho=
ught needed.
>
> I have a 7-member raid6. The other day I needed to send a disk for replac=
ement.
> I have done this before and all looked well. The array is now degraded un=
til I get the new disk.
>
> At one point my system got into trouble and I am not sure why, but it sta=
rted to have
> very slow response to open/close files, or even keystrokes. At the end I =
decided to reboot.
> It refused to complete the shutdown and after a while I used the sysrq fe=
ature for this.
>
> On the restart it dropped into emergency shell, the array had all members=
 listed as spares.
> I tried to '--run' the array but mdadm refused 'cannot start dirty degrad=
ed array'
> though the array was now listed in mdstat and looked as expected.
>
> Since mdadm suggested I use --force', I did so
>         mdadm --assemble --force /dev/md127 /dev/sd{b,c,d,e,f,g}1
>
> Q0) was I correct to use this command?
>
> 2023-10-30T01:08:25+1100 kernel: md/raid:md127: raid level 6 active with =
6 out of 7 devices, algorithm 2
> 2023-10-30T01:08:25+1100 kernel: md127: detected capacity change from 0 t=
o 117187522560
> 2023-10-30T01:08:25+1100 kernel: md: requested-resync of RAID array md127
>
> Q1) What does this last line mean?
>
> Now that the array came up I still could not mount the fs (still in emerg=
ency shell).
> I rebooted and all came up, the array was there and the fs was mounted an=
d so far
> I did not notice any issues with the fs.
>
> However, it is not perfect. I tried to copy some data from an external (U=
SB) disk to the array
> and it went very slowly (as in 10KB/s, the USB could do 120MB/s). The cop=
y (rsync) was running
> at 100% CPU which is unexpected. I then stopped it. As a test, I rsync'ed=
 the USB disk to another
> SATA disk on the server and it went fast, so the USB disk is OK.
>
> I then noticed (in 'top') that there is a kworker running at 100% CPU:
>
>      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ C=
OMMAND
>   944760 root      20   0       0      0      0 R 100.0   0.0 164:00.85 k=
worker/u16:3+flush-9:127
>
> It did it for many hours and I do not know what it is doing.
>
> Q2) what does this worker do?
>
> I also noticed that mdstat shows a high bitmap usage:
>
> Personalities : [raid6] [raid5] [raid4]
> md127 : active raid6 sde1[4] sdg1[6] sdf1[5] sdd1[7] sdb1[8] sdc1[9]
>        58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6=
] [_UUUUUU]
>        bitmap: 87/88 pages [348KB], 65536KB chunk
>
> Q3) Is this OK? Should the usage go down? It does not change at all.
>
> While looking at everything, I started iostat on md127 and I see that the=
re is a constant
> trickle of writes, about 5KB/s. There is no activity on this fs.
> Also, I see similar activity on all the members, at the same rate, so md1=
27 does not show
> 6 times the members activity. I guess this is just how md works?
>
> Q4) What is this write activity? Is it related to the abovementioned 'req=
uested-resync'?
>         If this is a background thing, how can I monitor it?
>
> Q5) Finally, will the array come up (degraded) if I reboot or will I need=
 to coerse it to start?
>         What is the correct way to bring up a degraded array? What about =
the 'dirty' part?
> 'mdadm -D /dev/md127' mention'sync':
>      Number   Major   Minor   RaidDevice State
>         -       0        0        0      removed
>         8       8       17        1      active sync   /dev/sdb1
>         9       8       33        2      active sync   /dev/sdc1
>         7       8       49        3      active sync   /dev/sdd1
>         4       8       65        4      active sync   /dev/sde1
>         5       8       81        5      active sync   /dev/sdf1
>         6       8       97        6      active sync   /dev/sdg1
> Is this related?
>
> BTW I plan to run a 'check' at some point.
>
> TIA
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
