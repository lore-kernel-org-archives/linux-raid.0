Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118B7C433E6
	for <linux-raid@archiver.kernel.org>; Wed, 10 Mar 2021 14:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C490F64EFD
	for <linux-raid@archiver.kernel.org>; Wed, 10 Mar 2021 14:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhCJOuf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Mar 2021 09:50:35 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17145 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhCJOuU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Mar 2021 09:50:20 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615387813; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OwuPJPz25v4nLR8KBlDmzhL1znATgXZE2OAoLz1ARFK1GF7zGNeySK57N1oHGJgt1Y78bhNtXSMAstXGd0B0s1Qq7HkQRJ2JatJYHaONtSwOOH2bWcz5sKsImMXR3qsBPPGmgWSr46y1+FPkwy/6yGOcIqr3muYemNS4oEYc2mI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615387813; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=0YBP/Y/YWMPUoQQpzoO/2wPh813j6RnCTfHv+Tzxspg=; 
        b=WndvD5aZLEMnkoA0CT/8jc5EGcR2grlWZSOL4c7qXEilZX8c0kxbOStuKZ2U8o4h+LLU2IKZ12I+4/P5F3XbAqZQfGiTR0aQcO1KCH5Qp1afBlEh+nhf08+lQsfU7jtKkJOOryvkDn6wws1qvTVyuZoxQ0yF3+2oHDIooCED8wE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615387811343660.4328267967068; Wed, 10 Mar 2021 15:50:11 +0100 (CET)
Subject: Re: [PATCH 0/8] Write-intent bitmap support for IMSM metadata
To:     Jakub Radtke <jakub.radtke@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <f06f1162-f80f-0afb-13e1-00ffce758354@trained-monkey.org>
Date:   Wed, 10 Mar 2021 09:50:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/15/21 12:46 AM, Jakub Radtke wrote:
> This patchset is aimed to add write-intent bitmap support for IMSM
> metadata.
> 
> Additional function in the superswitch (set_bitmap) is proposed as
> a place where the internal bitmaps configuration for non-native
> metadata can be performed (through sysfs).
> 
> Adding the bitmap to existing volumes is implemented similarly like
> for the PPL functionality (through --update-subarray).
> 
> The patchset was tested on HW and qemu.

All applied, with a few minor tweaks to broken comment formatting.

Thanks,
Jes

