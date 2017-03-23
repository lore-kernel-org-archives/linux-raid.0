From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: one question about the readonly and readwrite feature
Date: Thu, 23 Mar 2017 18:06:08 +1100
Message-ID: <87poh8a2vz.fsf@notabene.neil.brown.name>
References: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com> <87zigdt1r1.fsf@notabene.neil.brown.name> <58D32AE2.1030303@suse.com> <871stobqvl.fsf@notabene.neil.brown.name> <600b22b5-762e-da9c-0d20-9023de4361b3@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <600b22b5-762e-da9c-0d20-9023de4361b3@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23 2017, Zhilong Liu wrote:

> On 03/23/2017 11:42 AM, NeilBrown wrote:
>> On Thu, Mar 23 2017, Guoqing Jiang wrote:
>>
>>> On 03/23/2017 05:55 AM, NeilBrown wrote:
>>>> On Wed, Mar 22 2017, Zhilong Liu wrote:
>>>>
>>>>> Hi, Neil;
>>>>>
>>>>>      Excuse me, according to read 'mdadm/tests/ToTest', I'm a little
>>>>> confused about "readonly"
>>>>> and "readwrite" feature, and I've no idea how to fix it. Thus I report
>>>>> this question and I'm sorry
>>>>> for this long description email.
>>>>>
>>>>> relevant linux/driver/md commit: 260fa034ef7a4ff8b73068b48ac497edd521=
7491
>>>>>
>>>>>      My question: If the array has been set the MD_CLOSING flag, alth=
ough
>>>>> hasn't removed the sysfs
>>>>> folder because sysfs_remove_group() wasn't invoked, and now, how shou=
ld
>>>>> mdadm continue to
>>>>> control this 'readonly' array?
>>>> MD_CLOSING should only be set for a short period or time to avoid
>>>> certain races.  After the operation that set it completes, it should be
>>>> cleared.
>>>> It looks like this is a bug that was introduced in
>>>> Commit: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
>>>> when MD_STILL_CLOSED was renamed to MD_CLOSING.
>>> I guess it is because we set MD_CLOSING for STOP_ARRAY_RO cmd, then com=
mit
>>> af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag") did below changes:
>>>
>>> @@ -7075,9 +7073,13 @@ static int md_open(struct block_device *bdev,
>>> fmode_t mode)
>>>           if ((err =3D mutex_lock_interruptible(&mddev->open_mutex)))
>>>                   goto out;
>>>
>>> +       if (test_bit(MD_CLOSING, &mddev->flags)) {
>>> +               mutex_unlock(&mddev->open_mutex);
>>> +               return -ENODEV;
>>> +       }
>>>
>>> Maybe we need to differentiate "STOP_ARRAY" and "STOP_ARRAY_RO", or
>>> revert above
>>> changes.
>>>
>> No, your missing the point.
>> What you describe above would change the effect of what MD_CLOSING does.
>> We don't want to change it.  It is good.
>> The problem is that when it has finished doing what it needs to do,
>> we aren't clearing it. That is simply a bug.
>>
>> So something like this is needed.
>
> Sorry again, I have another question in md_set_readonly() of md.c
> Although it has stopped all md writes operations, and I still prefer
> to do set_disk_ro after md_wakeup_thread. refer to following code.

Why?
How do the actions performed by set_disk_ro() interact with the actions
performed by md_wakeup_thread()?

I'm not saying the code shouldn't be changed, just that there needs to
be a clear explanation of the benefit.

NeilBrown


>
> cut the piece of code:
> ... ...
> static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
> {
> ... ...
>          if (mddev->pers) {
>                  __md_stop_writes(mddev);
>
>                  err  =3D -ENXIO;
>                  if (mddev->ro=3D=3D1)
>                          goto out;
>                  mddev->ro =3D 1;
>                  set_disk_ro(mddev->gendisk, 1);         ## --> I prefer=
=20
> to do it after md_wakeup_thread.
>                  clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>                  set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>                  md_wakeup_thread(mddev->thread);     ## --> do=20
> set_disk_ro after this step.
>                  sysfs_notify_dirent_safe(mddev->sysfs_state);
>                  err =3D 0;
>          }
> out:
>          mutex_unlock(&mddev->open_mutex);
>          return err;
> }
>
> Thanks,
> -Zhilong
>> NeilBrown
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 7e168ff1ae90..567aba246497 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6934,6 +6934,7 @@ static int md_ioctl(struct block_device *bdev, fmo=
de_t mode,
>>   	void __user *argp =3D (void __user *)arg;
>>   	struct mddev *mddev =3D NULL;
>>   	int ro;
>> +	bool did_set_md_closing =3D false;
>>=20=20=20
>>   	if (!md_ioctl_valid(cmd))
>>   		return -ENOTTY;
>> @@ -7023,7 +7024,9 @@ static int md_ioctl(struct block_device *bdev, fmo=
de_t mode,
>>   			err =3D -EBUSY;
>>   			goto out;
>>   		}
>> +		WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
>>   		set_bit(MD_CLOSING, &mddev->flags);
>> +		did_set_md_closing =3D true;
>>   		mutex_unlock(&mddev->open_mutex);
>>   		sync_blockdev(bdev);
>>   	}
>> @@ -7216,6 +7219,8 @@ static int md_ioctl(struct block_device *bdev, fmo=
de_t mode,
>>   		mddev->hold_active =3D 0;
>>   	mddev_unlock(mddev);
>>   out:
>> +	if (did_set_md_closing)
>> +		clear_bit(MD_CLOSING, &mddev->flags);
>>   	return err;
>>   }
>>   #ifdef CONFIG_COMPAT

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljTc+AACgkQOeye3VZi
gbm7TA//WdoztyVA4FAza2qFfbkxkxfO1wvOshiiWQB1ljc2PDQ7utinhMDrA1yi
lVlSWxaB0nvGOBOk0u1EygtIpoNbjULO8Jdlb9PMg2FqFw7T2kNJ8npSjER7vgXU
6ST7aP0huy7C52uSKhJy8OkC1pnJMRuojDLYhZ1EkJ5qiWsJCKSk7GJ5sutCHT/v
ddCDB5JtwUC1GgNscyQHFzgieJazwOld0+ilc2Bwmwp0VUPlCDROiYwEldXxD2co
Ts/FB3MvtfQZhQ0F+8BpTvvw5RjIE6bmzseUqQG9l6XerL3ifIB5yfMT5ukDnsA2
B8T0riHTG1wrjOCihIWXCyNITOZhUyEfrAsKaQw961j6PZScNRkB100wMRwIJTkM
YzLH/vyySbF8ydRuU7CSsJi0wDIf9/7+dWFfvzlSLYCivh0/LnuXAMM1bu6tsaQN
L4rG5laBHg98OCza6vd/616rVRoWRrNRNyXvad8wwwkT+rcZj8osqWo1/Vfl+65B
UW8/lArPfUs0evKO/6hIopbPzGdlgojh+9jL1Af3zifVejBhwcRDxE2JfTMdDM+7
70w9ZzdmnMcP8IBcQPFiV1ImXY7eKFEdi4k+qArCAbNTSNkMDDNCFEWX8XPD/0CH
xQnA/8AxKe/trgycyKOT9dxysTf+5zKHRDQ1dXJonhbsWhSpWbg=
=vU1u
-----END PGP SIGNATURE-----
--=-=-=--
