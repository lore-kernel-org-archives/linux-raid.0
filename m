From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 23:01:45 +0200
Message-ID: <20090923210145.GA23285@rap.rap.dk>
References: <20090923091328.GA19193@rap.rap.dk> <501250.73276.qm@web38802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <501250.73276.qm@web38802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 23, 2009 at 07:59:09AM -0700, adfas asd wrote:
> --- On Wed, 9/23/09, Keld J=F8rn Simonsen <keld@dkuug.dk> wrote:
> > There is a setup described at=20
> >=20
> > http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_d=
isk
> >=20
> > You can substitute raid10,o2 for raid10,f2 for the root
> > partitions etc.
> >=20
> > Anyway, raid10,f2 should be faster than raid10,o2, for at
> > least reads,
> > while for writes it is about the same performance given
> > that you employ
> > a file system.
>=20
> Thanks keld.  I used this procedure, which does about the same thing =
and seems more clear, adapting it to RAID10-o2:
> http://www.howtoforge.com/software-raid1-grub-boot-debian-etch
>=20
> I could find no performance comparison with far and offset, and knew =
that far improved on reads, so since offset came later inferred that it=
 would have improved writes.  No objective data to confirm otherwise.

There are a number of performance tests at:
http://linux-raid.osdl.org/index.php/Performance

Writes are about the same for RAID10 types and RAID1.
This is also what theory would tell for random writes, given that they
are random, and that the elevator algorithm of the file system optimize=
s
the writing.=20

Yes, offset came after far, but Neil Brown said that offset was
implemented to make Linux MD align to RAID standards. It was not
necessarily meant to be better than far.=20

I think it is hard to beat raid10 far on reads (but then I am also the
one that invented the layout). As said for random reading and writing
the theory says that all mirrored raid types perform equally, and tests
verify this. Maybe far layout even has an edge for random reading, in
theory it should, but I have not seen tests really verifying that.

best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
