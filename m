From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 6 Not Mounting (Block device is empty)
Date: Sat, 7 Nov 2015 13:49:02 -0500
Message-ID: <563E479E.50409@turmel.org>
References: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <cisco@abitofthisabitofthat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2015 12:05 PM, Francisco Parada wrote:
> Hello,
>=20
> I=E2=80=99m not sure if this is the right way to go about it, so let =
me give
> you my story.  I had a 7 x 3TB RAID array (12TB in total), 6 drives
> in the array and 1 spare that was also part of the array but simply a
> spare waiting at the ready in case of a drive failure, is what I had
> running before my array broke.  I added two new arrays to my system
> last night, in order to back up my current RAID 6.  The first array
> was a 3 x 3TB RAID 0, for a total of 9TB.  Then a 2 x 1TB RAID 0
> array, for a total of 2TB.  9+2 =3D 11 and although I=E2=80=99m 1TB s=
hy, I knew
> I had a bunch of crap and redundancy to get rid of, I just really
> needed a solid backup after I was going to clean up.

Yes, this is the right way to go about it.  Missed just a few items tha=
t
would help.  Good report.

> After creating the new arrays, I started transferring from my 12TB
> array, 2TB worth of data to the 2TB RAID 0 array.  At some point
> during the transfer, rsync complained of an I/O error.  It seemed to
> have transferred 500GB worth of data before this mishap.  The
> following morning, I noticed that error, and saw that I couldn=E2=80=99=
t
> mount my 12TB array anymore.  Mind you, I didn=E2=80=99t touch this o=
riginal
> array, but I think what happened was that the I/O error blew 2 of my
> drives.
>=20
> What I=E2=80=99m thinking of doing is the following, but I=E2=80=99m =
just looking for
> some advice in case I=E2=80=99m missing anything:
>=20
> sudo mdadm create --assume-clean --level=3D6 --raid-devices=3D7 --siz=
e=3D2930135040 /dev/md127 /dev/sde /dev/sdf /dev/sdg /dev/sdh missing
missing /dev/sdd

Absolutely not!

Your array went from running to dead in minutes, so the variation of
event counts doesn't matter that much.  You should forcibly re-assemble
with all devices.

However, before you do *anything*, you need to figure out why so many
devices were ejected from your array.  Was it a controller glitch?  A
power supply failure?  Or, most likely, Unrecoverable Read Errors being
exposed by your first-ever backup, combined with timeout mismatch?

Any attempt to reassemble/recreate/recovery will simply blow up again i=
f
the root cause isn't addressed.

In your next reply, please paste:

1) the dmesg from the time around the event, +/- a few minutes.

2) the output of the following drive diagnostics:

for x in /dev/sd[a-z] ; do echo $x ; smartctl -i -A -l scterc $x ; done

Do *not* perform any --create operation on your array.

*Do* read the list archives linked below -- if any part of it is
unclear, please ask in your next reply.

Phil

[1] http://marc.info/?l=3Dlinux-raid&m=3D139050322510249&w=3D2
[2] http://marc.info/?l=3Dlinux-raid&m=3D135863964624202&w=3D2
[3] http://marc.info/?l=3Dlinux-raid&m=3D135811522817345&w=3D1
[4] http://marc.info/?l=3Dlinux-raid&m=3D133761065622164&w=3D2
[5] http://marc.info/?l=3Dlinux-raid&m=3D132477199207506
[6] http://marc.info/?l=3Dlinux-raid&m=3D133665797115876&w=3D2
[7] http://marc.info/?l=3Dlinux-raid&m=3D142487508806844&w=3D3
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
