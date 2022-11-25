Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558E5C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 25 Nov 2022 13:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiKYNa4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Nov 2022 08:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKYNa4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Nov 2022 08:30:56 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B7223EBB
        for <linux-raid@vger.kernel.org>; Fri, 25 Nov 2022 05:30:55 -0800 (PST)
Received: from [73.207.192.158] (port=50696 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1oyYnD-0004fI-4e
        for linux-raid@vger.kernel.org;
        Fri, 25 Nov 2022 07:30:54 -0600
Date:   Fri, 25 Nov 2022 13:30:53 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: about linear and about RAID10 (was "Re: how do i fix these RAID5
 arrays?")
Message-ID: <20221125133050.GH19721@jpo>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
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

Wol, et al --

...and then Wol said...
% On 24/11/2022 21:10, David T-G wrote:
% > How is linear different from RAID0?  I took a quick look but don't quite
% > know what I'm reading.  If that's better then, hey, I'd try it (or at
% > least learn more).
% 
% Linear tacks one drive on to the end of another. Raid-0 stripes across all
% drives. Both effectively combine a bunch of drives into one big drive.

Ahhhhh...  I gotcha.  Thanks.


% 
...
% 
% That's why there's raid-10. Note that outside of Linux (and often inside)
% when people say "raid-10" they actually mean "raid 1+0". That's two striped
% raid-0's, mirrored.

That's basically what I have on the web server:

  jpo:~ # mdadm -D /dev/md41 | egrep '/dev|Level'
  /dev/md41:
	  Raid Level : raid1
	 0       8       17        0      active sync   /dev/sdb1
	 1       8       34        1      active sync   /dev/sdc2
  jpo:~ # mdadm -D /dev/md42 | egrep '/dev|Level'
  /dev/md42:
	  Raid Level : raid1
	 0       8       18        0      active sync   /dev/sdb2
	 1       8       33        1      active sync   /dev/sdc1
  jpo:~ # mdadm -D /dev/md40 | egrep '/dev|Level'
  /dev/md40:
	  Raid Level : raid0
	 0       9       41        0      active sync   /dev/md/md41
	 1       9       42        1      active sync   /dev/md/md42
  jpo:~ #
  jpo:~ #
  jpo:~ # parted /dev/sdb p
  Model: ATA ST4000VN008-2DR1 (scsi)
  Disk /dev/sdb: 4001GB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags:
  
  Number  Start   End     Size    File system  Name                    Flags
   1      1049kB  2000GB  2000GB               Raid1-1
   2      2000GB  4001GB  2000GB               Raid1-2
   4      4001GB  4001GB  860kB   ext2         Seag4000-ZDHB2X37-ext2
  
  jpo:~ # parted /dev/sdc p
  Model: ATA ST4000VN008-2DR1 (scsi)
  Disk /dev/sdc: 4001GB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags:
  
  Number  Start   End     Size    File system  Name                    Flags
   1      1049kB  2000GB  2000GB               Raid1-2
   2      2000GB  4001GB  2000GB               Raid1-1
   4      4001GB  4001GB  860kB                Seag4000-ZDHBKZTG-ext2


% 
...
% 
% Either version (10, or 1+0), gives you get the speed of striping, and the
% safety of a mirror. 10, however, can use an odd number of disks, and disks
% of random sizes.

That's still magic to me :-)  Mirroring (but not doubling up the
redundancy) on an odd number of disks?!?


% 
% Cheers,
% Wol


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

