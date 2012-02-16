From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: add another disk to existing raid 0, ie grow raid 0 possible?
Date: Thu, 16 Feb 2012 17:38:52 +0200
Message-ID: <4F3D230C.5000503@oldum.net>
References: <4F212A59.1070008@oldum.net>	<CADNH=7GXJ0DW7K5DqSgoYYsa2eSWzE9P46R=Qrehu1pFXqnpyQ@mail.gmail.com>	<20120126215713.0c24db62@notabene.brown>	<4F21396D.7030308@oldum.net>	<20120209145054.4443a48b@notabene.brown>	<4F352541.2050207@oldum.net>	<20120213090727.1d06291f@notabene.brown>	<4F3A2CC2.4090101@oldum.net> <20120216175553.654595b4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120216175553.654595b4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,
It really might be fixed in recent code, just for consistency:

dpkg -l | grep mdadm
ii  mdadm                                         3.2.3-2              =
            tool to administer Linux MD arrays
(software RAID)

uname -a
Linux hanna64 3.1.0-1-amd64 #1 SMP Tue Jan 10 05:01:58 UTC 2012 x86_64 =
GNU/Linux



Cheers,
- -Nik

On 02/16/2012 08:55 AM, NeilBrown wrote:
> On Tue, 14 Feb 2012 11:43:30 +0200 Nikolay Kichukov <hijacker@oldum.n=
et>
> wrote:
>=20
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>=20
>> Hello Neil,
>> Here is the result, I think I managed to reproduce it as it has conv=
erted the raid0 to raid4.
>=20
>=20
>> so commands in sequence:
>=20
>> mdadm --verbose --create /dev/md/mdtest --level=3D0 --raid-devices=3D=
2 --metadata=3D1.2 /dev/loop0 /dev/loop1
>> mdadm: chunk size defaults to 512K
>> mdadm: array /dev/md/mdtest started.
>=20
>> strace -o /tmp/foo -f mdadm --grow /dev/md/mdtest --raid-devices=3D3=
 --add /dev/loop2
>> mdadm: level of /dev/md/mdtest changed to raid4
>> mdadm: /dev/loop2 not large enough to join array
>> mdadm: Need to backup 3072K of critical section..
>> mdadm: /dev/md/mdtest: Cannot grow - need a spare or backup-file to =
backup critical section
>> mdadm: aborting level change
>=20
>=20
> I tried exactly that and it worked perfectly.
> Maybe the bug has been fixed.
> Please remind me exactly which versions of mdadm and linux you are us=
ing.
>=20
> Thanks,
> NeilBrown
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

iQEcBAEBAgAGBQJPPSMMAAoJEDFLYVOGGjgXKWgH/3W4VqM65Dq4j0XIpyDUYi2B
ATFvVtzmBfiXvNnVBDdP953OK5bBrdcfXUbqYcRUOnzIPEcnxycWxtAe4qO/+OT5
ZJVajCD5JT8dD/xpSbW+bqi9CHo1kRzCfQmI9GydIYykfN6qjS7jfJqH4Jp6Au/w
2UFE0ZyZvB9pVrORdUCCZ7r0Zj2ctofqhxAG1Rip1ZZXtpuSHayIib5gUBx2S/JB
=46QPElqbaEureoDzG5fSg3IMBB7Sc37AjxzxbWkvYd1mBe2e9v4GHnsjv+wEukR95
e5VMr1NZ31AUzeQJR9YQW0NEjE/x/dar9+3jTXwZ1J2Z/1j08lsx9yL4kum3KDQ=3D
=3DgOyk
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
