Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB81C433EF
	for <linux-raid@archiver.kernel.org>; Sat,  5 Mar 2022 09:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiCEJGS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Mar 2022 04:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiCEJGR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Mar 2022 04:06:17 -0500
X-Greylist: delayed 527 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Mar 2022 01:05:27 PST
Received: from mr4.vodafonemail.de (mr4.vodafonemail.de [145.253.228.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D1506F1
        for <linux-raid@vger.kernel.org>; Sat,  5 Mar 2022 01:05:27 -0800 (PST)
Received: from smtp.vodafone.de (unknown [10.0.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mr4.vodafonemail.de (Postfix) with ESMTPS id 4K9dr70BQ4z1xyg;
        Sat,  5 Mar 2022 08:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
        s=vfde-smtpout-mb-15sep; t=1646470599;
        bh=iMelwn/UztAG4srYQBADI6jWSiHQ1Y69WSiF83MIPRw=;
        h=Date:From:To:Subject:Message-ID:References:Content-Type:
         In-Reply-To:From;
        b=YR0NIQROFrxRjL6NvPv6xfqSxCWhhWJtFrl2kO4Ie/pKdBeC/G1SKvI+8OlJ7C0Qg
         NdegXsJIqJ1F/iHmgG86y8V6zfKYpBHy+PGt30/K+bLtseg5NdlqTT57gTZ21LzLgh
         5raX1RsmLfRyTCvF11wwXutVOaHJvUvlPlIIrlRg=
Received: from lazy.lzy (p5dd47cf0.dip0.t-ipconnect.de [93.212.124.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4K9dr35SvmzMkrs;
        Sat,  5 Mar 2022 08:56:32 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
        by lazy.lzy (8.17.1/8.14.5) with ESMTPS id 2258uV7O003428
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 5 Mar 2022 09:56:31 +0100
Received: (from red@localhost)
        by lazy.lzy (8.17.1/8.16.1/Submit) id 2258uVFv003427;
        Sat, 5 Mar 2022 09:56:31 +0100
Date:   Sat, 5 Mar 2022 09:56:31 +0100
From:   Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To:     "Kengo.M" <kengo@kyoto-arc.or.jp>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Number of parity disks
Message-ID: <YiMlvzrUwFJtxqfr@lazy.lzy>
References: <20220304175556.407719-1-hch@lst.de>
 <20220304175556.407719-2-hch@lst.de>
 <20220304221255.GL3927073@dread.disaster.area>
 <20220305051929.GA24696@lst.de>
 <p06001087de48ad4092ee@kyoto-arc.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p06001087de48ad4092ee@kyoto-arc.or.jp>
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 1094
X-purgate-ID: 155817::1646470598-00000483-3D828DEF/0/0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Mar 05, 2022 at 03:09:55PM +0900, Kengo.M wrote:
> Hi Folks
> 
> I use mdadm conveniently.
> 
> Let me ask a very very basic question.
> 
> One parity disk can be used in RAID 5 and 2 parity disks can be used in RAID 6.
> ZFS RAIDZ-3 (raidz3) can use 3 parity disks.
> 
> Is it difficult to increase the number of parity disks to 4, 5 or more.
> If so, is the reason for this because of the time it takes to generate the
> parity bits?

There was a project, some times ago, with
the aim to create a library, initially for
btrfs, capable of adding "n" parities.

This should have been usable by md as well.

The problem is that the Vandermonde matrix
might not invertible with more than 2 parities.
So, they've to use a Cauchy matrix.

It might be that performances are degrading
quite a lot.

I'm not sure about the status of such library,
maybe you can ask in the btrfs mailing list.

On the other hand, 3 parities (or more) case
might be a bit an overkill.
For md could be better to have things like
RAID-61 or similar.

bye,

-- 

piergiorgio
