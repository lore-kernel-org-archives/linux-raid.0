From: Francisco Parada <cisco@abitofthisabitofthat.com>
Subject: Re: RAID 6 Not Mounting (Block device is empty)
Date: Sun, 8 Nov 2015 00:59:19 -0500
Message-ID: <251B709D-3310-433E-8817-E875194A69F9@abitofthisabitofthat.com>
References: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com> <563E479E.50409@turmel.org> <6AC4B7C0-0AE8-4E0A-9B25-049025C386C3@abitofthisabitofthat.com> <563E685C.70208@turmel.org> <C57F2260-D20C-4688-93F6-CB3CE8CF9F30@abitofthisabitofthat.com> <563E843E.5060108@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <563E843E.5060108@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Ok.  Those four drives cut out within a few milliseconds of each othe=
r.
So I checked the enclosure=E2=80=99s PSU voltages, and it looks like th=
e +5V rail was running at around +3V and the +12V rail at almost +8V un=
der load.  So I think your original theory of there being a power issue=
 is correct.  It=E2=80=99s a bummer, because I have 2 of these Rosewill=
 8-bay enclosures, and they both show that same issue.  This is very li=
kely why they=E2=80=99ve been discontinued.  Granted the speed on them =
is 1.5Gbps total per channel, but it=E2=80=99s really just for movies, =
so I=E2=80=99m not concerned about high speed read and writes.  I=E2=80=
=99ll just have to McGuyver it and use different PSUs than the ones the=
y came with.  I would imagine, that after about 500GB worth of data bei=
ng transferred, all the writing caused those drives to get pretty hot, =
making the PSU that much more likely to cut power.
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816132016

> Because I do all such maintenance as root.  In an ubuntu system, use
> "sudo su -" to get a full root console.
Ah, gotcha!

> Also, in the future, turn off word wrap when pasting. :-)
Boom!  Done deal, there was a setting in my Apple Mail application unde=
r Mail -> Preferences -> Fonts & Colors -> =E2=80=9CUse fixed-width fon=
t for plain text messages=E2=80=9D.  I think this might fix this word w=
rap issue, so my apologies.  It=E2=80=99s either that, or the fact that=
 I copied and pasted directly from my Terminal application, and it conv=
erted the email to HTML, which changed the format.

Now, onto the butter.  I tried what you told me, and it showed that the=
 devices were busy:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
cisco@DoctorBanner:~$ sudo mdadm -Afv /dev/md127 /dev/sd[b-h]
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdb is busy - skipping
mdadm: /dev/sdc is busy - skipping
mdadm: /dev/sdd is busy - skipping
mdadm: /dev/sde is busy - skipping
mdadm: /dev/sdf is busy - skipping
mdadm: /dev/sdg is busy - skipping
mdadm: /dev/sdh is busy - skipping
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

So I continued to stop the array:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
cisco@DoctorBanner:~$ sudo mdadm --stop /dev/md127
mdadm: stopped /dev/md127
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

Then I tried it once again, but it seems that because they=E2=80=99re d=
isplaying that the Events are out of sync, that it=E2=80=99s not able t=
o start the array.  Any ideas?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
cisco@DoctorBanner:~$ sudo mdadm -Afv /dev/md127 /dev/sd[b-h]
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdb is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sdc is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdd is identified as a member of /dev/md127, slot 5.
mdadm: /dev/sde is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdf is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdg is identified as a member of /dev/md127, slot 2.
mdadm: /dev/sdh is identified as a member of /dev/md127, slot -1.
mdadm: added /dev/sdf to /dev/md127 as 1
mdadm: added /dev/sdg to /dev/md127 as 2
mdadm: added /dev/sdb to /dev/md127 as 3 (possibly out of date)
mdadm: added /dev/sdc to /dev/md127 as 4 (possibly out of date)
mdadm: added /dev/sdd to /dev/md127 as 5 (possibly out of date)
mdadm: added /dev/sdh to /dev/md127 as -1
mdadm: added /dev/sde to /dev/md127 as 0
mdadm: /dev/md127 assembled from 3 drives and 1 spare - not enough to s=
tart the array.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

Thanks again,

Cisco----
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
