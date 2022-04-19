Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC0EC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Apr 2022 10:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348548AbiDSKFi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Apr 2022 06:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242209AbiDSKFh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Apr 2022 06:05:37 -0400
X-Greylist: delayed 541 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Apr 2022 03:02:54 PDT
Received: from mail.spoje.net (mail.spoje.net [82.100.58.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD68F140E9
        for <linux-raid@vger.kernel.org>; Tue, 19 Apr 2022 03:02:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.spoje.net (Postfix) with ESMTP id EC679AC0081
        for <linux-raid@vger.kernel.org>; Tue, 19 Apr 2022 11:53:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=spoje.net;
        s=spojemail; t=1650362032;
        bh=I3qJXF73LSJy3Bb6c6N+WTMRGaydIKkiyiyXca13VMc=;
        h=To:Subject:Date:From:From;
        b=Vj8KU8FZobUmPTZxyp/0DHmnzZGmreGuLuARwyAFbHw+LGXtrXdaW4GzUDJC5If/0
         /aJ0SvH2EW5pN1t3Eib3s9U7TX4DGOPZ0W+Y5xsUB6/C1dVwNjCab4qQ9RiZzbXgqM
         94Q8kFqOpwARrrccag4afTbHfXkRESXlo6xGrFIM=
X-Virus-Scanned: Debian amavisd-new at mail.spoje.net
Authentication-Results: mail.spoje.net (amavisd-new); dkim=pass (1024-bit key)
        header.d=spoje.net
Received: from mail.spoje.net ([127.0.0.1])
        by localhost (mail.spoje.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4sQiKc1lX1x6 for <linux-raid@vger.kernel.org>;
        Tue, 19 Apr 2022 11:53:50 +0200 (CEST)
Received: by mail.spoje.net (Postfix, from userid 33)
        id E5F22ABFFC1; Tue, 19 Apr 2022 11:53:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=spoje.net;
        s=spojemail; t=1650362030;
        bh=I3qJXF73LSJy3Bb6c6N+WTMRGaydIKkiyiyXca13VMc=;
        h=To:Subject:Date:From:From;
        b=L3UC7eiUJZbySp1Zr81ngxup8cMQqGPMFKPWCK96nkQauxS75chCT5M/GV+ekaqmy
         7Rxhw+Nx9OHpBrePPVnbxIjfPT8T+fF9b+e1qRBxJt2jFoSuRy4HgB0haoWJ/4Pg00
         xM1blnfKZHEsLmOnwByl0nEIQewKcSHdlpHwR3ts=
To:     linux-raid@vger.kernel.org
Subject: Create MDRAID image without kernel
X-PHP-Originating-Script: 0:rcube.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 19 Apr 2022 11:53:50 +0200
From:   Tomas Mudrunka <mudrunka@spoje.net>
Organization: SPOJE.NET s.r.o.
Message-ID: <97e63e23a0f31d8dccec5321abee30e4@spoje.net>
X-Sender: mudrunka@spoje.net
User-Agent: Roundcube Webmail/1.2.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,
i am thinking about writing genimage plugin to build disk images 
containing md raid partitions.
It is a framework to build disk images based on structure declared by 
config file.
I need to be able to write script, which will create metadata in empty 
file and copy filesystem image into it.
It is obviously not desirable to be forced why

Is there a way to create mdraid image file without activating the raid 
in kernel? Or write md 1.2 metadata to block device without starting it 
or requiring root permissions?

Thanks for help.

-- 
S pozdravem
Best regards
      Tomáš Mudruňka
