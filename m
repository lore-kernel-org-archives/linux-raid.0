Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB24C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 15:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A5960F6F
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 15:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243077AbhJHPuQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 11:50:16 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17287 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhJHPuP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 11:50:15 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633708094; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ckIRJIYTKtMNh/wBg7mqR7roJA61D4H8YHSq3/n5FrNAWnGPYoAhvK0QWpZFyP2wM/JTEu6qEp8suu73smTPavk4jsG7XXW5NC6naanYdiDQfThCDlMunMcOaIU4KkZzhQqHK0zgExVzZr8wBFdIFNBmnLt9mIo8h0SxWG7Xv1s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633708094; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Qfs1AX8O9Gg6tBJhv5zFiC4zZu4Bhhy1dguVaiaFahc=; 
        b=lcze/uzoHPlVF4Cg7OdSlZd5uo+vs2HgyTJO1/xNj3emP6V6AGHaPXpEoP5KwKc0yq4+RZhTl4SWNYPBqmSdNnPei8ocxo573T4ospSHD9mZiTJkju/3s0RyzUvAJyCU6xrxWr9xRdtgQw8JJkJ7Q23hAZUopyn3hTIpUp1o/G8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 1633708092933620.2308115416417; Fri, 8 Oct 2021 17:48:12 +0200 (CEST)
Subject: Re: [PATCH V2] disallow create or grow clustered bitmap with
 writemostly set
To:     Nigel Croxon <ncroxon@redhat.com>, xni@redhat.com,
        linux-raid@vger.kernel.org, pg@mdraid.list.sabi.co.UK
References: <20210823124835.2516714-1-ncroxon@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <594ee538-ac08-99b4-09cc-d19739a94cef@trained-monkey.org>
Date:   Fri, 8 Oct 2021 11:48:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210823124835.2516714-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/23/21 8:48 AM, Nigel Croxon wrote:
> Do not support creating an MD array on a clustered system
> (--bitmap=clustered) and disks with the write mostly
> (--write-mostly) flag set.
> 
> Or do not grow an MD array on a non-clustered bitmap to a
> clustered bitmap with disks having the write mostly flag set.
> 
> The actual results is the MD array is created successfully.
> But the expected results should be a failure with an
> error message stating:
> Can not set --write-mostly with a clustered bitmap.
> and disks marked write-mostly are not supported with clustered bitmap.
> 
> V2:
> Added the device name in the error message during creation:
> mdadm -CR /dev/md0 -l1 --raid-devices=2 /dev/sda --write-mostly /dev/sdb --bitmap=clustered
> mdadm: Can not set /dev/sdb --write-mostly with a clustered bitmap.
> 
> Added the array name in the error message when growing:
> mdadm --grow /dev/md0 --bitmap=clustered
> mdadm: /dev/md0 disks marked write-mostly are not supported with clustered bitmap
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  Create.c | 9 +++++++--
>  Grow.c   | 5 +++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 

Applied!

Thanks
Jes

