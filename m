Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C496DC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 22:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhLNWUJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 17:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhLNWUI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Dec 2021 17:20:08 -0500
X-Greylist: delayed 1241 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Dec 2021 14:20:08 PST
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABD5C061574
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 14:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RMfGwNP8omLC4IuaMmXQQSvw1sE/vbGhrj77e/3S640=; b=sZlDbjCmmZjFNXZr2Gb6uayk6I
        F3Xjs3NPbMRmKcbdeT4SnKLW2LBYWwAsZKp9+7tfp/9bmbn/86kvhtH1ffJRbJ3G1BguNmrQtFM3D
        Ok3SdLwsLAS/T8hggBGNjSfpsjOn26qdKA6dZSIUtmMqldhhIlmxlfe7DToRo5hXKkg/QK8e9ofRs
        WejROZWq3n6kIC7HT1VO0JLOVH+OGuHxoQ+5vvKEko+eYOHauybygtK0NbZu2CYUOBgAKwHOO4I1Y
        AwuuFIHdMRP6fsezJVJpF6fU3rROAOhrXTmHg9ZOvDc8hBC9HELJYFTFSvpMvoxjQ/MEzYWu2y7rR
        pE2Nd/iA==;
Received: from [12.35.44.237] (helo=[172.30.0.81])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1mxFpT-0002DF-QQ; Tue, 14 Dec 2021 21:59:23 +0000
Subject: Re: Debugging system hangs
To:     Roman Mamedov <rm@romanrm.net>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <20211214224658.26cea5a0@nvm>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <4187acd4-ece5-9d39-a008-5aa01c9b6d76@turmel.org>
Date:   Tue, 14 Dec 2021 16:59:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211214224658.26cea5a0@nvm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/14/21 12:46 PM, Roman Mamedov wrote:
> On Tue, 14 Dec 2021 15:54:50 +0000
> Wols Lists <antlists@youngman.org.uk> wrote:
> 

>> Any advice on how to debug a hang - basically I need something that'll
>> just sit there so when it crashes (and I press the reset button to
>> recover) I'll have some sort of trace. It would be nice to prove it's
>> not the disk stack at fault ...
>>
>> Obviously, "set these options in the kernel" won't faze me ...
> 
> Set up "netconsole":
> https://www.kernel.org/doc/html/latest/networking/netconsole.html
> https://wiki.ubuntu.com/Kernel/Netconsole
> 

+1 for netconsole.  Also enable the SysRq key for thread dumps.  So you 
have the dump before you reset.
