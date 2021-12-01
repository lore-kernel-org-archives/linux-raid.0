Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F91C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Dec 2021 16:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350079AbhLAQ0l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Dec 2021 11:26:41 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:46730 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhLAQ0f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Dec 2021 11:26:35 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 10314212C2;
        Wed,  1 Dec 2021 16:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638375794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1rZ2Gu6EpLjGBzCQKtoWt+aabGTwxSUGWzF4+pgFrzQ=;
        b=o4xVbcKIksuWkKa6eb8dr92zFHM3elnYRBwC24QrvompgMKmqtqMAYrZrt/qaDvCORwS8A
        +ZZizfZl8tBB16Fo1/pi24m6GBeLalf5CRts/EZ/pXFfkWulfFUhNoI9viAT7BMbONEjVP
        5qoDGxK4oQ7D7PKHyXOtCkOzhP/Bgk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638375794;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1rZ2Gu6EpLjGBzCQKtoWt+aabGTwxSUGWzF4+pgFrzQ=;
        b=Imi5biH6UKBvAENf86VHGOjLE5MpNha6LGnYOaxBAnE0SgsWqZJTUtkR7UhmsrM6cy69wM
        OMyjEMA+Dnho+ADA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8CAB013D90;
        Wed,  1 Dec 2021 16:23:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eBAeD3Chp2GIGQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 01 Dec 2021 16:23:12 +0000
Message-ID: <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>
Date:   Thu, 2 Dec 2021 00:23:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
Content-Language: en-US
To:     mtkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Neil Brown <neilb@suse.de>, Jes Sorensen <jsorensen@fb.com>
References: <20211201062245.6636-1-colyli@suse.de>
 <20211201170843.00005f69@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211201170843.00005f69@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/2/21 12:08 AM, mtkaczyk wrote:
> Hi Coly,
>
>> This patch changes KillMode in above listed service files from "none"
>> to "mixed", to follow systemd recommendation and avoid potential
>> unnecessary issue.
> What about mdmonitor.service? Should we add it there too? Now it is not
> defined.

It was overlooked when I did grep KillMode. Yes, I agree 
mdmonitor.service should have a KillMode key word as well.

Let me post a v2 version.

>> Cc: Jes Sorensen <jsorensen@fb.com>
> Not sure if it a problem but Jes uses: jes@trained-monkey.org for
> communication with linux-raid.

Copied. Thanks for the hint.

Coly Li
