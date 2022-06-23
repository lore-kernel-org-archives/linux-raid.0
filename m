Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B99C43334
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 14:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiFWOql (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 10:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiFWOql (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 10:46:41 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3F64505F
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 07:46:39 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aedb8.dynamic.kabel-deutschland.de [95.90.237.184])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BC90061EA1928;
        Thu, 23 Jun 2022 16:46:36 +0200 (CEST)
Message-ID: <89467d26-f653-8347-bbcf-6b4d4cd824b7@molgen.mpg.de>
Date:   Thu, 23 Jun 2022 16:46:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: ESP and its file system (Re: a new install - - - putting the system
 on raid)
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
Cc:     o1bigtenor@gmail.com, linux-raid@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Wol,


Am 23.06.22 um 14:56 schrieb Wols Lists:

[…]

> /efi/boot (a) must be fat32,
Just a minor (theoretical) correction. To my knowledge the UEFI 
specification requires the UEFI firmware to be able to read a (UEFI) FAT 
partition, but if you are lucky or control the firmware stack, the ESP 
can be formatted with any filesystem.


Kind regards,

Paul
