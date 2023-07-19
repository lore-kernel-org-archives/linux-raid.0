Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37973C0015E
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jul 2023 11:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjGSLvQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 07:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjGSLvP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 07:51:15 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98243D3
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 04:51:13 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b89d47ffb6so40167715ad.2
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 04:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1689767473; x=1690372273;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gQi75PF1xJ7IH5SSYclTXXw+hr8IDquwk0LGcnQyCKQ=;
        b=N5nG2xImy3lkn4JG6+n9hhn4YHygIXpyG/vA8w5hZxbIMyMHa5OQm+WuJetjzaGvt3
         rmmaHtzoUdTkQS3GhUfFISkqt4baXw9tCsSdq4SQ7jg5URbHReNTqMVdIsPed4fIfX/v
         My0CmMStAyZz9JIXwjw7BBJ14Bs16k+K5LjVSRPHA94889Agv1gp4wVmWPvuEPyVnpR1
         88zi2AZwj0eh8yu+2vf6WLjCmHUqR3bV7Zuiv3RUukhszNwbQ5o/U0tBB6qgIgHYe69L
         mJL7jCHQz4R/q8Y3vRRb7rKSkpm9L208Eio/ZUMcs2xvrl1i92uFb7X249DYET5EWs4O
         3wOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689767473; x=1690372273;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gQi75PF1xJ7IH5SSYclTXXw+hr8IDquwk0LGcnQyCKQ=;
        b=XQgKgn0RA2cjgczx5busq447x6c3HCq4M8gvVukWgzjH+wQnuHLKOGrAF63KJPzf1p
         Tfj7EaRm0yvdzx88hln5PIDCxaRzfJdyNWLSyIwATuwwSF8+Mgq4BKrYZ3U4rlpyGvb7
         shBzFQ2SYeFqaS3ufRlvBfkoPvlhSCI2WBdyaK+OCdcfCbyiRAtDKxjIuBQUFPmmB7rK
         4cnav57UGCU0guJ2Qgoy9ZxuTrbp2cnh08kgUuh2IbY1on4iyc6VBCkJDhX9g6PqHOEp
         Bqohz8ksZd9msPjEyG6VB0Bj4Y9KoK/2GnzDxcEZ7+wxDp3/fQPN++SUcd1c3fnyCBp9
         i7oA==
X-Gm-Message-State: ABy/qLatb6Z+Y3MplvC564lJl5v9Jp1BnQgIyjQScWlv6zlaBBIbVYsr
        fRLXTcn+S0t3zyrO5RrpFe4A9Q==
X-Google-Smtp-Source: APBJJlHXdF4EGoJQIAFyzFdP7SJ8EEUYNgTySSt6TVdzHj5IpcNX8NyX0JmVD0d1sr2Diqk1puvRcg==
X-Received: by 2002:a17:903:41d2:b0:1b8:ab0d:cd5 with SMTP id u18-20020a17090341d200b001b8ab0d0cd5mr16150002ple.49.1689767472766;
        Wed, 19 Jul 2023 04:51:12 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id iz9-20020a170902ef8900b001a1b66af22fsm3777954plb.62.2023.07.19.04.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 04:51:12 -0700 (PDT)
Date:   Wed, 19 Jul 2023 19:51:07 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
Message-ID: <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
 <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jul 19, 2023 at 09:38:26AM +0200, Paul Menzel wrote:
> Dear Xueshi,
> 
> 
> Thank you for your patches.
> 
> Am 19.07.23 um 09:09 schrieb Xueshi Hu:
> > If array size doesn't changed, nothing need to do.
> 
> Maybe: … nothing needs to be done.
What a hurry, I'll be cautious next time and check the sentences with
tools.
> 
> Do you have a test case to reproduce it?
> 
Userspace command:

	echo 4 > /sys/devices/virtual/block/md10/md/raid_disks

Kernel function calling flow:

md_attr_store()
	raid_disks_store()
		update_raid_disks()
			raid1_reshape()

Maybe I shall provide more information when submit patches, thank you for
reminding me.
> 
> Kind regards,
> 
> Paul
> 
> 
> > Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> > ---
> >   drivers/md/raid1.c | 9 ++++++---
> >   1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 62e86b7d1561..5840b8b0f9b7 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -3282,9 +3282,6 @@ static int raid1_reshape(struct mddev *mddev)
> >   	int d, d2;
> >   	int ret;
> > -	memset(&newpool, 0, sizeof(newpool));
> > -	memset(&oldpool, 0, sizeof(oldpool));
> > -
> >   	/* Cannot change chunk_size, layout, or level */
> >   	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
> >   	    mddev->layout != mddev->new_layout ||
> > @@ -3295,6 +3292,12 @@ static int raid1_reshape(struct mddev *mddev)
> >   		return -EINVAL;
> >   	}
> > +	if (mddev->delta_disks == 0)
> > +		return 0; /* nothing to do */
> > +
> > +	memset(&newpool, 0, sizeof(newpool));
> > +	memset(&oldpool, 0, sizeof(oldpool));
> > +
> >   	if (!mddev_is_clustered(mddev))
> >   		md_allow_write(mddev);
