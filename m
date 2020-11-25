Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744A8C8301D
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F41D208B8
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgKYXWP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:22:15 -0500
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17396 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729779AbgKYXWO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 18:22:14 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1606346531; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=W8pelFJONgOv2HrtmFas4UNaQpzM32zG5ckpYxCE9QkapMPQq40TQLpNYMSjusq0gJhgbeCbNlgQm272RRonkp28NXP3FnUz7WckrVGr4jCfO+uKqElLm6LMLg5030HL0bUECuqCrIB2d7poNnzgtjp3Eekd9fItJq+DqBTAdSA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606346531; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=f8L8DBnlmtk1U5hB3CWi75l+Srf4LEZxHqc1QM8vT9g=; 
        b=MqBdMhnCOOGOXwBr3mCbOVfn7ujaLQyrFWhglpGvbPNYgSdDWdmPhtSkUxZgBCQ/9YhDWN4JARGm+AF4yfYWftntWItyFsOjh9YZafE7FwHwlp5JUuYaoHLZaDpIhYjNoDGqzjG7lIXM/lCxju6kJg6AB4UgO9zRy41p5XOV7bY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1606346530535442.3444282766475; Thu, 26 Nov 2020 00:22:10 +0100 (CET)
Subject: Re: [PATCH] udev: start grow service automatically
To:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20201015084529.5306-1-mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <88a22fb8-2429-035a-a4be-6fbfcb905ed6@trained-monkey.org>
Date:   Wed, 25 Nov 2020 18:22:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201015084529.5306-1-mariusz.tkaczyk@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/15/20 4:45 AM, Mariusz Tkaczyk wrote:
> From: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
> 
> Grow continue via service or fork is started during raid assembly.
> If raid was assembled in initrd it will be newer restarted after
> switch root.
> Add udev support for starting mdadm-grow-continue service.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---

Applied!

Thanks,
Jes

