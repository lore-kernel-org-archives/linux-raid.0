Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9880EC433FE
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 15:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbiAEPMN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 10:12:13 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17029 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiAEPMK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jan 2022 10:12:10 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1641395513; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=lKvwdUVoXmCc6xQlc/cfxf1OYb/eDoA+NCXxDVWZDQK8iSIv/K/b3rCtf0yTCV/Q4jRwfFpGIptrEXJDdK/DO/9K1Bzd9gWh1YPXfCuLp34i4JV7lc//c6TYIiQEPbuZ8+1HooFoCCtr7mRUxj4++XBL7D3MkzOWx3wzio425no=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1641395513; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=e1cRLn73QF+A2HlQ0CJEH3W0ionVGSidcg5LBcMYaso=; 
        b=knNLO3Wfdxvb6VSMyJoic2/5we7yen3fUWR87RfDYIQGFPHFw23FNAJzR64GbtyhqKbEjQt8EoQLoUMIJ44ry4M1ZDUGNwtPj0HGoglbnCKdWMXS71DrXA+Q7ftycwUg5MB2NWhf4GxRrX7dZddYY36Xvxep6Y1rFGWU9t3APB8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1641395511702731.7104332553096; Wed, 5 Jan 2022 16:11:51 +0100 (CET)
Subject: Re: ANNOUNCE mdadm-4.2
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
References: <28fdbc45-96ca-7cdb-3ced-a5f65d978048@trained-monkey.org>
 <20220105112124.00006a92@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <fa69622a-9d2a-43f0-1604-40b41388e44a@trained-monkey.org>
Date:   Wed, 5 Jan 2022 10:11:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20220105112124.00006a92@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/5/22 5:21 AM, Mariusz Tkaczyk wrote:
> On Thu, 30 Dec 2021 14:52:44 -0500
> Jes Sorensen <jes@trained-monkey.org> wrote:
> 
>> Hi,
>>
>> Finally here it is, mdadm-4.2. Thanks for all the contributions and
>> your patience.
>>
>> Happy New Year everyone!
>>
>> Jes
>>
>> From the announce file:
>>
>> I am pleased to finally announce the availability of mdadm-4.2.
>> get 4.2 out the door soon.
>>
>> It is available at the usual places:
>>    http://www.kernel.org/pub/linux/utils/raid/mdadm/
>> and via git at
>>    git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
>>    http://git.kernel.org/cgit/utils/mdadm/
>>
> 
> Hi Jes,
> I can see a tarball in the first link but I cannot find 4.2 tag in git:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
> 
> Could you push the tag to repository?

Hi Mariusz,

Looks like I forgot to do that. Should be uptodate now.

Thanks,
Jes

