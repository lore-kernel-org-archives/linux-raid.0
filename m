Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E062EB64DD
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jul 2023 03:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjGaDsV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 30 Jul 2023 23:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjGaDsU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 30 Jul 2023 23:48:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AD0194
        for <linux-raid@vger.kernel.org>; Sun, 30 Jul 2023 20:48:18 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1bbc87ded50so24605125ad.1
        for <linux-raid@vger.kernel.org>; Sun, 30 Jul 2023 20:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1690775298; x=1691380098;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Nh519nWY+Rbby6NzD7ELUMgkrJxVYPAm/gYyEn0y59E=;
        b=3VCWRgqRh5rXtvpbNyyXS4vm8PCArh6a8h/0fp89bvOStmwpypEUJHQggwBxwd3AHS
         ziUFn2NAl2PelR4kFuNJjmI1Q09RSmbtHj+Q7rwhbPgoGxP3mv7Z/HiuBuVqnkxrUPrz
         OxGRQaaOci4oe9l33/UsepBVrcdnJRLr1YfRe96RQFmG1xiwHqcklMwMrwTRaOXjruj/
         HaEZFc2Xi1E0+cED8+wjfwWC37CfXBk5hZa58ULwTrimH0T8RtWuh/sRd5oMiUxRNtnJ
         ct8ROomDDXGbVYbqLKaPbjMfTE4lT/Mb8emNmKKf7sW5rsCbIrnkA8O9toYWPV7P+9J/
         BJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690775298; x=1691380098;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nh519nWY+Rbby6NzD7ELUMgkrJxVYPAm/gYyEn0y59E=;
        b=GUQFyDEsriOOyKO/NamM6k4YEknw3RPJjMfgZoIMNrcdT8n28LKopvNfR7PkIbCxM8
         CL4twVpleO+wOynJ93npRfvN8DItCe5lUyndaxVKOB+8ELtOqBDmlSSj1vk0PDOGFtU+
         jgU6+aPqkH0iReSm2ZvBk7wNmWSDTetuCzYgCzAMGE3FO/E7+oDhxsa5XvUIrKNplTyv
         cvIAUOKLAo5kRP5mAsit2lc92ekuCxl1JPgUdOiOlM/FH/C5t+ER5EU7OerpWzbJpiBH
         fqrFz6RqmDexMgfpr7vfc4uHo8oUUo5D0+gU1+KytAJEpVDZxJLJlIcLmQkRLReVgaQx
         VZIg==
X-Gm-Message-State: ABy/qLbwvqtF8tKXW+4Xjllg6dtzbn9NXlm0XgKCCaDMjF58d1bqBmRI
        2nLJmUasV8Ec4/GzfBmxli3Q+A==
X-Google-Smtp-Source: APBJJlGOa1UuK5XmjZ1cTkSA+qYJ4KzDXZoobQs//de47NsioveMooypkMP5CpD7UHRFVXdyUKgp2A==
X-Received: by 2002:a17:902:b60a:b0:1a6:74f6:fa92 with SMTP id b10-20020a170902b60a00b001a674f6fa92mr8332273pls.19.1690775297736;
        Sun, 30 Jul 2023 20:48:17 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902744400b001b7f9963febsm7287211plt.175.2023.07.30.20.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jul 2023 20:48:17 -0700 (PDT)
Date:   Mon, 31 Jul 2023 11:48:13 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
Message-ID: <jm5cxwosgfolegtnkdt7madecheukl73gpgpabgogie5irt74e@v7knmmj537py>
References: <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
 <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
 <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
 <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
 <e4dd94a5-0f03-9b7b-72cf-f0ce17441815@huaweicloud.com>
 <443169b3-4e38-d4fe-0450-5d2698c65988@huaweicloud.com>
 <honxxkye2lhuzkpty2hv3jlrhd72od3mc6rcb27koeo4hq66bs@qsczyfxupqd3>
 <0d683096-5084-df23-8c6d-a1725f834b3d@huaweicloud.com>
 <bkou447mvbzpka2xyzojdyywogm3ljdstnfuhf4c3zyribrw55@joxaoryhdiji>
 <8085922e-403b-890e-8710-6ac3d09aa3d4@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8085922e-403b-890e-8710-6ac3d09aa3d4@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jul 31, 2023 at 09:03:52AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/29 20:23, Xueshi Hu 写道:
