Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D27DC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 02:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA1DD61362
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 02:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhKOCyJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 Nov 2021 21:54:09 -0500
Received: from smtp2.us.opalstack.com ([23.106.47.103]:51324 "EHLO
        smtp2.us.opalstack.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhKOCyA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 14 Nov 2021 21:54:00 -0500
Received: from localhost (opal1.opalstack.com [108.59.4.161])
        by smtp2.us.opalstack.com (Postfix) with ESMTPSA id F419F6EF15;
        Mon, 15 Nov 2021 02:51:03 +0000 (UTC)
Date:   Mon, 15 Nov 2021 02:51:03 +0000
From:   David T-G <davidtg+robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: overlays on dd images of 4T drives
Message-ID: <20211115025103.GA254223@opal1.opalstack.com>
References: <20211114022924.GA21337@opal1.opalstack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211114022924.GA21337@opal1.opalstack.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all --

...and then David T-G said...
% 
% Crossing my fingers that this gets through ...  My last few messages have
% not come back to me on the list.

It looks like anything sent from my server is silently dropped.  I've
asked majordomo for help; wish me luck.  Meanwhile, I have to send these
through an alternate server :-/

This is even more fun because I'm only home every three days or so to be
able to poke at this :-(  Dang!


% 
...
% to pull an image of each RAID partition
% 
%   davidtg@gezebel:~> sudo fdisk -l /dev/sda
%   Disk /dev/sda: 3.7 TiB, 4000787030016 bytes, 7814037168 sectors
%   Disk model: ST4000DM000-1F21
...
%   diskfarm:/mnt/10Traid50md/tmp # ls -goh 4T*
%   -rw-r--r-- 1 4.0T Nov 12 02:05 '4Tsda1.EYNA.dd-bs=256M-conv=sparse,noerror'
%   -rw-r--r-- 1 4.0T Nov 12 02:05 '4Tsdb1.5YD9.dd-bs=256M-conv=sparse,noerror'
%   -rw-r--r-- 1 4.0T Nov 12 02:05 '4Tsdc1.5ZY3.dd-bs=256M-conv=sparse,noerror'
%   diskfarm:/mnt/10Traid50md/tmp # file 4Tsda1.EYNA.dd-bs\=256M-conv\=sparse\,noerror
%   4Tsda1.EYNA.dd-bs=256M-conv=sparse,noerror: Linux Software RAID version 1.2 (1) UUID=ca7008ef:90693dae:6c231ad7: 8b3f92d name=diskfarm:0 level=5 disks=4
% 
% so that I can use overlays to assemble the device and replay the XFS
...
% 
% and have created
% 
%   diskfarm:/mnt/10Traid50md/tmp # ls -goh overlay-sd*
%   -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sda1
%   -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sdb1
%   -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sdc1
%   diskfarm:/mnt/10Traid50md/tmp # losetup -a
%   /dev/loop1: [66326]:1059 (/mnt/10Traid50md/tmp/overlay-sdb1)
%   /dev/loop2: [66326]:1060 (/mnt/10Traid50md/tmp/overlay-sdc1)
%   /dev/loop0: [66326]:1058 (/mnt/10Traid50md/tmp/overlay-sda1)
% 
% my overlay files and loopback devices.  But ...
% 
% It seems that blockdev does not like
[snip]

Thanks to Roman for pointing out that I should look at the loopback
devices rather than the overlay files.  That gets me on my way again.
But ... now I have problems with the device mapper:

  diskfarm:/mnt/10Traid50md/tmp # echo $size
  8388608000
  diskfarm:/mnt/10Traid50md/tmp # echo "0 $size snapshot overlay-sda1 /dev/loop0 P 8" | dmsetup create ov-a
  device-mapper: reload ioctl on ov-a  failed: No such device
  Command failed.

ARRRGH!

OK, so I'll go to my workstation and poke at the actual devices, with
great trepidation, from there.

  davidtg@gezebel:/mnt/data/tmp/4Traid> ls -goh
  total 0
  -rw-r--r-- 1 4.0T Nov 15 02:00 overlay-sda1
  -rw-r--r-- 1 4.0T Nov 15 02:00 overlay-sdb1
  -rw-r--r-- 1 4.0T Nov 15 02:00 overlay-sdc1

  davidtg@gezebel:/mnt/data/tmp/4Traid> parallel 'size=$(sudo blockdev --getsize {}); loop=$(sudo losetup -f --show -- overlay-{/}) ; echo $loop' ::: $DEVICES
  /dev/loop0
  /dev/loop2
  /dev/loop1

  davidtg@gezebel:/mnt/data/tmp/4Traid> sudo losetup -a
  /dev/loop1: [66307]:624372298 (/mnt/data/tmp/4Traid/overlay-sdc1)
  /dev/loop2: [66307]:624372297 (/mnt/data/tmp/4Traid/overlay-sdb1)
  /dev/loop0: [66307]:624372296 (/mnt/data/tmp/4Traid/overlay-sda1)
  ### why are these out of order?!? *sigh*

Now, however, when I try to use the dev mapper to create the snapshot
device I get

  davidtg@gezebel:/mnt/data/tmp/4Traid> echo 0 `sudo blockdev --getsize /dev/sda1` snapshot /dev/sda1 /dev/loop0 P 8 | sudo dmsetup create sda1
  device-mapper: reload ioctl on sda1  failed: Device or resource busy
  Command failed.

an error.  It's simply plugged in!  What could have it busy?  Or is this
a device mapper problem on my OpenSuSE LEAP 15.2 system?

I think we need the device mapper to create the snapshot dev to be able
to write changes not to the original disks, so we're stuck there.

Soooo ...  Let's go back to diskfarm and, throwing caution to the winds,
attempt to assemble the image files copied over:

  diskfarm:/mnt/10Traid50md/tmp # mdadm --assemble --force /dev/md4 4Tsda1* 4Tsda2* 4Tsda3*
  mdadm: 4Tsda1.EYNA.dd-bs=256M-conv=sparse,noerror is not a block device.
  mdadm: 4Tsda1.EYNA.dd-bs=256M-conv=sparse,noerror has no superblock - assembly aborted

OK, yeah, we could predict that.  But it gets even more fun:

  diskfarm:/mnt/10Traid50md/tmp # mdadm --assemble --force /dev/md4 /dev/loop{0,1,2}
  mdadm: no recogniseable superblock on /dev/loop0
  mdadm: /dev/loop0 has no superblock - assembly aborted

What?!?  Where is my superblock?  This is a bit-for-bit copy of the
partition itself.

Time to fall back for more help from the RAID gods *sigh*  Any further
recommendations?


TIA again

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

