From: NeilBrown <neilb@suse.de>
Subject: Re: BUG - raid 1 deadlock on handle_read_error / wait_barrier
Date: Tue, 4 Jun 2013 11:49:24 +1000
Message-ID: <20130604114924.37e4573c@notabene.brown>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	<20130225094350.4b8ef084@notabene.brown>
	<20130225110458.2b1b1e2d@notabene.brown>
	<1361808662.20264.4.camel@148>
	<alpine.DEB.2.02.1302260905390.1736@jlaw-desktop.mno.stratus.com>
	<CAGRgLy45byT7fxLBOqU6ZNjpOL0Xmq6nNsiwJSCTq+kd1Ya7Jg@mail.gmail.com>
	<20130520171753.002f07d9@notabene.brown>
	<CAGRgLy5m8KxKPxJE+AbtYbBDzo9uo81wez1ba=H4VY3Jiq32WQ@mail.gmail.com>
	<CAGRgLy4zTwopPS-cVwT1RKBr8pE7f3n-X3YLyFpktooQtTYGuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EstbdzsE69M3=QkPDp0bMFK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4zTwopPS-cVwT1RKBr8pE7f3n-X3YLyFpktooQtTYGuQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shyam Kaushik <shyam@zadarastorage.com>, yair@zadarastorage.com
List-Id: linux-raid.ids

--Sig_/EstbdzsE69M3=QkPDp0bMFK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Jun 2013 15:43:41 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> I believe I have found what is causing the deadlock. It happens in two fl=
avors:
>=20
> 1)
> # raid1d() is called, and conf->pending_bio_list is non-empty at this poi=
nt
> # raid1d() calls md_check_recovery(), which eventually calls
> raid1_add_disk(), which calls raise_barrier()
> # Now raise_barrier will wait for conf->nr_pending to become 0, but it
> cannot become 0, because there are bios sitting in
> conf->pending_bio_list, which nobody will flush, because raid1d is the
> one supposed to call flush_pending_writes(), either directly or via
> handle_read_error. But it is stuck in raise_barrier.
>=20
> 2)
> # raid1_add_disk() calls raise_barrier(), and waits for
> conf->nr_pending to become 0, as before
> # new WRITE comes and calls wait_barrier(), but this thread has a
> non-empty current->bio_list
> # In this case, the code allows the WRITE to go through
> wait_barrier(), and trigger WRITEs to mirror legs, but these WRITEs
> again end up in conf->pending_bio_list (either via raid1_unplug or
> directly). But nobody will flush conf->pending_bio_list, because
> raid1d is stuck in raise_barrier.
>=20
> Previously, for example in kernel 3.2, raid1_add_disk did not call
> raise_barrier, so this problem did not happen.
>=20
> Attached is a reproduction with some prints that I added to
> raise_barrier and wait_barrier (their code also attached). It
> demonstrates case 2. It shows that once raise_barrier got called,
> conf->nr_pending drops down, until it equals the number of
> wait_barrier calls, that slipped through because of non-empty
> current->bio_list. And at this point, this array hangs.
>=20
> Can you please comment on how to fix this problem. It looks like a
> real deadlock.
> We can perhaps call md_check_recovery() after flush_pending_writes(),
> but this only makes the window smaller, not closes it entirely. But it
> looks like we really should not be calling raise_barrier from raid1d.
>=20
> Thanks,
> Alex.

Hi Alex,
 thanks for the analysis.

Does the following patch fix it?  It makes raise_barrier  more  like
freeze_array().
If not, could you try making the same change to the first
wait_event_lock_irq in raise_barrier?

Thanks.
NeilBrown



diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 328fa2d..d34f892 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -828,9 +828,9 @@ static void raise_barrier(struct r1conf *conf)
 	conf->barrier++;
=20
 	/* Now wait for all pending IO to complete */
-	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock);
+	wait_event_lock_irq_cmd(conf->wait_barrier,
+				!conf->nr_pending && conf->barrier < RESYNC_DEPTH,
+				conf->resync_lock, flush_pending_writes(conf));
=20
 	spin_unlock_irq(&conf->resync_lock);
 }

--Sig_/EstbdzsE69M3=QkPDp0bMFK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUa1HpDnsnt1WYoG5AQL51g/+Os99AUTGwRGLEGnrmXktM7na84Nb/3A7
Ktpu6Hx5DLxSvyrD9jIztpDyZVt9MYKd/IDq+dGq6GuXIOKmUaZDMDQo7twj51nu
btxdo58kVHncZzpBSjNfxUbmEc2lFYYsGsoaqoCbs6U8An4f+wBWVGY2M8xDaHEA
X8jHw54af3r+zugw0OaD9hf+yJUYJDeQh9avtGxpNyIP8KEKbGG/L8Wjd9byxEk8
NsYNjgcyhgM5VLe83Az9kIuy8cMZO+5aOae/Z0sWvdCcPGQJg6eZbuDzjgyZUCiU
wOp4hRRX5+6c0NYDAk1B01pp0XJF265EGjoevd8gLkUFilmhl3h5DES9j9DJmWPY
QChe9+UmLoJ3LXEDiPKLgSqYQFds16OZ7U46NqN8lXJNhO/ot0NtZJYSlbStmuhe
9Oz6K9QWK46gWSPHXDK3gsJJOU3+yNCHgjWJlzH6t+1mw5izeZoAV+KERiDoJfTf
O5hVr1suB5pkNe7meWCGLhafRgkSJDwWRZ4xWXYMi/Q7fhFnq6F6JdPd7y5tDZTQ
MPqgvA8Vx9LlRykv0UEfGH1wPomtCp5Exyrco0+6m+1KvV8lMCVmBulSb1bwUmKu
c+q2CT/yJpJZj2RhptZSSEmGga8yf4lcW47Xe+ixgVkEQuKaftj8Cebr4tgv48m5
63AAHjNQikQ=
=/F3E
-----END PGP SIGNATURE-----

--Sig_/EstbdzsE69M3=QkPDp0bMFK--
