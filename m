Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCAEC54EBE
	for <linux-raid@archiver.kernel.org>; Mon, 16 Jan 2023 12:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjAPME6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Jan 2023 07:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjAPME4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Jan 2023 07:04:56 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E45193CD
        for <linux-raid@vger.kernel.org>; Mon, 16 Jan 2023 04:04:54 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id t8so6894782uaj.5
        for <linux-raid@vger.kernel.org>; Mon, 16 Jan 2023 04:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W03SNoit9J1qAwxQnDYUmqwzJSj8w1SDKuqOQtkOVf0=;
        b=GtL8n6AS/DvhrT8S9PUrMXxSbifsos0ZTERnPJmcDDKIMrY4BDoA46/fni96oO4dwo
         5hOTht2Bv3kC6Gld8rBzQsgcxkddeS9KlssPatwo8Lmyvj8Tqg6txt4917ECYxnl91fu
         Xb+kGpaXe7wGPz1LBat+XNNYUVuy75wvClIf4ok9MF9JvyoMHUgaeo7aTJ0csacfNTxt
         SmQMZgIxnFJDxsY/ELaIKXaFvkc/Jm6/KgKeWNTS4Ip8hyJY84VxpMb2UgGypj7BxDVh
         J4+L9JHWdg0EjsVf+TRJAespivRdLrQ2qT4EYEBO6RafQ3G27MXTmZny9z5LQIY0I3qA
         GSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W03SNoit9J1qAwxQnDYUmqwzJSj8w1SDKuqOQtkOVf0=;
        b=yYMgdPujdbkbn8hUfNYXaoiAytQiN2+ZaOxD/NS/GUygLUBk7GwHlwRNfbnjM3iGAe
         JO9GRRjiOBxKZpkTaeUeKu2m4/NhIy9gQxxZkcG+EyGvA1+TvoL7KeHseKZu4pqbJcLo
         L3zcTT6LSVLK7RJORhd412wCvFuQg/oM9NpiyAPmcVNaqRrBFMZ14hYE/C7SxIV/QmFD
         xjBQol3YiktmOXzT/9AkNJ+8wOukvSLgYKgiGp/vkt/540FvtQjXVpJRzPdxSUXCT1m1
         MmVef15WaPck4Sc5tCUHPxqOD1lXwcBbmUgOQrx5D+Lvqybl4gBgxOw2ufB8i70glZRB
         xf2w==
X-Gm-Message-State: AFqh2koTyPtiP7oRbenjzmGQw0pjVd8dTDL9Y3mV51kTim6NJlPlgXGw
        FbnHCXQMIfyk/koJ6g/T9yERFD2NWgBE496EXBI=
X-Google-Smtp-Source: AMrXdXueTRrsrxvKWTGbkZZeD6Vv3oGrOyzDlOJ1ZWB9gV8D/cz/8EiGdN/4IJCM1WvQ5mPAigwnoOp7D3Kv25+jkYY=
X-Received: by 2002:ab0:1685:0:b0:5f5:1eca:db4 with SMTP id
 e5-20020ab01685000000b005f51eca0db4mr1328848uaf.73.1673870693826; Mon, 16 Jan
 2023 04:04:53 -0800 (PST)
MIME-Version: 1.0
References: <CAMnA3U1b6n34SzNh9RQROyP-=AkN9ZsLunm_aokV+BDAeR2vrw@mail.gmail.com>
 <CAMnA3U00_JONs-e8afbUE+EOf2Zex0wOKSaWc1YxeF5hQh5nQQ@mail.gmail.com> <3199b9d7-3974-a953-e101-f48d8661fd2b@youngman.org.uk>
In-Reply-To: <3199b9d7-3974-a953-e101-f48d8661fd2b@youngman.org.uk>
From:   Tiago Afonso <tiaafo@gmail.com>
Date:   Mon, 16 Jan 2023 12:04:42 +0000
Message-ID: <CAMnA3U0NfnunoTfQJ5VmkRVWFP3KCXU4ZZgmY7zTMHaHrL2CUw@mail.gmail.com>
Subject: Re: Fwd: RAID 5 growing hanged at 0.0%
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Thanks for the reply. I didn't do much. I put the HDDs in another
machine with a fresh installation of debian/OMV, to rule out any
hardware issue. The mdadm --detail detected the array with the 5
drives and state was reshaping paused or something. I resumed with
mdadm --readwrite /dev/md127 it started for a couple of seconds, just
to stop again, more or less in the same block...

root@openmediavault:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : active raid5 sda[6] sde[4] sdd[7] sdb[5]
      11720661504 blocks super 1.2 level 5, 512k chunk, algorithm 2
[5/4] [UUUU_]
      [>....................]  reshape =  0.0% (2303100/3906887168)
finish=3315.9min speed=4K/sec
      bitmap: 6/30 pages [24KB], 65536KB chunk


Then tried to assemble it back with just 4 HDDs, the original 4 HDDs:

