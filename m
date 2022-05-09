Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A98AC433FE
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 13:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiEINLd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 09:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbiEINLc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 09:11:32 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id B575323E353
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 06:07:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 9ACE819F35E;
        Mon,  9 May 2022 23:07:31 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pGhkNv70L5T5; Mon,  9 May 2022 23:07:31 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 6127119F371;
        Mon,  9 May 2022 23:07:31 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au 6127119F371
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1652101651;
        bh=TiWZSACWwYbJmWBcd4EVZmA3jnXpPEYzrwtFjV4xMTM=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=WnsLsReYy6kv8urOewIUNMOTOcTcPVDmU+9lg9MQIp5G2BcMIPQ0vHtA3YJZW0Sx9
         JN0jUyLGQfnvi/ZXu7UKmt6T7rOnums5AW7vet2rJCHEp/ZawDdHhbCbOZMtZTlCW5
         dCUCqQEcDXJt9Q4VECBaaAc5wdfo8yducxA4qWBg=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TZoDiiMQDirR; Mon,  9 May 2022 23:07:31 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 29EDB19F35E;
        Mon,  9 May 2022 23:07:31 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Wols Lists" <antlists@youngman.org.uk>,
        <linux-raid@vger.kernel.org>
Cc:     "Phil Turmel" <philip@turmel.org>, "NeilBrown" <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk> <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au> <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk> <00d101d86329$a2a57130$e7f05390$@wmawater.com.au> <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au> <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au> <00eb01d86339$18cc0860$4a641920$@wmawater.com.au> <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk>
In-Reply-To: <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Mon, 9 May 2022 23:07:31 +1000 (AEST)
Message-ID: <002601d863a5$bd9f5880$38de0980$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P4764 T66f8 R515)
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFAYMzo9kBZlg9dAGZ0oLFAdWidsoCQWnqlQI7z0N+AMQVcYqq+lu9gA==
Content-Language: en-au
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Wol,

I did read the links you sent, actually I'd already trawled through them=20
prior to subscribing to the mailing list. They're how I learned about the=
=20
mailing list.

It seems that the conventional version of CentOS 8.5 is no longer availab=
le,=20
there's just the CentOS 8 Streams version and I wasn't sure how it would =
go=20
with the old style of CentOS. To be honest it didn't occur to me to go wi=
th=20
another flavour of Linux, I just figured that I'd use CentOS to repair=20
CentOS.

Anyway, I did try using "mdadm /dev/md2 -r detached" and "mdadm /dev/md2 =
-r=20
failed" to remove the removed disk to no avail.  I ended up using=20
"mdadm --grow /dev/md125 --array-size=20
218789036032 --backup-file=3D/mnt/sysimage/grow_md125_size_grow.bak --ver=
bose"=20
followed by "mdadm --grow=20
/dev/md125 --raid-devices=3D30 --backup-file=3D/mnt/sysimage/grow_md125_g=
row_disks.bak=20
 --verbose" and it seems to be working in that it is reshaping the array=20
although it is apparently going to take around 16,000 minutes (would that=
 be=20
because we've about 200TB of data?).

My concern now is whether or not I'll still have the mount issue once it=20
finally completes the reshape.  If it does mount OK, does that mean I'm g=
ood=20
to reboot it?

With regards to your comment about downloading lsdrv, I'll try and do tha=
t=20
although I'm having trouble configuring my DNS servers in the running res=
cue=20
disk OS. I could run lsblk but, from what I see of lsdrv, lsblk doesn't h=
ave=20
the detail that lsdrv has. I'll keep working on that and let you know wha=
t I=20
get - it looks like I have to edit it to use the older version of Python=20
that this installation has.

Cheers,
Bob



-----Original Message-----
From: Wols Lists <antlists@youngman.org.uk>
Sent: Monday, 9 May 2022 4:52 PM
To: Bob Brand <brand@wmawater.com.au>; linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>; NeilBrown <neilb@suse.com>
Subject: Re: Failed adadm RAID array after aborted Grown operation

On 09/05/2022 01:09, Bob Brand wrote:
> Hi Wol,
>
> My apologies for continually bothering you but I have a couple of=20
> questions:

Did you read the links I sent you?
>
> 1. How do I overcome the error message "mount: /dev/md125: can't read
> superblock."  Do it use fsck?
>
> 2. The removed disk is showing as "   -   0   0   30   removed". Is it=20
> safe
> to use "mdadm /dev/md2 -r detached" or "mdadm /dev/md2 -r failed" to
> overcome this?

I don't know :-( This is getting a bit out of my depth. But I'm SERIOUSLY=
=20
concerned you're still futzing about with CentOS 7!!!

Why didn't you download CentOS 8.5? Why didn't you download RHEL 8.5, or =
the=20
latest Fedora? Why didn't you download SUSE SLES 15?

Any and all CentOS 7 will come with either an out-of-date mdadm, or a=20
Frankenkernel. NEITHER are a good idea.

Go back to the links I gave you, download and run lsdrv, and post the out=
put=20
here. Hopefully somebody will tell you the next steps. I will do my best.
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
> I just tried it again with the --invalid_backup switch and it's now
> showing the State as "clean, degraded".and it's showing all the disks
> except for the suspect one that I removed.
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
> I've booted to the installation media and I've run the following comman=
d:
>
> mdadm
> /dev/md125 --assemble --update=3Drevert-reshape --backup-file=3D/mnt/sy=
simage/grow_md125.bak
>   --verbose --uuid=3D f9b65f55:5f257add:1140ccc0:46ca6c19
> /dev/md125mdadm --assemble --update=3Drevert-reshape --backup-file=3D/g=
row_md125.bak
>    --verbose --uuid=3Df9b65f55:5f257add:1140ccc0:46ca6c19
>
> But I'm still getting the error:
>
> mdadm: /dev/md125 has an active reshape - checking if critical section
> needs to be restored
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
> OK.  I've downloaded a Centos 7 - 2009 ISO from centos.org - that
> seems to be the most recent they have.
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
> Try and get a CentOS 8.5 disk. At the end of the day, the version of
> linux doesn't matter. What you need is an up-to-date rescue disk.
> Distro/whatever is unimportant - what IS important is that you are
> using the latest mdadm, and a kernel that matches.
>
> The problem you have sounds like a long-standing but now-fixed bug. An
> original CentOS disk might be okay (with matched kernel and mdadm),
> but almost certainly has what I consider to be a "dodgy" version of mda=
dm.
>
> If you can afford the downtime, after you've reverted the reshape, I'd
> try starting it again with the rescue disk. It'll probably run fine.
> Let it complete and then your old CentOS 7 will be fine with it.
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
>>> If you=E2=80=99ve stuck with me and read all this way, thank you and =
I hope
>>> you can help me.
>>
>> https://raid.wiki.kernel.org/index.php/Linux_Raid
>>
>> Especially
>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrog
>> n
>>
>> What you need to do is revert the reshape. I know what may have
>> happened, and what bothers me is your kernel version, 3.10.
>>
>> The first thing to try is to boot from up-to-date rescue media and
>> see if an mdadm --revert works from there. If it does, your Centos
>> should then bring everything back no problem.
>>
>> (You've currently got what I call a Frankensetup, a very old kernel,
>> a pretty new mdadm, and a whole bunch of patches that does who knows=20
>> what.
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
> CAUTION!!! This E-mail originated from outside of WMA Water. Do not
> click links or open attachments unless you recognize the sender and
> know the content is safe.
>
>
>




CAUTION!!! This E-mail originated from outside of WMA Water. Do not click=
=20
links or open attachments unless you recognize the sender and know the=20
content is safe.


