Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C99C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 08:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCCIdf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCCIde (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 03:33:34 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1EE1027F
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 00:33:32 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BC54D2299C;
        Fri,  3 Mar 2023 08:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677832410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BoRR+e0891oMLNDjcRhy8NfgiOrKTaxtIIX308eFDT0=;
        b=PbluKbW4QgqMB0WRXSvfZeDk+UkbFqn7syHnnrBC8dlg1ybrel3j03rBaVb7VJSgtzQMy4
        yUp7FZjGA7QGRRVmF7V/n1I7qeiPbIIWrdkp9u9LjgwFLMVmwja1IzEELnkMZ5TtWUGgYP
        S29O6byCBIrZSFkzAphvWLXVaUSCTw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677832410;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BoRR+e0891oMLNDjcRhy8NfgiOrKTaxtIIX308eFDT0=;
        b=EhUoXrYZSc9JFVi0GmHoQ5tURfS8qbuTNwXKvS/gjXjcfjjCbeikP4zsZ1uLK5aTmN9Jzr
        KvtMUPZk194D41CQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 872BD2C141;
        Fri,  3 Mar 2023 08:33:29 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/6] rebased patch set from Wu Guanghao
Date:   Fri,  3 Mar 2023 16:33:17 +0800
Message-Id: <20230303083323.3406-1-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

This is the rebased patch set from Wu Guanghao, all the patches can
be applied on top of commit 0a07dea8d3b78 ("Mdmonitor: Refactor
check_one_sharer() for better error handling") from the mdadm tree.

The patch from me is to solve conflict for the first patch of Guanghao.
In order to make the commit logs to be more understandable, I recompose
some patch subjects or commit logs.

Thank you in advance for taking them.

Coly Li
---

Coly Li (1):
  util.c: code cleanup for parse_layout_faulty()

Wu Guanghao (5):
  util.c: fix memleak in parse_layout_faulty()
  Detail.c: fix memleak in Detail()
  isuper-intel.c: fix double free in load_imsm_mpb()
  super-intel.c: fix memleak in find_disk_attached_hba()
  super-ddf.c: fix memleak in get_vd_num_of_subarray()

 Detail.c      |  1 +
 super-ddf.c   |  9 +++++++--
 super-intel.c |  5 +++--
 util.c        | 11 ++++++++---
 4 files changed, 19 insertions(+), 7 deletions(-)

-- 
2.39.2

