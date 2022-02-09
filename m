Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E76C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 14:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiBIO52 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 09:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiBIO50 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 09:57:26 -0500
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22E5C06157B
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 06:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KZIInqJSptTDAP1ydybPEwcvVGzTa4k701AoZ+Dkvz8=; b=HStHl0cjLDfPwQduwwDVt9hLJb
        YLtNKGpD4XhLNxJUN2X8ZfmK5Axg+YYNiX8gv0G4VNwXYNh9May3awgPRm2YEhmrTR8AgGKZ8ecrF
        lfTSsUg5TsuakyQfkODVb/QS+PLRPTj5ggkJU97f7SgOm9tjf+HhxsdrEt04SUYwz8fkB2Lpcywtu
        J7HMazJSkrLFXlaRvbh//IyomGqU38I4v/m/kdSu0sRz24GeS8LhCBLOQvJ9tFoZaLyAD1KBAX2vX
        JcHJC9HEuURQ5+D/9ji5vUXLQ2ue8qznHF8ChMKo5Nmh3wePw+nKi6VaSGG4TElBw+oGZR2LaBkvc
        CwhRs6vw==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1nHoPP-00008T-Jh; Wed, 09 Feb 2022 14:57:27 +0000
Message-ID: <bb5b9cb3-8f74-3194-1193-2108a39d6cdb@turmel.org>
Date:   Wed, 9 Feb 2022 09:57:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Replacing all disks in a an array as a preventative measure
 before failing.
Content-Language: en-US
To:     Red Wil <redwil@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
References: <20220207152648.42dd311a@falcon.sitarc.ca>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <20220207152648.42dd311a@falcon.sitarc.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/7/22 15:26, Red Wil wrote:
> Hello,

[trim/]

> Approaches/solutions and critique
>   1- add one by one a 'spare' and 'replace' raid member
>    critique:
>    - seem to me long and tedious process
>    - cannot/will not run in parallel
>   2- add all the spares at once and perform 'replace' on members
>    critique
>    - just tedious - lots of cli commands which can be prone to mistakes.
>   next ones assume I have all the 'spares' in the rig
>   3- create new arrays on spares, fresh fs and copy data.
>   4- dd/ddrescue copy each drive to a new one. Advantage can be done one
>   by one or in parallel. less commands in the terminal.

My last drive upgrades were done in a chassis that had two extra hot 
swap bays.  So I could do two at a time.  I wanted to keep careful track 
of roles, so I started a replace after each spare added, to ensure that 
spare would get the designated role.  After it was running, I would 
--add and --replace the next.  After the first two were running 
(staggered), it was just waiting for one to finish to pop it out and 
start the next.

After completion, I used --grow to occupy the new space on each.

Took several days, but no downtime at all.

Phil
