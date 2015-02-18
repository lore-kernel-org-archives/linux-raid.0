From: NeilBrown <neilb@suse.de>
Subject: Re: md_raid5 using 100% CPU and hang with status resync=PENDING, if
 a drive is removed during initialization
Date: Wed, 18 Feb 2015 12:16:56 +1100
Message-ID: <20150218121656.0584e09d@notabene.brown>
References: <CD8664C5675EDF49A5E76D7DB099D7B32611BB56@VENUS1.in.megatrends.com>
	<20141231164800.GL19091@reaktio.net>
	<CD8664C5675EDF49A5E76D7DB099D7B326130D6E@VENUS1.in.megatrends.com>
	<20150203093040.569aa5e1@notabene.brown>
	<wrfjpp99pp9d.fsf@redhat.com>
	<wrfjd259o4iy.fsf@redhat.com>
	<wrfj61b0gk6l.fsf@redhat.com>
	<20150218112741.08495514@notabene.brown>
	<wrfjh9ukf2y6.fsf@redhat.com>
	<wrfjsie4do37.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5VQweliLQ0tWMd5G7jBiU2R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjsie4do37.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Manibalan P <pmanibalan@amiindia.co.in>, Pasi =?UTF-8?B?S8Okcmtrw6Rp?= =?UTF-8?B?bmVu?= <pasik@iki.fi>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5VQweliLQ0tWMd5G7jBiU2R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Feb 2015 20:07:24 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> > NeilBrown <neilb@suse.de> writes:
> >> On Tue, 17 Feb 2015 19:03:30 -0500 Jes Sorensen <Jes.Sorensen@redhat.c=
om>
> >> wrote:
> >>
> >>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> >>> > Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> >>> >> NeilBrown <neilb@suse.de> writes:
> >>> >>> On Mon, 2 Feb 2015 07:10:14 +0000 Manibalan P <pmanibalan@amiindi=
a.co.in>
> >>> >>> wrote:
> >>> >>>
> >>> >>>> Dear All,
> >>> >>>> 	Any updates on this issue.
> >>> >>>
> >>> >>> Probably the same as:
> >>> >>>
> >>> >>>   http://marc.info/?l=3Dlinux-raid&m=3D142283560704091&w=3D2
> >>> >>
> >>> >> Hi Neil,
> >>> >>
> >>> >> I ran some tests on this one against the latest Linus' tree as of =
today
> >>> >> (1fa185ebcbcefdc5229c783450c9f0439a69f0c1) which I believe include=
s all
> >>> >> your pending 3.20 patches.
> >>> >>
> >>> >> I am able to reproduce Manibalan's hangs on a system with 4 SSDs i=
f I
> >>> >> run fio on top of a device while it is resyncing and I fail one of=
 the
