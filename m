Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33C1C76196
	for <linux-raid@archiver.kernel.org>; Wed, 12 Apr 2023 01:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDLBFz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Apr 2023 21:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLBFy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Apr 2023 21:05:54 -0400
X-Greylist: delayed 2336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 18:05:52 PDT
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142A63ABB
        for <linux-raid@vger.kernel.org>; Tue, 11 Apr 2023 18:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
        :To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zGlSmt+U8aefo8tx52eP0vIbXqlKX1zz8ES8VJGPOZs=; b=GhhgItRpO+aw27BFj0Lj8up+I7
        TO8baDi1jl2nxmzamgZQvXhQxkJzvzzhv1MVZzUogQ0oNOsbmjeE+lFv8YleaxIJob6hzfdvXlkIW
        Mf6D9VCZomiCl4BVHB2FBHpwQdRW2Myu9CsAXHzu5TrTxGiNvM2SEMJtFQHcGjNlPn7Ta4mwVcRTP
        qWfdGgZRvaJotN3dSMRiVX1FpcEZeGJoIVnqlGMz6kyE3sHAfkZhIwqb+M+nM939hnhquf+Z4pncI
        BnPH7YB5fLd7Yd6qXHFCc1RvOkkwFZx4V/dMAeP+2cNiIqkStOQVi3l7CYCVbulEGXtz7Ou+leB7z
        p31WGLrw==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1pmOK1-00088a-5k; Wed, 12 Apr 2023 00:26:49 +0000
Message-ID: <83e691b8-4127-4691-da03-3c43d50f7a5c@turmel.org>
Date:   Tue, 11 Apr 2023 20:26:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Recover data from accidentally created raid5 over raid1
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>, John Stoffel <john@stoffel.org>,
        Moritz Rosin <moritz.rosin@itrosinen.de>
Cc:     linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
 <25653.47458.489415.933722@quad.stoffel.home>
 <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Moritz, et al,

On 4/11/23 20:18, Wol wrote:
> On 11/04/2023 20:47, John Stoffel wrote:
>>>>>>> "Moritz" == Moritz Rosin <moritz.rosin@itrosinen.de> writes:
>>
>>> Hey there,
>>> unfortunately I have to admit, that I learned my lesson the hard way
>>> dealing with software raids.
>>
>>> I had a raid1 running reliable over month using two 4TB HDDs.
>>> Since I ran short on free space I tried to convert the raid1 to a raid5
>>> in-place (with the plan to add the 3rd HDD after converting).
>>> That's where my incredibly stupid mistake kicked in.
>>
>>> I followed an internet tutorial that told me to do:
>>> mdadm --create /dev/md0 --level=5 --raid-devices=2 /dev/sdX1 /dev/sdY1

Ewww.

>> Please share the link to the tutorial so we can maybe shame that
>> person into fixing it.  Or removing it.
> 
> See below. There's no reason why it shouldn't work, PROVIDED nothing has 
> happened to the mirror since you created it.
>>
>>> I learned that I re-created a raid5 array instead of converting the
>>> raid1 :-(

Indeed.  It would have sync'd every other chunk in opposite directions 
to place "parity" in the right rotation, but otherwise equivalent to a 
mirror.

>> Yeah, I think you're out of luck here.  What kind of filesystem did
>> you have on your setup?  Were you using MD -> LVM -> filesystem stack?
>> Or just a raw filesystem on top of the /dev/md?  device?
> 
> I dunno. A two-disk raid-5 is the same as a 2-disk mirror. That raid-5 
> MAY just start and run and you'll be okay. You can try mounting it 
> read-only and see what happens ...

The odds of matching offsets depends entirely on how old the original 
raid1 was.

>>> Is there any chance to un-do the conversion or restore the data?
>>> Has the process of creation really overwritten data or is there
>>> anythins left on the disk itself that can be rescued?
>>
> If the conversion has overwritten the data, it will merely have 
> overwritten one copy of the data with the other.

Concur.

>> If you have any information on your setup before you did this, then
>> you might be ok, but honestly, I think you're toast.
>>
> It might be a bit of a forensic job, but no I don't think so. Do you 
> have that third 4TB HDD? If so, MAKE A BACKUP of one of the drives. That 
> way, you'll have three copies to play with to try and recover the data.

This.

> As John says, please give us all the information you can. If you've just 
> put a file system on top of the array, you should now have three copies 
> of the filesystem to try and recover. I can't help any further here. but 
> all you have to do is track down the start of said filesystem, work out 
> where you tell linux to start a partition so it correctly contains the 
> filesystem, and then mount said partition. Your data should all be there.

The trick will be to determine the offset.  Please share as much 
information as possible as to the layering of the original setup, 
preferable with the fstab contents if available.

> Actually, you might be better off not copying onto drive 3. If you can 
> work out where your filesystem partition should start, create a 
> partition on drive 3 and copy the filesystem contents into said partition.

Or overlays with dmsetup.

> I've cc'd a couple of people I hope can help, but basically, you need to 
> find out where in the raid array your data has been put, and then work 
> out how to access it. Your data SHOULD be recoverable, but you've got 
> some detective work ahead of you.

Your odds are decent.  Again, share all the info you can.

> 
> Cheers,
> Wol

Phil
