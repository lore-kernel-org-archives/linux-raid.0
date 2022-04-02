Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23F0C433F5
	for <linux-raid@archiver.kernel.org>; Sat,  2 Apr 2022 14:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243566AbiDBOJ6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Apr 2022 10:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiDBOJ6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Apr 2022 10:09:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE70FFB74
        for <linux-raid@vger.kernel.org>; Sat,  2 Apr 2022 07:08:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5F6DD21613;
        Sat,  2 Apr 2022 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648908484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=K9VsFYGsTv94xvdLk4UWOlpSDLscpPjD9KS1dRremKE=;
        b=phmBJLPktSVIp5L+mdKc4zzykW9xPgThQjewjDUK/ijJjbLKNBqcUh1oo7A0r/dsP+hneb
        U9lYmSJ4tk0bmWjC0XK6Ayyf/wMOAq685XXAnA8lHOr5SiL+6pcHpQtMmHql+7Z32pe0bC
        bXIjfkZ0n/opSSrc6KgZmh8cyx/rRo0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648908484;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=K9VsFYGsTv94xvdLk4UWOlpSDLscpPjD9KS1dRremKE=;
        b=Es6RIi5p2kQs3Trqdx9YDAmlg/3vHi/NXn11RT3oAcFgBLPwhywgJmivignPM+JTsIqDi1
        k3wKCKc6aX7OrTAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F391132C1;
        Sat,  2 Apr 2022 14:08:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tz5jCMNYSGIEHwAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 02 Apr 2022 14:08:03 +0000
Message-ID: <cc0ddd43-688c-5275-6abf-9be52f99bc80@suse.de>
Date:   Sat, 2 Apr 2022 22:08:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>
From:   Coly Li <colyli@suse.de>
Subject: mdadm-CI: reviewed and tested patch for 20220402
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

This is my first output of the mdadm continuous integration effort. 
Currently it is only based on manual code review and very basic smoking 
test (compiling and basic setup).

The whole mdadm-CI progress will be improved bit by bit. Here are the 6 
mdadm patches that reviewed and tested by me, for your further check to 
take them. They are stored in the mdadm-CI tree on for-jes/20220402 
branch, here is the brief information from git request-pull (while this 
is not a pull request).

The following changes since commit cf9a109209aad285372b67306d54118af6fc522b:

   udev: adapt rules to systemd v247 (2022-03-31 11:41:09 -0400)

are available in the Git repository at:

   git@gitolite.kernel.org:pub/scm/linux/kernel/git/colyli/mdadm 
for-jes/20220402

for you to fetch changes up to 3400f9cdeef0064d11b3afcf6c92c69922bb8a4a:

   mdadm: Update config manual (2022-04-02 21:55:36 +0800)

----------------------------------------------------------------
Coly Li (1):
       mdadm/systemd: remove KillMode=none from service file

Lukasz Florczak (5):
       Replace error prone signal() with sigaction()
       mdadm: Respect config file location in man
       mdadm: Update ReadMe
       mdadm: Update config man regarding default files and 
multi-keyword behavior
       mdadm: Update config manual

  .gitignore                           |  1 +
  Grow.c                               |  4 +--
  Makefile                             |  7 +++++-
  Monitor.c                            |  5 ++--
  ReadMe.c                             | 11 ++++----
  managemon.c                          |  1 -
  mdadm.8.in                           | 34 +++++++++++--------------
  mdadm.conf.5 => mdadm.conf.5.in      | 84 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
  mdadm.h                              | 22 ++++++++++++++++
  mdmon.c                              |  1 -
  monitor.c                            |  1 -
  probe_roms.c                         |  6 ++---
  raid6check.c                         | 25 +++++++++++--------
  systemd/mdadm-grow-continue@.service |  1 -
  systemd/mdmon@.service               |  1 -
  util.c                               |  1 -
  16 files changed, 149 insertions(+), 56 deletions(-)
  rename mdadm.conf.5 => mdadm.conf.5.in (90%)


Thanks you in advance for taking care of them.

Coly Li

