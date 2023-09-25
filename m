Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8E4CE7A96
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 15:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjIYPwz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbjIYPwy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Sep 2023 11:52:54 -0400
Received: from micaiah.parthemores.com (micaiah.parthemores.com [199.26.172.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5C4AF
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 08:52:45 -0700 (PDT)
Received: from [130.243.159.229] (uu-guest-159-229.eduroam.uu.se [130.243.159.229])
        by micaiah.parthemores.com (Postfix) with ESMTPSA id 197CD300153;
        Mon, 25 Sep 2023 17:51:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parthemores.com;
        s=micaiah; t=1695657106;
        bh=1rw+r7w0XRVPHEHmo50pbj/AZeEU1TWxWunJalvNHMw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=mwJjd0nTsId7C55vGv7/ki6PTC1suAZ777uAjTWEoR2CYZ7eJcAvpC1P1JDsiHy2K
         Yl1Vb5D22hbRGUSnxF2qlPEyh0zzheATqXOCfSsvzYgAyhLMuhPyPKyvQAHMfeAmf9
         HZedOseT8RKZrMBccAcjaP0AbwJTJKxNo2oLJvnw=
Message-ID: <e8fbc585-9367-a865-8c18-bf9e4fc7562f@parthemores.com>
Date:   Mon, 25 Sep 2023 17:52:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: request for help on IMSM-metadata RAID-5 array
Content-Language: en-GB
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
 <20230925114420.0000302f@linux.intel.com>
From:   Joel Parthemore <joel@parthemores.com>
In-Reply-To: <20230925114420.0000302f@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Den 2023-09-25 kl. 11:44, skrev Mariusz Tkaczyk:

> Hi Joel,
> sorry for late response, I see that you were able to recover the data!


Yes. I just wanted to proceed as slowly and carefully as possible so 
that I would not make an awkward situation worse. ;-) The advice I got 
from the list gave me the assurance to go ahead.


> I think that metadata manager is down or broken from some reasons.
> #systemctl status mdmon@md127.service


I forgot to say with my earlier post that I'm not running systemd but 
rather openrc. Gentoo supports both, and I have my reasons for 
preferring not to make the switch to systemd. Therefore...


> I you will get the problem again, please try (but do not abuse- use it as last
> resort!!):
> #systemctl restart mdmon@md127.service


...That solution won't work. ;-)

If I do have the problem again, maybe I can come to understand better 
how/why it's happening.

Joel

