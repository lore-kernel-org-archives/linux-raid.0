Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E299C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 11 Nov 2022 15:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbiKKPq6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Nov 2022 10:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiKKPq4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Nov 2022 10:46:56 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3242EF28
        for <linux-raid@vger.kernel.org>; Fri, 11 Nov 2022 07:46:54 -0800 (PST)
Received: from [172.16.4.245] (unknown [185.236.96.202])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 27C2A61EA192D;
        Fri, 11 Nov 2022 16:46:52 +0100 (CET)
Message-ID: <f8ee8326-9b03-8c82-3c8d-895b160f00d9@molgen.mpg.de>
Date:   Fri, 11 Nov 2022 16:46:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: Kernel crash, possibly raid, and dump but no log available as
 shutdown.
To:     Wilson Jonathan <i400sjon@gmail.com>
References: <64eabe28c77a488e3c36839b7614770f9be7d389.camel@gmail.com>
Content-Language: en-US
Cc:     linux-raid@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <64eabe28c77a488e3c36839b7614770f9be7d389.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Jonathan,


Am 11.11.22 um 16:10 schrieb Wilson Jonathan:
> I have been suffering from a crash and dump for some time now when
> shutting down my AMD Threadripper TR4 system.

[…]

> The system does its usual shut down tasks and then somewhere between
> shutting down the virtual machines (none of which were running/had been
> started) and the disks doing their shutdowns (not sure what to call it,
> but its nearly the last thing that happens before power off but it
> mentions each disk) I get a crash dump to the console.

[…]

> Is there anyway to get/print/transmit the log in real time to some
> external "thing" such as another pc on the network as by the time the
> crash happens the array (with the log files) must be down because there
> is nothing in the log files. No errors, shutdown messages, or shutdown
> log (is there even such a thing as a shutdown log?).

Please look into the serial console, a lot of boards still have such a 
header, netconsole, and pstore.


Kind regards,

Paul
