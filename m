Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010E5C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 10:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE65060E76
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 10:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhHYKHI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Aug 2021 06:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhHYKHH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Aug 2021 06:07:07 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD41C061757
        for <linux-raid@vger.kernel.org>; Wed, 25 Aug 2021 03:06:21 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id x140so12464277ybe.0
        for <linux-raid@vger.kernel.org>; Wed, 25 Aug 2021 03:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=hcv/6t+ly7Js3Th/C75RCEMe3xplvmdZV5EmuT0whFI=;
        b=tXrHKFJnLnY/nhbbEYOf+yPrkgKBWtTwoJpyPbVTXTT7iGOTkmXpJzdIyvfgVRFtZZ
         YZZDehi/Xpqpw93NKc/BttjH24aOLZawK03/dc5n0Ptjcjbbf0lbdgVk7Xy2N5DlxdLK
         GQ4vR+UnZcWJ1KEcaCbSXkhi1Ch2n4LnEH6YzG/NM2bOpiX0RlwsXNwTWxop5vnqr4VD
         lw/QfkppYBxrUtWc8mANywI2hvn0YrKW+B1Vmw5g6H3HU4DO9OBYF3uvLDMNjl94dAff
         nk31FDkUQGALPwG70E/SyAjC4n6NOh5Xzc8Ko1OwXX2/hfPKDvr5ARGcv+WscqNmu/CF
         PyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=hcv/6t+ly7Js3Th/C75RCEMe3xplvmdZV5EmuT0whFI=;
        b=Bx1kKmFqWd8t4gjL4e1xmWbiIvX/essyXZrpZ9lrXK7w69tp+2Ih+KkV+Epcrj/s/a
         u+19AcQ8g4TRFzu60HSHtotdyS24FqbJ6SOv3oo8JtrxepN3M72PZborCrHu23fW9TD7
         3jPAzXPnmR3KX2p24aXFQHBiUmzfZazuUnzkpmFSpCjDN2LQqj3Y+0irbXhFDMGUZ6a/
         Rz+XKcFl1C8rgcLeq5UQiIQaQqmITSU724iYLrbgANXeyJeTwMDF6b8rLZf+A8wmmVJ+
         9LtVWmkpWUeiGDPGEA7PJh4CGqCAm78JQ4qmXTMI/H6T8KYYe0HL8UmK1J6WNr/3vWmO
         KJqA==
X-Gm-Message-State: AOAM530VpNFSrkvrqKOmeiEKOGI3PecY99IzPyikAJkRINHEvRwsdCaM
        pjHOyNNxBJFAJQrm/hj5gocIPVjvlDvFXtDAWWLIKdeHj3s=
X-Google-Smtp-Source: ABdhPJyiEqdbcOSndG6vxY5F58n8G2AfHhVuiQHAJ6JqY3oY6N+xq1HFQAzPU9Oou9cnh6Jfc9p50uvIdoKK5TkVc9U=
X-Received: by 2002:a25:7285:: with SMTP id n127mr40169248ybc.439.1629885980749;
 Wed, 25 Aug 2021 03:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
In-Reply-To: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
From:   Marcin Wanat <marcin.wanat@gmail.com>
Date:   Wed, 25 Aug 2021 12:06:09 +0200
Message-ID: <CAFDAVzmjGYsdgx0Yyn3n8NWVpAZQqmhBSneZY9fagV5PGTrgGw@mail.gmail.com>
Subject: Re: Slow initial resync in RAID6 with 36 SAS drives
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 19, 2021 at 11:28 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
>
> Sorry, this will be a long email with everything I find to be relevant.
> I have a mdraid6 array with 36 hdd SAS drives each able to do
> >200MB/s, but I am unable to get more than 38MB/s resync speed on a
> fast system (48cores/96GB ram) with no other load.

I have done a bit more research on 24 NVMe drives server and found
that resync speed bottleneck affect RAID6 with >16 drives:

# mdadm --create --verbose /dev/md0 --level=6 --raid-devices=16
/dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
/dev/nvme6n1 /dev/nvme7n1 /dev/nvme8n1 /dev/nvme9n1 /dev/nvme10n1
/dev/nvme11n1 /dev/nvme12n1 /dev/nvme13n1 /dev/nvme14n1 /dev/nvme15n1
/dev/nvme16n1
# iostat -dx 5
Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1          0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme1n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.88    0.00   0.99   470.84     2.25   2.51  86.04
nvme4n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.89    0.00   0.99   470.84     2.25   2.51  86.06
nvme5n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.89    0.00   0.99   470.84     2.25   2.51  86.14
nvme10n1       342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.90    0.00   0.99   470.84     2.25   2.51  86.20
nvme9n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.91    0.00   1.00   470.84     2.25   2.53  86.76
nvme13n1       342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.93    0.00   1.00   470.84     2.25   2.54  87.00
nvme12n1       342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.94    0.00   1.01   470.84     2.25   2.54  87.08
nvme8n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.93    0.00   1.00   470.84     2.25   2.54  87.02
nvme14n1       342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.96    0.00   1.01   470.84     2.25   2.56  87.64
nvme22n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme17n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme16n1       342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    3.05    0.00   1.04   470.84     2.25   2.58  88.56
nvme19n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme2n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.94    0.00   1.01   470.84     2.25   2.54  87.20
nvme6n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.95    0.00   1.01   470.84     2.25   2.55  87.52
nvme7n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.94    0.00   1.01   470.84     2.25   2.54  87.22
nvme21n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme11n1       342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.96    0.00   1.02   470.84     2.25   2.56  87.72
nvme15n1       342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.99    0.00   1.02   470.84     2.25   2.53  86.84
nvme23n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme18n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme3n1        342.60    0.40 161311.20      0.90 39996.60     0.00
99.15   0.00    2.97    0.00   1.02   470.84     2.25   2.53  86.66
nvme20n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00

