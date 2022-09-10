Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD553C6FA89
	for <linux-raid@archiver.kernel.org>; Sat, 10 Sep 2022 20:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIJUOS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Sep 2022 16:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIJUOQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Sep 2022 16:14:16 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FE740E0E
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 13:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
        :To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vNz/1zWG8IaJYIK9cY1KgwDvaRPp5iV27JqiIZTfjxU=; b=cO8f31qcRLy/0ZtmH4oL1C5z24
        X/UD7Nt7LGpxiMkNjL6YBP1LeDieHSmVXVARVsMDz5uwwJcN7/77cJwvFiHuRIEiMkT+8XXTuxJcj
        iVHMffKga3YTT8ISZNPc3JIMQ4Ye2WxsXahI5eKeZpuFSl8LiCsOJXZxU1Uiusw4V/F2ZxAgtMaXj
        WxVpcl32kBePwxyrwntJ67Nh5IDg+/2J43ISk0vOlu4rA4zU2CzxdcNozj7ZNLLLeeSL5E/r9Wama
        gg0JwOup1HkPg8f28bUkyhGAtWzQU3k6+nUA/E0UddP/Igjx+MtR+IcReQKsIC99v8Cp/xeKa81fb
        S0TKUrcg==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oX6rn-0004br-09; Sat, 10 Sep 2022 20:14:15 +0000
Message-ID: <10e92155-0662-44ca-87b0-16dbdb2efca4@turmel.org>
Date:   Sat, 10 Sep 2022 16:14:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: RAID5 failure and consequent ext4 problems
Content-Language: en-US
To:     Luigi Fabio <luigi.fabio@gmail.com>
Cc:     linux-raid@vger.kernel.org
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org>
 <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org>
 <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
 <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org>
 <CAJJqR23RE3Hfrm-bkiyMm3OjUTCFhXsRvBXr4H8563t1VyY=0g@mail.gmail.com>
 <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Luigi,


On 9/10/22 15:55, Luigi Fabio wrote:
> Well, I found SOMETHING of decided interest: when I run dumpe2fs with
> any backup superblock, this happens:
> 
> ---
> Filesystem created:       Tue Nov  4 08:56:08 2008
> Last mount time:          Thu Aug 18 21:04:22 2022
> Last write time:          Thu Aug 18 21:04:22 2022
> ---
> 
> So the backups have not been updated since boot-before-last? That
> would explain why, when fsck tries to use those backups, it comes up
> with funny results.

Interesting.

> Is this ...as intended, I wonder? Does it also imply that any file
> that was written to > aug 18th will be in an indeterminate state? That
> would seem to be the implication.

Hmm.  I wouldn't have thought so, but maybe the backup blocks don't get 
updated as often?

{ I think you are about as far as I would have gotten myself, if I 
allowed myself to get there. }

Phil
