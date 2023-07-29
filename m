Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D3CC0015E
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 12:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjG2MX2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Jul 2023 08:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjG2MX1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Jul 2023 08:23:27 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B728FCE
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 05:23:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d9443c01a7336-1b8b4748fe4so20029335ad.1
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 05:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1690633401; x=1691238201;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qnSTM3dCxM/7XwQxQRefFAppegRSxkwa7okh3rjAC1Q=;
        b=GnhPUCCXZBo2v78etkY6wFZQZfJmVfVBpAziVK/Zj6k2CL9qkTbjgtglMrGYI//3VA
         eNXznKkACicOtsAgMHAmmIJUZRlhyDL+dK3U3IsSv78hKYoegGsj1VajNt6yB1vTDmtS
         B5GvFPMUazAq6P2W0O3mjKnFQ2n6TzDn3xrmAcXBG1+OByp8wrEAV/C+v6I5tt1qszIH
         yiT65/RbOBhU1qmDbJnOUHk0BnujqgVk/W/o0r4sEJrb89NjhDr6faJoG5/FbJ4kr3B2
         lLrDlxf5WxVug/lPezLKXDsSzZ/XrjDs+JhyiruP3ucCSMtsc6gruQDyLFlPp4sdOxpQ
         ZtMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690633401; x=1691238201;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qnSTM3dCxM/7XwQxQRefFAppegRSxkwa7okh3rjAC1Q=;
        b=cfPlvJtyMxDUlxQN6cA7jfGgyfqAsx4BtzB5kfY5kbkiQRAwe5lAPAPGJJ07fdiiOK
         VpmskHPfHYLj3+k6y69nneOecmpw6erlh2qFjTm33uYKjiP9lCUPM9V+hbTOyHr02gza
         PeWZOqKc9JOmY5dnceoLiDpSrE6Q01CdnGKjgUQ5NCepKQ5e1WFyU+sywFeTFVN97DIN
         H/9qtxayPE2wYWTjZYQVRmC/9HWnrkMtmJXZbPXsWdstv+NiCJMYwzzk3kr5hHZPDwH9
         /VjmYJ0pCB57oryOqO8wRqieEH6eDqDSb2I8fnB1lC6Sdsq2cWbGLSnbQehwb54UwC+T
         4Nqg==
X-Gm-Message-State: ABy/qLboI/zWuzqjoEwoUtOFeBxzcttvfmQeXqWfUP0BDoRaRMIkRtlq
        trDnRpHtRoZk6SKkL/QDxGVn9A==
X-Google-Smtp-Source: APBJJlF+NXmiTnPr/PTbetSWihyhIJebsfn1Dj83HclZXTKuDbEFEV66NaZT2CIEcL8s+7ndQriHyA==
X-Received: by 2002:a17:902:eccf:b0:1b8:6b17:9093 with SMTP id a15-20020a170902eccf00b001b86b179093mr5041263plh.1.1690633401161;
        Sat, 29 Jul 2023 05:23:21 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id iz12-20020a170902ef8c00b001b9de2b905asm5209428plb.231.2023.07.29.05.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jul 2023 05:23:20 -0700 (PDT)
Date:   Sat, 29 Jul 2023 20:23:17 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
Message-ID: <bkou447mvbzpka2xyzojdyywogm3ljdstnfuhf4c3zyribrw55@joxaoryhdiji>
References: <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
 <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
 <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
 <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
 <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
 <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
 <e4dd94a5-0f03-9b7b-72cf-f0ce17441815@huaweicloud.com>
 <443169b3-4e38-d4fe-0450-5d2698c65988@huaweicloud.com>
 <honxxkye2lhuzkpty2hv3jlrhd72od3mc6rcb27koeo4hq66bs@qsczyfxupqd3>
 <0d683096-5084-df23-8c6d-a1725f834b3d@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d683096-5084-df23-8c6d-a1725f834b3d@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jul 29, 2023 at 03:37:41PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/29 14:16, Xueshi Hu 写道:
