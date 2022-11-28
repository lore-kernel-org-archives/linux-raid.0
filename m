Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7B1C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 28 Nov 2022 14:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiK1Or3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Nov 2022 09:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiK1OrF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Nov 2022 09:47:05 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90580F4D
        for <linux-raid@vger.kernel.org>; Mon, 28 Nov 2022 06:46:32 -0800 (PST)
Received: from [73.207.192.158] (port=55558 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1ozfOy-0000pk-0L
        for linux-raid@vger.kernel.org;
        Mon, 28 Nov 2022 08:46:31 -0600
Date:   Mon, 28 Nov 2022 14:46:30 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: about linear and about RAID10
Message-ID: <20221128144630.GN19721@jpo>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
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

...and then Roger Heflin said...
% You do not want to stripe 2 partitions on a single disk, you want that linear.
% 
...
% 
% do a dd if=/dev/mdXX of=/dev/null bs=1M count=100 iflag=direct  on one
% of the raid5s of the partitions and then on the raid1 device over
% them.  I would expect the raid device over them to be much slower, I
% am not sure how much but 5x-20x.

Note that we aren't talking RAID5 but simple RAID1, but I follow you.
Time for more testing.  I ran the same dd tests as on the RAID5 setup

  jpo:~ # for D in 41 40 ; do for C in 128 256 512 ; do for S in 1M 4M 16M ; do CMD="dd if=/dev/md$D of=/dev/null bs=$S count=$C iflag=direct" ; echo "## $CMD" ; $CMD 2>&1 | egrep -v records ; done ; done ; done
  ## dd if=/dev/md41 of=/dev/null bs=1M count=128 iflag=direct
  134217728 bytes (134 MB, 128 MiB) copied, 0.710608 s, 189 MB/s
  ## dd if=/dev/md41 of=/dev/null bs=4M count=128 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 2.7903 s, 192 MB/s
  ## dd if=/dev/md41 of=/dev/null bs=16M count=128 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 11.3205 s, 190 MB/s
  ## dd if=/dev/md41 of=/dev/null bs=1M count=256 iflag=direct
  268435456 bytes (268 MB, 256 MiB) copied, 1.41372 s, 190 MB/s
  ## dd if=/dev/md41 of=/dev/null bs=4M count=256 iflag=direct
  1073741824 bytes (1.1 GB, 1.0 GiB) copied, 5.50616 s, 195 MB/s
  ## dd if=/dev/md41 of=/dev/null bs=16M count=256 iflag=direct
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 22.7846 s, 189 MB/s
  ## dd if=/dev/md41 of=/dev/null bs=1M count=512 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 3.02753 s, 177 MB/s
  ## dd if=/dev/md41 of=/dev/null bs=4M count=512 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 11.2099 s, 192 MB/s
  ## dd if=/dev/md41 of=/dev/null bs=16M count=512 iflag=direct
  8589934592 bytes (8.6 GB, 8.0 GiB) copied, 45.5623 s, 189 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=1M count=128 iflag=direct
  134217728 bytes (134 MB, 128 MiB) copied, 1.19657 s, 112 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=4M count=128 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 4.32003 s, 124 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=16M count=128 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 12.0615 s, 178 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=1M count=256 iflag=direct
  268435456 bytes (268 MB, 256 MiB) copied, 2.38074 s, 113 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=4M count=256 iflag=direct
  1073741824 bytes (1.1 GB, 1.0 GiB) copied, 8.62803 s, 124 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=16M count=256 iflag=direct
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 25.2467 s, 170 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=1M count=512 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 5.13948 s, 104 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=4M count=512 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 16.5954 s, 129 MB/s
  ## dd if=/dev/md40 of=/dev/null bs=16M count=512 iflag=direct
  8589934592 bytes (8.6 GB, 8.0 GiB) copied, 55.5721 s, 155 MB/s

and did the math again

          1M        4M       16M
      +---------+---------+---------+
  128 | 189/112 | 192/124 | 190/178 |
      | (1.68)  | (1.54)  | (1.06)  |
      +---------+---------+---------+
  256 | 190/113 | 195/124 | 189/170 |
      | (1.68)  | (1.57)  | (1.11)  |
      +---------+---------+---------+
  512 | 177/104 | 192/129 | 189/155 |
      | (1.70)  | (1.48)  | (1.21)  |
      +---------+---------+---------+

and ... that was NOT what I expected!  I wonder if it's because of stripe
versus linear again.  A straight mirror will run down the entire disk,
so there's no speedup; if you have to seek from one end to the other, the
head moves the whole way.  By mirroring two halves and swapping them and
then gluing them together, though, a read *should* only have to hit the
first half of either disk and thus be FASTER.  And maybe that's the case
for random versus sequential reads; I dunno.  The difference was nearly
negligible for large reads, but I get a 40% penalty on small reads -- and
this server leans much more toward small files versus large.  Bummer :-(

I don't at this time have a device free to plug in locally to back up the
volume to destroy and rebuild as linear, so that will have to wait.  When
I do get that chance, though, will that help me get to the awesome goal
of actually INCREASING performance by including a RAID0 layer?


Thanks again & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

