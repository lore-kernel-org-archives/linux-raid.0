From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: XP RAID vs md
Date: Wed, 2 Apr 2003 10:17:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012EC6@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Vladimir Milovanovic <vlad@webmail.co.za>, raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm not sure if this is true on XP, but on Win2K the only software RAID=
 available is 0, 1, and 5.  You cannot combine already-created software=
 RAID devices to create RAID10, or RAID50 arrays for instance.  This ty=
pe of array is very easy with Linux software RAID.

So if all that you want is simple arrays, XP would be fine, but for dat=
abase servers that need both redundancy and performance, XP software RA=
ID would probably not work for you.

My 2=A2
Andy.

> -----Original Message-----
> From: Vladimir Milovanovic [mailto:vlad@webmail.co.za]=20
> Sent: Wednesday, April 02, 2003 7:20 AM
> To: raid-list
> Subject: XP RAID vs md
>=20
>=20
> Wow... I hope that one of the maintainers will comment on=20
> this, I didn't=20
> even know that XP had a sw RAID implementation. Up to 100%=20
> more on read=20
> and 60% more on write is quite a significant margin. Is there=20
> anything=20
> in favour of the md driver if this is true?
>=20
>=20
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-raid" in the body of a message to=20
> majordomo@vger.kernel.org More majordomo info at =20
http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
