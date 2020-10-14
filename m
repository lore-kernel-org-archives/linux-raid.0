Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8290C43457
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F2A2222C
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgJNPa6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:30:58 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17399 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgJNPa6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:30:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602689454; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DFm21rvGWlI+2LHZvneKW+aes8Q0NY4NBPmShgUEohNjj41KzC1rIH76x3Kkky17ioPuRNPYNs+e44CDTkYqMFJb3H5voBSLUnL+VfyFnV+UW3YtUaxVyq0vWSHsWwLStPGk19h9wmKfv/JK7CdUd1C+IZpmWqzpB1KBiOzF4V4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602689454; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=vfsLbd4M0k7IldGd2kegn3lNaOXNFeUjapDbK+N8ilY=; 
        b=KG0grbBpb6jYIkkW3kEIILPDYV6wYnhv7d1F+4QuOZ3OkKBstJUowVLLUVc38mZzXewK2e1OlA75/+7Jw4hBJpnRlLooJ1go9/mwcjGteavoB4jk5y7LXNNSlVvpKNtSzYtG79rBf6VizeS590k0UdioKaPeu9Zhk2fAFvJYZ98=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602689453329980.5003294876841; Wed, 14 Oct 2020 17:30:53 +0200 (CEST)
Subject: Re: [PATCH 0/4] mdmonitor improvements
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
 <SA0PR11MB454223C46AAB3F629BEEC22CFF320@SA0PR11MB4542.namprd11.prod.outlook.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <07e08c65-b7a7-e42e-4d3d-45e8e296cbf5@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:30:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <SA0PR11MB454223C46AAB3F629BEEC22CFF320@SA0PR11MB4542.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/29/20 10:34 AM, Tkaczyk, Mariusz wrote:
> Hi Jes,
> Do you receive whole patchset?
> If not let me know. I will send it again.
> I don't know why two patches were lost, I cannot find them anywhere on linux-raid.
> 
> Thanks,
> Mariusz

Hi Mariusz,

I got four patches. Sorry I have been completely swamped with other
stuff at work the last couple of months, so I have gotten behind on this.

I'll try and go through them now.

Thanks,
Jes

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org <linux-raid-owner@vger.kernel.org> On Behalf Of Mariusz Tkaczyk
> Sent: Wednesday, September 9, 2020 10:31 AM
> To: jes@trained-monkey.org
> Cc: linux-raid@vger.kernel.org
> Subject: [PATCH 0/4] mdmonitor improvements
> 
> This patchset is targeting issues observed across distributions:
> - polling on a wrong resource when mdstat is empty
> - eventing for external containers
> - dealing with udev and mdadm
> - quiet fail if other instance is running
> 
> Mdmonitor is started automitically if needed by udev. This patchset introduces mdmonitor stoping if no redundant array presents.
> 
> Blazej Kucman (2):
>   mdmonitor: set small delay once
>   Check if other Monitor instance running before fork.
> 
> Mariusz Tkaczyk (2):
>   Monitor: refresh mdstat fd after select
>   Monitor: stop notifing about containers.
> 
>  Monitor.c | 83 ++++++++++++++++++++++++++++++++++++++++---------------
>  mdadm.h   |  2 +-
>  mdstat.c  | 20 +++++++++++---
>  3 files changed, 77 insertions(+), 28 deletions(-)
> 
> --
> 2.25.0
> 

