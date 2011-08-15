From: NeilBrown <neilb@suse.de>
Subject: Re: Rotating RAID 1
Date: Tue, 16 Aug 2011 08:42:51 +1000
Message-ID: <20110816084251.2d8e7831@notabene.brown>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
	<4E497FB5.3030109@ivitera.com>
	<CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
	<4E49849E.4030604@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E49849E.4030604@ivitera.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: =?ISO-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 15 Aug 2011 22:42:06 +0200 Pavel Hofman <pavel.hofman@ivitera.c=
om>
wrote:

>=20
> Dne 15.8.2011 22:25, J=E9r=F4me Poulin napsal(a):
> > On Mon, Aug 15, 2011 at 4:21 PM, Pavel Hofman <pavel.hofman@ivitera=
=2Ecom> wrote:
> >> Does your scenario involve using two "external" drives, being swap=
ped
> >> each time?
> >=20
> > Yes, exactly, 3 or more drive, one stays in place, and the others g=
et
> > rotated off-site.
> >=20
> >> I am using such setup, but in order to gain the bitmap
> >> performance effects, I have to run two mirrored RAID1s, i.e. two
> >> bitmaps, each for its corresponding external disk. This setup has =
been
> >> working OK for a few years now.
> >=20
> > Did you script something that stops the RAID and re-assemble it? Th=
e
> > RAID must stay mounted in my case as there is live data (incrementi=
al
> > backups, so even if the last file is incomplete it is not a problem=
=2E)
>=20
> I am working on wiki description of our backup solution. The prioriti=
es
> got re-organized recently, looks like I should finish it soon :-)
>=20
> Yes, I have a script automatically re-assembling the array correspond=
ing
> to the added drive and starting synchronization. There is another scr=
ipt
> checking synchronization status, run periodically from cron. When the
> arrays are synced, it waits until the currently running backup job
> finishes, shuts down the backup software (backuppc), unmounts the
> filesystem to flush, removes the external drives from the array (we r=
un
> several external drives in raid0), does a few basic checks on the
> external copy (mounting read-only, reading a directory) and puts the
> external drives to sleep (hdparm -Y) for storing them outside of comp=
any
> premises.
>=20
> Give me a few days, I will finish the wiki page and send you a link.
>=20

I'm not sure from you description whether the following describes exact=
ly
what you are doing or not, but this is how I would do it.
As you say, you need two bitmaps.

So if there are 3 drives A, X, Y where A is permanent and X and Y are r=
otated
off-site, then I create two RAID1s like this:


mdadm -C /dev/md0 -l1 -n2 --bitmap=3Dinternal /dev/A /dev/X
mdadm -C /dev/md1 -l1 -n2 --bitmap=3Dinternal /dev/md0 /dev/Y

mkfs /dev/md1; mount /dev/md1 ...


Then you can remove either or both of X and Y and which each is re-adde=
d it
will recover just the blocks that it needs.  X from the bitmap of md0, =
Y from
the bitmap of md1.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
