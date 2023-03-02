Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9C7C7EE2F
	for <linux-raid@archiver.kernel.org>; Thu,  2 Mar 2023 14:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjCBOyH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Mar 2023 09:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCBOyG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Mar 2023 09:54:06 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABAD11648
        for <linux-raid@vger.kernel.org>; Thu,  2 Mar 2023 06:53:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677768756; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Q4ZdX9Ev0H1hBxqp29olWu2PxYDc69wbAjSiy3IqaTRpd+eMvqIlzXCVRzoUUEZPt+mdjZetjhZX7v9nC874qUoP80xosbfvyM1l6iELAjSrZ/BckajGU9txXUN1KIQlcy4iQECLlHCqEMdCIJPDQ+ZKTjLNC3QjAYplItUEhKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1677768756; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=BEM+tJZboqvr5WPyPRu2vxjZM2Htkfw7xWH+38StKCE=; 
        b=itixK9ia5SgAomTergWnfNggC+kapRSRJjnHoJ7AhzgckJLCb4kgXKdg4a1RBu9jPs1TCuby6erON6wZP6LgFHxYoRoqLltmQOcEEAMkE4AR2KMAyJ/H9epZjOJtMtMj2zIbX585xNMeUnRAZ7MwkKS8V/YMYHQmNOt2CwWBwBQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1677768753168941.9479806427628; Thu, 2 Mar 2023 15:52:33 +0100 (CET)
Message-ID: <0017b6dc-b0c0-7d4e-4765-fcc429b41862@trained-monkey.org>
Date:   Thu, 2 Mar 2023 09:52:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/3] mdadm: refactor ident->name handling
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     colyli@suse.de, linux-raid@vger.kernel.org
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
 <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
 <bef57069-acdb-3a2f-b691-2c438c4247fb@trained-monkey.org>
 <20221229103931.00006ff0@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20221229103931.00006ff0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/29/22 04:39, Mariusz Tkaczyk wrote:

Hi Mariusz,

Apologies for the slow response on this one.

> On Wed, 28 Dec 2022 10:07:22 -0500
> Jes Sorensen <jes@trained-monkey.org> wrote:

>> I appreciate the work to consolidate duplicate code. However, I am not a
>> fan of new typedefs, in addition you return status_t codes in functions
>> changed to return error_t, which is inconsistent.
> 
> Hi Jes,
> Indeed, initially I named it as error_t and I forgot to update that part.
> I'm surprised that compiler didn't catch it. Thanks!
> 
> About typedef, I did it same for IMSM already:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super-intel.c#n376
> I can change that but I wanted to define a common solution propagated later to
> other mdadm parts.

I am really on the fence on this one. I'd very much like to see us get
away from the nasty 0/1/2 error codes we currently have all over the
place, but I am also vary of reinventing the wheel.

I must admit I missed it in super-intel.c

>> I would prefer if we move towards standard POSIX error codes instead of
>> trying to invent new ones.
>>
> 
> The POSIX errors are defined for communication with kernel space and
> unfortunately they are not detailed enough. For example "undefined" or
> just "general_error" statuses are not available.
> https://man7.org/linux/man-pages/man3/errno.3.html
> It the approach I proposed we are free to create exact errors we need.
> Later we can create a map of error values to string and create dedicated
> error print functions.

I agree that POSIX codes aren't perfect, however at least for the
current errors I see reported in this patch -EINVAL or -E2BIG ought to
cover. If you think there are many cases where we cannot map well to
POSIX, then I would be OK with it, but I would prefer to go straight to
a global error code space rather than one per subsystem.

Thoughts?

Thanks,
Jes
