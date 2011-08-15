From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Re: Rotating RAID 1
Date: Mon, 15 Aug 2011 22:42:06 +0200
Message-ID: <4E49849E.4030604@ivitera.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com> <4E497FB5.3030109@ivitera.com> <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Dne 15.8.2011 22:25, J=C3=A9r=C3=B4me Poulin napsal(a):
> On Mon, Aug 15, 2011 at 4:21 PM, Pavel Hofman <pavel.hofman@ivitera.c=
om> wrote:
>> Does your scenario involve using two "external" drives, being swappe=
d
>> each time?
>=20
> Yes, exactly, 3 or more drive, one stays in place, and the others get
> rotated off-site.
>=20
>> I am using such setup, but in order to gain the bitmap
>> performance effects, I have to run two mirrored RAID1s, i.e. two
>> bitmaps, each for its corresponding external disk. This setup has be=
en
>> working OK for a few years now.
>=20
> Did you script something that stops the RAID and re-assemble it? The
> RAID must stay mounted in my case as there is live data (incremential
> backups, so even if the last file is incomplete it is not a problem.)

I am working on wiki description of our backup solution. The priorities
got re-organized recently, looks like I should finish it soon :-)

Yes, I have a script automatically re-assembling the array correspondin=
g
to the added drive and starting synchronization. There is another scrip=
t
checking synchronization status, run periodically from cron. When the
arrays are synced, it waits until the currently running backup job
finishes, shuts down the backup software (backuppc), unmounts the
filesystem to flush, removes the external drives from the array (we run
several external drives in raid0), does a few basic checks on the
external copy (mounting read-only, reading a directory) and puts the
external drives to sleep (hdparm -Y) for storing them outside of compan=
y
premises.

Give me a few days, I will finish the wiki page and send you a link.

Pavel.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
