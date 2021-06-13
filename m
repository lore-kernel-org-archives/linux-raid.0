Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F082C48BDF
	for <linux-raid@archiver.kernel.org>; Sun, 13 Jun 2021 22:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E25F6124B
	for <linux-raid@archiver.kernel.org>; Sun, 13 Jun 2021 22:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhFMW6g (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 13 Jun 2021 18:58:36 -0400
Received: from mout.perfora.net ([74.208.4.196]:34915 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232164AbhFMW6g (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 13 Jun 2021 18:58:36 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jun 2021 18:58:36 EDT
Received: from [192.168.1.23] ([72.94.51.172]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M9ZXN-1m2DJz2Ib1-00CzU2
 for <linux-raid@vger.kernel.org>; Mon, 14 Jun 2021 00:51:32 +0200
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
From:   H <agents@meddatainc.com>
Subject: Recovering RAID-1
Message-ID: <e6940ac5-9c2a-35bb-04fe-c80fe2a95405@meddatainc.com>
Date:   Sun, 13 Jun 2021 18:51:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:hKGX7oQv1acJXa0QwON1WfNagw+MhSjn31N+c74xt8fPaennXRi
 MF2fdCQBKFo5zb+CKPHq5fKfrZIGaED3DjFS7EA+31xo5nji/yNziFeegJ40Irx9MnEXn55
 wZ3vLdBJyCpiiqdGrchta6Yd5tDqZURIrxVap0ZAU09mxb22bUPu/bYxUOi1rvaPv4gitXT
 8aQMF6vVJ4iUKVO273szA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xsmBnYwyDBg=:GSjxZ1alHCIdshKsnqdDA6
 0FYGu/JhxC2imFdrJgh15K042X7Jay3FGWGeUa075hHTLydFc8AxdRPj5VSxCqjIC8xbikB+P
 utUV9B0muk4bFxK6YSoNHWS/0wFbXfYnwdo7659URSUlwRMfmlyARmoBnGOv31zmUJ8mAp5rS
 MpjpzbwCP9NwfAARl+4J4440qzIEshbE/lSfAHfb0+rssDmS3GIq5wFwOQzY1D4k7AYFYQdd0
 zgcOxVQsQSnoaFNXUJmJyH9jro2GfgfE63z49XYZDJSIp0QOhGoqUvCePidVxq7dbyA5e3lEy
 8SqVXWc7pd+0bAOWvTeOMIeNxT0FpYYTNtqt73uUq41IX+5oAzqJ+sKhD8EzRb72wE0/0bCkN
 AYWDeVTN13g/O7l/0Pm98jh43891KKUyeEWDoON4+rZmNjU1pPZ5fudsRmeLEUq63my5jusnd
 1KE/7AzwUis8+a21jaJnWFDNkY4hsT12t8V0fcRJY4guASIyWzb63RUmklW/UIxqEzBZejBpQ
 Ro22Wj6VIogQUufIHSZhrI=
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I am running CentOS 7 and would like to see if I can "recover" a lost(?) RAID-1 setup on two identical SSDs and would greatly appreciate some assistance.

Part of the history is that I many months ago used Intel fake RAID on the motherboard but I /think/ I may also have used software RAID... The motherboard was replaced and because there were some issues I eventually abandoned the fake RAID and did not have mdadm running at that time. Thus, I have been operating off the two identical disks in non-RAID mode but would now like to see if I can get back to having RAID-1 running using mdadm only. There have been a number of OS updates, new software installed and work done on the computer since but it is running fine.

Because I have no notes and really did not know what I had done before the above motherboard replacement I have to tread very carefully. Here is my current understanding:

- mdadm is installed on the system

- the two relevant disks are currently /dev/sdb and /dev/sdc (I also have two other disks in the system that are, for this purpose, irrelevant)

- gparted tells me that both disks are 238.47 GiB in size with:

-- /boot/efi of 260 MiB

-- /boot 1.00 GiB and formatted xfs

-- (LUKS) encrypted partition 247.22 GiB

-- unallocated 4.34 MiB

- gparted further shows a key symbol next to /dev/sdc1 and /dev/sdc2 and /dev/sdb3 but not /dev/sdb1, /dev/sdb2 and /dev/sdc3. Googling this it suggests that partitions with keys are in use and the ones with /no/ keys are /not/ in use?

- am I correct therefore that the system booted from /dev/sdc1 and /dev/sdc2 and using /dev/sdb3 for everything /but/ /boot and /boot/efi?

- cat /proc/mdstat does not show any RAID information

- my /uneducated/ guess is that there /might/ be some RAID-information in the last 4.34 MiB but I am not sure how to check it?

- my next /uneducated/ guess is that, if so, mdadm 0.90 was/could be used since that is the version that seems to use space at the end of the disk

I would very much appreciate if anyone can suggest how to check the last items? Once this has been verified the next step would be to get mdadm RAID-1 going again.

If any of the above is incorrect in whole or partially, please advise.

Thanks!

