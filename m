Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DFAC77B75
	for <linux-raid@archiver.kernel.org>; Mon, 22 May 2023 07:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjEVHXQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 May 2023 03:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbjEVHWx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 May 2023 03:22:53 -0400
Received: from crane.ash.relay.mailchannels.net (crane.ash.relay.mailchannels.net [23.83.222.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387EC269A
        for <linux-raid@vger.kernel.org>; Mon, 22 May 2023 00:20:59 -0700 (PDT)
X-Sender-Id: a2hosting|x-authuser|raid@electrons.cloud
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 45C3B641BFB;
        Mon, 22 May 2023 07:20:56 +0000 (UTC)
Received: from mi3-ss61.a2hosting.com (unknown [127.0.0.6])
        (Authenticated sender: a2hosting)
        by relay.mailchannels.net (Postfix) with ESMTPA id 38F98641BB4;
        Mon, 22 May 2023 07:20:55 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1684740055; a=rsa-sha256;
        cv=none;
        b=o/iiwTrNlW0Tm3co3uRT1sqhoTUPupdzvpSOKDTruUidjYdVvvzRXipyIhohHG96n3Gnh+
        IpqaHXhkfxIYkYJx/ZXxUjJ43NXXO5VyGZE/6AIuOaX4AX1zwU/FLDQ79YBMSxZFEfmc19
        VvDH54gtaxZN5GbVIWqNM8MOiEpjtRsOHvG0+EseWJcwFyjonPNF3jfVnT9ZelEpuuu1cz
        +3A5HgUWV341mljPs52JNzl4QFvgI0zffGXbLoO0QiI5eqfaXODVKNunfaYM3ouc5aE/05
        vDNKMraYAkHbk+rRi3DQrhObfztlFHp/G8fuMTX2zAcBorBjjub06odru0waLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1684740055;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=33V+5DBRX+GZ7OY/ELi5N7uxeUkTrvPZivSHEPRH1MQ=;
        b=VGk7M8OEBz1s+761zsBtxeCxhyu0pbr5ROnkCtDJ7ju/n56ZpTt2yYirCYzn2oIkIEhw2D
        mI6ijimKxX/G5fLbnPxb4DSY2XA69w2TyKpIx1MFru5Y2GmVvMYaviJG0XQUD0eg7BLOHR
        M3jPivzgbHOeWfKXtosKdw8rmjpDjvPi4vm1uprBq/U4xP5qXKYJkc8JvzEvavgcvo4vyR
        XOQRsmm9me/fp8XokEbpmb59jcIt3o3tvpLaY3tKE5Oaf70MpkTBfb2CmPGE/ndZAqf/FI
        mWfredCU01GnAmF1xGHcAG2+6YM8qBTqQRcVZ87tJyWQ8F6N07Qwwc2cgQCikw==
ARC-Authentication-Results: i=1;
        rspamd-5cdf8fd7d9-s7qtv;
        auth=pass smtp.auth=a2hosting smtp.mailfrom=raid@electrons.cloud
X-Sender-Id: a2hosting|x-authuser|raid@electrons.cloud
X-MC-Relay: Neutral
X-MailChannels-SenderId: a2hosting|x-authuser|raid@electrons.cloud
X-MailChannels-Auth-Id: a2hosting
X-Stop-Illustrious: 7d82fe7b219587df_1684740056048_1822499583
X-MC-Loop-Signature: 1684740056048:4032415764
X-MC-Ingress-Time: 1684740056047
Received: from mi3-ss61.a2hosting.com (mi3-ss61.a2hosting.com [70.32.23.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.116.217.246 (trex/6.8.1);
        Mon, 22 May 2023 07:20:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=electrons.cloud; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:
        Message-ID:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=33V+5DBRX+GZ7OY/ELi5N7uxeUkTrvPZivSHEPRH1MQ=; b=Sm1NEVQOy5ToEzb/5rpP9qdplA
        Wiz/VqX71ipUdxmwT7gHOkXQ4ohj/QQebtsmRzu7swPdTteh7Hojy3NXxH2lNIIKcmn6mdWv3eylU
        mf4lEK2r9mBPeAAEjCrOQ5+dC6V+B4aMFyLofxhOeP+NnxuqZorD5H2kOgq9fXsRuA8oxgKGcu1cF
        8EHpgrSxTpTiTUKetIfOn77ebQiO4yQQPomTvs8o94pGgmKRLdD4Sxi+ImNYKdkJhx6/yJola6Ml8
        F5EYfVliQ7bHdpPdaRX8ytVi2BgM2Hdqou+EcDEtRUgcSAGEgbjYzzddNkx6a+Q/Ttydrb3HewqDx
        y337plog==;
Received: from [2.56.191.211] (port=52988 helo=OAK2023)
        by mi3-ss61.a2hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <raid@electrons.cloud>)
        id 1q0zqg-0007Pz-06;
        Mon, 22 May 2023 03:20:54 -0400
Message-ID: <94b4fde6602bd2ba35afaa2e190920dfa6a100f7.camel@electrons.cloud>
Subject: Re: RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
 (HARDLOCK)
From:   raid <raid@electrons.cloud>
Reply-To: raid@electrons.cloud
To:     Yu Kuai <yukuai1@huaweicloud.com>, Wol <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>,
        "yukuai (C)" <yukuai3@huawei.com>
Date:   Mon, 22 May 2023 02:20:52 -0500
In-Reply-To: <9b22d5ce-5f1b-0fc8-acdc-02c2e8cefa55@huaweicloud.com>
References: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
         <96524acc-504d-6a07-85a0-0b56a9e2f2d7@youngman.org.uk>
         <9b22d5ce-5f1b-0fc8-acdc-02c2e8cefa55@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: raid@electrons.cloud
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
Thanks for the guidance as the current state has at least changed somewhat.

BTW Sorry about Life getting in the way of tech. =) Reason for my delayed response.

-sudo mdadm -I /dev/sdc1
mdadm: /dev/sdc1 attached to /dev/md480, not enough to start (1).

-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 1
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 1

     Delta Devices : 1, (-1->0)
         New Level : raid5
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78714

    Number   Major   Minor   RaidDevice

       -       8       33        -        /dev/sdc1

-sudo mdadm -I /dev/sdd1
mdadm: /dev/sdd1 attached to /dev/md480, not enough to start (2).

-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 2
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 2

     Delta Devices : 1, (-1->0)
         New Level : raid5
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78714

    Number   Major   Minor   RaidDevice

       -       8       49        -        /dev/sdd1
       -       8       33        -        /dev/sdc1

-sudo mdadm -I /dev/sde1
mdadm: /dev/sde1 attached to /dev/md480, not enough to start (2).

-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 3
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 3

     Delta Devices : 1, (-1->0)
         New Level : raid5
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78712

    Number   Major   Minor   RaidDevice

       -       8       65        -        /dev/sde1
       -       8       49        -        /dev/sdd1
       -       8       33        -        /dev/sdc1

-sudo mdadm -I /dev/sdf1
mdadm: /dev/sdf1 attached to /dev/md480, not enough to start (3).

-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 4
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 4

     Delta Devices : 1, (-1->0)
         New Level : raid5
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78714

    Number   Major   Minor   RaidDevice

       -       8       81        -        /dev/sdf1
       -       8       65        -        /dev/sde1
       -       8       49        -        /dev/sdd1
       -       8       33        -        /dev/sdc1

-sudo mdadm -R /dev/md480 
mdadm: failed to start array /dev/md480: Input/output error

---
NOTE: Of additional interest...
---

-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
     Creation Time : Tue Oct 26 14:06:53 2021
        Raid Level : raid5
     Used Dev Size : 18446744073709551615
      Raid Devices : 5
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Thu May  4 14:39:03 2023
             State : active, FAILED, Not Started 
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : unknown

     Delta Devices : 1, (4->5)

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78714

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       -       0        0        1      removed
       -       0        0        2      removed
       -       0        0        3      removed
       -       0        0        4      removed

       -       8       81        3      sync   /dev/sdf1
       -       8       49        1      sync   /dev/sdd1
       -       8       33        0      sync   /dev/sdc1

---
-watch -c -d -n 1 cat /proc/mdstat
---
Every 1.0s: cat /proc/mdstat                                                     OAK2023: Mon May 22 01:48:24 2023

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md480 : inactive sdf1[4] sdd1[1] sdc1[0]
      46877239294 blocks super 1.2

unused devices: <none>
---

Hopeful that is some progress towards an array start? It's definately unexpected output to me.
I/O Error starting md480

Thanks!
SA

On Thu, 2023-05-18 at 11:15 +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/05/18 7:45, Wol 写道:
> > Hmmm. Firstly, what command did you give to grow the array?
> > 
> > Secondly, take a look at the thread "Raid5 to raid6 grow interrupted, 
> > mdadm hangs on assemble command". There's a problem there with rebuilds 
> > locking up, which is not fatal, and will be fixed, but might not have 
> > rippled through yet ...
> > 
> > That raid0 thing is almost certainly nothing to be worried about - it 
> > seems to be normal for any array that doesn't assemble completely.
> > 
> > The only things that bother me slightly are I believe mdadm 4.2 has been 
> > released? Don't quote me on that. And scterc is disabled by default? Weird.
> > 
> > I've cc'd a few people who I hope can help further ...
> 
> Hi, please cc yukuai3@huawei.com for me, huaweicloud email is just for
> send, I don't receive emails from this...
> > Cheers,
> > Wol
> > 
> > On 17/05/2023 14:26, raid wrote:
> > > RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
> > > (HARDLOCK)
> > > 
> > > I've been struggling with this for about two weeks now, realizing that
> > > I need some expert help.
> > > 
> > > My original 18 month old RAID5 consists of three newer TOSHIBA drives.
> > > /dev/sdc :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
> > > bytes)
> > > /dev/sdd :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
> > > bytes)
> > > /dev/sde :: TOSHIBA MG08ACA16TE (4002) :: 16 TB (16,000,900,661,248
> > > bytes)
> > > 
> > > Recently added...
> > > /dev/sdf :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
> > > bytes)
> > > 
> > > In a nutshell, I've added a fourth drive to my RAID5 and executed --
> > > grow & mdadm estimated completion in 3-5 days.
> > > At about 30-50% of reshaping, the computer hard locked. Pushing the
> > > reset button was the agonizing requirement.
> > > 
> > > After first reboot mdadm assembled & continued. But it displayed a
> > > fifth physical disk.
> > > The phantom FIFTH drive appeared as failed, while the other four
> > > continued reshaping, temporarily.
> > > The reshaping speed dropped to 0 after another day or so. It was near
> > > 80%, I think.
> > > So, I used mdadm -S then mdadm --assemble --scan it couldn't start
> > > (because phantom drive?) not enough
> > > drives to start the array. The Array State on each member shows the
> > > fifth drive with varying status.
> > > 
> > > File system (ext4) appears damaged and won't mount. Unrecognized
> > > filesystem.
> > > 20TB are backed up, there are, however, about 7000 newly scanned
> > > documents that aren't.
> > > I've done a cursory examination of data using R-Linux. Abit of in depth
> > > peeking using Active Disk Editor.
> > > 
> > > Life goes on. I've researched and read way more than I ever thought I
> > > would about mdadm RAID.
> > > Not any closer on how to proceed. I'm a hardware technician with some
> > > software skills. I'm stumped.
> > > Also trying to be cautious not to damage whats left of the RAID. ANY
> > > help with what commands
> > > I can attempt to at least get the RAID to assemble WITHOUT the phantom
> > > fifth drive would be
> > > immensely appreciated.
> > > 
> > > All four drives now appear as spares.
> > > 
> > > ---
> > > watch -c -d -n 1 cat /proc/mdstat
> > > md480 : inactive sdc1[0](S) sdd1[1](S) sdf1[4](S) sde1[3](S)
> > >        62502985709 blocks super 1.2
> > > ---
> > > uname -a
> > > Linux OAK2023 4.19.0-24-amd64 #1 SMP Debian 4.19.282-1 (2023-04-29)
> > > x86_64 GNU/Linux
> > > ---
> > > mdadm --version
> > > mdadm - v4.1 - 2018-10-01
> > > ---
> > > mdadm -E /dev/sd[c-f]1
> > > /dev/sdc1:
> > >            Magic : a92b4efc
> > >          Version : 1.2
> > >      Feature Map : 0x45
> > >       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >             Name : GRANDSLAM:480
> > >    Creation Time : Tue Oct 26 14:06:53 2021
> > >       Raid Level : raid5
> > >     Raid Devices : 5
> > > 
> > >   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
> > >       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
> > >    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
> > >      Data Offset : 264192 sectors
> > >       New Offset : 261120 sectors
> > >     Super Offset : 8 sectors
> > >            State : clean
> > >      Device UUID : 8f0835db:3ea24540:2ab4232d:6203d1b7
> > > 
> > > Internal Bitmap : 8 sectors from superblock
> > >    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
> > >    Delta Devices : 1 (4->5)
> > > 
> > >      Update Time : Thu May  4 14:39:03 2023
> > >    Bad Block Log : 512 entries available at offset 72 sectors
> > >         Checksum : 37ac3c04 - correct
> > >           Events : 78714
> > > 
> > >           Layout : left-symmetric
> > >       Chunk Size : 512K
> > > 
> > >     Device Role : Active device 0
> > >     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
> > > replacing)
> > > /dev/sdd1:
> > >            Magic : a92b4efc
> > >          Version : 1.2
> > >      Feature Map : 0x45
> > >       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >             Name : GRANDSLAM:480
> > >    Creation Time : Tue Oct 26 14:06:53 2021
> > >       Raid Level : raid5
> > >     Raid Devices : 5
> > > 
> > >   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
> > >       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
> > >    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
> > >      Data Offset : 264192 sectors
> > >       New Offset : 261120 sectors
> > >     Super Offset : 8 sectors
> > >            State : clean
> > >      Device UUID : b4660f49:867b9f1e:ecad0ace:c7119c37
> > > 
> > > Internal Bitmap : 8 sectors from superblock
> > >    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
> > >    Delta Devices : 1 (4->5)
> > > 
> > >      Update Time : Thu May  4 14:39:03 2023
> > >    Bad Block Log : 512 entries available at offset 72 sectors
> > >         Checksum : a4927b98 - correct
> > >           Events : 78714
> > > 
> > >           Layout : left-symmetric
> > >       Chunk Size : 512K
> > > 
> > >     Device Role : Active device 1
> > >     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
> > > replacing)
> > > /dev/sde1:
> > >            Magic : a92b4efc
> > >          Version : 1.2
> > >      Feature Map : 0x45
> > >       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >             Name : GRANDSLAM:480
> > >    Creation Time : Tue Oct 26 14:06:53 2021
> > >       Raid Level : raid5
> > >     Raid Devices : 5
> > > 
> > >   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
> > >       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
> > >    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
> > >      Data Offset : 264192 sectors
> > >       New Offset : 261120 sectors
> > >     Super Offset : 8 sectors
> > >            State : clean
> > >      Device UUID : 79a3dff4:c53f9071:f9c1c262:403fbc10
> > > 
> > > Internal Bitmap : 8 sectors from superblock
> > >    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
> > >    Delta Devices : 1 (4->5)
> > > 
> > >      Update Time : Thu May  4 14:38:38 2023
> > >    Bad Block Log : 512 entries available at offset 72 sectors
> > >         Checksum : 112fbe09 - correct
> > >           Events : 78712
> > > 
> > >           Layout : left-symmetric
> > >       Chunk Size : 512K
> > > 
> > >     Device Role : Active device 2
> > >     Array State : AAAA. ('A' == active, '.' == missing, 'R' ==
> > > replacing)
> 
> I have no idle why other disk shows that device 2 is missing, and what
> is device 4.
> 
> Anyway, can you try the following?
> 
> mdadm -I /dev/sdc1
> mdadm -D /dev/mdxxx
> 
> mdadm -I /dev/sdd1
> mdadm -D /dev/mdxxx
> 
> mdadm -I /dev/sde1
> mdadm -D /dev/mdxxx
> 
> mdadm -I /dev/sdf1
> mdadm -D /dev/mdxxx
> 
> If above works well, you can try:
> 
> mdadm -R /dev/mdxxx, and see if the array can be started.
> 
> Thanks,
> Kuai
> > > /dev/sdf1:
> > >            Magic : a92b4efc
> > >          Version : 1.2
> > >      Feature Map : 0x45
> > >       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >             Name : GRANDSLAM:480
> > >    Creation Time : Tue Oct 26 14:06:53 2021
> > >       Raid Level : raid5
> > >     Raid Devices : 5
> > > 
> > >   Avail Dev Size : 31251492926 (14901.87 GiB 16000.76 GB)
> > >       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
> > >    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
> > >      Data Offset : 264192 sectors
> > >       New Offset : 261120 sectors
> > >     Super Offset : 8 sectors
> > >            State : clean
> > >      Device UUID : 9d9c1c0d:030844a7:f365ace6:5e568930
> > > 
> > > Internal Bitmap : 8 sectors from superblock
> > >    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
> > >    Delta Devices : 1 (4->5)
> > > 
> > >      Update Time : Thu May  4 14:39:03 2023
> > >    Bad Block Log : 512 entries available at offset 72 sectors
> > >         Checksum : 2d33aff - correct
> > >           Events : 78714
> > > 
> > >           Layout : left-symmetric
> > >       Chunk Size : 512K
> > > 
> > >     Device Role : Active device 3
> > >     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
> > > replacing)
> > > ---
> > > mdadm -E /dev/sd[c-f]1 | grep -E '^/dev/sd|Update'
> > > /dev/sdc1:
> > >      Update Time : Thu May  4 14:39:03 2023
> > > /dev/sdd1:
> > >      Update Time : Thu May  4 14:39:03 2023
> > > /dev/sde1:
> > >      Update Time : Thu May  4 14:38:38 2023
> > > /dev/sdf1:
> > >      Update Time : Thu May  4 14:39:03 2023
> > > ---
> > > mdadm --assemble --scan
> > > mdadm: /dev/md/GRANDSLAM:480 assembled from 3 drives - not enough to
> > > start the array.
> > > ---
> > > /etc/mdadm/mdadm.conf
> > > # This configuration was auto-generated on Tue, 26 Oct 2021 12:52:33
> > > -0500 by mkconf
> > > ARRAY /dev/md480 metadata=1.2 name=GRANDSLAM:480
> > > UUID=20211025:02005a7a:5a7abeef:cafebabe
> > > ---
> > > 
> > > NOTE: Raid Level is now shown below to be raid0. This is a RAID5.
> > >        Delta Devices are munged?
> > > 
> > > NOW;mdadm -D /dev/md480
> > >   2023.05.17 02:44:06 AM
> > > /dev/md480:
> > >             Version : 1.2
> > >          Raid Level : raid0
> > >       Total Devices : 4
> > >         Persistence : Superblock is persistent
> > > 
> > >               State : inactive
> > >     Working Devices : 4
> > > 
> > >       Delta Devices : 1, (-1->0)
> > >           New Level : raid5
> > >          New Layout : left-symmetric
> > >       New Chunksize : 512K
> > > 
> > >                Name : GRANDSLAM:480
> > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >              Events : 78714
> > > 
> > >      Number   Major   Minor   RaidDevice
> > > 
> > >         -       8       81        -        /dev/sdf1
> > >         -       8       65        -        /dev/sde1
> > >         -       8       49        -        /dev/sdd1
> > >         -       8       33        -        /dev/sdc1
> > > ---
> > > 
> > > NOTE: The HITACHI MG08ACA16TE drives default to DISABLED
> > >        I've since enabled the setting if this helps.
> > > 
> > > smartctl -l scterc /dev/sdc; smartctl -l scterc /dev/sdd; smartctl -l
> > > scterc /dev/sde; smartctl -l scterc /dev/sdf
> > > 
> > > smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
> > > build)
> > > Copyright (C) 2002-17, Bruce Allen, Christian Franke,
> > > www.smartmontools.org
> > > 
> > > SCT Error Recovery Control:
> > >             Read:     70 (7.0 seconds)
> > >            Write:     70 (7.0 seconds)
> > > 
> > > smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
> > > build)
> > > Copyright (C) 2002-17, Bruce Allen, Christian Franke,
> > > www.smartmontools.org
> > > 
> > > SCT Error Recovery Control:
> > >             Read:     70 (7.0 seconds)
> > >            Write:     70 (7.0 seconds)
> > > 
> > > smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
> > > build)
> > > Copyright (C) 2002-17, Bruce Allen, Christian Franke,
> > > www.smartmontools.org
> > > 
> > > SCT Error Recovery Control:
> > >             Read:     70 (7.0 seconds)
> > >            Write:     70 (7.0 seconds)
> > > 
> > > smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
> > > build)
> > > Copyright (C) 2002-17, Bruce Allen, Christian Franke,
> > > www.smartmontools.org
> > > 
> > > SCT Error Recovery Control:
> > >             Read:     70 (7.0 seconds)
> > >            Write:     70 (7.0 seconds)
> > > 
> > > ---
> > > 
> > > Exhausted and maybe I'm just looking for someone to suggest running the
> > > command that I really don't want to run yet.
> > > 
> > > Enabling Loss Of Confusion flag hasn't worked either.
> > > 
> > 
> > .
> > 

