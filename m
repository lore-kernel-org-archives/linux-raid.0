Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762B1C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 02:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B1736137F
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 02:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346051AbhKPCM6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 21:12:58 -0500
Received: from smtp2.us.opalstack.com ([23.106.47.103]:46860 "EHLO
        smtp2.us.opalstack.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359458AbhKPCKy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 15 Nov 2021 21:10:54 -0500
Received: from localhost (opal1.opalstack.com [108.59.4.161])
        by smtp2.us.opalstack.com (Postfix) with ESMTPSA id BA0816F65C;
        Tue, 16 Nov 2021 02:07:57 +0000 (UTC)
Date:   Tue, 16 Nov 2021 02:07:56 +0000
From:   David T-G <davidtg+robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: can't loop the image files and assemble (was "Re: overlays on dd
 images of 4T drives")
Message-ID: <20211116020756.GA120503@opal1.opalstack.com>
References: <20211114022924.GA21337@opal1.opalstack.com>
 <20211115025103.GA254223@opal1.opalstack.com>
 <87czn1i4xr.fsf@vps.thesusis.net>
 <20211116020126.GA95566@opal1.opalstack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116020126.GA95566@opal1.opalstack.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi again, all --

...and then David T-G said...
% 
...
% 
% Can I create loopback devices pointing to the image files, which will
% give me raw handles, and then assemble that?
[snip]

Apparently that's a "no":

  diskfarm:/mnt/10Traid50md/tmp # losetup -r /dev/loop10 `pwd`/4Tsda1*
  diskfarm:/mnt/10Traid50md/tmp # losetup -r /dev/loop11 `pwd`/4Tsdb1*
  diskfarm:/mnt/10Traid50md/tmp # losetup -r /dev/loop12 `pwd`/4Tsdc1*

  diskfarm:/mnt/10Traid50md/tmp # losetup -a | grep 4T
  /dev/loop11: [66326]:1054 (/mnt/10Traid50md/tmp/4Tsdb1.5YD9.dd-bs=256M-conv=sparse,noerror)
  /dev/loop12: [66326]:1055 (/mnt/10Traid50md/tmp/4Tsdc1.5ZY3.dd-bs=256M-conv=sparse,noerror)
  /dev/loop10: [66326]:1028 (/mnt/10Traid50md/tmp/4Tsda1.EYNA.dd-bs=256M-conv=sparse,noerror)
  # hey ... i did those manually and in order! *sigh*

  diskfarm:/mnt/10Traid50md/tmp # mdadm --assemble /dev/md4 /dev/loop1{0,1,2}
  mdadm: /dev/loop10 is busy - skipping
  mdadm: /dev/loop11 is busy - skipping
  mdadm: /dev/loop12 is busy - skipping

Scratch that idea ...


:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

