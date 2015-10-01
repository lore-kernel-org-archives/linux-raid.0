From: Neil Brown <neilb@suse.de>
Subject: RE: [PATCH 7/8] md: skip resync for raid array with journal
Date: Fri, 02 Oct 2015 09:50:40 +1000
Message-ID: <87zj02i1wv.fsf@notabene.neil.brown.name>
References: <cover.1441221530.git.shli@fb.com> <7c5622ab3335f31a27f807d8fee27f8bb60675ae.1441221530.git.shli@fb.com> <871tdgmt4w.fsf@notabene.neil.brown.name> <C709E4D363AAB64590BFAC54D4C478AA0104B82A61@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C709E4D363AAB64590BFAC54D4C478AA0104B82A61@PRN-MBX02-4.TheFacebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, Shaohua Li <shli@fb.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Kernel Team <Kernel-team@fb.com>, "hch@infradead.org" <hch@infradead.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Song Liu <songliubraving@fb.com> writes:

>> -----Original Message-----
>> From: Neil Brown [mailto:neilb@suse.de]
>> Sent: Tuesday, September 29, 2015 9:25 PM
>> To: Shaohua Li; linux-raid@vger.kernel.org
>> Cc: Kernel Team; Song Liu; hch@infradead.org; dan.j.williams@intel.com
>> Subject: Re: [PATCH 7/8] md: skip resync for raid array with journal
>>=20
>> Shaohua Li <shli@fb.com> writes:
>>=20
>> > If a raid array has journal, the journal can guarantee the
>> > consistency, we can skip resync after a unclean shutdown. The
>> > exception is raid creation or user initiated resync, which we still do=
 a raid
