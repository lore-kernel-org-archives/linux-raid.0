From: Tommy Apel Hansen <tommyapeldk@gmail.com>
Subject: Re: raid1 read balance with write mostly
Date: Sat, 02 Feb 2013 23:16:23 +0100
Message-ID: <1359843383.430.18.camel@workstation-home>
References: <36edd03089332985af9a97eeaf719cd3@mail1.volny.cz>
	 <510D8A8C.5090505@hardwarefreak.com> <20130203040758.5e2e7f3c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130203040758.5e2e7f3c@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: stan@hardwarefreak.com, tomas.hodek@volny.cz, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2013-02-03 at 04:07 +0600, Roman Mamedov wrote:
> On Sat, 02 Feb 2013 15:52:12 -0600
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
>=20
> > So under heavy read load, in this case we'd probably want the slow =
3TB drive
> > to contribute to the workload.
>=20
> No, it should behave as documented.
>=20
>        -W, --write-mostly
>               subsequent devices listed in a --build, --create, or --=
add  com=E2=80=90
>               mand will be flagged as 'write-mostly'.  This is valid =
for RAID1
>               only and means that the 'md'  driver  will  avoid  read=
ing  from
>               these devices if at all possible.
                             ^^^^^^^^^^^^^^^^^^^
I would assume that if the kernel thinks the SSD is starved for io (tha=
t
being the %util column in iostat) it would consider sending io to the
HDD. At least that would be what I would expect to happen, so if the SS=
D
reports wrong utilization numbers back or anything else involved in the
io processing the the behavior is as expected.

> =20
>=20
> if at all possible =3D if there is any other mirror still alive, do n=
ot read from
> this one.
>=20
> BTW I also run an SSD+HDD array, and after a brief testing today I di=
d notice
> some reads from the HDD on reading from the array showing up in iosta=
t. So I
> can confirm the bug.
>=20


/Tommy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
