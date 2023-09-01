Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7365CCA0FE5
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 16:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242107AbjIAQId (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbjIAQId (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 12:08:33 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D59CDD
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 09:08:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693584484; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=lJwmljF3ujcCrM0Z5bCEqaYXJF0BbD4ZEHDq7XdxPIqrxQtSNG0GGX/xPYw29WRZ6RDiBF7CcQYQcoe8CLlvJXFvOK8x418QOhmo0KpcJ9vNnv6pF8HEw5MI9zmf4KJWDT1AUjbI0DYnI3VkH582CBKESca6THJty8jGUbf+2Yw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693584484; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=2Pm+TSGi+Ew5iRFRr4uL6DYF5GUkd3XxPewUxvTrcNs=; 
        b=LQRmdmlYxtxxC0BDk+ghEhrDbMTHklFhqABpoT3ab6rejDRJcaMRcNSnApGIhTl5vxTPwYXgqzW7ETMcvC4pWzQmHwpSfg2WlbrdKlMcSm8GiQq7fKA0Me+V+PSCuufHxlGIZJ4hDctpjiJFi8CR1Fl3ViwHYCwh/JAVfkiqRDk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1693584481808227.8625548679904; Fri, 1 Sep 2023 18:08:01 +0200 (CEST)
Message-ID: <42664c9a-ba6c-e85b-731f-f217e24c8f2f@trained-monkey.org>
Date:   Fri, 1 Sep 2023 12:07:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/4] Fix memory leak for Manage Assemble Kill mdadm
Content-Language: en-US
From:   Jes Sorensen <jes@trained-monkey.org>
To:     Guanqin Miao <miaoguanqin@huawei.com>,
        mariusz.tkaczyk@linux.intel.com, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
Cc:     linfeilong@huawei.com, lixiaokeng@huawei.com,
        louhongxiang@huawei.com
References: <20230424080637.2152893-1-miaoguanqin@huawei.com>
 <bbafe9cc-dbd1-c503-c294-aec9dbd4dccb@trained-monkey.org>
In-Reply-To: <bbafe9cc-dbd1-c503-c294-aec9dbd4dccb@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/1/23 12:02, Jes Sorensen wrote:
> On 4/24/23 04:06, Guanqin Miao wrote:
>> When we test mdadm with asan,i we found some memory leaks.
>> We fix these memory leaks based on code logic.
>>
>> Guanqin Miao (4):
>>   Fix memory leak in file Assemble
>>   Fix memory leak in file Kill
>>   Fix memory leak in file Manage
>>   Fix memory leak in file mdadm
>>
>>  Assemble.c | 13 +++++++++++--
>>  Kill.c     |  9 ++++++++-
>>  Manage.c   | 11 ++++++++++-
>>  mdadm.c    |  4 ++++
>>  4 files changed, 33 insertions(+), 4 deletions(-)
>>
> 
> I applied this, modulo a fix to the Manage fix, where it would try to
> call free(tst) in the abort path, before tst was initialized.

Oh and a fix to Assemble where free(st) would goto loop and then
dereference st.

Jes


