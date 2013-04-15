From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: MD does not wait for drives on start-up with kernels 3.8+
Date: Mon, 15 Apr 2013 14:45:30 +0600
Message-ID: <20130415144530.183d7b31@natsu>
References: <20130330190538.4e3c1771@natsu>
	<CAGqmV7qmPHYpm1rinfsh5W-mgqo+Va2RvQtZoy-5AazYFAHYdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eRCKzIZlsBMQ7mEV.3jn_qv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qmPHYpm1rinfsh5W-mgqo+Va2RvQtZoy-5AazYFAHYdg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eRCKzIZlsBMQ7mEV.3jn_qv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 31 Mar 2013 09:36:30 +0400
CoolCold <coolthecold@gmail.com> wrote:

> In similar situation (but on 2.6.2x kernels i AFAIR, with scsi drives)
> I've used rootdelay param -
> http://lists.debian.org/debian-user/2012/01/msg00748.html to make md
> assembly succeed. Hope this will help you too.

Thanks, rootdelay=3D10 seems to have solved the problem.

...
[    3.860538] scsi 12:0:0:0: Direct-Access     ATA      Hitachi HDS5C302 M=
L6O PQ: 0 ANSI: 5
[    3.860716] sd 12:0:0:0: Attached scsi generic sg8 type 0
[    3.860879] sd 12:0:0:0: [sdi] 3907029168 512-byte logical blocks: (2.00=
 TB/1.81 TiB)
[    3.860906] sd 12:0:0:0: [sdi] Write Protect is off
[    3.860908] sd 12:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    3.860920] sd 12:0:0:0: [sdi] Write cache: enabled, read cache: enabled=
, doesn't support DPO or FUA
[    3.872747]  sdi: sdi1 sdi2 sdi3
[    3.873014] sd 12:0:0:0: [sdi] Attached SCSI disk
[    4.144402] scsi 14:0:0:0: Direct-Access     ChipsBnk   Multi-Reader   4=
082 PQ: 0 ANSI: 2
[    4.145294] sd 14:0:0:0: Attached scsi generic sg9 type 0
[    4.147579] sd 14:0:0:0: [sdj] Attached SCSI removable disk
[    4.179650] ata14: SATA link down (SStatus 0 SControl 300)
[    4.601802] hid-generic 0003:051D:0002.0001: hiddev0,hidraw0: USB HID v1=
.10 Device [American Power Conversion Back-UPS RS 500 FW:30.j5.I USB FW:j5]=
 on usb-0000:00:12.0-3/input0
[    4.601987] input: Logitech HID compliant keyboard as /devices/pci0000:0=
0/0000:00:12.2/usb1/1-6/1-6.1/1-6.1:1.0/input/input2
[    4.602051] hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.1=
0 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:12.2-6.1/input0
[    4.606121] input: Logitech HID compliant keyboard as /devices/pci0000:0=
0/0000:00:12.2/usb1/1-6/1-6.1/1-6.1:1.1/input/input3
[    4.606647] hid-generic 0003:046D:C30E.0003: input,hidraw2: USB HID v1.1=
0 Device [Logitech HID compliant keyboard] on usb-0000:00:12.2-6.1/input1
[   12.537344] nbd: registered device at major 43
[   12.599970] md: md0 stopped.
[   12.603855] md: bind<sde3>
[   12.604029] md: bind<sda3>
[   12.604139] md: bind<sdi3>
[   12.604290] md: bind<sdc3>
[   12.604618] md: bind<sdb3>
[   12.604779] md: bind<sdd3>
[   12.604982] md: bind<sdh3>
...

This was NOT required on any of the previous kernels, so I wonder why all of
sudden with the 3.8+ kernels my system needs an extra "crutch" just to keep
starting up properly.


--=20
With respect,
Roman

--Sig_/eRCKzIZlsBMQ7mEV.3jn_qv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFrvisACgkQTLKSvz+PZwgn+ACdGr5rwItluOXoDXaP94Q/dTnG
68AAn2XdVrKo1WNWsbhyuIoVpA24o4d8
=oypx
-----END PGP SIGNATURE-----

--Sig_/eRCKzIZlsBMQ7mEV.3jn_qv--
