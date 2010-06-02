From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?= <st0ff@gmx.net>
Subject: Re: devices get kicked from RAID about once a month
Date: Wed, 02 Jun 2010 20:29:46 +0200
Message-ID: <4C06A31A.4060907@gmx.net>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



-------- Original-Nachricht --------
Betreff: Re: devices get kicked from RAID about once a month
Datum: Wed, 02 Jun 2010 19:08:58 +0200
Von: Stefan /*St0fF*/ H=FCbner <st0ff@gmx.net>
Antwort an: st0ff@npl.de
An: Dan Christensen <jdc@uwo.ca>

Am 02.06.2010 18:33, schrieb Dan Christensen:
> John Robinson <john.robinson@anonymous.org.uk> writes:
>=20
>> My Samsung Spinpoint F1's can have TLER enabled using a more recent
>> smartctl. It's not appeared as part of a formal release yet but a
>> patch went in to r3065 in SVN:
>> http://sourceforge.net/apps/trac/smartmontools/log/trunk/smartmontoo=
ls
>=20
> Thanks.  I got the svn3077 from Debian testing, but it doesn't seem t=
o
> be supported with my drives:
>=20
> # smartctl -l scterc /dev/sda
> smartctl 5.40 2010-03-16 r3077 [i686-pc-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen,
> http://smartmontools.sourceforge.net
>=20
> Warning: device does not support SCT Commands

There you have it: the drives are not supporting SCT-ERC.  Which I can
say is true: I also own an SP2504C.
>=20
> Any other suggestions?

Not really, it's up to Neil to export some sysfs-variable, where you
could tune how long a drive may take to respond to some command.

The "trying hard to get the data back" can take up to a few minutes
(somewhere I read about 2, somewhere else about 3 minutes).  And what
really is happening is: after some timeout the mdraid "thinks
correctly", that the drive cannot provide the requested sector.  To
prevent failure, it reconstructs the "missing" data and issues a write
request.  Unfortunately the drive still tries to reconstruct the data
itself and will not respond.  After those write requests failing, mdrai=
d
drops the disk.

The ERC-setting is volatile.  You'd have to issue it on every reboot,
and on every hotswap.  But at first you'd have to get drives that
support this setting.

stefan
>=20
> Dan
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
