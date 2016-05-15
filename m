From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Mon, 16 May 2016 01:10:46 +0200
Message-ID: <20160515231046.E3685100A8E@atlas.denx.de>
References: <20160515124534.A42D0100879@atlas.denx.de> <20160515133740.85EC3100879@atlas.denx.de> <20160515153121.GA11365@EIS.leimen.priv> <20160515182524.7B12D100A8E@atlas.denx.de> <20160515183128.GA12823@EIS.leimen.priv> <20160515193516.2C457100879@atlas.denx.de> <20160515203446.GA13218@EIS.leimen.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160515203446.GA13218@EIS.leimen.priv>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Andreas,

In message <20160515203446.GA13218@EIS.leimen.priv> you wrote:
>
> That's strange, if it worked once, it should work twice (if no change=
s=20
> were made outside of the overlays). If you have created the udev rule=
s=20
> file, just in case there is a side effect, remove it again ...

NO, I think it's me to blame.  If I read the bash history correctly,
I made a mistake (confusing $DEVICES and $devices and $overlays)
and ran the --zero-superblock on the real disk devices, not the overlay=
s.

On the other hand, that should not make a real difference if it worked
for the overlays.  Well, it does...

> What does mdadm --examine /dev/mapper/sda say before and after
> you --zero-superblock? (is it the same for the other disks?)

--zero-superblock now porperly reports that it cannot find a
superblock...

> If it's LVM, you could search the first few hundred megs of your devi=
ces for
> the LVM header, that should be the data offset you're looking for.

Ok, but...

> That's LABELONE at offset 0x200 and you have to substract 512 bytes f=
rom it,=20
> so this is actually what it would look like for offset 0.

That would be the --data-offset=3D parameter?

> Alternatively this can also be done using
>=20
>     dd bs=3D1M count=3D1024 if=3D... | strings -t d -n 8 | grep LABEL=
ONE
>     512 LABELONE
>=20
> if your version of strings supports this option.

It does - but I'm confused as I get a number of different values from
the devices:

# for i in /dev/mapper/sd? ; do
> echo $i
> dd bs=3D1M count=3D1024 if=3D$i | strings -t d -n 8 | grep LABELONE
> done
/dev/mapper/sda
 139776 LABELONE
=2E..
/dev/mapper/sdb
=2E..
/dev/mapper/sdc
396826104 LABELONE
=2E..
/dev/mapper/sdd
=2E..
/dev/mapper/sde
387503608 LABELONE
389663524 LABELONE
=2E..
/dev/mapper/sdf
398969636 LABELONE
=2E..

So I have 5 numbers; minus 512 and converted to kB gives:

   139776 ->    139264 ->    136
396826104 -> 396825592 -> 887524.99
387503608 -> 387503096 -> 878410.99
389663524 -> 389663012 -> 380530.28
398969636 -> 398969124 -> 889618.28

Of these, only 136 appears to make sense.  But running

# mdadm --create --verbose /dev/md2 --metadata=3D1.2 --level=3D6   --ra=
id-devices=3D6 --chunk=3D16 --assume-clean --data-offset=3D136 /dev/map=
per/sd?
mdadm: layout defaults to left-symmetric
mdadm: size set to 976762448K
mdadm: automatically enabling write-intent bitmap on large array
mdadm: array /dev/md2 started.

=2E..creates an array, but LVM does not recognise it.

Searching the resulting /dev/md2 for the LABELONE does not find any.

Am I misinterpreting your information?

Best regards,

Wolfgang Denk

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The sixth sick sheik=E2=80=99s sixth sheep=E2=80=99s sick.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
