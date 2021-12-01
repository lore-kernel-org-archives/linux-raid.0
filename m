Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED020C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Dec 2021 16:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351637AbhLAQsY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Dec 2021 11:48:24 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:51146 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351507AbhLAQqz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Dec 2021 11:46:55 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D84BA212BA;
        Wed,  1 Dec 2021 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638377013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8+q5fl5EihtTF9zr8FAGl/yA6LLiOHQ711daGCboDg=;
        b=qYwUDrIfVlv8iTwwu6kDqIyoIc++0dNDJ77J+tTz35eH1BmibByw1OvfvgBNx+9POgh0RY
        hdh30xZwMpFq7N2UeiDD0wmDBfz4tMTPr89PBLfOn9ZGJg3vKwGOu3L/B0bRQbNJUFnufL
        0H7u9Gd2+WSFrOu3wsWzo6sQENfRlI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638377013;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8+q5fl5EihtTF9zr8FAGl/yA6LLiOHQ711daGCboDg=;
        b=sv19hAS9ogTbVqsyRy5LCr8g8+0PB2SXDM2iHccajtRaf1hAqO9rd4uSv8tOipCgai+kvV
        LAeIebKv0T2u0kBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 970BB13D90;
        Wed,  1 Dec 2021 16:43:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yWPKGTSmp2GaIwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 01 Dec 2021 16:43:32 +0000
Message-ID: <39d432ad-b451-082a-e52d-ffa32155529b@suse.de>
Date:   Thu, 2 Dec 2021 00:43:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
Content-Language: en-US
To:     Benjamin Brunner <bbrunner@suse.com>
Cc:     linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        mtkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jsorensen@fb.com>
References: <20211201062245.6636-1-colyli@suse.de>
 <20211201170843.00005f69@linux.intel.com>
 <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>
 <73287b77-33aa-a9bd-7efa-5816e098f02f@suse.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <73287b77-33aa-a9bd-7efa-5816e098f02f@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/2/21 12:28 AM, Benjamin Brunner wrote:
> Hi all,
>
> On 01.12.21 17:23, Coly Li wrote:
>> On 12/2/21 12:08 AM, mtkaczyk wrote:
>>> Hi Coly,
>>>
>>>> This patch changes KillMode in above listed service files from "none"
>>>> to "mixed", to follow systemd recommendation and avoid potential
>>>> unnecessary issue.
>>> What about mdmonitor.service? Should we add it there too? Now it is not
>>> defined.
>>
>> It was overlooked when I did grep KillMode. Yes, I agree 
>> mdmonitor.service should have a KillMode key word as well.
>>
>> Let me post a v2 version.
>>
> JFYI, when KillMode is not set, it defaults to KillMode=control-group, 
> see https://www.freedesktop.org/software/systemd/man/systemd.kill.html.
>
> Therefore, it shouldn't be necessary to explicitly add it (as long as 
> control-group is working in case of mdmonitor.service, of course).

Hi Benjamin,

Please correct me if I am wrong, I see the difference of the KillMode is,
-- KillMode=mixed stops the processes more gentally, it kill the main 
process with SIGTERM and the remaining processes with SIGKILL.
-- KillMode=control-group kills all in-cgroup processes with SIGKILL, 
which I feel a bit cruel for the main process.

IMHO both method (explicit mixed mode or implicit control-group mode) 
should works for the fixing issue, but I feel removing the KillMode 
lines might be better as you indicated since the files can be a bit 
simpler. Do I understand you correct ?

Thanks.

Coly Li