> > On Sat, Jul 29, 2023 at 03:37:41PM +0800, Yu Kuai wrote:
> > > Hi,
> > > 
> > > 在 2023/07/29 14:16, Xueshi Hu 写道:
> > > > On Sat, Jul 29, 2023 at 11:51:27AM +0800, Yu Kuai wrote:
> > > > > Hi,
> > > > > 
> > > > > 在 2023/07/29 11:36, Yu Kuai 写道:
> > > > > > Hi,
> > > > > > 
> > > > > > 在 2023/07/29 11:29, Xueshi Hu 写道:
> > > > > > > > > > I think this is wrong, you should at least keep following:
> > > > > > > > > > 
> > > > > > > > > >             set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> > > > > > > > > >             set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > > > > > > > > >             md_wakeup_thread(mddev->thread);
> > > > > > > > > > 
> > > > > > > > > I fail to comprehend the rationale behind the kernel's need to invoke
> > > > > > > > > raid1d() repeatedly despite the absence of any modifications.
> > > > > > > > > It appears that raid1d() is responsible for invoking
> > > > > > > > > md_check_recovery()
> > > > > > > > > and resubmit the failed io.
> > > > > > > > 
> > > > > > > > No, the point here is to set MD_RECOVERY_NEEDED and MD_RECOVERY_RECOVER,
> > > > > > > > so that md_check_recovery() can start to reshape.
> > > > > > > I apologize, but I am still unable to comprehend your idea.
> > > > > > > If mmdev->delta_disks == 0 , what is the purpose of invoking
> > > > > > > md_check_recovery() again?
> > > > > > 
> > > > > > Sounds like you think raid1_reshape() can only be called from
> > > > > > md_check_recovery(), please take a look at other callers.
> > > > Thank you for the quick reply and patience.
> > > > 
> > > > Of course, I have checked all the caller of md_personality::check_reshape.
> > > > 
> > > > - layout_store
> > > > - action_store
> > > > - chunk_size_store
> > > > - md_ioctl
> > > > 	__md_set_array_info
> > > > 		update_array_info
> > > > - md_check_recovery
> > > > - md_ioctl
> > > > 	__md_set_array_info
> > > > 		update_array_info
> > > > 			update_raid_disks
> > > > - process_metadata_update
> > > > 	md_reload_sb
> > > > 		check_sb_changes
> > > > 			update_raid_disks
> > > > - raid_disks_store
> > > > 	update_raid_disks
> > > > 
> > > > There are three categories of callers except md_check_recovery().
> > > > 1. write to sysfs
> > > > 2. ioctl
> > > > 3. revice instructions from md cluster peer
> > > > 
> > > > Using "echo 4 > /sys/devices/virtual/block/md10/md/raid_disks" as an
> > > > example, if the mddev::raid_disks is already 4, I don't think
> > > > raid1_reshape() should set MD_RECOVERY_RECOVER and MD_RECOVERY_NEEDED
> > > > bit, then wake up the mddev::thread to call md_check_recovery().
> > > > 
> > > > Is there any counterexample to demonstrate the issues that may arise if
> > > > md_check_recovery() is not called out of raid1_reshape() ?
> > > > 
> > > > > 
> > > > > And even if raid1_reshape() is called from md_check_recovery(),
> > > > > which means reshape is interupted, then MD_RECOVERY_RECOVER
> > > > > and MD_RECOVERY_RECOVER need to be set, so that reshape can
> > > > > continue.
> > > > 
> > > > raid1 only register md_personality::check_reshape, all the work related
> > > > with reshape are handle in md_personality::check_reshape.
> > > > What's the meaning of "reshape can continue" ? In another word, what's
> > > > the additional work need to do if mddev::raid_disks doesn't change ?
> > > 
> > > Okay, I missed that raid1 doesn't have 'start_reshape', reshape here
> > > really means recovery, synchronize data to new disks. Never mind what
> > > I said "reshape can continue", it's not possible for raid1.
> > > 
> > > Then the problem is the same from 'recovery' point of view:
> > > if the 'recovery' is interrupted, before this patch, even if raid_disks
> > > is the same, raid1_reshape() will still set the flag and then
> > > md_check_recovery() will try to continue the recovery. I'd like to
> > > keep this behaviour untill it can be sure that no user will be
> > > affected.
> > 
> > But md_check_recovery() will never call raid1_reshape().
> > 
> > md_personality::check_reshape() is called in md_check_recovery() when
> > the reshape is in process. But, raid1 is speicial as
> > mddev::reshape_position always equals to MaxSector in raid1.
> > 
> > By the way, the concern in V2 patch[1] is unnecessary out of the same
> > reason.
> > 
> 
> Well... I just said reshape can continue is not possible for raid1, and
> this patch will cause that recovery can't continue is some cases.
I see. I will reread the relevant code to gain a better understanding of
"some cases".

Thanks,
Hu
> 
> Thanks,
> Kuai
> 
> > [1]: https://lore.kernel.org/linux-raid/ff93bc7a-5ae2-7a85-91c9-9662d3c5a442@huaweicloud.com/#t
> > 
> > > 
> > > Thanks,
> > > Kuai
> > > 
> > > > 
> > > > Thanks,
> > > > Hu
> > > > 
> > > > > 
> > > > > Thanks,
> > > > > Kuai
> > > > > > 
> > > > > > Thanks,
> > > > > > Kuai
> > > > > > 
> > > > > > .
> > > > > > 
> > > > > 
> > > > .
> > > > 
> > > 
> > .
> > 
> 
