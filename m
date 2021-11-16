Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843A6C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 02:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D6E461A7C
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 02:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353935AbhKPCG3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 21:06:29 -0500
Received: from smtp2.us.opalstack.com ([23.106.47.103]:44538 "EHLO
        smtp2.us.opalstack.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359301AbhKPCEX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 15 Nov 2021 21:04:23 -0500
Received: from localhost (opal1.opalstack.com [108.59.4.161])
        by smtp2.us.opalstack.com (Postfix) with ESMTPSA id D5C846F6F5;
        Tue, 16 Nov 2021 02:01:26 +0000 (UTC)
Date:   Tue, 16 Nov 2021 02:01:26 +0000
From:   David T-G <davidtg+robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: overlays on dd images of 4T drives
Message-ID: <20211116020126.GA95566@opal1.opalstack.com>
References: <20211114022924.GA21337@opal1.opalstack.com>
 <20211115025103.GA254223@opal1.opalstack.com>
 <87czn1i4xr.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czn1i4xr.fsf@vps.thesusis.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Phillip, et al --

...and then Phillip Susi said...
% 
% David T-G <davidtg+robot@justpickone.org> writes:
% 
% >   davidtg@gezebel:/mnt/data/tmp/4Traid> parallel 'size=$(sudo blockdev
% > --getsize {}); loop=$(sudo losetup -f --show -- overlay-{/}) ; echo
% > $loop' ::: $DEVICES
...
% >   davidtg@gezebel:/mnt/data/tmp/4Traid> sudo losetup -a
...
% >   ### why are these out of order?!? *sigh*
% 
% Because you ran the command to create them with parallel.  Don't do that.

Ah.  Well, yeah; I'd like to not, not least because I don't have parallel
on all machines and I don't know its grammar enough to know what it's
really doing.  But I also know that sometimes I should just shut up and
follow the documentation :-)

And I would figure that parallel would process them in order since they
should all take the same amount of time to run!  But that's MUTEX play
for ya.


% 
% > OK, yeah, we could predict that.  But it gets even more fun:
...
% > What?!?  Where is my superblock?  This is a bit-for-bit copy of the
% > partition itself.
% >
% > Time to fall back for more help from the RAID gods *sigh*  Any further
% > recommendations?
% 
% Run mdadm -E /dev/loop{0,1,2}

Well, that appears to agree:

  diskfarm:/mnt/10Traid50md/tmp # mdadm -E /dev/loop{0,1,2}
  mdadm: No md superblock detected on /dev/loop0.
  mdadm: No md superblock detected on /dev/loop1.
  mdadm: No md superblock detected on /dev/loop2.
  diskfarm:/mnt/10Traid50md/tmp # losetup -a
  /dev/loop1: [66326]:1059 (/mnt/10Traid50md/tmp/overlay-sdb1)
  /dev/loop2: [66326]:1060 (/mnt/10Traid50md/tmp/overlay-sdc1)
  /dev/loop0: [66326]:1058 (/mnt/10Traid50md/tmp/overlay-sda1)

But I'm confused, all right:

  diskfarm:/mnt/10Traid50md/tmp # mdadm -E 4Tsda1.EYNA.dd-bs\=256M-conv\=sparse\,noerror
  4Tsda1.EYNA.dd-bs=256M-conv=sparse,noerror:
	    Magic : a92b4efc
	  Version : 1.2
      Feature Map : 0x0
       Array UUID : ca7008ef:90693dae:6c231ad7:08b3f92d
	     Name : diskfarm:0  (local to host diskfarm)
    Creation Time : Mon Feb  6 05:56:35 2017
       Raid Level : raid5
     Raid Devices : 4

   Avail Dev Size : 7813510799 sectors (3.64 TiB 4.00 TB)
       Array Size : 11720265216 KiB (10.92 TiB 12.00 TB)
    Used Dev Size : 7813510144 sectors (3.64 TiB 4.00 TB)
      Data Offset : 262144 sectors
     Super Offset : 8 sectors
     Unused Space : before=262064 sectors, after=574835712 sectors
	    State : clean
      Device UUID : f05a143b:50c9b024:36714b9a:44b6a159

      Update Time : Sun Nov  7 01:00:00 2021
	 Checksum : 4adb8b59 - correct
	   Events : 128116

	   Layout : left-symmetric
       Chunk Size : 512K

     Device Role : Active device 3
     Array State : A.AA ('A' == active, '.' == missing, 'R' == replacing)

OH!!!  Wait.  The loopback device points to the overlay file, which is
sparse.  No wonder it has no superblock.  When I was here on this host
after having lots of device mapper issues, I tried to assemble the files
and got nowhere.

Can I create loopback devices pointing to the image files, which will
give me raw handles, and then assemble that?

Or am I stuck with struggling with the mapper on my workstation with the
actual disks in it and wondering why sda1

  davidtg@gezebel:/mnt/data/tmp/4Traid> sudo losetup -a
  /dev/loop1: [66307]:624372298 (/mnt/data/tmp/4Traid/overlay-sdc1)
  /dev/loop2: [66307]:624372297 (/mnt/data/tmp/4Traid/overlay-sdb1)
  /dev/loop0: [66307]:624372296 (/mnt/data/tmp/4Traid/overlay-sda1)
  davidtg@gezebel:/mnt/data/tmp/4Traid> echo 0 `sudo blockdev --getsize
  /dev/sda1` snapshot /dev/sda1 /dev/loop0 P 8 | sudo dmsetup create sda1
  device-mapper: reload ioctl on sda1  failed: Device or resource busy
  Command failed.

is busy?


Thanks again & HANN

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

