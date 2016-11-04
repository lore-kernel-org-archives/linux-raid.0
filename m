From: NeilBrown <neilb@suse.com>
Subject: Re: Resync issue in RAID1
Date: Fri, 04 Nov 2016 14:33:48 +1100
Message-ID: <87pombq5pf.fsf@notabene.neil.brown.name>
References: <CAF9xHmRCKzBXE5_tdqNY9BJJn7LyC8bOv8OaFXpxc1BvGUTCeQ@mail.gmail.com> <8760odt93j.fsf@notabene.neil.brown.name> <CAF9xHmQfUDOYFNa1uehqsz=arx-x24DuavX1sdBY313mdt0GEw@mail.gmail.com> <87r371rp0d.fsf@notabene.neil.brown.name> <CAF9xHmTGFXvQnKX5ZK5+ino4977SpHxMffCc0YPMxJGEhwGLuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF9xHmTGFXvQnKX5ZK5+ino4977SpHxMffCc0YPMxJGEhwGLuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: V <viswesh.vichu@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Oct 28 2016, V wrote:

> Is there any reason, why this happens in the resync flow. Normally the
> upper layer driver tries to align with device block size for the
> request. So could there be an issue in this path ?


This happens in the resync flow because there is a bug which lets the
number "3" escape and be used incorrectly as a device address.
The same bug wouldn't affect data from any upper level driver.

NeilBrown


>
> Thanks,
> V
>
> On Thu, Oct 27, 2016 at 11:01 PM, NeilBrown <neilb@suse.com> wrote:
>> On Fri, Oct 28 2016, V wrote:
>>
>>> Hi Neil,
>>>
>>> Thanks for the response. But during this phase, why is the scsi driver
>>> complaining about bad block number ?
>>>
>>> Oct 18 03:52:56  kernel: [  52.869378] sd 0:0:0:0: [sda] Bad block
>>> number requested
>>
>> Because md is asking to read blocks are offsets which are not a multiple
>> of 8 sectors.
>>
>> NeilBrown
>>
>>
>>> Oct 18 03:52:56  kernel: [  52.869414] sd 0:0:0:0: [sda] Bad block
>>> number requested
>>> Oct 18 03:52:56  kernel: [  52.869436] sd 0:0:0:0: [sda] Bad block
>>> number requested
>>> Oct 18 03:52:56  kernel: [  52.869465] sd 0:0:0:0: [sda] Bad block
>>> number requested
>>> Oct 18 03:52:56  kernel: [  52.869503] sd 0:0:1:0: [sdb] Bad block
>>> number requested
>>>
>>> Thanks,
>>> V
>>>
>>> On Thu, Oct 27, 2016 at 9:01 PM, NeilBrown <neilb@suse.com> wrote:
>>>> On Sat, Oct 22 2016, V wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> I am facing an issue during RAID1 resync. I have an ubuntu
>>>>> 4.4.0-31-generic running with raid1 configured with 2 disks as active
>>>>> and 2 as spares. On the first powercycle, after installing RAID, i see
>>>>> the following messages in kern.log
>>>>>
>>>>>
>>>>> My disks are configured with 4K sector size (both logical and
>>>>> physical) (sda and sdb are active disks for this raid)
>>>>>
>>>>>
>>>>> ===========
>>>>> Oct 18 03:52:56  kernel: [   52.869113] md: using 128k window, over a
>>>>> total of 51167104k.
>>>>> Oct 18 03:52:56  kernel: [   52.869114] md: resuming resync of md2 from checkpoint.
>>>>
>>>> This line (above) combined with ...
>>>>
>>>>> Oct 18 03:52:56  kernel: [   52.869536] md/raid1:md2: sda: unrecoverable I/O read error for block 3
>>>>
>>>> this line suggests that when you shut down, md had already started a
>>>> resync, and it had checkpointed at block '3'.
>>>>
>>>> The subsequent error are:
>>>>
>>>>> Oct 18 03:52:56  kernel: [   52.869692] md/raid1:md2: sda: unrecoverable I/O read error for block 131
>>>>> Oct 18 03:52:56  kernel: [   52.869837] md/raid1:md2: sda: unrecoverable I/O read error for block 259
>>>>> Oct 18 03:52:56  kernel: [   52.870022] md/raid1:md2: sda: unrecoverable I/O read error for block 387
>>>>
>>>> which are every 128 blocks (aka sectors) from '3'.
>>>> I know what caused that.  The patch below will stop it happening again.
>>>>
>>>> You might be able get your array working again by stopping it
>>>> and assembling with --update=resync.
>>>> That will reset the checkpoint to 0.
>>>>
>>>> NeilBrown
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 2cf0e1c00b9a..aa2ca23463f4 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -8099,7 +8099,8 @@ void md_do_sync(struct md_thread *thread)
>>>>             mddev->curr_resync > 2) {
>>>>                 if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
>>>>                         if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>>>> -                               if (mddev->curr_resync >= mddev->recovery_cp) {
>>>> +                               if (mddev->curr_resync >= mddev->recovery_cp &&
>>>> +                                   mddev->curr_resync > 3) {
>>>>                                         printk(KERN_INFO
>>>>                                                "md: checkpointing %s of %s.\n",
>>>>                                                desc, mdname(mddev));
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYHAGeAAoJEDnsnt1WYoG5Rx4P/31NiqSBzB/9m5t0K4XL75yE
5cLsXNQP/vUYbXaixS8FE+Yh5cAR1gRr2hS+WCPjprovGNN1AoWXXKA8H8Eab0C5
WokDwG2DY5U2aeAWInM3KnTNkVRg6QQli3ycClTEXGFr7Tr41vo20IkF26NCJUOq
1MgswfTolvxG66PrGghHcK4BIhhNODBksf1REumu5cwDfKx0qbvV4g1sdJbls/RQ
AVLZlLW5+K2sPsM/eHWTdQGXgdWI0gl6hUmh6tNnLw01iqpOTlEOke7iQs28eKvR
hoYn44VpM3qByCp3s8ym3VcQhMoKHGrV4BEEZo5FrgCWD6WoTTuVpYVU5n6rZWd8
651OVmti1DRF29F5OfCxNrcmEHJdmy3nAPTx1t7h7aYNKUzJyP0Ao/c7olQeN/qY
4uB9hNXwYlhdxJu8Xq4M9dmXgvj+ZMWSL2pHQJs0UMluufw41+AvhJRDEnkcMwRn
ivVY9Lc7FE9qQLBc+ZGZFM46INlpoWUmJgenUghE1jrbol6KxGtHCt5m5nBFjMcl
xCj7DV0HwK18GYBNCtDvwI57YlNzvawEBOIsrLrmLzzSQ1t5DJ/GBxT/qvfwdwPC
9u3Yn358PTSk6pkUy61gnUskQUhUK7uzoP4S/5PFHiDV//SWk1JYtOfSesKNuosZ
5nhjeNM9SLmuuOv3wThu
=KL61
-----END PGP SIGNATURE-----
--=-=-=--