> > On Sat, Jul 29, 2023 at 11:51:27AM +0800, Yu Kuai wrote:
> > > Hi,
> > > 
> > > 在 2023/07/29 11:36, Yu Kuai 写道:
> > > > Hi,
> > > > 
> > > > 在 2023/07/29 11:29, Xueshi Hu 写道:
> > > > > > > > I think this is wrong, you should at least keep following:
> > > > > > > > 
> > > > > > > >            set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> > > > > > > >            set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > > > > > > >            md_wakeup_thread(mddev->thread);
> > > > > > > > 
> > > > > > > I fail to comprehend the rationale behind the kernel's need to invoke
> > > > > > > raid1d() repeatedly despite the absence of any modifications.
> > > > > > > It appears that raid1d() is responsible for invoking
> > > > > > > md_check_recovery()
> > > > > > > and resubmit the failed io.
> > > > > > 
> > > > > > No, the point here is to set MD_RECOVERY_NEEDED and MD_RECOVERY_RECOVER,
> > > > > > so that md_check_recovery() can start to reshape.
> > > > > I apologize, but I am still unable to comprehend your idea.
> > > > > If mmdev->delta_disks == 0 , what is the purpose of invoking
> > > > > md_check_recovery() again?
> > > > 
> > > > Sounds like you think raid1_reshape() can only be called from
> > > > md_check_recovery(), please take a look at other callers.
> > Thank you for the quick reply and patience.
> > 
> > Of course, I have checked all the caller of md_personality::check_reshape.
> > 
> > - layout_store
> > - action_store
> > - chunk_size_store
> > - md_ioctl
> > 	__md_set_array_info
> > 		update_array_info
> > - md_check_recovery
> > - md_ioctl
> > 	__md_set_array_info
> > 		update_array_info
> > 			update_raid_disks
> > - process_metadata_update
> > 	md_reload_sb
> > 		check_sb_changes
> > 			update_raid_disks
> > - raid_disks_store
> > 	update_raid_disks
> > 
> > There are three categories of callers except md_check_recovery().
> > 1. write to sysfs
> > 2. ioctl
> > 3. revice instructions from md cluster peer
> > 
> > Using "echo 4 > /sys/devices/virtual/block/md10/md/raid_disks" as an
> > example, if the mddev::raid_disks is already 4, I don't think
> > raid1_reshape() should set MD_RECOVERY_RECOVER and MD_RECOVERY_NEEDED
> > bit, then wake up the mddev::thread to call md_check_recovery().
> > 
> > Is there any counterexample to demonstrate the issues that may arise if
> > md_check_recovery() is not called out of raid1_reshape() ?
> > 
> > > 
> > > And even if raid1_reshape() is called from md_check_recovery(),
> > > which means reshape is interupted, then MD_RECOVERY_RECOVER
> > > and MD_RECOVERY_RECOVER need to be set, so that reshape can
> > > continue.
> > 
> > raid1 only register md_personality::check_reshape, all the work related
> > with reshape are handle in md_personality::check_reshape.
> > What's the meaning of "reshape can continue" ? In another word, what's
> > the additional work need to do if mddev::raid_disks doesn't change ?
> 
> Okay, I missed that raid1 doesn't have 'start_reshape', reshape here
> really means recovery, synchronize data to new disks. Never mind what
> I said "reshape can continue", it's not possible for raid1.
> 
> Then the problem is the same from 'recovery' point of view:
> if the 'recovery' is interrupted, before this patch, even if raid_disks
> is the same, raid1_reshape() will still set the flag and then
> md_check_recovery() will try to continue the recovery. I'd like to
> keep this behaviour untill it can be sure that no user will be
> affected.

But md_check_recovery() will never call raid1_reshape().

md_personality::check_reshape() is called in md_check_recovery() when
the reshape is in process. But, raid1 is speicial as
mddev::reshape_position always equals to MaxSector in raid1.

By the way, the concern in V2 patch[1] is unnecessary out of the same
reason.

[1]: https://lore.kernel.org/linux-raid/ff93bc7a-5ae2-7a85-91c9-9662d3c5a442@huaweicloud.com/#t

> 
> Thanks,
> Kuai
> 
> > 
> > Thanks,
> > Hu
> > 
> > > 
> > > Thanks,
> > > Kuai
> > > > 
> > > > Thanks,
> > > > Kuai
> > > > 
> > > > .
> > > > 
> > > 
> > .
> > 
> 
