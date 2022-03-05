Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4111C4332F
	for <linux-raid@archiver.kernel.org>; Sat,  5 Mar 2022 06:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiCEGUr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Mar 2022 01:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiCEGUq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Mar 2022 01:20:46 -0500
X-Greylist: delayed 494 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Mar 2022 22:19:56 PST
Received: from kyoto-arc.or.jp (ns.kyoto-arc.or.jp [202.252.247.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57FF5527D0
        for <linux-raid@vger.kernel.org>; Fri,  4 Mar 2022 22:19:55 -0800 (PST)
Received: from [192.168.2.84] ([202.252.247.10]:15509)
        by kyoto-arc.or.jp with [XMail ESMTP Server]
        id <S15B45B> for <linux-raid@vger.kernel.org> from <kengo@kyoto-arc.or.jp>;
        Sat, 5 Mar 2022 15:11:38 +0900
Mime-Version: 1.0
X-Sender: kengo@ms.kyoto-arc.or.jp
X-Mailer: QUALCOMM MacOS Classic Eudora Version 6J Jr6
Message-Id: <p06001087de48ad4092ee@kyoto-arc.or.jp>
In-Reply-To: <20220305051929.GA24696@lst.de>
References: <20220304175556.407719-1-hch@lst.de>
 <20220304175556.407719-2-hch@lst.de>
 <20220304221255.GL3927073@dread.disaster.area>
 <20220305051929.GA24696@lst.de>
Date:   Sat, 5 Mar 2022 15:09:55 +0900
To:     linux-raid@vger.kernel.org
From:   "Kengo.M" <kengo@kyoto-arc.or.jp>
Subject: Number of parity disks
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Folks

I use mdadm conveniently.

Let me ask a very very basic question.

One parity disk can be used in RAID 5 and 2 parity disks can be used in RAID 6.
ZFS RAIDZ-3 (raidz3) can use 3 parity disks.

Is it difficult to increase the number of parity disks to 4, 5 or more.
If so, is the reason for this because of the time it takes to 
generate the parity bits?

Kengo Miyahara
