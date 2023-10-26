Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EFDC25B6E
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjJZVcT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjJZVcS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:32:18 -0400
X-Greylist: delayed 643 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Oct 2023 14:32:12 PDT
Received: from sender-op-o11.zoho.eu (sender-op-o11.zoho.eu [136.143.169.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F95DC
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698355924; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=aQvfZIKeuZiyedbjtcTl5R9h+15l2JnPxcMMM9UHTCZYjc+9Tcx/Dzz9FkYnmQXdDZG/bnpp/qHBJDfvwhsntWm+VUa1B6bC6pyh/XGspvNd+3z/xr1nCwebbEqtOc/oH7kvK1W95ErHuchmPlxONsCkckpBNtap65G1kr9idEI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698355924; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=xJACe4fQoOnAx6J0Fug3rNsBMaTr9j9+2uZcdnJ+sco=; 
        b=Fp62DetrJh2p3xZR+CGPji3cIioFbDsqUur+//5juOgerNxdBXxzuTb6/OBQhkdlpeVE4oK7u1ojDSKLxl+3ITzGgNaakaCE0fJ0cJ3nJSc7zF2VzilNUnq7w3Ntqo8dt4AEF/Zls1sfa/7S6NuQpE7tTbivSLph6A5/mwTCTg8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698355920373638.0346469042669; Thu, 26 Oct 2023 23:32:00 +0200 (CEST)
Message-ID: <ff7cc9e9-532b-5a23-cdb7-e6b4521a2004@trained-monkey.org>
Date:   Thu, 26 Oct 2023 17:31:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/6] mdadm: POSIX portable naming rules
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/1/23 03:27, Mariusz Tkaczyk wrote:
> Hi Jes,
> To avoid problem with udev and VROC UEFI driver I developed stronger
> naming policy, basing on POSIX portable names standard. Verification is
> added for names and config entries. In case of an issue, user can update
> name to make it compatible (for IMSM and native).
> 
> The changes here may cause /dev/md/ link will be different than before
> mdadm update. To make any of that happen user need to use unusual naming
> convention, like:
> - special, non standard signs like, $,%,&,* or space.
> - '-' used as first sign.
> - locals.
> 
> Note: I didn't analyze configurations with "names=1". If name cannot be
> determined mdadm should fallback to default numbered dev creation.
> 
> If you are planning release soon then feel free to merge it after the
> release. It is a potential regression point.
> 
> It is a new version of [1] but it is strongly rebuild. Here is a list
> of changes:
> 1. negative and positive test scenarios for both create and config
>    entries are added.
> 2. Save parsed parameters in dedicated structs. It is a way to control
>    what is parsed, assuming that we should use dedicated set_* function.
> 3. Verification for config entries is added.
> 5. Improved error logging for names:
>    - during creation, these messages are errors, printed to stderr.
>    - for config entries, messages are just a warnings printed to stdout.
> 6. Error messages reworked.
> 7. Updates in manual.
> 
> [1] https://lore.kernel.org/linux-raid/20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com/
> 
> Mariusz Tkaczyk (6):
>   tests: create names_template
>   tests: create 00confnames
>   mdadm: set ident.devname if applicable
>   mdadm: refactor ident->name handling
>   mdadm: define ident_set_devname()
>   mdadm: Follow POSIX Portable Character Set

Applied!

Thanks,
Jes


