Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AF5C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 23 Jan 2022 12:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiAWM1M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 23 Jan 2022 07:27:12 -0500
Received: from smtpq6.tb.mail.iss.as9143.net ([212.54.42.169]:34838 "EHLO
        smtpq6.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231757AbiAWM1M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 23 Jan 2022 07:27:12 -0500
Received: from [212.54.42.106] (helo=smtp2.tb.mail.iss.as9143.net)
        by smtpq6.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1nBbxf-0004SH-4U
        for linux-raid@vger.kernel.org; Sun, 23 Jan 2022 13:27:11 +0100
Received: from imail.office.romunt.nl ([94.214.94.139])
        by smtp2.tb.mail.iss.as9143.net with ESMTP
        id BbxendiwFEkreBbxen7VvL; Sun, 23 Jan 2022 13:27:10 +0100
X-Env-Mailfrom: rudy@grumpydevil.homelinux.org
X-Env-Rcptto: linux-raid@vger.kernel.org
X-SourceIP: 94.214.94.139
X-CNFS-Analysis: v=2.4 cv=EOMVbnVC c=1 sm=1 tr=0 ts=61ed499f cx=a_exe
 a=MLz4jdL9LhxtSH7CRyKX8g==:117 a=MLz4jdL9LhxtSH7CRyKX8g==:17
 a=IkcTkHD0fZMA:10 a=DghFqjY3_ZEA:10 a=CkK3bxTLzCHsvYjNXnoA:9 a=QEXdDO2ut3YA:10
Received: from [192.168.30.68] ([192.168.30.68])
        by imail.office.romunt.nl (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 20NCR634024883;
        Sun, 23 Jan 2022 13:27:07 +0100
Message-ID: <5ebb793e-ffef-da03-5eaf-34fdea1cb853@grumpydevil.homelinux.org>
Date:   Sun, 23 Jan 2022 13:27:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Backup drive DOA?
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>
References: <b8c7f666-3bad-2bde-4513-acbfd45618bf@youngman.org.uk>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
In-Reply-To: <b8c7f666-3bad-2bde-4513-acbfd45618bf@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.3 at imail
X-Virus-Status: Clean
X-CMAE-Envelope: MS4xfCxMAjPnBd6NQ4JPf/xHQXrZpK9PDjxoSXOnRxBMjCPrc1Kpyz3SXBfPoFWjYLZVVOI8ZldRcub/N+SKBSfQiMG/XxT0BTJdjwUnv4DR/aZ1ySGfP3Ka
 lgtNKByozQ47I5kTYG9k2uovNoCR61KX8/sazS7CH1FBm5xOymnm1qjNoeptmRb51Mfk4mzeYHuMiYS6R6MvAv6/c0cOYTmIvtvwHKjiR5rDUqlt/xK2dPzH
 OQMWXyzCvCII1FwklvofNqiPm02L/ChRcz7cJ+/O3/Y=
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 23-01-2022 13:19, Wols Lists wrote:
>
>
> I'm guessing the drive is dead and it's an RMA? I've never heard 
> sounds like that from a drive before ...
>
RMA, just sent it back
