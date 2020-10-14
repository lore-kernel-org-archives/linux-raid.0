Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204CBC433E7
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B71E42222A
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgJNPfM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:35:12 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17311 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729318AbgJNPfM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:35:12 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602688802; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=PKYGPYemajCFz4l+6oSN0zLch35HKmLFwi9ovhSKBbb7aLpGRrTsLzeCSRhQSwUaHiHxiE6mBDWJaYhO440c+Jd17IRdlCxzCC2cnx1QitLTNrwqrmF6kbSH1ccIFUIako63tvCY/onJln591jr4nj2hMlvrVRLs6Smhp+08w30=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602688802; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=/YXwRl5BPdPhzIUiJTIQ86CeZtJSPUbl+Ggyn/u9kBA=; 
        b=AvCljuxCKTXsa0/RCD/TjhUfcMWo1jRTJQqpvP779PDXmnTuOmlIex4IgIBLUcNBLyEmixvINKmOgg1Thq+NbTrmhTqURNk4vKecodKOko2iIUbvG7w9xKjNegGV5O/YCHRL6D0do93rQb4XzElnvEMqks6YbwldKjSHbMcO7/0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602688800965861.1750237922348; Wed, 14 Oct 2020 17:20:00 +0200 (CEST)
Subject: Re: [PATCH v2] Detail: show correct raid level when the array is
 inactive
To:     Lidong Zhong <lidong.zhong@suse.com>
Cc:     linux-raid@vger.kernel.org
References: <20200914025218.7197-1-lidong.zhong@suse.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <48f8cd25-d872-e306-a544-e31c59d91c9b@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:19:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914025218.7197-1-lidong.zhong@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/13/20 10:52 PM, Lidong Zhong wrote:
> Sometimes the raid level in the output of `mdadm -D /dev/mdX` is
> misleading when the array is in inactive state. Here is a testcase for
> introduction.
> 1\ creating a raid1 device with two disks. Specify a different hostname
> rather than the real one for later verfication.
> 
> node1:~ # mdadm --create /dev/md0 --homehost TESTARRAY -o -l 1 -n 2 /dev/sdb
> /dev/sdc
> 2\ remove one of the devices and reboot
> 3\ show the detail of raid1 device
> 
> node1:~ # mdadm -D /dev/md127
> /dev/md127:
>         Version : 1.2
>      Raid Level : raid0
>   Total Devices : 1
>     Persistence : Superblock is persistent
>           State : inactive
> Working Devices : 1
> 
> You can see that the "Raid Level" in /dev/md127 is raid0 now.
> After step 2\ is done, the degraded raid1 device is recognized
> as a "foreign" array in 64-md-raid-assembly.rules. And thus the
> timer to activate the raid1 device is not triggered. The array
> level returned from GET_ARRAY_INFO ioctl is 0. And the string
> shown for "Raid Level" is
> str = map_num(pers, array.level);
> And the definition of pers is
> mapping_t pers[] = {
> { "linear", LEVEL_LINEAR},
> { "raid0", 0},
> { "0", 0}
> ...
> So the misleading "raid0" is shown in this testcase.
> 
> Changelog:
> v1: don't show "Raid Level" when array is inactive
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
>

Applied!

Thanks,
Jes

