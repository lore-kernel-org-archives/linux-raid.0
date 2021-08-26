Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF18C432BE
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 09:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 465F3610A4
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 09:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbhHZJTA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Aug 2021 05:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240674AbhHZJTA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Aug 2021 05:19:00 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5077C061757
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 02:18:12 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g22so3588162edy.12
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 02:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=NxIFcXSoVOVEmhqaw39jhy3woaDMKrzhvETmOAORp+g=;
        b=Z6qD/0dOlsI/bLgurebbVGbHTy70biO99LsYDPtjkGlSonm6Z1GQ0x2sVocBDRpuBq
         U4jfqJZJZrm3xFDe8AWRy/GXWRa6lByl6GJA0cuXTLepVvUpkEb56cXGsyKT/ti/+fSB
         IlK48k3/yqvfTsG97g7fW8kdN+ZNNZCC/+vU+ibCmUmet/ctnFcpmKtRbv9dtnoXvKLv
         WR458NA0HEA63OAKLaIOAFiPc+1DIJ3v7B+ikIWWBSo+913mF/76El7zeTJ/iQhr9PHn
         Be2aRuU86EE04+5DaTvEQNhImt7bnz/Tuja1XiFzZ0jeRtLsqnHeIB0mr1OL4yKgnJR9
         glHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=NxIFcXSoVOVEmhqaw39jhy3woaDMKrzhvETmOAORp+g=;
        b=id9vZh39ZVGhouZwomk/g9ELh9ozNz3eDxNhFOWVsuzyUKUkyi10k0aYzESYTCO/Y3
         U3IqW0LLMv/4kcLoP/MyS7VIdRZ7+y6EDJjKQjJuGcBtijZefbvavZ1jAT6Xtga6gNnV
         M/5sS9fjClv5ISPEjq3Ban89JMWZtpVPSiSeCEW9tlwOEYqAIwT75MOGl6SxYC4Hz18P
         KwTkzdXq0JuvPz5cjSkhLl/gMoGTSKiiWWQKyrgz/7roSK8tuIu0il++GinSrNw3jLA1
         SvMUiAU1y5YCb15FBQnWO/cRsozEYPe69b7yQTv09/89KxqSMWIxipuZPJZp2smywuTr
         LrzA==
X-Gm-Message-State: AOAM532fDL1vPAtb6V9h7J3lv62KjvzR2Vg99pDIzS2A+5sjyvVmwXGj
        CvSqjaUVLDbcqd5f1Gw2/SzkTNRlcpw=
X-Google-Smtp-Source: ABdhPJwFzRiFQMJiOH/c0nyr2kzLO4pUmLFK6h2T1Bl9fOUdPRuWcRrUT61D2dcKl7Jj7udpssxhhg==
X-Received: by 2002:aa7:ca04:: with SMTP id y4mr3306918eds.162.1629969490985;
        Thu, 26 Aug 2021 02:18:10 -0700 (PDT)
Received: from localhost (host-87-7-107-231.retail.telecomitalia.it. [87.7.107.231])
        by smtp.gmail.com with ESMTPSA id o15sm1049101ejj.10.2021.08.26.02.18.09
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 02:18:10 -0700 (PDT)
Date:   Thu, 26 Aug 2021 11:18:09 +0200
From:   Gennaro Oliva <gennaro.oliva@gmail.com>
To:     linux-raid@vger.kernel.org
Subject: Raid 5 where 2 disks out of 4 were unplugged
Message-ID: <YSdcUa6ZYsdPEtFB@ischia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,
I have a QNAP with Linux 3.4.6 and mdadm 3.3. I have 4 drives assembled
in raid 5, two of those drives where accidentally removed and now they
are out of sync. This is a partial output of mdadm --examine 

/dev/sda3:
    Update Time : Thu Jul  8 18:01:51 2021
       Checksum : 4bc8157c - correct
         Events : 469678
   Device Role : Active device 0
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb3:
    Update Time : Thu Jul  8 18:01:51 2021
       Checksum : 7fac997f - correct
         Events : 469678
   Device Role : Active device 1
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc3:
    Update Time : Thu Jul  8 13:15:58 2021
       Checksum : fcd5279f - correct
         Events : 469667
   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd3:
    Update Time : Thu Jul  8 13:15:58 2021
       Checksum : b9bc1e2e - correct
         Events : 469667
   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

The disk are all healthy. I tried to re-assemble the drive with
mdadm --verbose --assemble --force
using various combination of 3 drives or using all the four drives but
I'm always notified I have no enough drives to start the array.

This is the output when trying to use all the drives:

mdadm --verbose --assemble --force /dev/md1 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3            
mdadm: looking for devices for /dev/md1
mdadm: failed to get exclusive lock on mapfile - continue anyway...
mdadm: /dev/sda3 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdb3 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sdc3 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdd3 is identified as a member of /dev/md1, slot 3.
mdadm: added /dev/sdb3 to /dev/md1 as 1
mdadm: added /dev/sdc3 to /dev/md1 as 2 (possibly out of date)
mdadm: added /dev/sdd3 to /dev/md1 as 3 (possibly out of date)
mdadm: added /dev/sda3 to /dev/md1 as 0
mdadm: /dev/md1 assembled from 2 drives - not enough to start the array.

The number of events is really close (11). What is my next option to
recover the partition? Do I need to rebuild the superblock?
What options should I use?

Thank you for reading this e-mail.
Best regards,
-- 
Gennaro Oliva
