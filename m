Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E87EE49A0
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 06:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjHWGA5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Aug 2023 02:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjHWGA4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Aug 2023 02:00:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25CAA1
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 23:00:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 84AC31F390;
        Wed, 23 Aug 2023 06:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692770453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LhmNe8FjKiJ59bjsZEF6V7vA6fMZCeg+fS8vTCGBoII=;
        b=ZkXGFWSRVwNrHeoMiT3z7sDGcVhzUg5cX5S3yCjpA/EXkYgZmB/SMIfnSmGb5doq5lNRKF
        20fbFBqCtO/Rp/25RaVuxrWeleudeRUycFfJXezOsM+GIRjVxBpr+SiyBhdIUlFY77Hz9P
        vuvYW6ETYmkkiwFQNCjzRhUNMet/Pck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692770453;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LhmNe8FjKiJ59bjsZEF6V7vA6fMZCeg+fS8vTCGBoII=;
        b=lOX1vrgWcQjOyksmlRnQwrf07lUR2lDChtsZWZ28Xu8BCKTQylFp+ggN1UQKItwD1zvK32
        lXUi3DJDQwelE/Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C7E413458;
        Wed, 23 Aug 2023 06:00:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Dzd4EZSg5WQxGgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 23 Aug 2023 06:00:52 +0000
Message-ID: <9106ad75-8c58-9edb-d066-e5ee332907d3@suse.de>
Date:   Wed, 23 Aug 2023 08:00:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: libsed in mdadm
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Xiao Ni <xni@redhat.com>,
        Paul E Luse <paul.e.luse@linux.intel.com>,
        Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org
References: <20230821161604.000048c7@linux.intel.com>
 <24acd8dc-e3c6-cfb1-3fba-42d1d0699b39@trained-monkey.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <24acd8dc-e3c6-cfb1-3fba-42d1d0699b39@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/22/23 22:54, Jes Sorensen wrote:
> On 8/21/23 10:16, Mariusz Tkaczyk wrote:
>> Hello,
>> IMSM/VROC is going to support self-encrypted drives. With this feature you need
>> to unlock the drives during boot-up in UEFI first. It is kind of protection
>> from physical stealing.
>>
>> To ensure security, Linux have to respect that. It means that we need to
>> determine if the drive support locking and do not allow to mix locked and
>> unlocked drives in one IMSM array.
>>
>> To grab that information we will need to impose the "magic commands" to the
>> drives. There is a libsed library, designed for such purposes:
>> https://github.com/sedcli/sedcli
>>
>> So far I know, this library is not released under distributions (not handled by
>> package managers) and that will bring not user friendly dependency- you will
>> need to compile and install the lib first to build mdadm.
>>
>> The sedcli project is maintained in Intel, currently it is not in active
>> development but there are no plans to drop it, interest around it is growing as
>> you can see. It seems to be great opportunity for this project to
>> become integrated with mainstream distributions when mdadm will start to
>> require it.
>>
>> So, my questions are: Are we fine with adding this dependency? Are there big
>> cons you see?
>> Obviously, I will make it optional like libudev is.
>>
>> I can try to re-implement the functionality I need in mdadm but it is like
>> reinventing the wheel.
>>
>> Any feedback will be appreciated.
> 
> Hi Mariusz,
> 
> I am not against adding it to mdadm, though I think a better approach is
> to try and get the library built as a package for the distros.
> 
> Did you look into that yet?
> 
We (as in 'We as an OS distributor') actually evaluated packaging libsed 
some time ago, but decided against it as the original authors (namely 
Intel) apparently disbanded it. So before adding it to a distro there 
needs to be an active maintainer, and one would be looking to Intel here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

