From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/4] raid1: directly dispatch write request if no bitmap
Date: Thu, 24 May 2012 13:51:17 +1000
Message-ID: <20120524135117.238b2ed9@notabene.brown>
References: <20120523072619.670179001@kernel.org>
	<20120523072829.967587288@kernel.org>
	<20120524122112.05b4d6e3@notabene.brown>
	<20120524025425.GA1190@kernel.org>
	<20120524130912.4076ea1a@notabene.brown>
	<20120524033126.GA1172@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uk7tPxEDgHiOkzhg7/NM_MV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120524033126.GA1172@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/uk7tPxEDgHiOkzhg7/NM_MV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 May 2012 11:31:26 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, May 24, 2012 at 01:09:12PM +1000, NeilBrown wrote:

> > Not necessarily.  It might queue it:
> > 	if (current->bio_list) {
> > 		bio_list_add(current->bio_list, bio);
> > 		return;
> > 	}
>=20
> Ah, yes. Looks we can workaround it to increase bioset entry number to
> raid_disks*2. There isn't too much memory wasted with it.

No, that doesn't work.  There might be raid_disk*2 separate threads which
have each allocated on entry from the pool, and then they all block waiting
for another.

Adding the pool can change the probability of a deadlock but not the
possibility.

NeilBrown


--Sig_/uk7tPxEDgHiOkzhg7/NM_MV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT72wNTnsnt1WYoG5AQIj5w/8DUIdBEAW7TCd3qWaU1oiIyF2uZVNg1Om
ugq6qjs7V7ZmWZgiswBbPm4b5RZRy7icltz+/GOMClKD6mbWuQSnx6hSgp2+2xVA
Bn6vrVMQTexRN+/bPHD4MnU1s7cc9U0iE6cc7aOKgpu8rzpxAHHnDs3whDc4UdAx
QChA60vAjR21vnWO5XqyL7Jf6wwiRbFrt5SkV7tZN1dGxvqCSdzqvFLwiOaZyzD7
GBgluSpULrnGC4r+lRmiPveWnwAiE+ldYERRet/6zqSdQ9yW0/O1DKWzDFnfE+NB
rGdKp8Jm/KUoEOGaKL9AHAL7d1N/Pe410FnL7Qot+q3UwAwmG0bZhFDWtQEh4UCc
zzLZZV3L+rlqrKiaK8yC+gY+aUN7KqhHqawafxj4oqgkes8UjQT/FlRFC4gVkwax
7zr8pYyHZzKtNoHGiapvdKP09w4xC+MNmpnbQT3VHFn4aWByufgvxIw507+0isFR
e95OujX610ALsVldQe9OctPpe4NlTjaShprvtxUnwZ5Olwg5t5ZhMD5subkaYrmW
Of9UVArB6NGt7dEhciRVRH8rfwAQnjkIjkYGIr+W7ig16qAYZtRkHw/Edq0fIlzd
vEESqHr2bfeQfGpxyr2Jf2Bv+cfnc8qzqeXlmS0O3FLp4XIjXym0T3btcAcdE5Tz
D9f0PUhsVes=
=NZrx
-----END PGP SIGNATURE-----

--Sig_/uk7tPxEDgHiOkzhg7/NM_MV--
