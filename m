From: Cry Regarder <cry_regarder@yahoo.com>
Subject: Re: =?utf-8?b?cGF0YV92aWE=?= with software raid1: "attempt to access beyond end of device"
Date: Mon, 30 Jul 2007 19:01:52 +0000 (UTC)
Message-ID: <loom.20070730T203850-197@post.gmane.org>
References: <dju2n4-lcf.ln1@tux.abusar.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

D=C3=A2niel Fraga <fragabr <at> gmail.com> writes:

> 	I have 2 PATA HDs and they always worked perfectly with
> software (kernel) raid1 using the old IDE kernel drivers. Now I use
> the new libata drivers (VIA), and it keep giving those erros messages=
:
>=20
> attempt to access beyond end of device
> md1: rw=3D0, want=3D155284112, limit=3D155284096

Isn't this the standard problem that some hard drives have reserved
areas that the operating system isn't supposed to use?  The old IDE
drivers didn't honor the drive's request not to use.  libata, however,
now behaves correctly and honors it.

libata.ignore_hpa=3D1

https://www.redhat.com/archives/fedora-devel-list/2007-May/msg01695.htm=
l

and

http://fedoraproject.org/wiki/Bugs/F7Common


Now if someone can explain to me if it is safe to write the partition t=
able
saying I only have one partition when I built a raid-5 on /dev/sd? inst=
ead of
/dev/sd?1

Thanks!

Cry

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
