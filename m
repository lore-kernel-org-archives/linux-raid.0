Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62D6C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 21 Mar 2022 14:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346808AbiCUO4X (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Mar 2022 10:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239708AbiCUO4W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Mar 2022 10:56:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95B633E24
        for <linux-raid@vger.kernel.org>; Mon, 21 Mar 2022 07:54:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 981331F385;
        Mon, 21 Mar 2022 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647874495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kqDkyjYy29IvCL2zGGrGvYhqq8arHWdVlgT5EwJORx8=;
        b=S2SS1wNIdVO11xeuUmzlDHpmij9kMY8aVmVA8GzAIIJOwN7ejAL65AdDLAfYuZqicHBChV
        rz8uUncvHXdE0O1kf12aSoNn/eISHfu/pe4D2PYR8JhaNpOuft6JfVblctcOcqNOj6Nm8s
        rne1iAfEfKa3rjeY1qidu9f9nfK2JF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647874495;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kqDkyjYy29IvCL2zGGrGvYhqq8arHWdVlgT5EwJORx8=;
        b=D5VZqliNSg5KOvOW5Nr2z+HG/lI+k+bZvav2ibIkiSzgeG6oZRvXf/RyvCjo+HWErb3FWD
        0cNEc0oLiSSHKyAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E99C12FC5;
        Mon, 21 Mar 2022 14:54:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3b9zObaROGK/BAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 21 Mar 2022 14:54:46 +0000
Message-ID: <084cd90c-fada-072e-aade-079b577cf107@suse.de>
Date:   Mon, 21 Mar 2022 22:54:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 1/4] mdadm: Respect config file location in man
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
 <51ee6419-9ae4-04a5-1a69-e3fd1b9f0d04@suse.de>
 <20220321091458.00007c0c@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220321091458.00007c0c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/21/22 4:14 PM, Mariusz Tkaczyk wrote:
> On Sun, 20 Mar 2022 17:54:56 +0800
> Coly Li <colyli@suse.de> wrote:
>
>> On 3/18/22 4:26 PM, Lukasz Florczak wrote:
>>> Default config file location could differ depending on OS (e.g.
>>> Debian family). This patch takes default config file into
>>> consideration when creating mdadm.man file as well as
>>> mdadm.conf.man.
>>>
>>> Rename mdadm.conf.5 to mdadm.conf.5.in. Now mdadm.conf.5 is
>>> generated automatically.
>>>
>>> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
>>
>> I test and verify the change under openSUSE.
>>
>>
>> Acked-by: Coly Li <colyli@suse.de>
>>
>>
> Hi Coly,
> Could you please merge it to your master/for-jes branch then?

Sure, I will do it.

Just to confirm, for this situation, do you want me to add the patch 
directly to for-jes branch with my Acked-by: tag, or you will post 
another version with the Acked-by: tag?


> We have additional CI at Intel, based on our internal IMSM scope.
> I would like to switch it to your master/for-jes branch. Also I want to
> base future development on your tree.


Copied.


> Could you also elaborate more, what kind of testing are you doing?


Currently I only compile the patches, and create simple md raid1 
with/without container, and show them with mdadm -D and -E.

For the manual modification, it is checked by myself. I compile the man 
page, and check the CONFFILE and CONFFILE2 replacement in man page is 
correct on openSUSE. Then I run checkpatch.pl from Linux kernel with 
--codespell to check the patch style and basic spelling. And finally 
read the changed content of the man page.


> I think that is a good moment to give new life to mdadm test suite, if
> you are using it.


I am thinking of create another separate git repo, to store all the 
testing scripts, and run them on the mdadm-CI tree.

Thanks.


Coly Li

