Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D20DEB64DD
	for <linux-raid@archiver.kernel.org>; Sun, 16 Jul 2023 22:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjGPWRt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 16 Jul 2023 18:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjGPWRs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 16 Jul 2023 18:17:48 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C8B1A2
        for <linux-raid@vger.kernel.org>; Sun, 16 Jul 2023 15:17:47 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1b441dd19eeso3076684fac.1
        for <linux-raid@vger.kernel.org>; Sun, 16 Jul 2023 15:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689545867; x=1692137867;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LbloSl5BB2zrXzAAEpJ+DjipIGVNlYxWl6WG4myi8b0=;
        b=eA60a89bG6+i8VvGoHN7E3RMDQZQtF+eZT+68S2U3E9XLUwiplNfd4IjaFH09MqAUn
         itSWHBCcxkLYrMqlopoYU4ZMkbK0sbrjbU4IOmKmzziHV18rZwcx5xAeqPK9VKOjvR3d
         Hc44AB+NZtsf4eHV8FZz7vPZZ8AMule5RNKxIh4P7K6t9G+T08H7pwjGcFi1L2lg7ba6
         tAnee8Zao1ifAUdri0jjv+cG9dn4mH1jFGjDhoR+kzlIEOG/n27/4vNqF7h2jNWmDijZ
         pGCjYa2btcLFgBjVlBRKStU+eJGZt2RPZRbFhC3TiDO5ZTCh3iJ0sfgAjaNZqJ5lZAWY
         5tdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689545867; x=1692137867;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LbloSl5BB2zrXzAAEpJ+DjipIGVNlYxWl6WG4myi8b0=;
        b=B5BD0fkFglzBnnHkessGb0scgvLRJlvCB4Ou1cfLItDTt3CX7ojyar7MiDxpa6I/mj
         sCU89m93756h/hWLrj8E9RPZEiSgu7r/sxWRsaFkq2sQVXQtoKyQzB4c3snevIeIuYAS
         yioefuKqPpq3ard2KariE1S7FwBf/7iCAeJ9HSWIug3URh3RaYSSMotWiiKX/otSidsb
         AUM+6UkiSnQTvJ1El5KJeW2guWnS6J2sze3aCZzzOtedYN/1T2s0DmQatM/lvfU4e7CJ
         NV+j3yhnbc8vh48TACUTmlzyFhphar69DynHhEovcynQ7IguZe34CH6FFxuFXXhajLio
         Dasw==
X-Gm-Message-State: ABy/qLb3ORP+VWvOxJNE5L9KNadRj1foH+vqoTwS3LqqcQM2I81mwYEd
        T2iHL5levFEyLMDss+Kuv6GgKXcvHL2s4TWzAlHl4oITY402Kw==
X-Google-Smtp-Source: APBJJlG4pz/boklib1SQFL5E4rS+YCzgLJSV+jv+5ymqO6/QSobSHya2j3yUMO2DZMRGBnh6dpejZu+NmS+AoAPutTg=
X-Received: by 2002:a05:6870:249a:b0:1b0:5218:cf07 with SMTP id
 s26-20020a056870249a00b001b05218cf07mr12986723oaq.5.1689545866605; Sun, 16
 Jul 2023 15:17:46 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Fran=C3=A7ois_RONVAUX?= <francois.ronvaux@gmail.com>
Date:   Mon, 17 Jul 2023 00:17:37 +0200
Message-ID: <CAMbPAZ4aKP_oXm8DgO03JTfDuqKWeTMBQSnwU5AdvVBUTa1prQ@mail.gmail.com>
Subject: Option --write-journal
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,


I'm going to create a RAID6 (6+2) array with 12TB HDDs Seagate IronWolf.

My system is installed on a SSD Samsung 970 EVO Plus NVMe with a
capacity of 250GB.

According to the spec [1], the SSD has a write endurance of 150TB and
as there is free capacity on the device, I plan to create a new
partition and to place the write journal of the RAID array on it.

About the usage of the array, it will be used to store video and audio
files for long term storage, the I/Os will be mainly sequential and
quite large (MB or hundreds of KB) and I will be the only user
accessing to the array. No virtual machines, databases, etc.
The file system will be ext4.

The man page says "The journal device should be an SSD with a
reasonable lifetime." I think to be good on the lifetime for my use
case.

But I do not know what is the required capacity for the journal.
Can someone give me some clues about this ?

All the config files of the system will be backed up so I will be able
to reinstall it easly (and re-assemble the RAID array) but the journal
can not be backed up.
So in case of failure of the journal (bad sectors on the SSD or
complete SSD failure), what are the risks on the integrity of the RAID
Array ?


[1] https://www.samsung.com/us/computing/memory-storage/solid-state-drives/ssd-970-evo-plus-nvme-m-2-250gb-mz-v7s250b-am/#specs


Thanks for your guidance.
