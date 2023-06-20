Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1C1EB64D7
	for <linux-raid@archiver.kernel.org>; Tue, 20 Jun 2023 18:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjFTSua (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Jun 2023 14:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFTSu3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Jun 2023 14:50:29 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559D810DA
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 11:50:27 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-77de8cc1370so55639639f.1
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 11:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687287026; x=1689879026;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q2oJeKg2295ZW4+oFZd0KhW8kvlNPjdhIaqSYcEhYdE=;
        b=uEEytb8IfuPMIpeeqxDFwObmfpD4Yur+nfGTc6btAHvnkmpdu6ay+gsclOmuq1KNSZ
         TLOqIv3fbzwdAzlXYsvt3kav3xVyhJwmQKFjDe3TvukLmcjThXZeoRe3p2nXvMzMTT2c
         WltTKYG/yz0qjcGj4q6ZHdT50cdzMLbj9kcAtjL+Q3dnJEfD+EjURo0spKTaldvFy8jo
         uRBi6FTlQ10On7MCHqOfoKVA7OSavZPldVIk0K04fsFX61qKNLWMn1lgzelHtWffY35R
         W6Ui57qkRo1LRyOOfNU/drSJboP5thh35LXQtPZHkOPnA3Q7E0h7yHtddGaWwK2xQo+5
         tjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687287026; x=1689879026;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2oJeKg2295ZW4+oFZd0KhW8kvlNPjdhIaqSYcEhYdE=;
        b=Gtut2TDAdVayapdVNr7188sXfM1xQ2JLtUDbIa8yxRPLzsNrjkBjdn4/3iTV2ZHihQ
         HtFjUN+1I5TQk3k587svCWJ7GwsCmOmNIZNCDDu9v8MRHopyKAXp+zui7rZIXT9EVFy8
         kTUXkrXkYMQABxTZPQVGyJRs6c3Eug9afodvdT1YSFDSDIsTD+io6s2sQL6OCWLy7jkg
         LHrqk4GDf1Kh2ydoYswkBAu4lTYDr90ut7f+XWEFDBQEmZxdEM+Lr3l3LUHc47HO5fPc
         DpY2+fg598SBZPBopXwOzZDHILEpTAQQ7LfE+E+1vcykZaGImkmXg1bpoilRgXKOKfdm
         GbnA==
X-Gm-Message-State: AC+VfDwaN1b8y6xBMIgSuH+LYPcrM/um2EonWqlqWae9wLrBOsVQ3sHZ
        AD3zn/MgouM94KpVK8Fy4OkD7A==
X-Google-Smtp-Source: ACHHUZ4SczXoEjujWT9H1CzOVupU3UPu0mLyPOkwdGkdTDwEJBLX0ziiS8aXB5fZC9moLR7pK79WLw==
X-Received: by 2002:a6b:b256:0:b0:77e:3892:1e84 with SMTP id b83-20020a6bb256000000b0077e38921e84mr7172432iof.0.1687287026681;
        Tue, 20 Jun 2023 11:50:26 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u24-20020a02aa98000000b0041631393ac9sm809441jai.18.2023.06.20.11.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 11:50:26 -0700 (PDT)
Message-ID: <50217644-7acc-dccd-bada-d31dda2d29a4@kernel.dk>
Date:   Tue, 20 Jun 2023 12:50:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] md: use mddev->external to select holder in export_rdev()
Content-Language: en-US
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20230617052405.305871-1-song@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230617052405.305871-1-song@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/16/23 11:24 PM, Song Liu wrote:
> mdadm test "10ddf-create-fail-rebuild" triggers warnings like the following
> 
> [  215.526357] ------------[ cut here ]------------
> [  215.527243] WARNING: CPU: 18 PID: 1264 at block/bdev.c:617 blkdev_put+0x269/0x350
> [  215.528334] Modules linked in:
> [  215.528806] CPU: 18 PID: 1264 Comm: mdmon Not tainted 6.4.0-rc2+ #768
> [  215.529863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> [  215.531464] RIP: 0010:blkdev_put+0x269/0x350
> [  215.532167] Code: ff ff 49 8d 7d 10 e8 56 bf b8 ff 4d 8b 65 10 49 8d bc
> 24 58 05 00 00 e8 05 be b8 ff 41 83 ac 24 58 05 00 00 01 e9 44 ff ff ff
> <0f> 0b e9 52 fe ff ff 0f 0b e9 6b fe ff ff1
> [  215.534780] RSP: 0018:ffffc900040bfbf0 EFLAGS: 00010283
> [  215.535635] RAX: ffff888174001000 RBX: ffff88810b1c3b00 RCX: ffffffff819a4061
> [  215.536645] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI: ffff88810b1c3ba0
> [  215.537657] RBP: ffff88810dbde800 R08: fffffbfff0fca983 R09: fffffbfff0fca983
> [  215.538674] R10: ffffc900040bfbf0 R11: fffffbfff0fca982 R12: ffff88810b1c3b38
> [  215.539687] R13: ffff88810b1c3b10 R14: ffff88810dbdecb8 R15: ffff88810b1c3b00
> [  215.540833] FS:  00007f2aabdff700(0000) GS:ffff888dfb400000(0000) knlGS:0000000000000000
> [  215.541961] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  215.542775] CR2: 00007fa19a85d934 CR3: 000000010c076006 CR4: 0000000000370ee0
> [  215.543814] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  215.544840] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  215.545885] Call Trace:
> [  215.546257]  <TASK>
> [  215.546608]  export_rdev.isra.63+0x71/0xe0
> [  215.547338]  mddev_unlock+0x1b1/0x2d0
> [  215.547898]  array_state_store+0x28d/0x450
> [  215.548519]  md_attr_store+0xd7/0x150
> [  215.549059]  ? __pfx_sysfs_kf_write+0x10/0x10
> [  215.549702]  kernfs_fop_write_iter+0x1b9/0x260
> [  215.550351]  vfs_write+0x491/0x760
> [  215.550863]  ? __pfx_vfs_write+0x10/0x10
> [  215.551445]  ? __fget_files+0x156/0x230
> [  215.552053]  ksys_write+0xc0/0x160
> [  215.552570]  ? __pfx_ksys_write+0x10/0x10
> [  215.553141]  ? ktime_get_coarse_real_ts64+0xec/0x100
> [  215.553878]  do_syscall_64+0x3a/0x90
> [  215.554403]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  215.555125] RIP: 0033:0x7f2aade11847
> [  215.555696] Code: c3 66 90 41 54 49 89 d4 55 48 89 f5 53 89 fb 48 83 ec
> 10 e8 1b fd ff ff 4c 89 e2 48 89 ee 89 df 41 89 c0 b8 01 00 00 00 0f 05
> <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 448
> [  215.558398] RSP: 002b:00007f2aabdfeba0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> [  215.559516] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007f2aade11847
> [  215.560515] RDX: 0000000000000005 RSI: 0000000000438b8b RDI: 0000000000000010
> [  215.561512] RBP: 0000000000438b8b R08: 0000000000000000 R09: 00007f2aaecf0060
> [  215.562511] R10: 000000000e3ba40b R11: 0000000000000293 R12: 0000000000000005
> [  215.563647] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000c70750
> [  215.564693]  </TASK>
> [  215.565029] irq event stamp: 15979
> [  215.565584] hardirqs last  enabled at (15991): [<ffffffff811a7432>] __up_console_sem+0x52/0x60
> [  215.566806] hardirqs last disabled at (16000): [<ffffffff811a7417>] __up_console_sem+0x37/0x60
> [  215.568022] softirqs last  enabled at (15716): [<ffffffff8277a2db>] __do_softirq+0x3eb/0x531
> [  215.569239] softirqs last disabled at (15711): [<ffffffff810d8f45>] irq_exit_rcu+0x115/0x160
> [  215.570434] ---[ end trace 0000000000000000 ]---
> 
> This means export_rdev() calls blkdev_put with a different holder than the
> one used by blkdev_get_by_dev(). This is because mddev->major_version == -2
> is not a good check for external metadata. Fix this by using
> mddev->external instead.
> 
> Also, do not clear mddev->external in md_clean(), as the flag might be used
> later in export_rdev().

Want me to grab this one directly, or is it going into a pull request?

-- 
Jens Axboe


