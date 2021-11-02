Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A779C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 16:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B16460E9C
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 16:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhKBQjr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:39:47 -0400
Received: from sender12-1.zoho.eu ([185.20.211.225]:17289 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhKBQNw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 12:13:52 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1635869410; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=c1HxOfbUfYr0KvlxKgiogq0/lcEO7Gtg5F+OluZCdUQKQNeJE5JhA1dIHPuiQyYzbFUym+U5VF/dy8Z0T/oG6ynZiZlIw1lhRd8WVyD7M/hDncIH9/+gsoUUCQxJn09AbA8+J5JUkhaAePC087K1Jx6ZjMU9PW7BSn1k7URq1qI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635869410; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=sDHTgDJzWNH9cEYl7pSS4Qp9kD8sVCT03DcJ/nYme2E=; 
        b=jO2aF/HTv6n7aL5aRtRkJXLbnmMWcuit2As2uETABE3fV5apvB7nx2X2wMZCukrsr/tpq8o7/zbRI4HK5rMW9PyDntWmhNZO2F6C8lMNOoWkHgHkqBqR2ATLEI/sbNiYnFn9Wj2D0w9znCvCffCVoqGT6neN4WyCVLD8GXyPry0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1635869410118303.8804332174975; Tue, 2 Nov 2021 17:10:10 +0100 (CET)
Subject: Re: [PATCH 0/2] --detail show messy container name
To:     Xiao Ni <xni@redhat.com>
Cc:     ncroxon@redhat.com, ffan@redhat.com,
        mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org
References: <1635337394-4782-1-git-send-email-xni@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <325cb9e1-1106-01e4-3240-f3ce709e4c0a@trained-monkey.org>
Date:   Tue, 2 Nov 2021 12:10:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1635337394-4782-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/27/21 8:23 AM, Xiao Ni wrote:
> This patch set tries to fix the bug that --detail show messy container
> name. It adds a new method to check if one device is alive in first
> patch.
> 
> V2:
> use access rather than devid2kname
> 
> V3:
> define a new function to check if disk is alive
> include <stdbool.h> to use bool
> 
> Xiao Ni (2):
>   mdadm/lib: Define a new helper function is_dev_alived
>   mdadm/Detail: Can't show container name correctly when unpluging disks

Applied!

Thanks,
Jes

