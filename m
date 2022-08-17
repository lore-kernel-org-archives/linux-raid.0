Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1058C25B0E
	for <linux-raid@archiver.kernel.org>; Wed, 17 Aug 2022 02:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbiHQCEY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Aug 2022 22:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238472AbiHQCET (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Aug 2022 22:04:19 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA14B98CB5
        for <linux-raid@vger.kernel.org>; Tue, 16 Aug 2022 19:04:13 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id y10-20020a9d634a000000b006167f7ce0c5so8627001otk.0
        for <linux-raid@vger.kernel.org>; Tue, 16 Aug 2022 19:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VFjy1fpwa0Tbw5K+5q5bwoSo9BXgKEhFuRcQ53/klvU=;
        b=HvhHoYLBb/xv9HmUWW4/P4RAsPcIN4GA2dj7fRNO8dPlygJJQXY64RKhCvPdkM2C9w
         n/TNDxrvOx8l2cCwkaxbLUJWTEI3KjokZKkcg2rU7zNARU30Hgk4FsPfV4bDbkzpOHlT
         FS8v3JUy5p18QReKzFMevT6buZKgNSGFRSG5c7T23ZK5BYLfxW+OholQAZ+f8tTxoA8Z
         bF8fHmgKUkW5Y+kHxbhDV+oaUE9iBYIGIpV+XQ8qjHgRnzTMEFqN3HPV0WwijJaE8aBX
         AEWfFSt0eIHDCKjvvkGVg6isb4JEGA+Bfz6mYo4a1gT8dWUL9ytyao2EF3j/4LwW1b5i
         9tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VFjy1fpwa0Tbw5K+5q5bwoSo9BXgKEhFuRcQ53/klvU=;
        b=HVLhThUItZW6BNWz3pyRZEGuB+Rrvs21I8QKkPjGKqXRkYakDXfcejpi4XZLe1I31Z
         j858Tfs2iG6/YN4is4c2mU6qnXLC4hCJbbhe4pHYVC/sqeO53ARfkuUQT1ckvjoTrs/J
         L2dG+IsjRsRyMC4FHdNujkdQztrBmEVbh5Q4mm35TdB1ECNoad8+1Z6sJcywnTRCOu/U
         NPYsh9di8Ab72Z3wowqx/ukvMU20WARHgbL28/qGP6zldbLgDKO+bZoBXtQ4V8RHLgHf
         9fR1Xdtf8N4z1dH35xfJISt9a1oiDz0zdzOzeHWrU+QhtZReV6k69yiLEx45HS6lrBeB
         5vMw==
X-Gm-Message-State: ACgBeo1eTD+L6PQLaoDydpoROuCCliBsgfe1/q12zzMDTNUR+rGEu8bw
        BbzIcX7BH60ZBRGqPlDP+d4IqL8hPKonCcywTeSJ2ork
X-Google-Smtp-Source: AA6agR5Vpuw1tiHMfPa2EkaMHFlv2S6e/2wk1nd7fg5Pz7d+cMw2lz3bjq5v2LNJ5mQj3+wo+2EH09ZQD8oxvIXSBAQ=
X-Received: by 2002:a05:6830:1bc4:b0:636:e925:c3b6 with SMTP id
 v4-20020a0568301bc400b00636e925c3b6mr8975478ota.86.1660701853065; Tue, 16 Aug
 2022 19:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAGRSmLvY48qanq6qdi40LE_50xT9ZzUq456KntesLSrxt8AmBw@mail.gmail.com>
 <20220816082344.00001dbf@linux.intel.com>
In-Reply-To: <20220816082344.00001dbf@linux.intel.com>
From:   "David F." <df7729@gmail.com>
Date:   Tue, 16 Aug 2022 19:04:02 -0700
Message-ID: <CAGRSmLvKtjtDtrmv1pp7YEdxOGRYnRXs0WaFS_y0HJxX3NYSaA@mail.gmail.com>
Subject: Re: Timeout waiting for /dev/md/imsm0 ?
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

What rules should be used?   I don't see a /dev/md directory, I
created one, stopped the raid (all the /dev/md* devices went away)
and tried to start the raid, same thing and only /dev/md127 gets
created, nothing in /dev/md/ directory and none of the md126 devices ?
 You then get the timeout.

On Tue, Aug 16, 2022 at 12:03 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi David,
> On Mon, 15 Aug 2022 15:28:08 -0700
> "David F." <df7729@gmail.com> wrote:
>
> > I'm not sure if this list is getting the messages but to summarize, if
> > I pass the 5.15.x kernel parameter "nomdraid" to skip udev from doing
> > anything with the RAID and then run:
> >
> > mdadm - v4.1 - 2018-10-01
> >
> > mdadm --examine --scan to create the /etc/mdadm/mdadm.conf file with:
> >
> > ARRAY metadata=imsm UUID=788c3635:2e37de4b:87d08323:987f57e5
> > ARRAY /dev/md/TestRAID container=788c3635:2e37de4b:87d08323:987f57e5
> > member=0 UUID=835de710:3d35bfb1:d159af46:6570f120
> >
> > Then run:
> >
> > mdadm --assemble --scan --no-degraded -v
> >
> > I get:
> >
> > mdadm: looking for devices for further assembly
> > mdadm: no RAID superblock on /dev/sdc1
> > mdadm: /dev/sdc is not attached to Intel(R) RAID controller.
> > mdadm: No OROM/EFI properties for /dev/sdc
> > mdadm: no RAID superblock on /dev/sdc
> > mdadm: no RAID superblock on /dev/sda5
> > mdadm: no RAID superblock on /dev/sda3
> > mdadm: no RAID superblock on /dev/sda2
> > mdadm: no RAID superblock on /dev/sda1
> > mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot 1.
> > mdadm: /dev/sda is identified as a member of /dev/md/imsm0, slot 0.
> > mdadm: added /dev/sdb to /dev/md/imsm0 as 1
> > mdadm: added /dev/sda to /dev/md/imsm0 as 0
> > mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> > mdadm: timeout waiting for /dev/md/imsm0
> > mdadm: looking for devices for /dev/md/TestRAID
> > mdadm: cannot open device /dev/md/imsm0: No such file or directory
> > mdadm: Cannot assemble mbr metadata on /dev/sdc1
> > mdadm: Cannot assemble mbr metadata on /dev/sdc
> > mdadm: /dev/sdb has wrong uuid.
> > mdadm: Cannot assemble mbr metadata on /dev/sda5
> > mdadm: Cannot assemble mbr metadata on /dev/sda3
> > mdadm: Cannot assemble mbr metadata on /dev/sda2
> > mdadm: no recogniseable superblock on /dev/sda1
> > mdadm: /dev/sda has wrong uuid.
> > mdadm: looking for devices for /dev/md/TestRAID
> > mdadm: cannot open device /dev/md/imsm0: No such file or directory
> > mdadm: Cannot assemble mbr metadata on /dev/sdc1
> > mdadm: Cannot assemble mbr metadata on /dev/sdc
> > mdadm: /dev/sdb has wrong uuid.
> > mdadm: Cannot assemble mbr metadata on /dev/sda5
> > mdadm: Cannot assemble mbr metadata on /dev/sda3
> > mdadm: Cannot assemble mbr metadata on /dev/sda2
> > mdadm: no recogniseable superblock on /dev/sda1
> > mdadm: /dev/sda has wrong uuid.
> >
> > If I let UDEV start it and then stop the RAID with:
> >
> > mdadm --stop --scan
>
> No, You didn't ask udev. You asked mdadm to do clean up. It will trigger
> "remove" event at some point so then udev will be involved.
> >
> > (which does stop it) then try to start again using the above command,
> > I still get the timeout.
> >
> > This was working fine with older version 5.10.x kernel with the
> > following differences:
> >
> >    mdadm v4.1 - 2018-10-01 (but from a different build - debian
> > instead of devuan)
> >    kmod as an older version
> >    udev (eudev) was built against the older kmod.
> >    all the various shared libraries and utilities were moved up to
> > versions with Devuan Chimaera
> >    rules updated (although I tried with the old rules too, no difference)
> >
> > Any idea on what is wrong?  Any tricks to have it output more
> > information to diagnose what is happening?   The /dev/md127 device
> > gets created, the actual devices never get created, even if you wait.
>
> The error you mentioned in subject is caused by udev. This error means that
> udev failed to create link in /dev/md/ directory.
> If you are not referencing to this link, it can be ignored. We are expecting
> that udev will create the link and we are waiting for it as some point in mdadm.
>
> Thanks,
> Mariusz
