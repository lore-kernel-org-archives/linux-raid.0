Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872CAC433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 16:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbiCIQKW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 11:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbiCIQIS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 11:08:18 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2129186239
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 08:04:50 -0800 (PST)
Received: from [73.207.192.158] (port=42690 helo=justpickone.org)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1nRynH-0000su-7I
        for linux-raid@vger.kernel.org; Wed, 09 Mar 2022 10:04:06 -0600
Date:   Wed, 9 Mar 2022 11:04:03 -0500
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: to partition or not to partition (was "Re: striping 2x500G to mirror
 1x1T")
Message-ID: <20220309160403.GH4455@justpickone.org>
References: <20220305044704.GB4455@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220305044704.GB4455@justpickone.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi again, all --

...and then davidtg-robot@justpickone.org said...
% 
% I have a 1T data drive (currently in use with data) that I'd like to
% mirror with a pair of 500G drives striped together.  I'll be mirroring
% two partitions, and I'll be striping partitions to ensure the correct
[snip]

Is it OK to mirror a partition and an entire device?  Are there any pros
or cons?

I now have my 2ea 500G drives partitioned

  jpo:~ # parted /dev/sdc unit MiB print
  Model: ATA WDC WD5000AAVS-0 (scsi)
  Disk /dev/sdc: 476940MiB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags: 

  Number  Start      End        Size       File system  Name                    Flags
   1      1.00MiB    472171MiB  472170MiB               raid0-WD-WMASU0686160   raid
   4      472171MiB  476940MiB  4769MiB    reiserfs     wwn-0x50014ee055b724ad

  jpo:~ # parted /dev/sdd unit MiB print
  Model: ATA WDC WD5000AAVS-0 (scsi)
  Disk /dev/sdd: 476940MiB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags: 

  Number  Start      End        Size       File system  Name                    Flags
   1      1.00MiB    472171MiB  472170MiB               raid0-WD-WMASU0769665   raid
   4      472171MiB  476940MiB  4769MiB    ext3         wwn-0x50014ee055b72bcd

(I always reserve a small slice at the end of the disk in which to keep
array structure data and other helpful info) and striped 

  jpo:~ # mdadm --detail /dev/md0
  /dev/md0:
             Version : 1.2
       Creation Time : Wed Mar  9 05:48:41 2022
          Raid Level : raid0
          Array Size : 966739968 (921.96 GiB 989.94 GB)
        Raid Devices : 2
       Total Devices : 2
         Persistence : Superblock is persistent

         Update Time : Wed Mar  9 05:48:41 2022
               State : clean 
      Active Devices : 2
     Working Devices : 2
      Failed Devices : 0
       Spare Devices : 0

              Layout : -unknown-
          Chunk Size : 512K

  Consistency Policy : none

                Name : jpo:500Graid0md  (local to host jpo)
                UUID : fc674dbd:577b7d48:5cbe936f:6954eb62
              Events : 0

      Number   Major   Minor   RaidDevice State
         0       8       33        0      active sync   /dev/sdc1
         1       8       49        1      active sync   /dev/sdd1

into a 1T-ish device ready to be half a mirror.  I had originally done
lots of partition size math equal exactly half of my 1T drive partition

  jpo:~ # parted /dev/sdb unit MiB print
  Model: ATA ST31000524AS (scsi)
  Disk /dev/sdb: 953870MiB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags: 

  Number  Start      End        Size       File system  Name  Flags
   1      1.00MiB    858307MiB  858306MiB  xfs          pri
   4      950055MiB  953869MiB  3814MiB                 pri

with existing data (and having to fudge around, not surprisingly, the
striping metadata overhead), and so I've been playing

  jpo:~ # parted /dev/md0 unit MiB print
  Model: Linux Software RAID Array (md)
  Disk /dev/md0: 944082MiB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags: 

  Number  Start      End        Size       File system  Name         Flags
   1      1.00MiB    934641MiB  934640MiB               500Graid0md  raid
   4      934641MiB  944081MiB  9440MiB                 pri          msftdata

with how to slice up the stripe device to size it to match the existing
sdb1 partition with the mirroring metadata overhead, when I wondered ...
do I care?  I don't need the s4 slice on this virtual device; that's just
leftover space.  I hate to think of it going to waste, but it's really
trivial in the grand scheme of things.  Soooooo ... if it's just as happy
to mirror against a whole device as it is a slice of one, then maybe I
can skip ahead.

Thoughts?


Thanks again! :-)

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

