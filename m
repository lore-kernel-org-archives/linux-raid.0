Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F176C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  5 Oct 2021 15:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77AD461186
	for <linux-raid@archiver.kernel.org>; Tue,  5 Oct 2021 15:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbhJEPDu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Oct 2021 11:03:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34018 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbhJEPDu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Oct 2021 11:03:50 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BE1D11FE66;
        Tue,  5 Oct 2021 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633446118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vReLn03fAWBptLwyepcNiFCz5lmv8+ZXZOfrwzQ/HQU=;
        b=2MCPcjp68wJzsnlPD4wkMsKEHCv2RI4Px5LxJFf2akYr5oa4CxR0wl3hwsKc72k//jQbrK
        NsYYrnI3m3p5gW72BzKEvEAmN+Ztyxmc1ODJdlVNf3Gp4/KZo8rkEdxv9OR6Vz2yd0MMMz
        8WkaqXmK3vOt8vP2OJpTeqv6vI6mHcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633446118;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vReLn03fAWBptLwyepcNiFCz5lmv8+ZXZOfrwzQ/HQU=;
        b=RdZ1BhQgsUmpjzhxvQzHkrYXPVxa6EcspLBjBZc42Rqep/ZCAvbqEJq7WamglDgAOWtf3y
        MfjWOJWeCiIiX7AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C53F13D1D;
        Tue,  5 Oct 2021 15:01:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 805eNuRoXGG0OwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 05 Oct 2021 15:01:56 +0000
To:     Jes Sorensen <jsorensen@fb.com>, jes@trained-monkey.org
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        "hare@suse.de" <hare@suse.de>, pmenzel@molgen.mpg.de,
        linux-raid <linux-raid@vger.kernel.org>
From:   Coly Li <colyli@suse.de>
Subject: The mdadm maintenance
Message-ID: <c27798e0-dc8b-7058-4347-732d7162f011@suse.de>
Date:   Tue, 5 Oct 2021 23:01:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

As Paul and Mariusz suggested, I post this email for your opinion.

 From the recent communication on linux-raid mailing list, I know and 
fully understand you are too busy to take care mdadm and response other 
developers in time. I'd like to help to maintainer mdadm project if you 
are glad to. I am very happy with my current job and employer, it is 
very probably I can be stable on the maintenance role for quite long 
time before I am retired (maybe 20+ years if I may live that long time).

So if you feel it works, and other folks on linux-raid being supportive, 
I'd like to take the maintenance of mdadm and keep things moving 
forward. Now I am bcache (linux/drivers/md/bcache/) maintainer of 
upstream Linux kernel, and SUSE internal md raid and mdadm maintainer. 
Taking care of mdadm can be my daily regular job for quite long time.

Thanks in advance for your response.

Coly Li

