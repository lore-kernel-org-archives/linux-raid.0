Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0D2C636D6
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 18:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjBWSYL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 13:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjBWSYJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 13:24:09 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1CD4A1E4
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 10:24:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677176634; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=PIIH//S7pZWyDXu6v1p46Y0ffMRZpj1S0cOX7DKalXbgaJQvxASG/x3KbKh6f3zn+rpLmn8+J4tdPaNIVubyOnn/puZUZedrqpsZrcC0+CAYqlaWYR+AiQtDC/q97sGgKJHDn7jJe5mpcwt5KPnt+HYhlEki3ZDuKwDr/j8IX/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1677176634; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=0Mxwjv8xv0TE/kbDb/tB/6xoLFzkvdTeROSxfjdffxk=; 
        b=Jd3HvQDPHaoEKvmsI1C3lR5kpqhyNKTpF/G4wQ3R4LZ9CMo0fcQx5Uk94AqB7+Wr/CGCo7e2ElPKwSoe9+xzAawKHjdGYX7VK5zsUXKj7Rk/AaxSVvfDbH5uL68CLNCKLXYimgrHckTk75iZ3B6jx0suSGSDJin1rbJH40tTn6g=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 167717663173938.761650107313244; Thu, 23 Feb 2023 19:23:51 +0100 (CET)
Message-ID: <dc887716-1b95-709d-07b1-fe0c6ddbcfe0@trained-monkey.org>
Date:   Thu, 23 Feb 2023 13:23:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Grow: fix can't change bitmap type from none to
 clustered.
Content-Language: en-US
To:     Heming Zhao <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        ncroxon@redhat.com
Cc:     colyli@suse.de
References: <20230223143939.3817-1-heming.zhao@suse.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230223143939.3817-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/23/23 09:39, Heming Zhao wrote:
> Commit a042210648ed ("disallow create or grow clustered bitmap with
> writemostly set") introduced this bug. We should use 'true' logic not
> '== 0' to deny setting up clustered array under WRITEMOSTLY condition.
> 
> How to trigger
> 
> ```
> ~/mdadm # ./mdadm -Ss && ./mdadm --zero-superblock /dev/sd{a,b}
> ~/mdadm # ./mdadm -C /dev/md0 -l mirror -b clustered -e 1.2 -n 2 \
> /dev/sda /dev/sdb --assume-clean
> mdadm: array /dev/md0 started.
> ~/mdadm # ./mdadm --grow /dev/md0 --bitmap=none
> ~/mdadm # ./mdadm --grow /dev/md0 --bitmap=clustered
> mdadm: /dev/md0 disks marked write-mostly are not supported with clustered bitmap
> ```
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Applied!

Thanks,
Jes

