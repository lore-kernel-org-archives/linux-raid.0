Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87037C433F5
	for <linux-raid@archiver.kernel.org>; Sun,  5 Dec 2021 13:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhLENqT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 5 Dec 2021 08:46:19 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60994 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbhLENqT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 5 Dec 2021 08:46:19 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8FFF31FD54;
        Sun,  5 Dec 2021 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638711771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5yw++nrexlFfC4AX3f7lJLguphc4g3NkFsMKcLgIZjo=;
        b=e8TPswRzk2uoA2Hws5nobkiiGsgFJuuKbXb/38W3+q1d5DdGYTbSoI7SjHIjWcS+XvzQxp
        8HH5Pe6uE5JRQCJvT65ZNKwVQfeuo8/cPBoUjJ4QI2YGfpc8YIRjvwhIK1InhlxovjCa2K
        XMhmfRTsdk2vNj98KiNqrzf1mCUhVvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638711771;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5yw++nrexlFfC4AX3f7lJLguphc4g3NkFsMKcLgIZjo=;
        b=aBz1qEuSu0fp+B2hRNPC7qXngJ+XiW2vzeRJxOdjFnCBrb2OQ6P9a/HeLzhZelQKpLwfUC
        2rjvppe5o32UrTCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59B9113466;
        Sun,  5 Dec 2021 13:42:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KkKHCdjBrGGmewAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 05 Dec 2021 13:42:48 +0000
Message-ID: <dabe438e-3eca-8ad4-553e-ba8555d126bd@suse.de>
Date:   Sun, 5 Dec 2021 21:42:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>, Benjamin Brunner <bbrunner@suse.com>
Cc:     linux-raid@vger.kernel.org,
        mtkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jsorensen@fb.com>
References: <20211201062245.6636-1-colyli@suse.de>
 <20211201170843.00005f69@linux.intel.com>
 <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>
 <73287b77-33aa-a9bd-7efa-5816e098f02f@suse.com>
 <39d432ad-b451-082a-e52d-ffa32155529b@suse.de>
 <163839547917.26075.6431438000167570600@noble.neil.brown.name>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <163839547917.26075.6431438000167570600@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/2/21 5:51 AM, NeilBrown wrote:
> On Thu, 02 Dec 2021, Coly Li wrote:
>> On 12/2/21 12:28 AM, Benjamin Brunner wrote:
>>> Hi all,
>>>
>>> On 01.12.21 17:23, Coly Li wrote:
>>>> On 12/2/21 12:08 AM, mtkaczyk wrote:
>>>>> Hi Coly,
>>>>>
>>>>>> This patch changes KillMode in above listed service files from "none"
>>>>>> to "mixed", to follow systemd recommendation and avoid potential
>>>>>> unnecessary issue.
>>>>> What about mdmonitor.service? Should we add it there too? Now it is not
>>>>> defined.
>>>> It was overlooked when I did grep KillMode. Yes, I agree
>>>> mdmonitor.service should have a KillMode key word as well.
>>>>
>>>> Let me post a v2 version.
>>>>
>>> JFYI, when KillMode is not set, it defaults to KillMode=control-group,
>>> see https://www.freedesktop.org/software/systemd/man/systemd.kill.html.
>>>
>>> Therefore, it shouldn't be necessary to explicitly add it (as long as
>>> control-group is working in case of mdmonitor.service, of course).
>> Hi Benjamin,
>>
>> Please correct me if I am wrong, I see the difference of the KillMode is,
>> -- KillMode=mixed stops the processes more gentally, it kill the main
>> process with SIGTERM and the remaining processes with SIGKILL.
>> -- KillMode=control-group kills all in-cgroup processes with SIGKILL,
>> which I feel a bit cruel for the main process.
> There is no point sending SIGTERM to a process which doesn't respond to
> it.  mdmon is the only mdadm service which handles SIGTERM.  So it might
> make sense to uise KillMode=mixed for that.
> For anything else, SIGKILL via KillMode=control-group is perfectly
> acceptable.

Hi Neil,

Thanks for the hint. So it seems remove the KillMode= lines from the 
systemd files might be best choice.

Hi Benjamin,

How do you think about removing the KillMode= lines to use SIGKILL as 
default action ?

Thanks.

Coly Li
