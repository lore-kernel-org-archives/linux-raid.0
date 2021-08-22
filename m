Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1692C4320A
	for <linux-raid@archiver.kernel.org>; Sun, 22 Aug 2021 02:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1E5C61248
	for <linux-raid@archiver.kernel.org>; Sun, 22 Aug 2021 02:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhHVCRe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Aug 2021 22:17:34 -0400
Received: from atl4mhfb02.myregisteredsite.com ([209.17.115.118]:41802 "EHLO
        atl4mhfb02.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229571AbhHVCRd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 21 Aug 2021 22:17:33 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Aug 2021 22:17:33 EDT
Received: from jax4mhob05.registeredsite.com (jax4mhob05.myregisteredsite.com [64.69.218.85])
        by atl4mhfb02.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id 17M2BPnD022478
        for <linux-raid@vger.kernel.org>; Sat, 21 Aug 2021 22:11:25 -0400
Received: from mailpod.hostingplatform.com ([10.30.71.209])
        by jax4mhob05.registeredsite.com (8.14.4/8.14.4) with ESMTP id 17M2BNnJ024101
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-raid@vger.kernel.org>; Sat, 21 Aug 2021 22:11:23 -0400
Received: (qmail 5580 invoked by uid 0); 22 Aug 2021 02:11:23 -0000
X-TCPREMOTEIP: 24.7.18.247
X-Authenticated-UID: scowles@ckhb.org
Received: from unknown (HELO ckhb02.ckhb.org) (scowles@ckhb.org@24.7.18.247)
  by 0 with ESMTPA; 22 Aug 2021 02:11:22 -0000
Date:   Sat, 21 Aug 2021 19:10:56 -0700 (PDT)
From:   scowles@ckhb.org
Reply-To: scowles@ckhb.org
To:     linux-raid <linux-raid@vger.kernel.org>
Subject: volume recovery question
Message-ID: <f820d037-c981-f1a1-49ca-dbf971695c80@ckhb.org>
X-Face: Ek1c-Ll9]E|9mF*Z|hf5VSHqF.]0Qv%;h%=Zne"Y3am*(:Tf_BlXI;j'}FMhu%sNCjSk|</(~~v,k&/W^/<B[/4.rOqScspm-J_a)0xn*J8L[e:n%{R7'f`B`lQH]J;>cxD~oD:g5Tv,gN}{Y8("m<8<%%=_vy
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


i apologize in advance if this is the wrong forum in which to pose this 
question.  if so, where would it be appropriate?

one disk in a two disk level 1 array failed.  i added another disk to the array 
and the resynchronisation completed successfully.  while the synchronisation was 
running, i removed the failed volume and the array filesystem specs vanished.

so i have two questions:

1)  what happened when i removed the failed array that caused the existing 
filesystem to vanish?

2)  is it possible to recovery the filesystem on the array?

current status:

------------------------------------------------------------------------------------
# mdadm -Es
ARRAY /dev/md/2  metadata=1.2 UUID=a58fd446:5acce560:16946592:61a8ef7e name=ckhb02:2
------------------------------------------------------------------------------------
# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md127 : active raid1 sdf1[2] sdd[0]
       10737418240 blocks super 1.2 [2/2] [UU]
       bitmap: 0/80 pages [0KB], 65536KB chunk

unused devices: <none>
------------------------------------------------------------------------------------
# mdadm --detail /dev/md127
/dev/md127:
            Version : 1.2
      Creation Time : Sun Jun 28 16:55:00 2020
         Raid Level : raid1
         Array Size : 10737418240 (10240.00 GiB 10995.12 GB)
      Used Dev Size : 10737418240 (10240.00 GiB 10995.12 GB)
       Raid Devices : 2
      Total Devices : 2
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Tue Aug 17 13:20:32 2021
              State : clean
     Active Devices : 2
    Working Devices : 2
     Failed Devices : 0
      Spare Devices : 0

Consistency Policy : bitmap

               Name : ckhb02:2  (local to host ckhb02)
               UUID : a58fd446:5acce560:16946592:61a8ef7e
             Events : 175334

     Number   Major   Minor   RaidDevice State
        0       8       48        0      active sync   /dev/sdd
        2       8       81        1      active sync   /dev/sdf1
------------------------------------------------------------------------------------
/bin/ls -lF /dev/disk/by-uuid
yields no volume associated with the array
------------------------------------------------------------------------------------

