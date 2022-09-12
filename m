Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CCFECAAD3
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 00:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiILA64 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiILA6y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 11 Sep 2022 20:58:54 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C0427DEF
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 17:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/EVOSGZC2EgudPdYERH381tlwyYbPMr7TnHYpDPVfno=; b=oRhLrmbei1wsUhG2Q6AG9JiQGz
        aeCEqUNNrnC2IOHxJfKb4DcFci3zFJ5SwnbXqV4dOv6iOgnCr03Y1apZisfP6vfFOcHY9fpJN8ikz
        2QHJTWWbYo+7sjov43GmGwZlvqh/KJmdEdAeiUZA8j7yOPxHnCOfItRYVGOh6njr7+0bGqcyKP/Xf
        F71lp5tAML1dCmfnSpweddtJ1aaOqoHWmOA1XkPoFP29324JzgUOm5CFFIg2iEbmnvNLQjL47j2ro
        qKHG3kmTTQFfjy85D/bFBa4baxvkZ9e92gGpFi1MBo6Y10Ci14TQkDlaEcJFOCIMH1JqAK132OCjR
        IfAhpAKg==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oXXml-00040x-KA; Mon, 12 Sep 2022 00:58:51 +0000
Message-ID: <e12bc8eb-6be0-f5a2-c57e-b0685752ae2b@turmel.org>
Date:   Sun, 11 Sep 2022 20:58:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: 3 way mirror
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <73143dc1-e259-9dd1-d146-81d6c576b5d4@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <73143dc1-e259-9dd1-d146-81d6c576b5d4@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Wol,

On 9/11/22 06:08, Wols Lists wrote:

[trim /]

> old one is still good I'd go for a 3-disk raid-5 plus spare. That's my 
> current setup.

Eww.  Don't do that.  Always convert raid5+spare to raid6.

> Cheers,
> Wol

