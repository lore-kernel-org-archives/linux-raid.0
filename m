From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Raid6 write performance
Date: Sun, 01 Mar 2009 12:35:41 -0800
Message-ID: <49AAF19D.8050502@zytor.com>
References: <49742E74.9090502@rabbit.us> <49A88DB4.40008@zytor.com> <6c4602af0903011112o440d7a4i22a24b58ada58865@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0903011112o440d7a4i22a24b58ada58865@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBQcnp5xYJ1c2tp?= <mikylie@gmail.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Micha=C5=82 Przy=C5=82uski wrote:
>=20
> I'm afraid that might be incorrect.
>=20
> Let's assume we want to write 100MB of data onto a 4 drive raid6.
> Let's divide 100MB of data into two parts, say A and B, each 50MB big=
=2E
> Writing the data on the raid, would mean writing:
> * A on disk1
> * B on disk2
> * XOR(A,B) on disk3
> * Q(A,B) on disk4
> That is actually assuming 50MB chunk, and whole chunk writes, etc.
> Each of written portions would have been 50MB in size. That sounds
> reasonable to me, as with 2 data disks, only half of data has to be
> written on each. The fact that disks are really striped with data, XO=
R
> and Q doesn't change the image in terms of amount written.
>=20
> I do hope I had understood the situation correctly, but I'll be ever
> happy to be proved wrong.
>=20

Ah, sorry, yes you're of course right.  I was thinking about latency,
not throughput, for some idiotic reason.

	-hpa

--=20
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
