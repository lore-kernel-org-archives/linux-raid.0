Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1C1C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 15 Feb 2022 13:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbiBONen (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Feb 2022 08:34:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbiBONel (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Feb 2022 08:34:41 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B801106C8A
        for <linux-raid@vger.kernel.org>; Tue, 15 Feb 2022 05:34:31 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 53C6C210F6;
        Tue, 15 Feb 2022 13:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644932070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+pifBAbrVntr5NyM4nd/CQFtwQDj/UjbiBi41zZTHxM=;
        b=eBmV3O1B5SkNs2YMzXOIQFFwZmJaE7PHljGpbGNe9sdKXWmiss3PADYsGsXtnblTtoU7db
        gSWtkiRkA4ZHy4WW2dB66JKqa3ojAp6wO9MnSWRrzWlPnCi6g89wmJxcMifuw/v9yN7hZ5
        Tl8bu8SS2hke6desmvqxdgsyFoHu08E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644932070;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+pifBAbrVntr5NyM4nd/CQFtwQDj/UjbiBi41zZTHxM=;
        b=14wYVo3WxpZC7kL7xY6PTONig56Vq1BC01aBSd4AWJCdLvk7Wpkoayvi9NvYdsuVA+NZVS
        vwkk0vInu4ORV2Dg==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id C0AB7A3B81;
        Tue, 15 Feb 2022 13:34:24 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Neil Brown <neilb@suse.de>, Xiao Ni <xni@redhat.com>
Subject: [PATCH] mdadm/systemd: remove KillMode=none from service file
Date:   Tue, 15 Feb 2022 21:34:15 +0800
Message-Id: <20220215133415.4138-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

For mdadm's systemd configuration, current systemd KillMode is "none" in
following service files,
- mdadm-grow-continue@.service
- mdmon@.service

This "none" mode is strongly againsted by systemd developers (see man 5
systemd.kill for "KillMode=" section), and is considering to remove in
future systemd version.

As systemd developer explained in disuccsion, the systemd kill process
is,
1. send the signal specified by KillSignal= to the list of processes (if
   any), TERM is the default
2. wait until either the target of process(es) exit or a timeout expires
3. if the timeout expires send the signal specified by FinalKillSignal=,
   KILL is the default

For "control-group", all remaining processes will receive the SIGTERM
signal (by default) and if there are still processes after a period f
time, they will get the SIGKILL signal.

For "mixed", only the main process will receive the SIGTERM signal, and
if there are still processes after a period of time, all remaining
processes (including the main one) will receive the SIGKILL signal.

From the above comment, currently KillMode=control-group is a proper
kill mode. Since control-gropu is the default kill mode, the fix can be
simply removing KillMode=none line from the service file, then the
default mode will take effect.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Benjamin Brunner <bbrunner@suse.com>
Cc: Franck Bui <fbui@suse.de>
Cc: Jes Sorensen <jes@trained-monkey.org>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Xiao Ni <xni@redhat.com>
---
 systemd/mdadm-grow-continue@.service | 1 -
 systemd/mdmon@.service               | 1 -
 2 files changed, 2 deletions(-)

diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
index 5c667d2..9fdc8ec 100644
--- a/systemd/mdadm-grow-continue@.service
+++ b/systemd/mdadm-grow-continue@.service
@@ -14,4 +14,3 @@ ExecStart=BINDIR/mdadm --grow --continue /dev/%I
 StandardInput=null
 StandardOutput=null
 StandardError=null
-KillMode=none
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 85a3a7c..7753395 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -25,4 +25,3 @@ Type=forking
 # it out) and systemd will remove it when transitioning from
 # initramfs to rootfs.
 #PIDFile=/run/mdadm/%I.pid
-KillMode=none
-- 
2.31.1

