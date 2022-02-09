Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88F9C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 20:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiBIU6f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 15:58:35 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiBIU63 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 15:58:29 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B74C043181
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 12:58:32 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id x5so2949203qtw.10
        for <linux-raid@vger.kernel.org>; Wed, 09 Feb 2022 12:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zkSZ6bcFZBYafA1JqYtldqzQ16y/hSamKVyNAO31Je8=;
        b=OGFHgdr39gnF6AzFHt1IRGid1Ob9j6VvMhko0hykOQQ78wYHN3ywZ1ISxUk45G0p/S
         szG2B2Cd3M0SjFtL1LnIL04MgKi9OIq7DOtXYa5JJKSk+guf5LPvhA79jOo5VFepOCXo
         DkQ5RlWizRY/bPFfQJyaktQd4sbZCqFKD1wgsgTEMFHYcb/rQ17azlUrYElgN4eGF45j
         EGUvHRl3cD5dCvAjRDQ6QLrlHeGdRdBhKV+CViDeVGKyc24yrZKRvacHjRRWtH8Sg+Vm
         n16Olf0mSqjCKtGy7yE+oexmYCHCWNhTCzeuEpK2cK7ABTXHPiVVIKejHQ4GJbUlV4az
         HO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zkSZ6bcFZBYafA1JqYtldqzQ16y/hSamKVyNAO31Je8=;
        b=ulqhF8XW4NNXtwOj1g5RZEt5oeDqR9tHg0aFqa1ZSRDpNuDAPxp+PYSLvXJeV5YqVs
         KVQgS7bKcQBmoNkVKBm9WUUHuSXPVbvBse5I/+FGo/h0dM5k/A8v+69atcJZtemmxiyr
         z0qQwShqjDCkVwIzIIp1MMyXCJ34+y/DCY4YgyDSiDr2bLOtfVR3RpI+6GAoUU0I4PZQ
         QJu0vLxTgyg5+lVQvDJwEuM42EJThyTY1RwhY3+s/mIFjC0qTbn0jowsEJ5FchRl6kG7
         Bxb4cFgZ5IaLi5Qn4hqSLIx/F7EO41yiURMxLugUxWFYRFvn2Yhr/PN4XvxMbNMJrPrt
         A2zg==
X-Gm-Message-State: AOAM532b6+3PJnjZZS4EgItTHUYYXWSvAyBhRKjxC6LU56zwrGWZudfG
        46Wrsyr3p/6IGbX4EK6dLrlObZqFd14=
X-Google-Smtp-Source: ABdhPJyEL2XAExUDnM7VsQjPy5BFv8nZy3cjWM95JGrQ/zl2hvjZO2Sq1PP/NbGv3CdHeA9MLxBg+Q==
X-Received: by 2002:a05:622a:11c9:: with SMTP id n9mr2695465qtk.592.1644440311123;
        Wed, 09 Feb 2022 12:58:31 -0800 (PST)
Received: from falcon.sitarc.ca ([2607:fea8:c39f:f018::c39])
        by smtp.gmail.com with ESMTPSA id s6sm8936377qko.93.2022.02.09.12.58.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Feb 2022 12:58:30 -0800 (PST)
Date:   Wed, 9 Feb 2022 15:58:25 -0500
From:   Red Wil <redwil@gmail.com>
To:     Wol <antlists@youngman.org.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Replacing all disks in a an array as a preventative measure
 before failing.
Message-ID: <20220209155825.1c8a3570@falcon.sitarc.ca>
In-Reply-To: <c6873b6a-eabf-d6db-80f1-20b75a37bca7@youngman.org.uk>
References: <20220207152648.42dd311a@falcon.sitarc.ca>
        <c6873b6a-eabf-d6db-80f1-20b75a37bca7@youngman.org.uk>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 7 Feb 2022 22:28:57 +0000
Wol <antlists@youngman.org.uk> wrote:

