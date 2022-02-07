Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FEBC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  7 Feb 2022 20:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiBGU3U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Feb 2022 15:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241729AbiBGU0y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Feb 2022 15:26:54 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A328C0401E2
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 12:26:51 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 13so11958577qkd.13
        for <linux-raid@vger.kernel.org>; Mon, 07 Feb 2022 12:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=fQAqdG1aOm39yCM9zTj5kQ0s0P8LW1FD+NxBE+s2Hp4=;
        b=EMWciI/iLwBmr1TElwZHBoHsjkz3MxWX2lDgMfo6LqpGFogPb86Ly3yxCogtUQ0sAV
         TsExtF2ZO23CVPps2+BlOGxb9D8WT8EKTnpsieXEZGPkSQnaAY5mw9dh3ZzGBKrTxJIR
         VkS6EHz2iUQm/qHIz/XHLCAlBX21dFatqaDETHLlhpX3k+i+VaSEo32wbq7NdeJgeoyY
         4s96opldO6a6hKmgdgKGyKFNI1v4l4H+VehOidn/pZGQH98SBUSdvLRUUYTLwBWBfEIP
         1MjeuHDz/3wogAZnQxoRZoYYJCNtq5kUVwv/W9b06j1SrcQDULqWC00UIs7aLCR8c4/6
         K6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=fQAqdG1aOm39yCM9zTj5kQ0s0P8LW1FD+NxBE+s2Hp4=;
        b=H5ZcsLEOe7bbsTlpcS+qOnIzKgXceaZEwr5k2b8+QcEZlwKbWRqO/HswGS2xOF/CUS
         ZqCvbpH0hjTRJtNphd5f0VDheCZf5bSDg/gTqQkoQbiaGKskMuKaanrGIzlqPC68rPwA
         B59zliG8V8h0JrwaIiv2jbkxSZHph2USQdra24PztHsIZeH8BeJa1b/SwqPv+qHAx2Rd
         Cr/W3ySuknyZIPtV8iHGUtC4E1fuRbC53HJmL13KYjRAT+AzniIwlQsPKbZ+f+YZKle/
         Fr5PD2/EuDHj6+YMh4yDJbfpkVyRnr6id2J5tXA6MQynWtWMBzflV6DQJaZxpdSShwuu
         qLXQ==
X-Gm-Message-State: AOAM530J0BdquR1wNLAQSEpEipqF4WV1Vp6dzWxlUc+ZT4NWSXNWKpiI
        vAeSHOaw/J0z4kozXenL5DQra1J2JOQ=
X-Google-Smtp-Source: ABdhPJym2p1mdpI/Ahs7shotoupV+V/kcLlGpnGimPVH6XQDcHAa1p2aWp4lKuQJL1nGd9Cql/GRDg==
X-Received: by 2002:a05:620a:9c4:: with SMTP id y4mr923054qky.2.1644265610611;
        Mon, 07 Feb 2022 12:26:50 -0800 (PST)
Received: from falcon.sitarc.ca ([2607:fea8:c39f:f018::c39])
        by smtp.gmail.com with ESMTPSA id y5sm6012132qkp.37.2022.02.07.12.26.50
        for <linux-raid@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Feb 2022 12:26:50 -0800 (PST)
Date:   Mon, 7 Feb 2022 15:26:48 -0500
From:   Red Wil <redwil@gmail.com>
To:     linux-raid <linux-raid@vger.kernel.org>
Subject: RE: Replacing all disks in a an array as a preventative measure
 before failing.
Message-ID: <20220207152648.42dd311a@falcon.sitarc.ca>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

It started as the subject said:
 - goal was to replace all 10 disks in a R6
 - context and perceived constraints
   - soft raid (no imsm and or ddl containers) 
   - multiple disk partition. partitions across 10 disks formed R6
   - downtime not an issue
   - minimize the number of commands
   - minimize disks stress
   - reduce the time spent with this process
   - difficult to add 10 spares at once in the rig
   - after a reshape/grow from 6 to 10 disks offset of data in raid
     members was all over the place from cca 10ksect to 200ksect

Approaches/solutions and critique 
 1- add one by one a 'spare' and 'replace' raid member
  critique:
  - seem to me long and tedious process
  - cannot/will not run in parallel
 2- add all the spares at once and perform 'replace' on members
  critique
  - just tedious - lots of cli commands which can be prone to mistakes.
 next ones assume I have all the 'spares' in the rig
 3- create new arrays on spares, fresh fs and copy data.
 4- dd/ddrescue copy each drive to a new one. Advantage can be done one
 by one or in parallel. less commands in the terminal. 

In the end I decided I will use route (3). 
 - flexibility on creation
 - copy only what I need
 - old array is a sort of backup

Question:
Just for my curiosity regarding (4) assuming array is offline:
Besides being not recommended in case of imsm/ddl containers which (as
far as i understood) keep some data on the hardware itself

In case of pure soft raid is anything technical or safety related that
prevents a 'dd' copy of a physical hard drive to act exactly as the
original.

Thanks
Red
