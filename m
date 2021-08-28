Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573BDC4320E
	for <linux-raid@archiver.kernel.org>; Sat, 28 Aug 2021 23:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F3E60E93
	for <linux-raid@archiver.kernel.org>; Sat, 28 Aug 2021 23:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhH1X4k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 28 Aug 2021 19:56:40 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:59817 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232475AbhH1X4k (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 28 Aug 2021 19:56:40 -0400
X-Greylist: delayed 10066 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Aug 2021 19:56:40 EDT
Received: from 92.40.169.105.threembb.co.uk ([92.40.169.105] helo=[192.168.101.7])
        by smtp.hosts.co.uk with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim)
        (envelope-from <antmbox@youngman.org.uk>)
        id 1mK2eh-0006f9-5x; Sat, 28 Aug 2021 19:02:12 +0100
Subject: Re: Raid 5 where 2 disks out of 4 were unplugged
To:     Gennaro Oliva <gennaro.oliva@gmail.com>, linux-raid@vger.kernel.org
References: <YSdcUa6ZYsdPEtFB@ischia>
From:   Anthony Youngman <antmbox@youngman.org.uk>
Message-ID: <8a9c66df-b271-dcac-4ca3-86c2de083bfd@youngman.org.uk>
Date:   Sat, 28 Aug 2021 19:02:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSdcUa6ZYsdPEtFB@ischia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 26/08/2021 10:18, Gennaro Oliva wrote:
> Hello,
> I have a QNAP with Linux 3.4.6 and mdadm 3.3. I have 4 drives assembled
> in raid 5, two of those drives where accidentally removed and now they
> are out of sync. This is a partial output of mdadm --examine
>
> /dev/sda3:
>      Update Time : Thu Jul  8 18:01:51 2021
>         Checksum : 4bc8157c - correct
>           Events : 469678
>     Device Role : Active device 0
>     Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdb3:
>      Update Time : Thu Jul  8 18:01:51 2021
>         Checksum : 7fac997f - correct
>           Events : 469678
>     Device Role : Active device 1
>     Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdc3:
>      Update Time : Thu Jul  8 13:15:58 2021
>         Checksum : fcd5279f - correct
>           Events : 469667
>     Device Role : Active device 2
>     Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdd3:
>      Update Time : Thu Jul  8 13:15:58 2021
>         Checksum : b9bc1e2e - correct
>           Events : 469667
>     Device Role : Active device 3
>     Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
>
> The disk are all healthy. I tried to re-assemble the drive with
> mdadm --verbose --assemble --force
> using various combination of 3 drives or using all the four drives but
> I'm always notified I have no enough drives to start the array.
>
> This is the output when trying to use all the drives:
>
> mdadm --verbose --assemble --force /dev/md1 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3
> mdadm: looking for devices for /dev/md1
> mdadm: failed to get exclusive lock on mapfile - continue anyway...
> mdadm: /dev/sda3 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdb3 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdc3 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdd3 is identified as a member of /dev/md1, slot 3.
> mdadm: added /dev/sdb3 to /dev/md1 as 1
> mdadm: added /dev/sdc3 to /dev/md1 as 2 (possibly out of date)
> mdadm: added /dev/sdd3 to /dev/md1 as 3 (possibly out of date)
> mdadm: added /dev/sda3 to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 2 drives - not enough to start the array.
>
> The number of events is really close (11). What is my next option to
> recover the partition? Do I need to rebuild the superblock?
> What options should I use?
>
Do NOT "rebuild the superblock" whatever you mean by that. What I think 
you need to do is force-assemble the array. You might lose a bit of data 
- the first thing you will need to do after a forced assembly is to 
check the file system ...

The low discrepancy in the event count is a good sign, you won't lose much.

What I would suggest is you read up on the linux wiki, use overlays to 
test and make sure you won't lose anything, and then do the force 
assembly for real.

https://raid.wiki.kernel.org/index.php/Linux_Raid

Cheers,

Wol

