From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: raid partition crash
Date: Mon, 25 Aug 2003 04:08:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F496F8C.8070803@hum.auc.dk>
References: <000201c36aac$37729080$1902a8c0@magnus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000201c36aac$37729080$1902a8c0@magnus>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Chambon wrote:

> =3D=3D=3D=3D=3D=3D=3D=3DFrom /proc/mdstat=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Personalities : [raid1]
> read_ahead 1024 sectors
> md0 : active raid1 hda6[0] hdc6[1](F)
                             ^^---- hdc6 is still is the array, it is j=
ust
marked as failed.

>       115411840 blocks [2/1] [U_]
> md2 : active raid1 hda5[0] hdc5[1]
>       532608 blocks [2/2] [UU]
> md1 : active raid1 hda3[0] hdc3[1]
>       2047680 blocks [2/2] [UU]
> md3 : active raid1 hda2[0] hdc2[1]
>       2047680 blocks [2/2] [UU]
> md4 : active raid1 hda1[0] hdc1[1]
>       20544 blocks [2/2] [UU]
> unused devices: <none>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>=20
>=20
>=20
> As others hdc partitions seem to work fine, I assume there is not har=
dware
> problem with hdc.

You shouldn't really assume that. You really should do a test on this
partition (raid/write to it with dd, and see if the error occurs again)=
=2E

> So I tried to reinsert hdc6 to md0 with: raidhotadd -a /dev/md0 /dev/=
hdc6
> but I get the following error:
>=20
> /dev/md0: can not hot-add disk: disk busy!

You'll need to remove the disk from the array, before you can add it ba=
ck.
Currently, it is just marked as failed.

--=20
Mads Peter Bach
Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st - (+45) 96358062
# whois MPB1-DK@whois.dk-hostmaster.dk

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
