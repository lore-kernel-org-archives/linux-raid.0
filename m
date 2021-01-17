Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BE5C433E0
	for <linux-raid@archiver.kernel.org>; Sun, 17 Jan 2021 20:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60F7421D7A
	for <linux-raid@archiver.kernel.org>; Sun, 17 Jan 2021 20:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbhAQUmP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Jan 2021 15:42:15 -0500
Received: from mail.eclipso.de ([217.69.254.104]:42840 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbhAQUmO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 17 Jan 2021 15:42:14 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jan 2021 15:42:13 EST
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 75469544
        for <linux-raid@vger.kernel.org>; Sun, 17 Jan 2021 21:35:37 +0100 (CET)
Date:   Sun, 17 Jan 2021 21:35:37 +0100
MIME-Version: 1.0
Message-ID: <950d061954e1f779739c9c5777b94ade@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: What is the best way to combine 4 HDD's and 2 SSD's into a single
        filesystem?
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

­I have 4 slow, loud, big, power hungry and old hard drives, and 2 SSD's. I'm trying to come up with a way to combine them into a system that has the following characteristics:

A) The hard drives stop spinning 5 minutes after they have been used.
B) The SSD's are used for read and write caching. Writes to the system are absorbed by the SSD's. Only when the ssd's are full of dirty data, then the hard drives are woken up. (This means the SSD's contain dirty data for potentially a long time.)
C) When data is requested that's not present on the SSD's (a read cache miss), then the hard drive which has that data is woken up.
D) When a hard drive is woken up as a result of a read cache miss, then the SSD's write out the dirty data to that drive.
E) If one drive fails, or starts to produce random data, the system must return the correct data to the user.

First idea is to use this stack of bcache and btrfs:
+--------------------------------------------+--------------+
|               btrfs raid 1 (2 copies) /mnt                |
+--------------+--------------+--------------+--------------+
| /dev/bcache0 | /dev/bcache1 | /dev/bcache2 |/dev/bcache3  |
+--------------+--------------+--------------+--------------+
|                       Cache (SSD)                         |
|                       /dev/sda4                           |
+--------------+--------------+--------------+--------------+
| Data HDD     | Data HDD     | Data HDD     |Data HDD      |
| /dev/sda8    | /dev/sda9    | /dev/sda10   |/dev/sda11    |
+--------------+--------------+--------------+--------------+
The good:
Btrfs in raid 1 is able to handle a failing hard drive, both when it failed completely, and when it corrupts data.
Bcache is capable of using an ssd to cache the read and the write requests from btrfs. 
The not-so-good:
Bcache can only use one SSD, so using bcache is only possible as read cache in order to achieve characteristic E, but this prevents characteristic B to be achieved.
I can't get bcache to read-ahead the data that is adjacent to the data that has just been accessed.

Second idea is to use a SSD in front of each hard drive:
+-----------------------------------------------------------+
|                btrfs raid 1 (2 copies) /mnt               |
+--------------+--------------+--------------+--------------+
| /dev/bcache0 | /dev/bcache1 | /dev/bcache2 | /dev/bcache3 |
+--------------+--------------+--------------+--------------+
| Cache SSD    |  Cache SSD   |  Cache SSD   |   Cache SSD  | 
| /dev/sda5    | /dev/sda6    | /dev/sda7    | /dev/sda8    |
+--------------+--------------+--------------+--------------+
| Data         | Data         | Data         | Data         |
| /dev/sda9    | /dev/sda10   | /dev/sda11   |/dev/sda12    |
+--------------+--------------+--------------+--------------+
The good:
This setup achieves all characteristics I'm after 
The not-so-good:
This requires more SSD's and more (SATA) ports than I have.
I can't get bcache to read-ahead the data that is adjacent to the data that has just been accessed.

Third idea is to use mdadm to create a raid 0 array out of the 2 SSD's to create a fault tolerant write cache:
+-----------------------------------------------------------+
|                 btrfs raid 1 (2 copies) /mnt              |
+--------------+--------------+--------------+--------------+
| /dev/bcache0 | /dev/bcache1 | /dev/bcache2 |/dev/bcache3  |
+--------------+--------------+--------------+--------------+
|                      bcache Cache                         |
|                         /dev/md0                          |
+-----------------------------------------------------------+
|               mdadm raid 0 array /dev/md0                 |
|             SSD /dev/sda4 and SSD /dev/sda5               |    
+--------------+--------------+--------------+--------------+
| Data         | Data         | Data         | Data         |
| /dev/sda9    | /dev/sda10   | /dev/sda11   |/dev/sda12    |
+--------------+--------------+--------------+--------------+
The good:
This setup is capable of achieving all characteristics I'm after. It can handle abrupt failure of a single drive.
The not-so-good:
When one of the SSD's start to produce random data, mdadm is not able to know what SSD produces correct data, and data is lost. (both copies of the data btrfs is trying to write to underlying storage are on the 2 SSD's.

Fourth idea is to use dm-cache. Dm-cache can only cache one backing device, and it has no way to use 2 cache devices. 
+-----------------------------------------------------------+
|                btrfs raid 1 (2 copies) /mnt               |
+--------------+--------------+--------------+--------------+
| /dev/bcache0 | /dev/bcache1 | /dev/bcache2 | /dev/bcache3 |
+--------------+--------------+--------------+--------------+
| Cache SSD    |  Cache SSD   |  Cache SSD   |   Cache SSD  |  
| /dev/sda5    | /dev/sda6    | /dev/sda7    | /dev/sda8    |
+--------------+--------------+--------------+--------------+
| Data         | Data         | Data         | Data         |
| /dev/sda9    | /dev/sda10   | /dev/sda11   |/dev/sda12    |
+--------------+--------------+--------------+--------------+
The good:
This setup is capable of achieving all characteristics I'm after.
The not-so-good:
This requires more SSD's and more (SATA) ports than I have.

What options do I have to create the desired setup?
Is it feasible to add a checksum to mdadm, much like btrfs has, so it can tell what drive (if any) has returned the correct data?

Is this the correct mailing list to ask these questions?

---

Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: https://www.eclipso.eu - Time to change!


