Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A726C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 17 Feb 2022 19:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245099AbiBQTTE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:19:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245097AbiBQTTC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Feb 2022 14:19:02 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2D5C2E60
        for <linux-raid@vger.kernel.org>; Thu, 17 Feb 2022 11:18:46 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m11so1772102pls.5
        for <linux-raid@vger.kernel.org>; Thu, 17 Feb 2022 11:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=MTrLutqpew5dLnuZITM683iqMGWfz4+lQFTczIaZFTo=;
        b=YFX9Ok7MLPeNSJ3QW6bvLzV4k2aYqpmHDZ8+wk+f1JlkhnZZIyiR5HMdJ+c9MgNqbn
         aCRMp+2Qpcvyf7884T1Jw0ZhesgnoSV4Jks5WeJkDlET8y1y4n/FQtU4fR6fAM5IcMvv
         JQ3335z2Oi5JTGwdIPraOtkKWhZ72Y/Hotk6PXAMQsfSvkcRaP7x+0QUzCyIE5PHlSIU
         DA5HX5lh5mOMAC+xU/YSdh94qgGUt5mGAXj0LTvJW7OwLpcX+3mdjVb4f0BwdSGwWOfv
         JX7jH4pLhIgOe081Z0LQN0TOqL62+ZSSxAEueO1EnAQGNOC5JMk2k3Cs+LSdyxyOl3/o
         keLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MTrLutqpew5dLnuZITM683iqMGWfz4+lQFTczIaZFTo=;
        b=J6tDbrWJjAxVFX9kLQSptEaCulbFU/X4FiQnhFLo2MM+F2kjAKulX+pyjYBXvk85R9
         sna36ot8n55eN+dCAgBMsHtKuMFA5TcXYmdq8R0lZmVcmASO/Jewp0S0NKZe07tflW9d
         DH24VOZo3vdEQlKUVE1G6NBRfEsMmRbyKCZszJr7/NVRbFWq4q3UQUCqD6xxcJ6cx6rR
         X51M0EXCoHM4EeuYqMsLp+3u+AJPPDKjpii4i6AteaLGfROWanaDGADHIxiQpzR8wOM5
         xJh0ToqES2xNEL8xS6NhsUNQwjs4n87T4XOOwQAaOQTjRXYl8YQCb9PJnZxrUJmOlL8/
         KSjA==
X-Gm-Message-State: AOAM531Cjkb4YwISSB7HPbi54IUSs+mkGYKaNsGa0sj8ijiJsWMIDJb1
        DP71NHXGXZqMfA1oFtE3WIvYBTABehBpz+/fY4AP04ujxAM=
X-Google-Smtp-Source: ABdhPJwLXDSqQOAXp8cj9s/s8XpOxOUOMc+rjHdDmaEB5PNKrDFvlCD6KgacCLcqRJbg7sYPCWa/fYveNDJNpOSuUH0=
X-Received: by 2002:a17:90a:7e0a:b0:1b8:fa20:f4c with SMTP id
 i10-20020a17090a7e0a00b001b8fa200f4cmr8834096pjl.46.1645125525646; Thu, 17
 Feb 2022 11:18:45 -0800 (PST)
MIME-Version: 1.0
From:   Natanji <natanji@gmail.com>
Date:   Thu, 17 Feb 2022 20:17:00 +0100
Message-ID: <CAG0r0U3Knj67Gxm9mNatXQfuQQNjhHq=3DH5+vaMMqGWVHTZpg@mail.gmail.com>
Subject: Reshape corrupting data after growing raid10
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello everyone,
I have been shifting around my raid10 design a little. Originally it
had 6 devices (each around 3 TB) in layout near=2, with 512K chunks. I
then added two spares and did mdadm --grow --raid-devices=8 - that
took a few days, but was ultimately successful and everything was
running fine.

Now I tried the same thing again last night - added two devices as
spares, then wanted to grow to 10 devices. This time though I figured
the array was getting large enough for benefitting from a larger chunk
size, and I also wanted to change the layout from near=2 to offset=2.
Thus I did:

# mdadm --grow --raid-devices=10 --layout=o2 --chunk=1024K

This had a number of really weird effects. First of all, I immediately
got email notifications that four devices in the raid failed, right
after each other. Like within 5 seconds. Luckily (?) the raid did not
fail - no two failures were on consecutive devices. So the reshape
started nevertheless.

Worried, I checked /proc/mdstat and saw it fluctuating between 0.0%
and 99,9% progress. Checking dmesg I saw a lot of messages about
attempts to access the drives over the bounds of their actual size,
which kept restarting the array (and indeed, attempts to access data
on the md device were extremely slow). Sadly I don't have these exact
logs to share here, since the situation eventually deteriorated even
further: I noticed that I couldn't run mdadm commands anymore, since
it immediately exited with a Segmentation fault.

I immediately froze the reshape via sync_action, remounted / as ro and
used dd_rescue to copy the (still running) system to a backup.
Examining this backup on a remote machine, the ext4 filesystem was
corrupted. I managed to restore it via a backup of the superblock but
many inodes were corrupt and had to be deleted, so something
definitely went terribly wrong.

The system eventually locked up and I had to reboot it. I booted from
a Ubuntu live disk and assembled the array there. The reshape
immediately restarted, this time without the hitches, 99,9%
fluctuations, weird dmesg entries etc. - but I froze the reshape again
shortly after because I'm afraid that it might lead to more
corruption/destruction of data.

For more info, I run raid -> luks -> lvm, so the raid contains one
large luks encrypted volume. There are no errors from luks when
unlocking the device with my password - everything works fine so far.
I don't know if this is because the luks header perhaps resided in the
first 512K of the device, which I guess is the only block that would
not get moved around during the reshape.

I'm currently in the process of using ddrescue to make a backup of the
data in its current state. I guess most of it is still recoverable in
this state and I will definitely learn from this that just because one
reshape worked fine, I should still make an up-to-date backup before
any --grow. What's done is done.

Still, I wonder how and why this even happened. Was I wrong to assume
that when I issue a reshape because of increasing raid-devices, I can
change layout and chunk at the same time? Is the layout change from
near to far not a stable feature of mdadm (I thought it was for a
while now)? Or is it possible that if I let the reshape finish, it
will eventually fix the errors again? My assumption was that a reshape
would never affect/change the data when viewed from the virtual md
device, thus also not on the luks encrypted volume, and thus if there
is any change to my data during the reshape then clearly something
really weird happens during this reshape that absolutely should not
have happened. Is this a user error or is this a bug in mdadm?
