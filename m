Return-Path: <SRS0=YfF9=D6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D178BC4363A
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 03:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 633FA2177B
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 03:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="iX0Eh39a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460380AbgJWDbp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Oct 2020 23:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374850AbgJWDbo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Oct 2020 23:31:44 -0400
Received: from mail-ua1-x964.google.com (mail-ua1-x964.google.com [IPv6:2607:f8b0:4864:20::964])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C09C0613CE
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
Received: by mail-ua1-x964.google.com with SMTP id f20so631912uap.2
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ReTTaNs/1URCBe015zmmsnkZL8avfnlCHdKrYfMsUo4=;
        b=iX0Eh39aqpOwnxJBatJaScEMnOAfgzq3qvGvZLeXjM61EmZgTGO89tuYRjCMi4Vks6
         qrjr0Cua8S6hdGMKyDsTBRvygocQyPw+RKQa4U++kuTdKniSwXCoYQ3zAtg1Cik9M8my
         xIUsq5GOicpeaB6RciM+uis9JHr5+7lizqD5ram1wHEhcWoqZjrwrbYW6pg0lAwlw7kY
         Gy+KctTCtbD4G3F/SdXA8YY0t9egtxPxywawRsvnw84v95zN9mgHqT63yn0Ch7OuRvZh
         MtFgXjlqxV0KsqWdGGjmAvT3afzaxfhN0//s7pRfWmHzy9C2FG3iKHUdA8ehJi5kfmv7
         /dAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ReTTaNs/1URCBe015zmmsnkZL8avfnlCHdKrYfMsUo4=;
        b=XpUrNZdx4Gzlk6P8NIo9Y+1COCFCy0JWP7fHKHk3bjnhQ07nX14vI+bsJWm+HH/0df
         fNC8/58tgzrPoj6aaIg/+hD1u+x6FbDLkkpwadmvkuhXDG72PDsql26AyjISYYdLd9QJ
         CmzAH1RM+Qe0SmpVSu1IHujHzOLslN0l5lbb3F2/5I/J4r2EjCl/fQyEEKplIeCjAKuo
         U7odkz/BHZ0In2Y+bR0AoFlApJInWjP24fx6nTrurckwdFGyQJ2zYk2vLYrFSDyeW6+H
         Mm2AeGJhavRX/JepH0/nDEDiwQHVn8HGzxJI0TYq0CZh64spox5CvJ94Qhzvg32LuSsB
         rNRg==
X-Gm-Message-State: AOAM532TQBIIE/VSw1ZXD7WwevfEjGM/ouJgq9uhMZm12090PEwwBbi5
        F6gO/FirZuzONwnNlLzgsUtOfsIxmuUGEbST0TdXLbi+OPjcZA==
X-Google-Smtp-Source: ABdhPJwIWpFcsIiW8yfvDvEBcQIxb250sa2gQL1dNp7BJ2OoScUbPyV7hwErd66vzdMT6prDPTQFu4kP6WJF
X-Received: by 2002:ab0:77d8:: with SMTP id y24mr130681uar.72.1603423903067;
        Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
Received: from dcs.hq.drivescale.com ([68.74.115.3])
        by smtp-relay.gmail.com with ESMTP id p17sm40671vkf.7.2020.10.22.20.31.42;
        Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
X-Relaying-Domain: drivescale.com
Received: from localhost.localdomain (gw1-dc.hq.drivescale.com [192.168.33.175])
        by dcs.hq.drivescale.com (Postfix) with ESMTP id 2E05A420D3;
        Fri, 23 Oct 2020 03:31:42 +0000 (UTC)
From:   Christopher Unkel <cunkel@drivescale.com>
To:     linux-raid@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
        cunkel@drivescale.com
Subject: [PATCH 0/3] mdraid sb and bitmap write alignment on 512e drives
Date:   Thu, 22 Oct 2020 20:31:27 -0700
Message-Id: <20201023033130.11354-1-cunkel@drivescale.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello all,

