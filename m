From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V1] md:Fix name of raid thread when raid takeovered.
Date: Wed, 27 Jun 2012 13:56:28 +1000
Message-ID: <20120627135628.7752780e@notabene.brown>
References: <201206051337125784360@gmail.com>
	<20120605154851.0664f8fb@notabene.brown>
	<201206051406033596882@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//L_.O+wpJsAzeC7_mVEQekI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206051406033596882@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//L_.O+wpJsAzeC7_mVEQekI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Jun 2012 14:06:06 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On  Mon, 4 Jun 2012 22:49:02 -0700, neil wrote:
> >On Tue, 5 Jun 2012 13:37:15 +0800 majianpeng <majianpeng@gmail.com> wrot=
e:
> >
> >> When raid takeovered, it used old personality to set task->comm[].
> >> So we add judgement and set corrected task->comm[].
> >>=20
> >> Signed-off-by: majianpeng <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/md.c |   14 ++++++++++++++
> >>  1 files changed, 14 insertions(+), 0 deletions(-)
> >>=20
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 1c2f904..6b3ce6e 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -6738,11 +6738,25 @@ struct md_thread *md_register_thread(void (*ru=
n) (struct mddev *), struct mddev
> >>  				 const char *name)
> >>  {
> >>  	struct md_thread *thread;
> >> +	struct md_personality *pers =3D NULL;
> >> =20
> >>  	thread =3D kzalloc(sizeof(struct md_thread), GFP_KERNEL);
> >>  	if (!thread)
> >>  		return NULL;
> >> =20
> >> +	/*
> >> +	 *When raid takeovered,the mddev->pers was old,so the
> >> +	 *thread_name is wrong.
> >> +	 */
> >> +	if (name =3D=3D NULL && mddev->level !=3D mddev->new_level) {
> >> +		spin_lock(&pers_lock);
> >> +		list_for_each_entry(pers, &pers_list, list)
> >> +			if (pers->level =3D=3D mddev->new_level) {
> >> +				name =3D pers->name;
> >> +				break;
> >> +			}
> >> +		spin_unlock(&pers_lock);
> >> +	}
> >>  	init_waitqueue_head(&thread->wqueue);
> >> =20
> >>  	thread->run =3D run;
> >
> >No, I really don't like that.  It is to focussed on fixing the particular
> >symptom rather that making the code generally cleaner.
> >
>=20
> >Was there a reason you didn't just change the last arg of md_register_th=
read
> >to be the level name instead of NULL??
> >
> No.I first wanted to corrected in which call md_register_thread.But I fou=
nd it will take some codes.
> So i think corrected this function may better.
> >NeilBrown

I've applied this patch to fix the problem.

Thanks,
NeilBrown

=46rom 5fc056ff25485cecb8464a6fe09d3d486fd99d6a Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 27 Jun 2012 13:53:52 +1000
Subject: [PATCH] md: make 'name' arg to md_register_thread non-optional.

Having the 'name' arg optional and defaulting to the current
personality name is no necessary and leads to errors, as when
changing the level of an array we can end up using the
name of the old level instead of the new one.

So make it non-optional and always explicitly pass the name
of the level that the array will be.

Reported-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 973aa84..c601c4b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6751,7 +6751,7 @@ struct md_thread *md_register_thread(void (*run) (str=
uct mddev *), struct mddev
 	thread->tsk =3D kthread_run(md_thread, thread,
 				  "%s_%s",
 				  mdname(thread->mddev),
-				  name ?: mddev->pers->name);
+				  name);
 	if (IS_ERR(thread->tsk)) {
 		kfree(thread);
 		return NULL;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 9339e67..61a1833 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -474,7 +474,8 @@ static int multipath_run (struct mddev *mddev)
 	}
=20
 	{
-		mddev->thread =3D md_register_thread(multipathd, mddev, NULL);
+		mddev->thread =3D md_register_thread(multipathd, mddev,
+						   "multipath");
 		if (!mddev->thread) {
 			printk(KERN_ERR "multipath: couldn't allocate thread"
 				" for %s\n", mdname(mddev));
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a9c7981..39b2a8a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2621,7 +2621,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		goto abort;
 	}
 	err =3D -ENOMEM;
-	conf->thread =3D md_register_thread(raid1d, mddev, NULL);
+	conf->thread =3D md_register_thread(raid1d, mddev, "raid1");
 	if (!conf->thread) {
 		printk(KERN_ERR
 		       "md/raid1:%s: couldn't allocate thread\n",
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index bcf6ea8..0ee7602 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3427,7 +3427,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	spin_lock_init(&conf->resync_lock);
 	init_waitqueue_head(&conf->wait_barrier);
=20
-	conf->thread =3D md_register_thread(raid10d, mddev, NULL);
+	conf->thread =3D md_register_thread(raid10d, mddev, "raid10");
 	if (!conf->thread)
 		goto out;
=20
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 62b6b3a..a5135e5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4840,6 +4840,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	int raid_disk, memory, max_disks;
 	struct md_rdev *rdev;
 	struct disk_info *disk;
+	char pers_name[6];
=20
 	if (mddev->new_level !=3D 5
 	    && mddev->new_level !=3D 4
@@ -4963,7 +4964,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
 		       mdname(mddev), memory);
=20
-	conf->thread =3D md_register_thread(raid5d, mddev, NULL);
+	sprintf(pers_name, "raid%d", mddev->new_level);
+	conf->thread =3D md_register_thread(raid5d, mddev, pers_name);
 	if (!conf->thread) {
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't allocate thread.\n",


--Sig_//L_.O+wpJsAzeC7_mVEQekI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+qEbDnsnt1WYoG5AQJZrxAAlVNDDEMrhCjnsGmjnpspbYU9hpK+O6Z7
03lE3AV83PWuQnWTQsvKUm2Gg+DRA4C0Irdl3x99zJsJMGliFx0voijshV4vEbca
wyJXpBJyvZrVkPUhMO3FXEL/23PDqFqGVqLEdzmy1SO35SgGR3i32VNfMO/xz+JX
qBUz3ijTcEtQkjsbFEObuLF1xwQbEmJ2HbOy6LYsymwYQhU2A4nsy0aYaOqnzF+z
vzlT6sps5vG3c+lvj5pB6BXZHm7GD5fonYzPttPYtCSWIwDBZjomUd/xNtQvd6rA
9OQdRHxaBkuOwJ+//e903LWupaJuH99T8y1pnOHRJ0fJGiYgEasrqXTwfepg4+MA
yNESRhLwf5chvXccAyoBr8E2Os0M/17OyHAd+opOZej0iLWLnokoAXElrzjopUO+
zGHHSrmjmucri0ymgdMygQmJTWPcII72cKB/1mFDDeRWSRVZ0JYRWyW0oy25zwWC
PhWBcc3sg/SiDXmQhOwEEa1mzUAixaUGfF3dFLFWPSDBRyvI5p27XoQKGZe9mqx3
MGwxNvU+aN7szZHksInJtLLCYBljrAr/yofS93w2b6mZnm+X4j4lzIa6lB2KHPKc
4QUS4Hpjx+97rmWiKX1qeiR3qvIrNjG1lV9PD0M9t9Qba4QmTGRM5gl2q4/X6aej
Q7WFVERqiUs=
=ZyCX
-----END PGP SIGNATURE-----

--Sig_//L_.O+wpJsAzeC7_mVEQekI--
