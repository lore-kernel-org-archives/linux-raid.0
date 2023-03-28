Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC85C76195
	for <linux-raid@archiver.kernel.org>; Tue, 28 Mar 2023 08:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjC1Isc convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Mar 2023 04:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjC1Isa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Mar 2023 04:48:30 -0400
Received: from mout-xforward.gmx.com (mout-xforward.gmx.com [82.165.159.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8041708
        for <linux-raid@vger.kernel.org>; Tue, 28 Mar 2023 01:48:25 -0700 (PDT)
Received: from [178.140.144.219] ([178.140.144.219]) by web-mail.mail.com
 (3c-app-mailcom-lxa10.server.lan [10.76.45.11]) (via HTTP); Tue, 28 Mar
 2023 10:48:23 +0200
MIME-Version: 1.0
Message-ID: <trinity-3b72f993-a1a2-48d7-99f5-2e91a7b700f6-1679993303899@3c-app-mailcom-lxa10>
From:   Leonid Mironov <lvm@royal.net>
To:     linux-raid@vger.kernel.org
Subject: Re-adding disk failed during reshaping causes array corruption
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 28 Mar 2023 10:48:23 +0200
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-Provags-ID: V03:K1:maErVxUWLYxJM3+KhS+w7m7QCO+kZJredd95Aadb/MWGdhO4hYkehmY8NWJuy7OAPMlcr
 2CI7uTvINbxwdZnL2fx2Df/f5BuE3wBXpPqBsFZyEhfUl060ayI2iWEDIv/A9lWCtx7jxjU1Ssy3
 +7OjLTmTSweAGj0/e/+DaoB0Ug/59DVz8fkRQob+CFz9S/RiLMsBnMLkjxoWkDdgCHwFfHj2tq7H
 bkJwk38uLNfaisT9awEjfdz+8aZTDO78lrm5Lw9iMk/iMiagDUyZqlWBVHKBqZjyc68UbfrJrGuo
 bc=
UI-OutboundReport: junk:10;M01:P0:VZIcx1qc5SQ=;Nzfx69xGZKfBcDN2g500jOUcagQi5
 O39OXH94i+ilDmPaM7areRU0HxR2Yb7ewkz4jkVz3RukyNiHQ0tc7bNGRsipOtTLkfc650d20
 X3XJ8G5JJosnPsS6brXAzcTy18rXkEuW/eIdE34CeXjfMZUcVnxMQ3oarI/PmwmkmgKjB0ReB
 sTxcSSz4OY8Jx6OdaQlVoi+f41Uy/8SvsMGxSyWBGngzZJyXrmdKQLfsWfo6K33mzr0Q7eubw
 ttDu4K9MBqUrZL9r1xWVt6jG/zevhlBqli0rTludFR1y3Gc3jbv1CZVg5Y4H2CtJlSAZW/dy7
 BtKN8banse30UlpINohyzuZOeZ0aZ68eoVKciKi1aFFtBok7YdeE8XXKloY6BMzIaxsCbd+b3
 xmHgdiMuhyLRIMQQAdEITi7edN37CmH01MasN2gdvafibH+o+1RBMSrHAeOl4VikokSDKAdcM
 WVXAehKnWRx/9LISzISLEfe7pceDwRBPFN1ADHyt6iNJzjxcG+acbtx8PUyIH1II7fRtD3GIS
 hUoZT7BTsuk/Xc2t8S5Qz+PQjHLebivcjQOxUivnDWUw8QrrfXnt9+k24t2PJj1lbiSmMQkIq
 NiEA5Bt1DQ/qVJIYMyDrsHbyN04c7zFxQ1B3MxDR/Cw0tTwtFe6EIQoSMbzyAxyLArBV6hmjg
 OJbnsbVZkuIUTul6DHV3DHTqaaoPKYlhMaOW9j39jIUdz9qj2OrfrZMO3dLgvW36h6G2gOlOA
 RsMWsyulQEozzSaImguvk/zPcBqi9dvKeehRq542KIvc4J0wf16oPUWvqRo4QVLlbcYRMIi3g
 /2+CKgGocUhyJbKpHyt6nIKdDwbzrUPQIHyLExryOkali03m32/hgc+3VtP0y7Sn
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Consider the following scenario:

* A new disk was added to RAID6 md array (mdadm -a /dev/md1 /dev/sdc1)
* Number of devices was increased and array started to reshape (mdadm -G /dev/md1 -n 5)
* While the array was reshaping, one of the pre-existing disks in the array failed; degraded array continued reshaping and completed the
process successfully, albeit at reduced speed (to be expected). While array was reshaping there were no signs of data corruption.
* Computer was shut down, SATA cable to the failed disk was replaced, and it came back online with only CRC errors in the SMART error log,
which indicated nothing worse than a loose connection.
* Failed disk was added to the degraded array (mdadm -a /dev/md1 /dev/sdc1)
* At this point /proc/mdstat didn't report that the array was recovering, it reported that this disk was being re-added, and the process
completed very quickly - in a minute or two.
* I am pretty sure that the previous step caused the corruption, but to be honest, I didn't check at this time - I grew filesystem to match
the array size, started copying some files and only then noticed multiple errors. 'xfs_repair -n' generated a 24M error log. All was lost.
* I tried failing the re-added disk, and the filesystem recovered [almost] completely.
* I then zeroed the superblock on this disk and added it back, normal (and lengthy) rebuild started and is currently in progress. Everything
seems to be fine.
 
Note:

1. mdadm - v4.1-rc1 - 2018-03-22, by no means the latest version, this issue may be already fixed, but as it causes severe data corruption
I'd better report it.
2. no assistance necessary, looks like I managed to fix it on my own - just reporting the bug

