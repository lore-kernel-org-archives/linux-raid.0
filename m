Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F1DC433F5
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jan 2022 15:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbiA2PZY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Jan 2022 10:25:24 -0500
Received: from www18.qth.com ([69.16.238.59]:39788 "EHLO www18.qth.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239029AbiA2PZX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 29 Jan 2022 10:25:23 -0500
Received: from [73.207.192.158] (port=38574 helo=justpickone.org)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <davidtg+robot@justpickone.org>)
        id 1nDpbR-0005Ol-IA; Sat, 29 Jan 2022 09:25:23 -0600
Date:   Sat, 29 Jan 2022 10:25:21 -0500
From:   David T-G <davidtg+robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: hardware recovery and RAID5 services
Message-ID: <20220129152521.GJ14596@justpickone.org>
References: <20220121164804.GE14596@justpickone.org>
 <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
 <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk>
 <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
 <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
 <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
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

Phil, et al --

...and then Phil Turmel said...
% 
% Hi David, et al,
% 
% The principle of "My Hard Drive Died" is Scott Moulton, a highly respected
% member of the forensics and white-hat scene here in the Atlanta Metro Area.
% 
% https://myharddrivedied.com/

Great to know!  Thanks so much.


% 
% That said, I highly recommend copying the disk showing read errors onto
% another disk, keeping the log of sectors replaced by zeros. Then performing
% a file by file backup from the degraded array, using the copy instead of the
% troubled drive.
[snip]

I think I'm about there now.  I believe I have a "virtual array" 

  diskfarm:/mnt/10Traid50md/tmp # head -4 /proc/mdstat
  Personalities : [raid6] [raid5] [raid4] [raid0] 
  md0 : active (read-only) raid5 loop12[0] loop11[3] loop10[4]
        11720265216 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U_UU]
  
  diskfarm:/mnt/10Traid50md/tmp # mdadm -E /dev/md0
  /dev/md0:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)

which presents me a partition with an ailing XFS filesystem on it.  I'm
hopeful that in my next round of an hour or two I can dig into superblock
adventures.


Thanks to all for all of the input!

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

