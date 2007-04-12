From: "matt s." <cache22@webkorner.com>
Subject: Re: LINEAR RAID, little help
Date: Thu, 12 Apr 2007 07:19:37 -0400
Message-ID: <461E15C9.7010306@webkorner.com>
References: <46177DD8.9080707@pcfusion.co.uk>	<20070407173352.GA23645@gmail.com>	<4617E5E2.2090609@pcfusion.co.uk>	<17948.6604.619118.556382@notabene.brown>	<461DE4CA.9020406@pcfusion.co.uk>	<461DE688.4070808@pcfusion.co.uk> <17949.59661.6968.6058@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17949.59661.6968.6058@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>=20
> md/raid0 makes use of all available space (modulo chunk size).
> To quote from "man md"
>=20
>=20
>        If devices in the array are not all the same size, then once t=
he small=E2=80=90
>        est device has been  exhausted,  the  RAID0  driver  starts  c=
ollecting
>        chunks  into smaller stripes that only span the drives which s=
till have
>        remaining space.
>=20

And at the point where the space is exhausted on all drives but one, I=20
assume it will keep writing to that last one, non-striped?

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
