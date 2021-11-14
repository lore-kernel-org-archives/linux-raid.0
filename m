Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E15BC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 14 Nov 2021 02:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838ED60F46
	for <linux-raid@archiver.kernel.org>; Sun, 14 Nov 2021 02:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhKNChz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 13 Nov 2021 21:37:55 -0500
Received: from smtp2.us.opalstack.com ([23.106.47.103]:35126 "EHLO
        smtp2.us.opalstack.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbhKNChv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 13 Nov 2021 21:37:51 -0500
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Nov 2021 21:37:51 EST
Received: from localhost (opal1.opalstack.com [108.59.4.161])
        by smtp2.us.opalstack.com (Postfix) with ESMTPSA id 58DF16F29A;
        Sun, 14 Nov 2021 02:29:25 +0000 (UTC)
Date:   Sun, 14 Nov 2021 02:29:24 +0000
From:   David T-G <davidtg+robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: overlays on dd images of 4T drives
Message-ID: <20211114022924.GA21337@opal1.opalstack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all --

Crossing my fingers that this gets through ...  My last few messages have
not come back to me on the list.

After a first attempt to assemble the two working and one wonky drives of
my 4-disk array and then watching reads hang forever, I have now used dd
to pull an image of each RAID partition

  davidtg@gezebel:~> sudo fdisk -l /dev/sda
  Disk /dev/sda: 3.7 TiB, 4000787030016 bytes, 7814037168 sectors
  Disk model: ST4000DM000-1F21
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
  Disklabel type: gpt
  Disk identifier: 482CA0F0-663B-409D-A4DF-4A4B248E6D23

  Device          Start        End    Sectors   Size Type
  /dev/sda1        2048 7813774990 7813772943   3.7T Linux RAID
  /dev/sda2  7813775360 7814037134     261775 127.8M Linux filesystem

  diskfarm:/mnt/10Traid50md/tmp # ls -goh 4T*
  -rw-r--r-- 1 4.0T Nov 12 02:05 '4Tsda1.EYNA.dd-bs=256M-conv=sparse,noerror'
  -rw-r--r-- 1 4.0T Nov 12 02:05 '4Tsdb1.5YD9.dd-bs=256M-conv=sparse,noerror'
  -rw-r--r-- 1 4.0T Nov 12 02:05 '4Tsdc1.5ZY3.dd-bs=256M-conv=sparse,noerror'
  diskfarm:/mnt/10Traid50md/tmp # file 4Tsda1.EYNA.dd-bs\=256M-conv\=sparse\,noerror
  4Tsda1.EYNA.dd-bs=256M-conv=sparse,noerror: Linux Software RAID version 1.2 (1) UUID=ca7008ef:90693dae:6c231ad7: 8b3f92d name=diskfarm:0 level=5 disks=4

so that I can use overlays to assemble the device and replay the XFS
journal to get up and running again to finally be able to pull off this
data.

After going back and forth across the deprecated wiki pages, I'm working
through Irreversible Failure Recovery

  https://raid.wiki.kernel.org/index.php/Irreversible_mdadm_failure_recovery

and have created

  diskfarm:/mnt/10Traid50md/tmp # ls -goh overlay-sd*
  -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sda1
  -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sdb1
  -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sdc1
  diskfarm:/mnt/10Traid50md/tmp # losetup -a
  /dev/loop1: [66326]:1059 (/mnt/10Traid50md/tmp/overlay-sdb1)
  /dev/loop2: [66326]:1060 (/mnt/10Traid50md/tmp/overlay-sdc1)
  /dev/loop0: [66326]:1058 (/mnt/10Traid50md/tmp/overlay-sda1)

my overlay files and loopback devices.  But ...

It seems that blockdev does not like

  diskfarm:/mnt/10Traid50md/tmp # blockdev --getsize ./overlay-sda1
  blockdev: ioctl error on BLKGETSIZE: Inappropriate ioctl for device

my files and so it won't give me the size that I need for dmsetup in the
next step.

How can I use these partition images as source for faking up my RAID
array to recover the contents?  I seem to have gotten myself stuck :-/


TIA & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

