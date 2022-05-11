Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E080EC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 13:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbiEKNWo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 09:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243883AbiEKNWP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 09:22:15 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id A556323148
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 06:22:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id E9E6019F373;
        Wed, 11 May 2022 23:22:07 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 1VYddSluZahu; Wed, 11 May 2022 23:22:07 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id B9C3719F375;
        Wed, 11 May 2022 23:22:07 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au B9C3719F375
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1652275327;
        bh=bE7jzxXU9FwN1HF7SN/v385npTR4muzNh8goZgslvpk=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=CdTqpZIdfZRE1egj4qrOAvy4kYlX2y53JLzhjiz9ymvKbGJNzSbfhz7mGjV9tZzfp
         wYcG9zxoRouaHXDFOcTuNrkQLcOmt8/je+2si3Tx2dXpcr+7fpYTYmvE/sdH55Wesv
         bf555P99QkPZfPBD7LcNGnmEfTpYRKoray737gkI=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id luSM9PlHfo8W; Wed, 11 May 2022 23:22:07 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 8949019F373;
        Wed, 11 May 2022 23:22:07 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Reindl Harald" <h.reindl@thelounge.net>,
        "Roger Heflin" <rogerheflin@gmail.com>,
        "Wols Lists" <antlists@youngman.org.uk>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Phil Turmel" <philip@turmel.org>, "NeilBrown" <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk> <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au> <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk> <00d101d86329$a2a57130$e7f05390$@wmawater.com.au> <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au> <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au> <00eb01d86339$18cc0860$4a641920$@wmawater.com.au> <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk> <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com> <019701d864f9$7c87ab90$759702b0$@wmawater.com.au> <4fc8c8b4-cfc2-81b2-40d6-13c9d8c940bb@thelounge.net>
In-Reply-To: <4fc8c8b4-cfc2-81b2-40d6-13c9d8c940bb@thelounge.net>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Wed, 11 May 2022 23:22:07 +1000 (AEST)
Message-ID: <01f501d8653a$1ccf8420$566e8c60$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P4764 T66f8 R7810)
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFAYMzo9kBZlg9dAGZ0oLFAdWidsoCQWnqlQI7z0N+AMQVcYoBrcfnAQIP8nq4AeCBcYOq0J7YgA==
Content-Language: en-au
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sorry Reindl.  I'm not sure I understand. Are you saying I did or didn't =
do=20
the right thing in booting from a CentOS rescue disk? At the moment it's=20
running from the rescue disk and, be it the best distro to have used (or=20
not), I would imagine that I need to keep running from the rescue disk un=
til=20
the reshape is complete as rebooting in the middle of a reshape is what g=
ot=20
me in this mess.

Thanks

-----Original Message-----
From: Reindl Harald <h.reindl@thelounge.net>
Sent: Wednesday, 11 May 2022 10:36 PM
To: Bob Brand <brand@wmawater.com.au>; Roger Heflin <rogerheflin@gmail.co=
m>;=20
Wols Lists <antlists@youngman.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>; Phil Turmel=20
<philip@turmel.org>; NeilBrown <neilb@suse.com>
Subject: Re: Failed adadm RAID array after aborted Grown operation



Am 11.05.22 um 07:39 schrieb Bob Brand:
> Do I understand that you would recommend upgrading our installation of
> Linux once the repair is complete or are advising downloading and
> compiling a new kernel as part of the repair?  Or are you suggesting
> that it was the fact that we=E2=80=99re on such an old version of CentO=
S that
> caused this mess?  I ask because once this is repaired (assuming it
> does complete successfully), I would like to extend the array to the
> full 45 drives of which this server is capable

you where adivised doing thatg with a live-iso of whatever distribution w=
ith=20
a recent kernel and recent mdadm and leave your installed os alone



CAUTION!!! This E-mail originated from outside of WMA Water. Do not click=
=20
links or open attachments unless you recognize the sender and know the=20
content is safe.


