Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98562C38A2D
	for <linux-raid@archiver.kernel.org>; Thu, 27 Oct 2022 08:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiJ0IoV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Oct 2022 04:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiJ0IoT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Oct 2022 04:44:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D615D09A
        for <linux-raid@vger.kernel.org>; Thu, 27 Oct 2022 01:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666860258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DZm/LIvsghPLBMIPuv6JCPmWn6H+tGHz7qoBlvCV20U=;
        b=KC7/wifhFBEm81mGGrl97V8bDOeFNRfZmmgRL+8W3LSDetNFswTg93OY+Q1+snk8m6GYrB
        FvKBco7ACptkQZI1fxzL64bYk6IpGT8oRw+AV0AbRmEITfa3BUHcHLZ3gIKTYWnmsUGOIW
        XMBaW3wYuJSwNm52LdrlD64iTCbqOHI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-357-ZJRHIh4JOaerWBcfVRuzCw-1; Thu, 27 Oct 2022 04:44:14 -0400
X-MC-Unique: ZJRHIh4JOaerWBcfVRuzCw-1
Received: by mail-pg1-f198.google.com with SMTP id h19-20020a63e153000000b00434dfee8dbaso407250pgk.18
        for <linux-raid@vger.kernel.org>; Thu, 27 Oct 2022 01:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZm/LIvsghPLBMIPuv6JCPmWn6H+tGHz7qoBlvCV20U=;
        b=zjsD73wbt5HhSyhen6wrCumvsgWNgHZphBtyGjJh40sHnwOx1eySUUbTuEJ1DupZ19
         8nGXKVvVxfxcjDgsPrPYRB/X5v7jac/3cAU0aj5NRV9TIHDXgXyF4D9ZAtRKd2IRn4pz
         FUtrqe1vNICSd0k0MDav8uBSGuHYPuWL7bWSl2wwjyfF/lJ3F1WUCEgw1MI+s554YLv/
         p8hW8MwTMtyDdf2Z9wrEJvkMipe0Wfdqb71ab59JE+quzXQPSbqQojw9fGyeTxIIOrcd
         PsJgvJjbCEmVl6H8Tq1WOpKoZEPCe86sfeRHCYX3E50itmt3E60oHS+uTPoc0OjCbb29
         bdpA==
X-Gm-Message-State: ACrzQf25OxEg+HvY86tBGC6c7RpxT3iEYhH99TJLp2ZbvWL9cmGiby4E
        1AStadrlCSRZjnVvo3NWF/HlOIbN2kMRhPu8XwLO/xmrRPiBuWkwpGnxdwmaES8m5oJdLmJygFi
        eUJmzTBGIwE8wzSsnvtHZFFBPUSJjcLi72GYQlQ==
X-Received: by 2002:a17:902:da92:b0:186:611a:baa with SMTP id j18-20020a170902da9200b00186611a0baamr38511054plx.15.1666860253433;
        Thu, 27 Oct 2022 01:44:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7J8MOJHkQdffGBsdIlpucTbUjPCQONEQh3BlUS+SPPWb5GW2VeoiEdB251cTaxtc7ROkIbyERMcKcQHxX6jWo=
X-Received: by 2002:a17:902:da92:b0:186:611a:baa with SMTP id
 j18-20020a170902da9200b00186611a0baamr38511035plx.15.1666860253157; Thu, 27
 Oct 2022 01:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221007201037.20263-1-logang@deltatee.com> <CALTww28HQUPbB647oP9WKvkLX=9PqZv+9am-884zZVM923H-KA@mail.gmail.com>
 <8ee5368c-1808-d2bc-9ad2-2f8332d2704e@deltatee.com> <yq15ygo4jkv.fsf@ca-mkp.ca.oracle.com>
 <CALTww28XKzYmKrVQn=yYyq3xpjcEDzz1Bao+eLx3LR5mbm333Q@mail.gmail.com> <yq1tu3rtio1.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1tu3rtio1.fsf@ca-mkp.ca.oracle.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 27 Oct 2022 16:44:02 +0800
Message-ID: <CALTww28jqtYAzQfoCzD2L=B76J1Ld7jSRrF_Q0W_rRDCUM2BNQ@mail.gmail.com>
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

On Wed, Oct 26, 2022 at 10:42 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Xiao,
>
> > If the upper layer submit 1GB request, SCSI will split them and handle
> > 32MB requests in default. If the upper layer wants SCSI to handle 1GB
> > one time, it needs to pass some information to SCSI, right?
>
> It is the device that defines its capabilities, not Linux. If the device
> states it wants 32MB per request, then that's what we'll issue.
>
> >> In NVMe there's a limit of 64K blocks per range and 256 ranges per
> >> request. So 8GB or 64GB per request for discard depending on the block
> >> size. So presumably it will take several operations to deallocate an
> >> entire drive.
> >
> > Could you tell the command how to check the block size.
> > blockdev --getsz tells the sector size of the device. It should not be the
> > block size you mentioned here.
>
> blockdev --getss will tell you the device's logical block size.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
>

Hi Martin

Thanks for all the explanations :)

Regards
Xiao

