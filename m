Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40652C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 31 Mar 2022 16:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbiCaQqv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 12:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiCaQqs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 12:46:48 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C252220D3
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 09:45:01 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id u103so418854ybi.9
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 09:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=eq5mUkqq+u7STO0q44qt8geB/trRQJMwAK8INJLVuts=;
        b=BhjJUQcdbcMKneVb+cMOnY0qgCczTVBkX+tBUmhYS742lPcJlUG7hCg6/JvX+V0MEn
         e/s9VgljXTxsgydicstPK14G9vqfSfHOHTZd+jGSEDOvO90dNezwkH08n0sizuoQCSlA
         /blb9zCyOgmKC2UqvrSnqWgG9P/BC5Ysk6XkOAn2Mrma3Y6voS75Rh/jCdAqz3q3jGyI
         74P9mdHvrzwtHzVVewd3K6ek5LlL1K2MZ39jbJdBAppZ6EigFC+i1w8b5n4nexnw7bej
         BDLGM2wX3/h5VEjvWnY1qxYEO4o/EUhyZM3z52S3Zz8eYRVWNrOSWSKCdhH5cxS8NDJw
         Pp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=eq5mUkqq+u7STO0q44qt8geB/trRQJMwAK8INJLVuts=;
        b=yOP6oXgmBB+jxY0UBIusc3kI68YD2x0iG/NNoX4rb5ARDGXwDgVO6eZtFtcE3piFiW
         A4zsAljUqBgUl/GZJ7sT7xA64GrK0rCvYOqQKWlIounA4aNIEp+wvceacHirwiMfb0u2
         uHm27RllKpg/KAn0/ZOAe3AHZCliCWGKgxrLbP4VH4yCT1S1xdg7rqcPhRgQf1mCiLti
         prHhntRWPxox6vivrQ01iwlH2YGVsqfnp1BeYnT200cCmOeiv+dzeNfwQRdi7YuzgyH2
         v7SHKurF3WN+JFRd+e6TfxySWfrQOU/LzyOfR/OuWch7UjF/qgIT8wfTR2n/JCTzeRyQ
         iZsA==
X-Gm-Message-State: AOAM532Kt5X1BS6QYG1+XNlQHFum9JK1hxcaKh3Y7F9WmR4Ll65tJ7ju
        VVvT1LMMspEJo1/pI33fau0cW9CX4bVI/lzfEfIWyl6U
X-Google-Smtp-Source: ABdhPJzcd7JzpVL2TscWFC2i5BS92SOYH0b/JFgCWG+3h5metF79IV9lO70scCFnUkfChniZxxGcWL4U+btMW0IL0ms=
X-Received: by 2002:a25:910b:0:b0:633:b85d:28c9 with SMTP id
 v11-20020a25910b000000b00633b85d28c9mr4520047ybl.610.1648745100792; Thu, 31
 Mar 2022 09:45:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: bruce.korb+reply@gmail.com
From:   Bruce Korb <bruce.korb@gmail.com>
Date:   Thu, 31 Mar 2022 09:44:25 -0700
Message-ID: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
Subject: Trying to rescue a RAID-1 array
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I moved the two disks from a cleanly shut down system that could not
reboot and could not
be upgraded to a new OS release. So, I put them in.a new box and did an install.
The installation recognized them as a RAID and decided that the
partitions needed a
new superblock of type RAID-0. Since these data have never been
remounted since the
shutdown on the original machine, I am hoping I can change the RAID
type and mount it
so as to recover my. .ssh and .thunderbird (email) directories. The
bulk of the data are
backed up (assuming no issues with the full backup of my critical
data), but rebuilding
and redistributing the .ssh directory would be a particular nuisance.

SO: what are my options? I can't find any advice on how to tell mdadm
that the RAID-0 partitions
really are RAID-1 partitions. Last gasp might be to "mdadm --create"
the RAID-1 again, but there's
a lot of advice out there saying that it really is the last gasp
before giving up. :)

Thank you!

 - Bruce
