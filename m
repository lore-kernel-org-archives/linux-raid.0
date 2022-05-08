Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C342DC433F5
	for <linux-raid@archiver.kernel.org>; Sun,  8 May 2022 22:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiEHWXD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 May 2022 18:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiEHWXC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 May 2022 18:23:02 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2AEBED9E
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 15:19:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 5D98A19F372;
        Mon,  9 May 2022 08:19:09 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id M86bwE05M0pE; Mon,  9 May 2022 08:19:09 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 2D32819F373;
        Mon,  9 May 2022 08:19:09 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au 2D32819F373
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1652048349;
        bh=ffB5tb2wSer+M+IZnrnM2BhPjPdxwit5tEdxRqXxg+Q=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=FOmRhdDO2AV9bZAZbwVgoJUMvdCbmE0Wx5fwY0TihC7YiRhf77qDRkiQrY2Yl26l2
         J6GFqDRYe60iRywsieskO8bTaTX0yur8FQAcpUbs6DKr3HRSRV99joXFse+17ooq0D
         J5I8yLa5L8y65oPRmwXe/1yv71BsboDwuF+GSLEY=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id L_LrHAFI3b3X; Mon,  9 May 2022 08:19:09 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 0899B19F372;
        Mon,  9 May 2022 08:19:09 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Wol" <antlists@youngman.org.uk>, <linux-raid@vger.kernel.org>
Cc:     "Phil Turmel" <philip@turmel.org>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk> <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au> <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk>
In-Reply-To: <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Mon, 9 May 2022 08:19:08 +1000 (AEST)
Message-ID: <00d101d86329$a2a57130$e7f05390$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P3210 T3bbc R3780)
Content-Language: en-au
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFAYMzo9kBZlg9dKs+9m/w
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

OK.  I've downloaded a Centos 7 - 2009 ISO from centos.org - that seems t=
o=20
be the most recent they have.


-----Original Message-----
From: Wol <antlists@youngman.org.uk>
Sent: Monday, 9 May 2022 8:16 AM
To: Bob Brand <brand@wmawater.com.au>; linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
Subject: Re: Failed adadm RAID array after aborted Grown operation

How old is CentOS 7? With that kernel I guess it's quite old?

Try and get a CentOS 8.5 disk. At the end of the day, the version of linu=
x=20
doesn't matter. What you need is an up-to-date rescue disk.
Distro/whatever is unimportant - what IS important is that you are using =
the=20
latest mdadm, and a kernel that matches.

The problem you have sounds like a long-standing but now-fixed bug. An=20
original CentOS disk might be okay (with matched kernel and mdadm), but=20
almost certainly has what I consider to be a "dodgy" version of mdadm.

If you can afford the downtime, after you've reverted the reshape, I'd tr=
y=20
starting it again with the rescue disk. It'll probably run fine. Let it=20
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



CAUTION!!! This E-mail originated from outside of WMA Water. Do not click=
=20
links or open attachments unless you recognize the sender and know the=20
content is safe.


