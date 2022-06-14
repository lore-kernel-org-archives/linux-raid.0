Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835C6CCA47A
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 14:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245372AbiFNOio (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350175AbiFNOiR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 10:38:17 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB672ED79
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 07:38:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1655217443; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OVxxtnWac7OdleBD13xgYrG5PUX7jmAOO9Yoljn1BerU9maTNIxnfgz4pMXhaMTL0jzB3ZIqnEfXF1eRXbKQn6D2mdGt44GJD4iL7xnH3mXuAbyj1JT5SmaO5OSavjIOYR43SI0sHNGhc+FVZRIlMtrVluQ0fkXy6l8atJrgrG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1655217443; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=zUndF6z1MLav/dpjcM6e1RU6NwuS38+Cue8m/hkUkiw=; 
        b=LwIYGyR1dDeDqnH8FZ+Ps/v3eQpdAGn+1kAeN4eOofa6J4c/ITIMXBCmcXTDsFeuJ+w8Vve5rDCY8p+VSSI7+pWPDOtrw7lD3GOwiIReo0bEaxFynZEv85E/L8jJWqT0UNO3/onDOil8zcxcLtU9xUXTPxgXbpE4TCgl3cUterM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [IPV6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1655217442025513.25933484457; Tue, 14 Jun 2022 16:37:22 +0200 (CEST)
Message-ID: <e90d6d40-a956-f855-d8cd-6df42a3f9640@trained-monkey.org>
Date:   Tue, 14 Jun 2022 10:37:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 1/2] Mdmonitor: Fix segfault
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, pmenzel@molgen.mpg.de
References: <20220606103213.12753-1-kinga.tanska@intel.com>
 <20220606103213.12753-2-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220606103213.12753-2-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/6/22 06:32, Kinga Tanska wrote:
> Mdadm with "--monitor" parameter requires md device
> as an argument to be monitored. If given argument is
> not a md device, error shall be returned. Previously
> it was not checked and invalid argument caused
> segmentation fault. This commit adds checking
> that devices passed to mdmonitor are md devices.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Monitor.c | 10 +++++++++-
>  mdadm.h   |  1 +
>  mdopen.c  | 17 +++++++++++++++++
>  3 files changed, 27 insertions(+), 1 deletion(-)
> 

Applied!

Thanks,
Jes


