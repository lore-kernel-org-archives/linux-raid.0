Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10961C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 26 Jun 2022 15:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiFZPoK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Jun 2022 11:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiFZPoJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Jun 2022 11:44:09 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE79B863
        for <linux-raid@vger.kernel.org>; Sun, 26 Jun 2022 08:44:09 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r66so6900542pgr.2
        for <linux-raid@vger.kernel.org>; Sun, 26 Jun 2022 08:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=5+eLIaiILnZak7pns1R8hAEzAVTaqDv/NUQwE4vtoEw=;
        b=d7Rkh2kWokx6F8ou3+NdVtRb/GOWs/r87eB4C9hS8wZnPe9kSHLYQBhB8h2IjcAV80
         NTNiMHNA+dfRFVUhtMKEDviV91pKOOmxEzAwsoPdmDzftIOTn+JNxcklVhOqgE1bfIox
         TbbC8aQHG4nI0aEQLzafD0iT3eSlCV4W5qfds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=5+eLIaiILnZak7pns1R8hAEzAVTaqDv/NUQwE4vtoEw=;
        b=C66IenUIP4IBgdgPX6G8AtD0N4Z0ZGjSIhk2I/ror3qOxss7jnMS7xX5pzJXcRV/Os
         /WoWKYvTSg4nuW3nos26YEqNUT8zfj0SFKy/oX8fjKFTIzk+iPDdfBRD5q7XGJsKDAMl
         6djljneTsfMZFkUhvXNIWWTsIRn5C9vgNIlY8wjzFlUCGk/reB9zNHT8VeTu6pUoNwAK
         6adU6pIYv6m32LMy0x1kEi/EUEJQuM6KFFN2YI2ENZLOum9vIoxzj0yg/og6t8+p7GgM
         OP6lyJtbZ/DC/Ex0oTpwQzvWeR01k9riIR7MHNIpZVjFW9LepPNiYrySJrvpZ9uS+bPu
         DfbA==
X-Gm-Message-State: AJIora/dwb6rRO+Gz0OHwH8+y4xLWJec2A19mgcu9WdA0xwupvs21uPm
        BdsmqSQZbaEOd1ngwfST7VgWpamBmkCtLRU0
X-Google-Smtp-Source: AGRyM1si6arXdw9VVvAUuXg0tNw5I9PI0ZFGnlV24GsPSdZEjtgvLHwKtu22zCnTZXLdtiV+NfRzrA==
X-Received: by 2002:a63:194c:0:b0:408:a9d1:400c with SMTP id 12-20020a63194c000000b00408a9d1400cmr8592671pgz.559.1656258248821;
        Sun, 26 Jun 2022 08:44:08 -0700 (PDT)
Received: from [192.168.1.243] ([47.215.181.107])
        by smtp.googlemail.com with ESMTPSA id e14-20020a170902ef4e00b0016a275623c1sm5351916plx.219.2022.06.26.08.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 08:44:08 -0700 (PDT)
Message-ID: <3dedb344-7f0e-b82f-fe7f-ca56c42ecac4@shenkin.org>
Date:   Sun, 26 Jun 2022 08:44:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
From:   Alexander Shenkin <al@shenkin.org>
To:     Roger Heflin <rogerheflin@gmail.com>,
        Roman Mamedov <rm@romanrm.net>
Cc:     Reindl Harald <h.reindl@thelounge.net>,
        Wols Lists <antlists@youngman.org.uk>,
        Stephan <linux@psjt.org>, Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
 <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
 <20220624234453.43cf4c74@nvm>
 <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
 <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
 <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
 <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
 <20220625030833.3398d8a4@nvm>
 <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
 <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
 <a16b44a7-ae37-7775-24c8-436dcbe69ae8@shenkin.org>
 <cb10aa14-3a52-740c-4f6b-d7816cb31155@youngman.org.uk>
 <414a502b-dffd-d4cc-4eaa-579589877cee@shenkin.org>
 <6257be2f-212f-72ed-228c-324253910666@thelounge.net>
 <20220626034554.4bfe7388@nvm>
 <CAAMCDecEd1po2WpGT_SyimkJLoitRL-=RxKgDdsFA0LX7=2QuQ@mail.gmail.com>
 <c9897e26-a919-f594-55f3-f3256ceb9f87@shenkin.org>
In-Reply-To: <c9897e26-a919-f594-55f3-f3256ceb9f87@shenkin.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 6/26/2022 8:34 AM, Alexander Shenkin wrote:
> So, any idea how to disable hostonly?  I'm not finding it via google...

I should mention that /etc/dracut.conf doesn't exist on my system, and 
the dracut pacakge (if it is a package) doesn't show up in apt list, so 
I'm assuming it's not installed.  Does that mean I don't have hostonly 
installed?
