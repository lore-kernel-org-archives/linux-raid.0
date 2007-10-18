From: Ming Zhang <blackmagic02881@gmail.com>
Subject: RE: [Iscsitarget-devel] Abort Task ?
Date: Thu, 18 Oct 2007 17:35:42 -0400
Message-ID: <1192743342.3596.39.camel@dhcp-117.ibrix.com>
References: <471720F1.40409@systella.fr> <471727F3.2080500@systella.fr>
	 <471734C5.8090405@systella.fr>
	 <E2BB8074E5500C42984D980D4BD78EF9017A2958@MFG-NYC-EXCH2.mfg.prv>
	 <1192721909.3596.15.camel@dhcp-117.ibrix.com>
	 <47178ABF.1040500@systella.fr> <47179492.4000109@systella.fr>
	 <E2BB8074E5500C42984D980D4BD78EF9017A295C@MFG-NYC-EXCH2.mfg.prv>
Reply-To: blackmagic02881@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E2BB8074E5500C42984D980D4BD78EF9017A295C@MFG-NYC-EXCH2.mfg.prv>
Sender: linux-raid-owner@vger.kernel.org
To: "Ross S. W. Walker" <rwalker@medallion.com>
Cc: BERTRAND =?ISO-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>, iscsitarget-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2007-10-18 at 17:03 -0400, Ross S. W. Walker wrote:
> BERTRAND Jo=C3=ABl wrote:
> >=20
> > BERTRAND Jo=C3=ABl wrote:
> > >     I can format serveral times (mkfs.ext3) a 1.5 TB volume=20
> > over iSCSI=20
> > > without any trouble. I can read and write on this virtual=20
> > disk without=20
> > > any trouble.
> > >=20
> > >     Now, I have configured ietd with :
> > >=20
> > > Lun 0 Sectors=3D1464725758,Type=3Dnullio
> > >=20
> > > and I run on initiator side :
> > >=20
> > > Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8192
> > > 479482+0 records in
> > > 479482+0 records out
> > > 3927916544 bytes (3.9 GB) copied, 153.222 seconds, 25.6 MB/s
> > >=20
> > > Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8192
> > >=20
> > >     I'm waitinfor a crash. No one when I write these lines.=20
> >    I suspect=20
> > > an interaction between raid and iscsi.
> >=20
> > 	I simultanely run :
> >=20
> > Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8192
> > 8397210+0 records in
> > 8397210+0 records out
> > 68789944320 bytes (69 GB) copied, 2732.55 seconds, 25.2 MB/s
> >=20
> > and
> >=20
> > Root gershwin:[~] > dd if=3D/dev/sdj of=3D/dev/null bs=3D8192
> > 739200+0 records in
> > 739199+0 records out
> > 6055518208 bytes (6.1 GB) copied, 447.178 seconds, 13.5 MB/s
> >=20
> > 	without any trouble.
>=20
> The speed can definitely be improved. Look at your network setup
> and use ping to try and get the network latency to a minimum.
>=20
> # ping -A -s 8192 172.16.24.140
> ....
> --- 172.16.24.140 ping statistics ---
> 14058 packets transmitted, 14057 received, 0% packet loss, time 9988m=
s
> rtt min/avg/max/mdev =3D 0.234/0.268/2.084/0.041 ms, ipg/ewma 0.710/0=
=2E260 ms
>=20
> You want your avg ping time for 8192 byte payloads to be 300us or les=
s.
>=20
> 1000/.268 =3D 3731 IOPS @ 8k =3D 30 MB/s

he use normal dd, which in turn use page cache and read ahead, so actua=
l
request size at scsi layer can be much larger than 8k....


>=20
> If you use apps that do overlapping asynchronous IO you can see bette=
r
> numbers.
>=20
> -Ross
>=20
> _____________________________________________________________________=
_
> This e-mail, and any attachments thereto, is intended only for use by
> the addressee(s) named herein and may contain legally privileged
> and/or confidential information. If you are not the intended recipien=
t
> of this e-mail, you are hereby notified that any dissemination,
> distribution or copying of this e-mail, and any attachments thereto,
> is strictly prohibited. If you have received this e-mail in error,
> please immediately notify the sender and permanently delete the
> original and any copy or printout thereof.
>=20
--=20
Ming Zhang


@#$%^ purging memory... (*!%
http://blackmagic02881.wordpress.com/
http://www.linkedin.com/in/blackmagic02881
--------------------------------------------

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
