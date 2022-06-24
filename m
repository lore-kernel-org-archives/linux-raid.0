Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB38C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 18:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiFXS1N (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 14:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFXS1L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 14:27:11 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4E4792B4
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 11:27:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso3574613pjh.4
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 11:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=fbmg9rSNvYIucCnYxvakDdVCwhbLRfv3lwcuA/iL7Lw=;
        b=gOvnaBXOmuieipHWD9T5k8mIp0uv4GwLjd5SyCS+G9cZkRnYEGi8gXqqhN4rHMHcdm
         PvzTtsueVi9GJU6qC9oVLtJUM6FnDMl8LDdjxk55f+rt/mlVbcvnj80yzbAK/wBDcIeh
         6B+B06K8kXRjalK5EhAvvrneUw+3iLCpqefFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=fbmg9rSNvYIucCnYxvakDdVCwhbLRfv3lwcuA/iL7Lw=;
        b=q66kETNZDnwAhXLzbzezGrqIrNcTRwMUH9ByakV+TVQ4n6f03RWODshte/n5QbZ618
         pyaG7/r1f4AxYp7I5kMjWZjeIOnB5xc9zxsh3Q6Y0ZVlKNm95ofAxsho3Iu9ynaysZhc
         MpLGttVEY/uC6PVSQ2gkzELPx2EyyDKSsHf+SGgDpmfPeb289IXMOWHXguVjIlCVDSrL
         L/PrGcB9PSwi+z+66XaCBlki3Oy8DN0hkrjXfXd6NFd1HxuTRLmQO+EF8ttOXb9Cr60h
         u24+yb5zH+yochfLo6hIqX8d/bi9lyBejdMgV0CG8yAShmWa6oq1E80k2EMPDN0/EkfR
         J/6g==
X-Gm-Message-State: AJIora8dtqRzEV5cwB46p9lg0pH1PSGHHuLP+5EUtYwUdKE/qG3cdQpd
        /wZicNkoZ6SjWdcPoZgQllMClNe19zmVjvJl
X-Google-Smtp-Source: AGRyM1vmhUwVgXKqFwPXBNPXRpaz9vNMfVYb2/avGd01QHGlMm68j1Cfrye9bdWHmpzoU/y0dSbHRQ==
X-Received: by 2002:a17:902:cecc:b0:16a:416c:3d14 with SMTP id d12-20020a170902cecc00b0016a416c3d14mr361921plg.73.1656095229662;
        Fri, 24 Jun 2022 11:27:09 -0700 (PDT)
Received: from [134.114.109.180] ([134.114.109.180])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902e54100b00168adae4eb2sm2137782plf.262.2022.06.24.11.27.09
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 11:27:09 -0700 (PDT)
Message-ID: <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
Date:   Fri, 24 Jun 2022 11:27:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
From:   Alexander Shenkin <al@shenkin.org>
Subject: Upgrading motherboard + CPU
In-Reply-To: <20220624232049.502a541e@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi all,

I have 1 RAID6 (root) and 1 RAID1 (boot) array running across 7 drives 
in my Ubuntu 20.04 system.  I bought a new motherboard and CPU that I'd 
like to replace my current ones.  In non-raid systems, I get the sense 
that it's not a very risky operation.  However, I suspect RAID makes it 
more tricky.  Wondering if anyone can offer any advice here?  Do I have 
to make sure sata cables are plugged into corresponding ports in the new 
motherboard?  etc.  Many thanks in advance.

Allie
