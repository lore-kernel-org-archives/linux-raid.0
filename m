From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: RE: Why does one get mismatches?
Date: Thu, 28 Jan 2010 01:16:28 -0800 (PST)
Message-ID: <802139.74942.qm@web51305.mail.re2.yahoo.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C08AE1690@SDCEXCHANGE01.ad.amcc.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C08AE1690@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org, Tirumala Reddy Marri <tmarri@amcc.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]
> On Behalf Of Steven Haigh
> Sent: Monday, January 25, 2010 2:49 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: Why does one get mismatches?
>=20
>=20
> On 26/01/2010, at 7:43 AM, greg@enjellic.com
> wrote:
>=20
> > On Jan 21, 12:48pm, Farkas Levente wrote:
> > } Subject: Re: Why does one get mismatches?
> >=20
> > Good afternoon to everyone, hope the week is starting
> well.
> >=20
> >> On 01/21/2010 11:52 AM, Steven Haigh wrote:
> >>> On Thu, 21 Jan 2010 09:08:42 +0100, Asdo<asdo@shiftmail.org>=A0
> wrote:
> >>>> Steven Haigh wrote:
> >>>>> On Wed, 20 Jan 2010 17:43:45 -0500,
> Brett Russ<bruss@netezza.com>
> >>> wrote:
> >>>>>=20
> >>>>> CUT!
> >>>> Might that be a problem of the
> disks/controllers?
> >>>> Jon and Steven, what hardware do you
> have?
> >>>=20
> >>> I'm running some fairly old hardware on this
> particular server. It's
> a
> >>> dual P3 1Ghz.
> >>>=20
> >>> After running a repair on /dev/md2, I now
> see:
> >>> # cat /sys/block/md2/md/mismatch_cnt
> >>> 1536
> >>>=20
> >>> Again, no smart errors, nothing to indicate a
> disk problem at all :(
> >>>=20
> >>> As this really keeps killing the machine and
> it is a live system -
> the
> >>> only thing I can really think of doing is to
> break the RAID and just
> rsync
> >>> the drives twice daily :\
> >=20
> >> the same happened with many people. and we all
> hate it since it
> >> cause a huge load at all weekend on most of our
> servers:-( according
> >> to redhat it's not a bug:-(
> >=20
> > The RAID check/mismatch_count is an example of well
> intentioned
> > technology suffering from 'featuritis' by the
> distributions which is,
> > as I predicted a couple of times in this forum,
> causing all sorts of
> > angst and problems throughout the world.=A0 I've
> had some posts on this
> > subject but will summarize in the hopes of giving some
> background
> > information which will be useful to people.
> >=20
> > There is an issue in the kernel which causes these
> mismatches.=A0 The
> > problem seems to be particularly bad with RAID1
> arrays.=A0 The
> > contention is that these mismatches are 'harmless'
> because they only
> > occur in areas of the filesystems which are not being
> used.
> >=20
> > The best description is that the buffers containing
> the data to be
> > written are not 'pinned' all the way down the I/O
> stack.=A0 This can
> > cause the contents of a buffer to be changed while in
> transit through
> > the I/O stack.=A0 Thus one copy of a mirror gets a
> buffer written to it
> > different then the other side of the mirror.
> >=20
> > I've read reasoned discussions about why this occurs
> with swap over
> > RAID1 and why its harmless.=A0 I've set to see the
> same type of reasoned
> > discussion as to why it is not problematic with a
> filesystem over
> > RAID1.=A0 There has been some discussion that its
> due to high levels of
> > MMAP activity on the filesystem.
> >=20
> > We have confirmed, that at least with RAID1, this all
> occurs with no
> > physical corruption on the 'disk drives'.=A0 We
> implement geographically
> > mirror storage with RAID1 against two separate
> data-centers.=A0 At each
> > data-center the RAID1 'block-device' are RAID5
> volumes.=A0 These latter
> > volumes check out with no errors/mismatch counts
> etc.=A0 So the issue is
> > at the RAID1 data abstraction layer.
> >=20
> > There do not appear to be any tools which allow one to
> determine
> > 'where' the mismatches are.=A0 Such a tool, or
> logging by the kernel,
> > would be useful for people who want to verify what
> files, if any, are
> > affected by the mismatch.=A0 Otherwise running a
> 'repair' results in the
> > RAID1 code arbitraily deciding which of the two blocks
> is the
> > 'correct' one.
> >=20
> > So thats sort of a thumbnail sketch of what is going
> on.=A0 The fact the
> > distributions chose to implement this without
> understanding the issues
> > it presents is a bit problematic.
> >=20
> >>=A0=A0=A0Levente=A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0=A0=A0"Si vis pacem para
> bellum!"
> >=20
> > Hopefully this information is helpful.
> >=20
> > Greg
>=20
> Hi Greg and all,
>=20
> The funny part is that I believe the mismatches aren't
> happening in the
> empty space of the filesystem - as it seems that the errors
> are causing
> the ext3 journal to abort and force the filesystem into
> readonly in my
> particular situation.
>=20
> It is interesting that I do not get any mismatches on md0,
> md1 or md3 -
> only md2.
>=20
> md0 =3D /boot
> md1 =3D swap
> md2 =3D /
> md3 =3D /tmp
>=20
> I ran weekly checks on the all four RAID1 arrays and ONLY
> md2 had a
> problem with mismatches, which also had a habit of going
> readonly -
> therefore I don't believe the part of common belief that
> this problem
> only affects empty parts of the filesystem.
>=20
> I have also done just about every test to the disks that I
> can think of
> with no errors to be found - leaving only the md layer to
> be suspect.
>=20
> --
> Steven Haigh
>=20
> Email: netwiz@crc.id.au
> Web: http://www.crc.id.au
> Phone: (03) 9001 6090 - 0412 935 897
> Fax: (03) 8338 0299
>=20

Well, I finished running my none-destructive badblocks check and ran se=
veral smart --long tests I also did a forcefsk on the bad boy and NOW t=
he active md4 (with a DEACTIVE vg on it) returns 0 mismatch_cnt. I have=
n't rebooted it in days though so I just dont know what casued this. No=
 errors in the log, the pending/reallocated sector count is still 0 on =
all drives.

I have reactivated my VG and am running it again now it is just bizzare=
=2E



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
