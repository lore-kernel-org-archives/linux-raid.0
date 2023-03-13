Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51343C6FD19
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 14:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjCMOXO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Mar 2023 10:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCMOXN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Mar 2023 10:23:13 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A69E125A1
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 07:23:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1678717371; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=E7U9HMja6Z15cFZtanoG2U1uq/GLBgewkkM9MawxrAb6ufeCL3AtrkxizL/4NgXFVqJRrRyZQ99E72FhTiPYlnYSgSHh60kE0woIbyqm0UReoCwJuKkKvTSd5Lzqx3SjjV1LF3nt+LcLgMBedz0wXDImMVz2psEEjt1F1TBgz3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1678717371; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+lTf4+YVyIIc98NGiq3d4cv8/Q3dtI8HUrSI+B/ZWcs=; 
        b=UAUUGZ1JehgJPqPtZXlBNDu00BBzXbXgLIocjqNQ2RYyto/LeS1iv5cNbBTCpHyyvvCWH49H995xGtY3BnfBe6KD+hd2J+3kQA0le5U/oDFqJV5ZA3jQqRsaLkTsAr9uQn/UoFiPCqIkznbQV+rDer5xHu/pfBbfDHeY+G9Cnpg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1678717368950268.8453437202942; Mon, 13 Mar 2023 15:22:48 +0100 (CET)
Message-ID: <6ee775b9-291a-a2e7-1b30-3fc8e103e60d@trained-monkey.org>
Date:   Mon, 13 Mar 2023 10:22:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 3/3] Limit length and set of characters allowed of devname
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
 <20221221115019.26276-4-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20221221115019.26276-4-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/21/22 06:50, Mariusz Tkaczyk wrote:
> When the user creates a device with a name that contains whitespace,
> mdadm timeouts and throws an error. This issue is caused by udev, which
> truncates /dev/md link until the first whitespace.
> 
> This patch introduces prohibition of characters other than A-Za-z0-9.-_
> in the device name. Also, it prohibits using leading "-" in device name,
> so name won't be confused with cli parameter.
> Set of allowed characters is taken from POSIX 3.280 Portable Character
> Set. Also, device name length now is limited to NAME_MAX.
> 
> In some places there are other requirements for string length (e.g. size
> up to MD_NAME_MAX for device name). This routine is made to follow POSIX
> and other, more strict limitations should be checked separately.
> We are aware of the risk of regression in exceptional cases (as
> escape_devname function is removed) that should be fixed by updating
> the array name.
> 
> The posix validation is added for:
> - 'name' parameter in every mode.
> - secondary device name (first devlist entry), only for create and
> assembly.
> 
> To limit regression risk, config entries are excluded from POSIX
> validation.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Hi Mariusz,

This no longer applies cleanly. Any chance you can post an updated version?

Thanks,
Jes