> On 07/02/2022 20:26, Red Wil wrote:
> > Hello,
> > 
> > It started as the subject said:
> >   - goal was to replace all 10 disks in a R6
> >   - context and perceived constraints
> >     - soft raid (no imsm and or ddl containers)
> >     - multiple disk partition. partitions across 10 disks formed R6
> >     - downtime not an issue
> >     - minimize the number of commands
> >     - minimize disks stress
> >     - reduce the time spent with this process
> >     - difficult to add 10 spares at once in the rig
> >     - after a reshape/grow from 6 to 10 disks offset of data in raid
> >       members was all over the place from cca 10ksect to 200ksect
> > 
> > Approaches/solutions and critique
> >   1- add one by one a 'spare' and 'replace' raid member
> >    critique:
> >    - seem to me long and tedious process
> >    - cannot/will not run in parallel  
> 
> There's not a problem running in parallel as far as mdraid is
> concerned. If you can get the spare drives into the chassis (or on
> eSATA), you can --replace several drives at once.
> 
> And it pretty much just does a dd, just on the live system keeping
> you raid-safe.
If I remember correctly if you have multiple partitions on a single
disk (different arrays obviously) if you start a syn/resync op, for
example, on all arrays from that particular spindle/disk, it will be
done sequentially. If it would do it in parallel -> heads movement
stress.
> 
> >   2- add all the spares at once and perform 'replace' on members
> >    critique
> >    - just tedious - lots of cli commands which can be prone to
> > mistakes.  
> 
> pretty much the same as (1). Given that your sdX's are moving all
> over the place, I would work with uuids even though it's more typing,
> it's safer.
> 
> >   next ones assume I have all the 'spares' in the rig
> >   3- create new arrays on spares, fresh fs and copy data.  
> 
> Well, you could fail/replace all the old drives, but yes just
> building a new array from scratch (if you can afford the downtime) is
> probably better.
Another reason to go this route was to tune/tweak the stack
(RAID-LVM-FS)
> 
> >   4- dd/ddrescue copy each drive to a new one. Advantage can be
> > done one by one or in parallel. less commands in the terminal.  
> 
> Less commands? Dunno about that. Much safer in many ways though,
> remove the drive you're replacing, copy it, put the new one back.
> Less chance for a physical error.
well.. it's a matter of perception. for 10 disks I will have 10 dd
commands of the form "dd if=olddrive of=newdrive <some params>" or even
better "ddrescue olddrive newdrive logfile" otherwise all the "mdadm
commands" would be 50 in total for 10 disks for I have 5 individual
arrays across 10 disks
> > 
> > In the end I decided I will use route (3).
> >   - flexibility on creation
> >   - copy only what I need
> >   - old array is a sort of backup
> > 
> > Question:
> > Just for my curiosity regarding (4) assuming array is offline:
> > Besides being not recommended in case of imsm/ddl containers which
> > (as far as i understood) keep some data on the hardware itself
> > 
> > In case of pure soft raid is anything technical or safety related
> > that prevents a 'dd' copy of a physical hard drive to act exactly
> > as the original.
> >   
> Nope. You've copied the partition byte for byte, the raid won't know
> any different.
> 
> One question, though. Why are you replacing the drives? Just a
> precaution?
> 
> How big are the drives? What I'd do if you're not replacing dying 
> drives, is buy five or possibly six drives of twice the capacity. Do
> a --replace on those five drives. Now take two of the drives you've 
> removed, raid-0 them, and now do a major re-org, adding your raid-0
> as device 6, reducing your raid to a 6-device array, and removing the
> last four old drives from the array. Assuming you've only got 10 bays
> and you've been faffing about externally as you replace drives, you
> can now use the last three drives in the chassis to create another
> two-drive raid-0, add that as a spare into your raid-6, and add your
> last drive as a spare into both your raid-0s.
> 
> So you end up with a 6-device+plus-spare raid-6, and devices 6 &
> spare (your raid-0s) share a spare between them.
> 
> Cheers,
> Wol
I was thinking of cutting nr. of drives to 6 from 10 by using double
size drives but financial considerations at the time end up with 10
slightly larger drives.

Thanks for your comments
Red
