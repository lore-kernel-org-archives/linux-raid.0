From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] [RFC] md raid10: use rcu to avoid NULL dereference in raid10d()
Date: Fri, 02 Feb 2018 09:22:56 +1100
Message-ID: <87o9l82vun.fsf@notabene.neil.brown.name>
References: <20171117200326.xqchu3r3elzvkg7z@kernel.org> <45cfa4a5-fe04-8b02-531d-c642ad6e7b4c@huawei.com> <7b5cb7fa-2dfa-0fab-752d-16cdfedffbca@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b5cb7fa-2dfa-0fab-752d-16cdfedffbca@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: yuyufen <yuyufen@huawei.com>, colyli@suse.de, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 01 2018, yuyufen wrote:

> hi.
>
>> On Thu, Oct 19, 2017 at 10:06:56AM +1100, Neil Brown wrote:
>>> On Wed, Oct 18 2017, NeilBrown wrote:
>>>
>>>> On Wed, Oct 18 2017, Coly Li wrote:
>>>>
>>>>> We have a bug report about NULL dereference in md raid10 code. The
>>>>> operations are,
>>>>>   - Create a raid10 device
>>>>>   - add a spare disk
>>>>>   - disconnect one of the online disks from the raid10 device
>>>>>   - wait to the recovery happens on the spare disk
>>>>>   - remove the spare disk which is recovering
>>>>> And sometimes a kernel oops of NULL dereference in md raid10 module c=
an
>>>>> be observed, and crash tool reports the following information:
>>>>>> (gdb) list *(raid10d+0xad6)
>>>>>> 0x5de6 is in raid10d (../drivers/md/raid10.c:2300).
>>>>>> 2295		 * the latter is free to free wbio2.
>>>>>> 2296		 */
>>>>>> 2297		if (wbio2 && !wbio2->bi_end_io)
>>>>>> 2298			wbio2 =3D NULL;
>>>>>> 2299		if (wbio->bi_end_io) {
>>>>>> 2300			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>>>>>> 2301			md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
>>>>>> 2302			generic_make_request(wbio);
>>>>>> 2303		}
>>>>>> 2304		if (wbio2) {
>>>>> At line 2300, conf->mirrors[d].rdev is NULL, this causes a NULL point=
er
>>>>> dereference to conf->mirrors[d].rdev->nr_pending. After reading previ=
ous
>>>>> raid10 patches, I find conf->mirrors[d].rdev can be NULL at any point
>>>>> unless,
>>>>>   - a counted reference is held
>>>>>   - ->reconfig_mutex is held, or
>>>>>   - rcu_read_lock() is held
>
> We have the same bug report about NULL dereference in md raid10 code.
> operations are:
>
>      - create raid10, including 4 disk and 2 spare disk
>          mdadm -C /dev/md1 -l 10 -n 4  /dev/sda /dev/sdb /dev/sdc=20
> /dev/sdd -x 2 /dev/sde /dev/sdf -R
>      - block and offline a disk in raid10
>      - hot remove a disk by
>          mdadm --manage /dev/md1 -r sdX
>      - add disk
>          mdadm --manage /dev/md1 -r sdX
>
> (gdb) l *(0xffffffff815daafd)
> 0xffffffff815daafd is in rdev_clear_badblocks (drivers/md/md.c:8688).
> 8683                             int is_new)
> 8684    {
> 8685            if (is_new)
> 8686                    s +=3D rdev->new_data_offset;
> 8687            else
> 8688                    s +=3D rdev->data_offset; <=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 8689            return md_clear_badblocks(&rdev->badblocks,
> 8690                                      s, sectors);
> 8691    }
> 8692    EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
>
> Call Trace and crash tools show it is triggered as following:
> raid10d() =3D> handle_write_completed() =3D> rdev_clear_badblocks()
>
>>>> There is one other condition: MD_RECOVERY_RUNNING is set (without
>>>> MD_RECOVERY_DONE).
>>>> mirrors[d].rdev is only set to NULL by ->hot_remove_disk() which is on=
ly
>>>> called from remove_and_add_spares(), and that is never called while
>>>> resync/recovery/reshape is happening.
>>>> So there is no need for RCU protection here.
>>>>
>>>> Only ... remove_and_add_spares() *can* sometimes be called during
>>>> resync -
>>>> Commit: 8430e7e0af9a ("md: disconnect device from personality before t=
rying to remove it.")
>>>> added a called to remove_and_add_spares() when "remove" is written to
>>>> the device/state attribute.  That was wrong.
>>>> This:
>>>>
>>>>   	} else if (cmd_match(buf, "remove")) {
>>>> -		if (rdev->mddev->pers) {
>>>> +		if (rdev->mddev->pers &&
>>>> +		    !test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
>>>>   			clear_bit(Blocked, &rdev->flags);
>>>>   			remove_and_add_spares(rdev->mddev, rdev);
>>>>
>>>> should fix it.
>>> Actually, that doesn't even compile :-(
>>>
>>> I think this is a better fix.
>>> Thanks,
>>> NeilBrown
>>>
>>> From: NeilBrown <neilb@suse.com>
>>> Date: Thu, 19 Oct 2017 09:58:19 +1100
>>> Subject: [PATCH] md: only allow remove_and_add_spares() when no sync_th=
read running.
>>>
>>> The locking protocols in md assume that a device will
>>> never be removed from an array during resync/recovery/reshape.
>>> When that isn't happening, rcu or reconfig_mutex is needed
>>> to protect an rdev pointer while taking a refcount.  When
>>> it is happening, that protection isn't needed.
>>>
>>> Unfortuantely there is a case were remove_and_add_spares() is
>>> called when recovery might be happening: when "remove" is
>>> written to the device/state sysfs attribute.
>>>
>>> This call is an optimization and not essential so it doesn't
>>> matter if it fails.
>>> So change remove_and_add_spares() to abort early if
>>> resync/recovery/reshape is happening.
>>>
>>> As this can result in a NULL dereference, the fix is suitable
>>> for -stable.
>>>
>>> Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>>> Fixes: 8430e7e0af9a ("md: disconnect device from personality before try=
ing to remove it.")
>>> Cc: stable@ver.kernel.org (v4.8+)
>>> Signed-off-by: NeilBrown <neilb@suse.com>
>>> ---
>>>   drivers/md/md.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index b3192943de7d..01eac0dbca98 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -8563,6 +8563,10 @@ static int remove_and_add_spares(struct mddev *m=
ddev,
>>>   	int removed =3D 0;
>>>   	bool remove_some =3D false;
>> Sorry, I missed this patch.
>>
>> I'd really appreciate if you can add the locking protocol into comments =
here,
>> digging changelog is much painful.
>>    > +	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>>> +		/* Mustn't remove devices when resync thread is running */
>>> +		return 0;
>>> +
>> This will bypass hotadd too, is it what we want?
>
> After applying this patch, there is no more Oops, but the number of=20
> disks will become less and less, which is not expected.

Please explain what you mean by "the number of disks will become less
and less"??  What is the sequence of events?


> I think it's caused by bypassing of hotadd. Can we just add spare disk=20
> without removing disk?
>
> Any suggestions for this fix or any progress on this patch?

I had forgotten about this patch and will resend.  However I think the
only change needs is adding some comments.  I still think the code is
correct.

Thanks,
NeilBrown

>
> Thanks a lot,
> Yufen Yu
>
>>
>> Thanks,
>> Shaohua
>>>   	rdev_for_each(rdev, mddev) {
>>>   		if ((this =3D=3D NULL || rdev =3D=3D this) &&
>>>   		    rdev->raid_disk >=3D 0 &&
>>> --=20
>>> 2.14.0.rc0.dirty
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> .
>>
>>
>>
>> .
>>
> .

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpzk0AACgkQOeye3VZi
gbmY3g/9EVxhcNmZsiQSywDGik4U38bzj5NuhGdiMANKCF0WqEIb63YOHCpRKTFa
gCYlS0UPFjC9NZIhpwh+PSroYCg+NiGp5HI9hFrfBZUx13scNkamvHqoNgqQcsnD
aAH984yeWLrSMA1yobIhT+oCskRiMb9Iof2oWj7yufLOH7MCT9pdgqIk5lsnaCWs
JM0JDj7eIG5hlfgNr6U5zfh5bwEWHvw9igfGNJOrhr/6qBZGV1Dks26ttb9PQDDz
iVq2FhdG+AZtiOUjUbondnH38L9FNeu+ciTa20E0DFK1lhNcRwRPz4yEbdXwOoYE
RbsOjX6K6o6Cp0oCCERW6xZABZIv6YjKsY3pSfmqLBltb8VNC7EvQsba5CiiIjgS
sC3JeaKLWuHd5Ou2PslitmaM9c5rVHBEsB4gG3m3UDM9eZVNNKQTrMMO/DsCLG9y
k3i9W8g0nUVH3cT82tTjsvytdm+BuEWQEUEYXKV4aQcXU8Hcp6QUqdDOdPdkmCKo
oet24XbWc1nGnSCuaRJTSXor84qohB1MeHxK/5mNiZNFeVhpiS6LK9M9EBAZmHDs
k2WEgrpAFMu+oo+pBQapRXJV8pP/4j9+h6wndJW8OTTtLhSko8QEo2bEQQW6iKlX
rMGd3XMGcPTWH+i3ny7W/hzxDQsZcqo4dtWQT0JKnbVeHUxcrnc=
=Ytb9
-----END PGP SIGNATURE-----
--=-=-=--
