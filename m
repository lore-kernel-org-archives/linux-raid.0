From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 17:25:04 +0100
Message-ID: <479F5360.1010705@rabbit.us>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <20080129144840.GA4621@rap.rap.dk> <479F4D95.3090701@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F4D95.3090701@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Keld J=C3=B8rn Simonsen wrote:
>=20
>> raid10 have a number of ways to do layout, namely the near, far and
>> offset ways, layout=3Dn2, f2, o2 respectively.
>=20
> The default layout, according to --detail, is "near=3D2, far=3D1." If=
 I=20
> understand what's been written so far on the topic, that's automatica=
lly=20
> incompatible with 1+0.
>=20

Unfortunately you are interpreting this wrong as well. far=3D1 is just =
a way of=20
saying 'no copies of type far'.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
