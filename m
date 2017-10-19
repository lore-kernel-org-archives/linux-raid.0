From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Fri, 20 Oct 2017 09:28:49 +1100
Message-ID: <87wp3qg4bi.fsf@notabene.neil.brown.name>
References: <87mv4qjrez.fsf@notabene.neil.brown.name> <20171018062137.ssdhwkeoy6fdp7yq@kernel.org> <87h8uwj4mz.fsf@notabene.neil.brown.name> <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com> <87376ghyms.fsf@notabene.neil.brown.name> <9759b574-2d3f-de45-0840-c84d9cc10528@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9759b574-2d3f-de45-0840-c84d9cc10528@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19 2017, Artur Paszkiewicz wrote:

> On 10/19/2017 12:36 AM, NeilBrown wrote:
>> On Wed, Oct 18 2017, Artur Paszkiewicz wrote:
>>=20
>>> On 10/18/2017 09:29 AM, NeilBrown wrote:
>>>> On Tue, Oct 17 2017, Shaohua Li wrote:
>>>>
>>>>> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>>>>>
>>>>>> lockdep currently complains about a potential deadlock
>>>>>> with sysfs access taking reconfig_mutex, and that
>>>>>> waiting for a work queue to complete.
>>>>>>
>>>>>> The cause is inappropriate overloading of work-items
>>>>>> on work-queues.
>>>>>>
>>>>>> We currently have two work-queues: md_wq and md_misc_wq.
>>>>>> They service 5 different tasks:
>>>>>>
>>>>>>   mddev->flush_work                       md_wq
>>>>>>   mddev->event_work (for dm-raid)         md_misc_wq
>>>>>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>>>>>   mddev->del_work (md_start_sync)         md_misc_wq
>>>>>>   rdev->del_work                          md_misc_wq
>>>>>>
>>>>>> We need to call flush_workqueue() for md_start_sync and ->event_work
>>>>>> while holding reconfig_mutex, but mustn't hold it when
>>>>>> flushing mddev_delayed_delete or rdev->del_work.
>>>>>>
>>>>>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>>>>>> best to leave that alone.
>>>>>>
>>>>>> So create a new workqueue, md_del_wq, and a new work_struct,
>>>>>> mddev->sync_work, so we can keep two classes of work separate.
>>>>>>
>>>>>> md_del_wq and ->del_work are used only for destroying rdev
>>>>>> and mddev.
>>>>>> md_misc_wq is used for event_work and sync_work.
>>>>>>
>>>>>> Also document the purpose of each flush_workqueue() call.
>>>>>>
>>>>>> This removes the lockdep warning.
>>>>>
>>>>> I had the exactly same patch queued internally,
>>>>
>>>> Cool :-)
>>>>
>>>>>                                                   but the mdadm test =
suite still
>>>>> shows lockdep warnning. I haven't time to check further.
>>>>>
>>>>
>>>> The only other lockdep I've seen later was some ext4 thing, though I
>>>> haven't tried the full test suite.  I might have a look tomorrow.
>>>
>>> I'm also seeing a lockdep warning with or without this patch,
>>> reproducible with:
>>>
>>=20
>> Thanks!
>> Looks like using one workqueue for mddev->del_work and rdev->del_work
>> causes problems.
>> Can you try with this addition please?
>
> It helped for that case but now there is another warning triggered by:
>
> export IMSM_NO_PLATFORM=3D1 # for platforms without IMSM
> mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sd[a-d] -R
> mdadm -C /dev/md/vol0 -l5 -n4 /dev/sd[a-d] -R --assume-clean
> mdadm -If sda
> mdadm -a /dev/md127 /dev/sda
> mdadm -Ss

I tried that ... and mdmon gets a SIGSEGV.
imsm_set_disk() calls get_imsm_disk() and gets a NULL back.
It then passes the NULL to mark_failure() and that dereferences it.
(even worse things happen if "CREATE names=3Dyes" appears in mdadm.conf.
I should fix that).

I added
  if (!disk)
     return;

and ran it in a loop, and got the lockdep warning.

This patch gets rid of it for me.  I need to think about it some more
before I commit to it though.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e1e7e8dc6878..874e4101721f 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5373,8 +5373,11 @@ static int md_alloc(dev_t dev, char *name)
=20
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
 {
=2D	if (create_on_open)
+	if (create_on_open) {
+		/* Wait until bdev->bd_disk is definitely gone (mddev->del_work) */
+		flush_workqueue(md_del_wq);
 		md_alloc(dev, NULL);
+	}
 	return NULL;
 }
=20
@@ -7383,8 +7386,6 @@ static int md_open(struct block_device *bdev, fmode_t=
 mode)
 		 * bd_disk.
 		 */
 		mddev_put(mddev);
=2D		/* Wait until bdev->bd_disk is definitely gone (mddev->del_work) */
=2D		flush_workqueue(md_del_wq);
 		/* Then retry the open from the top */
 		return -ERESTARTSYS;
 	}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnpJyMACgkQOeye3VZi
gbkWhxAAlM9FcYDkGhcDY9KqsL4Ai+MWq1TJCbyKKeUbUonG74tkl/eTFZ6fi9nY
bKFgBkuITA7+ZalNuwrMBpl+DcKJdmEr+aKZyreKdyZtK4cbyguJWb1/SyPm/PB5
47OQWT/YnXx5h6sG/S1F6zxXk8Nb9zR4P6o0eoTethhEJEyceYj37Zu2ciuqMPAH
oByIeGD3u/wyN+BtzYahaA/JAO8l0adiwX0c75gPHCMFUcKs6s6cJv6pY9gkuXns
u5O006p9VQ97XwzKLsquw4OEiRkCPB784Rilcg2yQZtjW1w2uVrEXosrVt9EH+Yf
I4/iL+PbtCKd7VKFdzo/o/UJUwAsMLz5gQfXnEg4/aLRp9q1Oezv45qS9QtrAaVa
heinIBCtGE5JcgQOYyIb0pQtnf9uy/15f3Q5Ft7VDDZqxFekUkcgl8N7oRvRdDLt
550+qhgPEXrW4mSh0h7VWPIfjFVOXzhnkqadPBZAeEz9aKmeXXrm+oG6nN05w2/n
+7nbVbJOd2hDbqlczXUciBQR32cQvki3mZl+1rrteSHvxW5XqZ4j4Z9kzh4Fib8I
u80ZygID7xBVt2mNi3lQJ3ZRaRAnBXecvYtbfNFT3sRroYdfdZ2P9YbD5Qb81/qZ
PTmnhpVjRw+gbDPxEVO1os/015wPrr/KFmDEJlHnzss/BmOIyyk=
=m5hK
-----END PGP SIGNATURE-----
--=-=-=--
