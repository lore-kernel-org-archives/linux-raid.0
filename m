Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37650C4332F
	for <linux-raid@archiver.kernel.org>; Thu, 13 Oct 2022 07:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJMHv3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Oct 2022 03:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJMHv2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Oct 2022 03:51:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BB768888
        for <linux-raid@vger.kernel.org>; Thu, 13 Oct 2022 00:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665647486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yAWP4bcWfxX91VgxzqYoNJ7nC6UkZzpQsQvg2NZ/hlc=;
        b=A1ntCr8LwtmS/7Ggpm+anMK6D0BPlgnRkJxBc85vH+GKGL7bB2WxEg/dfXfk7ndBi4IoX+
        kzcZnjyk4OZbH0E2lC3Jnz2zMLBc65D23D6juQ6v8bGKO1gouJXYF38SRRDOKHa1TKgZNU
        fQzata42Tpqz1ZGowA+sYBSTPB/ALmY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-210-y3qAuVfTNvePAszUAu9YNA-1; Thu, 13 Oct 2022 03:51:25 -0400
X-MC-Unique: y3qAuVfTNvePAszUAu9YNA-1
Received: by mail-pg1-f199.google.com with SMTP id y71-20020a638a4a000000b0046014b2258dso619899pgd.19
        for <linux-raid@vger.kernel.org>; Thu, 13 Oct 2022 00:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yAWP4bcWfxX91VgxzqYoNJ7nC6UkZzpQsQvg2NZ/hlc=;
        b=7OmBj88Fsd0/XQBRv5wVyDxbwCR4qzNMAzCw4OTt5qLESlcX/ymJ6irakJpewng9ZL
         TnB3vr3fFxyTWg9VSPIvh1tdxAOyREOYYUUs58E4Pjd1RgM7i86xFiDUWpGKf7RvuMuM
         LF/e0HjRDSrmD3QZE5e16v/3LtW5o5b/SAsylWDaHfCvkyIjfiQ7s4mgax1kt5XGuZLR
         tUTQ7yRTkGZFv8wv3gNuoMuRinU6xfbseGtaVUx8EuM79ZqnrZ2Yb1Z6r8YSBZAc1pBE
         DhRpR5CxI33Z3g45KWF7eRUy09KYVhg4BcMa/aXbuyLndeGPCkfEqqL9dEkgB1hNMy2m
         pkbg==
X-Gm-Message-State: ACrzQf1faqt8psMGINCt9ceG2VJGeTP0F0hsgMKdWVEKSEQmg4kID6Au
        wpwmWC/Da8y15WHQqWypRNvvBvllrSnTQ8CKqez2MCS6Hb0kmDXnR1In3DE2EkmXZRUM5ugWA+x
        DyRIeKigKxLyekYN4YEPwkFeKler4Ui4rg6q8DQ==
X-Received: by 2002:a17:902:da8a:b0:180:6f4f:beee with SMTP id j10-20020a170902da8a00b001806f4fbeeemr29855043plx.82.1665647484073;
        Thu, 13 Oct 2022 00:51:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7UHMyxkcPFxjY1mSFY5+PnowUpCFE+kUfkMGKcHQ+f3QvYHgQPvpSFLbLGaKLbNrKFtqRJXu0wSF5txj2am0A=
X-Received: by 2002:a17:902:da8a:b0:180:6f4f:beee with SMTP id
 j10-20020a170902da8a00b001806f4fbeeemr29855033plx.82.1665647483798; Thu, 13
 Oct 2022 00:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221007201037.20263-1-logang@deltatee.com> <CALTww28HQUPbB647oP9WKvkLX=9PqZv+9am-884zZVM923H-KA@mail.gmail.com>
 <8ee5368c-1808-d2bc-9ad2-2f8332d2704e@deltatee.com> <yq15ygo4jkv.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15ygo4jkv.fsf@ca-mkp.ca.oracle.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 13 Oct 2022 15:51:12 +0800
Message-ID: <CALTww28XKzYmKrVQn=yYyq3xpjcEDzz1Bao+eLx3LR5mbm333Q@mail.gmail.com>
Subject: Re: [PATCH mdadm v4 0/7] Write Zeroes option for Creating Arrays
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 13, 2022 at 9:34 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Logan,
>
> > 2) We could split up the fallocate call into multiple calls to zero
> > the entire disk. This would allow a quicker ctrl-c to occur, however
> > it's not clear what the best size would be to split it into. Even
> > zeroing 1GB can take a few seconds,
>
> FWIW, we default to 32MB per request in SCSI unless the device
> explicitly advertises wanting something larger.

Hi Martin

If the upper layer submit 1GB request, SCSI will split them and handle 32MB
requests in default. If the upper layer wants SCSI to handle 1GB one time, it
needs to pass some information to SCSI, right?

>
> > (with NVMe, discard only requires a single command to handle the
> > entire disk
>
> In NVMe there's a limit of 64K blocks per range and 256 ranges per
> request. So 8GB or 64GB per request for discard depending on the block
> size. So presumably it will take several operations to deallocate an
> entire drive.

Could you tell the command how to check the block size.
blockdev --getsz tells the sector size of the device. It should not be the
block size you mentioned here.

It looks like we can decide the best size once the blocksize is found.

Regards
Xiao

>
> > where as write-zeroes requires a minimum of one command per 2MB of
> > data to zero).
>
> 32MB for 512-byte blocks and 256MB for 4096-byte blocks. Which matches
> how it currently works for SCSI devices.
>
> > I was hoping write-zeroes could be made faster in the future, at least
> > for NVMe.
>
> Deallocate had a bit of a head start and vendors are still catching up
> in the zeroing department. Some drives do support using Deallocate for
> zeroing and we quirk those in the driver so they should perform OK with
> your change.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
>

