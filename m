From: NeilBrown <neilb@suse.de>
Subject: Re: [Doubt] how is a disk marked faulty in RAID5
Date: Sat, 28 Apr 2012 08:20:54 +1000
Message-ID: <20120428082054.3ecd8398@notabene.brown>
References: <CANSbrrpBAPdKgJYJGtpRs0DcwTs_1BEOEaxf3y4fVcO6M+0H1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XhE00Y0qK5R4Zv=1qHn1MZV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANSbrrpBAPdKgJYJGtpRs0DcwTs_1BEOEaxf3y4fVcO6M+0H1w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anuj Goel <agoel@cs.stonybrook.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/XhE00Y0qK5R4Zv=1qHn1MZV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Apr 2012 19:36:48 -0400 Anuj Goel <agoel@cs.stonybrook.edu> wrot=
e:

> Hi,
>=20
> I have been looking into the RAID5 code, but unable to find how a disk
> is marked faulty in a RAID5 array.

A call to md_error() calls back into error() and marks it fault.

> I consider the case when we try to read, say 2 sectors within a chunk
> and the read fails. My understanding so far is as below:
>=20
> The status of the read operation is returned in the call back function
> "raid5_align_endio" registered in chunk-aligned_read().
> If there was an error in the read, it LIFO adds the original bio to
> the retry list and wakes up the raid5d thread.
> This thread will remove the bio from the retry list and send it to
> retry_aligned_read().
>=20
> In retry_aligned_read(), we first compute the disk number and sector
> offset within the disk using raid5_compute_sector().
>=20
> 1. Then we do some stripe operations, but I cannot see where the
> actual read from the disk is scheduled.

retry_alignd_read calls handle_stripe()
handle_stripe() calls handle_stripe_fill()
handle_stripe_fill() calls fetch_block which sets R5_Wantread on the target
'dev', or on every other dev (later it will set R5_Wantcompute on the target
dev).
handle_stripe() calls ops_run_io which notices R5_Wantread an schedules the
read.

> 2. Also, if the sector on the disk is found unreadable, according to
> the RAID5 design, it should be recomputed using parity and the disk
> marked FAULTY. Can you please point me to the code/functions I should
> look into to understand how this is being done.

fetch_block is probably the important bit to read and understand
Note how it sets STRIPE_OP_COMPUTE_BLOCK and subsequently __raid_run_ops()
notices that and runs ops_run_compute5() which sets up the xor process.


> 3. After one disk failure, if another disk fails, I think the RAID5
> array cannot be used anymore. How is the second disk failure reported
> ?

What exactly to you mean by "reported".
The second disk is marked as faulty
Subsequent writes and some reads will fail.
See the
	if (s.failed > conf->max_degraded) {
branch in handle_stripe()


>=20
> This is my first tryst with Linux code, (specifically software RAID),
> so I am not sure how to debug and understand the code flow.
> Is code reading the only way to understand the flow, or is there some
> documentation giving a high level overview of the implementation of
> software RAID ?
>=20
> Any suggestions will be highly appreciated !!
>=20

NeilBrown


--Sig_/XhE00Y0qK5R4Zv=1qHn1MZV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5sbxjnsnt1WYoG5AQL7rQ//WkM+JpLeYtOqu3ATrC7tH3sobLnsBT8A
HGa/hRDz8X80Zr918bK+uzltCCKVLw7rIWsL0o8zTaYihXdW6v+v1no/Dt4S5kth
Q+wpLpW9JUUUzGqXLhWSeby5wQrGdbY+93mUdGsvwRV5RuqLkDinGaFcif9mOx0N
53QFyKRam5o6vZ9JoTc+lQAASlrxlPhV7EgkQLGqEfrDbYefhVKVLKw5Lq8NO/II
vAVW8DdZbadeIg1HTvurfZu6ppJy/smJZST5MM5/uerkO9TX7WFR/jRkMysS7AUx
ZeTuH4uP7a4+8Zjg/hXDcRoY3cOanudwIZpq/aJ4a4vUtlAmTYx9mPGTM1eYCLil
K3LAeOrZQfldqMnBvbBKD8yESNwM+k0/67UZssTVmLttyEOj5yr5Bg2k4D872mCL
X9vjUTeV0Z+6fDoP2qCzcc87SRBQiHfKAOxQm+69ujrDOuy/8uD/iUvIo/DsQ/JS
B9xbyMcDgKksBRYgbz/1mSaoPvo15G+AtcOQPYhs+lD+seKl27OsDeTDvF902PYT
+J/Xe6saVG58ZM9jJR9ZYG5DQkjp6RCLfqfzLv6D6bPYcYHggovZMQiMl8pkYqFn
560YNsszpYWlYuoYLQR0xuaxdmg664dhJHEwBSXzvDrTQ6YdTr+jALiQRR0B8PoI
OAaTeJ7bzvM=
=Cyry
-----END PGP SIGNATURE-----

--Sig_/XhE00Y0qK5R4Zv=1qHn1MZV--
