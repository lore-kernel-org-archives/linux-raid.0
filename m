Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6BDC77B7F
	for <linux-raid@archiver.kernel.org>; Wed, 17 May 2023 13:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjEQN0p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 May 2023 09:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjEQN0o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 May 2023 09:26:44 -0400
Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07487199
        for <linux-raid@vger.kernel.org>; Wed, 17 May 2023 06:26:39 -0700 (PDT)
X-Sender-Id: a2hosting|x-authuser|raid@electrons.cloud
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id BF8AE3410C1
        for <linux-raid@vger.kernel.org>; Wed, 17 May 2023 13:26:35 +0000 (UTC)
Received: from mi3-ss61.a2hosting.com (unknown [127.0.0.6])
        (Authenticated sender: a2hosting)
        by relay.mailchannels.net (Postfix) with ESMTPA id 241DA340C26
        for <linux-raid@vger.kernel.org>; Wed, 17 May 2023 13:26:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1684329995; a=rsa-sha256;
        cv=none;
        b=sHaEThFMuIp/NRkKKorKa9vB4jDam2ylzSe/bxmVgoVHEh0s0VECqJB7eG3ly6yspBHXcO
        aphFiTtIFXS/wmWhEvkrRe4mCv3YYWDByfaLdw/1LkYx8H2IYL0Ys4t60if8JpAh6q8389
        gCM0tXyUe6pyEwxpePpa4JfH9saspJ7KO0pfAc5U4bAkiGyCr78mYtS6xQ2AKrVVBSfM8b
        jwenfH1EeUglIpl/vCyyG0g1rt8mkJutEQ4E02XQ5MHtOu/kEWJDn4mVEQg26SaQnTJsc8
        m24ZNAX7nmGmpsCn4EGTVEoOarGnYpcuVLB2+h0luJMJDuNoeZNmojavcyVkZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1684329995;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:dkim-signature;
        bh=lCsgnkJ9jQ/BQkj9XZY5WD2MiupU01htJ8MnxcipZj0=;
        b=6Y5H6LTbVTYbyQTswOglev5/XOuo5Vw4glqfNC7XdTYNnPVYDEnIMJykd8iNX2fWWw9+VQ
        8DHjpg0M0FhGh/bzQmFO6h1N5wxaod4i4AVv2QCpZ/ZuQc+CGPN+g/j0elg41iWnBHBnBb
        Vz6He9Nnz4gkfQj++DNJ3eHoLxi6+hwLobWG/KAcom4wB7kNwwamnk710+rJHcIQd1Wk3F
        Y8qHC2/G2S3Ko74i20o/VP4QjbPDrHPfIl4csz4TrDPKBCu0ImBk9P00JwAaSjsAvCIIHf
        onTRmNngvmTkT+SrcDATdLNq/EwO7vOH59Zx4NrWdaw36w5fVPIBJpWPMJnVSQ==
ARC-Authentication-Results: i=1;
        rspamd-5cdf8fd7d9-7wjvd;
        auth=pass smtp.auth=a2hosting smtp.mailfrom=raid@electrons.cloud
X-Sender-Id: a2hosting|x-authuser|raid@electrons.cloud
X-MC-Relay: Neutral
X-MailChannels-SenderId: a2hosting|x-authuser|raid@electrons.cloud
X-MailChannels-Auth-Id: a2hosting
X-Whispering-Lonely: 1121d73c24988e9e_1684329995518_1867466032
X-MC-Loop-Signature: 1684329995518:3719912108
X-MC-Ingress-Time: 1684329995518
Received: from mi3-ss61.a2hosting.com (mi3-ss61.a2hosting.com [70.32.23.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.127.59.19 (trex/6.8.1);
        Wed, 17 May 2023 13:26:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=electrons.cloud; s=default; h=Content-Transfer-Encoding:MIME-Version:Date:
        Content-Type:To:Reply-To:From:Subject:Message-ID:Sender:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lCsgnkJ9jQ/BQkj9XZY5WD2MiupU01htJ8MnxcipZj0=; b=SEBmMLd/XG+EVj8MT4pcCV5NP9
        ArhvpX6Fg6Od4rfCi5ZvOwsehgKjGPyLPaWiBa//eI4kXRl6HBQGzsR3AssJFFvE2abNyVsTub0RD
        +yxXqblcdSMqmjeH/31a5FIIFRsEms3j1GQ47B8Qprg/y+ayS68BWYU6Pn4mujPMS+1I6qwvpVVOm
        qdZY/lL1D9KrzTQ2QcVjSF4YPcCiLOJHEeA7FmnSVHswRrXy9I/uzup9VVFq1Vl3mKITgrN23yytt
        BDv3aYdUuiZTsGEw9Egb8dbjgYmb8OQDGttoeHRC/bB07LcV1bvCHRAWr6sQB5DeTbdNDX20NSZ1d
        VxTbePRg==;
Received: from [2.56.190.51] (port=37256 helo=OAK2023)
        by mi3-ss61.a2hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <raid@electrons.cloud>)
        id 1pzHAn-0007JE-38
        for linux-raid@vger.kernel.org;
        Wed, 17 May 2023 09:26:34 -0400
Message-ID: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
Subject: RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
 (HARDLOCK)
From:   raid <raid@electrons.cloud>
Reply-To: raid@electrons.cloud
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 17 May 2023 08:26:25 -0500
MIME-Version: 1.0
User-Agent: Evolution 3.30.5-1.1 
Content-Transfer-Encoding: 7bit
X-AuthUser: raid@electrons.cloud
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
(HARDLOCK)

I've been struggling with this for about two weeks now, realizing that
I need some expert help.

My original 18 month old RAID5 consists of three newer TOSHIBA drives.
/dev/sdc :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
bytes)
/dev/sdd :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
bytes)
/dev/sde :: TOSHIBA MG08ACA16TE (4002) :: 16 TB (16,000,900,661,248
bytes)

