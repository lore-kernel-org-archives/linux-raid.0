Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3BAC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 29 Sep 2022 15:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbiI2PM5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiI2PMz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Sep 2022 11:12:55 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B1D14C04C
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 08:12:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664464350; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=a5JpVfu7KEbSsW03ae4WQvbP6EswpB+sQ2BhbQ+tEX60D/ek6KP+ve/iOrnFD5NGHGWp38XUwTYiku74rcbkiM/tzn+8sdSYAcyoWT+dz32DftxZCKe21zjzCoyL7jzON8DMXPfsFh8HjFnPxRr8RotKdAyGSenHwa+yU2Mt2B4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1664464350; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Xzo3BZv/I2q2tzLSXUyRDxQjRB8o029XVNgbSvQvMQM=; 
        b=MBzYHMMCdnu6Xq7yNT4fFaho8BCaTmoYhnhnPL1IPIIAhpaL7hmfYN/7yflILIF8AyTJi97+9kz5v0AIVTrIJLMb7G9sFkFcAJQV1ZuEsGDM1FEf6RXF36TcPVmwbAsAtP7ixtkYcLP1fls51oQ33ctXBPTW0n0PCW52iMx+mhQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 166446434691161.018602625227686; Thu, 29 Sep 2022 17:12:26 +0200 (CEST)
Message-ID: <762a9ee5-0975-bd54-006c-237bf324855b@trained-monkey.org>
Date:   Thu, 29 Sep 2022 11:12:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] Mdmonitor: Omit non-md devices
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220922062950.9709-1-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220922062950.9709-1-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/22/22 02:29, Lukasz Florczak wrote:
> Fix segfault commit [1] introduced check whether given device is
> mddevice, but it happend to terminate Mdmonitor if at least one of given
> devices didn't fulfill that condition. In result Mdmonitor service was
> no longer started on boot (with --scan option) when config contained some
> non-existent array entry.
> 
> This commit introduces ommiting non-md devices so scan option can still
> be used when config is wrong and allow Mdmonitor service to run on boot.
> 
> Giving a list of devices to monitor containing non-existing or
> non-md devices will result in monitoring only confirmed mddevices.
> 
> [1] https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=e702f392959d1c2ad2089e595b52235ed97b4e18
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>

Applied!

Thanks,
Jes