root@openmediavault:~# mdadm --assemble --force /dev/md127 /dev/sda
/dev/sdb /dev/sdd /dev/sde
mdadm: Marking array /dev/md127 as 'clean'
mdadm: /dev/md127 has been started with 4 drives (out of 5).
root@openmediavault:~# mdadm --detail /dev/md127
/dev/md127:
Version : 1.2
Creation Time : Sat Apr  7 18:19:22 2018
Raid Level : raid5
Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
Used Dev Size : 3906887168 (3725.90 GiB 4000.65 GB)
Raid Devices : 5
Total Devices : 4
Persistence : Superblock is persistent


Intent Bitmap : Internal


Update Time : Sat Jan 14 13:45:57 2023
State : clean, degraded
Active Devices : 4
Working Devices : 4
Failed Devices : 0
Spare Devices : 0


Layout : left-symmetric
Chunk Size : 512K


Consistency Policy : bitmap


Delta Devices : 1, (4->5)


Name : helios4:Helios4
UUID : b6d959d8:96a3a0e6:29da39c1:15407b98
Events : 44240


Number   Major   Minor   RaidDevice State
6       8        0        0      active sync   /dev/sda
5       8       16        1      active sync   /dev/sdb
7       8       48        2      active sync   /dev/sdd
4       8       64        3      active sync   /dev/sde
-       0        0        4      removed
root@openmediavault:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : active (auto-read-only) raid5 sda[6] sde[4] sdd[7] sdb[5]
11720661504 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [UUUU_]
bitmap: 6/30 pages [24KB], 65536KB chunk


unused devices: <none>

root@openmediavault:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : active raid5 sda[6] sde[4] sdd[7] sdb[5]
      11720661504 blocks super 1.2 level 5, 512k chunk, algorithm 2
[5/4] [UUUU_]
      [>....................]  reshape =  0.0% (2303100/3906887168)
finish=3315.9min speed=19624K/sec
      bitmap: 6/30 pages [24KB], 65536KB chunk

Then it just stopped again when reshaping.

I'm now at this state.
Regarding (2): Yeah, I know that. I'm slowly replacing them with REDs.

Yeah, I saw that "assemble no-bad-blocks force" in the wiki, but I was
also afraid to try.

Thanks a lot for the help.

BR,
Tiago

On Mon, 16 Jan 2023 at 11:44, Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 16/01/2023 11:12, Tiago Afonso wrote:
> > Hi,
> >
> > Long story short, the bigger story is here:
> > https://forum.openmediavault.org/index.php?thread/45829-raid-5-growing-hanged-at-0-0/
> > I had a 4x4TB raid5 configuration and I added a new 4TB drive in order
> > to grow the array as 5x4TB raid5. I did this via openmediavault GUI
> > (my mistake, maybe I should have checked tutorials and more info on
> > how to do it properly). The reshape started but hung right at the
> > beginning.
> >
> > root@openmediavault:~# cat /proc/mdstat Personalities : [raid6]
> > [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10] md127 :
> > active raid5 sdh[4] sdg[7] sdf[6] sde[5] sdi[8] 11720661504 blocks
> > super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
> > [>....................] reshape = 0.0% (1953276/3906887168)
> > finish=2008857.0min speed=32K/sec bitmap: 6/30 pages [24KB], 65536KB
> > chunk
> >
> > I forced shutdown the process by pulling the power, as it was not
> > letting me stop the process otherwise. Even put the disks in another
> > machine to no avail. The problem seems to be that the array was not
> > healthy and there were bad-blocks, and I think that is why it keeps
> > stopping the reshape. The bad-blocks are in two of the HDDs and it
> > seems they are the same block. Now I'm stuck. I'm unable to reshape
> > back to 4 HDDs (I did try this) or access the data.
> >
> > How can I get out of this situation and recover the data back even if
> > not all data?
> >
> > I read the wiki, but I don't have much experience in linux or raid.
> > I'm afraid of doing something that puts me in an even worse situation.
> >
> > Attached are some commands output.
> >
> >
> > Thank you.
>
> Thanks. Looks like you've done your homework :-)
>
> I was about to say this looks like a well-known problem, and then I saw
> the mdadm version and the kernel. You should not be getting that problem
> with something this up-to-date.
>
> The good news is this still looks like that problem, but the question is
> what on earth is going on. Can you boot into a rescue disk rather than
> the mediavault stuff?
>
> The array is clean but degraded. Not knowing what you've done, I'm not
> sure how to put the array together again, but the really good news is it
> looks like - because the reshape never started - it shouldn't be a hard
> job to retrieve everything. Then we can start sorting things out from there.
>
> I'm going to bring in the two experts - they might take a little while
> to respond - but in the meantime two points to ponder ...
>
> (1) raid badblocks are a mis-feature, as soon as we get the array back,
> we want them gone.
> (2) "SCT Error Recovery not supported" - Your blues are not suitable
> raid drives. I've got Barracudas, and you shouldn't use those in raid
> either, so it's not immediately serious, but you want something like a
> Seagate IronWolf, or Toshiba N300. I avoid WD for precisely this reason
> - they tend to advertise stuff as suitable when it isn't.
>
> If you can afford it (they're not cheap) you might consider getting four
> decent raid drives, backing up your existing drives, and then fixing it
> when the experts chime in. I'm guessing an "assemble no-bad-blocks
> force" will fix everything, but I'm hesitant to say "go ahead and try it".
>
> Cheers,
> Wol
