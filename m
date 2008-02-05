From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Auto generation of mdadm.conf
Date: Tue, 05 Feb 2008 18:34:47 +0300
Message-ID: <47A88217.8070003@msgid.tls.msk.ru>
References: <200802051142.19625.admin@domeny.pl>	<20080205132717.238c4312@szpak>	<47A86A12.2090405@msgid.tls.msk.ru> <20080205154713.0ccae001@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080205154713.0ccae001@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Michael Tokarev said:     (by the date of Tue, 05 Feb 2008 16:52:18 +=
0300)
>=20
>> Janek Kozicki wrote:
>>> I'm not using mdadm.conf at all.=20
>> That's wrong, as you need at least something to identify the array
>> components.=20
>=20
> I was afraid of that ;-) So, is that a correct way to automatically
> generate a correct mdadm.conf ? I did it after some digging in man pa=
ges:
>=20
>   echo 'DEVICE partitions' > mdadm.conf
>   mdadm  --examine  --scan --config=3Dmdadm.conf >> ./mdadm.conf=20
>=20
> Now, when I do 'cat mdadm.conf' i get:
>=20
>  DEVICE partitions
>  ARRAY /dev/md/0 level=3Draid1 metadata=3D1 num-devices=3D3 UUID=3D75=
b0f87879:539d6cee:f22092f4:7a6e6f name=3D'backup':0
>  ARRAY /dev/md/2 level=3Draid1 metadata=3D1 num-devices=3D3 UUID=3D4f=
d340a6c4:db01d6f7:1e03da2d:bdd574 name=3Dbackup:2
>  ARRAY /dev/md/1 level=3Draid5 metadata=3D1 num-devices=3D3 UUID=3D22=
f22c3599:613d5231:d407a655:bdeb84 name=3Dbackup:1

Hmm.  I wonder why the name for md/0 is in quotes, while others are not=
=2E

> Looks quite reasonable. Should I append it to /etc/mdadm/mdadm.conf ?

Probably... see below.

> This file currently contains: (commented lines are left out)
>=20
>   DEVICE partitions
>   CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>   HOMEHOST <system>
>   MAILADDR root
>=20
> This is the default content of /etc/mdadm/mdadm.conf on fresh debian
> etch install.

But now I wonder HOW your arrays gets assembled in the first place.

Let me guess... mdrun?  Or maybe in-kernel auto-detection?

The thing is that mdadm will NOT assemble your arrays given this
config.

If you have your disk/controller and md drivers built into the
kernel, AND marked the partitions as "linux raid autodetect",
kernel may assemble them right at boot.  But I don't remember
if the kernel will even consider v.1 superblocks for its auto-
assembly.  In any way, don't rely on the kernel to do this
work, in-kernel assembly code is very simplistic and works
up to a moment when anything changes/breaks.  It's almost
the same code as was in old raidtools...

Another possibility is mdrun utility (shell script) shipped
with Debian's mdadm package.  It's deprecated now, but still
provided for compatibility.  mdrun is even worse, it will
try to assemble ALL arrays found, giving them random names
and numbers, not handling failures correctly, and failing
badly in case of, e.g. a "foreign" disk is found which
happens to contain a valid raid superblock somewhere...

Well.  There's another, 3rd possibility: mdadm can assemble
all arrays automatically (even if not listed explicitly in
mdadm.conf) using homehost (only available with v.1 superblock).
I haven't tried this option yet, so don't remember how it
works.  From the mdadm(8) manpage:

   Auto Assembly
       When --assemble is used with --scan and no devices  are  listed,=
  mdadm
       will  first  attempt  to  assemble  all the arrays listed in the=
 config
       file.

       If a homehost has been specified (either in the config file or  =
on  the
       command line), mdadm will look further for possible arrays and w=
ill try
       to assemble anything that it finds which is tagged as belonging =
to  the
       given  homehost.   This is the only situation where mdadm will a=
ssemble
       arrays without being given specific device name or identity info=
rmation
       for the array.

       If  mdadm  finds a consistent set of devices that look like they=
 should
       comprise an array, and if the superblock is tagged as belonging =
to  the
       given  home host, it will automatically choose a device name and=
 try to
       assemble the array.  If the array uses version-0.90 metadata, th=
en  the
       minor  number as recorded in the superblock is used to create a =
name in
       /dev/md/ so for example /dev/md/3.  If the array uses  version-1=
  meta=E2=80=90
       data,  then  the name from the superblock is used to similarly c=
reate a
       name in /dev/md (the name will have any =E2=80=99host=E2=80=99 p=
refix stripped  first).

So.. probably this is the way your arrays are being assembled, since yo=
u
do have HOMEHOST in your mdadm.conf...  Looks like it should work, afte=
r
all... ;)  And in this case there's no need to specify additional array
information in the config file.

/mjt
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
