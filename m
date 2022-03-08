Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F079FC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Mar 2022 23:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiCHXU2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 18:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiCHXU0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 18:20:26 -0500
X-Greylist: delayed 629 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 15:19:22 PST
Received: from box.sotapeli.fi (sotapeli.fi [37.59.98.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A2BA0BCC
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 15:19:22 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7F5C28275F;
        Wed,  9 Mar 2022 00:08:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1646780931; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=p/BKSThOHYLJNBAbSmyvZ0xNJWFVaF/JJB+Dz2tvmPU=;
        b=oLbN2jXSLcjdWhhON2nCKskHWahyCtDsLHk659SJftfgUGhA25lsyYZhwTrhS9vh19Sjf8
        j3Hb8efUu3eA7zgWXFYFIxwjbje0t8+GUkyWTz7mLIVUmzHc2TbSTVvvb/NXkVdMxQwZMm
        4xFRIl1UVd1U6vdAlZMw1J8xgj/RBWe1w4UaIYM6avxpsMh+F3vxZIivGnxOx6XFmtTMhL
        YNYP6t+Sxj7oCFUwltYlGStJ1NwjBl40nGI4HoPMy3RKmn7Mmx8d5rRUKSX8cg4NG3YMH2
        1v5cKqMngepwpase8fWQv/2Dn+t+QYFfE6mOgK0j0isTU8AVdZAWLDKOktsa5Q==
Message-ID: <9b00eff9-1540-228c-60af-d33c32e1b45a@sotapeli.fi>
Date:   Wed, 9 Mar 2022 01:08:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: striping 2x500G to mirror 1x1T
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20220305044704.GB4455@justpickone.org>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <20220305044704.GB4455@justpickone.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello, I don't think you gain really any benefit from that raid-0, just 
go linear array, IMHO.


// JiiPee


David T-G kirjoitti 05/03/2022 klo 6.47:
> Hi, all --
>
> I have a 1T data drive (currently in use with data) that I'd like to
> mirror with a pair of 500G drives striped together.  I'll be mirroring
> two partitions, and I'll be striping partitions to ensure the correct
> size, and my understanding is that I'll have to create the mirror on the
> two new drives with half missing, mount it up, copy over the data, dump
> the original disk, and add it as the other half of the mirror to sync.
> If I've missed anything there, please let me know, but all of that
> matches my Googling and I don't think I have any questions.
>
> What I do wonder, and what I don't see in any searches since apparently
> nobody talks about striping up half of a mirror, is if I should do
> anything special with my two-disk RAID0 stripe.  I was gobsmacked at
> the simplicity of RAID10 on only two drives by splitting each in half
> and "flipping" one to maximize head movement performance.  Awesome! :-)
> Are there any brilliant hacks for simple striping?  If I'm just putting
> together two [not terribly large] disks, will I benefit from any other
> funny stuff, or should I just stripe together two partitions -- each
> half the size of my other drive, of course -- to make a "boring basic"
> stripe and run with that?
>
>
> TIA & HANW
>
> :-D

