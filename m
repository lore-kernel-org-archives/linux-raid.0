Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDD8C001DF
	for <linux-raid@archiver.kernel.org>; Fri, 28 Jul 2023 14:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbjG1Omb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Jul 2023 10:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbjG1Oma (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Jul 2023 10:42:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8873C24
        for <linux-raid@vger.kernel.org>; Fri, 28 Jul 2023 07:42:28 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1bbd2761f1bso17325155ad.2
        for <linux-raid@vger.kernel.org>; Fri, 28 Jul 2023 07:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1690555347; x=1691160147;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9htDoAkRi54dlosClF0Q6EWGdhdU3Obfj4q+ZNTUTsg=;
        b=jZ4CWQ6bKsjMw3xls0/P9YAcegZwD0T64PPwQPn8Lzs1aPBjxCATxUaEF7fFcwhRG3
         ubl1JHG4kHatKqrM0h5FcwEBLB4dxIDETZiPtJOhH7HlFq1PEaWAtMWW6Istvj8ZgcJa
         WnFXL/jtytvvxbhZTh+hSxRo9t+E96m2f6CRB2mCH0NDwlcIR4mfe+R5Zz8Bt6D5EK3W
         vWhCgqeDCzbqyzKJJvmXQE6T8EoD/PnVR93+3nj3GmGFw7Bw8jzvyg94Z5F03kL/ZbP6
         plZppKVD6rCqdq4UiR8Xxe9JMf6cQAdzVMiEjBbBSn6VLyZyYRbbnYzEBGRpUat73H8L
         2X5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690555347; x=1691160147;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9htDoAkRi54dlosClF0Q6EWGdhdU3Obfj4q+ZNTUTsg=;
        b=k5n6ESLZnMOXdpce9sqQ27pIW0zNNz3lwSCJbhmcRFJAFNlEHONmjasX7RqGJHLmI4
         Y02F+oHAPohHb3SzgwjqxP3QrDnZ3EODbbXqpPhnxwJ7C4Ao0Msop95yITI/Qg98HfEn
         3xB0enQiN9QvwtfatajUkJGJ29Pmd0vlFe561qmqcdlN4W4UIGsyNkmUmbx44lIl5ELv
         p3eiJsFJLJqH+VedaQleL61RXCu2MjfSVOgKbD44CLYtrJZB1BOor4ZA0v7woMLbVfG+
         crvpPPiErfVuvYQXxn77Qocm20zOj1xB4zrteMyVRbeqLx3+xQjv1xQ6QUDx6sfR9dhw
         TXHw==
X-Gm-Message-State: ABy/qLa7/rDa8h2iWvbFneerFTzeTHzV0mA+/gHbFzr8Yca0EN1AS4CY
        ifnPVe4XZklyor03m/xXEuSjmQ==
X-Google-Smtp-Source: APBJJlGNvK9vD7DXGhLdYX44ymSheECW/2UumbvPprfXOyJADSWKxwtB/Pu6HQh8jgSuEb+odXAHJA==
X-Received: by 2002:a17:903:2655:b0:1bb:ed06:72da with SMTP id je21-20020a170903265500b001bbed0672damr1633991plb.14.1690555347519;
        Fri, 28 Jul 2023 07:42:27 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f55100b001b9cdf11764sm3673186plf.31.2023.07.28.07.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 07:42:26 -0700 (PDT)
Date:   Fri, 28 Jul 2023 22:42:16 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
Message-ID: <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
 <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
 <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
 <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 20, 2023 at 09:28:34AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/19 19:51, Xueshi Hu 写道:
> > On Wed, Jul 19, 2023 at 09:38:26AM +0200, Paul Menzel wrote:
> > > Dear Xueshi,
> > > 
> > > 
> > > Thank you for your patches.
> > > 
> > > Am 19.07.23 um 09:09 schrieb Xueshi Hu:
> > > > If array size doesn't changed, nothing need to do.
> > > 
> > > Maybe: … nothing needs to be done.
> > What a hurry, I'll be cautious next time and check the sentences with
> > tools.
> > > 
> > > Do you have a test case to reproduce it?
> > > 
> > Userspace command:
> > 
> > 	echo 4 > /sys/devices/virtual/block/md10/md/raid_disks
> > 
> > Kernel function calling flow:
> > 
> > md_attr_store()
> > 	raid_disks_store()
> > 		update_raid_disks()
> > 			raid1_reshape()
> > 
> > Maybe I shall provide more information when submit patches, thank you for
> > reminding me.
> > > 
> > > Kind regards,
> > > 
> > > Paul
> > > 
> > > 
> > > > Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> > > > ---
> > > >    drivers/md/raid1.c | 9 ++++++---
> > > >    1 file changed, 6 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > > > index 62e86b7d1561..5840b8b0f9b7 100644
> > > > --- a/drivers/md/raid1.c
> > > > +++ b/drivers/md/raid1.c
> > > > @@ -3282,9 +3282,6 @@ static int raid1_reshape(struct mddev *mddev)
> > > >    	int d, d2;
> > > >    	int ret;
> > > > -	memset(&newpool, 0, sizeof(newpool));
> > > > -	memset(&oldpool, 0, sizeof(oldpool));
> > > > -
> > > >    	/* Cannot change chunk_size, layout, or level */
> > > >    	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
> > > >    	    mddev->layout != mddev->new_layout ||
> > > > @@ -3295,6 +3292,12 @@ static int raid1_reshape(struct mddev *mddev)
> > > >    		return -EINVAL;
> > > >    	}
> > > > +	if (mddev->delta_disks == 0)
> > > > +		return 0; /* nothing to do */
> 
> I think this is wrong, you should at least keep following:
> 
>         set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>         md_wakeup_thread(mddev->thread);
> 
I fail to comprehend the rationale behind the kernel's need to invoke 
raid1d() repeatedly despite the absence of any modifications.
It appears that raid1d() is responsible for invoking md_check_recovery() 
and resubmit the failed io.

Evidently, it is not within the scope of raid1_reshape() to resubmit
failed io.

Moreover, upon reviewing the Documentation[1], I could not find any
indications that reshape must undertake the actions as specified in
md_check_recovery()'s documentation, such as eliminating faulty devices.

[1]: https://www.kernel.org/doc/html/latest/admin-guide/md.html
> Thanks,
> Kuai
> 
> > > > +
> > > > +	memset(&newpool, 0, sizeof(newpool));
> > > > +	memset(&oldpool, 0, sizeof(oldpool));
> > > > +
> > > >    	if (!mddev_is_clustered(mddev))
> > > >    		md_allow_write(mddev);
> > .
> > 
> 
Thanks,
Hu
