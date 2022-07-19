Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EAAC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 07:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbiGSH7O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiGSH7M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 03:59:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C1C31DEC;
        Tue, 19 Jul 2022 00:59:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1059D2008A;
        Tue, 19 Jul 2022 07:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658217550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ag2PCav6/+YWGJlrgwEXroJayeEk/+Qui+8D2H2O964=;
        b=prK6cADJAqPxfa28FbmsUgZXK11s315oVnxiRUd54XueJX5Jep7ok6FcE8+QrExBACftq8
        aan2fQvT2Q9coXymgq3TwMkhwywNXm2wU5Lgpz9KIAU1oID4FQ+BJIJnstqVFq1H9l+bD4
        TujAUQn0+qb8kcdJp4arpfkCV4ymqis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658217550;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ag2PCav6/+YWGJlrgwEXroJayeEk/+Qui+8D2H2O964=;
        b=kohvmFbcvZIBxVe6N6g+9pY87RphQtqiBBRa91ej6XSkRMiB0tdT9ps6wMM7U4VE47SwtP
        re5VEsNLQD7NVpAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E80A213488;
        Tue, 19 Jul 2022 07:59:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VqaRN01k1mJyPgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 19 Jul 2022 07:59:09 +0000
Message-ID: <6a411ecb-0fef-56fb-1e54-bb46612c2b3b@suse.de>
Date:   Tue, 19 Jul 2022 09:59:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 09/10] md: only delete entries from all_mddevs when the
 disk is freed
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Song Liu <song@kernel.org>, Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-10-hch@lst.de>
 <b8521a53-fb41-279c-dc43-580e8d0de045@suse.de>
 <20220719071434.GA28668@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220719071434.GA28668@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/19/22 09:14, Christoph Hellwig wrote:
> On Mon, Jul 18, 2022 at 09:17:42AM +0200, Hannes Reinecke wrote:
>> Why can't we use 'atomic_inc_unless_zero' here and do away with the
>> additional 'deleted' flag?
> 
> See my previous reply.
> 
>>> @@ -3338,6 +3342,8 @@ static bool md_rdev_overlaps(struct md_rdev *rdev)
>>>      	spin_lock(&all_mddevs_lock);
>>>    	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
>>> +		if (mddev->deleted)
>>> +			continue;
>>
>> Any particular reason why you can't use the 'mddev_get()' / 'mddev_put()'
>> sequence here?
> 
> Mostly because it would be pretty mess.  mdev_put takes all_mddevs_lock,
> so we'd have to add an unlock/relock cycle for each loop iteration.
> 
>> After all, I don't think that 'mddev' should vanish while being in this
>> loop, no?
> 
> It won't, at least without the call to mddev_put.  Once mddev_put is
> in the game things aren't that easy, and I suspect the exising and
> new code might have bugs in that area in the reboot notifier and
> md_exit for extreme corner cases.

And again, MD mess.
But thanks for start clearing it up.

Cheers,

Hannes
