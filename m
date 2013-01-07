From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH] raid5: Correct some failed-stripe which because the
 badsector.
Date: Tue, 8 Jan 2013 09:17:41 +1100
Message-ID: <20130108091741.4d9786cb@notabene.brown>
References: <2012092211144517180514@gmail.com>
	<20120926112010.0d27c892@notabene.brown>
	<2012092613251873407316@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2v+YrpzHuuWflRfK/1fF9Jv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012092613251873407316@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, "=?gb2312?Q?=D6=DC,_=F7=E8?=" <qi.g.zhou@gmail.com>, "=?gb2312?Q?=B1=DF,_=D3=EA?=" <ycbzzjlbyby@gmail.com>
List-Id: linux-raid.ids

--Sig_/2v+YrpzHuuWflRfK/1fF9Jv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 13:25:21 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> On 2012-09-26 09:20 NeilBrown <neilb@suse.de> Wrote:
> >On Sat, 22 Sep 2012 11:14:47 +0800 "Jianpeng Ma" <majianpeng@gmail.com> =
wrote:
> >
> >> Because raid5 had implemented badsector feature,some failed-stripe whi=
ch because the
> >> badsector can try to correct instead of only failing.
> >>=20
> >> For example:
> >> 1:Create a raid5 by four disks missing/sdb/sdc/sdd.
> >> 2:If readed  data from sdb and met error,so the stripe is failed
> >> 3:If later write-stripe contains sdb which overwrite.The stripe has a
> >> chance to correct.
> >
> >Your patch looks much more complicated that should be necessary, and you
> >don't provide any explanation for how it works, so it is very hard for m=
e to
> >review.
> >
> Before implementing badsector log, failed-stripes were becasue the faulty=
 or removed disks.
> For those, it's unnecessary to do something for those failed-stripe.
> But after implementing badsector log, failed-stripe can by some badsector.
> One example, RAID5 has four disk: one removed and one contained badsector=
, so the stripe is failed;
> Another example is recovery, when recovery a stripe and fail,so all the d=
isks set badsector.
> But for above example, if full-write on this stripe,the badsector will be=
 correct and failed-stripe become normal.
>=20
> This patch is do this to try recorrect some failed-stripe because badsect=
ors.
> The workflow is:
> 1:in func analyse_stripe, we count the overwrite-on-failed-disks(containe=
d badsector or faulty or removed), noworkeddisk(faulty or remove)
> 2:in func handle_stripe, it determines whether to be processed.There will=
 be three cases:
> A: noworkdisk > max_degraded. It indicates there are many removed or faul=
ty disks.It only failed
> B: All faild-disks are overwrited,which dosen't need read old data.So it =
can read other goog disks or computer parity data using RCW.
> C: Some failed-disks are overwrited.If stripe didn't set STRIPE_PREREAD_A=
CTIVE, stripe can delay for waitting other failed-disks write-data.
> Otherwise, it only failed the stripe.
> 3;in func handle_stripe_dirtying do two things:
> 	A: delay for failed-disks write-data
> 	B: set RCW to control this situation
> 4:After successly writed, one thing must to do.It will be rewrite and rer=
ead for check.
> But for this case, it's unnecessary to rewrite,it only reread the failed-=
disks(only contains badsector).


Thanks - I think I know what you are trying to do now.

Please resend the patch with *only* the changes that you actually need and
I'll try to review it.


i.e.

> >> @@ -548,9 +549,9 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
> >>  			else
> >>  				rw =3D WRITE;
> >>  		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
> >> -			rw =3D READ;
> >> +				rw =3D READ;
> >>  		else if (test_and_clear_bit(R5_WantReplace,
> >> -					    &sh->dev[i].flags)) {
> >> +				&sh->dev[i].flags)) {
> >>  			rw =3D WRITE;
> >>  			replace_only =3D 1;
> >>  		} else

This is purely cosmetic so shouldn't be in the patch.


> >> @@ -1737,6 +1738,7 @@ static void raid5_end_read_request(struct bio * =
bi, int error)
> >>  		s =3D sh->sector + rdev->new_data_offset;
> >>  	else
> >>  		s =3D sh->sector + rdev->data_offset;
> >> +
> >>  	if (uptodate) {
> >>  		set_bit(R5_UPTODATE, &sh->dev[i].flags);
> >>  		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {

So is this.


> >> @@ -1852,8 +1856,8 @@ static void raid5_end_write_request(struct bio *=
bi, int error)
> >>  		}
> >>  	}
> >>  	pr_debug("end_write_request %llu/%d, count %d, uptodate: %d.\n",
> >> -		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
> >> -		uptodate);
> >> +		(unsigned long long)sh->sector, i,
> >> +		atomic_read(&sh->count), uptodate);
> >>  	if (i =3D=3D disks) {
> >>  		BUG();
> >>  		return;

So is this.
etc.

NeilBrown



--Sig_/2v+YrpzHuuWflRfK/1fF9Jv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUOtJhTnsnt1WYoG5AQL4Iw//V0kb6I0LOvLnZOVsQerr+TVPYqQITTgc
niNohp1bcrH6rI6tX3Z/VbqiRWmbNH3Htponx1S9+kh04lHzAdzxDx2DkBkOR0Yf
uouWzGB8QfGgj5zNQ/X1YvR/4hBPdGSx4HANIq8WLBuLj2GvmA+dSS4v/A9i50XJ
ytvBmkpjndNqZMaLtdjYFto7zwhIl0TqP5O00jUDG3TNJ9D5rIyw0Eb0n3aT5Zps
Qx8hYkloTW1S8VHW0mVcWUWOMLJOOICD+pj+tsHx+P26Wt0w1DLotfT464Oc3sa1
/DhPhfY5JHyYt3RBBUV2FoM/N79feQ6ynzUP9vqFAePrypEVyeM8LtYAq729c9i3
JpUzH9guH1fiH5hZlZC0vGuuZkvDdAfHOMXkUmp64JIx67qV6UCP7i+0tTXraZJg
fDUqsverntILaGue15MhqFjhTDEuOAbq+SKmbO43UVVu/EAEgmx8ZJnii/yPMVaq
uP4xvx+Dt7cKBl5sOxq4wv9HqOE+Ky4W3uMGZg4IOqhe9BDeTRj3qjPIRL/Dulp1
aTvk68gkqD74myapehLYixTLAGZEgoGIZOup5IJzIfPVMLCITHt9eZNHIBJjQKJr
0sN5E7I3tR6ud/IkcOWn286wTLn/RID0iDvVSkYrZzdv0pgnxKRWj28g1sMCtWcg
52q7tqMOGRs=
=WOuI
-----END PGP SIGNATURE-----

--Sig_/2v+YrpzHuuWflRfK/1fF9Jv--
