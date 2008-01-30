From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 16:35:27 +0100
Message-ID: <47A0993F.8000005@rabbit.us>
References: <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <20080129162640.GA16250@rap.rap.dk> <479F5882.8050400@msgid.tls.msk.ru> <20080129180101.GB19527@rap.rap.dk> <47A07D95.2030902@msgid.tls.msk.ru> <47A08E02.3000009@rabbit.us> <20080130152156.GA22131@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080130152156.GA22131@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen wrote:
> On Wed, Jan 30, 2008 at 03:47:30PM +0100, Peter Rabbitson wrote:
>> Michael Tokarev wrote:
>>
>>> With 5-drive linux raid10:
>>>
>>>   A  B  C  D  E
>>>   0  0  1  1  2
>>>   2  3  3  4  4
>>>   5  5  6  6  7
>>>   7  8  8  9  9
>>>  10 10 11 11 12
>>>   ...
>>>
>>> A&B can't be removed - 0, 5.  A&C CAN be removed, as
>>> are A&D.  But not A&E - losing 2 and 7.  And so on.
>=20
> I see. Does the kernel code allow this? And mdadm?
>=20
> And can B+E be removed safely, and C+E and B+D?=20
>=20

It seems like it. I just created the above raid configuration with 5 lo=
op=20
devices. Everything behaved just like Michael described. When the wrong=
 drives=20
disappeared - I started getting IO errors.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
