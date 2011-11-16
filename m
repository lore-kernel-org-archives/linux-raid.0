From: NeilBrown <neilb@suse.de>
Subject: Re: possible bug - bitmap dirty pages status
Date: Wed, 16 Nov 2011 13:30:45 +1100
Message-ID: <20111116133045.2528310b@notabene.brown>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
	<CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
	<CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
	<4E5E2F7D.1010306@anonymous.org.uk>
	<CAGqmV7p=oM_TJoBC-=he3TnJwcmbZBekq14yjiba_p90RC+0BQ@mail.gmail.com>
	<CAECXXi7Ui6T2kti1JjA6Txft7LXR_sM1QbUkmgXj92kSXPrfCg@mail.gmail.com>
	<CAGqmV7qKjV1QL_GgxGqmLL2BSui+HVxRo=82KHuW0oLONH1D_A@mail.gmail.com>
	<20110901154022.45f54657@notabene.brown>
	<4EC1A037.4080406@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c/8MNG+EY3s7SOfnL7vem8y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EC1A037.4080406@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: linbloke <linbloke@fastmail.fm>
Cc: CoolCold <coolthecold@gmail.com>, Paul Clements <paul.clements@us.sios.com>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/c/8MNG+EY3s7SOfnL7vem8y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Nov 2011 10:11:51 +1100 linbloke <linbloke@fastmail.fm> wrote:
> Hello,
>=20
> Sorry for bumping this thread but I couldn't find any resolution=20
> post-dated. I'm seeing the same thing with SLES11 SP1. No matter how=20
> long I wait or how often I sync(8), the number of dirty bitmap pages=20
> does not reduce to zero - 52 has become the new zero for this array=20
> (md101). I've tried writing more data to prod the sync  - the result was=
=20
> an increase in the dirty page count (53/465) and then return to the base=
=20
> count (52/465) after 5seconds. I haven't tried removing the bitmaps and=20
> am a little reluctant to unless this would help to diagnose the bug.
>=20
> This array is part of a nested array set as mentioned in another mail=20
> list thread with the Subject: Rotating RAID 1. Another thing happening=20
> with this array is that the top array (md106), the one with the=20
> filesystem on it, has the file system exported via NFS to a dozen or so=20
> other systems. There has been no activity on this array for at least a=20
> couple of minutes.
>=20
> I certainly don't feel comfortable that I have created a mirror of the=20
> component devices. Can I expect the devices to actually be in sync at=20
> this point?

Hi,
 thanks for the report.
 I can understand your discomfort.  Unfortunately I haven't been able to
 discover with any confidence what the problem is, so I cannot completely
 relieve that discomfort.  I have found another possible issue - a race that
 could cause md to forget that it needs to clean out a page of the bitmap.
 I could imagine that causing 1 or maybe 2 pages to be stuck, but I don't
 think it can explain 52.

 Can can check if you actually have a mirror by:
    echo check > /sys/block/md101/md/sync_action
 then wait for that to finish and check ..../mismatch_cnt.
 I'm quite confident that will report 0.  I strongly suspect the problem is
 that we forget to clear pages or bits, not that we forget to use them duri=
ng
 recovery.

 So don't think that keeping the bitmaps will help in diagnosing the
 problem.   We I need is a sequence of events that is likely to produce the
 problem, and I realise that is hard to come by.

 Sorry that I cannot be more helpful yet.

NeilBrown


--Sig_/c/8MNG+EY3s7SOfnL7vem8y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsMgWznsnt1WYoG5AQL2ZA//XKpDs60q7lt4tx05TAHXedX1lxcXzAFd
tY+n/mLdpapcIA3kC1UrcDRbSX1rmJ1hCbC46vu6TEk6AP3CcUmpfyN4QdUBvkXy
G4PyJMrs4l79OFQL4gu7B1UWiluF6TfYpy6uHgI0FJwutAzVL++PspNagQECfCln
0WK5dM5EGIFmfKZ42jKQB1dg2d53X3Kj5qqjQ8ZDl/Yq32pFw+x8rGrhXJffxHhD
OYYwwUUjxlflyjiPbcWiwrrs5bwwiMFrF0aXwvcxgMYuYt8gudVK5kHCkzyt2B4M
/xEJNeRfFkJ08YL2u147Dtqr3MP6ioUw9skNNDtX8faxD2zdz+A62TfhqlbuVx/f
jAAxkWqL147U9YrXaVz5HQZrG9FKCT9tYF4X6ssbGLyQ4B3F2fx/U+yzhwfY4o1N
zz1IRNnj2E/rGQBQWdilVRRUrILaKZFHF73YKJNfSBrLtEntO+dBnUT6LKvzibP8
DV9eC0Txgs4eQuiGGIgrI90uNMGXYe8o2ZVzCqmufce8pYku41BzvhxKWAJBwMFX
0986GChG7IpDEjBVu5Djr2UblNElf2HIkRbnMPtyb2dJhhXNdayaLii4dqYKhzaE
Csjtlw8kNQPXThxYbxT4ztdkKkZZzLZejBqYdaRWjLKEQUHUPxm5EXVuvTv5Jf6d
LY0RVZpZtPQ=
=75B9
-----END PGP SIGNATURE-----

--Sig_/c/8MNG+EY3s7SOfnL7vem8y--
