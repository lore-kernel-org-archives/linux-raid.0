Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FE5C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 21 Jan 2022 17:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiAURFF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Jan 2022 12:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379818AbiAUREv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Jan 2022 12:04:51 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C28C06173B
        for <linux-raid@vger.kernel.org>; Fri, 21 Jan 2022 09:04:50 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id 15so11029967qvp.12
        for <linux-raid@vger.kernel.org>; Fri, 21 Jan 2022 09:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5c9tOOq4hDxlIzxRGDfKJpaLJjBMEH8+w3FFgIH1jTY=;
        b=MM168NnOC30K/7LUfOKPe/dcjGlAet8da5ndakJ2DAuL4GjDtOQDzC5tqfxlgPEDVF
         2c5/Zl68gGieXhs44EnvE4jSiYtVe2nqoopjJ8ZpthcHeS9qF8ldtsk8f+VO3fIqHi7M
         /JLlMSp90KW++5BthyLD8r1/SwMyDfOx3wu1IqtNM4Wdgg7wO68TniErZB7Eq9+5Z5jO
         Uo7VlLMNRQwFtBVZriVKaaUPDckEySN/C8WKiwZW6wqnj2FyRUAx6wf2HLrRveaPQ8t+
         mRQ/dg+7eg1arLnGPpkrCpX9xXn6pKlq8t7yCagXIpA3EwpmU+sxD8Jjk8HNEx2NYtnP
         5kQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5c9tOOq4hDxlIzxRGDfKJpaLJjBMEH8+w3FFgIH1jTY=;
        b=iLL4l1VERCNeNXrpbQwe0gPj/A4vWrs4EmYAeX3YHxykrVnZIsQKzS67s2F2iO4NQ6
         U8sfpjG71oeVLDzdWpvriIggRwey0bXaIiyEt544mk8ZxGdj1b9N5NbeVApVPmyAfDJd
         R84RaPOOZLroZGUmcjUIaz313WTEFXGPJ1cE4dVObJQdtZMOL85JEtD0krRhyGAn7NBM
         PFht3fjvazWkPOd+v4vsyX6CNrZFvS0U1UInpW30CBC4diLsWP8niJD0rNJq9bbIsKNn
         bJmuZlqyaA4I/ZlEYBRHGtwitK4nK4nT5N3IBpNSpwiOGZC6D+4eVYgwcMU+jnXfD1Qt
         qR2A==
X-Gm-Message-State: AOAM532iHQwr73uOg7jLXSeRoP+DPXDz1jUawPTxJovxn3oOliaCT8UD
        lG0JhRssJkktwxibg/4ahIVJNd/8/1Qi7zaX2En8nG82
X-Google-Smtp-Source: ABdhPJzyQYR2PjBptmsk9XrbVjw6UuUPB78cVn3NUz0Mzbf+iV7xqbD4P8sqqHMI4PN3SsOCdkJEA6yEUApPuPzOcSs=
X-Received: by 2002:a05:6214:f25:: with SMTP id iw5mr4399507qvb.3.1642784689174;
 Fri, 21 Jan 2022 09:04:49 -0800 (PST)
MIME-Version: 1.0
References: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk> <164254680952.24166.7553126422166310408@noble.neil.brown.name>
In-Reply-To: <164254680952.24166.7553126422166310408@noble.neil.brown.name>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 21 Jan 2022 11:04:37 -0600
Message-ID: <CAAMCDecC0+8DGqagttoqaEra=fT=qnoS_cwzpXM+xWcOUT+fPw@mail.gmail.com>
Subject: Re: The mysterious case of the disappearing superblock ...
To:     NeilBrown <neilb@suse.de>
Cc:     anthony <antmbox@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>,
        Phil Turmel <philip@turmel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I would first look for the superblock magic Neil mentions.  Usually in
lost PV, FSes and other data volumes the issue is that something like
the partition start moved and the magic is now either outside the
given partition or not in the right location in the given partition.
So you may want to take one disk and scan a wide range to see if you
can find it.  If you find it on that disk, now you have an idea where
it may be on the others.

