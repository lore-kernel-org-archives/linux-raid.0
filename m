Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57CAC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 17:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ECB261159
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 17:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhKJRyK convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Nov 2021 12:54:10 -0500
Received: from group.wh-serverpark.com ([159.69.170.92]:56198 "EHLO
        group.wh-serverpark.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbhKJRyJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Nov 2021 12:54:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 90DFAEEA03A;
        Wed, 10 Nov 2021 18:51:20 +0100 (CET)
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id BxnguPyW0fgA; Wed, 10 Nov 2021 18:51:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id B339EEEBA3E;
        Wed, 10 Nov 2021 18:51:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at valiant.wh-serverpark.com
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GkFte_15o6zr; Wed, 10 Nov 2021 18:51:19 +0100 (CET)
Received: from enterprise.localnet (unknown [93.189.159.254])
        by group.wh-serverpark.com (Postfix) with ESMTPSA id 98101EEA03A;
        Wed, 10 Nov 2021 18:51:19 +0100 (CET)
From:   Markus Hochholdinger <Markus@hochholdinger.net>
To:     Neil Brown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, Chris Webb <chris@arachsys.com>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running arrays.
Date:   Wed, 10 Nov 2021 18:51:19 +0100
Message-ID: <1941952.8ZYzkbqb7V@enterprise>
User-Agent: KMail/5.2.3 (Linux/4.19.0-0.bpo.6-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <1930539.SuHy7v25Ye@enterprise>
References: <20080627164503.9671.patches@notabene> <201203242147.23273.Markus@hochholdinger.net> <1930539.SuHy7v25Ye@enterprise>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Am Mittwoch, 10. November 2021, 14:09:53 CET schrieb Markus Hochholdinger:
> Am Samstag, 24. März 2012, 21:47:15 CET schrieb Markus Hochholdinger:
> > it's been a long time, but today I tried again and had success!
> > Am 28.06.2008 um 01:41 Uhr schrieb Neil Brown <neilb@suse.de>:
> > > On Friday June 27, Markus@hochholdinger.net wrote:
> > > > Am Freitag, 27. Juni 2008 08:51 schrieb NeilBrown:
> > > > > From: Chris Webb <chris@arachsys.com>
> > [..]
> > > You don't want to "mdadm --grow" until everything has been resized.
> > > First lvresize one disk, then write '0' to the .../size file.
> > > Then do the same for the other disk.
> > > Then "mdadm --grow /dev/mdX --size max".
> > it works for me, if I do:
> >   echo 0 > /sys/block/md2/md/rd0/size
> >   mdadm --grow /dev/md2 --size=max
> >   # till here, nothing happens
> >   echo 0 > /sys/block/md2/md/rd1/size
> >   mdadm --grow /dev/md2 --size=max
> >   # rebuild of the added space begins
> This has been working for me till at least kernel 4.19.x and I first
> recognized it not working anymore with kernel 5.10.x . So inbetween
> something changed regarding the resize and grow of md raid1 with superblock
> version 1.0. The grow still works and a rebuild is done, but afterwards the
> superblock isn't created/moved to the new end of the devices. The raid1
> works until you stop it, but you won't be able to re-assemble it
> (re-creating works). While re-creating I recognized the grown filesystem
> (after the raid1 was grown) was too large (fsck complained).
> I already tracked it down to the version of the metadata/superblock. With
> version 1.0 (superblock at the end) the above fails and it looks like the
> superblock on the grown device is somehow there but with wrong informations
> (mdadm --zero-superblock has removed something while mdadm -D .. tells me,
> there's no superblock).
> All works fine with superblock version 1.2 (superblock at the beginning).
> Any ideas what could have changed so the grow feature for raid1 with
> superblock version 1.0 isn't working anymore?
> For now the workaround is to really remove a grown device from the raid1 and
> do a full rebuild before re-adding the other grown device.
> I'll test the different kernel versions to see, where/when this feature was
> lost.

It is working es (I) expected till at least kernel 5.4.158.

It is not working with 5.10.x till 5.15.1.

On my old systems (kernel <= 5.4.x) after resizing one component
  mdadm -E /dev/xvda2
is able to see the moved superblock only after
  echo 0 > /sys/block/md2/md/rd0/size

On new systems (kernel >= 5.10.0) it doesn't matter if I issue
  echo 0 > /sys/block/md2/md/rd0/size
mdadm -E keeps complaining about no superblock on the grown device.
(The bitmap was removed before the echo 0 and I tried to remove the bitmap at 
all before resizing, still the same issue.)

It's only possible to remove the changed device and add with a full rebuild. 
But this isn't possible, if both devices were resized before. mdadm complains 
about no metadata available, no matter what I do while the md raid1 is still 
running (where is the superblock updated on the disks then?).


> > If I do only:
> >   echo 0 > /sys/block/md2/md/rd0/size
> >   echo 0 > /sys/block/md2/md/rd1/size
> >   mdadm --grow /dev/md2 --size=max
> > 
> > nothing will change.
> > As I understand, with "echo 0" md sees the new size and only with --grow
> > the superblock will be moved.
> > I'm doing this with 2.6.32-5-xen-686 within Debian (squeeze) 6.0.
> > Many thanks to you and all the other linux-raid developers for this
> > feature! I'm very happy about this :-)


-- 
Mfg

Markus Hochholdinger
