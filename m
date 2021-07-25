Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC13EC4338F
	for <linux-raid@archiver.kernel.org>; Sun, 25 Jul 2021 11:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C3E660231
	for <linux-raid@archiver.kernel.org>; Sun, 25 Jul 2021 11:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhGYKYf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 25 Jul 2021 06:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhGYKYe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 25 Jul 2021 06:24:34 -0400
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFC7C061757
        for <linux-raid@vger.kernel.org>; Sun, 25 Jul 2021 04:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kccrq/m1C+CGf/HDnWS5K1FW0qm+qfied7Av85pEZWE=; b=w+2Dk5coUzOlOiqjuj0B2blIki
        msl+VGs+iwbHG2W4Okn0mTl5GSXcXdRX64/jiMKjcJ7D0xEr/LR+omfRtmaXGtizugPau56G4kDIk
        GFk/xJbffCDahy2TuTt+HrAu3IffiXkEvcSpRKX970HCVgegOfnJTXqyouX08v+5sScajHLzFl9E3
        +Xv6hZt2jcTHN9509qLL11RJ0w5SGc7CXBEUuNyAd8wEXl+PcotH3R+u6V3sJJXmofPM6I4A4jEBT
        Sczknsl1y1Vad/Z/prWG9ASF0xBGRr7KeWK1yWnCOVSKcJQHJVdoK8rS51pYo3eeATWAG8xnBRgr4
        OSGIE4uQ==;
Received: from b2b-37-24-20-172.unitymedia.biz ([37.24.20.172] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1m7bwM-004kIN-EU   id 1m7bwM-004kIN-EUby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Sun, 25 Jul 2021 11:05:02 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1m7bwH-002etB-Qn
        for <linux-raid@vger.kernel.org>; Sun, 25 Jul 2021 13:04:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24829.17753.629325.512814@cyme.ty.sabi.co.uk>
Date:   Sun, 25 Jul 2021 13:04:57 +0200
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: SSD based sw RAID: is ERC/TLER really important?
In-Reply-To: <e4ecfd01-cffc-f154-5f7c-5ca08a12fd33@turmel.org>
References: <2232919.g0K5C1TF2C@chirone>
        <24828.30134.873619.942883@cyme.ty.sabi.co.uk>
        <e4ecfd01-cffc-f154-5f7c-5ca08a12fd33@turmel.org>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@raid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>> * It is possible to set the kernel timeouts higher than device retry
>> periods, if one does not care about latency, to minimize the chances
>> of declaring a drive failed (not the difference between Linux command
>> timeouts and retry timeouts, the latter can also be long).

> I don't have data on SSD behavior without ERC. If their retry
> cycle is exhausted within the kernel default 30 seconds, the
> timeout mismatch issue will *not* apply.

That as written may confuse readers as to the difference between
the Linux command timeout and the the Linux retry timeout:

  # grep -H . /sys/module/scsi_mod/parameters/eh_deadline 
  /sys/module/scsi_mod/parameters/eh_deadline:-1

  # grep -H . /sys/block/sda/device/*timeout*
  /sys/block/sda/device/eh_timeout:10
  /sys/block/sda/device/timeout:30

Things are different again with the NVME subsystem:

  # grep -H . /sys/module/nvme_core/parameters/*{timeout,retries,latency}*
  /sys/module/nvme_core/parameters/admin_timeout:60
  /sys/module/nvme_core/parameters/io_timeout:30
  /sys/module/nvme_core/parameters/shutdown_timeout:5
  /sys/module/nvme_core/parameters/max_retries:5
  /sys/module/nvme_core/parameters/default_ps_max_latency_us:100000

Some relevant links:

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_storage_devices/configuring-maximum-time-for-storage-error-recovery-with-eh_deadline_managing-storage-devices
https://unix.stackexchange.com/questions/541463/how-to-prevent-disk-i-o-timeouts-which-cause-disks-to-disconnect-and-data-corrup
https://elixir.bootlin.com/linux/v5.13.4/source/drivers/scsi/scsi_error.c
