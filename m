Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32295C636D3
	for <linux-raid@archiver.kernel.org>; Sun, 12 Feb 2023 20:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjBLUdv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Feb 2023 15:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBLUdu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Feb 2023 15:33:50 -0500
X-Greylist: delayed 905 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Feb 2023 12:33:47 PST
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E377EE3A6
        for <linux-raid@vger.kernel.org>; Sun, 12 Feb 2023 12:33:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1676233113; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=IHlPDJNCtlI7GD06kiCAXEJ8GBh8QVsOaO8eHb0Ym4YRZYOkkEOSmNRVqGln46uG9mD+WQ7D/uQqDn7usalI7LZZCLtitApUs6h83HI1FMLXVz8MPx60I8WVL9OpX17ghVKYUifKktxA/7UKiiBs8zA62cv5E/6kga5LQzPY0oo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1676233113; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3dDoK3JxzSnP0SwUlUFZSU1H60w9rvGIAS9g4Hbld/k=; 
        b=QInz81H5NLAzS4tArDO82ZQ29Wf8U9WogyhzqKvcFAYcqGSUbuyqJNsftUx+96ujKEXOOKfiO23R0J+xj5rvPXA1swD4UK8l7q09FZYMm7fHUTN7W/NqV8ZjyxjZaEleedmOdSfFBTu5ngrfNkDwOSUg2/QbajOKVj7iqXbJqmg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1676233109636636.9212403163242; Sun, 12 Feb 2023 21:18:29 +0100 (CET)
Message-ID: <1f799f15-78f3-db4e-2d59-c31480e787fd@trained-monkey.org>
Date:   Sun, 12 Feb 2023 15:18:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Revert "mdadm/systemd: remove KillMode=none from service
 file"
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
References: <20230202075631.18092-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230202075631.18092-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/2/23 02:56, Mariusz Tkaczyk wrote:
> This reverts commit 52c67fcdd6dadc4138ecad73e65599551804d445.
> 
> The functionality is marked as deprecated but we don't have alternative
> solution yet. Shutdown hangs if OS is installed on external array:
> 
> task:umount state:D stack: 0 pid: 6285 ppid: flags:0x00004084
> Call Trace:
> __schedule+0x2d1/0x830
> ? finish_wait+0x80/0x80
> schedule+0x35/0xa0
> md_write_start+0x14b/0x220
> ? finish_wait+0x80/0x80
> raid1_make_request+0x3c/0x90 [raid1]
> md_handle_request+0x128/0x1b0
> md_make_request+0x5b/0xb0
> generic_make_request_no_check+0x202/0x330
> submit_bio+0x3c/0x160
> 
> Use it until new solution is implemented.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  systemd/mdadm-grow-continue@.service | 1 +
>  systemd/mdmon@.service               | 1 +
>  2 files changed, 2 insertions(+)

Applied!

Sorry for taking so long.

Best regards,
Jes

