Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42719C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  2 Mar 2022 18:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244735AbiCBSsY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Mar 2022 13:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244617AbiCBSsX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Mar 2022 13:48:23 -0500
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB95263F
        for <linux-raid@vger.kernel.org>; Wed,  2 Mar 2022 10:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DuPOThntikEZcDYyAoosIPexJDc03e2jAjtqNdRYD7o=; b=GFS4hOW20bPv6NPHtIEiTLyXz0
        SDtjBAIEn+qJ8ZmhFnL5gDoI3MrpY+wgpV0CALXnH94F+7qC2hOnP4Oofb1hn0vF8YEkIZ8EMWJd6
        6MzAQ/uDh4ghNH6h/Sq8Dmc7uSGjvar8uEh9boRt7CdkqXfiVQIk/27oea5QHB8qWy58lCFW1zGd3
        VPqeKqgKUV1uKTEzTMsNvtbNxZ/b5fulhafHs8RAUzhH42Oo6Rso1ynoRGnnH1npgF4cau2yP1vJt
        u7raWqLa31ZYxwEwyyTkOJ/Op9npvfnE6BZTGTaXeSt/kekISpRlvDHl4PU/eYum0an1mshuySmDD
        G/OTXjrg==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1nPU0d-0006G2-U8; Wed, 02 Mar 2022 18:47:35 +0000
Message-ID: <63d13bf2-3e7b-a038-ef6f-f34acbc1e2bf@turmel.org>
Date:   Wed, 2 Mar 2022 13:47:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: mdadm clone for continuous integration
Content-Language: en-US
To:     Coly Li <colyli@suse.de>, linux-raid <linux-raid@vger.kernel.org>
References: <49e78e8f-080e-9c62-4cd6-6fcf902dcb7e@suse.de>
From:   Phil Turmel <philip@turmel.org>
Organization: Turmel Enterprises
In-Reply-To: <49e78e8f-080e-9c62-4cd6-6fcf902dcb7e@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Coly,

On 3/2/22 02:26, Coly Li wrote:
> Hi Jes, and other mdadm and md raid developers,
> 
> 
> In order to help Jes to miantain mdadm more convenient, I decide to 
> spend my time on the code review and integration testing, to (try my 
> best to) help the Jes' maintenance process to be faster.

[trim/]

> Let me start it from scratch now, and see how it goes after next 2 or 3 
> years. Thank you all in advance, for all necessary help in future.

> Coly Li

Thank you for stepping up to do this.  The community appreciates it.

Regards,

Phil Turmel
