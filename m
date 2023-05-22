Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D35C77B75
	for <linux-raid@archiver.kernel.org>; Mon, 22 May 2023 06:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbjEVG7I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 May 2023 02:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjEVG6s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 May 2023 02:58:48 -0400
Received: from crane.ash.relay.mailchannels.net (crane.ash.relay.mailchannels.net [23.83.222.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD90B94
        for <linux-raid@vger.kernel.org>; Sun, 21 May 2023 23:57:51 -0700 (PDT)
X-Sender-Id: a2hosting|x-authuser|raid@electrons.cloud
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 1DEA62010FA;
        Mon, 22 May 2023 06:57:47 +0000 (UTC)
Received: from mi3-ss61.a2hosting.com (unknown [127.0.0.6])
        (Authenticated sender: a2hosting)
        by relay.mailchannels.net (Postfix) with ESMTPA id 25450201B31;
        Mon, 22 May 2023 06:57:46 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1684738666; a=rsa-sha256;
        cv=none;
        b=cXX+qokbbO8MfPmJlFlGx7hr5ZPiVZ42kedPEhsGBY9zxKmeyQQbUpRNOf/VW+tlS7v8KD
        cYDOtzUTUFiFycA5EC1YHWAqDZfm0WxkR/13M/0DjPf91mth1w6uevXDlbeYAurf0LspIQ
        c3JjCfGTaseTvq6+mP3NmbfIT/G4VETyhh3stkRhYI9E4HLJthLjjsQu6UXV1cwxJM+RZl
        2QPviE7AitbMkuQX/AUpV5aehLkRP1/W3LrtwsIwNlGuIdcIKPOlVF+/wWcFBHr3iSEe2u
        10+G1b6mTdOhmlqE62n9liIOKQ0ZvQC19uWiUc/u2vke5/2cHpE+a/E5b7j2OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1684738666;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=AS0IEMN86TOcBwL38GQmJhDn+ul/Jr+7Fs45R8bjgiQ=;
        b=Xf68tz25BPckcjttFNvnD45OgHdbvr6LGBROAP28i+0YiDbpO5z/glPyKb38GDmPm/TUhb
        K4y5Z/RnIP94lWmdIfZOxJYCF6PQXYTVVjxz0m1N/IPMzUtkYKfFvoKHoAVHbHXXneaPUo
        ZZ+vm9rE3Ksa7AyF0aAPXhp6+q5hYKnMJHYK7lPnU5SR1osQJzAD0d+Xsmj9LROQOHY//V
        sptFYxIodB4Gzi6Nq128sa9/zEY5nWu4vzpYxTXdGYdArCD8Xk6ezw0h9h6tF/eGSMgJds
        IeMs1W4/gSRtJUOFsV/XR6O6n53dFkLFQD3dxFDQJKzhSwqTl1Fveb58pIcCDw==
ARC-Authentication-Results: i=1;
        rspamd-79bb5575d7-4v5cb;
        auth=pass smtp.auth=a2hosting smtp.mailfrom=raid@electrons.cloud
X-Sender-Id: a2hosting|x-authuser|raid@electrons.cloud
X-MC-Relay: Neutral
X-MailChannels-SenderId: a2hosting|x-authuser|raid@electrons.cloud
X-MailChannels-Auth-Id: a2hosting
X-Turn-Cold: 73a5a5ca59bdf248_1684738666883_3329311362
X-MC-Loop-Signature: 1684738666882:2799585820
X-MC-Ingress-Time: 1684738666882
Received: from mi3-ss61.a2hosting.com (mi3-ss61.a2hosting.com [70.32.23.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.107.49.218 (trex/6.8.1);
        Mon, 22 May 2023 06:57:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=electrons.cloud; s=default; h=Content-Transfer-Encoding:MIME-Version:Date:
        Content-Type:References:In-Reply-To:Cc:To:Reply-To:From:Subject:Message-ID:
        Sender:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AS0IEMN86TOcBwL38GQmJhDn+ul/Jr+7Fs45R8bjgiQ=; b=IjSdR4cNbpyB8HuOGlYeOAtd0j
        SvIr3x6nLoCjM8k5nZn0kF7LMVUeJ9U91MhavtV++Uhf0GMQq5vsIfAk2Ag+llHYyA6vpvmd2Db2+
        iYoRTK83/ACIzTwxvXZoSI+Z19VA9MjGI3o5NG/761Bb4ktmD2oR+FyPT4G/QMIPMHTFXmCSdQwdn
        wiH/lvIsn+8UoBKtBWLmGALLQqFwS7UpeOOFiS2VfUpbmPsw42pNg/Up17IDa1dnS0jUVuHY7b/B7
        /tGv8+Cx96NGdPfhR+TIrochi/SxtCeW4Cx+UwhjcZH8uy2kbSRo0ovLmJODDVfPswwp48Jenoa5l
        3E1jP7eA==;
Received: from [2.56.191.211] (port=37354 helo=OAK2023)
        by mi3-ss61.a2hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <raid@electrons.cloud>)
        id 1q0zUH-0006EP-04;
        Mon, 22 May 2023 02:57:45 -0400
Message-ID: <b18cfe9f6f8e44285aa4ab4300e0c0e1b863fe08.camel@electrons.cloud>
Subject: Re: RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
 (HARDLOCK)
From:   raid <raid@electrons.cloud>
Reply-To: raid@electrons.cloud
To:     Yu Kuai <yukuai1@huaweicloud.com>, Wol <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>,
        "yukuai (C)" <yukuai3@huawei.com>
In-Reply-To: <9b22d5ce-5f1b-0fc8-acdc-02c2e8cefa55@huaweicloud.com>
References: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
         <96524acc-504d-6a07-85a0-0b56a9e2f2d7@youngman.org.uk>
         <9b22d5ce-5f1b-0fc8-acdc-02c2e8cefa55@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 22 May 2023 01:56:05 -0500
MIME-Version: 1.0
User-Agent: Evolution 3.30.5-1.1 
Content-Transfer-Encoding: 7bit
X-AuthUser: raid@electrons.cloud
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
Thanks for the guidance as the current state has at least changed somewhat.

BTW Sorry about Life getting in the way of tech. =) Reason for my delayed response.

-sudo mdadm -I /dev/sdc1
mdadm: /dev/sdc1 attached to /dev/md480, not enough to start (1).
-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 1
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 1

     Delta Devices : 1, (-1->0)
         New Level : raid5
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78714

    Number   Major   Minor   RaidDevice

       -       8       33        -        /dev/sdc1
-sudo mdadm -I /dev/sdd1
mdadm: /dev/sdd1 attached to /dev/md480, not enough to start (2).
-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 2
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 2

     Delta Devices : 1, (-1->0)
         New Level : raid5
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78714

    Number   Major   Minor   RaidDevice

       -       8       49        -        /dev/sdd1
       -       8       33        -        /dev/sdc1
-sudo mdadm -I /dev/sde1
mdadm: /dev/sde1 attached to /dev/md480, not enough to start (2).
-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 3
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 3

     Delta Devices : 1, (-1->0)
         New Level : raid5
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78712

    Number   Major   Minor   RaidDevice

       -       8       65        -        /dev/sde1
       -       8       49        -        /dev/sdd1
       -       8       33        -        /dev/sdc1
-sudo mdadm -I /dev/sdf1
mdadm: /dev/sdf1 attached to /dev/md480, not enough to start (3).
-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 4
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 4

     Delta Devices : 1, (-1->0)
         New Level : raid5
        New Layout : left-symmetric
     New Chunksize : 512K

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78714

    Number   Major   Minor   RaidDevice

       -       8       81        -        /dev/sdf1
       -       8       65        -        /dev/sde1
       -       8       49        -        /dev/sdd1
       -       8       33        -        /dev/sdc1
-sudo mdadm -R /dev/md480 
mdadm: failed to start array /dev/md480: Input/output error
---
NOTE: Of additional interest...
---
-sudo mdadm -D /dev/md480 
/dev/md480:
           Version : 1.2
     Creation Time : Tue Oct 26 14:06:53 2021
        Raid Level : raid5
     Used Dev Size : 18446744073709551615
      Raid Devices : 5
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Thu May  4 14:39:03 2023
             State : active, FAILED, Not Started 
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : unknown

     Delta Devices : 1, (4->5)

              Name : GRANDSLAM:480
              UUID : 20211025:02005a7a:5a7abeef:cafebabe
            Events : 78714

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       -       0        0        1      removed
       -       0        0        2      removed
       -       0        0        3      removed
       -       0        0        4      removed

       -       8       81        3      sync   /dev/sdf1
       -       8       49        1      sync   /dev/sdd1
       -       8       33        0      sync   /dev/sdc1

---
-watch -c -d -n 1 cat /proc/mdstat
---
Every 1.0s: cat /proc/mdstat                                                     OAK2023: Mon May 22 01:48:24 2023

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md480 : inactive sdf1[4] sdd1[1] sdc1[0]
      46877239294 blocks super 1.2

unused devices: <none>
---
Hopeful that is some progress towards an array start? It's definately unexpected output to me.
I/O Error starting md480

Thanks!
SA

On Thu, 2023-05-18 at 11:15 +0800, Yu Kuai wrote:

> I have no idle why other disk shows that device 2 is missing, and what
> is device 4.
> 
> Anyway, can you try the following?
> 
> mdadm -I /dev/sdc1
> mdadm -D /dev/mdxxx
> 
> mdadm -I /dev/sdd1
> mdadm -D /dev/mdxxx
> 
> mdadm -I /dev/sde1
> mdadm -D /dev/mdxxx
> 
> mdadm -I /dev/sdf1
> mdadm -D /dev/mdxxx
> 
> If above works well, you can try:
> 
> mdadm -R /dev/mdxxx, and see if the array can be started.
> 
> Thanks,
> Kuai



