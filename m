Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F855C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jan 2022 23:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350104AbiARXAR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jan 2022 18:00:17 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:55382 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350094AbiARXAO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Jan 2022 18:00:14 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D471F218A9;
        Tue, 18 Jan 2022 23:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642546813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RL77TAEvD2Kvyu4fNSGd1H+M1V0Xjv/c1VyVI6lxepA=;
        b=RAiIVjbfgwiHQYYv3ZByxRDLs9I3KZMG+fF3GsAIsvv4Scy2deZ3MleDYLkFm2bVLTfvuj
        qZC3UwzF/+XaKnshIslzRVzk48a4fSzI+0rohpDY3ZjO8fXUodfGEFrF/KJHqYKeEnBDNC
        L3y9/ME9s/QWFleWzFWh39FdmCSPmac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642546813;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RL77TAEvD2Kvyu4fNSGd1H+M1V0Xjv/c1VyVI6lxepA=;
        b=BWUt/JEp2Q7TXtgA+IarBWTii3aXZHgZeMHG61lXC0xYG7uMBukYND3w0TC1R/PhOBqWMo
        +JbOR4wgzHYJiZBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B38DA13AF0;
        Tue, 18 Jan 2022 23:00:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iotWG3xG52EDKwAAMHmgww
        (envelope-from <neilb@suse.de>); Tue, 18 Jan 2022 23:00:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "anthony" <antmbox@youngman.org.uk>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Phil Turmel" <philip@turmel.org>
Subject: Re: The mysterious case of the disappearing superblock ...
In-reply-to: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
References: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
Date:   Wed, 19 Jan 2022 10:00:09 +1100
Message-id: <164254680952.24166.7553126422166310408@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 19 Jan 2022, anthony wrote:
> You all know the story of how the cobbler's children are the worst shod, 
> I expect :-) Well, the superblock to my raid (containing /home, etc) has 
> disappeared, and I don't have a backup ... (well I do but it's now well 
> out of date).
> 
> So, a new hard drive is on order, for backup ...
> 
> Firstly, given that superblocks seem to disappear every now and then, 
> does anybody have any ideas for something that might help us track it 
> down? The 1.2 superblock is 4K into the device I believe? So if I copy 
> the first 8K ( dd if=/dev/sda4 of=sda4.img bs=4K count=2 ) of each 
> partition, that might help provide any clues as to what's happened to 
> it? What am I looking for? What is the superblock supposed to look like?

Yes, 4K offset.  Yes, that dd command will get what you want it to.
It hardly matters what the superblock should looks like, because it
won't be there.  The thing you want to know is: what is there?
i.e.  you see random bytes and need to guess what they mean, so you can
guess where they came from.
Best to post the "od -x" output and crowd-source.

Are you sure the partition starts haven't changed? Was the array made of
whole-devices or of partitions?

If you want to find out if the superblock got moved, the maybe searching
for the magic number is best.
Look a the start of super1.c in mdadm.  The first 4 bytes of the
superblock are 0xa92b4efc little-endian.  So: FC 4E 2B A9
The next 4 bytes as 01 00 00 00 ( the major version)
Then the feature map - possibly 0.  Then 4 zero bytes.

If you see something that looks like that, it worth trying to point
mdadm at it.  Create a loop device over the it with an appropriate
offset, and ask mdadm --example to look at it.


> 
> Secondly, once I've backed up my partitions, I obviously need to do 
> --create --assume-clean ... The only snag is, the array has been 
> rebuilt, so I doubt my data offset is the default. The history of the 
> array is simple. It's pretty new, so it will have been created with the 
> latest mdadm, and was originally a mirror of sda4 and sdb4.
> 
> A new drive was added and the array upgraded to raid-5, and I BELIEVE 
> the order is sdc4, sda4, sdb1 - sdb1 being the new drive that was added.
> 
> Am I safe to assume that sdc4 and sda4 will have the same data offset? 
> What is it likely to be? And seeing as it was the last added am I safe 
> to assume that sdb1 is the last drive, so all I have to do is see which 
> way round the other two should be?

I would suggest creating some sparse files the same size as the device,
create loop devices over them, and creating the array in the sequence
you remember doing it - using "--assume-clean" to avoid rebuilds that
would make those sparse files less sparse.
Then look at the metadata written and assume it is will similar to
that which was written to your array.

NeilBrown


> 
> At least the silver lining behind this, is that having been forced to 
> recover my own array, I'll understand it much better helping other 
> people recover theirs!
> 
> Cheers,
> Wol
> 
> 
