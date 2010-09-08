From: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Subject: =?iso-8859-1?B?UmU6IDMtd2F5IG1pcnJvcnM=?=
Date: Wed, 08 Sep 2010 07:01:40 +0000
Message-ID: <20100908070140.24742.qmail@s217.sureserver.com>
Reply-To: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>  -------Original Message-------
>  From: Neil Brown <neilb@suse.de>
>  To: Michael Sallaway <michael@sallaway.com>
>  Cc: linux-raid@vger.kernel.org
>  Subject: Re: 3-way mirrors
>  Sent: 08 Sep '10 06:40

>  Yes, it is just reads.
>  It looks like you have an ancient kernel - older than April 2010 :-)
>  A patch went in to 2.6.35 and I think some 2.6.34.y which fixed a bu=
g that
>  causes md to drop devices in a degraded RAID6 when it could have fix=
ed the
>  read error.=A0=A0Commit 7b0bb5368a719
> =20
>  So a newer kernel might fix your problem for you.

Aha -- yep, I'm just using the stock ubuntu kernel, which for 10.04 see=
ms to be back at 2.6.32-22. Yikes!

So that would explain that. I'll see what kernel I can upgrade to, and =
go from there. Thanks for your help!

Cheers,
Michael
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
