Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2B9C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 21 Jan 2022 19:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiAUTmg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Jan 2022 14:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiAUTmg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Jan 2022 14:42:36 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B194C06173B
        for <linux-raid@vger.kernel.org>; Fri, 21 Jan 2022 11:42:36 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id f5so11073168qtp.11
        for <linux-raid@vger.kernel.org>; Fri, 21 Jan 2022 11:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FfCqnPi+iFTbI6wRfi2mHvFkJenmh/vVQGWZDQftWcw=;
        b=pVtF6Czb9sSEPBrsfRWwauaiT/RuX5f+8eAyx/WD+6jFSMnQndbHQ4Y+Pk2ZWrmb8b
         I0jGHpcyFund+6KwWK8GtLA+HQ8s81rAS7w5GUrn+keO2n4krOjKSTGovKL8hk1EVnfV
         YuQTnY5GCwykm0fDXniwizONKzo/x+h9DNOzqSVSJIPMdo8+eOQm5M5azhapcie4t2r2
         nMSbfFWrYCyvibMaULo/dpm4wiS8cNuZ+BiS5YoYnDBeFvQzsYJNnaeS3FBwaKRPNGlB
         SetlMRXZ6J5g1WKc/gxgUM9zPrL5qqn+wVARn7Iz/jEWnDtjuvGPS9y2UyGMwUzGYgjs
         Trag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FfCqnPi+iFTbI6wRfi2mHvFkJenmh/vVQGWZDQftWcw=;
        b=amn4dg93uT4CFKC/ynB6s5/hZAhDzrIMPnLl0++aup8M3KfXRFlcpchUsjIJEWPdyp
         ZhFKaRsnh0kjrljj3YRKIyHGlSgYsnOSL/+KgnIYjjYvPv6u/J31w8H7XnsHNpnIKdj+
         atVT9tYvqQYAHs5tZd5hhYDw1TuQJbrW+5zI4OPbrEBtI3tfo/qsWr26FSMeJ14sFiNT
         RJZJiP3lmYzMfUQvGp6MHjH5HgQY1Qd0upIv87E856iU+3FtTSukhbRVgBNzR9ZQhP+V
         Z1N7ay1C7Te17CsC0KqzaMzX9An1vn0qKoC2JvftNMqxTqZpRTq3wJUjQvXhBfJTe+HI
         HMqA==
X-Gm-Message-State: AOAM531dcbslrnHdf986JH8TC4cFYkZHKXjxVFvf5WGg3DAJiPV0MAu8
        Y7jsYdOmHv3asUwMgP4c9NJDAFF0rz1IKN4YPGo=
X-Google-Smtp-Source: ABdhPJyW2Mp0mgzzPaoxaPOLs9eGDhV6hmzGIeASpBHYtHbQF5PipJ3fvquY7ixzxLUjFxYOT2ppvLJIefZ8s3kTwNI=
X-Received: by 2002:a05:622a:508:: with SMTP id l8mr4541507qtx.412.1642794155315;
 Fri, 21 Jan 2022 11:42:35 -0800 (PST)
MIME-Version: 1.0
References: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
 <164254680952.24166.7553126422166310408@noble.neil.brown.name> <cfea15f4-228e-4a38-5567-9b710b6dc5c2@youngman.org.uk>
In-Reply-To: <cfea15f4-228e-4a38-5567-9b710b6dc5c2@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 21 Jan 2022 13:42:24 -0600
Message-ID: <CAAMCDefRDmfstAcqkbiq2rhGw4HeLa9fimOnKP8+Or_tB6=PMg@mail.gmail.com>
Subject: Re: PANIC OVER! Re: The mysterious case of the disappearing
 superblock ...
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     NeilBrown <neilb@suse.de>, anthony <antmbox@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>,
        Phil Turmel <philip@turmel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I do something with fewer moving parts for my backups:
dstring=`date +%Y%m%d`
DIRDATE=`date +%Y%m%d`

MONTH=`date +%Y%m`

DAY=`date +%d`
DIR=/2TB-backup
mkdir -p ${DIR}/backup/${MONTH}/${DIRDATE}

/usr/bin/rsync -xab --backup-dir=/${DIR}/backup/${MONTH}/${DIRDATE}/
<listofdirstobcakup> --excludefile <excludefilename> ${DIR} >>
${DIR}/backup/backups-${dstring}.out

If you run this every day/so often then you end up with any file that
is changed being in the backup/month/day structure and can see all
file changes going back as far as you have enough space for.

And when you are running low on space you delete the directories
associated with older dates, and you can easily see any old file
changes.

like so:

ls -l ./backup/*/*/*/datafile03.txt ./randomuser/datafile03.txt
-rw-r--r--. 1 randomuser randomuser  150 Jan 21  2016
./backup/201802/20180205/randomuser/datafile03.txt
-rw-r--r--. 1 randomuser randomuser 1019 Dec 19  2017
./backup/201911/20191110/randomuser/datafile03.txt
-rw-r--r--. 1 randomuser randomuser 1104 Sep  5  2019
./backup/202201/20220101/randomuser/datafile03.txt
-rw-r--r--. 1 randomuser randomuser 1874 Dec  7 11:06
./randomuser/datafile03.txt

On Fri, Jan 21, 2022 at 1:02 PM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 18/01/2022 23:00, NeilBrown wrote:
> >> Firstly, given that superblocks seem to disappear every now and then,
> >> does anybody have any ideas for something that might help us track it
> >> down? The 1.2 superblock is 4K into the device I believe? So if I copy
> >> the first 8K ( dd if=/dev/sda4 of=sda4.img bs=4K count=2 ) of each
> >> partition, that might help provide any clues as to what's happened to
> >> it? What am I looking for? What is the superblock supposed to look like?
>
> > Yes, 4K offset.  Yes, that dd command will get what you want it to.
> > It hardly matters what the superblock should looks like, because it
> > won't be there.  The thing you want to know is: what is there?
> > i.e.  you see random bytes and need to guess what they mean, so you can
> > guess where they came from.
> > Best to post the "od -x" output and crowd-source.
>
> That's exactly what I was thinking. But I was thinking if it had been
> damaged rather than destroyed maybe stuff would have been recoverable.
> >
> > Are you sure the partition starts haven't changed? Was the array made of
> > whole-devices or of partitions?
>
> That's what I missed. I forgot my array was on top of dm-integrity, so
> although I think of it as sda4, sdb1, sdc4, they each in fact have an
> extra layer between them and the raid.
>
> Dunno what or why, but my systemd service that fires that up failed.
> status tells me it was killed after 2msec.
>
> So if that wasn't running, the integrity devices weren't there, and
> mdadm couldn't start the array.
>
> Oh well, the good thing is that backup drive is on its way. I'm planning
> to put plain lvm on it, and write a bunch of services that create backup
> volumes then do a overwrite-in-place rsync. So as I keep advising
> people, it does an incremental backup, but the COW volumes mean I have
> full backups.
>
> Cheers,
> Wol
