Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11412C352A1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 18:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiLCS1Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 13:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiLCS1Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 13:27:24 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926521DF00
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 10:27:23 -0800 (PST)
Received: from [73.207.192.158] (port=34980 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1XER-0008T6-4h
        for linux-raid@vger.kernel.org;
        Sat, 03 Dec 2022 12:27:22 -0600
Date:   Sat, 3 Dec 2022 18:27:21 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: about linear and about RAID10
Message-ID: <20221203182721.GV19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
 <25477.7682.651953.966662@quad.stoffel.home>
 <20221203055816.GT19721@jpo>
 <dad4a4d4-70bb-f09b-c2fc-05dc2d21f8bb@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dad4a4d4-70bb-f09b-c2fc-05dc2d21f8bb@youngman.org.uk>
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

Anthony, et al --

...and then Wols Lists said...
% On 03/12/2022 05:58, David T-G wrote:
% > 
% > I've finally convinced The Boss to spring for additional disks so that I
% > can mirror, so our two servers both have SSD mirroring; yay.  The web
% > server doesn't need much space, so it has a pair of 4T HDDs mirrored as
% > well ... but as RAID10 since I thought that that was cool.  Ah, well.
% 
% Raid 10 across two drives? Do I read you right? So you can easily add a 3rd
% drive to get 6TB of usable storage, but raid 10 x 2 drives = raid 1 ...

Thanks for the aa/bb/cc non-symmetrical layout help recently.  I think I
see where you're going here.  But that isn't what I have in this case.

Each disk is sliced into two large partitions that take up about half:

  davidtg@jpo:~> for D in /dev/sd[bc] ; do sudo parted $D u GiB p free | grep GiB ; done
  Disk /dev/sdb: 3726GiB
          0.00GiB  0.00GiB  0.00GiB  Free Space
   1      0.00GiB  1863GiB  1863GiB               Raid1-1
   2      1863GiB  3726GiB  1863GiB               Raid1-2
   4      3726GiB  3726GiB  0.00GiB  ext2         Seag4000-ZDHB2X37-ext2
  Disk /dev/sdc: 3726GiB
          0.00GiB  0.00GiB  0.00GiB  Free Space
   1      0.00GiB  1863GiB  1863GiB               Raid1-2
   2      1863GiB  3726GiB  1863GiB               Raid1-1
   4      3726GiB  3726GiB  0.00GiB               Seag4000-ZDHBKZTG-ext2

The two halves of each disk are then mirrored across -- BUT in an "X"
layout.  Note that b1 pairs with c2 and c1 pairs with b2.

  davidtg@jpo:~> sudo mdadm -D /dev/md/md4[12] | egrep '/dev/.d|Level'
  /dev/md/md41:
          Raid Level : raid1
         0       8       17        0      active sync   /dev/sdb1
         1       8       34        1      active sync   /dev/sdc2
  /dev/md/md42:
          Raid Level : raid1
         0       8       18        0      active sync   /dev/sdb2
         1       8       33        1      active sync   /dev/sdc1

Finally, the mirrors are striped together (perhaps that should have been
a linear instead) to make the final device.

  davidtg@jpo:~> sudo mdadm -D /dev/md/40 | egrep '/dev/.d|Level'
  /dev/md/40:
          Raid Level : raid0
         0       9       41        0      active sync   /dev/md/md41
         1       9       42        1      active sync   /dev/md/md42

  davidtg@jpo:~> sudo parted /dev/md40 u GiB p free | grep GiB
  Disk /dev/md40: 3726GiB
	  0.00GiB  0.00GiB  0.00GiB  Free Space
   1      0.00GiB  3726GiB  3726GiB  xfs          4TRaid10md
   4      3726GiB  3726GiB  0.00GiB  ext2         4TRaid10md-ntfs

The theory was that each disk would hold half of the total in the first
half of its space and that md would be clever enough to ask the proper
disk for the sector to keep the head in that short run.  Writes cover the
whole disk one way or another, of course, but reads should require less
head movement and be quicker.

Or that's how I understood it in the very many RAID wiki pages and other
docs I read :-)


% 
...
% should just replay the lost writes, and you're back in business. So - if
% your aim is speed of recovery - there's no point splitting the disk into

[Not here; that's the RAID5 system with big disks.]


% slices. There are good reasons for doing it, but that isn't one of them!

How about speed of read?  That was the goal here.  I don't foresee adding
more disks here, although I do actually have one more internal SATA port
and so, maybe, yeah, I might go to a three-disk RAID10 somehow.  But this
server isn't meant to have a lot of content.  [If I can ever find my old
SATA daughter card, though, I could hang some of those leftover <2T disks
on it and shoehorn in more archive disks :-]


% 
% Cheers,
% Wol


Thanks again & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

