Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7051C43217
	for <linux-raid@archiver.kernel.org>; Fri,  4 Nov 2022 15:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiKDPT2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Nov 2022 11:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiKDPTW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Nov 2022 11:19:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2219585
        for <linux-raid@vger.kernel.org>; Fri,  4 Nov 2022 08:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667575104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/3Emx964qE4HALN/piAaGa3Aj8/+sF9ota+IP7QVzDA=;
        b=PVZn55N9Z2uKvZFijZRMYqmStsjYv/mbN+YmkHPA98bV5ci1tdlD1cgEDgUq0dYj44w3mm
        /G8foR+0cEjXCkMQmsHaOd0TpeWaShpUvMKXaOMQGPSobWHK2wQqy/uZGrGIqgG8Hplkdk
        ecVjmoVMP0CqY9yEbP1xdQupHvMwa+E=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-AdRE4qjBPfm8N1f29waT6A-1; Fri, 04 Nov 2022 11:18:22 -0400
X-MC-Unique: AdRE4qjBPfm8N1f29waT6A-1
Received: by mail-pf1-f198.google.com with SMTP id cw4-20020a056a00450400b00561ec04e77aso2611802pfb.12
        for <linux-raid@vger.kernel.org>; Fri, 04 Nov 2022 08:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3Emx964qE4HALN/piAaGa3Aj8/+sF9ota+IP7QVzDA=;
        b=00AXhxciq5zY2PuysQ/moBS3rIB8HM6nDo+eNvCtrfPRA9VO+9rhK8JYb3sqxj+dAX
         MlJ6vYIRLFCqLqCqsrn3bPJU8Ak3c+y39YsF1sUE1P3i1cJRu+kZ6cwQdzK/pyrHh3PW
         M1JYrOTD2OZYl491mBnYqU6q9jQykAmLDuWlXkKOoPM9kTW6sOf/sUs9SgHzyR4IKXqB
         SUVKKVop9pk+lMTFYtZXSEKd6elNXLyfwpk3oHAJgduH9kRoreXgLNgR2X+tDRLHW0Iz
         HvHr7KHA+1u+BAAnaNMbKuvWkfd53TteEVQMCdtXWeSzwXSJhXO6F9c/qWxCUDRyuT9F
         fkhA==
X-Gm-Message-State: ACrzQf2PyGZy2vxmZ9flOfqjiA0aQ8n+O7Mg0MIckPwIvP+50Aeqf9LN
        7rt54adgqaFegTXNEU5SB9DDTNT7ISCimO4qFAP7PdEDzq4uw02H4gsj00gG24H+TQ9HIHGZ4DX
        vOEJRSa7RyThwFEW5+gkQqH8JkUgy2KjGZcqteQ==
X-Received: by 2002:a17:902:da82:b0:186:ee5a:47c7 with SMTP id j2-20020a170902da8200b00186ee5a47c7mr36394697plx.82.1667575101851;
        Fri, 04 Nov 2022 08:18:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5bL8EYaAoAE9Jtgs/T/s7qCSO5P84GoMtpgEPZ9/i9XWkv3n+6iLAc50+11huhaYdtpC3GKVnQwvLzzzafgxg=
X-Received: by 2002:a17:902:da82:b0:186:ee5a:47c7 with SMTP id
 j2-20020a170902da8200b00186ee5a47c7mr36394671plx.82.1667575101527; Fri, 04
 Nov 2022 08:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev> <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
 <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev> <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
In-Reply-To: <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 4 Nov 2022 23:18:10 +0800
Message-ID: <CALTww2-q0xbMSf2FW9TBkSOeoHuOffQvFyJN5MbLGtx=AF3q1w@mail.gmail.com>
Subject: Re: [dm-devel] A crash caused by the commit 0dd84b319352bb8ba64752d4e45396d8b13e6018
To:     Zdenek Kabelac <zkabelac@redhat.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Heming Zhao <heming.zhao@suse.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 4, 2022 at 7:10 PM Zdenek Kabelac <zkabelac@redhat.com> wrote:
>
> Dne 04. 11. 22 v 2:23 Guoqing Jiang napsal(a):
> >
> >
> > On 11/3/22 10:46 PM, Heming Zhao wrote:
> >> On 11/3/22 11:47 AM, Guoqing Jiang wrote:
> >>> Hi,
> >>>
> >>> On 11/3/22 12:27 AM, Mikulas Patocka wrote:
> >>>> Hi
> >>>>
> >>>> There's a crash in the test shell/lvchange-rebuild-raid.sh when running
> >>>> the lvm testsuite. It can be reproduced by running "make check_local
> >>>> T=shell/lvchange-rebuild-raid.sh" in a loop.
> >>>
> >>> I have problem to run the cmd (not sure what I missed), it would be better if
> >>> the relevant cmds are extracted from the script then I can reproduce it with
> >>> those cmds directly.
> >>>
> >>> [root@localhost lvm2]# git log | head -1
> >>> commit 36a923926c2c27c1a8a5ac262387d2a4d3e620f8
> >>> [root@localhost lvm2]# make check_local T=shell/lvchange-rebuild-raid.sh
> >>> make -C libdm device-mapper
> >>> [...]
> >>> make -C daemons
> >>> make[1]: Nothing to be done for 'all'.
> >>> make -C test check_local
> >>> VERBOSE=0 ./lib/runner \
> >>>          --testdir . --outdir results \
> >>>          --flavours ndev-vanilla --only shell/lvchange-rebuild-raid.sh
> >>> --skip @
> >>> running 1 tests
> >>> ###      running: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 0
> >>> | [ 0:00] lib/inittest: line 133:
> >>> /tmp/LVMTEST317948.iCoLwmDhZW/dev/testnull: Permission denied
> >>> | [ 0:00] Filesystem does support devices in
> >>> /tmp/LVMTEST317948.iCoLwmDhZW/dev (mounted with nodev?)
> >>
> >> I didn't read other mails in this thread, only for above issue.
> >> If you use opensuse, systemd service tmp.mount uses nodev option to mount
> >> tmpfs on /tmp.
> >> From my experience, there are two methods to fix(work around):
> >> 1. systemctl disable tmp.mount && systemctl mask tmp.mount && reboot
> >> 2. mv /usr/lib/systemd/system/tmp.mount /root/ && reboot
> >
> > I am using centos similar system, I can try leap later. Appreciate for the
> > tips, Heming.
>
>
> You can always redirect default /tmp dir to some other place/filesystem that
> allows you to create /dev nodes. Eventually for 'brave men'  you can let lvm2
> test suite to play directly with your /dev dir.  Normally nothing bad should
> happen, but we tend to prefer more controled '/dev' managed for a test.
>
> Here are two envvars to play with:
>
>
> make check_local T=shell/lvchange-rebuild-raid.sh LVM_TEST_DIR=/myhomefsdir
> LVM_TEST_DEVDIR=/dev
>
> LVM_TEST_DIR for setting of dir where test creates all its files
>
> LVM_TEST_DEVDIR  you can explicitly tell to keep using system's /dev
> (instead of dir created within tmpdir)

Hi Zdenek

I tried this command and the test was skipped. Does it need to add
more options for
the command?

make check_local T=shell/lvchange-rebuild-raid.sh
LVM_TEST_DIR=/root/test  LVM_TEST_DEVDIR=/dev

VERBOSE=0 ./lib/runner \
--testdir . --outdir results \
--flavours ndev-vanilla --only shell/lvchange-rebuild-raid.sh --skip @
running 1 tests
###      skipped: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 0

### 1 tests: 0 passed, 1 skipped, 0 timed out, 0 warned, 0 failed

Regards
Xiao

