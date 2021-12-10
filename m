Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B790EC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 06:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhLJHBH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 02:01:07 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:44800 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbhLJHA7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Dec 2021 02:00:59 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4471C1F3A0;
        Fri, 10 Dec 2021 06:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639119444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsxNbVqSHl10S77H6yDqDZ9G/tcyZqlj5Kx/Pd7vvwE=;
        b=cKcym/fesNX5y+RYMdRCIVMDpLAo5yDUPKtJt1zSW6cvqKEX7NwWvrWM2+toz4jbIOxuhz
        p8+/uMbtkc0oSltvf1O2GYygwF747iR6jalVciCiaqEdSyQMNTw5hokUDnt3zMbCv7GVUJ
        l8VpPdqGh2xH/vnyxkptZP6FIZ71isI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639119444;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsxNbVqSHl10S77H6yDqDZ9G/tcyZqlj5Kx/Pd7vvwE=;
        b=whSaZOOURTQ9HhQUyEH7mgG7IDIScjhqEIW01mjt7DerodW1oRk+AwV447Y+/Lbjixoj/L
        xCyx2X/NaNjwn5BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8E45313DD2;
        Fri, 10 Dec 2021 06:57:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id j3A+GFL6smGxdgAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 10 Dec 2021 06:57:22 +0000
Message-ID: <a608949d-86ea-b7fd-c0c6-6dd6614202c7@suse.de>
Date:   Fri, 10 Dec 2021 14:57:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v3 2/6] badblocks: add helper routines for badblock ranges
 handling
Content-Language: en-US
To:     Geliang Tang <geliang.tang@suse.com>
Cc:     nvdimm@lists.linux.dev, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Vishal L Verma <vishal.l.verma@intel.com>
References: <20211202125245.76699-1-colyli@suse.de>
 <20211202125245.76699-3-colyli@suse.de>
 <20211209072251.GA26976@dhcp-10-157-36-190>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211209072251.GA26976@dhcp-10-157-36-190>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/9/21 3:22 PM, Geliang Tang wrote:
> Hi Coly,
>
> Thanks for this new version!

Thank you so much for the review comments. I fix all the typos and 
change the code as you suggested with dropping extra local variables.

The modification will be posted in next version.

Coly Li

[snip]