Recently added...
/dev/sdf :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
bytes)

In a nutshell, I've added a fourth drive to my RAID5 and executed --
grow & mdadm estimated completion in 3-5 days.
At about 30-50% of reshaping, the computer hard locked. Pushing the
reset button was the agonizing requirement.

After first reboot mdadm assembled & continued. But it displayed a
fifth physical disk.
The phantom FIFTH drive appeared as failed, while the other four
continued reshaping, temporarily.
The reshaping speed dropped to 0 after another day or so. It was near
80%, I think.
So, I used mdadm -S then mdadm --assemble --scan it couldn't start
(because phantom drive?) not enough
drives to start the array. The Array State on each member shows the
fifth drive with varying status.

File system (ext4) appears damaged and won't mount. Unrecognized
filesystem.
20TB are backed up, there are, however, about 7000 newly scanned
documents that aren't.
I've done a cursory examination of data using R-Linux. Abit of in depth
peeking using Active Disk Editor.

Life goes on. I've researched and read way more than I ever thought I
would about mdadm RAID.
Not any closer on how to proceed. I'm a hardware technician with some
software skills. I'm stumped.
Also trying to be cautious not to damage whats left of the RAID. ANY
help with what commands
I can attempt to at least get the RAID to assemble WITHOUT the phantom
fifth drive would be
immensely appreciated.

All four drives now appear as spares.

---
watch -c -d -n 1 cat /proc/mdstat
md480 : inactive sdc1[0](S) sdd1[1](S) sdf1[4](S) sde1[3](S)
      62502985709 blocks super 1.2
---
uname -a
Linux OAK2023 4.19.0-24-amd64 #1 SMP Debian 4.19.282-1 (2023-04-29)
x86_64 GNU/Linux
---
mdadm --version
mdadm - v4.1 - 2018-10-01
---
mdadm -E /dev/sd[c-f]1 
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
           Name : GRANDSLAM:480
  Creation Time : Tue Oct 26 14:06:53 2021
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
     Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
  Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
    Data Offset : 264192 sectors
     New Offset : 261120 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 8f0835db:3ea24540:2ab4232d:6203d1b7

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
  Delta Devices : 1 (4->5)

    Update Time : Thu May  4 14:39:03 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 37ac3c04 - correct
         Events : 78714

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
           Name : GRANDSLAM:480
  Creation Time : Tue Oct 26 14:06:53 2021
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
     Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
  Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
    Data Offset : 264192 sectors
     New Offset : 261120 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b4660f49:867b9f1e:ecad0ace:c7119c37

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
  Delta Devices : 1 (4->5)

    Update Time : Thu May  4 14:39:03 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a4927b98 - correct
         Events : 78714

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
           Name : GRANDSLAM:480
  Creation Time : Tue Oct 26 14:06:53 2021
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
     Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
  Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
    Data Offset : 264192 sectors
     New Offset : 261120 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 79a3dff4:c53f9071:f9c1c262:403fbc10

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
  Delta Devices : 1 (4->5)

    Update Time : Thu May  4 14:38:38 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 112fbe09 - correct
         Events : 78712

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
           Name : GRANDSLAM:480
  Creation Time : Tue Oct 26 14:06:53 2021
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 31251492926 (14901.87 GiB 16000.76 GB)
     Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
  Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
    Data Offset : 264192 sectors
     New Offset : 261120 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9d9c1c0d:030844a7:f365ace6:5e568930

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
  Delta Devices : 1 (4->5)

    Update Time : Thu May  4 14:39:03 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2d33aff - correct
         Events : 78714

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
replacing)
---
mdadm -E /dev/sd[c-f]1 | grep -E '^/dev/sd|Update'
/dev/sdc1:
    Update Time : Thu May  4 14:39:03 2023
/dev/sdd1:
    Update Time : Thu May  4 14:39:03 2023
/dev/sde1:
    Update Time : Thu May  4 14:38:38 2023
/dev/sdf1:
    Update Time : Thu May  4 14:39:03 2023
---
mdadm --assemble --scan 
mdadm: /dev/md/GRANDSLAM:480 assembled from 3 drives - not enough to
start the array.
---
/etc/mdadm/mdadm.conf
# This configuration was auto-generated on Tue, 26 Oct 2021 12:52:33
-0500 by mkconf
ARRAY /dev/md480 metadata=1.2 name=GRANDSLAM:480
UUID=20211025:02005a7a:5a7abeef:cafebabe
---

NOTE: Raid Level is now shown below to be raid0. This is a RAID5.
      Delta Devices are munged?

NOW;mdadm -D /dev/md480
 2023.05.17 02:44:06 AM 
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
---

NOTE: The HITACHI MG08ACA16TE drives default to DISABLED
      I've since enabled the setting if this helps.

smartctl -l scterc /dev/sdc; smartctl -l scterc /dev/sdd; smartctl -l
scterc /dev/sde; smartctl -l scterc /dev/sdf

smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

---

Exhausted and maybe I'm just looking for someone to suggest running the
command that I really don't want to run yet.

Enabling Loss Of Confusion flag hasn't worked either.

