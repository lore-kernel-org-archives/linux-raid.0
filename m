From: Olivier Mueller <om-lists-linux@omx.ch>
Subject: Re: "megaraid mbox: critical hardware error" on new dell poweredge
	1850, suse 9.2, kernel 2.6.8
Date: Mon, 24 Jan 2005 20:49:32 +0100
Message-ID: <1106596172.5082.12.camel@bigapple.omnis.ch>
References: <1106436197.14192.4.camel@bigapple.omnis.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1106436197.14192.4.camel@bigapple.omnis.ch>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2005-01-23 at 00:23 +0100, Olivier Mueller wrote:
> I'm trying to get a quite standard "suse linux 9.2" setup working
> on a brand new dell poweredge 1850 with 2 scsi disks in raid1 setup.
>=20
> Installation went completely fine, everything is working. But now (an=
d
> every time), after 2-3h of uptime and some high disk I/O load (rsync =
of
> some GB of data), it badly crashes with the following messages:
>                                                                      =
                                                                       =
          =20
> -------------------------------------------------------------------
> megaraid: aborting-1164069 cmd=3D2a <c=3D1 t=3D0 l=3D0>
> megaraid abort: 1164069:48[255:0], fw owner
> megaraid: aborting-1164070 cmd=3D2a <c=3D1 t=3D0 l=3D0>
> megaraid abort: 1164070:59[255:0], fw owner
> megaraid: aborting-1164071 cmd=3D2a <c=3D1 t=3D0 l=3D0>
> megaraid abort: 1164071:19[255:0], fw owner
> megaraid: aborting-1164072 cmd=3D2a <c=3D1 t=3D0 l=3D0>
> megaraid abort: 1164072:18[255:0], fw owner


=46YI, I tried some "load tests" with under linux kernel 2.4 (knoppix,=20
with module megaraid2 loaded, and it doesn't crash yet after 2-3h of
work  (under 2.6 and megaraid it would have crashed after 30 minutes).

Has the megaraid module been "improved" between 2.4 and 2.6 ?  The
server is brand new, and the disks doesn't seem overheated...=20
Is there anybody else working with dell 1850 servers ? :)

regards,
Olivier
--=20
_______________________________________________________
 Olivier M=FCller - PGP key ID: 0x0E84D2EA - Switzerland=20
    E-Mail: http://omx.ch/mail/ - AIM/iChat: swix3k


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
