Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A52C433E0
	for <linux-raid@archiver.kernel.org>; Mon, 21 Dec 2020 12:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE52216FD
	for <linux-raid@archiver.kernel.org>; Mon, 21 Dec 2020 12:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgLUMel (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Dec 2020 07:34:41 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:40291 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbgLUMel (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 21 Dec 2020 07:34:41 -0500
Received: from [192.168.0.8] (ip5f5aef0c.dynamic.kabel-deutschland.de [95.90.239.12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 171622064784C;
        Mon, 21 Dec 2020 13:33:59 +0100 (CET)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
From:   Donald Buczek <buczek@molgen.mpg.de>
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
 <77244d60-1c2d-330e-71e6-4907d4dd65fc@molgen.mpg.de>
 <7c5438c7-2324-cc50-db4d-512587cb0ec9@molgen.mpg.de>
 <b289ae15-ff82-b36e-4be4-a1c8bbdbacd7@cloud.ionos.com>
 <37c158cb-f527-34f5-2482-cae138bc8b07@molgen.mpg.de>
Message-ID: <efb8d47b-ab9b-bdb9-ee2f-fb1be66343b1@molgen.mpg.de>
Date:   Mon, 21 Dec 2020 13:33:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <37c158cb-f527-34f5-2482-cae138bc8b07@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Guoging,

I think now that this is not an issue for md. I've driven a system into that situation again and have clear indication, that this is a problem of the member block device driver.

With md0 in the described errornous state (md0_raid6 busy looping, echo idle > .../sync_action blocked, no progress in mdstat) and md1 operating normally:

     root:deadbird:/scratch/local/# for f in /sys/devices/virtual/block/md?/md/rd*/block/inflight;do echo $f: $(cat $f);done
     /sys/devices/virtual/block/md0/md/rd0/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd1/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd10/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd11/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd12/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd13/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd14/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd15/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd2/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd3/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd4/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd5/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd6/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd7/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd8/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd9/block/inflight: 1 0
     /sys/devices/virtual/block/md1/md/rd0/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd1/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd10/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd11/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd12/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd13/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd14/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd15/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd2/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd3/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd4/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd5/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd6/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd7/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd8/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd9/block/inflight: 0 0

Best
   Donald
