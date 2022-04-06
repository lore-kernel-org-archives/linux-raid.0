Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649AEC433F5
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 16:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbiDFQES (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbiDFQEA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 12:04:00 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D563A1E960D
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 06:35:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649252127; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=iOghYfordWhI241x8NGWfzlZq7WPB+VrlQ8uyCOIFW4gsGgWMqZCOdXK5LKaSCry1XOUFBEDIRR5fC9Zo7WOSttRE+7C1VKzGzkVowW6jGZPhD4XJi1ywlrcncE8humLgayCocN41t2xGWDaGxOXjkovBtgUd0EVJplokIgfqIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649252127; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Q88Z9Lyf4Q+Bblg7sV0ASQaT6W8ZIGANLRgAq5FCCp4=; 
        b=hR4mGmiFwBuPL8Ys3L2SRpzw2IiVYL45z207IYkr59TH1ubdf3I/wG7OC7tPiZQIJpK+sOW3glFi92J+hPGKECxNlKss0VnnDuR/cnJN++OygeK1YGQfEuEgCN6xR27YIST2hcgttc1y10TI05koiAd0eBHa6fdkMkCoBB9FppM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1649252126075568.6814091235765; Wed, 6 Apr 2022 15:35:26 +0200 (CEST)
Message-ID: <b8642257-bba8-91b1-b7ec-5ec16c59da85@trained-monkey.org>
Date:   Wed, 6 Apr 2022 09:35:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Neil Brown <neilb@suse.de>
References: <20220215133415.4138-1-colyli@suse.de>
 <CALTww28aKNSAj9a7kyYxPEJgUMRA5f0DGjc=X-SrRY5c5p6jyQ@mail.gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <CALTww28aKNSAj9a7kyYxPEJgUMRA5f0DGjc=X-SrRY5c5p6jyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/6/22 02:36, Xiao Ni wrote:
> Hi Jes
> 
> Could you merge this patch.
> 
> On Tue, Feb 15, 2022 at 9:34 PM Coly Li <colyli@suse.de> wrote:
>>
>> For mdadm's systemd configuration, current systemd KillMode is "none" in
>> following service files,
>> - mdadm-grow-continue@.service
>> - mdmon@.service
>>
>> This "none" mode is strongly againsted by systemd developers (see man 5
>> systemd.kill for "KillMode=" section), and is considering to remove in
>> future systemd version.
>>
>> As systemd developer explained in disuccsion, the systemd kill process
>> is,
>> 1. send the signal specified by KillSignal= to the list of processes (if
>>    any), TERM is the default
>> 2. wait until either the target of process(es) exit or a timeout expires
>> 3. if the timeout expires send the signal specified by FinalKillSignal=,
>>    KILL is the default
>>
>> For "control-group", all remaining processes will receive the SIGTERM
>> signal (by default) and if there are still processes after a period f
>> time, they will get the SIGKILL signal.
>>
>> For "mixed", only the main process will receive the SIGTERM signal, and
>> if there are still processes after a period of time, all remaining
>> processes (including the main one) will receive the SIGKILL signal.
>>
>> From the above comment, currently KillMode=control-group is a proper
>> kill mode. Since control-gropu is the default kill mode, the fix can be
>> simply removing KillMode=none line from the service file, then the
>> default mode will take effect.
>>


Seems reasonable to me, applied!

Thanks,
Jes


