Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF70C77B75
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 05:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjEWFEn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 01:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjEWFEm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 01:04:42 -0400
Received: from bird.elm.relay.mailchannels.net (bird.elm.relay.mailchannels.net [23.83.212.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF9AFA
        for <linux-raid@vger.kernel.org>; Mon, 22 May 2023 22:04:39 -0700 (PDT)
X-Sender-Id: a2hosting|x-authuser|raid@electrons.cloud
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 42E723E1A09;
        Tue, 23 May 2023 05:04:39 +0000 (UTC)
Received: from mi3-ss61.a2hosting.com (unknown [127.0.0.6])
        (Authenticated sender: a2hosting)
        by relay.mailchannels.net (Postfix) with ESMTPA id 1AE933E19B8;
        Tue, 23 May 2023 05:04:38 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1684818278; a=rsa-sha256;
        cv=none;
        b=6YT1tihXoQ4lL/fAMcD6dfStcY0+9RNUu/XimHy+TTjGCP14GD6DGdUAO05Ul71TZZHu/C
        R6YuX/WxCrYjNp7ZFvAG3kjR+aHzalpIGrrec+NhajOVY4o3GeBDufQ+39X9oFyRZhy5w9
        LJkkmNt/1EZFbMBJOsCE5UMfUyT47Zugmee9+P300AGiK5/xBgDoC8BTd3/0RO4vFCfy4B
        EXyssPIUhPmD7Ec/S+LKo3brs7R45F4W8mK2EFdvdNsX6n/GVRgKM96NAyc1x1EEW+XI/W
        XIpXNBFt6ZSM8Bi9CKsJUJhoHfgyrs7LxQsHJ255GinwTj7hr/jw+uxcgl7BCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1684818278;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=sewG6B18FIHJPhl3WqJtB5e84z/z41bZpL/VTLhzONw=;
        b=0fgAtZkqwr0XtI7/scvPj7CF0Fu6Gl6j61zTEKneSfFjvZxHg3kLHEiGYB0PESvEN6mggG
        czAGZ46FPn5gnmjJNzx89mBrbP4gRCKZRf9tpu4lgaW31u1iLOFAjtrWOZAYQhV0VwEycl
        RVhh0SZCwIle3fzpw/XjFRd2jOnK9KzOBKcqSyTjLN5DxUJPL8jr8cy9nEOdv3FuiPkNzn
        JxsEurOls5QECDdkPbzGFwjzZ48Wic7dXSvfM9v3Q9HeSCvrsZnQbVp+Rv8Dzw2IqxNCNQ
        5S6z5H/o/5XfGR7rCfC4tgnFpTgmom93/x/7CUd+HGlwYoGgPdSgUazIpqwFjQ==
ARC-Authentication-Results: i=1;
        rspamd-79bb5575d7-8tqnd;
        auth=pass smtp.auth=a2hosting smtp.mailfrom=raid@electrons.cloud
X-Sender-Id: a2hosting|x-authuser|raid@electrons.cloud
X-MC-Relay: Neutral
X-MailChannels-SenderId: a2hosting|x-authuser|raid@electrons.cloud
X-MailChannels-Auth-Id: a2hosting
X-Spot-Cooing: 3fd53256723c30ce_1684818278989_269757728
X-MC-Loop-Signature: 1684818278989:4128202976
X-MC-Ingress-Time: 1684818278988
Received: from mi3-ss61.a2hosting.com (mi3-ss61.a2hosting.com [70.32.23.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.125.42.166 (trex/6.8.1);
        Tue, 23 May 2023 05:04:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=electrons.cloud; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:
        Message-ID:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sewG6B18FIHJPhl3WqJtB5e84z/z41bZpL/VTLhzONw=; b=pbZpjPHwv4W/U/BKvJeUR4IRvl
        Gyxl9ol0dnIV/KzDZBEVJmI9YvUrldyvflkukCLnh6675Vxe1gqLbJQyDA8INsoZuqtkllQkbZY0d
        sO4rwvaxJZYdoMT6YcNEOhYpAAnPnFcyiM5iuIY6gMplDxQvoFIlAHZtI/LKzmhvA0kFt5FjqsTFl
        o4RulP73JJWLyLQv+arJZ2s6hiq13JZ2jqtSwyWu/npqHf1f67/OiZr+spwc70/cEzWVxEbErjzpD
        QmVatiWp5OqGdTRxZ25nvTZ9fuP3ccfBjlslUytKcvsv+dfT8FF90yvu56GcWoJ37UXxXsEBVEfqU
        YLC1IUIQ==;
Received: from [2.56.191.211] (port=42722 helo=OAK2023)
        by mi3-ss61.a2hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <raid@electrons.cloud>)
        id 1q1KCK-0005qu-1Y;
        Tue, 23 May 2023 01:04:36 -0400
Message-ID: <a971aabd9c730f9c880155847fd30721682335cc.camel@electrons.cloud>
Subject: Re: RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
 (HARDLOCK)
From:   raid <raid@electrons.cloud>
Reply-To: raid@electrons.cloud
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, Wol <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>, "yukuai (C)" <yukuai3@huawei.com>
Date:   Tue, 23 May 2023 00:04:34 -0500
In-Reply-To: <CAAMCDedzs2mi7TGrOUKkSDPVqOQvq+j2JMa3WOtzOtwt7324Jw@mail.gmail.com>
References: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
         <96524acc-504d-6a07-85a0-0b56a9e2f2d7@youngman.org.uk>
         <9b22d5ce-5f1b-0fc8-acdc-02c2e8cefa55@huaweicloud.com>
         <b18cfe9f6f8e44285aa4ab4300e0c0e1b863fe08.camel@electrons.cloud>
         <a78c4551-defb-d531-3b5e-372889158f28@huaweicloud.com>
         <3f3fd288e33cccdae32e3f26943218c773589849.camel@electrons.cloud>
         <CAAMCDedzs2mi7TGrOUKkSDPVqOQvq+j2JMa3WOtzOtwt7324Jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: raid@electrons.cloud
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi

The command that I used was straight forward, I believe.

Here goes, Hopefully this helps clearify (best that I can recall since the terminal history
was destroyed.)

sync; sudo umount /MEGARAID
sudo mdadm -S /dev/md480
sudo mdadm --add /dev/md480 /dev/sde1 ## New drive was prepped and /dev/sde initially
sudo mdadm --grow --raid-devices=4 /dev/md480

I have a function within .bashrc watchraid(){ watch -c -d -n 1 cat /proc/mdstat ;} 
So, that is running all the time and it reported ~4-5 days to complete.

I paused it successfully using either...
echo "frozen" > /sys/block/md480/md/sync_action
OR
echo "idle" >  /sys/block/md480/md/sync_action
(No history available.)

Used rsync to copy ~450GB from network share onto the idling raid.
When rsync completed sucessfully I attempted to rename the rsync log file using Thunar.
It flashed back to the file listing without renaming the file.
So, I tried exact same name again. Same failure. 

Within seconds, every open application/terminal window stopped responding.
(Looking back I probably should have tried a TTY terminal.) Instead I pushed reset button.
Reshaping was at ~30% and stalled. X was completely unresponsive. Hit the reset switch.

The reboot was absolutely normal. The RAID was operational and filesystem intact.
Here's where it gets fuzzy, panic was setting in because the drives didn't look right in
the watch terminal. There were five drives now. One showing failed/removed. I can't recall
if it started reshaping automatically. It shouldn't have. I'm now beginning to believe that
I made a sloppy typo while restarting the reshape manually? In any event, I continued with
routine daily activities while the RAID reshaped. Alot happens in 3-5 days while reshaping.

At ~80% the speed slowed to 0.
sudo umount /MEGARAID
sudo mdadm -S /dev/md480

I had to add a new card to the machine; 1TB NVMe on a PCIe card.
Shutdown. Added card. Booted all looked normal.
However, the filesystem on the raid couldn't auto mount.

watch -c -d -n 1 cat /proc/mdstat

All previously active drives were now listed as spares. So, Life goes on. And here I am now.
The 1TB NVMe that I added is formatted, fully functional and hasn't interfered.

Anyhow, After I create a RAID, I prefer to let mdadm handle itself. In other words, I avoid
using the --force'ing optino. mdadm has been very robust over the years.

I can only conclude that I made a sloppy typo. Right now I'm just trying to deal with the
current state of the array.

I appreciate that your free time has great value. Thank you.
SA

Oh, kind of a silver lining that maybe of interest, I found that the ~7,000 scanned documents
were cataloged/THUMNAILED in a photo album within the digiKam program on a non raid partition.
Most thumbnails are abolutely legible, so, I have high confidence of originals that are lost.

Cheers for having a few luck attributes.

On Mon, 2023-05-22 at 18:50 -0500, Roger Heflin wrote:
> Given what the array is reporting I would doubt that is going to fix
> anything.    The array being in the middle of a reshape makes it
> likely that neither n or n-1 is the right raid config for at least 1/2
> of the data, so it is likely the filesystem will be completely broken.
> 
> Right now the array reports it is a 5 disk array, and the array data
> says it was going from 4 disks to 5.
> 
> What was the command you used to add the 4th disk?     No one is sure
> based on what you are saying how exactly the array got into this
> state.   The data being shown disagrees with what you are reporting,
> and given that no one knows what actually happened.
> 
> On Mon, May 22, 2023 at 3:18 PM raid <raid@electrons.cloud> wrote:
> > Hi
> > 
> > Thanks for your time so far ! Final questions before I rebuild this RAID from scratch.
> > 
> > BTW I created detailed notes when I created this array (as I have for eight other RAIDs that I maintain).
> >     These notes may be applicable later... Here's why.
> > 
> > Do you think that Zero'ing the drives (as is done for initial drive prep) and then recreating the
> > RAID5 using the initial settings (originally three drives, NOW four drives) could possibly offer
> > a greater chance to recover files? As in, more complete file recovery if the striping aligns
> > correctly? Technically, I've had to write off the files that aren't currently backed up.
> > 
> > However, I'm still willing to make an attempt if you think the idea above might yield something
> > better than one or two stripes of data per file?
> > 
> > And/Or any other tips for this final attempt? Setting ReadOnly if possible?
> > 
> > Thanks Again
> > SA
> > 
> > ---
> > Detailed Notes:
> > ============================================================
> >   2021.10.26 0200P NEW RAID MD480 (48TB) 3x 1600GB HITACHI
> > ====================================================================================================================
> > ====
> > = PREPARATION ==
> > 
> > watch -c -d -n 1 cat /proc/mdstat  ############## OPEN A TERMINAL AND MONITOR STATUS ##
> > 
> > sudo lsblk && sudo blkid  ########################################### VERIFY DEVICES ##
> > 
> > sudo umount /MEGARAID                         # Unmount if filesystem is mounted
> > sudo mdadm --stop /dev/md480                  # Stop the RAID/md480 device
> > sudo mdadm --zero-superblock /dev/sd[cdf]1    # Zero  the   superblock(s)  on
> >                                               #      all members of the array
> > sudo mdadm --remove /dev/md480                # Remove the RAID/md480
> > 
> > Edit  ########################################## OPTIONAL FINALIZE PERMANENT REMOVAL ##
> > /etc/fstab
> > /etc/mdadm/mdadm.conf
> > Removing referrences to the mounting and the definition of the RAID/MD480 device(s)
> > NOTE: Some fstab CFG settings allow skipping devices when unavailable at boot. (nofail)
> > 
> > sudo update-initramfs -uv       # -uv  update ; verbose  ########### RESET INITRAMFS ##
> > 
> > ======================================================================================== CREATE RAID & ADD
> > FILESYSTEM ==
> >   MEGARAID 2021.10.26 0200P
> > ##############  RAID5 ARRAY MD480 32TB (32,001,527,644,160 bytes) Available (3x16TB) ##
> > 
> > sudo mdadm --create --verbose /dev/md480 --level=5 --raid-devices=3 --uuid=2021102502005a7a5a7abeefcafebabe
> > /dev/sd[cdf]1
> > 
> > 31,251,491,840 BLOCKS CREATED IN ~20 HOURS
> > 
> > ############################################################  CREATE FILESYSTEM EXT4 ##
> >  -v VERBOSE
> >  -L DISK LABEL
> >  -U UUID FORMATTED AS 8CHARS-4CHARS-4CHARS-4CHARS-12CHARS
> >  -m OVERFLOW PROTECTION PERCENTAGE IE. .025 OF 24,576GB IS ~615MB FREE IS CONSIDERED FULL
> >  -b BLOCK SIZE 1/4 OF STRIDE= OFFERS BEST OVERALL PERFORMANCE
> >  -E STRIDE= MULTIPLE OF 8
> >     STRIPE-WIDTH= STRIDE X 2
> > 
> > sudo mkfs.ext4 -v -L MEGARAID    -U 20211028-0500-5a7a-5a7a-beefcafebabe -m .025 -b 4096 -E stride=32,stripe-
> > width=64
> > /dev/md480
> > 
> > sudo mkdir  /MEGARAID  ; sudo chown adminx:adminx -R /MEGARAID
> > 
> > ##############################################################  SET CORRECT HOMEHOST ##
> > 
> > sudo umount /MEGARAID
> > sudo mdadm --stop /dev/md480
> > sudo mdadm --assemble --update=homehost --homehost=GRANDSLAM /dev/md480 /dev/sd[cdf]1
> > sudo blkid
> > 
> > /dev/sdc1: UUID="20211025-0200-5a7a-5a7a-beefcafebabe"
> >            UUID_SUB="8f0835db-3ea2-4540-2ab4-232d6203d1b7"
> >            LABEL="GRANDSLAM:480" TYPE="linux_raid_member"
> >            PARTLABEL="HIT*16TB*001*RAID5"
> >            PARTUUID="3b68fe63-35d0-404d-912e-dfe1127f109b"
> > 
> > /dev/sdd1: UUID="20211025-0200-5a7a-5a7a-beefcafebabe"
> >            UUID_SUB="b4660f49-867b-9f1e-ecad-0acec7119c37"
> >            LABEL="GRANDSLAM:480" TYPE="linux_raid_member"
> >            PARTLABEL="HIT*16TB*002*RAID5"
> >            PARTUUID="32c50f4f-f6ce-4309-b8e4-facdb6e05ba8"
> > 
> > /dev/sdf1: UUID="20211025-0200-5a7a-5a7a-beefcafebabe"
> >            UUID_SUB="79a3dff4-c53f-9071-f9c1-c262403fbc10"
> >            LABEL="GRANDSLAM:480" TYPE="linux_raid_member"
> >            PARTLABEL="HIT*16TB*003*RAID5"
> >            PARTUUID="7ec27f96-2275-4e09-9013-ac056f11ebfb"
> > 
> > /dev/md480: LABEL="MEGARAID" UUID="20211028-0500-5a7a-5a7a-beefcafebabe" TYPE="ext4"
> > 
> > ############################################################### ENTRY FOR /ETC/FSTAB ##
> > 
> > /dev/md480              /MEGARAID               ext4            nofail,noatime,nodiratime,relatime,errors=remount-ro
> > 0               2
> > 
> > #################################################### ENTRY FOR /ETC/MDADM/MDADM.CONF ##
> > 
> > ARRAY /dev/md480 metadata=1.2 name=GRANDSLAM:480 UUID=20211025:02005a7a:5a7abeef:cafebabe
> > 
> > #######################################################################################
> > 
> > sudo update-initramfs -uv       # -uv  update ; verbose
> > sudo mount -a
> > sudo chown adminx:adminx -R /MEGARAID
> > 
> > ############################################################### END 2021.10.28 0545A ##
> > 
> > 
> > 
> > 
> > 
> > 
> > On Mon, 2023-05-22 at 15:51 +0800, Yu Kuai wrote:
> > > Hi,
> > > 
> > > 在 2023/05/22 14:56, raid 写道:
> > > > Hi,
> > > > Thanks for the guidance as the current state has at least changed somewhat.
> > > > 
> > > > BTW Sorry about Life getting in the way of tech. =) Reason for my delayed response.
> > > > 
> > > > -sudo mdadm -I /dev/sdc1
> > > > mdadm: /dev/sdc1 attached to /dev/md480, not enough to start (1).
> > > > -sudo mdadm -D /dev/md480
> > > > /dev/md480:
> > > >             Version : 1.2
> > > >          Raid Level : raid0
> > > >       Total Devices : 1
> > > >         Persistence : Superblock is persistent
> > > > 
> > > >               State : inactive
> > > >     Working Devices : 1
> > > > 
> > > >       Delta Devices : 1, (-1->0)
> > > >           New Level : raid5
> > > >          New Layout : left-symmetric
> > > >       New Chunksize : 512K
> > > > 
> > > >                Name : GRANDSLAM:480
> > > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > > >              Events : 78714
> > > > 
> > > >      Number   Major   Minor   RaidDevice
> > > > 
> > > >         -       8       33        -        /dev/sdc1
> > > > -sudo mdadm -I /dev/sdd1
> > > > mdadm: /dev/sdd1 attached to /dev/md480, not enough to start (2).
> > > > -sudo mdadm -D /dev/md480
> > > > /dev/md480:
> > > >             Version : 1.2
> > > >          Raid Level : raid0
> > > >       Total Devices : 2
> > > >         Persistence : Superblock is persistent
> > > > 
> > > >               State : inactive
> > > >     Working Devices : 2
> > > > 
> > > >       Delta Devices : 1, (-1->0)
> > > >           New Level : raid5
> > > >          New Layout : left-symmetric
> > > >       New Chunksize : 512K
> > > > 
> > > >                Name : GRANDSLAM:480
> > > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > > >              Events : 78714
> > > > 
> > > >      Number   Major   Minor   RaidDevice
> > > > 
> > > >         -       8       49        -        /dev/sdd1
> > > >         -       8       33        -        /dev/sdc1
> > > > -sudo mdadm -I /dev/sde1
> > > > mdadm: /dev/sde1 attached to /dev/md480, not enough to start (2).
> > > > -sudo mdadm -D /dev/md480
> > > > /dev/md480:
> > > >             Version : 1.2
> > > >          Raid Level : raid0
> > > >       Total Devices : 3
> > > >         Persistence : Superblock is persistent
> > > > 
> > > >               State : inactive
> > > >     Working Devices : 3
> > > > 
> > > >       Delta Devices : 1, (-1->0)
> > > >           New Level : raid5
> > > >          New Layout : left-symmetric
> > > >       New Chunksize : 512K
> > > > 
> > > >                Name : GRANDSLAM:480
> > > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > > >              Events : 78712
> > > > 
> > > >      Number   Major   Minor   RaidDevice
> > > > 
> > > >         -       8       65        -        /dev/sde1
> > > >         -       8       49        -        /dev/sdd1
> > > >         -       8       33        -        /dev/sdc1
> > > > -sudo mdadm -I /dev/sdf1
> > > > mdadm: /dev/sdf1 attached to /dev/md480, not enough to start (3).
> > > > -sudo mdadm -D /dev/md480
> > > > /dev/md480:
> > > >             Version : 1.2
> > > >          Raid Level : raid0
> > > >       Total Devices : 4
> > > >         Persistence : Superblock is persistent
> > > > 
> > > >               State : inactive
> > > >     Working Devices : 4
> > > > 
> > > >       Delta Devices : 1, (-1->0)
> > > >           New Level : raid5
> > > >          New Layout : left-symmetric
> > > >       New Chunksize : 512K
> > > > 
> > > >                Name : GRANDSLAM:480
> > > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > > >              Events : 78714
> > > > 
> > > >      Number   Major   Minor   RaidDevice
> > > > 
> > > >         -       8       81        -        /dev/sdf1
> > > >         -       8       65        -        /dev/sde1
> > > >         -       8       49        -        /dev/sdd1
> > > >         -       8       33        -        /dev/sdc1
> > > > -sudo mdadm -R /dev/md480
> > > > mdadm: failed to start array /dev/md480: Input/output error
> > > > ---
> > > > NOTE: Of additional interest...
> > > > ---
> > > > -sudo mdadm -D /dev/md480
> > > > /dev/md480:
> > > >             Version : 1.2
> > > >       Creation Time : Tue Oct 26 14:06:53 2021
> > > >          Raid Level : raid5
> > > >       Used Dev Size : 18446744073709551615
> > > >        Raid Devices : 5
> > > >       Total Devices : 3
> > > >         Persistence : Superblock is persistent
> > > > 
> > > >         Update Time : Thu May  4 14:39:03 2023
> > > >               State : active, FAILED, Not Started
> > > >      Active Devices : 3
> > > >     Working Devices : 3
> > > >      Failed Devices : 0
> > > >       Spare Devices : 0
> > > > 
> > > >              Layout : left-symmetric
> > > >          Chunk Size : 512K
> > > > 
> > > > Consistency Policy : unknown
> > > > 
> > > >       Delta Devices : 1, (4->5)
> > > > 
> > > >                Name : GRANDSLAM:480
> > > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > > >              Events : 78714
> > > > 
> > > >      Number   Major   Minor   RaidDevice State
> > > >         -       0        0        0      removed
> > > >         -       0        0        1      removed
> > > >         -       0        0        2      removed
> > > >         -       0        0        3      removed
> > > >         -       0        0        4      removed
> > > > 
> > > >         -       8       81        3      sync   /dev/sdf1
> > > >         -       8       49        1      sync   /dev/sdd1
> > > >         -       8       33        0      sync   /dev/sdc1
> > > 
> > > So the reason that this array can't start is that /dev/sde1 is not
> > > recognized as RaidDevice 2, and there are two RaidDevice missing for
> > > a raid5.
> > > 
> > > Sadly I have no idea to workaroud this, sb metadate seems to be broken.
> > > 
> > > Thanks,
> > > Kuai
> > > > ---
> > > > -watch -c -d -n 1 cat /proc/mdstat
> > > > ---
> > > > Every 1.0s: cat /proc/mdstat                                                     OAK2023: Mon May 22 01:48:24
> > > > 2023
> > > > 
> > > > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> > > > md480 : inactive sdf1[4] sdd1[1] sdc1[0]
> > > >        46877239294 blocks super 1.2
> > > > 
> > > > unused devices: <none>
> > > > ---
> > > > Hopeful that is some progress towards an array start? It's definately unexpected output to me.
> > > > I/O Error starting md480
> > > > 
> > > > Thanks!
> > > > SA
> > > > 
> > > > On Thu, 2023-05-18 at 11:15 +0800, Yu Kuai wrote:
> > > > 
> > > > > I have no idle why other disk shows that device 2 is missing, and what
> > > > > is device 4.
> > > > > 
> > > > > Anyway, can you try the following?
> > > > > 
> > > > > mdadm -I /dev/sdc1
> > > > > mdadm -D /dev/mdxxx
> > > > > 
> > > > > mdadm -I /dev/sdd1
> > > > > mdadm -D /dev/mdxxx
> > > > > 
> > > > > mdadm -I /dev/sde1
> > > > > mdadm -D /dev/mdxxx
> > > > > 
> > > > > mdadm -I /dev/sdf1
> > > > > mdadm -D /dev/mdxxx
> > > > > 
> > > > > If above works well, you can try:
> > > > > 
> > > > > mdadm -R /dev/mdxxx, and see if the array can be started.
> > > > > 
> > > > > Thanks,
> > > > > Kuai
> > > > 
> > > > .
> > > > 

