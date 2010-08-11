From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re:  sdc1 does not have a valid v0.90 superblock, not importing!
Date: Wed, 11 Aug 2010 08:30:31 -0700 (PDT)
Message-ID: <282617.15518.qm@web51308.mail.re2.yahoo.com>
References: <20100811213405.09a0b709@notabene>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100811213405.09a0b709@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Wed, 11/8/10, Neil Brown <neilb@suse.de> wrote:

> From: Neil Brown <neilb@suse.de>
> Subject: Re:  sdc1 does not have a valid v0.90 superblock, not import=
ing!
> To: Jon@eHardcastle.com
> Cc: jd_hardcastle@yahoo.com, linux-raid@vger.kernel.org
> Date: Wednesday, 11 August, 2010, 12:34
> On Wed, 11 Aug 2010 04:19:07 -0700
> (PDT)
> Jon Hardcastle <jd_hardcastle@yahoo.com>
> wrote:
>=20
> >=20
> > --- On Wed, 11/8/10, Neil Brown <neilb@suse.de>
> wrote:
> >=20
> > > From: Neil Brown <neilb@suse.de>
> > > Subject: Re:=A0 sdc1 does not have a valid
> v0.90 superblock, not importing!
> > > To: Jon@eHardcastle.com
> > > Cc: jd_hardcastle@yahoo.com,
> linux-raid@vger.kernel.org
> > > Date: Wednesday, 11 August, 2010, 12:06
> > > On Wed, 11 Aug 2010 02:55:44 -0700
> > > (PDT)
> > > Jon Hardcastle <jd_hardcastle@yahoo.com>
> > > wrote:
> > >=20
> > > > (my first attempt appears to have been
> bounced as the
> > > spam checker thought it had HTML in it?!)
> > >=20
> > > odd... came through ok for me the first time.
> > >=20
> > > >=20
> > > > Help!
> > > >=20
> > > > Long story short - I was watching a movie
> off my RAID6
> > > array. Got a smart error warning
> > >=20
> > > > Aug 10 22:00:07 mangalore kernel: raid5:
> cannot start
> > > dirty degraded array for md4
> > >=20
> > > This is the current problem.=A0 The array is dirty
> and
> > > degraded so there could
> > > theoretically be undetectable corruption.=A0
> Chance is
> > > quite low but it is
> > > there so md won't start with out you
> acknowledging the risk
> > > by giving the
> > > --force flag to mdadm --assemble.
> > > Only do that if you are confident that your
> hardware is
> > > working correctly.
> >=20
> > Well I am reasonable sure the controller came adrift
> the first time.. when i reseated it i stopped getting 100's
> of errors.. and it has survived 1.5 badblocks checks. It is
> being held in place by one of those bars you press down
> (does all the expansion cards in 1 go) except i dont think
> it is very good. I will screw it down.
> >=20
> > >=20
> > > > It appears sdc has an invalid superblock?
> > > >=20
> > > > This is the 'examine' from sdc1 (note the
> checksum)
> > > >=20
> > > > /dev/sdc1:
> > > .....
> > > >=A0 =A0 =A0=A0=A0Checksum : b335b4e3 -
> > > expected b735b4e3
> > >=20
> > > Single bit error.=A0 That isn't good as it means
> some
> > > bit of memory or some bit
> > > on some bus somewhere cannot be trusted.
> > > It could be a transient thing and will never
> happen
> > > again.=A0 Or maybe not.
> > > Given the smart errors and the fact that you have
> had
> > > problems with the drive
> > > before it seem very likely that the problem is in
> that
> > > drive.=A0 I suggest
> > > unplugging it and leaving it unplugged.=A0 Some
> memory
> > > buffer in the drive is
> > > probably marginal.=A0 I don't think they use ECC
> > > memory.
> >=20
> > Could this be a result of me forcing a power off when
> the drive was causing problems?
>=20
> Probably not.=A0 Forcing a power off may well have left
> the array 'dirty' so
> that it wouldn't assemble, but is fairly unlikely to
> corrupt data within a
> block.
>=20
> >=20
> > What are the dangers to removing it, zeroing the
> superblock and readding? is it MORE dangerous than leaving a
> raid 6 degraded for a few days?
>=20
> In general, I would say the chance of a known-bad drive
> causing problems is
> greater than the chance of a fewer known-good drives
> causing problems.
> But then you seem to think it isn't the drive, it was the
> controller and that
> is fixed...
>=20
> This is really about your level of trust in the hardware.
> If you trust sdc as much as the others, include it in the
> array.
> If you don't, then don't.
>=20
> NeilBrown
>=20
>=20
>=20
> >=20
> > >=20
> > > >=20
> > > > Anyways... I am ASSUMING mdadm has not
> assembled the
> > > array to be on the safe side? i have not done
> anything.. no
> > > force... no assume clean.. I wanted to be sure?
> > >=20
> > > You assume correctly.
> > >=20
> > > >=20
> > > > Should i remove sdc1 from the array? It
> should then
> > > assemble? I have 2 spare drives that I am getting
> around to
> > > using to replace this drive and the other 500GB..
> so should
> > > I remove sdc1... and try and re-add or just put
> the new
> > > drive in?
> > > >=20
> > > > atm I have 'stop'ped the array and got
> badblocks
> > > running....
> > > >=20
> > >=20
> > > Remove sdc and assemble the array with --force,
> and get a
> > > new device to
> > > replace /dev/sdc as soon as possible.
> >=20
> > Thanks Neil - I panic'd as previously it has mounted
> the array in a degraded state... but previously the drive
> has disappeared completely... whereas in this case it is
> present... but wrong!
> >=20
> > >=20
> > > NeilBrown
> > > --
> > > To unsubscribe from this list: send the line
> "unsubscribe
> > > linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at=A0 http://vger.kernel.org/majordomo-info.h=
tml
> > >=20
> >=20
> >=20
> >=A0 =A0 =A0=A0=A0

=46or the benefit of those that follow! I assemble the array by specify=
ing exactly the drives I wanted in it.. once assembled i could confiden=
tly zero-block the troublesome drive... without it rearing its ugly hea=
d again!

I now have a 1 drive down - degraded raid 6 array.


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
