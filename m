Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC92C432BE
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 05:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9457760232
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 05:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241375AbhIAFUM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Sep 2021 01:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhIAFUL (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 1 Sep 2021 01:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99DF360232
        for <linux-raid@vger.kernel.org>; Wed,  1 Sep 2021 05:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630473555;
        bh=PRhInH5lr2E28CGJlkeNPaF1vWkpDYyUIiXWg5oIrb8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GDUYOV6tsLwV0JVIKW+jGcc1zoE7dF3oRYVfngyW3UfDAK+L6jOtGs/vpLwrtT1ia
         h2VzgyVZDzV8XtuiDLhEuH48hMgGEu2J1wLj8ldZIJhkBaTURTGIfLML4yAYApVoNs
         n+OtUhLReGRhRL8i46J+e8tRfrjfJDhSVYK7RIXFR7QOvqYwN2RfpEbCTGvOGagPGW
         V9BATL1bBQt7m3Pp1wp5mbbhBwM9S1Q4+3jBJScUKXYDJFlq7TXo3Y8PQmWj8MClmf
         0bWtOKdp0cu9nPmwgT8NI2DIrI2+iol0O4Zjp4dLZkPj49Dyd/wKIY09c4NgqdTVFN
         +ape0qlkts3pw==
Received: by mail-wm1-f44.google.com with SMTP id m2so985102wmm.0
        for <linux-raid@vger.kernel.org>; Tue, 31 Aug 2021 22:19:15 -0700 (PDT)
X-Gm-Message-State: AOAM530HGJOpu/pDKRS2yz3+KWdW2H7NA3hckvibFkPy0FH1nX1gQBfs
        4SHLvk97W/uTv+MVrZsawLapr8B8SylCsqn2ZsQ=
X-Google-Smtp-Source: ABdhPJxLFcusLZANXO72Jqyzasry3OATVGaCPyZhEuCcMFoAzu+e7XJ/tS0f35RDBXKONRH1JZpCv/aitYj+THRgyfQ=
X-Received: by 2002:a1c:c913:: with SMTP id f19mr7561989wmb.86.1630473554086;
 Tue, 31 Aug 2021 22:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
 <CAFDAVzmjGYsdgx0Yyn3n8NWVpAZQqmhBSneZY9fagV5PGTrgGw@mail.gmail.com>
In-Reply-To: <CAFDAVzmjGYsdgx0Yyn3n8NWVpAZQqmhBSneZY9fagV5PGTrgGw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 31 Aug 2021 22:19:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW491s_6pEYRxHphgSAPVta=qPrsKXONvq03Xxv71BVx2g@mail.gmail.com>
Message-ID: <CAPhsuW491s_6pEYRxHphgSAPVta=qPrsKXONvq03Xxv71BVx2g@mail.gmail.com>
Subject: Re: Slow initial resync in RAID6 with 36 SAS drives
To:     Marcin Wanat <marcin.wanat@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 25, 2021 at 3:06 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
>
> On Thu, Aug 19, 2021 at 11:28 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
> >
> > Sorry, this will be a long email with everything I find to be relevant.
> > I have a mdraid6 array with 36 hdd SAS drives each able to do
> > >200MB/s, but I am unable to get more than 38MB/s resync speed on a
> > fast system (48cores/96GB ram) with no other load.
>
> I have done a bit more research on 24 NVMe drives server and found
> that resync speed bottleneck affect RAID6 with >16 drives:

Sorry for the late response.

This is interesting behavior. I don't really know why this is the case at the
moment. Let me try to reproduce this first.

Thanks,
Song

>
> # mdadm --create --verbose /dev/md0 --level=6 --raid-devices=16
> /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
> /dev/nvme6n1 /dev/nvme7n1 /dev/nvme8n1 /dev/nvme9n1 /dev/nvme10n1
> /dev/nvme11n1 /dev/nvme12n1 /dev/nvme13n1 /dev/nvme14n1 /dev/nvme15n1
> /dev/nvme16n1
> # iostat -dx 5
> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s
> %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1          0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme1n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.88    0.00   0.99   470.84     2.25   2.51  86.04
> nvme4n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.89    0.00   0.99   470.84     2.25   2.51  86.06
> nvme5n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.89    0.00   0.99   470.84     2.25   2.51  86.14
> nvme10n1       342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.90    0.00   0.99   470.84     2.25   2.51  86.20
> nvme9n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.91    0.00   1.00   470.84     2.25   2.53  86.76
> nvme13n1       342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.93    0.00   1.00   470.84     2.25   2.54  87.00
> nvme12n1       342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.94    0.00   1.01   470.84     2.25   2.54  87.08
> nvme8n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.93    0.00   1.00   470.84     2.25   2.54  87.02
> nvme14n1       342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.96    0.00   1.01   470.84     2.25   2.56  87.64
> nvme22n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme17n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme16n1       342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    3.05    0.00   1.04   470.84     2.25   2.58  88.56
> nvme19n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme2n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.94    0.00   1.01   470.84     2.25   2.54  87.20
> nvme6n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.95    0.00   1.01   470.84     2.25   2.55  87.52
> nvme7n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.94    0.00   1.01   470.84     2.25   2.54  87.22
> nvme21n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme11n1       342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.96    0.00   1.02   470.84     2.25   2.56  87.72
> nvme15n1       342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.99    0.00   1.02   470.84     2.25   2.53  86.84
> nvme23n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme18n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme3n1        342.60    0.40 161311.20      0.90 39996.60     0.00
> 99.15   0.00    2.97    0.00   1.02   470.84     2.25   2.53  86.66
> nvme20n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
>
> as you can see, there are 342 iops with ~470 rareq-sz, but when i
> create RAID6 with 17 drives or more:
>
> # mdadm --create --verbose /dev/md0 --level=6 --raid-devices=17
> /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
> /dev/nvme6n1 /dev/nvme7n1 /dev/nvme8n1 /dev/nvme9n1 /dev/nvme10n1
> /dev/nvme11n1 /dev/nvme12n1 /dev/nvme13n1 /dev/nvme14n1 /dev/nvme15n1
> /dev/nvme16n1 /dev/nvme17n1
> # iostat -dx 5
> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s
> %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1          0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme1n1       21484.20    0.40  85936.80      0.90     0.00     0.00
> 0.00   0.00    0.04    0.00   0.82     4.00     2.25   0.05  99.16
> nvme4n1       21484.00    0.40  85936.00      0.90     0.00     0.00
> 0.00   0.00    0.03    0.00   0.74     4.00     2.25   0.05  99.16
> nvme5n1       21484.00    0.40  85936.00      0.90     0.00     0.00
> 0.00   0.00    0.04    0.00   0.84     4.00     2.25   0.05  99.16
> nvme10n1      21483.80    0.40  85935.20      0.90     0.00     0.00
> 0.00   0.00    0.03    0.00   0.65     4.00     2.25   0.04  83.64
> nvme9n1       21483.80    0.40  85935.20      0.90     0.00     0.00
> 0.00   0.00    0.03    0.00   0.67     4.00     2.25   0.04  85.86
> nvme13n1      21483.60    0.40  85934.40      0.90     0.00     0.00
> 0.00   0.00    0.03    0.00   0.63     4.00     2.25   0.04  83.66
> nvme12n1      21483.60    0.40  85934.40      0.90     0.00     0.00
> 0.00   0.00    0.03    0.00   0.65     4.00     2.25   0.04  83.66
> nvme8n1       21483.60    0.40  85934.40      0.90     0.00     0.00
> 0.00   0.00    0.04    0.00   0.81     4.00     2.25   0.05  99.22
> nvme14n1      21481.80    0.40  85927.20      0.90     0.00     0.00
> 0.00   0.00    0.03    0.00   0.67     4.00     2.25   0.04  83.66
> nvme22n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme17n1      21482.00    0.40  85928.00      0.90     0.00     0.00
> 0.00   0.00    0.02    0.00   0.49     4.00     2.25   0.03  67.12
> nvme16n1      21481.60    0.40  85926.40      0.90     0.00     0.00
> 0.00   0.00    0.03    0.00   0.75     4.00     2.25   0.04  83.66
> nvme19n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme2n1       21481.60    0.40  85926.40      0.90     0.00     0.00
> 0.00   0.00    0.04    0.00   0.95     4.00     2.25   0.05  99.26
> nvme6n1       21481.60    0.40  85926.40      0.90     0.00     0.00
> 0.00   0.00    0.04    0.00   0.91     4.00     2.25   0.05  99.26
> nvme7n1       21481.60    0.40  85926.40      0.90     0.00     0.00
> 0.00   0.00    0.04    0.00   0.87     4.00     2.25   0.05  99.24
> nvme21n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme11n1      21481.20    0.40  85924.80      0.90     0.00     0.00
> 0.00   0.00    0.03    0.00   0.75     4.00     2.25   0.04  83.66
> nvme15n1      21480.20    0.40  85920.80      0.90     0.00     0.00
> 0.00   0.00    0.04    0.00   0.80     4.00     2.25   0.04  83.66
> nvme23n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme18n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
> nvme3n1       21480.40    0.40  85921.60      0.90     0.00     0.00
> 0.00   0.00    0.05    0.00   1.02     4.00     2.25   0.05  99.26
> nvme20n1         0.00    0.00      0.00      0.00     0.00     0.00
> 0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
>
> rareq-sz drops to 4, iops increase to 21483 and resync speed drops to 85MB/s.
>
> Why is it like that? Could someone let me know which part of mdraid
> kernel code is responsible for this limitation ? Is changing this and
> recompiling the kernel on machine with 512GB+ ram safe ?
>
> Regards,
> Marcin Wanat
