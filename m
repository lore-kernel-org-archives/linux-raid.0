Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7550BC001B0
	for <linux-raid@archiver.kernel.org>; Mon,  7 Aug 2023 21:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjHGVRy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Aug 2023 17:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjHGVRx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Aug 2023 17:17:53 -0400
X-Greylist: delayed 904 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Aug 2023 14:17:52 PDT
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4A11BC
        for <linux-raid@vger.kernel.org>; Mon,  7 Aug 2023 14:17:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1691442159; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=XYw8orj/QCeg23VqHzcYC5Ey/pLZGk76NO9/iFHuN9y2+e9cE6TdFX3swcV853f70s0O8raCuLbLjTpUkjx5lwTvgzmNxcrFWLqVjNTIKH41JaI7KFif23RcL9ZVRYioVM/kix20emYgkstcgDQnT3sU/U5UheJIBel1PWHcDyQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1691442159; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gpDqOnZZcuyUJyRYdkY94peZ8dKJOMMGm4M0n1Uw+cA=; 
        b=bE1wDnwLVh3OmGnA366QgiwyjLG8w6H2qJ1295m4LdCFp8GbGGB9+ADMMiqAGp6NSEIAEnQdWF3syoNQrtXBr1CetMBuRFm4r783dkawDoABontPS+L06a3FxdQlArCAMFz8o+SBBl7GZdosYBb8j9hezQmVC5MxM6IDiqm5QrU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1691442156063898.1849532229709; Mon, 7 Aug 2023 23:02:36 +0200 (CEST)
Message-ID: <edb6432e-ed7c-dff6-2c63-a119b9254fcb@trained-monkey.org>
Date:   Mon, 7 Aug 2023 17:02:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] imsm: Fix possible segfault in check_no_platform()
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20230705143456.20462-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230705143456.20462-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/5/23 10:34, Mateusz Grzonka wrote:
> conf_line() may return NULL, which is not handled and might cause
> segfault.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  super-intel.c | 5 +++++
>  1 file changed, 5 insertions(+)

Applied!

Thanks,
Jes