> >>> >> devices.
> >>> >
> >>> > Since Manibalan mentioned this issue wasn't present in earlier kern=
els,
> >>> > I started trying to track down what change caused it.
> >>> >
> >>> > So far I have been able to reproduce the hang as far back as 3.10.
> >>>=20
> >>> After a lot of bisecting I finally traced the issue back to this comm=
it:
> >>>=20
> >>> a7854487cd7128a30a7f4f5259de9f67d5efb95f is the first bad commit
> >>> commit a7854487cd7128a30a7f4f5259de9f67d5efb95f
> >>> Author: Alexander Lyakas <alex.bolshoy@gmail.com>
> >>> Date:   Thu Oct 11 13:50:12 2012 +1100
> >>>=20
> >>>     md: When RAID5 is dirty, force reconstruct-write instead of
> >>> read-modify-write.
> >>>    =20
> >>>     Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> >>>     Suggested-by: Yair Hershko <yair@zadarastorage.com>
> >>>     Signed-off-by: NeilBrown <neilb@suse.de>
> >>>=20
> >>> If I revert that one I cannot reproduce the hang, applying it reprodu=
ces
> >>> the hang consistently.
> >>
> >> Thanks for all the research!
> >>
> >> That is consistent with what you already reported.
> >> You noted that it doesn't affect RAID6, and RAID6 doesn't have an RMW =
cycle.
> >>
> >> Also, one  of the early emails from Manibalan contained:
> >>
> >> handling stripe 273480328, state=3D0x2041 cnt=3D1, pd_idx=3D5, qd_idx=
=3D-1
> >> , check:0, reconstruct:0
> >> check 5: state 0x10 read           (null) write           (null) writt=
en           (null)
> >> check 4: state 0x11 read           (null) write           (null) writt=
en           (null)
> >> check 3: state 0x0 read           (null) write           (null) writte=
n           (null)
> >> check 2: state 0x11 read           (null) write           (null) writt=
en           (null)
> >> check 1: state 0x11 read           (null) write           (null) writt=
en           (null)
> >> check 0: state 0x18 read           (null) write ffff8808029b6b00 writt=
en           (null)
> >> locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=
=3D3,-1
> >> force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D2734803=
28
> >> for sector 273480328, rmw=3D2 rcw=3D1
> >>
> >> So it is forcing RCW, even though a single block update is usually han=
dled
> >> with RMW.
> >>
> >> In this stripe, the parity disk is '5' and disk 3 has failed.
> >> That means to perform an RCW, we need to read the parity block in order
> >> to reconstruct the content of the failed disk.  And if we were to do t=
hat,
> >> we may as well just do an RMW.
> >>
> >> So I think the correct fix would be to only force RCW when the array
> >> is not degraded.
> >>
> >> So something like this:
> >>
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index aa76865b804b..fa8f8b94bfa8 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -3170,7 +3170,8 @@ static void handle_stripe_dirtying(struct r5conf=
 *conf,
> >>  	 * generate correct data from the parity.
> >>  	 */
> >>  	if (conf->max_degraded =3D=3D 2 ||
> >> -	    (recovery_cp < MaxSector && sh->sector >=3D recovery_cp)) {
> >> +	    (recovery_cp < MaxSector && sh->sector >=3D recovery_cp &&
> >> +	     s->failed =3D=3D 0)) {
> >>  		/* Calculate the real rcw later - for now make it
> >>  		 * look like rcw is cheaper
> >>  		 */
> >>
> >>
> >> I think reverting the whole patch is not necessary and discards useful
> >> functionality while the array is not degraded.
> >>
> >> Can you test this patch please?
> >
> > Actually I just tried this one - I was on my way home and grabbed food
> > on the way, and thought there was a better solution than to revert.
> >
> > I'll give your solution a spin too.
>=20
> I tried your patch, as expected that also resolves the problem. Not sure
> which solution is better, so I'll let you pick.

Thanks!

>=20
> Note whichever patch you choose it is applicable for stable-3.6+

3.6??=20

$ git describe --contains a7854487cd7128a30a7f4f5259
v3.7-rc1~10^2~7

so I assume 3.7.
Doesn't apply to 3.6, so I'll assume a typo.

NeilBrown

--Sig_/5VQweliLQ0tWMd5G7jBiU2R
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOPoCDnsnt1WYoG5AQKfaxAAvrrCAuHY8uP9+83gEvFyiJpB4NNUnuK2
uNxe3VdntzuMK0+xBCgSROc/mPtz5TIByH5wTKm4hTgy9RA5coWurOz0Tp9gupJs
oxmclzIBV5za7qDd9t1M97qPhgXrzLly8XX5US4OK58ZZDKT2bay0ltLddMctMEL
H0gP51/IIfeZ97kofxgdRRYqfMXXVRdrg1Y12uWVPPcFBNlhFg+QJH6+WtOZxPlf
ypxg1z4slV2WsQkbebaBfBRbX3r0m8qN/LHZKxCUUKFl9C0Yu0qXMrHX5BnnAOyw
mIgGIZqDhJYDncFaku0TxkaGqukgSDgd6W66LddZYjTMe/x/zfnIwYsovfgE0cQB
xp1ackylJkyIgdBGWuRtHGYBi2sp16SDJisKs2rBx5vU2tBy2B5ZzxMIp6gfsaAX
AsHyqHGeWzIM3V6dYvAR8KsSP6Z0NDZo/VZa/+W+AXz2N80LmYXcT9RLNJj3CBSu
ySxFQLoWqlHB/5JWKiynrAq6e28A97x6bQ/HbuzQp46XUM0vNaiBPqzImzngjLWO
kvJDX1eLSu304ielUF5LrePMr0yGewsdWd4FrgO914TbGpwoTN3lF6Ls6UiIZT6A
jmCTmj8WkO0XkUtyrPoUR/f3Qi7tQmENz40nAA0USbV51pMytOvHWwTSBj/duwm0
CB39nfxEX7g=
=C3J+
-----END PGP SIGNATURE-----

--Sig_/5VQweliLQ0tWMd5G7jBiU2R--
