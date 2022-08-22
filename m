Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D60C28D13
	for <linux-raid@archiver.kernel.org>; Mon, 22 Aug 2022 21:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238285AbiHVVoX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiHVVoS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 Aug 2022 17:44:18 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFFE12625
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 14:44:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661204645; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=IpfE6+e7YFEq6HgR3MDHGhcEcNo1WBeUEbFWc4/rzdvLx602ek4JJ5bayQmReRQw7F4WDaEQvQBXorTly3eZoVpdt8E+l6WPY5gikKbfwtT0TjtYiBO7qzDgGkg4JzI+zmoDtnobvke/KDZMtnhihVeKUcbSKS80fge3Izi6nJ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661204645; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ky3qDXd43/ir8qTIngu38btycPy5jnkTNahuYMRrx/c=; 
        b=S5j1a42y5t3mGx/RALLWG/mPqGuwvktpIgMI989msR8Rb+GWxrnyPsAEMhjkRfcPabyJYT3t/++ayIgSeYbe56RZVPcUtQlhhMsTHrWUTa5/qX6kae2PYER+GXSvppTbytu94y3zS1MjKwg1XHlEstib5ZzuaH8VESAN9ahnSvE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1661204642648609.6974438953048; Mon, 22 Aug 2022 23:44:02 +0200 (CEST)
Message-ID: <f8ae455b-72e6-bf76-0df4-a1d4a3d46ab0@trained-monkey.org>
Date:   Mon, 22 Aug 2022 17:44:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] mdadm: Replace obsolete usleep with nanosleep
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20220812143602.15338-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220812143602.15338-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/12/22 10:36, Mateusz Grzonka wrote:
> According to POSIX.1-2001, usleep is considered obsolete.
> Replace it with a wrapper that uses nanosleep, as recommended in man.
> Add handy macros for conversions between msec, usec and nsec.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Assemble.c    |  2 +-
>  Grow.c        |  4 ++--
>  Manage.c      | 10 +++++-----
>  managemon.c   |  8 ++++----
>  mdadm.h       |  4 ++++
>  mdmon.c       |  4 ++--
>  super-intel.c |  6 +++---
>  util.c        | 42 +++++++++++++++++++++++++++++++++---------
>  8 files changed, 54 insertions(+), 26 deletions(-)
> 

Applied!

Thanks,
Jes


