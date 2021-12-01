Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B6EC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Dec 2021 06:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhLAG1H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Dec 2021 01:27:07 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:57264 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhLAG1H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Dec 2021 01:27:07 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3053421155;
        Wed,  1 Dec 2021 06:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638339826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HdTKeoebT7JovkGnUSToUrOHmKYXHM/9+1P+IE3zpOQ=;
        b=CSTYZoNOLl8K0u6AvaRKsg9HYcoh5VzMxlqNUdvosDXiGYiMkRV6J7a0m63+obwbotbG+Y
        +A0K2UE1KtovI/QzJkY8NpvY5nUhlPcOGuMNPa1E/zpQr1xUtdKxCdwjECJvQ3vPWflntX
        u5q2ldxT08zVF+JvKmLPmxtJADI8swA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638339826;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HdTKeoebT7JovkGnUSToUrOHmKYXHM/9+1P+IE3zpOQ=;
        b=zBqK6xmZXLQQpXKCq9usq2K8ICc2E8o5PSJ9S8CqcU6FjS1jokI+MbypiOXpK+btqdBbXj
        tszFTCtQGAACZTCQ==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 8408EA3B81;
        Wed,  1 Dec 2021 06:23:44 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Benjamin Brunner <bbrunner@suse.com>,
        Neil Brown <neilb@suse.de>, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH] mdadm/systemd: change KillMode from none to mixed in service files
Date:   Wed,  1 Dec 2021 14:22:45 +0800
Message-Id: <20211201062245.6636-1-colyli@suse.de>
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

This "none" mode is strongly recommended againsted by systemd developers
(see man 5 system.kill for "KillMode=" section), and is considering to
remove in future systemd version.

A proper KillMode is "mixed", which is explained in the system.kill man
page as,
"If set to mixed, the SIGTERM signal (see below) is sent to the main
process while the subsequent SIGKILL signal (see below) is sent to all
remaining processes of the unit's control group."

This patch changes KillMode in above listed service files from "none"
to "mixed", to follow systemd recommendation and avoid potential
unnecessary issue.

Suggested-by: Benjamin Brunner <bbrunner@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jes Sorensen <jsorensen@fb.com>
---
 systemd/mdadm-grow-continue@.service | 2 +-
 systemd/mdmon@.service               | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
index 5c667d2..5fe9d99 100644
--- a/systemd/mdadm-grow-continue@.service
+++ b/systemd/mdadm-grow-continue@.service
@@ -14,4 +14,4 @@ ExecStart=BINDIR/mdadm --grow --continue /dev/%I
 StandardInput=null
 StandardOutput=null
 StandardError=null
-KillMode=none
+KillMode=mixed
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 85a3a7c..5ef1bf5 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -25,4 +25,4 @@ Type=forking
 # it out) and systemd will remove it when transitioning from
 # initramfs to rootfs.
 #PIDFile=/run/mdadm/%I.pid
-KillMode=none
+KillMode=mixed
-- 
2.31.1

