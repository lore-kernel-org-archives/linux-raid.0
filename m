From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] Fixes for RAID1 resync
Date: Mon, 15 Sep 2014 13:30:06 +1000
Message-ID: <20140915133006.14e57085@notabene.brown>
References: <20140910062039.26400.36745.stgit@notabene.brown>
	<D96E0116-919C-4F4B-B4B6-2564B99449FB@redhat.com>
	<8697EC47-F648-4E66-B37C-4A2DC3030696@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5vJ3WrHggRc7U.ImBx0e+_y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8697EC47-F648-4E66-B37C-4A2DC3030696@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids

--Sig_/5vJ3WrHggRc7U.ImBx0e+_y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 12:12:01 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Sep 10, 2014, at 10:45 PM, Brassow Jonathan wrote:
>=20
> >=20
> > On Sep 10, 2014, at 1:20 AM, NeilBrown wrote:
> >=20
> >>=20
> >> Jon: could you test with these patches on top of what you
> >> have just in case something happens to fix the problem without
> >> me realising it?
> >=20
> > I'm on it.  The test is running.  I'll know later tomorrow.
> >=20
> > brassow
>=20
> The test is still failing from here.  I grabbed 3.17.0-rc4, added the 5 p=
atches, and got the attached backtraces when testing.  As I said, the hangs=
 are not exactly the same.  This set shows the mdX_raid1 thread in the midd=
le of handling a read failure.

Thanks.
mdX_raid1 is blocked in freeze_array.
That could be caused by conf->nr_pending nor aligning properly with
conf->nr_queued.

Both normal IO and resync IO can be retried with reschedule_retry()
and so be counted into ->nr_queued, but only normal IO gets counted in
->nr_pending.

Previously could could only possibly have on or the other and when handling
a read failure it could only be normal IO.  But now that they two types can
interleave, we can have both normal and resync IO requests queued, so we ne=
ed
to count them both in nr_pending.

So the following patch might help.

How complicated are your test scripts?  Could you send them to me so I can
try too?

Thanks,
NeilBrown

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 888dbdfb6986..6a9c73435eb8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -856,6 +856,7 @@ static void raise_barrier(struct r1conf *conf, sector_t=
 sector_nr)
 			     conf->next_resync + RESYNC_SECTORS),
 			    conf->resync_lock);
=20
+	conf->nr_pending++;
 	spin_unlock_irq(&conf->resync_lock);
 }
=20
@@ -865,6 +866,7 @@ static void lower_barrier(struct r1conf *conf)
 	BUG_ON(conf->barrier <=3D 0);
 	spin_lock_irqsave(&conf->resync_lock, flags);
 	conf->barrier--;
+	conf->nr_pending--;
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
 	wake_up(&conf->wait_barrier);
 }

--Sig_/5vJ3WrHggRc7U.ImBx0e+_y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBZdPjnsnt1WYoG5AQLFmQ//aytAwOuXCtmklZLe6NWUDgrotZhW/GuK
8WjGbFEUsWhv9/akRe39Xtgwwbq0TICZJCiyLp43zGVPS3222VgdTIxUcy9yiN+8
WAmCdSNcMGNZBthWfrOm0NrQbLurApRtMlxKTkl0yy4oZDfp9W8U/S6DR98bzKqx
IoJXhwk754nXRQc4cBidDmFa0KGGjCMCOs1sZMm1J29sz3KPbK2uZxj7h/0wKi4F
cYose11rg9uubgAelP4dD514Iq+3bVnXSA8s/2D8wXKgSLFlVnpxkHyM9C68UdyT
B3WZjAdd+vttkQ6+sNqXyNSq51h99gOAc+1UJb8Ldn5rqnlqNucA7S1RHfrivdx8
Ivd1HSK9+V2vYJTzXRLLvUMJyN0uLfr+Vfz/I6zh7abqFAi8YIyGd0YjrXvteglb
vrMdvtL8zpbI2qpV7KtzeNI0mhjdqy18NBCrvYClCTkTzXm3UwYnt0yCdR+2WSPy
rcy6RXaZ3DDnu9SCMF4XSWpFQkzfUZV87Yu6HJhgdYliDOZGmMeAjXguCqjziSCj
lKSqDuyAngjCB4dmhMHoBIamd/9CKDDynjNzghuTplw41Yq69ZaO8sLi160m72g7
kLwHVvSVt/Jse7ZJXPQ+CxbBHqLggW17MbW9oFnej9V1m4DbHRx+oSg13UfElRRm
JfU/TRa/xMk=
=iGmJ
-----END PGP SIGNATURE-----

--Sig_/5vJ3WrHggRc7U.ImBx0e+_y--
