Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED372C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 20:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242441AbiAKUev (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 15:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiAKUet (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jan 2022 15:34:49 -0500
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F88C06173F
        for <linux-raid@vger.kernel.org>; Tue, 11 Jan 2022 12:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4zrewSRw4vQIW8RYSWzAvbgFvibDrgAgi+2DlQ+Q9l8=; b=MqnygNDVFxUDRpfDxIzoqUZHC5
        1Cq2H3Wyrr8hjl6pGf3Fbg08TEuQywMLtRjCtwWVVrTpayhuetdd7uLRrXVPSzqO4tuAIRSau3qxI
        hIq1bdj9ZNf8tYHvFS1fxniLXn5QukfjiiA1LjZ3O8ydJ7vOA8yCP8gJVUSgMJatAO41V1CbXKBSm
        5DwsTZ6fT/QeYHLfeX9HNdPBTcu4FNjXOW6QhkXzLUhC3H8nYNBjojtb162gwwsljTBLseVvql0JW
        4wA/1TQk7RK4X0yZ0jB9/xIx+ZPsrOYPEI5ggdT3ub1T77KzDNTSnNuTxN21sNb8FMURN5Mte8PE2
        tfg1oHCQ==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1n7Nqx-0005BU-7W; Tue, 11 Jan 2022 20:34:47 +0000
Subject: Re: MDRAID NVMe performance question, but I don't know what I don't
 know
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <5EAED86C53DED2479E3E145969315A238926397D@UMECHPA7B.easf.csd.disa.mil>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <6941b93a-0e83-1e47-2769-f60785d4b41a@turmel.org>
Date:   Tue, 11 Jan 2022 15:34:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5EAED86C53DED2479E3E145969315A238926397D@UMECHPA7B.easf.csd.disa.mil>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi James,

On 1/11/22 11:03 AM, Finlayson, James M CIV (USA) wrote:
> Hi,
> Sorry this is a long read.   If you want to get to the gist of it, look for "<KEY>" for key points.   I'm having some issues with where to find information to troubleshoot mdraid performance issues.   The latest "rathole" I'm going down is that I have two identically configured mdraids, 1 per NUMA node on a dual socket AMD Rome with "numas per socket" set to 1 in the BIOS.   Things are cranking with a 64K blocksize but I have a substantial disparity between NUMA0's mdraid and NUMA1's.

[trim /]

Is there any chance your NVMe devices are installed asymmetrically on 
your PCIe bus(ses) ?

try:

# lspci -tv

Might be illuminating.  In my office server, the PCIe slots are routed 
through one of the two sockets.  The slots routed through socket 1 
simply don't work when the second processor is not installed.  Devices 
in a socket 0 slot have to route through that CPU when the other CPU 
talks to them, and vice versa.

Phil