>> resync.
>> >
>> > Signed-off-by: Shaohua Li <shli@fb.com>
>> > ---
>> >  drivers/md/md.c | 4 ++++
>> >  drivers/md/md.h | 1 +
>> >  2 files changed, 5 insertions(+)
>> >
>> > diff --git a/drivers/md/md.c b/drivers/md/md.c index b3f9eed..95824fb
>> > 100644
>> > --- a/drivers/md/md.c
>> > +++ b/drivers/md/md.c
>> > @@ -1669,6 +1669,8 @@ static int super_1_validate(struct mddev *mddev,
>> struct md_rdev *rdev)
>> >  			}
>> >  			set_bit(Journal, &rdev->flags);
>> >  			rdev->journal_tail =3D le64_to_cpu(sb->journal_tail);
>> > +			if (mddev->recovery_cp =3D=3D MaxSector)
>> > +				set_bit(MD_JOURNAL_CLEAN, &mddev-
>> >flags);
>> >  			break;
>> >  		default:
>> >  			rdev->saved_raid_disk =3D role;
>> > @@ -1711,6 +1713,8 @@ static void super_1_sync(struct mddev *mddev,
>> struct md_rdev *rdev)
>> >  	sb->events =3D cpu_to_le64(mddev->events);
>> >  	if (mddev->in_sync)
>> >  		sb->resync_offset =3D cpu_to_le64(mddev->recovery_cp);
>> > +	else if (test_bit(MD_JOURNAL_CLEAN, &mddev->flags))
>> > +		sb->resync_offset =3D cpu_to_le64(MaxSector);
>> >  	else
>> >  		sb->resync_offset =3D cpu_to_le64(0);
>> >
>> > diff --git a/drivers/md/md.h b/drivers/md/md.h index 226f4ba..0288a0b
>> > 100644
>> > --- a/drivers/md/md.h
>> > +++ b/drivers/md/md.h
>> > @@ -236,6 +236,7 @@ struct mddev {
>> >  #define MD_STILL_CLOSED	4	/* If set, then array has not been
>> opened since
>> >  				 * md_ioctl checked on it.
>> >  				 */
>> > +#define MD_JOURNAL_CLEAN 5	/* A raid with journal is already clean
>> */
>> >
>> >  	int				suspended;
>> >  	atomic_t			active_io;
>> > --
>> > 1.8.1
>>=20
>> This looks right as far as it goes, but I don't think it goes far enough.
>> The particular scenario that bothers me is if the array is started witho=
ut the
>> journal being present.
>> I cannot see anything to prevent that - is there?
>
> I have sent mdadm patches that prevent the array to assemble with missing=
=20
> journal, for both --assemble and --incremental:
>
> http://marc.info/?l=3Dlinux-raid&m=3D144080445720123
> http://marc.info/?l=3Dlinux-raid&m=3D144080446120127=20
>

That is probably good and useful, but the kernel cannot rely on mdadm to
protect it.  If the kernel is asked to start a journalled array when no
journal is present, it must do something that is safe.
That might be to refuse, it might be to force a resync, it might be to
somehow "know" if the journal is empty and only force a resync in that
case.

This should be treated much like a "dirty/degraded" start.  Currently
the kernel refuses to do that unless a module parameter is set.  When
mdadm is asked to --force start a dirty/degraded array, it modifies the
metadata so that it doesn't appear to be degraded.  Something similar
might be best for the missing-journal case.

I *think* the current kernel code will allow the array to be started
without a resync even if the journal was not empty, and that is not
safe.

> We can force start in both cases with --force or --run.=20
>
> Currently, mdadm doesn't clear MD_FEATURE_JOURNAL bit, so we get warning=
=20
> every time.=20
>
> I did miss one step: to mark the missing journal as fault.=20
>
>>=20
>> In that case we need to assume that the array is not in-sync, and we nee=
d to
>> clear MD_FEATURE_JOURNAL so if it gets stopped and then assembled again
>> with the stale journal doesn't get used.
>>=20
>> One unfortunate side effect of that is that you couldn't stop the array =
cleanly
>> (leaving the journal effectively empty) and then restart with no journal=
 and
>> no resync.  Is that a problem I wonder?
>>=20
>> I'm not sure what the best solution is here, but we need a clear
>> understanding of what happens if you try to assemble an array without the
>> journal where previously it had one, and I don't think the current code =
gets it
>> right.
>
> I just talked with Shaohua. We think we can probably do the following:
>
> 1. When assemble with cache device missing, show the warning (with --forc=
e=20
> option). Run resync if previous shutdown is not clean (this is the default
> behavior.

Probably sensible.  But I think the current code never marks the array as
"not clean" when there is a journal.

>
> 2. When we get I/O error on the journal device at run time, make the whole
> array as read only.

Yes, I think that is best.

>
> 3. Add new operation that adds new journal device to an array with missin=
g=20
> journal. We can limit this option to inactive array only.

It would be great if we could add a journal to an active array...

>
> Would this follow cover all the cases?

Quite possibly.  I don't want to commit myself until I see the code :-)

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWDcbQAAoJEDnsnt1WYoG5VwcP/jIes7SUYWRd3CxdMlb+IlEN
ECwd0UrRfeqxIuUWjP6uR1QdBq0xEeLzC/3vC3ZnuofPoQ8GPaApgvez6vnof7UI
WneQADCiSrrXN72ojHvgQQEVshPDMHjH2JlWJkdNbsQ+W7LmGeHq1MIajiW1xdUG
GOsXZXtOIN/9kJkfH7kgGiLN8R5EAj6J/w5LfCw3Z79IBT9HCoTZK/Wt6Yqo67cl
w99Bwe319Dsuz/yYAC6U4Vol5AotnQtUsuRnhdmtDXbSep5RNucfpd3dUJUttyTI
DHH8bmbOuOX8x9zz4W5OllFC5cqPqr6dR8QlFf+tJzsf5QMmTk82ygUE34/IOmdH
YS09L553YInN80ira/heKuw/LGfYKuMBnp3kgag/Yr3w3ud0W4/mxrh57WW03oXC
WdVX5x6I2cMrcJ1E8nFbtj0VAZpPXCkI6gwCfDcMYSDSHeAQhHBvg8SSsqd3DbNj
Zz87O6BVjACTG5ZjBQWoimtq4fnBtIdhOX53S09w5rhFtYrWpb8RyoO3ESU2xxYP
y1OVOIBArLmjSvKkHX40mefedpHCLFQBVK7MySzUSiLhF50FRI0bDeCeGoxfUI0W
dUklrMp4H8mb48y5YLeuxiPbinzsp6p+fKj9iyN8/0g9nOCcBYclUP2zwk9e6lax
1ZbUAuZ3qj610wiBny/y
=WTRo
-----END PGP SIGNATURE-----
--=-=-=--
