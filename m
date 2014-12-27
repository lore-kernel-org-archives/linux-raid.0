From: Phil Turmel <philip@turmel.org>
Subject: Re: md_raid5 recovering failed need help
Date: Sat, 27 Dec 2014 10:24:22 -0500
Message-ID: <549ECF26.2040104@turmel.org>
References: <!&!AAAAAAAAAAAYAAAAAAAAAOgLllvGWotKlJcBYHqu4VUCgQAAEAAAAJjrgwWxkKFFjrGxfwSsmpoBAAAAAA==@hafis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAAOgLllvGWotKlJcBYHqu4VUCgQAAEAAAAJjrgwWxkKFFjrGxfwSsmpoBAAAAAA==@hafis.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stephan Hafiz <forum@hafis.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning David,

{ or Stephan ? }

On 12/25/2014 09:24 AM, Stephan Hafiz wrote:
> Hi! I=E2=80=99m from germany and my raid and me needs help.
> My english isn=E2=80=99t very good, but i think it=E2=80=99s sufficie=
nt. And i think, this mailinglist is my last hope =E2=98=BA

This is the right place for problems with linux raid arrays.

> So on, =E2=80=A6. Here ist my problem.
> The raid5 has lost 2 of 5 disks. First one disk and then the second o=
ne.

Ok.  Not uncommon.

[trim /]

> !SMART Status
> for i in a b c d e f; do echo Device  sd$i; smartctl -H /dev/sd$i | e=
grep overall; echo; done;
> Device sda
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sdb
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sdc
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sdd
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sde
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sdf
> SMART overall-health self-assessment test result: PASSED

It is extremely common to have an overall result of "PASSED" when you
aren't safe at all.  Please redo this without trimming, like so:

for x in /dev/sd[b-f] ; do echo $x ; smartctl -x $x ; done

Paste the result at the end of you next mail--no need to attach nor nee=
d
for pastebin services.

Also, if you still have any syslogs from the time of the failure, it
would be good to see the kernel messages that triggered the drive
ejections from the raid.

> !mdadm version
> mdadm - v3.2.5 - 18th May 2012
> I have read about recent versions 3.3.x @ raid.wiki.kernel.org, i hav=
en=E2=80=99t tested this version.

It may be necessary.  You haven't reported your distro nor your kernel
version.

> !superblock informations
> Only the Events from sdb1 are off

[trim /]

Very good report!  You've saved all the superblocks and you haven't
tried to do any --create operations.

[trim /]

> !reassemble force
> mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /de=
v/sdf1 --force
> mdadm: ignoring /dev/sdd1 as it reports /dev/sdc1 as failed
> mdadm: ignoring /dev/sde1 as it reports /dev/sdc1 as failed
> mdadm: ignoring /dev/sdf1 as it reports /dev/sdc1 as failed
> mdadm: /dev/md0 assembled from 1 drive - not enough to start the arra=
y.

This should have worked.  Hmmm.

> i hope i don=E2=80=99t get the award =E2=80=9Epaint onself in to the =
corner=E2=80=9C =E2=80=A6=E2=80=A6

Probably not. :-)

The simplest way forward would probably be to boot a rescue CD (I
generally use the one from sysrescuecd.org) that has a recent kernel an=
d
mdadm combination.  Such CDs will probably attempt to assemble your
array during boot to /dev/md127 instead of /dev/md0, but it will fail.

So, within the rescue environment, do:

mdadm --stop /dev/md127  {or whatever shows in /proc/mdstat}

mdadm --assemble --force --verbose /dev/md0 /dev/sd[b-f]1

If that doesn't work, show us the verbose output, along with the
matching part of the dmesg.

If it does work, just do a clean shutdown and reboot back into your
regular OS.

> merry christmas =E2=80=A6 David

And Merry Christmas to you!

When you are done celebrating the revival of your array, you will need
to find out why it broke in the first place.  The most common cause see=
n
on this list is the use of consumer-grade drives without dealing with
the timeout mismatch problem.  You might want to review this old thread=
:

http://marc.info/?l=3Dlinux-raid&m=3D135811522817345&w=3D1

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
