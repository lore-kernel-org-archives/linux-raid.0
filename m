From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 01:26:15 +0100
Message-ID: <479FC427.1080007@rabbit.us>
References: <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <479FBA54.6010009@tmr.com> <20080130002237.GC7975@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080130002237.GC7975@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>
Cc: Bill Davidsen <davidsen@tmr.com>, Moshe Yudkowsky <moshe@pobox.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen wrote:
> On Tue, Jan 29, 2008 at 06:44:20PM -0500, Bill Davidsen wrote:
>=20
>> Depending on near/far choices, raid10 should be faster than raid5, w=
ith=20
>> far read should be quite a bit faster. You can't boot off raid10, an=
d if=20
>> you put your swap on it many recovery CDs won't use it. But for gene=
ral=20
>> use and swap on a normally booted system it is quite fast.
>=20
> Hmm, why would you put swap on a raid10? I would in a production
> environment always put it on separate swap partitions, possibly a num=
ber,
> given that a number of drives are available.
>=20

Because you want some redundancy for the swap as well. A swap partition=
/file=20
becoming inaccessible is equivalent to yanking out a stick of memory ou=
t of=20
your motherboard.

Peter
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
