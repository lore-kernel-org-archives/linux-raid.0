Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC786C43334
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 15:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbiGMPaO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiGMPaN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 11:30:13 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26334D17B;
        Wed, 13 Jul 2022 08:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=LUETXbF8HCRKfyRXGDknfCyAwKINDb5RGVv7tBw8vy4=; b=Zp86ovS8lPaQ+MxNcgVUj9Ivlg
        Ca4gNEq5zMne6tB4fzanArJH1wnm7w0kBqTeH+IbaEtGQ6LMQDVrVsmpOI4fYLIwMJgHAKriTp0xf
        MgY5SQkCFF89giZILHtpC/TMba+RU8JwA//b8XgCRubNsa/l7qZLju77PYh2vT3yEpI/fPws9JG9D
        V7ydKq+u2prIpJG9xjQijMMvL71i/jqsJcjqcpR0xaRsWzfQzFnQTWY3qIWxeYfNIp3tfLmm7qodI
        /XBh67TndyKbKXMieEmuXOkTb2U75bo17sE49MfhR5wK4gqlBOuC0adp56neAZwAmyGkr0MsJqf+/
        hQnYQEhA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oBeJV-00E8al-Gj; Wed, 13 Jul 2022 09:30:10 -0600
Message-ID: <90ae41d3-08b9-0342-6435-e636e18d3de2@deltatee.com>
Date:   Wed, 13 Jul 2022 09:30:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220712070331.1390700-1-hch@lst.de>
 <20220712070331.1390700-3-hch@lst.de>
 <85666118-cbb0-83e2-5c27-c3be8c5c6688@deltatee.com>
 <20220713071707.GA14903@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220713071707.GA14903@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 2/8] md: implement ->free_disk
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 2022-07-13 01:17, Christoph Hellwig wrote:
> On Tue, Jul 12, 2022 at 05:13:48PM -0600, Logan Gunthorpe wrote:
>>> +
>>> +	percpu_ref_exit(&mddev->writes_pending);
>>> +	bioset_exit(&mddev->bio_set);
>>> +	bioset_exit(&mddev->sync_set);
>>> +
>>> +	kfree(mddev);
>>> +}
>>
>> I still don't think this is entirely correct. There are error paths that
>> will put the kobject before the disk is created and if they get hit then
>> the kfree(mddev) will never be called and the memory will be leaked.
> 
> True.
> 
>> Instead of creating an ugly special path for that, I came up with a solution 
>> that I think  makes a bit more sense: the kobject is still freed in it's 
>> own free  function, but the disk holds a reference to the kobject and drops
>> it in its free function. The sysfs puts and del_gendisk are then moved
>> into mddev_delayed_delete() so they happen earlier.
> 
> I'm not sure this is a good idea.  The mddev kobject hangs off the
> disk, so I don't think that it should in any way control the life
> time of the disk, as that just creates potential problems down the
> road.

My interpretation was that kobject_del() (which is called in
mddev_delayed_delete() before the disk would be removed) removes the
mddev from the disk. At that point, it's just a structure hanging around
that will be freed when its last reference is dropped, which is the disk
itself cleaning up. I'm not sure how that would cause potential problems.

Logan
