Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C70FC43460
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 23:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EBC5613EB
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 23:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhELXWC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 19:22:02 -0400
Received: from pmta11.teksavvy.com ([76.10.157.34]:61554 "EHLO
        pmta11.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348071AbhELW1n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 18:27:43 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 18:27:43 EDT
IronPort-SDR: 8xpzZ/FHVDKWIpB8VxUvL8duN8yDB6rnu5k4S3rvaY+eEvPY0Px4TqYckxIDLM4nNWHrxAuROg
 bC+GUmf0BcFQ==
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AeZvq1a31FUI9FsGS9AHHPQqjBLMkLtp133?=
 =?us-ascii?q?Aq2lEZdPWaSKGlfrOV7ZMmPHjP+VIssRAb6LW90ca7IE80maQb3WBVB8bBYO?=
 =?us-ascii?q?CEghrKEGgB1+XfKlTbckXDH6xmuZuIGJIUNDSfNzJHZIrBgDWFLw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2ErAAAtU5xg/40INJ0NTRwBAQEBAQE?=
 =?us-ascii?q?HAQESAQEEBAEBQAmBPAUBAQsBiSmRVC0DhAqXAIF8CwEBAQEBAQEBAQk8BAE?=
 =?us-ascii?q?BhEYJAoF2JjYHDgIEAQEBEgEBAQUBAQEBAQYEAgKBAIwrAQEBAyMPAQVBEAs?=
 =?us-ascii?q?YAgImAgJXBgEMCAEBgm2rZHqBMoEBhGOFGYEQKgGJa4N3PQaCDYEVJ4JMLz6?=
 =?us-ascii?q?HWoJjBIFNB1OBLoFwPxsFu30HA4MVnTMFDSKlNJUznl6FQoFbDIIBcBWDJU8?=
 =?us-ascii?q?njisWjkeBDwIGAQkBAQMJjRABAQ?=
X-IPAS-Result: =?us-ascii?q?A2ErAAAtU5xg/40INJ0NTRwBAQEBAQEHAQESAQEEBAEBQ?=
 =?us-ascii?q?AmBPAUBAQsBiSmRVC0DhAqXAIF8CwEBAQEBAQEBAQk8BAEBhEYJAoF2JjYHD?=
 =?us-ascii?q?gIEAQEBEgEBAQUBAQEBAQYEAgKBAIwrAQEBAyMPAQVBEAsYAgImAgJXBgEMC?=
 =?us-ascii?q?AEBgm2rZHqBMoEBhGOFGYEQKgGJa4N3PQaCDYEVJ4JMLz6HWoJjBIFNB1OBL?=
 =?us-ascii?q?oFwPxsFu30HA4MVnTMFDSKlNJUznl6FQoFbDIIBcBWDJU8njisWjkeBDwIGA?=
 =?us-ascii?q?QkBAQMJjRABAQ?=
X-IronPort-AV: E=Sophos;i="5.82,295,1613451600"; 
   d="scan'208";a="163950734"
Received: from 157-52-8-141.cpe.teksavvy.com (HELO [192.168.12.90]) ([157.52.8.141])
  by smtp11.teksavvy.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2021 18:18:46 -0400
Subject: Re: Patch to fix boot from RAID-1 partitioned arrays
To:     Geoff Back <geoff@demonlair.co.uk>,
        Wols Lists <antlists@youngman.org.uk>,
        Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
References: <d9e1f759-3a11-1d63-f16c-8b999190c633@demonlair.co.uk>
 <609BB707.5030505@youngman.org.uk>
 <3f46a847-3dc4-4f39-5789-f85872e03c43@demonlair.co.uk>
From:   "J. Brian Kelley" <jbk@teksavvy.com>
Message-ID: <5a061fb8-73e5-4f0e-6a97-92e2db816c90@teksavvy.com>
Date:   Wed, 12 May 2021 18:18:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <3f46a847-3dc4-4f39-5789-f85872e03c43@demonlair.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Heh, sounds analogous to a quirk in BTRFS where a additional 'hook' is 
required or "btrfs" included in MODULES= (apparently triggering some 
(e)udev rule) in the initrd configuration file. Most linux distros take 
care of this , but not ARCH (or derivatives).  Hate to even think of 
incorporating this into a kernel....

On 2021-05-12 6:56 a.m., Geoff Back wrote:
>
> The problem is not with in-kernel assembly and starting of the array -
> that works perfectly well.  However, when the 'md' driver assembles and
> runs the partitionable array device (typically /dev/md_d0) it only
> causes the array device itself to get registered with the block layer.
> The assembled array is not then scanned for partitions until something
> accesses the device, at which point the pending GD_NEED_PART_SCAN flag
> in the array's block-device structure causes the probe for a partition
> table to take place and the partitions to become accessible.
>
> Without my patch, there does not appear to be anything between array
> assembly and root mount that will access the array and cause the
> partition probe operation.
>
> To be clear, the situation is that the array has been fully assembled
> and activated but the partitions it contains remain inaccessible.
>
> Thanks,
>
> Geoff.
>
