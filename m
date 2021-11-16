Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D192BC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 09:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A084563222
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 09:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhKPJbT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Nov 2021 04:31:19 -0500
Received: from group.wh-serverpark.com ([159.69.170.92]:46878 "EHLO
        group.wh-serverpark.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbhKPJbS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Nov 2021 04:31:18 -0500
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 3C75AEE292F;
        Tue, 16 Nov 2021 10:28:18 +0100 (CET)
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id VV99SJu8Y4bK; Tue, 16 Nov 2021 10:28:17 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 4ED29EE46FD;
        Tue, 16 Nov 2021 10:28:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at valiant.wh-serverpark.com
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id x6VidDKrP2Um; Tue, 16 Nov 2021 10:28:17 +0100 (CET)
Received: from enterprise.localnet (unknown [93.189.159.254])
        by group.wh-serverpark.com (Postfix) with ESMTPSA id 2DFB6EE292F;
        Tue, 16 Nov 2021 10:28:17 +0100 (CET)
From:   Markus Hochholdinger <Markus@hochholdinger.net>
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
Date:   Tue, 16 Nov 2021 10:28:16 +0100
Message-ID: <3122218.nCYcmegLye@enterprise>
In-Reply-To: <CALTww2-wLq1wvTABUft0hBg1gC2Qx+a_fUX2TZMJg0vve2uLBw@mail.gmail.com>
References: <20211112142822.813606-1-markus@hochholdinger.net> <181899007.qP1mJhO4kW@enterprise> <CALTww2-wLq1wvTABUft0hBg1gC2Qx+a_fUX2TZMJg0vve2uLBw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

Am Dienstag, 16. November 2021, 08:53:44 CET schrieb Xiao Ni:
> On Tue, Nov 16, 2021 at 2:39 AM Markus Hochholdinger
[..]
> > This is very neat, because we can grow the raid1 and the filesystem size
> > in a very short time frame and don't have to rebuild the raid1 twice
> > (remove one device, resize and add with full rebuild because the old
> > superblock is somewhere inbetween, then the same for the other device)
> > before we can grow the raid1 and the filesystem.
> > If this explanation is not enough why we need this feature, I can explain
> > in more detail why someone would do the software raid1 within a VM if you
> > like.
> It's enough. But could you talk more about the reason why create a
> raid1 in a vm?
> I want to know more scenarios that use raid devices.

sure. If you don't have the money for a big redundant storage, with multipath 
and fibre and so on you can use just two or more cheap servers (redundant array 
of inexpensive servers) which provide logical volumes of their local (maybe 
non redundant) disks as a iSCSI LUN to the other servers.
Now you build a VM by using two such volumes from different servers and do the 
raid1 inside the VM. If one server fails, there is still the other server who 
has the data. If the volumes are accessible on each hypervisor host by the 
same path you can live migrate your VMs freely between these hosts.
You have a shared nothing architecture, the only thing you have to take care 
of is, that a VM is only running once. You don't need heartbeat/pacemaker/.. 
or any other cluster software to take care about split brain situations within 
the storage. The RAID1 takes care about this inside the VM.

The raid1 bitmap helps a lot if you want to take one server into maintenance 
and re-add it afterwards, because only the changes on the raid1 have to be 
resynced.

By using metadata 1.0, the super block is at the end on the logical volumes 
and you can easily do a snpashot of the logical volumes and mount the snapshot 
for backups without calculating or guessing an offset.

We are using this setup for our customers since 2006 in production. The bitmap 
helped a lot with speeding up the resync after a server goes temporary off.
But growing was a pain, because you had to resync twice with the grown volumes 
before you could resize the raid1 and the filesystem.
Since the patch https://marc.info/?l=linux-raid&m=121455006810540&w=2 from 
2008 it was possible to grow a raid1 (and the underlaying disks) without full 
resync of the raid1 and this is working for me since at least kernel 2.6.32.


> > As I understand, if the superblock isn't moved and we have grown the array
> > and the filesystem on it, the superblock will now be updated inbetween
> > the filesystem and may corrupt the filesystem and data.
> > Funny thing, after both devices are resized, the raid1 is still online and
> > the grow does work. But afterwards, one can't do anything with the raid1,
> > you get errors about the superblock, e.g. mdadm -D .. works, but mdadm -E
> > .. for both devices doesn't. You can remove one device from the raid1,
> > but you can't add it anymore, mdadm --add .. says: "mdadm: cannot load
> > array metadata from /dev/ md0". And you can't re-assemble the raid1 after
> > it is stopped.
> mdadm -D reads information from files under /sys/block/md. mdadm -E reads
> data from disk. So one works and the other doesn't. And in kernel space, it
> doesn't update
> the superblock offset, and it still reads superblock from the old
> position. But in userspace
> it calculates the superblock position based on the disk size. It's in
> a mess now.

I see. Maybe some trigger to  /sys/block/mdX/.. could help to sync from kernel 
to disk and the other way round? But this isn't thought out.

[..]
> Thanks again for those detail steps.

Thank you for your time.

Regards,
Markus


