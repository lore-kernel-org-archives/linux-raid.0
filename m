Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDC3C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 12:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3B5660FC3
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 12:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhJRMgU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:36:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhJRMgT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 18 Oct 2021 08:36:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634560447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KEhbWPQjHzXLJs/VWCy/w/LWcwpgQ5OrkUg2/YuZjwg=;
        b=JVH9QctBcnqsz6jn3tyD6yFa3ZUDZUI/hPhPpjHeN5V0JnY2iIUbhYfTGkTmm8voHoHDJv
        ndo8SrOxXtVh0rrMmr1/stnY91Y+pJrBJMBP7D+o79RNg3GBL20RpA9ejBQejt7cpomuuT
        SCcAD88bMB8N3hxusjOXlWpcsBpMbSk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-RLjujAS4PTia2Rgrdez3tw-1; Mon, 18 Oct 2021 08:34:05 -0400
X-MC-Unique: RLjujAS4PTia2Rgrdez3tw-1
Received: by mail-ed1-f71.google.com with SMTP id f4-20020a50e084000000b003db585bc274so14171785edl.17
        for <linux-raid@vger.kernel.org>; Mon, 18 Oct 2021 05:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEhbWPQjHzXLJs/VWCy/w/LWcwpgQ5OrkUg2/YuZjwg=;
        b=tpnOpcoCu1zjI+jvdGQhR48kSo4Y4jFTsyNeL50awyU2fUDvGmObnI35XQVPea8dys
         QeMV7zOpb66DmH6ErMcNGPZDIoOJOWKWLXMLkGFRtghs9vpbSecxxodn4IHwv/eg89rE
         7lEBcZcIYHS6Cc5qexamLstijLf48ysWsvrRVHD/vh/+rL1gYRIkfiU3ftttNLMA+OfJ
         ybVVWxOAsEy+R8SOrT/jUr5w7ioobJJB2Lspo84vIsGTTeLTFFxcMdjVoIppwKuWHp2y
         EzZxxJ+A2Gv+exCqoqVfIR/Kh9RQQNUVT7d5b8ob49d9VLvKKxD1XZRp44n/qaPOQv05
         42Pg==
X-Gm-Message-State: AOAM532hVbYRq4u3m9pYbOYoup3snwjKHsAiWA0deYMxqqDueeG6Gp1J
        KU044lAhpp+3mRwvizDUTD26sBYS3IfDsPcnCNEkp3OFhUNt4EkLx6mQX8RDkITpjWOCk8oMxVG
        r080hW6cpZ4JCtkzVxpDZw23kpXzMAvs03V1pvA==
X-Received: by 2002:a50:9993:: with SMTP id m19mr43256848edb.357.1634560444581;
        Mon, 18 Oct 2021 05:34:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6n8+1ScYKq4YwlR3WNq/5bVRvdZZjmCLC0EDXPUWSNRtbR2ylmODMXcuxcYKQjjXYmgWfS3m269hK1qufSNA=
X-Received: by 2002:a50:9993:: with SMTP id m19mr43256827edb.357.1634560444347;
 Mon, 18 Oct 2021 05:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <1634289920-5037-1-git-send-email-xni@redhat.com>
 <92351bf8-b0e3-89da-48c0-993b0dc29db2@linux.intel.com> <150ef21b-91eb-2c9f-d813-e8791eded0c1@linux.intel.com>
In-Reply-To: <150ef21b-91eb-2c9f-d813-e8791eded0c1@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 18 Oct 2021 20:33:53 +0800
Message-ID: <CALTww2-m8royvGbtUiw=CjVCrhh+R+Rrmvg=CfW9yrgBn41QMA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, Nigel Croxon <ncroxon@redhat.com>,
        Fine Fan <ffan@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 18, 2021 at 3:15 PM Tkaczyk, Mariusz
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> >> +        dv = devid2kname(makedev(disks[d*2].major, disks[d*2].minor));
> >> +        dv_rep = devid2kname(makedev(disks[d*2+1].major, disks[d*2+1].minor));
>
> devid2kname() returns static memory. If both drive and replacement
> are available then dv value will be overwritten. Not sure if it is
> possible.
>

I think it has the possibility. It only wants to check if the disk exists. Maybe
it's better to write a new api or check if the device exists directly
here. I'll try to avoid
the problem you mentioned.

Best Regards
Xiao

