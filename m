From: =?ISO-8859-1?Q?Ra=FAl_G=F3mez?= Cabrera <raulgomezc@acm.org>
Subject: Re: Removing a RAID 1 setting without loosing data
Date: Sat, 13 May 2006 11:34:10 -0400
Message-ID: <1147534450.6198.24.camel@nachus.raulgomez.net>
References: <1147531525.6198.8.camel@nachus.raulgomez.net>
	 <Pine.LNX.4.56.0605131548450.19433@lion.drogon.net>
	 <1147532647.6198.16.camel@nachus.raulgomez.net>
	 <Pine.LNX.4.56.0605131612030.19433@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0605131612030.19433@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The drive is completely dead, it doesn't appear in the system, the mdad=
m
remove command fails because it says there is no drive (/dev/sdb) on th=
e
system, I'll try to convice my client (again) to install another drive.

BTW: good advise about bad sectors, thanks!
BTW2: I'm playing land of Drogon, I think is really cool!

Raul.


El s=C3=A1b, 13-05-2006 a las 16:16 +0100, Gordon Henderson escribi=C3=B3=
:
> Ask your client just how valuable their email data is...
>=20
> How badly broken is the drive? If it's just a bad sector then you may=
 be
> able to resurect it - which will provide a degree of redundancy again
> util such time as the server can be replaced.
>=20
> If you use mdadm to remove all the md? partitions, (mdadm --remove
> /dev/md? /dev/sdb?) then you can run something like
>=20
>   badblocks -w -s -c 128 /dev/sdb?
>=20
> etc. for every partition that was in the md? arrays. This will write =
to
> every sector and will force a sector re-allocate on bad sectors, if t=
he
> drive supports it. You can then mdadm --add them back into the array.
>=20
> (Running a badblocks in standard read mode on the live partitions is
> always prudent at this point though just in-case you find another ban=
d
> sector there!)
>=20
> Gordon
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
