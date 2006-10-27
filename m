From: Daniel Korstad <dan@korstad.net>
Subject: Re: future hardware
Date: Fri, 27 Oct 2006 16:56:16 -0500
Message-ID: <1161986176.3068.9.camel@localhost.localdomain>
References: <000901c6f509$1bd65560$eb00000a@mine3ad5e808fe>
	 <45427892.4070008@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3Uwa7K8Su71LmrCfLztB"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45427892.4070008@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-3Uwa7K8Su71LmrCfLztB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I have a case what will fit seven HD in standard bays.  Than I have four
bays of 5.25 for DVD/CD drives, so I bought this;
http://www.newegg.com/product/product.asp?item=3DN82E16841101035

leaving me one 5.25 left for the fan.  In addition to the fan in the
item above, I have the exhaust fan on the Power Supply, another 12mm
exhaust fan and a 12mm intake that blows across the other HDs.

This is my current case, with a little mod for an extra drive;
http://www.newegg.com/Product/Product.asp?Item=3DN82E16811133133

I have ten drives in it now.  Two in a RAID1 for the OS and eight in a
RAID6.

If I were to do it again, I would buy this...
http://www.newegg.com/Product/Product.asp?Item=3DN82E16811112064



On Fri, 2006-10-27 at 17:22 -0400, Bill Davidsen wrote:
> Dan wrote:
>=20
> >I have been using an older 64bit system, socket 754 for a while now.  It=
 has
> >the old PCI bus 33Mhz.  I have two low cost (no HW RAID) PCI SATA I card=
s
> >each with 4 ports to give me an eight disk RAID 6.  I also have a Gig NI=
C,
> >on the PCI bus.  I have Gig switches with clients connecting to it at Gi=
g
> >speed.
> >
> >As many know you get a peak transfer rate of 133 MB/s or 1064Mb/s from t=
hat
> >PCI bus http://en.wikipedia.org/wiki/Peripheral_Component_Interconnect
> >
> >The transfer rate is not bad across the network but my bottle neck it th=
e
> >PCI bus.  I have been shopping around for new MB and PCI-express cards. =
 I
> >have been using mdadm for a long time and would like to stay with it.  I=
 am
> >having trouble finding an eight port PCI-express card that does not have=
 all
> >the fancy HW RAID which jacks up the cost.  I am now considering using a=
 MB
> >with eight SATA II slots onboard.  GIGABYTE GA-M59SLI-S5 Socket AM2 NVID=
IA
> >nForce 590 SLI MCP ATX.
> >
> >What are other users of mdadm using with the PCI-express cards, most cos=
t
> >effective solution?
> >
> There may still be m/b available with multiple PCI busses. Don't know if=20
> you are interested in a low budget solution, but that would address=20
> bandwidth and use existing hardware.
>=20
> Idle curiousity: what kind of case are you using for the drives? I will=20
> need to spec a machine with eight drives in the December-January timefram=
e.
>=20

--=-3Uwa7K8Su71LmrCfLztB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQIVAwUARUKAf6LXAbJFWFH0AQK2nRAAxnt+YhR/u8182UhjbwV8LmTNPvZ/SeHq
YeP45u3rKmtXKa7UCU+l7AwGC6AhHa8J00WXWpBuHP+GALe2U6Je1AZi4Pjv5hSz
9iVfSPe9tA2FZ99LD2Piaq6GtXEVF8eEFHTOjiO/be1DnqXLX4jCOC26Gwkkf/yF
4vAkVy2YAC2l+rHGNuzhe1KW/RAYV1yBSm4s/0DhsSkOtFnDJAimx0KyBm+h+6Yz
7IO4/9yzHauQTsLPPYkMs1UJxrEQo3pe2T7f+Quz1Uav26DvYJJpLG44I6OBftCz
8K/uH8rWlzdTzm0cZzgzBZjrPZEPdDFylErQNo+tvDuOYSsXleiz/7vprD/Bvakz
NEcL0AZcGrXej+Tdc4QNXuqiJgX8Ua3b32/kzU6itawuQKp+bJrqkTsWj4kjmaRV
Xzbt0ahKYh69PjHkpMR66xUT4yZzKlrXNp0WkR6yqXVfUp8pPMrAa3Amf3M1YCvf
hV4HlTZJC/641/GSfTVdoNzYedX8EEyTBXfm2kr06N+lKZQEvVVsm0baWQFF/Ac/
xHf2lNbhikoNUHwQ1FnVh+R0MBkbo5aO3bAhD5rFF9fuqpAnV34BR+UNySyQlW+v
clmmPyNEmehRfsgRLlf6Yh47rWJ6D5r6zLE6nCNiPpi/g2B8jdm4AZg81jtiJLHs
Q5Clu2lMesk=
=gyuM
-----END PGP SIGNATURE-----

--=-3Uwa7K8Su71LmrCfLztB--

