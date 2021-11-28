Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CD3C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 28 Nov 2021 20:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352808AbhK1U0C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Nov 2021 15:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhK1UYB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Nov 2021 15:24:01 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ED2C061746
        for <linux-raid@vger.kernel.org>; Sun, 28 Nov 2021 12:20:45 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id j1so9578515vkr.1
        for <linux-raid@vger.kernel.org>; Sun, 28 Nov 2021 12:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=wK7RAY5cqY98Cfgxq+7iqQZC+Qd7nG111sBT4H9OR7s=;
        b=XurfQxN/U+LQafAluiGcSb2WQ7UYi/vZg1y777k4gnvh6+Sg6SXxUhwnQ7Yw9WvRlc
         hJQpzMTxOMpJR3eamNXTOzcw61GYwi4EVnaxZCL0+93WPGB0zNdXqPjHcaRDBdNZpiQT
         /nwpsg+mS7bc2nwXXT6AM1fun5SZ95q1tjVC0uKK2lsMIa9ZJI1vEOzBBndQRS7mFj/o
         dvUo5vvuUIMZ0U0XGb8fsXNjkqiDS7s7NZWid81Qj08DluVRsHfRRMKhABcwyQr11Xs2
         s0fkH/SmWGe4mE6LuKLKf7rQNJI9VVoKif/A64nz+Fpry9T/EonIyB5Lbazzbp9y8+R2
         ccAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=wK7RAY5cqY98Cfgxq+7iqQZC+Qd7nG111sBT4H9OR7s=;
        b=OhagRcfLp0Bo4gYe1PRtEq17msgbCB55JtWdxvAE1d76MchxQNwBxeI9W7FF4UL6Se
         pINrQipY7Yrr7zjuaSbMgslKUAnWRioW4uoOOUrYHvvLy3d4OkL/tFJmPQwXqOq+TEGC
         D6QTN+zeFstOLmARLa1rnne9g4iBM7noD3Np0YVlbVEnq3O34KzaXU6UM7zZ7kOWwBmu
         JDNGa+JYxFPEpRkGIVvPyhD2Ocs/jr3yxbWKrkTeuhRXnSsL8Rskba6Onp2w8wPG/WRv
         QBDGlrx5VmpvHnYRu1z/8Smo/TsKUufRiZSm/Ct52BA/omoHQWQJPAA7BB6pOLkWW1Qq
         CFjQ==
X-Gm-Message-State: AOAM531yhZ6y9r1F6fGVCESsjxHutxgFvKCAxTxlXRTCk5ZXCPlaqLF0
        AeAueZmF+mbJcBsG9ASEf8JoFAsRrXVEfqkliRlaH3i4YTo=
X-Google-Smtp-Source: ABdhPJznaeOcCW8P0h/Io38IujokuVP4ktla2bdTnBWPc0vIcsHaAhAcAN+SWR9YgVEXkljG0cgwCl8gapElTkDn6X0=
X-Received: by 2002:a1f:2849:: with SMTP id o70mr26523449vko.35.1638130844345;
 Sun, 28 Nov 2021 12:20:44 -0800 (PST)
MIME-Version: 1.0
From:   Edward Kuns <eddie.kuns@gmail.com>
Date:   Sun, 28 Nov 2021 14:20:33 -0600
Message-ID: <CACsGCySaG5ryZULOR=hCqyuFZEFJ3zpsv8WkFLi27_6X+L+USQ@mail.gmail.com>
Subject: I found how to enable the SCTERC equivalent on an NVMe drive
To:     Linux-RAID <linux-raid@vger.kernel.org>
Cc:     Edward Kuns <eddie.kuns@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I'm on RHEL 8.5.  I don't know how new this feature is, nor what
kernel is required for it to work.  However, this command gives the
following output after I've set TLER:

# for drive in /dev/nvme?n? ; do nvme get-feature $drive -f 5 -H ; done
get-feature:0x5 (Error Recovery), Current value:0x000046
Deallocated or Unwritten Logical Block Error Enable (DULBE): Disabled
Time Limited Error Recovery                          (TLER): 7000 ms
get-feature:0x5 (Error Recovery), Current value:0x000046
Deallocated or Unwritten Logical Block Error Enable (DULBE): Disabled
Time Limited Error Recovery                          (TLER): 7000 ms

"Feature 5" (-f 5) is TLER.  "-H" gives human-readable output.  The
nvme command doesn't seem to refer to features by any name, but just
by their hex ID.  The values before I set them were all 0.  I have
added this block to my /etc/rc.d/rc.local:

# Force NVMe SSDs to play nice with MD
for i in /dev/nvme?n? ; do
    if nvme set-feature  $i -f 5 -v 70 > /dev/null ; then
        echo -n $i " TLER successfully set "
    else
        echo -n $i " TLER NOT SET "
    fi
    smartctl -i $i | egrep "(Device Model|Product|Model Number):"
    # The default is 256 for my NVMe drives
    blockdev --setra 1024 $i
done

(NVMe devices don't seem to have an equivalent of
/sys/block/sda/device/timeout.)

Some of the nvme commands seem to allow permanent setting, but TLER at
least on my drives doesn't allow that.

My spinning hard drives and my non-NVMe SSDs have a default read-ahead
of 8192, so I commented out the blockdev command for those drives.  I
assume the goal of that command is to INCREASE the read-ahead?

Here are the versions of packages used:

# rpm -q nvme-cli kernel
nvme-cli-1.14-3.el8.x86_64
kernel-4.18.0-305.el8.x86_64
kernel-4.18.0-305.7.1.el8_4.x86_64
kernel-4.18.0-348.2.1.el8_5.x86_64

                        Eddie
