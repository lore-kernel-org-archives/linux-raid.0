From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/9] MD: fix info output for journal disk
Date: Tue, 13 Oct 2015 10:26:08 +1100
Message-ID: <87si5fzn1r.fsf@notabene.neil.brown.name>
References: <cover.1444360850.git.shli@fb.com> <2537e2bcb31eaf918df28f25d096b31c2b9daa70.1444360850.git.shli@fb.com> <87a8ro1wb0.fsf@notabene.neil.brown.name> <20151012170148.GA3081164@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151012170148.GA3081164@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> On Mon, Oct 12, 2015 at 04:37:55PM +1100, Neil Brown wrote:
>> Shaohua Li <shli@fb.com> writes:
>>=20
>> > journal disk can be faulty. The Journal and Faulty aren't exclusive wi=
th
>> > each other.
>> >
>> > Signed-off-by: Shaohua Li <shli@fb.com>
>> > ---
>> >  drivers/md/md.c | 10 +++++++---
>> >  1 file changed, 7 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/md/md.c b/drivers/md/md.c
>> > index 0729cc7..daf42bb 100644
>> > --- a/drivers/md/md.c
>> > +++ b/drivers/md/md.c
>> > @@ -5857,7 +5857,8 @@ static int get_disk_info(struct mddev *mddev, vo=
id __user * arg)
>> >  		else if (test_bit(In_sync, &rdev->flags)) {
>> >  			info.state |=3D (1<<MD_DISK_ACTIVE);
>> >  			info.state |=3D (1<<MD_DISK_SYNC);
>> > -		} else if (test_bit(Journal, &rdev->flags))
>> > +		}
>> > +		if (test_bit(Journal, &rdev->flags))
>> >  			info.state |=3D (1<<MD_DISK_JOURNAL);
>> >  		if (test_bit(WriteMostly, &rdev->flags))
>> >  			info.state |=3D (1<<MD_DISK_WRITEMOSTLY);
>> > @@ -7335,18 +7336,21 @@ static int md_seq_show(struct seq_file *seq, v=
oid *v)
>> >  		rcu_read_lock();
>> >  		rdev_for_each_rcu(rdev, mddev) {
>> >  			char b[BDEVNAME_SIZE];
>> > +			bool skip =3D false;
>> >  			seq_printf(seq, " %s[%d]",
>> >  				bdevname(rdev->bdev,b), rdev->desc_nr);
>> >  			if (test_bit(WriteMostly, &rdev->flags))
>> >  				seq_printf(seq, "(W)");
>> >  			if (test_bit(Faulty, &rdev->flags)) {
>> >  				seq_printf(seq, "(F)");
>> > -				continue;
>> > +				skip =3D true;
>> >  			}
>> >  			if (test_bit(Journal, &rdev->flags)) {
>> >  				seq_printf(seq, "(J)");
>> > -				continue;
>> > +				skip =3D true;
>> >  			}
>> > +			if (skip)
>> > +				continue;
>>=20
>> Is this 'skip' stuff really needed?  What would go wrong if we just left
>> it out?  An active journal will have raid_disk>=3D0 now won't it?  And
>> if we don't support replacement of journals (which I suspect we
>> shouldn't) then (R) will never get reported.
>>=20
>> So can we just drop the 'skip'??
>
> Sounds good. Let me know if I should resend this one alone or the
> series.

Just send this one alone.  I'll apply the rest from the previous
posting.

I'm not entirely convinced about the race issue, but I don't really
want to think about it today and as you seem certain we will go with the
current code for now.
If I think of something that does convince me, it can always be fixed
later.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWHEGQAAoJEDnsnt1WYoG5z0wP/2m7Svm3enM0qaZsrscNlcqR
9osIc9fFX1PgzR/6BcXay2Kz8l7/6MyYS5nhyckWjZ8bOtiKIux1/HdPUan/PUCN
olUiaZH+exOJfe+EctCgWKCPmkSMx97YqLcaGqb7whZjSpD7Kd8+qfcLitnkQQux
/hC1BH0mOHxXudZBig+xLwV43KfWV56hj9fKXEE5vgJK8WaoU46jsFp18DB6oQaY
tzpF1xRflddVtxDevBzhjQmmJK5M/8+pWcXK3iuyLGpw5+GOpe6tzXmdDGrfU6t4
ZCdxrJpmDVV88sQUrn7L5h2E24WS9xLS8hdb8BujEga2oLeJ2UtTnXlyGaJSqJKJ
5FRfEC2yBo1qPlmYZf9mIahrrjYddc/mt8/2bSGrongbAsPt4JlicVkJX/JhZMYQ
GzBiXCtpF88PeAzHSLFIjmPdxsI/4Ywbd3xKPO2QMULmmgGfniTwm0t5GHbJ9ClJ
YAZPNBymOUaAhD5wjCXbInSRQohvclL312359K3aN+q2xjrs9dwt4PKc/VQeCdyp
Po2Yadf7nhr6LDpVblQbJLX9cCzNTMD6iYHy/JFJy4lBQxV+Om7I2vpZmogXU3Ai
ZyBL5j5H6lcEhPPJQJHrQe+D/mVmTKDdFDxHGv6t/QJRyaLGKT5fcEHZAj8xoR5x
3g0hzTxWYhmBi3aGhzlM
=n5KV
-----END PGP SIGNATURE-----
--=-=-=--
