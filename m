Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC52C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 13 May 2022 16:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381684AbiEMQKv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 May 2022 12:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381798AbiEMQKu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 May 2022 12:10:50 -0400
X-Greylist: delayed 491 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 13 May 2022 09:10:47 PDT
Received: from mr3.vodafonemail.de (mr3.vodafonemail.de [145.253.228.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F19154B06
        for <linux-raid@vger.kernel.org>; Fri, 13 May 2022 09:10:47 -0700 (PDT)
Received: from smtp.vodafone.de (unknown [10.0.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mr3.vodafonemail.de (Postfix) with ESMTPS id 4L0D1k2gr2z1yqT;
        Fri, 13 May 2022 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
        s=vfde-smtpout-mb-15sep; t=1652457754;
        bh=148yt0Ys7t1m1K4yGtUYwBny7rXrzc+eSIfeL6QA3cA=;
        h=Date:From:To:Subject:Message-ID:References:Content-Type:
         In-Reply-To:From;
        b=hW94Wq+ZRV5cu1uTRHN6x3gVjyRLtJYBwbpbSlA8OP9aTRifAgPd5HUbs90XVoK0d
         RHIIYJKE5FnkzFM6J2Qs+rP4dZpi/pjcJrFOQ7n08OTINc2EqfholBQaU1yZtyR0yn
         LAdlTkFnfsnq6lner6lKYUMDICw0OBbQ+1BDL7kY=
Received: from lazy.lzy (p579d7d96.dip0.t-ipconnect.de [87.157.125.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4L0D1g0z6KzMkrj;
        Fri, 13 May 2022 16:02:28 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
        by lazy.lzy (8.17.1/8.14.5) with ESMTPS id 24DG2R8b003807
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 13 May 2022 18:02:27 +0200
Received: (from red@localhost)
        by lazy.lzy (8.17.1/8.16.1/Submit) id 24DG2RJ2003806;
        Fri, 13 May 2022 18:02:27 +0200
Date:   Fri, 13 May 2022 18:02:27 +0200
From:   Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To:     Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Subject: Re: failed sector detected but disk still active ?
Message-ID: <Yn6BEym8s0kVLhD0@lazy.lzy>
References: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 2174
X-purgate-ID: 155817::1652457754-00007BC1-16A02EED/0/0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 13, 2022 at 09:37:13AM +0200, Gandalf Corvotempesta wrote:
> How this is possible ?
> seems that sdc has some failed sectors but disk is still active in the array
> 
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc] Unhandled sense code
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:24 2022] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:24 2022] Sense Key : Medium Error [current]
> [Mon May  2 03:36:24 2022] Info fld=0x10565570
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:24 2022] Add. Sense: Unrecovered read error
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc] CDB:
> [Mon May  2 03:36:24 2022] Read(10): 28 00 10 56 51 80 00 04 00 00
> [Mon May  2 03:36:24 2022] end_request: critical medium error, dev
> sdc, sector 274093424
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc] Unhandled sense code
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:25 2022] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:25 2022] Sense Key : Medium Error [current]
> [Mon May  2 03:36:25 2022] Info fld=0x10565584
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:25 2022] Add. Sense: Unrecovered read error
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc] CDB:
> [Mon May  2 03:36:25 2022] Read(10): 28 00 10 56 55 80 00 04 00 00
> [Mon May  2 03:36:25 2022] end_request: critical medium error, dev
> sdc, sector 274093444
> [Mon May  2 04:06:32 2022] md: md0: data-check done.

The error is reported from the device.

As far as I know, and please someone correct
me if I'm wrong, when a device has an error,
"md" tries to re-write the data, using the
redundancy, and, if no error occurs, it just
continues, no reason to kick the device our
of the array.

bye,

pg

> 
> 
> 
> # cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdc1[2] sda1[0] sdb1[1]
>       292836352 blocks super 1.2 [3/3] [UUU]
>       bitmap: 3/3 pages [12KB], 65536KB chunk
> 
> unused devices: <none>

-- 

piergiorgio
