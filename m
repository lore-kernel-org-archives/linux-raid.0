Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123AEC433EF
	for <linux-raid@archiver.kernel.org>; Sun,  8 May 2022 22:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiEHWIg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 May 2022 18:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiEHWIc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 May 2022 18:08:32 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 54B46AE48
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 15:04:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 0A23C19F372;
        Mon,  9 May 2022 08:04:39 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Vj4CMQJAAeeF; Mon,  9 May 2022 08:04:38 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id D4B3B19F373;
        Mon,  9 May 2022 08:04:38 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au D4B3B19F373
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1652047478;
        bh=VUyB5b7T9QItEsFN58H8nlWpJu1gayEGYQI/In6y+dE=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=JMpLXsXRZmBPQ3djU/sub9GXerJGHQ+ISSeSRLdLqkivzRlTmuctuvJR+FE0YguRs
         JXnGb7gTD+xb9+cPwuKQo+N8fwK7XVr4iX5d4SJ0mut0jB8GOHC/QtFXrZvYhXKjvl
         KaGu8l5WrgxpwZVO/isP473InxuolUByzxHPnGjI=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kJ10cW6FnWig; Mon,  9 May 2022 08:04:38 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id B9D1019F372;
        Mon,  9 May 2022 08:04:38 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Wols Lists" <antlists@youngman.org.uk>,
        <linux-raid@vger.kernel.org>
Cc:     "Phil Turmel" <philip@turmel.org>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk>
In-Reply-To: <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Mon, 9 May 2022 08:04:38 +1000 (AEST)
Message-ID: <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P3210 T3bbc R3727)
Content-Language: en-au
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFq1Y/GuA=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thank Wol.

Should I use a CentOS 7 disk or a CentOS disk?

Thanks

-----Original Message-----
From: Wols Lists <antlists@youngman.org.uk>
Sent: Monday, 9 May 2022 1:32 AM
To: Bob Brand <brand@wmawater.com.au>; linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
Subject: Re: Failed adadm RAID array after aborted Grown operation

On 08/05/2022 14:18, Bob Brand wrote:
> If you=E2=80=99ve stuck with me and read all this way, thank you and I =
hope
> you can help me.

https://raid.wiki.kernel.org/index.php/Linux_Raid

Especially
https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

What you need to do is revert the reshape. I know what may have happened,=
=20
and what bothers me is your kernel version, 3.10.

The first thing to try is to boot from up-to-date rescue media and see if=
 an=20
mdadm --revert works from there. If it does, your Centos should then brin=
g=20
everything back no problem.

(You've currently got what I call a Frankensetup, a very old kernel, a=20
pretty new mdadm, and a whole bunch of patches that does who knows what.
You really need a matching kernel and mdadm, and your frankenkernel won't=
=20
match anything ...)

Let us know how that goes ...

Cheers,
Wol



CAUTION!!! This E-mail originated from outside of WMA Water. Do not click=
=20
links or open attachments unless you recognize the sender and know the=20
content is safe.


