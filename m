Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35897E7D0AE
	for <linux-raid@archiver.kernel.org>; Thu, 21 Sep 2023 21:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjIUVw1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjIUVwM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Sep 2023 17:52:12 -0400
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193979010
        for <linux-raid@vger.kernel.org>; Thu, 21 Sep 2023 14:45:27 -0700 (PDT)
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6562330d68dso7586736d6.2
        for <linux-raid@vger.kernel.org>; Thu, 21 Sep 2023 14:45:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695332726; x=1695937526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgzNGTzTkPRkR0XMm81Mz7n51ssIigIV04M2unjen8M=;
        b=bFHK/eXBVsrnGLEaoM4h4BoC83sSZaqQGRzytbupv6c9MDo336XCqg6quGoI/uzzxc
         sV+zChqucbZzSvgky1P3Jij+RO7DdaC33/wKjwiiV5AidOB3o7iWNyust/KrpSgNcQC6
         Q++1HwEiy1121orxhAeVPWpuSpdWQ/aI4TqhwHWora4QRUIXcypKRQGa0UyV3iz+cOi1
         ev6gAsf5UxWmXJA//CRm0jSMOIyv1G8D3pw5OYY6VFQwFJwrnhSOGvrLcpqB13/WDM1o
         VA1jSg++lTfz+Hv9tmpZaZ3LXxsPvkZ2J3jz0As2Q5Rs/RL5ITsVTJgFjIHUVUBwa7dm
         mqQw==
X-Gm-Message-State: AOJu0YwoKSBs8zP5lvIGxslBMAwsS70TRN9eMgoKAc+4r5hEIIZfMGjf
        033VssjvW3PfggJH55AYO+uS
X-Google-Smtp-Source: AGHT+IEAJ1YG+6DyxdjHFvDbvTBrNOzDLMvzeb50IyfajoiVHlzIhioS9od5xLSKftza0uwpbddERg==
X-Received: by 2002:a0c:f548:0:b0:63c:fbd0:6361 with SMTP id p8-20020a0cf548000000b0063cfbd06361mr6110413qvm.37.1695332725726;
        Thu, 21 Sep 2023 14:45:25 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id n1-20020a0ce481000000b006588bd29c7esm905832qvl.28.2023.09.21.14.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 14:45:25 -0700 (PDT)
Date:   Thu, 21 Sep 2023 17:45:24 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Kirill Kirilenko <kirill@ultracoder.org>
Cc:     Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        heinzm@redhat.com, linux-raid@vger.kernel.org
Subject: Re: fstrim on raid1 LV with writemostly PV leads to system freeze
Message-ID: <ZQy5dClooWaZoS/N@redhat.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[cc'ing Heinz and the linux-raid mailing list]

On Thu, Sep 21 2023 at  4:34P -0400,
Kirill Kirilenko <kirill@ultracoder.org> wrote:

> Hello.
> 
> I created two LVM physical volumes: one on NVMe device and one on SATA SSD.
> I added them to a volume group and created a logical RAID1 volume in it.
> Then I enabled 'writemostly' flag on the second (slowest) PV.
> And my system started to freeze at random times with no messages in syslog.
> I was able to determine that the freezing was happening during execution of
> 'fstrim' (via systemd timer). I checked this by running 'fstrim' manually.
> If I disable the 'writemostly' flag, I experience no freezes. I can
> reproduce this behavior on vanilla 6.5.0 kernel.
> 
> My LV is 150 GB ext4 volume, and it has lots of files in it, so running
> 'fstrim' takes around a minute. This may be important.
> 
> Additional information:
> OS: Linux Mint 21.2
> CPU: AMD Ryzen 7 5800X
> NVMe: Samsung SSD 980 500GB
> SATA SSD: Samsung SSD 850 EVO M.2 250GB
> 
> Best regards,
> Kirill Kirilenko.
> 

I just verified that 6.5.0 does have this DM core fix (needed to
prevent excessive splitting of discard IO.. which could cause fstrim
to take longer for a DM device), but again 6.5.0 has this fix so it
isn't relevant:
be04c14a1bd2 dm: use op specific max_sectors when splitting abnormal io

Given your use of 'writemostly' I'm inferring you're using lvm2's
raid1 that uses MD raid1 code in terms of the dm-raid target.

Discards (more generic term for fstrim) are considered writes, so
writemostly really shouldn't matter... but I know that there have been
issues with MD's writemostly code (identified by others relatively
recently).

All said: hopefully someone more MD oriented can review your report
and help you further.

Mike
