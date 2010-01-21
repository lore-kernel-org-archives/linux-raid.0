From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Why does one get mismatches?
Date: Thu, 21 Jan 2010 04:15:32 -0800 (PST)
Message-ID: <207849.38772.qm@web51308.mail.re2.yahoo.com>
References: <4B583F04.70005@lfarkas.org>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B583F04.70005@lfarkas.org>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>, Farkas Levente <lfarkas@lfarkas.org>
Cc: Asdo <asdo@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Thu, 21/1/10, Farkas Levente <lfarkas@lfarkas.org> wrote:

> From: Farkas Levente <lfarkas@lfarkas.org>
> Subject: Re: Why does one get mismatches?
> To: "Steven Haigh" <netwiz@crc.id.au>
> Cc: "Asdo" <asdo@shiftmail.org>, linux-raid@vger.kernel.org
> Date: Thursday, 21 January, 2010, 11:48
> On 01/21/2010 11:52 AM, Steven Haigh
> wrote:
> > On Thu, 21 Jan 2010 09:08:42 +0100, Asdo<asdo@shiftmail.org>=A0
> wrote:
> >> Steven Haigh wrote:
> >>> On Wed, 20 Jan 2010 17:43:45 -0500, Brett
> Russ<bruss@netezza.com>
> > wrote:
> >>>
> >>> CUT!
> >> Might that be a problem of the disks/controllers?
> >> Jon and Steven, what hardware do you have?
> >
> > I'm running some fairly old hardware on this
> particular server. It's a
> > dual P3 1Ghz.
> >
> > After running a repair on /dev/md2, I now see:
> > # cat /sys/block/md2/md/mismatch_cnt
> > 1536
> >
> > Again, no smart errors, nothing to indicate a disk
> problem at all :(
> >
> > As this really keeps killing the machine and it is a
> live system - the
> > only thing I can really think of doing is to break the
> RAID and just rsync
> > the drives twice daily :\
>=20
> the same happened with many people. and we all hate it
> since it cause a=20
> huge load at all weekend on most of our servers:-(
> according to redhat it's not a bug:-(
>=20
> --=20
> =A0=A0=A0Levente=A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0=A0=A0"Si vis pacem para bellum!"
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

Well i am running a Semperon based desktop system that has 4 in built s=
ata and 2 IDE, and 2 PCI-E controller cards exposing 2 sata ports each.

I have off the IDE 2 320GB HDD's that is split across 3 md's boot/swap/=
main. Only the Main is 'check'ed/repaired. Very rarely have a problem h=
ere!

On the Sata's I have 7 HDD's of varying size(4x500, 2x750, 1x1TB) and m=
akes(Samsung, Hitachi, Seagate) strung together to form a now raid6 (ra=
id5 until a couple of weeks ago). On top of that i have a VG split into=
 ~6 LV's and in some of those i have mount SquashFS filesystems. until =
i moved the drive order around at the weekend for access issues. I didn=
't really have any problems - except the occasional issue - I scrub it =
weekly currently.

BUT I have only just converted from raid5 to 6 and probably not run tha=
t many checks since so it could be related to that!




     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
