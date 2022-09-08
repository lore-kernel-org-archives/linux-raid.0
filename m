Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C5FC54EE9
	for <linux-raid@archiver.kernel.org>; Thu,  8 Sep 2022 17:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiIHRXP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Sep 2022 13:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIHRXO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Sep 2022 13:23:14 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67B4EB85F
        for <linux-raid@vger.kernel.org>; Thu,  8 Sep 2022 10:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/3sLQlQkT5RGmh1CBFWN24vT/ZE1NRT0DFhVBlyog2o=; b=SbkgNypbvGVVddo723pTpJARwG
        T1xDXaNwuKS79XX+hV+7I53kXsWLBunSLP4HTNIxGzf+J7DRQTBaCqVrNDKfJvOJrIOzL16MgXUsD
        Y6nhwEBtI/8IN74KkFiAsMucdiha7zvmaKu4XnR+31alP50Qog+DaVM4F3XD/gCQ+C6/+FWWSGjbC
        nB8fYWhovyETuLSKQCbmKg5aZOemTxMUtOm/tLajS9YGarR4IAcesTI53Kvc+26lZwUv8/D7z5Hhk
        V1nK38g29MIQSs4pxVPWZkNUp6oOAw1JteuxUnv4CG5JRwFJJR9wNXADPkfY3jzL3Vs7Y87nqFBWX
        QVZNQQjg==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.197])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oWLFA-0001x7-Qe; Thu, 08 Sep 2022 17:23:12 +0000
Message-ID: <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org>
Date:   Thu, 8 Sep 2022 13:23:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: RAID5 failure and consequent ext4 problems
Content-Language: en-US
To:     Luigi Fabio <luigi.fabio@gmail.com>, linux-raid@vger.kernel.org
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Luigi,

On 9/8/22 10:51, Luigi Fabio wrote:
> Upon reboot, the arrays would not reassemble - this is expected,
> because 4/12 drives were marked faulty. So I re--created the array
> using the same parameters as were used back when the array was built.

Oh, No!

> Unfortunately, I had a moment of stupid and didn't specify metadata
> 0.90 in the re--create, so it was recreated with metadata 1.2... which
> writes its data block at the beginning of the components, not at the
> end. I noticed it, restopped the array and recreated with the correct
> 0.90, but the damage was done: the 256 byte + 12 * 20 header was
> written at the beginning of each of the 12 components.

No, the moment of stupid was that you re-created the array. 
Simultaneous multi-drive failures that stop an array are easily fixed 
with --assemble --force.  Too late for that now.

It is absurdly easy to screw up device order when re-creating, and if 
you didn't specify every allocation and layout detail, the changes in 
defaults over the years would also screw up your data.  And finally, 
omitting --assume-clean would cause all of your parity to be 
recalculated immediately, with catastrophic results if any order or 
allocation attributes are wrong.

):

> Where do I go from here? I have had similar issues in the past, all
> the way back to the early 00s, and I had a near-100% success rate by
> re--creating the arrays. What is different this time?
> Or, is nothing different and is the problem just in the checksumming?

No, you just got lucky in the past.  Probably by using mdadm versions 
that hadn't been updated.

You'll need to show us every command you tried from your history, and 
full details of all drives/partitions involved.

But I'll be brutally honest:  your data is likely toast.

Phil
