Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA60EB64DD
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 03:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbjG2DaC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Jul 2023 23:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjG2DaB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Jul 2023 23:30:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12D9449F
        for <linux-raid@vger.kernel.org>; Fri, 28 Jul 2023 20:29:59 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d2e1a72fcca58-686f0d66652so2533899b3a.2
        for <linux-raid@vger.kernel.org>; Fri, 28 Jul 2023 20:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1690601399; x=1691206199;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nSVRAH8u9ql1gpaJsqHsG1D7GKfQ6V1klpv0Gngy1z4=;
        b=akEGr6MtNqIBB5ytr0etnl1HzN4yWlJvoaefYEI1LKfK3s+EteAlz3WtKLU8ZM4oWK
         LsxB8uwf4OhZhc7OR4a/0khQl1RZPiJjd8xqU1hWS38JOv2sVVPEp0qoXhpg284V8xAq
         JQLqX3qhTrSaMpCGjtYPY1o3LBXKcS+BYcg4mk1L9/mrOYEvnbKVsve55l4RpY+zW9gY
         pMsr5CHun/Wa8NoTyWoaudqphLlzTEdDrEGOGwblTCRel1nHbTYmzLaTqs6fzsHkSObt
         rPmEIXrnl6g0bWq8lkPNcRhIq0noDy90fBvwYr/zRBOv565rCNgGd0bpUd+B3Lhk2X7y
         YS1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690601399; x=1691206199;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nSVRAH8u9ql1gpaJsqHsG1D7GKfQ6V1klpv0Gngy1z4=;
        b=ILMcCSb7n94d3Vj7l7282lC3W2+M186tIbsawnCTMTabiE/g88/4lT0vReJDLo39/b
         DU6RP1VZ26PxQir2n9Hwz4vm1t4ZICs6NqQ54+ZMhWoVmBps39FpC32jqQF3rVrHGbV2
         PsfqFndQUTsUS3CRVAljra0ApHb+8PHVkyo3wVAl51Wa6/uJaYT7+z9PeUthhUc6An+A
         tqICcvPIu0Q0TZkDRsf7tnRvZU9jozlWDh0MxEDDGveZ3XwboJ4zet8PS7BFDbv55DeI
         yLj8iC6debC98XS/St7GBJd+G0ZJShWYiQbuROOGwre0Aff9dNbjGgmkWpLAmdjbNx7f
         b67A==
X-Gm-Message-State: ABy/qLa0Rrje4dHS6PZzKgQBQfWG2TmattkoXZpQwnf9C8qt+UzXsFDg
        +1LYFzMYVvueGkxjoaBxFB5ZQoklZRSZKszTSOXI9n5Lbx35CA==
X-Google-Smtp-Source: APBJJlHLgRQcA9X73IHY2J+gSQA9kB0XQI7RiPT3EZLExQ8TB06+5aeP/108qNcpP6lCoKeCaIHY/A==
X-Received: by 2002:a05:6a20:9696:b0:138:834:5dc7 with SMTP id hp22-20020a056a20969600b0013808345dc7mr3247797pzc.30.1690601399276;
        Fri, 28 Jul 2023 20:29:59 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id b23-20020a639317000000b0055adced9e13sm4251833pge.0.2023.07.28.20.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 20:29:58 -0700 (PDT)
Date:   Sat, 29 Jul 2023 11:29:53 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
Message-ID: <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
 <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
 <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
 <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
 <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
 <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jul 29, 2023 at 08:58:45AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/28 22:42, Xueshi Hu 写道:
> > On Thu, Jul 20, 2023 at 09:28:34AM +0800, Yu Kuai wrote:
> > > Hi,
> > > 
> > > 在 2023/07/19 19:51, Xueshi Hu 写道:
> > > > On Wed, Jul 19, 2023 at 09:38:26AM +0200, Paul Menzel wrote:
> > > > > Dear Xueshi,
> > > > > 
> > > > > 
> > > > > Thank you for your patches.
> > > > > 
> > > > > Am 19.07.23 um 09:09 schrieb Xueshi Hu:
> > > > > > If array size doesn't changed, nothing need to do.
> > > > > 
> > > > > Maybe: … nothing needs to be done.
> > > > What a hurry, I'll be cautious next time and check the sentences with
> > > > tools.
> > > > > 
> > > > > Do you have a test case to reproduce it?
> > > > > 
> > > > Userspace command:
> > > > 
> > > > 	echo 4 > /sys/devices/virtual/block/md10/md/raid_disks
> > > > 
> > > > Kernel function calling flow:
> > > > 
> > > > md_attr_store()
> > > > 	raid_disks_store()
> > > > 		update_raid_disks()
> > > > 			raid1_reshape()
> > > > 
> > > > Maybe I shall provide more information when submit patches, thank you for
> > > > reminding me.
> > > > > 
> > > > > Kind regards,
> > > > > 
> > > > > Paul
> > > > > 
> > > > > 
> > > > > > Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> > > > > > ---
> > > > > >     drivers/md/raid1.c | 9 ++++++---
> > > > > >     1 file changed, 6 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > > > > > index 62e86b7d1561..5840b8b0f9b7 100644
> > > > > > --- a/drivers/md/raid1.c
> > > > > > +++ b/drivers/md/raid1.c
> > > > > > @@ -3282,9 +3282,6 @@ static int raid1_reshape(struct mddev *mddev)
> > > > > >     	int d, d2;
> > > > > >     	int ret;
> > > > > > -	memset(&newpool, 0, sizeof(newpool));
> > > > > > -	memset(&oldpool, 0, sizeof(oldpool));
> > > > > > -
> > > > > >     	/* Cannot change chunk_size, layout, or level */
> > > > > >     	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
> > > > > >     	    mddev->layout != mddev->new_layout ||
> > > > > > @@ -3295,6 +3292,12 @@ static int raid1_reshape(struct mddev *mddev)
> > > > > >     		return -EINVAL;
> > > > > >     	}
> > > > > > +	if (mddev->delta_disks == 0)
> > > > > > +		return 0; /* nothing to do */
> > > 
> > > I think this is wrong, you should at least keep following:
> > > 
> > >          set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> > >          set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > >          md_wakeup_thread(mddev->thread);
> > > 
> > I fail to comprehend the rationale behind the kernel's need to invoke
> > raid1d() repeatedly despite the absence of any modifications.
> > It appears that raid1d() is responsible for invoking md_check_recovery()
> > and resubmit the failed io.
> 
> No, the point here is to set MD_RECOVERY_NEEDED and MD_RECOVERY_RECOVER,
> so that md_check_recovery() can start to reshape.
I apologize, but I am still unable to comprehend your idea.
If mmdev->delta_disks == 0 , what is the purpose of invoking
md_check_recovery() again?
> 
> Thanks,
> Kuai
> > 
> > Evidently, it is not within the scope of raid1_reshape() to resubmit
> > failed io.
> > 
> > Moreover, upon reviewing the Documentation[1], I could not find any
> > indications that reshape must undertake the actions as specified in
> > md_check_recovery()'s documentation, such as eliminating faulty devices.
> > 
> > [1]: https://www.kernel.org/doc/html/latest/admin-guide/md.html
> > > Thanks,
> > > Kuai
> > > 
> > > > > > +
> > > > > > +	memset(&newpool, 0, sizeof(newpool));
> > > > > > +	memset(&oldpool, 0, sizeof(oldpool));
> > > > > > +
> > > > > >     	if (!mddev_is_clustered(mddev))
> > > > > >     		md_allow_write(mddev);
> > > > .
> > > > 
> > > 
> > Thanks,
> > Hu
> > .
> > 
> 
