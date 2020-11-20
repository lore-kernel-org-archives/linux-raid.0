Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5309BC5519F
	for <linux-raid@archiver.kernel.org>; Fri, 20 Nov 2020 10:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA80822255
	for <linux-raid@archiver.kernel.org>; Fri, 20 Nov 2020 10:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oldum-net.20150623.gappssmtp.com header.i=@oldum-net.20150623.gappssmtp.com header.b="CbwQ8Ae1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgKTKmr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Nov 2020 05:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgKTKmr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Nov 2020 05:42:47 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2020C0613CF
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2020 02:42:46 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d12so9459940wrr.13
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2020 02:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oldum-net.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=A/JZkQggpUQxGVMfj/cm/hmy092XxrnrcVHTpb+kxK4=;
        b=CbwQ8Ae1fR5JiikQLihXmOcHHahTlqhr3eJ0WO45fL9Lv+Bo5N5f+mdWYSvr9vMnQF
         Qm0z6udN+gLp0Ny13LO9TLB4vsTBTPlx2mTtTLRym096kWszZs7dPJuKeurt5L3/aOxm
         vtQDnoSXySJk+TALzJi2TwHBNhs6LfxFU1H8ozfLLOXSewi+Rl3kvZ7aPR2yY9VSCkzt
         T5/sK1006Af+ciw2ALLQ9mqkJCYgoAaYTiFB3EMDbDedMrmmZ5Bz40Bo74R/UL8uJQLa
         RN/hKBfJUGZTaUrF0OC2IpOgCEhFhMWuq0JL7ljs4JEqAw7Yl6TdKVWGuYKZhtCmwXE5
         T7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=A/JZkQggpUQxGVMfj/cm/hmy092XxrnrcVHTpb+kxK4=;
        b=QAEl7PeThKOsmwGFj0ayiojdBdGbC0aQt1TaLev2p5NiMz4ms343K2D2TvpfYmwXPZ
         AmHaIAhv445LmmRgQ/8ZzGBRiKfDh4f8qtdY7nbOi9Nk0Klwfx4czp+UUHev+lAXCBU4
         cHrI7anLRE50uCKUmOkyeXzDGamXP5qjB/Vl6X3PJrDgfWgZwDbyMEGRjkHfIcqt45Vu
         G5gDfFzpsZDBWzN57ghwW1vY1W4tjVEI6AshAbI87+6/chlamU9eN3Zps8lVDL+g+K/d
         TUCuYcJrZs526hJg5B8U380EHMXcRZCtSlZ1SGYO5khwiFNj2J2i5IsdF6f2Aanmu4uO
         y7Ug==
X-Gm-Message-State: AOAM533mpg8dVrRiYzA/q1ikWgHkmAnaHTXnSNtEJwD+GKFZmmMU4fPn
        2Ej2QYqZdPN4vYbU+L0I0K4e3fHriBnMVNTh
X-Google-Smtp-Source: ABdhPJycSRLKhwgoLzPfA6YfK7x+sduHK5zfnonO4kBjHMoJPEZLsKnIvYf9DBlMU8iW0a1sGHDLZA==
X-Received: by 2002:adf:eb4c:: with SMTP id u12mr16125003wrn.73.1605868965426;
        Fri, 20 Nov 2020 02:42:45 -0800 (PST)
Received: from [192.168.178.61] (external.oldum.net. [82.161.240.76])
        by smtp.googlemail.com with ESMTPSA id j127sm4148351wma.31.2020.11.20.02.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 02:42:44 -0800 (PST)
Message-ID: <fa14ca859160872fece3e2d3efc0a21c42bb9a4a.camel@oldum.net>
Subject: Re: Nr_requests mdraid
From:   Nikolay Kichukov <nikolay@oldum.net>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Date:   Fri, 20 Nov 2020 11:42:44 +0100
In-Reply-To: <5EAED86C53DED2479E3E145969315A23856EEA12@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A23856EEA12@UMECHPA7B.easf.csd.disa.mil>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello all,

On Mon, 2020-11-16 at 16:51 +0000, Finlayson, James M CIV (USA) wrote:
> On Wed, Oct 28, 2020 at 6:39 PM Vitaly Mayatskih <
> v.mayatskih@gmail.com> wrote
> > 
> > On Thu, Oct 22, 2020 at 2:56 AM Finlayson, James M CIV (USA) <
> > james.m.finlayson4.civ@mail.mil> wrote:
> > > 
> > > All,
> > > I'm working on creating raid5 or raid6 arrays of 800K IOP nvme
> > > drives.   Each of \
> > > the drives performs well with a queue depth of 128 and I set to
> > > 1023 if allowed.   \
> > > In order for me to try to max out the queue depth on each RAID
> > > member, so I'd like \
> > > to set the sysfs nr_requests on the md device to something greater
> > > than 128, like \
> > > #raid members * 128.   Even though
> > > /sys/block/md127/queue/nr_requests is mode 644, \
> > > when I try to change nr_requests in any way as root, I get write
> > > error: invalid \
> > > argument.  When I'm hitting the md device with random reads, my
> > > nvme drives are \
> > > 100% utilized, but only doing 160K IOPS because they have no queue
> > > depth. 
> > > Am I doing something silly?
> > 
> > It only works for blk-mq block devices. MD is not blk-mq.

Would it be possible to implement something similar to the use_blk_mq of
dm_mod on md_mod?

> > 
> > You can exchange simplicity for performance: instead of creating one
> > RAID-5/6 array you can partition drives in N equal sized partitions,
> > create N RAID-5/6 arrays using one partition from every disk, then
> > stripe them into top-level RAID-0. So that would be RAID-5+0 (or
> > 6+0).
> > 
> > It is awful, but simulates multiqueue and performs better in
> > parallel
> > loads. Especially for writes (on RAID-5/6).
> > 
> > 
> > -- 
> > wbr, Vitaly
> 
> Vitaly,
> Thank you for the tip.  My raid5 performance (after creating 32
> partitions per SSD) and running 64  9+1 (2 in reality) stripes is up
> to 11.4M 4K random read IOPS, out of 17M that the box is capable,
> which I'm happy with, because I can't NUMA the raid stripes as I would
> the individual SSDs themselves.   However, when I perform the RAID0
> striping to make the "RAID50 from hell", my performance drops to 7.1M
> 4K random read IOPS.   Any suggestions?  The last RAID50, again won't
> let me generate the queue depth.
> 
> Thanks in advance,
> Jim
> 
> 
> 


