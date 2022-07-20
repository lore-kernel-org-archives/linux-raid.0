Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE6FC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 18:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiGTS7Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 14:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiGTS7K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 14:59:10 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E40675BB
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 11:59:09 -0700 (PDT)
Received: from host86-158-105-35.range86-158.btcentralplus.com ([86.158.105.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oEEuZ-00062b-9G;
        Wed, 20 Jul 2022 19:59:08 +0100
Message-ID: <f6f3c027-a376-66a3-c208-baf7809b85c5@youngman.org.uk>
Date:   Wed, 20 Jul 2022 19:59:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH mdadm] mdadm: Don't open md device for CREATE and ASSEMBLE
Content-Language: en-GB
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jsorensen@fb.com>
References: <20220714223749.17250-1-logang@deltatee.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20220714223749.17250-1-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14/07/2022 23:37, Logan Gunthorpe wrote:
> Side note: it would be nice to disable create_on_open as well to help
> solve this, but it seems the work for this was never finished. By default,
> mdadm will create using the old node interface when a name is specified
> unless the user specifically puts names=yes in a config file, which
> doesn't seem to be very common yet.

Putting ANYTHING in a config file is not that common.

I suspect there are very many systems out there, like mine, that work 
fine with auto-assemble and no config. I gather there are quite a few 
people out there who insist on having a config file, but IME it's a 
waste of time building one.

Cheers,
Wol
