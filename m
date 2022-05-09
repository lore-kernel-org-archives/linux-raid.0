Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5567C43217
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 07:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiEIHO6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 03:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235521AbiEIG43 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 02:56:29 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C5D158F84
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 23:52:35 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nnxFm-000CTb-Cq;
        Mon, 09 May 2022 07:52:23 +0100
Message-ID: <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk>
Date:   Mon, 9 May 2022 07:52:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Failed adadm RAID array after aborted Grown operation
Content-Language: en-GB
To:     Bob Brand <brand@wmawater.com.au>, linux-raid@vger.kernel.org
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au>
 <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk>
 <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au>
 <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk>
 <00d101d86329$a2a57130$e7f05390$@wmawater.com.au>
 <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au>
 <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au>
 <00eb01d86339$18cc0860$4a641920$@wmawater.com.au>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <00eb01d86339$18cc0860$4a641920$@wmawater.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09/05/2022 01:09, Bob Brand wrote:
> Hi Wol,
> 
> My apologies for continually bothering you but I have a couple of questions:

Did you read the links I sent you?
> 
> 1. How do I overcome the error message "mount: /dev/md125: can't read
> superblock."  Do it use fsck?
> 
> 2. The removed disk is showing as "   -   0   0   30   removed". Is it safe
> to use "mdadm /dev/md2 -r detached" or "mdadm /dev/md2 -r failed" to
> overcome this?

I don't know :-( This is getting a bit out of my depth. But I'm 
SERIOUSLY concerned you're still futzing about with CentOS 7!!!

Why didn't you download CentOS 8.5? Why didn't you download RHEL 8.5, or 
the latest Fedora? Why didn't you download SUSE SLES 15?

Any and all CentOS 7 will come with either an out-of-date mdadm, or a 
Frankenkernel. NEITHER are a good idea.

Go back to the links I gave you, download and run lsdrv, and post the 
output here. Hopefully somebody will tell you the next steps. I will do 
my best.
> 
> Thank you!
> 
Cheers,
Wol
> 
> -----Original Message-----
> From: Bob Brand <brand@wmawater.com.au>
> Sent: Monday, 9 May 2022 9:33 AM
> To: Bob Brand <brand@wmawater.com.au>; Wol <antlists@youngman.org.uk>;
> linux-raid@vger.kernel.org
> Cc: Phil Turmel <philip@turmel.org>
> Subject: RE: Failed adadm RAID array after aborted Grown operation
> 
> I just tried it again with the --invalid_backup switch and it's now showing
> the State as "clean, degraded".and it's showing all the disks except for the
> suspect one that I removed.
> 
> I'm unable to mount it and see the contents. I get the error "mount:
> /dev/md125: can't read superblock."
> 
> Is there more that I need to do?
> 
> Thanks
> 
> 
> -----Original Message-----
> From: Bob Brand <brand@wmawater.com.au>
> Sent: Monday, 9 May 2022 9:02 AM
> To: Bob Brand <brand@wmawater.com.au>; Wol <antlists@youngman.org.uk>;
> linux-raid@vger.kernel.org
> Cc: Phil Turmel <philip@turmel.org>
> Subject: RE: Failed adadm RAID array after aborted Grown operation
> 
> Hi Wol,
> 
> I've booted to the installation media and I've run the following command:
> 
> mdadm
> /dev/md125 --assemble --update=revert-reshape --backup-file=/mnt/sysimage/grow_md125.bak
>   --verbose --uuid= f9b65f55:5f257add:1140ccc0:46ca6c19
> /dev/md125mdadm --assemble --update=revert-reshape --backup-file=/grow_md125.bak
>    --verbose --uuid=f9b65f55:5f257add:1140ccc0:46ca6c19
> 
> But I'm still getting the error:
> 
> mdadm: /dev/md125 has an active reshape - checking if critical section needs
> to be restored
> mdadm: No backup metadata on /mnt/sysimage/grow_md125.back
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
> 
> 
> Should I try the --invalid_backup switch or --force?
> 
> Thanks,
> Bob
> 
> 
> -----Original Message-----
> From: Bob Brand <brand@wmawater.com.au>
> Sent: Monday, 9 May 2022 8:19 AM
> To: Wol <antlists@youngman.org.uk>; linux-raid@vger.kernel.org
> Cc: Phil Turmel <philip@turmel.org>
> Subject: RE: Failed adadm RAID array after aborted Grown operation
> 
> OK.  I've downloaded a Centos 7 - 2009 ISO from centos.org - that seems to
> be the most recent they have.
> 
> 
> -----Original Message-----
> From: Wol <antlists@youngman.org.uk>
> Sent: Monday, 9 May 2022 8:16 AM
> To: Bob Brand <brand@wmawater.com.au>; linux-raid@vger.kernel.org
> Cc: Phil Turmel <philip@turmel.org>
> Subject: Re: Failed adadm RAID array after aborted Grown operation
> 
> How old is CentOS 7? With that kernel I guess it's quite old?
> 
> Try and get a CentOS 8.5 disk. At the end of the day, the version of linux
> doesn't matter. What you need is an up-to-date rescue disk.
> Distro/whatever is unimportant - what IS important is that you are using the
> latest mdadm, and a kernel that matches.
> 
> The problem you have sounds like a long-standing but now-fixed bug. An
> original CentOS disk might be okay (with matched kernel and mdadm), but
> almost certainly has what I consider to be a "dodgy" version of mdadm.
> 
> If you can afford the downtime, after you've reverted the reshape, I'd try
> starting it again with the rescue disk. It'll probably run fine. Let it
> complete and then your old CentOS 7 will be fine with it.
> 
> Cheers,
> Wol
> 
> On 08/05/2022 23:04, Bob Brand wrote:
>> Thank Wol.
>>
>> Should I use a CentOS 7 disk or a CentOS disk?
>>
>> Thanks
>>
>> -----Original Message-----
>> From: Wols Lists <antlists@youngman.org.uk>
>> Sent: Monday, 9 May 2022 1:32 AM
>> To: Bob Brand <brand@wmawater.com.au>; linux-raid@vger.kernel.org
>> Cc: Phil Turmel <philip@turmel.org>
>> Subject: Re: Failed adadm RAID array after aborted Grown operation
>>
>> On 08/05/2022 14:18, Bob Brand wrote:
>>> If you’ve stuck with me and read all this way, thank you and I hope
>>> you can help me.
>>
>> https://raid.wiki.kernel.org/index.php/Linux_Raid
>>
>> Especially
>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>>
>> What you need to do is revert the reshape. I know what may have
>> happened, and what bothers me is your kernel version, 3.10.
>>
>> The first thing to try is to boot from up-to-date rescue media and see
>> if an mdadm --revert works from there. If it does, your Centos should
>> then bring everything back no problem.
>>
>> (You've currently got what I call a Frankensetup, a very old kernel, a
>> pretty new mdadm, and a whole bunch of patches that does who knows what.
>> You really need a matching kernel and mdadm, and your frankenkernel
>> won't match anything ...)
>>
>> Let us know how that goes ...
>>
>> Cheers,
>> Wol
>>
>>
>>
>> CAUTION!!! This E-mail originated from outside of WMA Water. Do not
>> click links or open attachments unless you recognize the sender and
>> know the content is safe.
>>
>>
> 
> 
> 
> CAUTION!!! This E-mail originated from outside of WMA Water. Do not click
> links or open attachments unless you recognize the sender and know the
> content is safe.
> 
> 
> 

