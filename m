From: Keld Simonsen <keld@keldix.com>
Subject: Re: very strange raid10,f2 performance
Date: Sat, 1 May 2010 10:36:08 +0200
Message-ID: <20100501083608.GA28178@rap.rap.dk>
References: <k2mcccedfc61004211002p24f1bd21xdead3e501766553f@mail.gmail.com>
 <20100430224642.GB7127@rap.rap.dk>
 <n2lcccedfc61004301835ofb5285b2g4e73a5181a0d6f77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <n2lcccedfc61004301835ofb5285b2g4e73a5181a0d6f77@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Apr 30, 2010 at 08:35:50PM -0500, Jon Nelson wrote:
> On Fri, Apr 30, 2010 at 5:46 PM, Keld Simonsen <keld@keldix.com> wrot=
e:
> > On Wed, Apr 21, 2010 at 12:02:46PM -0500, Jon Nelson wrote:
> >> I was helping somebody else diagnose some issues, and decided to r=
un
> >> comparitive tests on my own raid (raid10,f2).
> >>
> >> The raid10,f2 (md0) is the only physical device backing a volume
> >> group, which is then carved into a bunch of (primarily) ext4
> >> filesystems.
> >> The kernel is 2.6.31.12 (openSUSE) on a Quad Processor AMD Phenom =
9150e system.
> >> The raid is two Western Digital Caviar Blue drives (WDC WD5000AAKS=
-00V1A0).
> >>
> >> The problem: really, really bad I/O performance under certain circ=
umstances.
> >>
> >> When using an internal bitmap and *synchronous* I/O, applications =
like
> >> dd report 700-800 kB/s.
> >> When not using a bitmap at all, and synchronous I/O, dd reports 2.=
5
> >> MB/s (but dstat shows 14MB/s?)
> >> Without a bitmap and async I/O (but with fdatasync) I get 65MB/s.
> >> *With* a bitmap and using async. I/O (but with fdatasync) I get mo=
re
> >> like 65MB/s.
> >>
> >> The system has 3GB of memory and I'm testing with dd if=3D/dev/zer=
o
> >> of=3Dsomefile bs=3D4k count=3D524288.
> >>
> >> I'm trying to understand why the synchronous I/O is so bad, but ev=
en
> >> so I was hoping for more. 65MB/s seems *reasonable* given the
> >> raid10,f2 configuration and all of the seeking that such a
> >> configuration involves (when writing).
> >>
> >> The other very strange thing is that the I/O patterns seem very
> >> strange. I'll see 14MB/s very consistently as reported by dstat
> >> (14MB/s for each sda, sdb, and md0) for 10-15 seconds and then I'l=
l
> >> see it drop, sometimes to just 3 or 4 MB/s, for another 10 seconds=
,
> >> and then the pattern repeats. =A0What's going on here? With absolu=
tely
> >> no other load on the system, I would have expected to see somethin=
g
> >> much more consistent.
> >
> > Hmm, not much response to this.
> > The only idea I have for now is misalignment between raid and LVM b=
oundaries.
>=20
> These aren't 4K disks (as far as I know), so I'm not sure what you
> mean by alignment issues.
> Using 255 heads, 63 sectors per track:
>=20
> /dev/sda1 starts on sector 63 and ends on sector 7807589
> /dev/sda2 starts on sector 11711385 and ends on sector 482528340

I dont know much about this, and I have not tested it, but try to
make LVM and raid on sector numbers divisionable by the raid block size=
=2E

> /dev/sdb is partitioned the same
> /dev/sda2 and /dev/sdb2 form the raid10,f2.
>=20
> > Were your dd's done on the raw devices, or via a file system?
>=20
> Raw (logical) devices carved out of the volume group.

I always advise to do performance tests on the file system,
it is closer to the performance that you will actually see in service.
I even had some strange results with hdparm yesterday, where
a hdparm gave about 60 MB/s , and a "cat file >/dev/null" gave 180 MB/s=
 on the
same raid.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