While investigating some performance issues on mdraid 10 volumes
formed with "512e" disks (4k native/physical sector size but with 512
byte sector emulation), I've found two cases where mdraid will
needlessly issue writes that start on 4k byte boundary, but are are
shorter than 4k:

1. writes of the raid superblock; and
2. writes of the last page of the write-intent bitmap.

The following is an excerpt of a blocktrace of one of the component
members of a mdraid 10 volume during a 4k write near the end of the
array:

  8,32  11        2     0.000001687   711  D  WS 2064 + 8 [kworker/11:1H]
* 8,32  11        5     0.001454119   711  D  WS 2056 + 1 [kworker/11:1H]
* 8,32  11        8     0.002847204   711  D  WS 2080 + 7 [kworker/11:1H]
  8,32  11       11     0.003700545  3094  D  WS 11721043920 + 8 [md127_raid1]
  8,32  11       14     0.308785692   711  D  WS 2064 + 8 [kworker/11:1H]
* 8,32  11       17     0.310201697   711  D  WS 2056 + 1 [kworker/11:1H]
  8,32  11       20     5.500799245   711  D  WS 2064 + 8 [kworker/11:1H]
* 8,32  11       23    15.740923558   711  D  WS 2080 + 7 [kworker/11:1H]

Note the starred transactions, which each start on a 4k boundary, but
are less than 4k in length, and so will use the 512-byte emulation.
Sector 2056 holds the superblock, and is written as a single 512-byte
write.  Sector 2086 holds the bitmap bit relevant to the written
sector.  When it is written the active bits of the last page of the
bitmap are written, starting at sector 2080, padded out to the end of
the 512-byte logical sector as required.  This results in a 3.5kb
write, again using the 512-byte emulation.

Note that in some arrays the last page of the bitmap may be
sufficiently full that they are not affected by the issue with the
bitmap write.

As there can be a substantial penalty to using the 512-byte sector
emulation (turning writes into read-modify writes if the relevant
sector is not in the drive's cache) I believe it makes sense to pad
these writes out to a 4k boundary.  The writes are already padded out
for "4k native" drives, where the short access is illegal.

The following patch set changes the superblock and bitmap writes to
respect the physical block size (e.g. 4k for today's 512e drives) when
possible.  In each case there is already logic for padding out to the
underlying logical sector size.  I reuse or repeat the logic for
padding out to the physical sector size, but treat the padding out as
optional rather than mandatory.

The corresponding block trace with these patches is:

   8,32   1        2     0.000003410   694  D  WS 2064 + 8 [kworker/1:1H]
   8,32   1        5     0.001368788   694  D  WS 2056 + 8 [kworker/1:1H]
   8,32   1        8     0.002727981   694  D  WS 2080 + 8 [kworker/1:1H]
   8,32   1       11     0.003533831  3063  D  WS 11721043920 + 8 [md127_raid1]
   8,32   1       14     0.253952321   694  D  WS 2064 + 8 [kworker/1:1H]
   8,32   1       17     0.255354215   694  D  WS 2056 + 8 [kworker/1:1H]
   8,32   1       20     5.337938486   694  D  WS 2064 + 8 [kworker/1:1H]
   8,32   1       23    15.577963062   694  D  WS 2080 + 8 [kworker/1:1H]

I do notice that the code for bitmap writes has a more sophisticated
and thorough check for overlap than the code for superblock writes.
(Compare write_sb_page in md-bitmap.c vs. super_1_load in md.c.) From
what I know since the various structures starts have always been 4k
aligned anyway, it is always safe to pad the superblock write out to
4k (as occurs on 4k native drives) but not necessarily futher.

Feedback appreciated.

  --Chris


Christopher Unkel (3):
  md: align superblock writes to physical blocks
  md: factor sb write alignment check into function
  md: pad writes to end of bitmap to physical blocks

 drivers/md/md-bitmap.c | 80 +++++++++++++++++++++++++-----------------
 drivers/md/md.c        | 15 ++++++++
 2 files changed, 63 insertions(+), 32 deletions(-)

-- 
2.17.1

