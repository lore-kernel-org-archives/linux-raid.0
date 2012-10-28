From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 16:54:46 +0400
Message-ID: <508D2B16.902@msgid.tls.msk.ru>
References: <11510711257.20121028131527@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11510711257.20121028131527@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Cc: linux-raid@vger.kernel.org, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

On 28.10.2012 16:15, Rainer F=FCgenstein wrote:
>=20
> when trying to upgrade my raid5 with 4 Western digital caviar green
> 3TB drives [WDC WD30EZRX-00MMMB0] (3 brandnew, 1 about 4months old),
> the "old" drive and one of the brand new ones failed with
> unrecoverable read errors and about 70 reallocated sectors each. the
> failures already occured during the initial resync after creating the
> raid.
>=20
> until now I was very fond of WD caviar green drives, but after this
> 50% failure rate I'm not very eager to restore data from the backup.
>=20
> what is your experience with 3TB drives, WD and others?

This is not about 3TB, but about older 2Tb WD EARS.  I've 3 of them
in a raid array which runs 24x7 for about 2 years.  Here's one of
them:

Model Family:     Western Digital Caviar Green (Adv. Format)
Device Model:     WDC WD20EARS-00MVWB0
=46irmware Version: 50.0AB50
=2E..
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       83
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  9 Power_On_Hours          0x0032   077   077   000    Old_age   Alway=
s       -       16994
194 Temperature_Celsius     0x0022   107   099   000    Old_age   Alway=
s       -       43
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0

Other 2 are very similar.

I've several more drives of the same family in other
systems, about 10 in total, some are older than these.
Had no single failure so far.  SMART selftests are run
on a regular basis (about once every 2 months).

I can only guess this depends purely on luck.  I've
seen reports about these drives failing often, yet
others (like me) report these are rock solid.  Go
figure.

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
