Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54843ECAAA1
	for <linux-raid@archiver.kernel.org>; Sun, 11 Sep 2022 09:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiIKJIh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Sep 2022 05:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiIKJIg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 11 Sep 2022 05:08:36 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76813A171
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 02:08:35 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id z23so7235544ljk.1
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 02:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=L0diiU3b+QpuNpgkyw2w1F961JsLaTWAJLSKlcLX4Fg=;
        b=SYAeVsqZ4Xbv4qFk/07A+F9Qe/EtrDJ8yxydGNXenAZHhmJsqsMgaHdyP15vj542zz
         tj9A5brw76DV3NLjpHWFEzFp+8nEPSmnA9EBikIkXlOUjY5dfr0vuU4yRZ+C2jKdNuGI
         hUhcpgpgcX/KqnVoGSYnS8NIcki7Qm8BVf7v+7XBCyYdpmCnQFw6LoJnNkht0lOM4kQb
         g/U0l39FLmzz8tRKgRTqWvBuyt3LjbFp1e2gFYsyWzzpTHboAmsgUXc3ZEcpVzYKR5jy
         Ts+Lh3+UOS51+/UylWxiF7yhq0rFdg4gvsB5M3FgcyY9TxdEWdtFlgH2wZbLX9RsjTIi
         HEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=L0diiU3b+QpuNpgkyw2w1F961JsLaTWAJLSKlcLX4Fg=;
        b=jnvFcrg/4IXGjv40uEQ/+9ApKshGWkWYrkGvmRrYWPnP75GVVdxOXbNV0PpHD1iO5n
         KZkVYH++30LGT0aXtn0qUrYSam6U+8ZUeaVG8FHh4iBLGwZAQLZl6YGjZD6GWJUJLLxq
         hSjt3ZfcmUR9eZUw/E2bAU9czXyDQxNrp/EZQ1j0blzTf+7YKLbhj1DUuDY/cier1nLD
         BO+9drbjTabCE5hnSEhPL6QxE568Cqyfyr1AAtI/wLc60VeHuN+ElQjqexKI0JoLwh/i
         vvlXC/s9wfJdb+67dsXOmUj9GuXfAIEYE2Au0bjY3Zf4OXMbJnzhbvUvV7wOcrnIAuT1
         I/4w==
X-Gm-Message-State: ACgBeo3N8kWmu4Id3BSQ8yMWUtIhR7ZpOEMXE7mrk5JB+0N+YgTXSUCa
        DjEl0arK4otAtIY74kH66T+7K9Eqyk/KuLwuVxNGA24Hre4=
X-Google-Smtp-Source: AA6agR6dpUM2S2cUR4O6bDuW0PSLMJBagxzI1UTwbYULyHrK71aUBcA+M7EcOUuzvHLi1XzmBDrH7wJQfNn6eoLOxu0=
X-Received: by 2002:a2e:a550:0:b0:25f:9ae6:e40f with SMTP id
 e16-20020a2ea550000000b0025f9ae6e40fmr6466642ljn.408.1662887313283; Sun, 11
 Sep 2022 02:08:33 -0700 (PDT)
MIME-Version: 1.0
From:   Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date:   Sun, 11 Sep 2022 11:08:21 +0200
Message-ID: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
Subject: 3 way mirror
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

let's assume a 3 way mirror (raid1 with 3 disks)
One disk got a bad sector detrcted by smartd
what happens trying to read or write to that sector?

is md smart enough to read from the other 2 disks and serve consistant data?

in other words, can i delay the disk replacement for a couple of days
(i've ordered the disk today, will came tuesday) ?
