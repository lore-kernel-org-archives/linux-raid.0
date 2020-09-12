Return-Path: <SRS0=Qcx5=CV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4713C433E2
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 06:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B08207FB
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 06:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599891010;
	bh=9dDkKH/w9H/gj7WGtRLtCpyt15b73dQQ5KEg+Jut/u4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=doJ+N5I/4rrNHqGTLvf+pRHsBNrC0GwOckKsuR1dHSp0B0G24JiecgfudDThI8xwS
	 xmHbJEtdAwgmiZLCIfTdbg92tGSbN0zx6w88FPvGJ7cI3fUdtsiITvHp1QBu6KIOMU
	 HjALUygPtiFoRrfdHLo2N3nDCg7lN63kMSHXxLFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgILGKI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Sep 2020 02:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgILGKH (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 12 Sep 2020 02:10:07 -0400
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A2E207FB
        for <linux-raid@vger.kernel.org>; Sat, 12 Sep 2020 06:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599891006;
        bh=9dDkKH/w9H/gj7WGtRLtCpyt15b73dQQ5KEg+Jut/u4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zJZV3Nug31E2V5jMYH0wB6ls50XCJr/ETVAQlrhDfrD5ZdaO3P0L9CskK0obBOMg2
         qUx6BVYDaBAlxV+HdxZd2jQw+OeoMDkIQpNOpn9CB7j9rM0PZ2H2n198fSntRpa9xQ
         2GITK5vZnxLv9Sb7+EXfH+wz8ZU1YRPgFj4KnGtY=
Received: by mail-lf1-f53.google.com with SMTP id w11so8020012lfn.2
        for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2020 23:10:05 -0700 (PDT)
X-Gm-Message-State: AOAM5309tM6sWCP5+oUU6WgOUOIbbkpkPSwYm2VNHRyGdLRZy7cxDwea
        rwtSNK/BHziiGVqXu17bTyL0heQPByJ/UMmawCM=
X-Google-Smtp-Source: ABdhPJwLMOy0zmRBQetQOwqCUwD9p2ewYu3ToyJ+alXNJp205XxhoNzMUFFoWu21dOKCX/+kxZp7zEVNP6B0Qvg6x0I=
X-Received: by 2002:a19:7902:: with SMTP id u2mr1395769lfc.515.1599891003896;
 Fri, 11 Sep 2020 23:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com> <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com> <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com> <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
 <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
In-Reply-To: <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 11 Sep 2020 23:09:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5MA3aUpW6EVGbT0ANYai1t95bQ+R05VBLS8AOCCQ-CKg@mail.gmail.com>
Message-ID: <CAPhsuW5MA3aUpW6EVGbT0ANYai1t95bQ+R05VBLS8AOCCQ-CKg@mail.gmail.com>
Subject: Re: Linux raid-like idea
To:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Cc:     antlists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Sep 11, 2020 at 1:15 PM Brian Allen Vanderburg II
<brianvanderburg2@aim.com> wrote:
>
>
> On 9/11/20 3:16 PM, antlists wrote:
> > Yes it is a bit like raid-4 since the data and parity disks are
> >> separated.  In fact the idea could be better called a parity backed
> >> collection of independently accessed disks. While you would not get the
> >> advantage/performance increase of reads/writes going across multiple
> >> disks, the idea is primarily targeted to read-heavy applications, so in
> >> a typical use, read performance should be no worse than reading directly
> >> from a single un-raided disk, except in case of a disk failure where the
> >> parity is being used to calculated a block read on a missing disk.
> >> Writes would have more overhead since they would also have to
> >> calculate/update parity.
> >
> > Ummm...
> >
> > So let me word this differently. You're looking at pairing disks up,
> > with a filesystem on each pair (data/parity), and then using mergefs
> > on top. Compared with simple raid, that looks like a lose-lose
> > scenario to me.
> >
> > A raid-1 will read faster than a single disk, because it optimises
> > which disk to read from, and it will write faster too because your
> > typical parity calculation for a two-disk scenario is a no-op, which
> > might not optimise out.
>
>
> Not exactly.  You can do a data + parity, but you could also do a data +
> data + parity or a data + data + data + parity.  Or with more than one
> parity disk data + data + data + data +parity + parity, etc.
>
> Best viewed in a fixed-width font, and probably make more sense read
> from the bottom up:
>
>
>        /data
>          |
>     / mergerfs  \
>    /             \
> /pool1         /pool2         /pool3 (or /home or /usr/local, etc)
>    |             |             |
> The filesystem built upon the /dev/frX devices can be used however the
> user wants.
>    |             |             |
> ----------------------------------------
>    |             |             |
> ext4 (etc)     ext4(etc)    (ext4/etc, could in theory even have
> multiple partitions then filesystems)
>    |             |             |
> Each exposed block device /dev/frX can have a filesystem/partition table
> placed on it, which is placed onto the single mapped disk.
> Any damage/issues on one data disk would not affect the other data disks
> at all.  However, since the collection of data disks also has parity for
> them,
> damage to a data disk can be restored from the parity and other data
> disks.  If, during restore, something prevents the restore, then only
> the bad
> data disks have an issue, the other data disks would still be fully
> accessible, and any filesystem on them still intact since the entire
> filesystem
> from anything on /dev/fr0 would be only on /dev/sda1, and so on.
>    |             |             |
> ----------------------------------------
>    |             |             |
> /dev/fr0      /dev/fr1      /dev/fr2
>    |             |             |
> Individual data disks are passed through as fully exposed block devices,
> minus any overhead for information/data structures for the 'raid'.
> A block X on /dev/fr0 maps to block X + offset on /dev/sda1 and so on
>    |             |             |
> Raid/parity backed disk layer (data: /dev/sda1=/dev/fr0,
> /dev/sdb1=/dev/fr1, /dev/sdc1=/dev/fr2, parity: /dev/sdd1)
>    |             |             |
> -----------------------------------------------------
>    |             |             |                 |
> /dev/sda1    /dev/sdb1     /dev/sdc1      /dev/sdd1 (parity)
>
>
>
> So basically at the raid (or parity backed layer), multiple disks and
> not just a single disk, can be backed by the parity disk (ideally
> support for more than on parity disk as well)  Only difference is,
> instead of joining the disks as one block device /dev/md0, each data
> disk gets its own block device and so has it's own filesystem(s) on it
> independently of the other disks.  A single data disk can be removed
> entirely, taken to a different system, and still be read (would need to
> do losetup with an offset to get to the start of the
> filesystem/partition table though), and the other data disks would still
> be readable on the original system.  So any total loss of a data disk
> would not affect the other data disks files.  In this example, /data
> could be missing some files if /pool1 (/dev/sda1) died, but the files on
> /pool2 would still be entirely accessible as would any filesystem from
> /dev/sdc1.  There is no performance advantage to such a setup. The
> advantage is that should something real bad happen and it become
> impossible to restore some data disk(s), the other disk(s) are still
> accessible.
>
> Read from /dev/fr0 = read from /dev/sda1 (adjusted for any overhead/headers)
> Read from /dev/fr1 = read from /dev/sdb1 (adjusted for any overhead/headers)
> Read from /dev/fr2 = read from /dev/sdc1 (adjusted for any overhead/headers)
> Write to /dev/fr0 = write to /dev/sda1 ((adjusted for any
> overhead/headers) and parity /dev/sdd1
> Write to /dev/fr1 = write to /dev/sdb1 ((adjusted for any
> overhead/headers) and parity /dev/sdd1
> Write to /dev/fr2 = write to /dev/sdc1 ((adjusted for any
> overhead/headers) and parity /dev/sdd1
>
> Read from /dev/fr0 (/dev/sda1 missing) = read from parity and other
> disks, recalculate original block)
> During rebuild, /dev/sdd dies as well (unable to rebuild from parity now
> since /dev/sda and /dev/sdd are missing)
>     Lost: /dev/sda1
>     Still present: /dev/sdb1 -- some files from the pool will be missing
> since /pool1 is missing but the files on /pool2 are still present in
> their entirety
>     Still present: /pool3 (or /home or /usr/local, etc, whatever
> /dev/fr2 was used for)
>
> >>
> >>> Personally, I'm looking at something like raid-61 as a project. That
> >>> would let you survive four disk failures ...
> >>
> >> Interesting.  I'll check that out more later, but from what it seems so
> >> far there is a lot of overhead (10 1TB disks would only be 3TB of data
> >> (2x 5 disk arrays mirrors, then raid6 on each leaving 3 disks-worth of
> >> data).  My currently solution since I'ts basically just storing bulk
> >> data, is mergerfs and snapraid, and from the documents of snapraid, 10
> >> 1TB disks would provide 6TB if using 4 for parity.  However it's parity
> >> calculations seem to be more complex as well.
> >
> > Actually no. Don't forget that, as far as linux is concerned, raid-10
> > and raid-1+0 are two *completely* *different* things. You can raid-10
> > three disks, but you need four for raid-1+0.
> >
> > You've mis-calculated raid-6+1 - that gives you 6TB for 10 disks (two
> > 3TB arrays). I think I would probably get more with raid-61, but every
> > time I think about it my brain goes "whoa!!!", and I'll need to start
> > concentrating on it to work out exactly what's going on.
>
> That's right, I get the various combinations confused.  So does raid61
> allow for losing 4 disks in any order and still recovering? or would
> some order of disks make it where just 3 disks lost and be bad?
> Iinteresting non-the-less and I'll have to look into it.  Obviously it's
> not intended to as a replacement for backing up important data, but, for
> me any way, just away to minimize loss of any trivial bulk data/files.
>
> It would be nice if the raid modules had support for methods that could
> support a total of more disks in any order lost without loosing data.
> Snapraid source states that it uses some Cauchy Matrix algorithm which
> in theory could loose up to 6 disks if using 6 parity disks, in any
> order, and still be able to restore the data.  I'm not familiar with the
> math behind it so can't speak to the accuracy of that claim.
>
> >> This is actually the main purpose of the idea.  Due to the data on the
> >> disks in a traditional raid5/6 being mapped from multiple disks to a
> >> single logical block device, and so the structures of any file systems
> >> and their files scattered across all the disks, losing one more than the
> >> number of available lost disks would make the entire filesystem(s) and
> >> all files virtually unrecoverable.
> >
> > But raid 5/6 give you much more usable space than a mirror. What I'm
> > having trouble getting to grips with in your idea is how is it an
> > improvement on a mirror? It looks to me like you're proposing a 2-disk
> > raid-4 as the underlying storage medium, with mergefs on top. Which is
> > effectively giving you a poorly-performing mirror. A crappy raid-1+0,
> > basically.
>
> I do apologize it seems I'm having a little difficulty clearly
> explaining the idea.  Hopefully the chart above helps explain it better
> than I have been.  Imagine raid 5 or 6, but with no striping (so the
> parity goes on their own disks), and the data disks passed through as
> their down block devices each.  You lose any performance benefits of the
> striping of data/parity, but the data stored on any data disk is only on
> that data disk, and same for the others, so losing all parity and a data
> disk, would not lose the data on the other data disks.
>
> >>
> >> By keeping each data disk separate and exposed as it's own block device
> >> with some parity backup, each disk contains an entire filesystem(s) on
> >> it's own to be used however a user decides.  The loss of one of the
> >> disks during a rebuild would not cause full data loss anymore but only
> >> of the filesystem(s) on that disk.  The data on the other disks would
> >> still be intact and readable, although depending on the user's usage,
> >> may be missing files if they used a union/merge filesystem on top of
> >> them.  A rebuild would still have the same issues, would have to read
> >> all the remaining disks to rebuild the lost disk.  I'm not really sure
> >> of any way around that since parity would essentially be calculated as
> >> the xor of the same block on all the data disks.
> >>
> > And as I understand your setup, you also suffer from the same problem
> > as raid-10 - lose one disk and you're fine, lose two and it's russian
> > roulette whether you can recover your data. raid-6 is *any* two and
> > you're fine, raid-61 would be *any* four and you're fine.
>
> Not exactly.  Since the data disks are passed through as individual
> block devices instead of 'joined' into a single block device, if you
> lose one disk (assuming only one disk of parity) then you are fine. If
> you lose two, then you've only lost the data on the lost data disk. The
> other data disks would still have their in-tact filesystems on them.
> Depending on how they are used, some files may be missing. IE a mergerfs
> between two mount points would be missing any files on the lost mount
> point, but the other files would still be accessible.
>
>
> It may or may not (leaning more to probably not) have any use. I'm
> hoping from the above at least the idea is better understood.  I do
> apologize if it's still not clear/
>

IIUC...

If all the disks are of the same size, this looks like raid-4 with HUGE chunk
size. Say a raid-4 with 4 disks, the drive is 2TiB, and the chunk size is also
2TiB. The array is 6TiB. LBA 0-2TiB goes to disk 0, LBA 2-4TiB goes to
disk 1, and LBA 4-6TiB goes to disk 2. disk 3 is all parities.

Then we create 3x 2TiB partitions on the array (assuming the partition table
is free...). Then we can create 3x file systems on these partitions.

Is this same/similar to the idea?

Thanks,
Song
