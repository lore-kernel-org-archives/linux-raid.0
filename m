Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B18C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 13 May 2022 07:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377839AbiEMHhc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 May 2022 03:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377830AbiEMHh3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 May 2022 03:37:29 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9AC6C545
        for <linux-raid@vger.kernel.org>; Fri, 13 May 2022 00:37:26 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id f4so203382lfu.12
        for <linux-raid@vger.kernel.org>; Fri, 13 May 2022 00:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=oGz8/wIzeLol5UifCP65ca+IUgetkxVvyp6QT0zxHq0=;
        b=HamTBW9vPdTNuXMis2KhpXX5mSNSawssFLUGRhNVLEm0gkhES3XqwdB6KdahPfYGBz
         +eOlCIOp8B8OHuqtw2QgVwZxj4JEJiyhM3YRD6H5ajblUrNR8xPOB+vSR9CWVp6snbI8
         YwvNeCtyQVoPru2w4gyiNWsffAkyLhbv6hQzLLdUjOe9YFhi8MpIlNFJ74tI7e4YbxBK
         vv2zLBgl5duYk5ebV5TtbCrz8zKuUpZD6ETl8rWJ8lFYYCQthFKzhCIZBDo8zd8ndQIy
         SwsMj6LHRCu03xpelb26MSv7K3oj17RfHIjA37m9Bni5G0IYlDpHdsiAtAvSsPNLU31j
         CSMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oGz8/wIzeLol5UifCP65ca+IUgetkxVvyp6QT0zxHq0=;
        b=d29U/4Ni52u4PiBKGdb7RFqaPE5LOovaBY4OufnVNh5EssHgwmTKCWOYWSYtIVLBNK
         UPDYX/NLR4ErSOdpMG1OgsYw5DjAqJMQ31FX7VyP599uKH9hw2gMzCMDGy6sq6/85Z9Q
         +JLJttCYYXpwvtJry+3qbHlP5/ApDwiVFivtROs6WpdiYqoNGOy3ntytkffsVSZb1wej
         yGYixh4UztCCkMIbpVqd9Dea15hs2SLKteYCOpYmtkzlo6uO7YsmcW1BL6FnglpgyBsZ
         iutqI0UncJYWWwMoUCwPWPjvGLLQBnwPVQKZqpN7qVtRbBGzWI6tLuD/xw75y/8RLfrs
         Qolg==
X-Gm-Message-State: AOAM530hDNIDYn+s11RtvJSYQoJ3+wQaINZ5OhsWnMDjVrqgLYODo+Pj
        zZxicyJ/Xdj0lJ+deYhFVOZNZ5afmU6ujhd1NRSP9m71R+9YJg==
X-Google-Smtp-Source: ABdhPJwhStxGQUH2xnGtVH4GIrQHIWCxIotdkuzA4BfEjyfXXNqMgvKUyWvrNuzr2jQ/8g+O+zrW8IkABZcMHcRPuu0=
X-Received: by 2002:a05:6512:1694:b0:448:3fd4:c7a9 with SMTP id
 bu20-20020a056512169400b004483fd4c7a9mr2577434lfb.29.1652427444288; Fri, 13
 May 2022 00:37:24 -0700 (PDT)
MIME-Version: 1.0
From:   Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date:   Fri, 13 May 2022 09:37:13 +0200
Message-ID: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
Subject: failed sector detected but disk still active ?
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

How this is possible ?
seems that sdc has some failed sectors but disk is still active in the array

[Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc] Unhandled sense code
[Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
[Mon May  2 03:36:24 2022] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
[Mon May  2 03:36:24 2022] Sense Key : Medium Error [current]
[Mon May  2 03:36:24 2022] Info fld=0x10565570
[Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
[Mon May  2 03:36:24 2022] Add. Sense: Unrecovered read error
[Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc] CDB:
[Mon May  2 03:36:24 2022] Read(10): 28 00 10 56 51 80 00 04 00 00
[Mon May  2 03:36:24 2022] end_request: critical medium error, dev
sdc, sector 274093424
[Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc] Unhandled sense code
[Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
[Mon May  2 03:36:25 2022] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
[Mon May  2 03:36:25 2022] Sense Key : Medium Error [current]
[Mon May  2 03:36:25 2022] Info fld=0x10565584
[Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
[Mon May  2 03:36:25 2022] Add. Sense: Unrecovered read error
[Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc] CDB:
[Mon May  2 03:36:25 2022] Read(10): 28 00 10 56 55 80 00 04 00 00
[Mon May  2 03:36:25 2022] end_request: critical medium error, dev
sdc, sector 274093444
[Mon May  2 04:06:32 2022] md: md0: data-check done.



# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc1[2] sda1[0] sdb1[1]
      292836352 blocks super 1.2 [3/3] [UUU]
      bitmap: 3/3 pages [12KB], 65536KB chunk

unused devices: <none>
