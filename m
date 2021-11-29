Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D95C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 29 Nov 2021 21:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhK2Vx3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 Nov 2021 16:53:29 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:45378 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhK2Vv2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 Nov 2021 16:51:28 -0500
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 8A30E24258;
        Mon, 29 Nov 2021 16:48:09 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 26063A7672; Mon, 29 Nov 2021 16:48:05 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24997.19093.110727.118664@quad.stoffel.home>
Date:   Mon, 29 Nov 2021 16:48:05 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Wol <antlists@youngman.org.uk>
Cc:     John Stoffel <john@stoffel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Nothing wrong, but is my website advice wonky?
In-Reply-To: <f80d37f6-afb6-4080-d80d-7457a7d26b90@youngman.org.uk>
References: <1c63e476-b253-cb17-3299-f9d09453ee19@youngman.org.uk>
        <12dd9f53-aab2-c487-9663-b799c2d0e8dd@youngman.org.uk>
        <24995.58211.78152.138025@quad.stoffel.home>
        <f80d37f6-afb6-4080-d80d-7457a7d26b90@youngman.org.uk>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Wol" == Wol  <antlists@youngman.org.uk> writes:

Wol> On 28/11/2021 20:15, John Stoffel wrote:
>>>>>>> "Wol" == Wol  <antlists@youngman.org.uk> writes:
>> 
Wol> Problem solved! My usual problem of missing the detail...
>> 
>> How was the problem solved?  Can you provide details on the before and
>> after setup?  It should be trivial to test with loop back devices.
>> 
Wol> I'd described starting with a 2-drive mirror and converting it to
Wol> a 3-drive raid-5. I was actually starting with a 2-active-1-spare
Wol> mirror ...

Wol> So I converted it to raid-5, and because there were only two active 
Wol> drives, it carried on running as a degraded two-drive raid-5.

Wol> Once I brought the spare into service with --raid-devices=3, it started 
Wol> reshaping.

Ah... that explains it.  

Wol> The website said to add the new drive and set raid-devices to three, I 
Wol> misread my own stuff and thought simply converting to raid-5 would bring 
Wol> in the spare.

>> So if you had removed the spare before hand, would it have jumped
>> straight to a three drive RAID 5 setup? 

Wol> No - because I didn't tell it to use all three drives.

>> And curious why you didn't
>> goto RAID6?  RAID5 just makes me nervous these days, I don't trust it
>> since drives tend to fail in waves.

Wol> Well, with two DVD drives and a floppy in an old chassis, I've
Wol> only got room for three drives. Well, there should be room for
Wol> four, but my drives are a bit too fat ... :-)

I understand.  We all have to work within our limits.  

Wol> Plus (1) I've had no trouble so far with my drives (famous last words), 
Wol> (2) the drives are two new Ironwolves and an old Barracuda so I'm only 
Wol> likely to lose one so long as I keep an eye on things, and (3) all the 
Wol> drives have dm-integrity on them, so a corrupt drive should sort itself out.

>> But in my home system, I also mostly just mirror (or even triple
>> mirror!) my important data for both speed and ease of recovery.
>> 
Wol> The trouble with a plain mirror is if your data is corrupted ...

Wol> And if you've got raid you need to keep an eye on it. I'm planning to 
Wol> get an 8TB drive for backups ... probably configure it to snapshot once 
Wol> a week (I'm running lvm over raid over dm-integrity) and then use rsync 
Wol> to back up the volume over the network. Mind you I'm going to have to 
Wol> learn a lot of rsync - configure client/server and then get it to back 
Wol> up just the one file ...

I've got an external USB-3 4tb drive I'm running rclone to, and
planning on taking it to the bank one of these days when I remember to
do so.

