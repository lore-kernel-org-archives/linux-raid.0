From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Tue, 22 Feb 2011 14:06:39 -0500
Message-ID: <4D64093F.2050507@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<4D5C273E.7020609@turmel.org>	<4D5C4176.80604@gmail.com>	<4D5C4204.5020106@turmel.org>	<1377706586882297883@unknownmsgid>	<4D5C6016.6060809@turmel.org>	<AANLkTi=P5vPKa0JwqcjM3D6u2v9AaK9D35SbJv8Yn+0E@mail.gmail.com>	<4D5D2723.1010101@turmel.org>	<6037962689649361915@unknownmsgid>	<AANLkTik6k7kG1CEj=ESsjUcDJVp58cG_bV4Jx3zrd7LM@mail.gmail.com>	<4D5D52AE.8070602@turmel.org>	<AANLkTi=MZ4vo+H16UMuUsVSA2_D-Wp+sFP-5RqOksjXm@mail.gmail.com>	<4D5FE208.5020700@turmel.org>	<AANLkTinOXJWRw_et2U43R_T9XPBzQLnN56Kf2bOAz=_c@mail.gmail.com>	<4D5FED98.6060407@turmel.org>	<AANLkTin4u9yk4XPiHzFtagrdV5_iZJZ0+P+yHqH0x9bm@mail.gmail.com>	<4D61707D.4040304@turmel.org>	<AANLkTimL5y_-RPB9KvTM_N_kMojO6v94PNKjeC+4C=T5@mail.gmail.com>	<4D61A64B.6090708@turmel.org>	<AANLkTikcDiKp
 _iPxaP9Ke231Rnb-wOgJP3owXUVxnkSD@mail.gmail.com> <AANLkTimDnfjqC=gUiUb2qshXOMeR_zKK8M55tOGmP+V-@mail.gmail.com> <4D63FF1F.4030201@turmel.org> <4D640226.5010505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D640226.5010505@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/22/2011 01:36 PM, Simon McNair wrote:
> Phil,
> phew I didn't know that:
> "mdadm: /dev/sdo has wrong uuid.
> mdadm: /dev/sdn1 has wrong uuid."
>=20
> was just that the array UUID didn't match mdadm.conf, it would be nic=
e if it said:
>=20
> "mdadm: /dev/sdo uuid does not match mdadm.conf.
> mdadm: /dev/sdn1 uuid does not match mdadm.conf"
> my mdadm.conf now reads
>=20
> DEVICE partitions
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
> HOMEHOST <system>
> MAILADDR root
> # ARRAY /dev/md/0 level=3Draid5 metadata=3D1.1 num-devices=3D10 UUID=3D=
0a72e40f:aec6f80f:a7004457:1a84a7a8 name=3Dpro=EF=BF=BDlox:0
> ARRAY /dev/md/0 metadata=3D1.1 UUID=3D12c2af00:10681e10:fb17e449:1404=
739c name=3Dproxmox:0

You can strip it down to be effectively "auto", but I wouldn't remove i=
t.  Since you are using partitioned devices throughout your system, som=
ething like this:

DEVICE /dev/sd*[0-9]
AUTO all

Or slightly more restrictive:

DEVICE /dev/sd*[0-9]
ARRAY /dev/md/0 UUID=3D12c2af00:10681e10:fb17e449:1404739c

> I'm afraid to do another reboot incase something else goes wrong ;-).=
  Just for my info, when I only have a single array there isn't much ch=
ance of it being assigned anything other than md0, so could I not just =
leave mdadm.conf empty ?

LVM doesn't care what device name the physical volumes end up with.  Pl=
ease reboot when the system is quiet again to make sure your new mdadm.=
conf works.  Or stop your array, and then do a "mdadm --assemble --scan=
", which is effectively the same.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
