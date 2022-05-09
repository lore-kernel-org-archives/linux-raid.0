Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BADC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 01:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbiEIB3h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 May 2022 21:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiEIANn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 May 2022 20:13:43 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 442BB5594
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 17:09:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 8FC1B19F372;
        Mon,  9 May 2022 10:09:49 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ROhcUjwt2Sbp; Mon,  9 May 2022 10:09:49 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 4B54219F373;
        Mon,  9 May 2022 10:09:49 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au 4B54219F373
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1652054989;
        bh=mHtcaPYAQEeemV4qu7OkUwGfSxkJ45Wc8Qy3Q/+ybnE=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=VZQK3kplkzJcnwf9L8eSHzookUPcqaPEH7qngSDNtooxnP5T3Xd7QEdVyIUzaRkmo
         EpShzzTobPL5MB7NTVp5L9NRILgP/1fd42DJSQro8xSYoLMbt38/xLZOG3xD//JLsL
         /WhPxynZQsIynMKlyEUYxszUZWuTVul4/b7SGBO0=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id V0fCUVEefvxv; Mon,  9 May 2022 10:09:49 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id EB25819F372;
        Mon,  9 May 2022 10:09:48 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Bob Brand" <brand@wmawater.com.au>,
        "Wol" <antlists@youngman.org.uk>, <linux-raid@vger.kernel.org>
Cc:     "Phil Turmel" <philip@turmel.org>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk> <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au> <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk> <00d101d86329$a2a57130$e7f05390$@wmawater.com.au> <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au> <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au>
In-Reply-To: <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Mon, 9 May 2022 10:09:48 +1000 (AEST)
Message-ID: <00eb01d86339$18cc0860$4a641920$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P3210 T3bbc R4142)
Content-Language: en-au
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFAYMzo9kBZlg9dAGZ0oLFAdWidsoCQWnqlasRjYig
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Wol,

My apologies for continually bothering you but I have a couple of questio=
ns:

1. How do I overcome the error message "mount: /dev/md125: can't read=20
superblock."  Do it use fsck?

2. The removed disk is showing as "   -   0   0   30   removed". Is it sa=
fe=20
to use "mdadm /dev/md2 -r detached" or "mdadm /dev/md2 -r failed" to=20
overcome this?

Thank you!


-----Original Message-----
From: Bob Brand <brand@wmawater.com.au>
Sent: Monday, 9 May 2022 9:33 AM
To: Bob Brand <brand@wmawater.com.au>; Wol <antlists@youngman.org.uk>;=20
linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
Subject: RE: Failed adadm RAID array after aborted Grown operation

I just tried it again with the --invalid_backup switch and it's now showi=
ng=20
the State as "clean, degraded".and it's showing all the disks except for =
the=20
suspect one that I removed.

I'm unable to mount it and see the contents. I get the error "mount:
/dev/md125: can't read superblock."

Is there more that I need to do?

Thanks


-----Original Message-----
From: Bob Brand <brand@wmawater.com.au>
Sent: Monday, 9 May 2022 9:02 AM
To: Bob Brand <brand@wmawater.com.au>; Wol <antlists@youngman.org.uk>;=20
linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
Subject: RE: Failed adadm RAID array after aborted Grown operation

Hi Wol,

I've booted to the installation media and I've run the following command:

mdadm
/dev/md125 --assemble --update=3Drevert-reshape --backup-file=3D/mnt/sysi=
mage/grow_md125.bak
 --verbose --uuid=3D f9b65f55:5f257add:1140ccc0:46ca6c19
/dev/md125mdadm --assemble --update=3Drevert-reshape --backup-file=3D/gro=
w_md125.bak
  --verbose --uuid=3Df9b65f55:5f257add:1140ccc0:46ca6c19

But I'm still getting the error:

mdadm: /dev/md125 has an active reshape - checking if critical section ne=
eds=20
to be restored
mdadm: No backup metadata on /mnt/sysimage/grow_md125.back
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.


Should I try the --invalid_backup switch or --force?

Thanks,
Bob


-----Original Message-----
From: Bob Brand <brand@wmawater.com.au>
Sent: Monday, 9 May 2022 8:19 AM
To: Wol <antlists@youngman.org.uk>; linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
Subject: RE: Failed adadm RAID array after aborted Grown operation

OK.  I've downloaded a Centos 7 - 2009 ISO from centos.org - that seems t=
o
be the most recent they have.


-----Original Message-----
From: Wol <antlists@youngman.org.uk>
Sent: Monday, 9 May 2022 8:16 AM
To: Bob Brand <brand@wmawater.com.au>; linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
Subject: Re: Failed adadm RAID array after aborted Grown operation

How old is CentOS 7? With that kernel I guess it's quite old?

Try and get a CentOS 8.5 disk. At the end of the day, the version of linu=
x
doesn't matter. What you need is an up-to-date rescue disk.
Distro/whatever is unimportant - what IS important is that you are using =
the
latest mdadm, and a kernel that matches.

The problem you have sounds like a long-standing but now-fixed bug. An
original CentOS disk might be okay (with matched kernel and mdadm), but
almost certainly has what I consider to be a "dodgy" version of mdadm.

If you can afford the downtime, after you've reverted the reshape, I'd tr=
y
starting it again with the rescue disk. It'll probably run fine. Let it
complete and then your old CentOS 7 will be fine with it.

Cheers,
Wol

On 08/05/2022 23:04, Bob Brand wrote:
> Thank Wol.
>
> Should I use a CentOS 7 disk or a CentOS disk?
>
> Thanks
>
> -----Original Message-----
> From: Wols Lists <antlists@youngman.org.uk>
> Sent: Monday, 9 May 2022 1:32 AM
> To: Bob Brand <brand@wmawater.com.au>; linux-raid@vger.kernel.org
> Cc: Phil Turmel <philip@turmel.org>
> Subject: Re: Failed adadm RAID array after aborted Grown operation
>
> On 08/05/2022 14:18, Bob Brand wrote:
>> If you=E2=80=99ve stuck with me and read all this way, thank you and I=
 hope
>> you can help me.
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid
>
> Especially
> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>
> What you need to do is revert the reshape. I know what may have
> happened, and what bothers me is your kernel version, 3.10.
>
> The first thing to try is to boot from up-to-date rescue media and see
> if an mdadm --revert works from there. If it does, your Centos should
> then bring everything back no problem.
>
> (You've currently got what I call a Frankensetup, a very old kernel, a
> pretty new mdadm, and a whole bunch of patches that does who knows what=
.
> You really need a matching kernel and mdadm, and your frankenkernel
> won't match anything ...)
>
> Let us know how that goes ...
>
> Cheers,
> Wol
>
>
>
> CAUTION!!! This E-mail originated from outside of WMA Water. Do not
> click links or open attachments unless you recognize the sender and
> know the content is safe.
>
>



CAUTION!!! This E-mail originated from outside of WMA Water. Do not click
links or open attachments unless you recognize the sender and know the
content is safe.



