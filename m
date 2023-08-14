Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546F3C04A94
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 08:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbjHNIvc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 04:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbjHNIv2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 04:51:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E779C127
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 01:51:25 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-686f94328a4so2706030b3a.0
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 01:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1692003085; x=1692607885;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/bkh6h4jMoCcSaWgrHFeEKjBXByfWBFPM0qOpMiZbmo=;
        b=Y7JD4jfTeQ498Q8tUC9uSXZTWef8RrxqcOSBSgJ60AbLeFcp3JZzmJD2Pi7HG17QG/
         YAJ8M6PAYMZs5IsQn4rMOSwCli+amFAo18tZa6gPO8D9j+O2JysmYYsm3twoRTEYrpgR
         Splubll8jn30cHWh0gNgQRkMiWQ2ypPlS7E+e1UVkgmAmoevzZENbeXb2WAMQxwtErde
         0ZA180BXckgRoEOn0FOCSLGopK1PdrqFn9l2MB7/5/+uP5TIz1/dN9we6TkE5ML7BFUg
         2c3doh3m0DDzt86dkWNxYPRG9PEv9+/tN4vAh6wbeGZG1znkSkcvgUJP0qUg8lSGvPQD
         PEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692003085; x=1692607885;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/bkh6h4jMoCcSaWgrHFeEKjBXByfWBFPM0qOpMiZbmo=;
        b=RLemyuTNNIzlF9gNP4PhtjMTYrEHmZ5n84t5Y1CBmLYkZ19VuuqXb4krzVsgmppmAa
         hSHXmXcfUno20p4UWGjfRFfWGcHXe/ThcliPOtpVRJTaebDvbGiG760w7anOQ2bos6GM
         AGv7QeZYjt1rmOyiK4UKF+kLI0TGj0wA1u2/W1Xm0oH0k22mqflrUxoKeI81sRkYlBA1
         FxZ0CVjVJ1zyIld4whGLB98P5phki1XinJW8sBQjI+Wr4UeZT3h/knINw6fwQWk6Kfl9
         XcYc25xQ/rbIUmVL3DatS5PSzTkL3NOPj0dfJCaZw0L1fMYKW9J6LFqPQB0HvHA1bPQH
         8T1A==
X-Gm-Message-State: AOJu0YwFykNA/DUx7v2takbwWYfBIN6HIfukFoUkHXUGi++Q27MUGWWR
        xkXd90rL8AwDWRnEoJ0o9V2Hgg==
X-Google-Smtp-Source: AGHT+IE7Dxf76qIV0yMIldChCtbV4dWh7QFfgZXYDywsndz299Kwo6mscFyP6ViIUpN5K20WAAlPdw==
X-Received: by 2002:a05:6a00:1685:b0:666:c1ab:d6e5 with SMTP id k5-20020a056a00168500b00666c1abd6e5mr10858749pfc.16.1692003085270;
        Mon, 14 Aug 2023 01:51:25 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id fk1-20020a056a003a8100b006765cb3255asm7439668pfb.68.2023.08.14.01.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 01:51:24 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org, djeffery@redhat.com, dan.j.williams@intel.com,
        neilb@suse.de, akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v5 0/3] md/raid1: don't allow_barrier() before r1bio got freed
Date:   Mon, 14 Aug 2023 16:51:05 +0800
Message-Id: <20230814085108.991040-1-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Because raid reshape changes the r1conf::raid_disks and the mempool, it
orders that there's no in-flight r1bio when reshaping. However, the
current caller of allow_barrier() allows the reshape
operation to proceed even if the old r1bio requests have not been freed.

-> v2:
	- fix the problem one by one instead of calling
	blk_mq_freeze_queue() as suggested by Yu Kuai
-> v3:
	- add freeze_array_totally() to replace freeze_array() instead
	  of gave up in raid1_reshape()
	- add a missed fix in raid_end_bio_io()
	- add a small check at the start of raid1_reshape()
-> v4:
	- add fix tag and revise the commit message
	- drop patch 1 as there is an ongoing systematic fix for the bug
	- drop patch 3 as it's unrelated which will be sent in
	another patch
-> v5:
	- split the patch into three parts, with each individual patch fix
	one bug.

Xueshi Hu (3):
  md/raid1: call free_r1bio() before allow_barrier()
  md/raid1: free the r1bio firstly before waiting for blocked rdev
  md/raid1: keep the barrier held until handle_read_error() finished

 drivers/md/raid1.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

-- 
2.40.1

