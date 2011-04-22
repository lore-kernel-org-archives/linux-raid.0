From: NeilBrown <neilb@suse.de>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQ=?= RAID5-asking for some
 assistance
Date: Fri, 22 Apr 2011 12:57:34 +1000
Message-ID: <20110422125734.1a68a736@notabene.brown>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Valarti <mdadmuser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 21 Apr 2011 20:32:57 -0600 John Valarti <mdadmuser@gmail.com> w=
rote:

> On Thu, Apr 21, 2011 at 1:59 PM, David Brown <david.brown@hesbynett.n=
o> wrote:
> .
> > My first thought would be to get /all/ the disks, not just the "fai=
led"
> > ones, out of the machine. =A0You want to make full images of them (=
with
> > ddrescue or something similar) to files on another disk, and then w=
ork with
> > those images. =A0..
> > Once you've got some (hopefully most) of your data recovered from t=
he
> > images, buy four /new/ disks to put in the machine, and work on you=
r
> > restore. =A0You don't want to reuse the failing disks, and probably=
 the other
> > two equally old and worn disks will be high risk too.
>=20
> OK, I think I understand.
> Does that mean I need to buy 8 disks, all the same size or bigger?
> The originals are 250GB SATA so that should be OK, I guess.
>=20
> I read some more and found out I should run mdadm --examine.
>=20
> Should I not be able to just add the one disk partition sdc2 back to =
the RAID?

Possibly.

It looks like sdb2 failed in October 2009 !!!! and nobody noticed.  So =
your
array has been running degraded since then.

If you

 mdadm -A /dev/md1 --force /dev/sd[acd]2

Then you will have your array back, though there could be a small amoun=
t of
data corruption if the array was in the middle of writing when the syst=
em
crashed/died/lost-power/whatever-happened.

This will give you access to your data.
How much you trust your drives to continue to give access to your data =
is up
to you.  But you would be wise to at least by a 1TB drive to copy all t=
he
data on to before you put too much stress on your old drives.

Once you have a safe copy, you could

 mdadm /dev/md1 --add /dev/sdb2

This will add sdb2 to the array and it will recovery the data for sdb2 =
from
the data and parity on the other drives.  If this works - great.  Howev=
er
there is a reasonable chance you will hit a read error in which case th=
e
recovery will abort and you will still have your data on the degraded a=
rray.

You could possibly run some bad-blocks test on each drive (which will b=
e
destructive - but you  have a backup on the 1TB drive) and decide if yo=
u want
to throw them out or keep using them.


What ever you do, once you have a work array again what you feel happy =
to
trust, make sure a 'check' run happens regularly.  Some distros provide=
 a
cron job to do this for you.  It involves simply
   echo check > /sys/block/md0/md/sync_action

This will read every block on every device to make sure there are no sl=
eeping
bad blocks.  Every month is probably a reasonable frequency to run it.

Also run "mdadm --monitor" configured to send you email if there is a d=
rive
failure.  Also run "mdadm --monitor --oneshot" from a cron tab every da=
y so
that if you have a degraded array it will nag you about it every day.

Good luck,
NeilBrown

>=20
>=20
> Here is the result of --examine
>=20
> /dev/sda2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : ddf4d448:36afa319:f0917855:03f8bbe8
> =A0Creation Time : Mon May 15 16:38:05 2006
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
> =A0 =A0 Array Size : 734925312 (700.88 GiB 752.56 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 3
> Preferred Minor : 1
>=20
> =A0 =A0Update Time : Mon Apr 18 07:48:54 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> Active Devices : 3
> Working Devices : 3
> Failed Devices : 1
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : 5674ce60 - correct
> =A0 =A0 =A0 =A0 Events : 28580020
>=20
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 256K
>=20
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =
=A0active sync =A0 /dev/sdb2
>=20
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdb2
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc2
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed
> /dev/sdb2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : ddf4d448:36afa319:f0917855:03f8bbe8
> =A0Creation Time : Mon May 15 16:38:05 2006
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
> =A0 =A0 Array Size : 734925312 (700.88 GiB 752.56 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 4
> Preferred Minor : 1
>=20
> =A0 =A0Update Time : Sun Oct 18 10:04:06 2009
> =A0 =A0 =A0 =A0 =A0State : active
> Active Devices : 4
> Working Devices : 4
> Failed Devices : 0
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : 5171dcb2 - correct
> =A0 =A0 =A0 =A0 Events : 20333614
>=20
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 256K
>=20
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 50 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0active sync =A0 /dev/sdd2
>=20
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdb2
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc2
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 50 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd2
> /dev/sdc2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : ddf4d448:36afa319:f0917855:03f8bbe8
> =A0Creation Time : Mon May 15 16:38:05 2006
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
> =A0 =A0 Array Size : 734925312 (700.88 GiB 752.56 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 3
> Preferred Minor : 1
>=20
> =A0 =A0Update Time : Mon Apr 18 07:48:51 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> Active Devices : 3
> Working Devices : 3
> Failed Devices : 1
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : 5674ce6b - correct
> =A0 =A0 =A0 =A0 Events : 28580018
>=20
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 256K
>=20
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =
=A0active sync =A0 /dev/sdc2
>=20
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdb2
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc2
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed
> /dev/sdd2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : ddf4d448:36afa319:f0917855:03f8bbe8
> =A0Creation Time : Mon May 15 16:38:05 2006
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
> =A0 =A0 Array Size : 734925312 (700.88 GiB 752.56 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 3
> Preferred Minor : 1
>=20
> =A0 =A0Update Time : Mon Apr 18 07:48:54 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> Active Devices : 3
> Working Devices : 3
> Failed Devices : 1
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : 5674ce4e - correct
> =A0 =A0 =A0 =A0 Events : 28580020
>=20
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 256K
>=20
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
>=20
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdb2
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc2
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
