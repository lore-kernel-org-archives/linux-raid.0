Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906AFECAAD3
	for <linux-raid@archiver.kernel.org>; Sat, 10 Sep 2022 15:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIJPTA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Sep 2022 11:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIJPS5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Sep 2022 11:18:57 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661D24DB26
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
        :To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HDaMK0rXTINar7T1sbj4DVGzQrmQuA+VoVYS2WBgOOs=; b=VmTZDAsNETX2pzwN934HZBxclz
        nU3zM+KGIOxvMHPOWZjZgR4mO3OgC/yXJ1eDOwEbLcvUcvHzxkpwMzkr29hbzc/OWmT1i5Jugh4UU
        +m3Uoeqx0/6WAQfb5+bU3+/ftUmuvnbIF8pbQ2xdiIPKQj/Xziu92LF4LpDwja1a8WcHk/5LD2FxT
        xkrEgjsNu5tfCRQTyMDt3+du3Q3n4X5qXuuf6RTE7BNw9yiQZYz492RyJpv1ZOVwycBS2ZfeLVXCU
        sHLMQ3N1gzI0lVUqNXdpRwQ5rEWzzYBIgtxZiOonweXvT0H46GEIt/WXDujAOxD7NFqJzP4rogZ+L
        JLhDtMUA==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oX2Fy-0003n3-60; Sat, 10 Sep 2022 15:18:54 +0000
Message-ID: <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org>
Date:   Sat, 10 Sep 2022 11:18:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: RAID5 failure and consequent ext4 problems
Content-Language: en-US
To:     Luigi Fabio <luigi.fabio@gmail.com>
Cc:     linux-raid@vger.kernel.org
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org>
 <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org>
 <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Luigi,

Mixed in responses (and trimmed):

On 9/9/22 18:50, Luigi Fabio wrote:
 > By different kernels, maybe - but the kernel has been the same for
 > quite a while (months).

Yes.  Same kernels are pretty repeatable for device order on bootup as 
long as all are present.  Anything missing will shift the letter 
assignments.

 > I did paste the whole of the command lines in the (very long) email,
 > as David mentions (thanks!) - the first ones, the mistaken ones, did
 > NOT have --assume-clean but they did have -o, so no parity activity
 > should have started according to the docs?

Okay, that should have saved you.  Except, I think it still writes all 
the meta-data.  With v1.2, that would sparsely trash up to 1/4 gig at 
tbe beginning of each device.

 > A new thought came to mind: one of the HBAs lost a channel, right?
 > What if on the subsequent reboot the devices that were on that channel
 > got 'rediscovered' and shunted to the end of the letter order? That
 > would, I believe, be ordinary operating procedure.

Well, yes.  But doesn't matter for assembly attempts, with always go by 
the meta-data.  Device order only ever matters for --create when recreating.

 > That would give us an almost-correct array, which would explain how
 > fsck can get ... some pieces.

If you consistently used -o or --assume-clean, then everything beyond 
~3G should be untouched, if you can get the order right.  Have fsck try 
backup superblocks way out.

 > Also, I am not quite brave enough (...) to use shortcuts when handling
 > mdadm commands.

That's good.  But curly braces are safe.

 > I am reconstructing the port order (scsi targets, if you prefer) from
 > the 20220904 boot log. I should at that point be able to have an exact
 > order of the drives.

Please use lsdrv to capture names versus serial numbers.  Re-run it 
before any --create operation to ensure the current names really do 
match the expected serial numbers.  Keep track of ordering information 
by serial number.  Note that lsdrv will reliably line up PHYs on SAS 
controllers, so that can be trusted, too.

 > Here it is:

[trim /]

 > We have a SCSI target -> raid disk number correspondence.
 > As of this boot, the letter -> scsi target correspondences match,
 > shifted by one because as discussed 7:0:0:0 is no longer there (the
 > old, 'faulty' sdc).

OK.

 > Thus, having univocally determined the prior scsi target -> raid
 > position we can transpose it to the present drive letters, which are
 > shifted by one.
 > Therefore, we can generate, rectius have generated, a --create with
 > the same software versions, the same settings and the same drive
 > order. Is there any reason why, minus the 1.2 metadata overwriting
 > which should have only affected 12 blocks, the fs should 'not' be as
 > before?
 > Genuine question, mind.

Superblocks other than 0.9x and 1.0 place a bad block log and a written 
block bitmap between the superblock and the data area.  I'm not sure if 
any of the remain space is wiped.  These would be written regardless of 
-o or --assume-clean.  Those flags "protect" the *data area* of the 
array, not the array's own metadata.

On 9/9/22 19:04, Luigi Fabio wrote:
 > A further question, in THIS boot's log I found:
 > [ 9874.709903] md/raid:md123: raid level 5 active with 12 out of 12
 > devices, algorithm 2
 > [ 9874.710249] md123: bitmap file is out of date (0 < 1) -- forcing
 > full recovery
 > [ 9874.714178] md123: bitmap file is out of date, doing full recovery
 > [ 9874.881106] md123: detected capacity change from 0 to 42945088192512
 > From, I think, the second --create of /dev/123, before I added the
 > bitmap=none. This should, however, not have written anything with -o
 > and --assume-clean, correct?

False assumption.  As described above.

On 9/9/22 21:29, Luigi Fabio wrote:
 > For completeness' sake, though it should not be relevant, here is the
 > error that caused the mishap:

[trim /]

Noted, and helpful for correlating device names to PHYs.

Okay.  To date, you've only done create with -o or --assume-clean?

If so, it is likely your 0.90 superblocks are still present at the ends 
of the disks.

You will need to zero the v1.2 superblocks that have been placed on your 
partitions.  Then attempt an --assemble and see if mdadm will deliver 
the same message as before, identifying all of the members, but refusing 
to proceed due to event counts.

If so, repeat with --force.

This procedure is safe to do without overlays, and will likely yield a 
running array.

Then you will have to fsck to fix up the borked beginning of your 
filesystem.

Phil