as you can see, there are 342 iops with ~470 rareq-sz, but when i
create RAID6 with 17 drives or more:

# mdadm --create --verbose /dev/md0 --level=6 --raid-devices=17
/dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
/dev/nvme6n1 /dev/nvme7n1 /dev/nvme8n1 /dev/nvme9n1 /dev/nvme10n1
/dev/nvme11n1 /dev/nvme12n1 /dev/nvme13n1 /dev/nvme14n1 /dev/nvme15n1
/dev/nvme16n1 /dev/nvme17n1
# iostat -dx 5
Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1          0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme1n1       21484.20    0.40  85936.80      0.90     0.00     0.00
0.00   0.00    0.04    0.00   0.82     4.00     2.25   0.05  99.16
nvme4n1       21484.00    0.40  85936.00      0.90     0.00     0.00
0.00   0.00    0.03    0.00   0.74     4.00     2.25   0.05  99.16
nvme5n1       21484.00    0.40  85936.00      0.90     0.00     0.00
0.00   0.00    0.04    0.00   0.84     4.00     2.25   0.05  99.16
nvme10n1      21483.80    0.40  85935.20      0.90     0.00     0.00
0.00   0.00    0.03    0.00   0.65     4.00     2.25   0.04  83.64
nvme9n1       21483.80    0.40  85935.20      0.90     0.00     0.00
0.00   0.00    0.03    0.00   0.67     4.00     2.25   0.04  85.86
nvme13n1      21483.60    0.40  85934.40      0.90     0.00     0.00
0.00   0.00    0.03    0.00   0.63     4.00     2.25   0.04  83.66
nvme12n1      21483.60    0.40  85934.40      0.90     0.00     0.00
0.00   0.00    0.03    0.00   0.65     4.00     2.25   0.04  83.66
nvme8n1       21483.60    0.40  85934.40      0.90     0.00     0.00
0.00   0.00    0.04    0.00   0.81     4.00     2.25   0.05  99.22
nvme14n1      21481.80    0.40  85927.20      0.90     0.00     0.00
0.00   0.00    0.03    0.00   0.67     4.00     2.25   0.04  83.66
nvme22n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme17n1      21482.00    0.40  85928.00      0.90     0.00     0.00
0.00   0.00    0.02    0.00   0.49     4.00     2.25   0.03  67.12
nvme16n1      21481.60    0.40  85926.40      0.90     0.00     0.00
0.00   0.00    0.03    0.00   0.75     4.00     2.25   0.04  83.66
nvme19n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme2n1       21481.60    0.40  85926.40      0.90     0.00     0.00
0.00   0.00    0.04    0.00   0.95     4.00     2.25   0.05  99.26
nvme6n1       21481.60    0.40  85926.40      0.90     0.00     0.00
0.00   0.00    0.04    0.00   0.91     4.00     2.25   0.05  99.26
nvme7n1       21481.60    0.40  85926.40      0.90     0.00     0.00
0.00   0.00    0.04    0.00   0.87     4.00     2.25   0.05  99.24
nvme21n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme11n1      21481.20    0.40  85924.80      0.90     0.00     0.00
0.00   0.00    0.03    0.00   0.75     4.00     2.25   0.04  83.66
nvme15n1      21480.20    0.40  85920.80      0.90     0.00     0.00
0.00   0.00    0.04    0.00   0.80     4.00     2.25   0.04  83.66
nvme23n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme18n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00
nvme3n1       21480.40    0.40  85921.60      0.90     0.00     0.00
0.00   0.00    0.05    0.00   1.02     4.00     2.25   0.05  99.26
nvme20n1         0.00    0.00      0.00      0.00     0.00     0.00
0.00   0.00    0.00    0.00   0.00     0.00     0.00   0.00   0.00

rareq-sz drops to 4, iops increase to 21483 and resync speed drops to 85MB/s.

Why is it like that? Could someone let me know which part of mdraid
kernel code is responsible for this limitation ? Is changing this and
recompiling the kernel on machine with 512GB+ ram safe ?

Regards,
Marcin Wanat
