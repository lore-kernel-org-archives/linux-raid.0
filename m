From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: add another disk to existing raid 0, ie grow raid 0 possible?
Date: Thu, 26 Jan 2012 14:12:52 +0200
Message-ID: <4F214344.9090505@oldum.net>
References: <4F212A59.1070008@oldum.net>	<CADNH=7GXJ0DW7K5DqSgoYYsa2eSWzE9P46R=Qrehu1pFXqnpyQ@mail.gmail.com>	<20120126215713.0c24db62@notabene.brown>	<4F21396D.7030308@oldum.net> <20120126225234.2d944445@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120126225234.2d944445@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,
sure, take your time. I am rebooting this kernel now and will setup the=
 raid 0 from scratch with 3 disks/partitions.

Best,
- -Nik

On 01/26/2012 01:52 PM, NeilBrown wrote:
> On Thu, 26 Jan 2012 13:30:53 +0200 Nikolay Kichukov <hijacker@oldum.n=
et>
> wrote:
>=20
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>=20
>> Hello Neil,
>=20
>> Here goes the details. Once again, no valuable data, just curious wh=
at has gone wrong in that case:
>=20
>> dmesg output, first I stopped md2, then assembled it again to perfor=
m the grow.
>> http://pastebin.com/HkPVEKad
>=20
> Hmmm... definitely looks sick.
>=20
>=20
>> mdadm -E output:
>> http://pastebin.com/pJCjvrJE
>=20
>> The system runs GNU/Debian testing with latest updates from security=
-testing applied.
>> Kernel: 3.1.0-1-amd64
>> mdadm:  3.2.2-1
>=20
> Those should be recent enough ... I guess I must have broken somethin=
g.  This
> will need more than a couple of minutes - I'll try to have a proper l=
ook next
> week.
>=20
> Thanks for the report,
>=20
> NeilBrown
>=20
>=20
>=20
N=E2=80=B9=C2=A7=C2=B2=C3=A6=C3=ACr=C2=B8=E2=80=BAy=C3=BA=C3=A8=C5=A1=C3=
=98b=C2=B2X=C2=AC=C2=B6=C3=87=C2=A7v=C3=98^=E2=80=93)=C3=9E=C2=BA{.n=C3=
=87+=E2=80=B0=C2=B7=C2=A5=C5=A0{=C2=B1=C2=AD=C2=A8=C2=9D=C5=A0{ay=C2=BA=
=1D=C3=8A=E2=80=A1=C3=9A=E2=84=A2=C3=AB,j=07=C2=AD=C2=A2f=C2=A3=C2=A2=C2=
=B7h=C5=A1=E2=80=B9=C3=A0z=C2=B9=1E=C2=AEw=C2=A5=C2=A2=C2=B8=0C=C2=A2=C2=
=B7=C2=A6j:+v=E2=80=B0=C2=A8=C5=A0w=C3=A8j=C3=98m=C2=B6=C5=B8=C3=BF=C2=BE=
=07=C2=AB=E2=80=98=C3=AA=C3=A7zZ+=C6=92=C3=B9=C5=A1=C5=BD=C5=A0=C3=9D=C2=
=A2j"=C2=9D=C3=BA!tml=3D
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPIUNEAAoJEDFLYVOGGjgX1FcIAMfIYdnO9NjL2+OlqG/Lw+Cz
fRwRKSYKkr2EavY0RAP9Wh5APgi3znhL5HAwA8haZznaMziI6XHSWoOef8UYKG2Y
HMf2H3HR4ICttmJvjlqRfIoLeI431kJ3wP6n/+Y+uFODeGdYFi28qwKaNhwg0ycR
woGO/6UJbOSasOOI2KS3yXcIK8Ag2y1NoGo/Js1TFOjsgN85vYEnwMluuX3Z8EaY
qJAPgvLV5dGzonFbFMpAvf2KZ2eaZBXlzlClbzVn0W7mnuNjM/SeUfUIkH/liq/o
jx+mS+DnFh/7ZqAbe6lNs/HTSSkdOsVm1jMq6ygc0bGjJftwY4z/NHjXGpnGIZQ=3D
=3DUL7k
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
