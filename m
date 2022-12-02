Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397DFC4332F
	for <linux-raid@archiver.kernel.org>; Fri,  2 Dec 2022 21:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiLBVvm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiLBVvk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Dec 2022 16:51:40 -0500
X-Greylist: delayed 102 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 13:51:35 PST
Received: from cmx-alt-rgout001.mx-altice.prod.cloud.synchronoss.net (cmx-alt-rgout001.mx-altice.prod.cloud.synchronoss.net [65.20.48.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2166F2C5E
        for <linux-raid@vger.kernel.org>; Fri,  2 Dec 2022 13:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suddenlinkmail.com; s=dkim-001; t=1670017895; 
        bh=AqdKJnwuFk12bDkfXOovAYa7m4/WPiBx5p4I61B/QAQ=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=dwYY5LBpQWLQWTF6JfeBurEBDVe8nru9SYJsfXNcC5d0MIgsvPTV3E13/mXCsyeSg30kvCbEYBwyfG9M5nmHy6zVygxL0EUSH2pFmnl49/AzFZWMGw1ZYuC1r2c9EhdsVgql/EXY6anZrO/VPdjwN2GWteUFVHCzAK4TZ8eJpzjo9JuEniSJkF1cG6hjFA7XHeZVs2tBHE3Cpxt/b2kOiig/yrIRNy33SEVnhzHu7aJ10U6queiRkLbCLZxQpxxGLpnDETpKoDmVv476K1scxpVWXZmnadde5nXmR0Eyw5PHOX4EyFXVvZXRmKDqjTPNg17Q/wyUErQW3RWR9829Bg==
X-RG-VS-CS: clean
X-RG-VS-SC: 0
X-RG-VS: Clean
X-Originating-IP: [66.76.46.195]
X-RG-Env-Sender: drankinatty@suddenlinkmail.com
X-RG-Rigid: 636B531D0645BB2D
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvhedrtdekgdduvdelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecutefnvffkvefgfgfupdggtfgfnhhsuhgsshgtrhhisggvpdfqfgfvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepkfffgggfvffhohfupfgtgfesthejredttdefjeenucfhrhhomhepfdffrghvihguucevrdcutfgrnhhkihhnfdcuoegurhgrnhhkihhnrghtthihsehsuhguuggvnhhlihhnkhhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhepuefgkedthfefuedtueehheekjeevffevgeffgfegiefgtdekkedtjeeiueduteehnecukfhppeeiiedrjeeirdegiedrudelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopegludelvddrudeikedriedruddtgegnpdhinhgvthepieeirdejiedrgeeirdduleehpdhmrghilhhfrhhomhepughrrghnkhhinhgrthhthiesshhuugguvghnlhhinhhkmhgrihhlrdgtohhmpdhnsggprhgtphhtthhopedupdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgruhhthhgpuhhsvghrpegurhgrnhhkihhnrghtthihsehsuhguuggvnhhlihhnkhhmrghilhdrtghomhdpghgvohhiphepfgfupdhmthgrhhhoshhtpegtmhigqdgrlhhtqdhrghhouhhttddtud
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from [192.168.6.104] (66.76.46.195) by cmx-alt-rgout001.mx-altice.prod.cloud.synchronoss.net (5.8.810) (authenticated as drankinatty@suddenlinkmail.com)
        id 636B531D0645BB2D for linux-raid@vger.kernel.org; Fri, 2 Dec 2022 21:49:53 +0000
Message-ID: <53c32c9a-c727-ca36-961d-4f3d3afd545f@suddenlinkmail.com>
Date:   Fri, 2 Dec 2022 15:49:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     mdraid <linux-raid@vger.kernel.org>
From:   "David C. Rankin" <drankinatty@suddenlinkmail.com>
Organization: Rankin Law Firm, PLLC
Subject: Revisit Old Issue - Raid1 (harmless still?) mismatch_cnt = 128 on
 scrub?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

All,

   I have a Raid1 array on boot that showed 0 mismatch count for a couple of 
years, but lately shows:

mismatch_cnt = 128

   I know, I know for ages this was a just ignore it on Raid1 issue, but just 
to check that there were not changes to mdadm that now exclude false-positive 
mismatch on Raid1 and this is indicating hardware issues (powersupply, ram, 
etc..) I wanted to kick this old issue again. This is a tiny array of /boot 
roughly 199 Mib. The array and both individual member disks all report being 
happy, e.g.

# mdadm -D /dev/md0
/dev/md0:
            Version : 1.2
      Creation Time : Wed Nov 27 04:34:56 2013
         Raid Level : raid1
         Array Size : 204608 (199.81 MiB 209.52 MB)
      Used Dev Size : 204608 (199.81 MiB 209.52 MB)
       Raid Devices : 2
      Total Devices : 2
        Persistence : Superblock is persistent

        Update Time : Thu Dec  1 03:00:04 2022
              State : clean
     Active Devices : 2
    Working Devices : 2
     Failed Devices : 0
      Spare Devices : 0

Consistency Policy : resync

               Name : archiso:0
               UUID : f15a37fb:32ef816a:1cb4633b:2996f340
             Events : 457

     Number   Major   Minor   RaidDevice State
        0       8        5        0      active sync   /dev/sda5
        1       8       21        1      active sync   /dev/sdb5

and

# mdadm -E /dev/sd[ab]5
/dev/sda5:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : f15a37fb:32ef816a:1cb4633b:2996f340
            Name : archiso:0
   Creation Time : Wed Nov 27 04:34:56 2013
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 409312 sectors (199.86 MiB 209.57 MB)
      Array Size : 204608 KiB (199.81 MiB 209.52 MB)
   Used Dev Size : 409216 sectors (199.81 MiB 209.52 MB)
     Data Offset : 288 sectors
    Super Offset : 8 sectors
    Unused Space : before=200 sectors, after=96 sectors
           State : clean
     Device UUID : fc70fc11:d2867b8b:59ebe0b1:82b1ef88

     Update Time : Thu Dec  1 03:00:04 2022
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : bc8b170d - correct
          Events : 457


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb5:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : f15a37fb:32ef816a:1cb4633b:2996f340
            Name : archiso:0
   Creation Time : Wed Nov 27 04:34:56 2013
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 409312 sectors (199.86 MiB 209.57 MB)
      Array Size : 204608 KiB (199.81 MiB 209.52 MB)
   Used Dev Size : 409216 sectors (199.81 MiB 209.52 MB)
     Data Offset : 288 sectors
    Super Offset : 8 sectors
    Unused Space : before=200 sectors, after=96 sectors
           State : clean
     Device UUID : 8bcac23f:9140e68a:c3357fe8:e212af9f

     Update Time : Thu Dec  1 03:00:04 2022
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 3719d627 - correct
          Events : 457


    Device Role : Active device 1
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)

   So, is this still a -- "it's Raid1 or Raid10, ignore the mismatch" issue?


-- 
David C. Rankin, J.D.,P.E.
