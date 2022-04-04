Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAE8C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 12:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347808AbiDDM4P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbiDDM4O (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 08:56:14 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC61C140F2
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 05:54:16 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 62BAF61E6478B;
        Mon,  4 Apr 2022 14:54:13 +0200 (CEST)
Message-ID: <ee82953f-f156-040b-10b5-ae09f3f1c199@molgen.mpg.de>
Date:   Mon, 4 Apr 2022 14:54:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Mdmonitor: Fix segfault and improve logging
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@linux.intel.com>
References: <20220321123234.28769-1-kinga.tanska@intel.com>
 <e5502af7-be1c-da7f-af3d-ca36d45e6301@molgen.mpg.de>
 <9a062f0c-fcea-c543-3a46-05395c747fcd@linux.intel.com>
 <9eccf3ed-3db3-7ba7-fd8b-fa4273bc0752@molgen.mpg.de>
 <321885a5-f9c8-f9c2-fab2-2c31ead17b87@linux.intel.com>
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
        jes@trained-monkey.org, colyli@suse.de
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <321885a5-f9c8-f9c2-fab2-2c31ead17b87@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Kinga,


Am 04.04.22 um 14:39 schrieb Tanska, Kinga:

> I've tried to reproduce it with mdadm 4.1 and mdadm 4.2 and both apps
>  exit with segmentation fault. This patch is not a fix, it adds
> checking if device is md array.
> 
> It hasn't been checked before in mdmonitor, so segmentation fault
> should appear.
Understood, still it’d be nice to have a way to reproduce this. So 
please elaborate in the commit message, and give more details about your 
test setup.


Kind regards,

Paul
