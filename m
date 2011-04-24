From: NeilBrown <neilb@suse.de>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQ=?= RAID5-asking for some
 assistance
Date: Sun, 24 Apr 2011 12:54:01 +1000
Message-ID: <20110424125401.3de3720d@notabene.brown>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
	<20110422125734.1a68a736@notabene.brown>
	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>
	<20110423074411.78fef94f@notabene.brown>
	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>
	<20110423184824.55ee7893@notabene.brown>
	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>
	<20110424075101.6763309f@notabene.brown>
	<BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Valarti <mdadmuser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 23 Apr 2011 18:07:37 -0600 John Valarti <mdadmuser@gmail.com> w=
rote:

> On Sat, Apr 23, 2011 at 3:51 PM, NeilBrown <neilb@suse.de> wrote:
> > On Sat, 23 Apr 2011 10:19:31 -0600 John Valarti <mdadmuser@gmail.co=
m> wrote:
> >
> >> On Sat, Apr 23, 2011 at 2:48 AM, NeilBrown <neilb@suse.de> wrote:
> >> >> No luck
> >> >> Same thing:
> >> >> "no devices found.."
> >> >
> >> > I'm sure it said more than just that. =A0Complete error messages=
 really are
> >> > helpful..
> >> >
> >> > But the implication seems to be that /dev/sd[acd] don't exist...=
 That is
> >> > weird.
> >> > What does "cat /proc/partitions" show?
> >> > If e.g. =A0sda is there but sda2 is not, does "blockdev --reread=
pt /dev/sda"
> >> > help?
> >> >
> >> > NeilBrown
> >>
> >> They exist.
> >> I have physically removed the dead drive, so now the 3 remaining o=
nes
> >> are at sd[abc]
> >> I have a usb thumb drive plugged in to capture outputs as needed, =
it is sdd.
> >> blockdev does not seem to exist on this system.
> >>
> >> If useful I now have some more of the same 250GB drives, and I can
> >> plug one in to the sdb port and make partitions on it, and so on..
> >>
> >> For example fdisk -l shows all my partitions. I also show the outp=
ut
> >> you asked for proc/partitions:
> >>
> >> Disk /dev/sda: 251.0 GB, 251000193024 bytes
> >> 255 heads, 63 sectors/track, 30515 cylinders
> >> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> >>
> >> =A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0=
Blocks =A0 Id =A0System
> >> /dev/sda1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A017 =A0 =A0=
 =A0136521 =A0 fd =A0Linux raid autodetect
> >> /dev/sda2 =A0 =A0 =A0 =A0 =A0 =A0 =A018 =A0 =A0 =A0 30515 =A0 2449=
75185 =A0 fd =A0Linux raid autodetect
> >>
> >> Disk /dev/sdb: 251.0 GB, 251000193024 bytes
> >> 255 heads, 63 sectors/track, 30515 cylinders
> >> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> >>
> >> =A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0=
Blocks =A0 Id =A0System
> >> /dev/sdb1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A017 =A0 =A0=
 =A0136521 =A0 fd =A0Linux raid autodetect
> >> /dev/sdb2 =A0 =A0 =A0 =A0 =A0 =A0 =A018 =A0 =A0 =A0 30515 =A0 2449=
75185 =A0 fd =A0Linux raid autodetect
> >>
> >> Disk /dev/sdc: 251.0 GB, 251000193024 bytes
> >> 255 heads, 63 sectors/track, 30515 cylinders
> >> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> >>
> >> =A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0=
Blocks =A0 Id =A0System
> >> /dev/sdc1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A017 =A0 =A0=
 =A0136521 =A0 fd =A0Linux raid autodetect
> >> /dev/sdc2 =A0 =A0 =A0 =A0 =A0 =A0 =A018 =A0 =A0 =A0 30515 =A0 2449=
75185 =A0 fd =A0Linux raid autodetect
> >>
> >> Disk /dev/sdd: 1039 MB, 1039663104 bytes
> >> 255 heads, 63 sectors/track, 126 cylinders
> >> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> >>
> >> =A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0=
Blocks =A0 Id =A0System
> >> /dev/sdd1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 127 =A0 =A0 =
1015264+ =A0 c =A0W95 FAT32 (LBA)
> >> Partition 1 has different physical/logical endings:
> >> =A0 =A0 =A0phys=3D(125, 254, 63) logical=3D(126, 101, 39)
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> major minor =A0#blocks =A0name
> >>
> >> =A0 =A07 =A0 =A0 0 =A0 =A0 111000 loop0
> >> =A0 =A08 =A0 =A0 0 =A0245117376 sda
> >> =A0 =A08 =A0 =A0 1 =A0 =A0 136521 sda1
> >> =A0 =A08 =A0 =A0 2 =A0244975185 sda2
> >> =A0 =A08 =A0 =A016 =A0245117376 sdb
> >> =A0 =A08 =A0 =A017 =A0 =A0 136521 sdb1
> >> =A0 =A08 =A0 =A018 =A0244975185 sdb2
> >> =A0 =A08 =A0 =A032 =A0245117376 sdc
> >> =A0 =A08 =A0 =A033 =A0 =A0 136521 sdc1
> >> =A0 =A08 =A0 =A034 =A0244975185 sdc2
> >> =A0 =A08 =A0 =A048 =A0 =A01015296 sdd
> >> =A0 =A08 =A0 =A049 =A0 =A01015264 sdd1
> >>
> >> --
> >> John
> >
> >
> > I really cannot help you until you show me the output of "mdadm --a=
ssemble
> > --verbose ..." like I asked.
> >
> > NeilBrown
> >
>=20
> I really WAS NOT lying!

I never thought you were lying.  But you were summarising.  And when pe=
ople
summarise instead of giving exact messages I cannot be sure exactly wha=
t was
excluded.  I could guess - but the chances are that I would be wrong.

>=20
> I just did it again, and redirected output to a file
>=20
> The file ( located on my USB stick) contains:
>=20
> mdadm: looking for devices for /dev/md1
> mdadm: no devices found for /dev/md1

Thank you.  This is helpful.
It implies that there mdadm didn't actually try including any devices i=
n the
array, which is very odd because you listed some devices on the command=
 line
for it to try.
So I'm a bit confused.

Could you please run this set of commands exactly as given and send me =
the
complete output.  Maybe put them in a file and run
  sh -x file > /path/on/usb 2>&1


cat /proc/mdstat
mdadm --stop --verbose /dev/md1
ls -l /dev/sd[acd]2
mdadm -E /dev/sd[acd]2
mdadm -Afvv /dev/md1 /dev/sd[acd]2
cat /proc/mdstat
dmesg | tail -100


Thanks,
NeilBrown


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
