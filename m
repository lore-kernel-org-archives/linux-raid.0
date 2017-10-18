From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Thu, 19 Oct 2017 09:36:27 +1100
Message-ID: <87376ghyms.fsf@notabene.neil.brown.name>
References: <87mv4qjrez.fsf@notabene.neil.brown.name> <20171018062137.ssdhwkeoy6fdp7yq@kernel.org> <87h8uwj4mz.fsf@notabene.neil.brown.name> <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18 2017, Artur Paszkiewicz wrote:

> On 10/18/2017 09:29 AM, NeilBrown wrote:
>> On Tue, Oct 17 2017, Shaohua Li wrote:
>>=20
>>> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>>>
>>>> lockdep currently complains about a potential deadlock
>>>> with sysfs access taking reconfig_mutex, and that
>>>> waiting for a work queue to complete.
>>>>
>>>> The cause is inappropriate overloading of work-items
>>>> on work-queues.
>>>>
>>>> We currently have two work-queues: md_wq and md_misc_wq.
>>>> They service 5 different tasks:
>>>>
>>>>   mddev->flush_work                       md_wq
>>>>   mddev->event_work (for dm-raid)         md_misc_wq
>>>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>>>   mddev->del_work (md_start_sync)         md_misc_wq
>>>>   rdev->del_work                          md_misc_wq
>>>>
>>>> We need to call flush_workqueue() for md_start_sync and ->event_work
>>>> while holding reconfig_mutex, but mustn't hold it when
>>>> flushing mddev_delayed_delete or rdev->del_work.
>>>>
>>>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>>>> best to leave that alone.
>>>>
>>>> So create a new workqueue, md_del_wq, and a new work_struct,
>>>> mddev->sync_work, so we can keep two classes of work separate.
>>>>
>>>> md_del_wq and ->del_work are used only for destroying rdev
>>>> and mddev.
>>>> md_misc_wq is used for event_work and sync_work.
>>>>
>>>> Also document the purpose of each flush_workqueue() call.
>>>>
>>>> This removes the lockdep warning.
>>>
>>> I had the exactly same patch queued internally,
>>=20
>> Cool :-)
>>=20
>>>                                                   but the mdadm test su=
ite still
>>> shows lockdep warnning. I haven't time to check further.
>>>
>>=20
>> The only other lockdep I've seen later was some ext4 thing, though I
>> haven't tried the full test suite.  I might have a look tomorrow.
>
> I'm also seeing a lockdep warning with or without this patch,
> reproducible with:
>

Thanks!
Looks like using one workqueue for mddev->del_work and rdev->del_work
causes problems.
Can you try with this addition please?

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1dfc9879368..b3192943de7d 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -92,6 +92,7 @@ EXPORT_SYMBOL(md_cluster_mod);
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 static struct workqueue_struct *md_wq;
 static struct workqueue_struct *md_del_wq;
+static struct workqueue_struct *rdev_del_wq;
 static struct workqueue_struct *md_misc_wq;
=20
 static int remove_and_add_spares(struct mddev *mddev,
@@ -2265,7 +2266,7 @@ static void unbind_rdev_from_array(struct md_rdev *rd=
ev)
 	synchronize_rcu();
 	INIT_WORK(&rdev->del_work, md_delayed_delete);
 	kobject_get(&rdev->kobj);
=2D	queue_work(md_del_wq, &rdev->del_work);
+	queue_work(rdev_del_wq, &rdev->del_work);
 }
=20
 /*
@@ -4307,7 +4308,7 @@ new_dev_store(struct mddev *mddev, const char *buf, s=
ize_t len)
 		return -EOVERFLOW;
=20
 	/* Ensure old devices are fully deleted (rdev->del_work) */
=2D	flush_workqueue(md_del_wq);
+	flush_workqueue(rdev_del_wq);
=20
 	err =3D mddev_lock(mddev);
 	if (err)
@@ -7140,7 +7141,7 @@ static int md_ioctl(struct block_device *bdev, fmode_=
t mode,
=20
 	if (cmd =3D=3D ADD_NEW_DISK)
 		/* need to ensure md_delayed_delete() has completed (rdev->del_work) */
=2D		flush_workqueue(md_del_wq);
+		flush_workqueue(rdev_del_wq);
=20
 	if (cmd =3D=3D HOT_REMOVE_DISK)
 		/* need to ensure recovery thread has run */
@@ -9033,8 +9034,9 @@ static int __init md_init(void)
=20
 	md_wq =3D alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	md_del_wq =3D alloc_workqueue("md_del", 0, 0);
+	rdev_del_wq =3D alloc_workqueue("md_rdev_del", 0, 0);
 	md_misc_wq =3D alloc_workqueue("md_misc", 0, 0);
=2D	if (!md_wq || !md_del_wq || !md_misc_wq)
+	if (!md_wq || !md_del_wq || !rdev_del_wq || !md_misc_wq)
 		goto err;
=20
 	if ((ret =3D register_blkdev(MD_MAJOR, "md")) < 0)
@@ -9062,6 +9064,8 @@ static int __init md_init(void)
 		destroy_workqueue(md_wq);
 	if (md_del_wq)
 		destroy_workqueue(md_del_wq);
+	if (rdev_del_wq)
+		destroy_workqueue(rdev_del_wq);
 	if (md_misc_wq)
 		destroy_workqueue(md_misc_wq);
 	return ret;
@@ -9319,6 +9323,7 @@ static __exit void md_exit(void)
 	}
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_del_wq);
+	destroy_workqueue(rdev_del_wq);
 	destroy_workqueue(md_wq);
 }
=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnn120ACgkQOeye3VZi
gbkX9xAAjG5cyICTwjGkw5CNiJ+3wKSRT59/F0x80MJDZEU7fKoD5Nyke6kl0ox2
nMXlb7X6OMY8iQ47/JYtiZyoFawCjhXm240F9pxoFqp3AL5/rTKgyLkPMzs2aeva
VE87EzccuFtCIDYjN+PudKDDZPcErgAFA+q2GG4z+dgUKsktjGBtInBIvnMcSEbH
VP5ctPFtPxW++dKgRKcEdAQid2SbHpa2cP9w9ht56EfK9mCfCbU4YxcOCzZ26Gal
aq3xHYoGK9SJyRnRDOWlrOvXBOjMnK5dy3ItgcrX0YBAyzaSNf1rf4ZD3+yDfJTo
S+W7cT3QsS8vJzRIwIzbDa8QX/aA82Ustm+Y7rVHDXeAAMtZkqqDFc6ICfnph0cm
55D8zN7dGNgTqjMYwULrAzQJmfPaN3ffg8UcYXg2M6uV6oZjF2/Y+UbO5u6Z+OHf
ZiRSK3lCcB8yswoQevV4XZQuslEc2WOBLh1Un3ZJ7tXnncWg3cxPx9kz1BYMaqLi
wMIPA9XXd/VOhKaWdsXWkUDYCeeLlkQkZaxIE0LQ/y0PxGIw6F0Cm1PXRfM2aBWx
RsWMjEGdXIUQDlARVHsm7G1niAEbwOfVd0lI61Qn9zaZRL4o/VJ3kCk8xwdNOr/k
/Hlo/a0Btkg4wpjOam9rulrjrrV99wAyan9f2O5A+56LH8teLtc=
=i8Qu
-----END PGP SIGNATURE-----
--=-=-=--
