Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940F8C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 08:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4656A601FF
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 08:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhBXInT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:43:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234516AbhBXImP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Feb 2021 03:42:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B72D364EEC
        for <linux-raid@vger.kernel.org>; Wed, 24 Feb 2021 08:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614156094;
        bh=+3THlAGPDwF+Tz8hRmbBJlT5XbMa/8lbsiAapRgC1Wc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ar9eNQ3T/+Yaas1XrFBoHlHGFDaEaDpNcYxtbGqQ90NfrvQX6xzBAQgTEWCqipKCd
         4LvdslqmLLt+77+kdtzNXljoQNj7KVj0cuk2g5toy9G2a8uhmVQesmGKp/kfvY1MHp
         EEqjLzyLNWM3F4by+ZMTEDgHMT3A+fkXbi+YMYveKhnRiycb6kUGgknX9LQGtvmxUG
         uMtZDcTgLbCafUGRlhjcaMLF1j2h+ziU2ABS2CfYIUhYAl+rSGKfvWvi4IyvjisEq3
         Pp7B9iIjIL1lBg77bjfss8t+svmpQ9g1zbrNxqTKp+NryqRopDXjaIbLPCQBVYX9SQ
         HdlevzdW2Jxbg==
Received: by mail-lj1-f175.google.com with SMTP id q14so1477417ljp.4
        for <linux-raid@vger.kernel.org>; Wed, 24 Feb 2021 00:41:33 -0800 (PST)
X-Gm-Message-State: AOAM531+wlblqSLO5u4qh+asGyxAhqrFzUFMSge8P7q8RbWo3alomYS4
        KEi7LhtbatYCLtMoVS+XOC53dB4XsxzT960iku8=
X-Google-Smtp-Source: ABdhPJweitAO3cvvpnkcpgbgr7W8C81g2oQkY802XGnalTXT0Kvdmc+erwZcxi7WRs8kcLD/d/NXjOzWjrPMdGFsDPU=
X-Received: by 2002:a05:651c:1355:: with SMTP id j21mr16603989ljb.270.1614156091856;
 Wed, 24 Feb 2021 00:41:31 -0800 (PST)
MIME-Version: 1.0
References: <1612425047-10953-1-git-send-email-xni@redhat.com>
 <d86c7211-787f-ee34-d2c1-cf780ecd9322@canonical.com> <75ba722d-f11e-ebe5-5507-b0c380c203e9@redhat.com>
In-Reply-To: <75ba722d-f11e-ebe5-5507-b0c380c203e9@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 24 Feb 2021 00:41:20 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6NNGxK3ARvQHjoAK0-w1y938qdDAVH8xOYjEEY3QhhQQ@mail.gmail.com>
Message-ID: <CAPhsuW6NNGxK3ARvQHjoAK0-w1y938qdDAVH8xOYjEEY3QhhQQ@mail.gmail.com>
Subject: Re: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
To:     Xiao Ni <xni@redhat.com>
Cc:     Matthew Ruffell <matthew.ruffell@canonical.com>,
        Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Feb 20, 2021 at 12:21 AM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Matthew
>
> Thanks very much for those test. And as you said, it's better to wait
> more test results.
> By the way, do you know the date of 5.13 merge window?

5.13 merge window will be April (about 2 months from now).

I applied the set to md-next.

Thanks,
Song

>
> Regards
> Xiao
>
> On 02/15/2021 12:05 PM, Matthew Ruffell wrote:
> > Hi Xiao,
> >
> > Thanks for posting the patchset. I have been testing them over the past week,
> > and they are looking good.
> >
> > I backported [0] the patchset to the Ubuntu 4.15, 5.4 and 5.8 kernels, and I have
> > been testing them on public clouds.
> >
> > [0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1896578/comments/13
> >
> > For performance, formatting a Raid10 array on NVMe disks drops from 8.5 minutes
> > to about 6 seconds [1], on AWS i3.8xlarge with 4x 1.7TB disks, due to the
> > speedup in block discard.
> >
> > [1] https://paste.ubuntu.com/p/NNGqP3xdsc/
> >
> > I have also tested the data corruption reproducer from my original problem
> > report [2], and I have found that throughout each of the steps of formatting the
> > array, doing a consistency check, writing data, doing a consistency check,
> > issuing a fstrim, doing a consistency check, the /sys/block/md0/md/mismatch_cnt
> > was always 0, and all deep fsck checks came back clean for individual disks [3].
> >
> > [2] https://www.spinics.net/lists/kernel/msg3765302.html
> > [3] https://paste.ubuntu.com/p/5DK57TzdFH/
> >
> > So I think your patches do solve the data corruption problem. Great job.
> >
> > To try and get some more eyes on the patches, I have provided my test kernels to
> > 5 other users who are hitting the Raid10 block discard performance problem, and
> > I have asked them to test on spare test servers, and to provide feedback on
> > performance and data safety.
> >
> > I will let you know their feedback as it comes in.
> >
> > As for getting this merged, I actually agree with Song, the 5.12 merge window
> > is happening right now, and it is a bit too soon for large changes like this.
> > I think we should wait for the 5.13 merge window. That way we can do some more
> > testing, get feedback from some users, and make sure we don't cause any more
> > data corruption regressions.
> >
> > I will write back soon with some user feedback and more test results.
> >
> > Thanks,
> > Matthew
> >
>
