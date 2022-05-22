Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AD5C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 22 May 2022 04:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiEVENM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 May 2022 00:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiEVENL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 May 2022 00:13:11 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 257E03FBE8
        for <linux-raid@vger.kernel.org>; Sat, 21 May 2022 21:13:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id E46BE19F35E;
        Sun, 22 May 2022 14:13:06 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id RIR9_kUzuHiJ; Sun, 22 May 2022 14:13:06 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id B60CC19F372;
        Sun, 22 May 2022 14:13:06 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au B60CC19F372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1653192786;
        bh=KQTKOAG1Y37s+1Z2pN2AtmydoQUsThGQPm2JgNG04Jo=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=UjANULDgjY5tA2ijyhAL6kr2FIzRBh2qEOyxOwCw4jT9DEGIBp83WaHffQyxZauMB
         PNasyed0hYSPEgeUh/3dKLyYrd6c3Qt7U3Jj5jpzLd2Hu4U4Kpx6njh+uaO2IzxU9l
         IcnYIZfz7L5vnMou1p79T08nuvUrk8lEincpZWf8=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CJ6itrNLWY67; Sun, 22 May 2022 14:13:06 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 6B4AE19F35E;
        Sun, 22 May 2022 14:13:06 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Reindl Harald" <h.reindl@thelounge.net>,
        "Roger Heflin" <rogerheflin@gmail.com>,
        "Wols Lists" <antlists@youngman.org.uk>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Phil Turmel" <philip@turmel.org>, "NeilBrown" <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk> <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au> <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk> <00d101d86329$a2a57130$e7f05390$@wmawater.com.au> <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au> <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au> <00eb01d86339$18cc0860$4a641920$@wmawater.com.au> <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk> <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com> <04ed01d86c5c$2f632f50$8e298df0$@wmawater.com.au> <06995c9b-2dc5-3c0b-9ba1-59be171a7de8@thelounge.net>
In-Reply-To: <06995c9b-2dc5-3c0b-9ba1-59be171a7de8@thelounge.net>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Sun, 22 May 2022 14:13:06 +1000 (AEST)
Message-ID: <054401d86d92$3c59cac0$b50d6040$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P1de8 T376c R32427)
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFAYMzo9kBZlg9dAGZ0oLFAdWidsoCQWnqlQI7z0N+AMQVcYoBrcfnAQHzgz42AmhhXhiq3fKlkA==
Content-Language: en-au
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks Reindl.

Is xfs_repair an option? And, if it is, do I run it on md125 or the 
individual sd devices?

Unfortunately, restore from back up isn't an option - after all to where do 
you back up 200TB of data? This storage was originally set up with the 
understanding that it wasn't backed up and so no valuable data was supposed 
to have been stored on it. Unfortunately, people being what they are, 
valuable data has been stored there and I'm the mug now trying to get it 
back - it's a system that I've inherited.

So, any help or constructive advice would be appreciated.

Thanks,
Bob

-----Original Message-----
From: Reindl Harald <h.reindl@thelounge.net>
Sent: Saturday, 21 May 2022 1:41 AM
To: Bob Brand <brand@wmawater.com.au>; Roger Heflin <rogerheflin@gmail.com>; 
Wols Lists <antlists@youngman.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>; Phil Turmel 
<philip@turmel.org>; NeilBrown <neilb@suse.com>
Subject: Re: Failed adadm RAID array after aborted Grown operation



Am 20.05.22 um 17:13 schrieb Bob Brand:
> UPDATE:
>
> The array finally finished the reshape process (after almost two
> weeks!) and I now have an array that's showing as clean with the original 
> 30 disks.
> However, when I try to mount it, I get the message "mount: /dev/md125:
> can't read superblock".
>
> Any suggestions as to what my next step should be? Note: it's still
> running from the rescue disk

restore from a backup - the array is one thing, the filesystem is a 
different layer and it seems to be heavily damag after all the things which 
happened



CAUTION!!! This E-mail originated from outside of WMA Water. Do not click 
links or open attachments unless you recognize the sender and know the 
content is safe.


