Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5729EC77B75
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 20:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjEHU3g convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 16:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbjEHU3f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 16:29:35 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546DF46B9
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 13:29:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1683577767; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=GyvVo9x5ECt30U60lzDq3QuHNcO0rUzLWfCYsiqmKR9eoLNc8htfAQwi/msZaNyXPOZEKndXo6Z6xhsTDwEnKFyXKYGwked5Ck0qgyUVq7YrOfYvHwJKZdz0ff9AX/6Ybb8X/BEBTj7lvFwBZggJGiaqS+0zsaY5+G4EAWM+ZZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1683577767; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=sr/27plaf0rZ9sNzQQXEB+0JH1UhYOssSrl+WL3Fm8s=; 
        b=QTKdOY3H03HQpFCDHNNcKOkqvrIMNwbFXk9Nz7D4iodZSveXxXmY8OJAmp+WrJqW2xgX0THav+kbGoJjFxHSG6rttX9hpKzcsbZsiLSMwxN4vwTd2QZ3ZtnNafMOw5bVuhuSFO+25bg9xkd3Uv95a0hQ/C2/IcpHmRPHIiZOXww=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 16835777647671020.4158336726314; Mon, 8 May 2023 22:29:24 +0200 (CEST)
Date:   Mon, 8 May 2023 16:29:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] enable RAID for SATA under VMD
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Kevin Friedberg <kev.friedberg@gmail.com>
Cc:     Kinga Tanska <kinga.tanska@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <20230216044134.30581-1-kev.friedberg@gmail.com>
 <CAEJbB426WWdu5KESE1T+T0JHSKx3CGjUcpdZ5yhppsxyXNJDvw@mail.gmail.com>
 <20230320093545.000016cc@linux.intel.com>
 <20230428093056.00006ca2@intel.linux.com>
 <CAEJbB41BxMdU1bYWAhHh8KLL2_P_M5DCJaDBt3f_YdphmpN4yQ@mail.gmail.com>
 <20230505094410.00001aa3@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <6cf7f181-99d9-f5f2-c443-b9572fa69477@trained-monkey.org>
In-Reply-To: <20230505094410.00001aa3@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/5/23 03:44, Mariusz Tkaczyk wrote:
> On Fri, 5 May 2023 03:31:11 -0400
> Kevin Friedberg <kev.friedberg@gmail.com> wrote:
> 
>> On Fri, Apr 28, 2023 at 3:31 AM Kinga Tanska
>> <kinga.tanska@linux.intel.com> wrote:
>>
>>> Hi,
>>>
>>> We've been able to test this change and we haven't found problems.
>>>
>>> Regards,
>>> Kinga  
>>
>> Great!  What are the next steps to get it included in a future release?
> See patchwork:
> https://patchwork.kernel.org/project/linux-raid/patch/20230216044134.30581-1-kev.friedberg@gmail.com/
> 
> I moved the patch to "awaiting upstream". Now it is up to Jes.
> You will get mail, like here:
> https://lore.kernel.org/linux-raid/5f493463-6e69-419f-affc-b0de8424fa1a@trained-monkey.org/

Applied!

Thanks Mariusz for reviewing.

Cheers,
Jes