Since the one is sda4 is that the last partition and if it is not the
last are you missing any other partitions?

I have never seen a disk that disappeared for no reason.I have always
been able to find something pointing to what the human error was.  A
lot of being able to do that is the machines/teams I oversee have
weekly data collects similar to sosreport on the active kernel
tables/config files, so I can see that prior to reboot the partition
table was not where it is after boot.  And that is usually as simple
as fixing the partition table to match where it was and then all is
good.  Even without that you can look for the header magic and from
that tell where the partition table for that partition starts.  I
oversee a huge number of systems, with countless different hands of
various experience levels doing work on those 20k systems so I have
seen pretty much every variation of issue, and I have always been able
to find evidence of a root cause.

On Fri, Jan 21, 2022 at 5:13 AM NeilBrown <neilb@suse.de> wrote:
>
> On Wed, 19 Jan 2022, anthony wrote:
> > You all know the story of how the cobbler's children are the worst shod,
> > I expect :-) Well, the superblock to my raid (containing /home, etc) has
> > disappeared, and I don't have a backup ... (well I do but it's now well
> > out of date).
> >
> > So, a new hard drive is on order, for backup ...
> >
> > Firstly, given that superblocks seem to disappear every now and then,
> > does anybody have any ideas for something that might help us track it
> > down? The 1.2 superblock is 4K into the device I believe? So if I copy
> > the first 8K ( dd if=/dev/sda4 of=sda4.img bs=4K count=2 ) of each
> > partition, that might help provide any clues as to what's happened to
> > it? What am I looking for? What is the superblock supposed to look like?
>
> Yes, 4K offset.  Yes, that dd command will get what you want it to.
> It hardly matters what the superblock should looks like, because it
> won't be there.  The thing you want to know is: what is there?
> i.e.  you see random bytes and need to guess what they mean, so you can
> guess where they came from.
> Best to post the "od -x" output and crowd-source.
>
> Are you sure the partition starts haven't changed? Was the array made of
> whole-devices or of partitions?
>
> If you want to find out if the superblock got moved, the maybe searching
> for the magic number is best.
> Look a the start of super1.c in mdadm.  The first 4 bytes of the
> superblock are 0xa92b4efc little-endian.  So: FC 4E 2B A9
> The next 4 bytes as 01 00 00 00 ( the major version)
> Then the feature map - possibly 0.  Then 4 zero bytes.
>
> If you see something that looks like that, it worth trying to point
> mdadm at it.  Create a loop device over the it with an appropriate
> offset, and ask mdadm --example to look at it.
>
>
> >
> > Secondly, once I've backed up my partitions, I obviously need to do
> > --create --assume-clean ... The only snag is, the array has been
> > rebuilt, so I doubt my data offset is the default. The history of the
> > array is simple. It's pretty new, so it will have been created with the
> > latest mdadm, and was originally a mirror of sda4 and sdb4.
> >
> > A new drive was added and the array upgraded to raid-5, and I BELIEVE
> > the order is sdc4, sda4, sdb1 - sdb1 being the new drive that was added.
> >
> > Am I safe to assume that sdc4 and sda4 will have the same data offset?
> > What is it likely to be? And seeing as it was the last added am I safe
> > to assume that sdb1 is the last drive, so all I have to do is see which
> > way round the other two should be?
>
> I would suggest creating some sparse files the same size as the device,
> create loop devices over them, and creating the array in the sequence
> you remember doing it - using "--assume-clean" to avoid rebuilds that
> would make those sparse files less sparse.
> Then look at the metadata written and assume it is will similar to
> that which was written to your array.
>
> NeilBrown
>
>
> >
> > At least the silver lining behind this, is that having been forced to
> > recover my own array, I'll understand it much better helping other
> > people recover theirs!
> >
> > Cheers,
> > Wol
> >
> >
