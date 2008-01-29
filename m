From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 10:00:21 -0600
Message-ID: <479F4D95.3090701@pobox.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <20080129144840.GA4621@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080129144840.GA4621@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen wrote:

> raid10 have a number of ways to do layout, namely the near, far and
> offset ways, layout=3Dn2, f2, o2 respectively.

The default layout, according to --detail, is "near=3D2, far=3D1." If I=
=20
understand what's been written so far on the topic, that's automaticall=
y=20
incompatible with 1+0.

--=20
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
