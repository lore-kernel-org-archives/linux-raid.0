Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CCDC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 22:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbhLSWrH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Dec 2021 17:47:07 -0500
Received: from smtpq6.tb.mail.iss.as9143.net ([212.54.42.169]:58434 "EHLO
        smtpq6.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233859AbhLSWrA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 19 Dec 2021 17:47:00 -0500
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2021 17:47:00 EST
Received: from [212.54.42.108] (helo=smtp4.tb.mail.iss.as9143.net)
        by smtpq6.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1mz4dm-0006az-Hu
        for linux-raid@vger.kernel.org; Sun, 19 Dec 2021 23:26:50 +0100
Received: from imail.office.romunt.nl ([94.214.94.139])
        by smtp4.tb.mail.iss.as9143.net with ESMTP
        id z4dlmPM0sibMzz4dlm5N5n; Sun, 19 Dec 2021 23:26:50 +0100
X-Env-Mailfrom: rudy@grumpydevil.homelinux.org
X-Env-Rcptto: linux-raid@vger.kernel.org
X-SourceIP: 94.214.94.139
X-CNFS-Analysis: v=2.4 cv=EZ7b/dqC c=1 sm=1 tr=0 ts=61bfb1aa cx=a_exe
 a=MLz4jdL9LhxtSH7CRyKX8g==:117 a=MLz4jdL9LhxtSH7CRyKX8g==:17
 a=IkcTkHD0fZMA:10 a=IOMw9HtfNCkA:10 a=V8m0y-FVkoyDYk4TX-IA:9 a=QEXdDO2ut3YA:10
Received: from [192.168.30.68] ([192.168.30.68])
        by imail.office.romunt.nl (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 1BJMQkii003884;
        Sun, 19 Dec 2021 23:26:47 +0100
Subject: Re: Latest HP ProLiant DL380 G10 RAID1 support?
To:     Wol <antlists@youngman.org.uk>, "David F." <df7729@gmail.com>,
        "C.J. Collier" <cjac@colliertech.org>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
References: <CAGRSmLugFZo95qAOrGoKcfWN2wxe_h3Nyw8EVa+8sRVvPyu3_g@mail.gmail.com>
 <CAJj0OuvmhKP7TsamiA8X+qf38n=_94c8yR42NpUVoNp1jYqgUg@mail.gmail.com>
 <CAGRSmLvPWsYnCwkg61QJB4zjge4mu_-LOthicVzSFJo8+nj5sg@mail.gmail.com>
 <2726e0eb-90c1-b771-25c4-072caf5105be@youngman.org.uk>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <02affda1-1f10-997a-616b-f9963a2ec995@grumpydevil.homelinux.org>
Date:   Sun, 19 Dec 2021 23:26:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2726e0eb-90c1-b771-25c4-072caf5105be@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Virus-Scanned: clamav-milter 0.103.2 at imail
X-Virus-Status: Clean
X-CMAE-Envelope: MS4xfKMbIm+aEpWnIc746xg7FeqfYeT2/nlOy1G5l69y3nC7BPe1n5nsDweW45YYbfVgWscjLWmWL9BcdorhyOEg5YHJw3Qwg2HmwALFQnIZ22LTyVfpLhif
 YTfKDjy0Y31av24taXYz92jyo+Hb42FFNR7pZ/ONLZ0x1yzy5FTx6wRX982nDWseb+EeSXf5kJbQMCd7mldobpAPXOokwScXawwtu5+v17RyqYHDLktYDzuZ
 Ps0cmnEPnbYpJ4Hbp3CKU92/W/rpRyPenGOSbGIlFKpaX6/PAf3i++V/M05fXaY8oywo7JG+KYrd72CgeYdhKw==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 19-12-2021 23:07, Wol wrote:
> On 19/12/2021 21:11, David F. wrote:
>> Thanks, the strange thing is it's seeing the physical drives (I
>> understand when the drives don't show up but once the drives show up
>> mdadm was agnostic), it's not not seeing the RAID configuration, the
>> customer says "First two are raid one and second set of 3 drives are
>> raid 5"?
>
> Could it be the customer configured (or thought he did) the drives as 
> hardware raid in the BIOS, and then it's fallen into JBOD mode? Or is 
> linux bypassing the raid hardware somehow?
>
> It's probable (in fact, very liklely) that linux doesn't recognise the 
> HP raid format, unless it's IMSM.
>
> Cheers,
> Wol
I suspect this is the S100i Smart Array controller. This is a SW raid 
controller which only has a windows driver.
When you enable the raid in the BIOS the embedded raid manager lets you 
configure a raid config that windows will recognize (with the driver 
installed). Linux will only see the component disks and probably 
actually get into trouble with the S100i enabled in RAID. That at least 
is my experience with the comparable software raid on a gen8.

If no data / OS on the system, better to disable the SW raid and use 
mdadm on the base disks

Cheers

Rudy
