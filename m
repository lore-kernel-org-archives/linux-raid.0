From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V1] md:Fix name of raid thread when raid takeovered.
Date: Tue, 5 Jun 2012 16:33:38 +1000
Message-ID: <20120605163338.36d49bb2@notabene.brown>
References: <201206051337125784360@gmail.com>
	<20120605154851.0664f8fb@notabene.brown>
	<201206051406033596882@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nIt2_enwwt3eeqkG=A3bw1T"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206051406033596882@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/nIt2_enwwt3eeqkG=A3bw1T
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

I don't think it is that much code.  Just this:

NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c2f904..2e70768 100644
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
index 99ae606..994ac9a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3421,7 +3421,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	spin_lock_init(&conf->resync_lock);
 	init_waitqueue_head(&conf->wait_barrier);
=20
-	conf->thread =3D md_register_thread(raid10d, mddev, NULL);
+	conf->thread =3D md_register_thread(raid10d, mddev, "raid10");
 	if (!conf->thread)
 		goto out;
=20
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d267672..92c164f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4823,6 +4823,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	int raid_disk, memory, max_disks;
 	struct md_rdev *rdev;
 	struct disk_info *disk;
+	char pers_name[6];
=20
 	if (mddev->new_level !=3D 5
 	    && mddev->new_level !=3D 4
@@ -4946,7 +4947,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
 		       mdname(mddev), memory);
=20
-	conf->thread =3D md_register_thread(raid5d, mddev, NULL);
+	sprintf(pers_name, "raid%d", mddev->new_level);
+	conf->thread =3D md_register_thread(raid5d, mddev, pers_name);
 	if (!conf->thread) {
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't allocate thread.\n",

--Sig_/nIt2_enwwt3eeqkG=A3bw1T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT82oQjnsnt1WYoG5AQJztw/+LuNHe3yvHcOWijzUoEKhgeulSdmpOHQY
47iwK3KvfjAC1qygfbK89b+GWoiKg2aY2oFh/7KPOBBWVRxi41/2mQa053o0sesf
d3H3TC3V0nkXzA/81haUDnEyMQZfVHzrqtN2UcPaFUk+NIcweYUTmWJL2dx2DTPK
ag2gts0VUCUYG1GQrSt50pMknP/sk6b/XDwemUcjVXHmh/9omVtj8NHwGdd6MCxD
WHxVQIvLMS9mSQxjG0Eek1x6a18RYiesVsRrZ9NW1IjgO9Vem7XyADuEsqAGIhYl
6+wmlaK5jUtoUqGVmumufVW+Ob/FDUH0S16BBtZYoeWZsACQvG0RPSXgpfuO1jlx
pGt2dT7OhKsTcpjjO1iTo0mk8rCW9Vq96yqLp/5PPEjsN14naWlz+H8sfanhNYKz
ppFq82K9HrOIEx2krxE8vDaxcrMN4i/BIRoF4gjvwO28OOx23P2C7BMRgZZItoX+
Ik/ZGYWTGoxPQJa57JtS08j+QfrjIX5IHyRmoI7BIu0j5F9z87P0f79jXD41ielf
VloRJahW6wcM17krX4AlmUozAKqHrtuhXlTMkJ73EjKkIkHHBgycCDcm0dLdxYd2
vPkPzzXgnnqZTjdqK8j7bAR9cyZgbxNCF0jOR1lihREVv9JpJTuG0D83U8SP8e4H
EWxV9DNPskQ=
=P65C
-----END PGP SIGNATURE-----

--Sig_/nIt2_enwwt3eeqkG=A3bw1T--
