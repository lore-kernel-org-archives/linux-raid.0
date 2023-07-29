Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1538C0015E
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 06:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjG2GRF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Jul 2023 02:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjG2GRE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Jul 2023 02:17:04 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FF749DE
        for <linux-raid@vger.kernel.org>; Fri, 28 Jul 2023 23:17:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-52cb8e5e9f5so1771460a12.0
        for <linux-raid@vger.kernel.org>; Fri, 28 Jul 2023 23:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1690611422; x=1691216222;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5dY2vqJQxV8mmAVqtLrE+Qay1ZZQjzfwbxj4FBGmgec=;
        b=ssICK1ggAamwDXkY6wEwYL38ARZz6fKTgIPnNEDNDzy/kx8d89MpOVTL2iUhEmWg1N
         jYAY+P5xvjuMZGLTxfeAP8wrHe2AzqKFboOktDVQe/Ju0Bh5gxwTAifjQOUsF/3emqry
         we8tXeGWx/Yb1uEm8m9APFH41s3gB0RmmJK976H+G00lna0cZzFE/wmvIT2p9635PCO1
         N5Og+ZkQQ46MzJIQKsRbG9Df4Y6rY1KUy9bya+AouLZBXrAbg5oPtIzMNyy+do+YVamd
         Lm+LWIhgi2tldweM0JMfhCNm2WtndW1W/eNiqzE+CEE03IbVFYPBsJnYVwXADNopd8Y6
         eWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690611422; x=1691216222;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5dY2vqJQxV8mmAVqtLrE+Qay1ZZQjzfwbxj4FBGmgec=;
        b=gIMBv7mZ7OrQp1TrcW7YZYi6hiL2FaYEClsgC7Bt8AtjFzl9UrBEyl0Gw0zND2Hjh0
         srwXGi2ls0wIx9dKmFGJT9VyWM3/uSdzrvYsPHrdIMrq/1ad60c2kD/grFHmieTjArWU
         G5rxqFZHSq2Ai9teZN7/rFmV7Y4QpzWue2/+2V4ej5DwZyqJ29AYKMLOftlVPHHr8uXZ
         c0nhOGYIB4OLzFIXGooCy0KNsKMEFg5mPffN9Y/KPpxxesc9ZtlQvOVBFPhP8Ede2EHj
         sVJwQYjqTnbQoTzx+6fW6ufgs4Ht4RqamdTbIbxdts4AG0BCyThc+yNBu5wzkXxBDfoV
         9flg==
X-Gm-Message-State: ABy/qLZmsA5vMerhoZkdwY0OVXIj3LR10Z5J811+ey6d6EorXZraLMQC
        mKDix6l3Tipl7wS3DOiOVYU7JL5OVLrI3qusw6Uqr3054lY=
X-Google-Smtp-Source: APBJJlE5f+/ZlkfiVGKusBMilHpQNdy2cKLs+LyErU6+7XwvKmqZhf1UtkhtJV3ET8aml782xI80fQ==
X-Received: by 2002:a17:90a:940d:b0:263:5376:b952 with SMTP id r13-20020a17090a940d00b002635376b952mr5081387pjo.9.1690611422015;
        Fri, 28 Jul 2023 23:17:02 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id ix14-20020a170902f80e00b001b9bebb7a9dsm4544702plb.90.2023.07.28.23.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 23:17:01 -0700 (PDT)
Date:   Sat, 29 Jul 2023 14:16:58 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
Message-ID: <honxxkye2lhuzkpty2hv3jlrhd72od3mc6rcb27koeo4hq66bs@qsczyfxupqd3>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
 <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
 <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
 <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
 <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
 <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
 <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
 <e4dd94a5-0f03-9b7b-72cf-f0ce17441815@huaweicloud.com>
 <443169b3-4e38-d4fe-0450-5d2698c65988@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <443169b3-4e38-d4fe-0450-5d2698c65988@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jul 29, 2023 at 11:51:27AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/29 11:36, Yu Kuai 写道:
> > Hi,
> > 
> > 在 2023/07/29 11:29, Xueshi Hu 写道:
> > > > > > I think this is wrong, you should at least keep following:
> > > > > > 
> > > > > >           set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> > > > > >           set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > > > > >           md_wakeup_thread(mddev->thread);
> > > > > > 
> > > > > I fail to comprehend the rationale behind the kernel's need to invoke
> > > > > raid1d() repeatedly despite the absence of any modifications.
> > > > > It appears that raid1d() is responsible for invoking
> > > > > md_check_recovery()
> > > > > and resubmit the failed io.
> > > > 
> > > > No, the point here is to set MD_RECOVERY_NEEDED and MD_RECOVERY_RECOVER,
> > > > so that md_check_recovery() can start to reshape.
> > > I apologize, but I am still unable to comprehend your idea.
> > > If mmdev->delta_disks == 0 , what is the purpose of invoking
> > > md_check_recovery() again?
> > 
> > Sounds like you think raid1_reshape() can only be called from
> > md_check_recovery(), please take a look at other callers.
Thank you for the quick reply and patience.

Of course, I have checked all the caller of md_personality::check_reshape.

- layout_store
- action_store
- chunk_size_store
- md_ioctl
	__md_set_array_info 
		update_array_info 
- md_check_recovery
- md_ioctl
	__md_set_array_info
		update_array_info
			update_raid_disks
- process_metadata_update
	md_reload_sb
		check_sb_changes
			update_raid_disks
- raid_disks_store
	update_raid_disks

There are three categories of callers except md_check_recovery().
1. write to sysfs
2. ioctl
3. revice instructions from md cluster peer

Using "echo 4 > /sys/devices/virtual/block/md10/md/raid_disks" as an
example, if the mddev::raid_disks is already 4, I don't think 
raid1_reshape() should set MD_RECOVERY_RECOVER and MD_RECOVERY_NEEDED
bit, then wake up the mddev::thread to call md_check_recovery().

Is there any counterexample to demonstrate the issues that may arise if
md_check_recovery() is not called out of raid1_reshape() ?

> 
> And even if raid1_reshape() is called from md_check_recovery(),
> which means reshape is interupted, then MD_RECOVERY_RECOVER
> and MD_RECOVERY_RECOVER need to be set, so that reshape can
> continue.

raid1 only register md_personality::check_reshape, all the work related
with reshape are handle in md_personality::check_reshape.
What's the meaning of "reshape can continue" ? In another word, what's
the additional work need to do if mddev::raid_disks doesn't change ?

Thanks,
Hu

> 
> Thanks,
> Kuai
> > 
> > Thanks,
> > Kuai
> > 
> > .
> > 
> 
