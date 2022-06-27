Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C5DC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 14:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiF0O0W (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Jun 2022 10:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbiF0O0W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Jun 2022 10:26:22 -0400
Received: from mallaury.nerim.net (smtp-101-monday.noc.nerim.net [178.132.17.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87A4B13F1C
        for <linux-raid@vger.kernel.org>; Mon, 27 Jun 2022 07:26:19 -0700 (PDT)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 476B4DB17C;
        Mon, 27 Jun 2022 16:26:11 +0200 (CEST)
Message-ID: <3e756547-ae18-c0d8-209e-8dd1fc43bb0f@plouf.fr.eu.org>
Date:   Mon, 27 Jun 2022 16:26:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Alexander Shenkin <al@shenkin.org>, Roman Mamedov <rm@romanrm.net>
Cc:     Wols Lists <antlists@youngman.org.uk>, Stephan <linux@psjt.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
 <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
 <20220624234453.43cf4c74@nvm>
 <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
 <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
 <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
 <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
 <20220625030833.3398d8a4@nvm>
 <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
 <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
 <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
 <b1c6b0c2-ff7b-59e0-580c-81d57b8f8ddb@shenkin.org>
 <20220627160558.0ec507ae@nvm> <693d4b1c-ee58-4cc2-854b-4ae445ff7d24@Spark>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <693d4b1c-ee58-4cc2-854b-4ae445ff7d24@Spark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/06/2022 15:57, Alexander Shenkin wrote :
> 
> CSM is greyed out.  I think I need a graphics card

Is secure boot disabled? Legacy boot is not compatible with secure boot.
