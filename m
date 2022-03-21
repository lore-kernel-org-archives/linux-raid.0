Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64CFC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Mar 2022 15:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349802AbiCUPIO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Mar 2022 11:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238929AbiCUPIN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Mar 2022 11:08:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F223F89CC1
        for <linux-raid@vger.kernel.org>; Mon, 21 Mar 2022 08:06:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B156E1F37C;
        Mon, 21 Mar 2022 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647875206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uO3vQVgv5azSDc0fXxwOezZz8Tj0JKg/emijxAvta9o=;
        b=r3baS/mEyitSsBpi7WpU7/OAY96JxZ84uyJ97eh3lP834DG+ZVidkNEsKPjtY2jNOiuMBh
        14JkNRZ2XpP3NaZm5i6aqfr9cnBGhm4OVh8FtIv7MmP+kaLyoxnaKpHVSNIbaT/1QIc3xb
        EBFXH7Y5hphzCALMlDvf20Nof3FffYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647875206;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uO3vQVgv5azSDc0fXxwOezZz8Tj0JKg/emijxAvta9o=;
        b=IuCUMNisobIOYHV+KNHQCfexhu6KH1PQVTcAksC1nx9dzyZi9p/qHziqb2/twAfOyMEgCk
        QjwkGeCATZgokoDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A982113419;
        Mon, 21 Mar 2022 15:06:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kF8/FoSUOGLJCgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 21 Mar 2022 15:06:44 +0000
Message-ID: <05a9f84a-dc44-12db-2520-186f1c4450cd@suse.de>
Date:   Mon, 21 Mar 2022 23:06:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 1/4] mdadm: Respect config file location in man
Content-Language: en-US
From:   Coly Li <colyli@suse.de>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
 <51ee6419-9ae4-04a5-1a69-e3fd1b9f0d04@suse.de>
 <20220321091458.00007c0c@linux.intel.com>
 <084cd90c-fada-072e-aade-079b577cf107@suse.de>
In-Reply-To: <084cd90c-fada-072e-aade-079b577cf107@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/21/22 10:54 PM, Coly Li wrote:
> On 3/21/22 4:14 PM, Mariusz Tkaczyk wrote:
>>
>>>
>> Hi Coly,
>> Could you please merge it to your master/for-jes branch then?
>
> Sure, I will do it.
>
> Just to confirm, for this situation, do you want me to add the patch 
> directly to for-jes branch with my Acked-by: tag, or you will post 
> another version with the Acked-by: tag?


BTW, just for your information, the patches acked by me are pushed to 
for-jes/20220321 branch of the mdadm-CI tree.


Thanks.


Coly Li

