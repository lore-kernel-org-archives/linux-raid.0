Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15321C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  7 Mar 2022 18:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244562AbiCGSV7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Mar 2022 13:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiCGSV6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Mar 2022 13:21:58 -0500
X-Greylist: delayed 306 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Mar 2022 10:21:03 PST
Received: from titan.nuclearwinter.com (titan.nuclearwinter.com [IPv6:2603:c020:4000:e500::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EDE811AC
        for <linux-raid@vger.kernel.org>; Mon,  7 Mar 2022 10:21:02 -0800 (PST)
Received: from [10.0.0.102] (unknown [10.0.0.102])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by titan.nuclearwinter.com (Postfix) with ESMTPSA id 585D4A69EC
        for <linux-raid@vger.kernel.org>; Mon,  7 Mar 2022 13:15:55 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com 585D4A69EC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1646676955;
        bh=Wb4aGCUPTDpENRzFvthEvjPF8P898mGLG1VWAp2kowc=;
        h=Date:To:From:Subject:From;
        b=LAidNKZQJiwYlm2TOIfDMzGL9f3TKirudL7yflqjpko7ZlI7ML9pd12p2E6b9+pqt
         jp3iA7v1ZJL9CgKkPqzbcR4+IwS42IehIwrV9tuidnoZajlKCncZwTaiyoXVI9rCBi
         KH1Ib0cGa1g57JX8ISmDxgw+pkMmewRjFVhQolLw=
Message-ID: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
Date:   Mon, 7 Mar 2022 13:15:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To:     linux-raid <linux-raid@vger.kernel.org>
Content-Language: en-US
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Raid6 check performance regression 5.15 -> 5.16
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I am seeing a 'check' speed regression between kernels 5.15 and 5.16. 
One host with a 20 drive array went from 170MB/s to 11MB/s. Another host 
with a 15 drive array went from 180MB/s to 43MB/s. In both cases the 
arrays are almost completely idle. I can flip between the two kernels 
with no other changes and observe the performance changes.

Is this a known issue?

--Larkin
