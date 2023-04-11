Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3159C77B6F
	for <linux-raid@archiver.kernel.org>; Tue, 11 Apr 2023 18:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDKSUx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjDKSUu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Apr 2023 14:20:50 -0400
X-Greylist: delayed 550 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 11:20:48 PDT
Received: from itrosinen.de (itrosinen.de [185.13.148.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AB15B84
        for <linux-raid@vger.kernel.org>; Tue, 11 Apr 2023 11:20:47 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by itrosinen.de (Postfix) with ESMTP id 295D94E5E5
        for <linux-raid@vger.kernel.org>; Tue, 11 Apr 2023 20:11:36 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at itrosinen.de
Received: from itrosinen.de ([127.0.0.1])
        by localhost (itrosinen.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id P3ZqqLggXWeL for <linux-raid@vger.kernel.org>;
        Tue, 11 Apr 2023 20:11:35 +0200 (CEST)
Received: from www.itrosinen.de (unknown [172.17.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: moritz)
        by itrosinen.de (Postfix) with ESMTPSA id BBC6B40017
        for <linux-raid@vger.kernel.org>; Tue, 11 Apr 2023 20:11:35 +0200 (CEST)
MIME-Version: 1.0
Date:   Tue, 11 Apr 2023 20:11:35 +0200
From:   Moritz Rosin <moritz.rosin@itrosinen.de>
To:     linux-raid@vger.kernel.org
Subject: Recover data from accidentally created raid5 over raid1
Message-ID: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
X-Sender: moritz.rosin@itrosinen.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hey there,

unfortunately I have to admit, that I learned my lesson the hard way 
dealing with software raids.

I had a raid1 running reliable over month using two 4TB HDDs.
Since I ran short on free space I tried to convert the raid1 to a raid5 
in-place (with the plan to add the 3rd HDD after converting).
That's where my incredibly stupid mistake kicked in.

I followed an internet tutorial that told me to do:
mdadm --create /dev/md0 --level=5 --raid-devices=2 /dev/sdX1 /dev/sdY1

I learned that I re-created a raid5 array instead of converting the 
raid1 :-(

Is there any chance to un-do the conversion or restore the data?
Has the process of creation really overwritten data or is there anythins 
left on the disk itself that can be rescued?

Any help would be appreciated. Thanks!!!

Moritz
