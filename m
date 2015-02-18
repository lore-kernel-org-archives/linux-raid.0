From: NeilBrown <neilb@suse.de>
Subject: Re: md_raid5 using 100% CPU and hang with status resync=PENDING, if
 a drive is removed during initialization
Date: Wed, 18 Feb 2015 11:27:41 +1100
Message-ID: <20150218112741.08495514@notabene.brown>
References: <CD8664C5675EDF49A5E76D7DB099D7B32611BB56@VENUS1.in.megatrends.com>
	<20141231164800.GL19091@reaktio.net>
	<CD8664C5675EDF49A5E76D7DB099D7B326130D6E@VENUS1.in.megatrends.com>
	<20150203093040.569aa5e1@notabene.brown>
	<wrfjpp99pp9d.fsf@redhat.com>
	<wrfjd259o4iy.fsf@redhat.com>
	<wrfj61b0gk6l.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OhMVN2xJtw2C4VPT3tuED5w"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj61b0gk6l.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Manibalan P <pmanibalan@amiindia.co.in>, Pasi =?UTF-8?B?S8Okcmtrw6Rp?= =?UTF-8?B?bmVu?= <pasik@iki.fi>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/OhMVN2xJtw2C4VPT3tuED5w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Feb 2015 19:03:30 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> > Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> >> NeilBrown <neilb@suse.de> writes:
> >>> On Mon, 2 Feb 2015 07:10:14 +0000 Manibalan P <pmanibalan@amiindia.co=
.in>
> >>> wrote:
> >>>
> >>>> Dear All,
> >>>> 	Any updates on this issue.
> >>>
> >>> Probably the same as:
> >>>
> >>>   http://marc.info/?l=3Dlinux-raid&m=3D142283560704091&w=3D2
> >>
> >> Hi Neil,
> >>
> >> I ran some tests on this one against the latest Linus' tree as of today
> >> (1fa185ebcbcefdc5229c783450c9f0439a69f0c1) which I believe includes all
> >> your pending 3.20 patches.
> >>
> >> I am able to reproduce Manibalan's hangs on a system with 4 SSDs if I
> >> run fio on top of a device while it is resyncing and I fail one of the
> >> devices.
> >
> > Since Manibalan mentioned this issue wasn't present in earlier kernels,
> > I started trying to track down what change caused it.
> >
> > So far I have been able to reproduce the hang as far back as 3.10.
>=20
> After a lot of bisecting I finally traced the issue back to this commit:
>=20
> a7854487cd7128a30a7f4f5259de9f67d5efb95f is the first bad commit
> commit a7854487cd7128a30a7f4f5259de9f67d5efb95f
> Author: Alexander Lyakas <alex.bolshoy@gmail.com>
> Date:   Thu Oct 11 13:50:12 2012 +1100
>=20
>     md: When RAID5 is dirty, force reconstruct-write instead of read-modi=
fy-write.
>    =20
>     Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
>     Suggested-by: Yair Hershko <yair@zadarastorage.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> If I revert that one I cannot reproduce the hang, applying it reproduces
> the hang consistently.

Thanks for all the research!

That is consistent with what you already reported.
You noted that it doesn't affect RAID6, and RAID6 doesn't have an RMW cycle.

Also, one  of the early emails from Manibalan contained:

handling stripe 273480328, state=3D0x2041 cnt=3D1, pd_idx=3D5, qd_idx=3D-1
, check:0, reconstruct:0
check 5: state 0x10 read           (null) write           (null) written   =
        (null)
check 4: state 0x11 read           (null) write           (null) written   =
        (null)
check 3: state 0x0 read           (null) write           (null) written    =
       (null)
check 2: state 0x11 read           (null) write           (null) written   =
        (null)
check 1: state 0x11 read           (null) write           (null) written   =
        (null)
check 0: state 0x18 read           (null) write ffff8808029b6b00 written   =
        (null)
locked=3D0 uptodate=3D3 to_read=3D0 to_write=3D1 failed=3D1 failed_num=3D3,=
-1
force RCW max_degraded=3D1, recovery_cp=3D7036944 sh->sector=3D273480328
for sector 273480328, rmw=3D2 rcw=3D1

So it is forcing RCW, even though a single block update is usually handled
with RMW.

In this stripe, the parity disk is '5' and disk 3 has failed.
That means to perform an RCW, we need to read the parity block in order
to reconstruct the content of the failed disk.  And if we were to do that,
we may as well just do an RMW.

So I think the correct fix would be to only force RCW when the array
is not degraded.

So something like this:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index aa76865b804b..fa8f8b94bfa8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3170,7 +3170,8 @@ static void handle_stripe_dirtying(struct r5conf *con=
f,
 	 * generate correct data from the parity.
 	 */
 	if (conf->max_degraded =3D=3D 2 ||
-	    (recovery_cp < MaxSector && sh->sector >=3D recovery_cp)) {
+	    (recovery_cp < MaxSector && sh->sector >=3D recovery_cp &&
+	     s->failed =3D=3D 0)) {
 		/* Calculate the real rcw later - for now make it
 		 * look like rcw is cheaper
 		 */


I think reverting the whole patch is not necessary and discards useful
functionality while the array is not degraded.

Can you test this patch please?

Thanks!

NeilBrown

--Sig_/OhMVN2xJtw2C4VPT3tuED5w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOPcfjnsnt1WYoG5AQJtCw//aW/9yIPdsG14psBkx4nFU3kGaOK93dJo
QWsv1e3dnmVXx1f4CkMjI8PNnel4T2P2GOQVM1GpjRktTwQQW/LGUYewZwhew4Wb
z5nAPJidj2zA7EZYxzUiGAXSOzYwSEIk71snTV1B0dZ3jjwf9AAzklzYOmXRcHJQ
bOUt81S/oFKqDC2zGl48gVT4zHxi8Z29yo4Ak/0czaMxtSKzVo9KppDRoOdClgM5
TvNV2iXd+dso1ECTS58/QokOORx52c/BJQDTi136OPzHwJJ7Px/Op4gXT5lGOa7U
rzcw5zpZ2lYuEVlUqfgCSda0609E64F+2yN630WJF7onesOKvR2tp4TEcEIRZweQ
RlGVngU8UJkaFax/Tlb7d5NPlPNb7etrColYFtJHPXgeE1r/2ks9wsbWQPTlrbOg
1F6uTBp123PfJoXcx0CEUt1viXAfxDdYkLFv6UTswWhuTQ/V4ljW83Xa+2qWOBlJ
85s/eR1BylkHU/lHlZ9LEyteuuDas4jjlYmt8CUrlUauxT8ewFmBcB09pa+m7QZG
TNEjGm8Dlx7rTRfyKVbjrjI1jnvxwjXe/qWinHtriTwVnvxao52mruMmI9RjanDb
cF8IZXPy3gHAd1HQbUDlwfM/E6yi+SGkW5UWzeYQxoNr6/uj4QBxcSglrJ16OWNJ
Fq5grGZcEq8=
=9p8O
-----END PGP SIGNATURE-----

--Sig_/OhMVN2xJtw2C4VPT3tuED5w--
