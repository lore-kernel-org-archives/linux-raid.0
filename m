From: NeilBrown <neilb@suse.com>
Subject: Re: Enable skip_copy can cause data integrity issue in some storage stack
Date: Thu, 07 Sep 2017 11:11:24 +1000
Message-ID: <87r2vjb9dv.fsf@notabene.neil.brown.name>
References: <73ed28991837a9884824309137f1621c@synology.com> <20170906155739.exyap2fythtukpxy@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170906155739.exyap2fythtukpxy@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, alexwu <alexwu@synology.com>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 06 2017, Shaohua Li wrote:

> On Fri, Sep 01, 2017 at 03:26:41PM +0800, alexwu wrote:
>> Hi,
>>=20
>> Recently a data integrity issue about skip_copy was found. We are able
>> to reproduce it and found the root cause. This data integrity issue
>> might happen if there are other layers between file system and raid5.
>>=20
>> [How to Reproduce]
>>=20
>> 1. Create a raid5 named md0 first (with skip_copy enable), and wait md0
>>    resync done which ensures that all data and parity are synchronized
>> 2. Use lvm tools to create a logical volume named lv-md0 over md0
>> 3. Format an ext4 file system on lv-md0 and mount on /mnt
>> 4. Do some db operations (e.g. sqlite insert) to write data through /mnt
>> 5. When those db operations finished, we do the following command
>>    "echo check > /sys/block/md0/md/sync_action" to check mismatch_cnt,
>>    it is very likely that we got mismatch_cnt !=3D 0 when check finished
>>=20
>> [Root Cause]
>>=20
>> After tracing code and more experiments, it is more proper to say that
>> it's a problem about backing_dev_info (bdi) instead of a bug about
>> skip_copy.
>>=20
>> We notice that:
>>    1. skip_copy counts on BDI_CAP_STABLE_WRITES to ensure that bio's page
>>       will not be modified before raid5 completes I/O. Thus we can skip =
copy
>>       page from bio to stripe cache
>>    2. The ext4 file system will call wait_for_stable_page() to ask wheth=
er
>>       the mapped bdi requires stable writes
>>=20
>> Data integrity happens because:
>>    1. When raid5 enable skip_copy, it will only set it's own bdi required
>>       BDI_CAP_STABLE_WRITES, but this information will not propagate to
>>       other bdi between file system and md
>>    2. When ext4 file system check stable writes requirement by calling
>>       wait_for_stable_page(), it can only see the underlying bdi's
>> capability
>>       and cannot see all related bdi
>>=20
>> Thus, skip_copy works fine if we format file system directly on md.
>> But data integrity issue happens if there are some other block layers (e=
.g.
>> dm)
>> between file system and md.
>>=20
>> [Result]
>>=20
>> We do more tests on different storage stacks, here are the results.
>>=20
>> The following settings can pass the test thousand times:
>>    1. raid5 with skip_copy enable + ext4
>>    2. raid5 with skip_copy disable + ext4
>>    3. raid5 with skip_copy disable + lvm + ext4
>>=20
>> The following setting will fail the test in 10 rounds:
>>    1. raid5 with skip_copy enable + lvm + ext4
>>=20
>> I think the solution might be let all bdi can communicate through differ=
ent
>> block layers,
>> then we can pass BDI_CAP_STABLE_WRITES information if we enable skip_cop=
y.
>> But the current bdi structure is not allowed us to do that.
>>=20
>> What would you suggest to do if we want to make skip_copy more reliable ?
>
> Very interesting problem. Looks this isn't raid5 specific. stacked device=
 with
> block integrity enabled could expose the same issue.
>
> I'm cc Jens and Neil to check if they have good idea. Basically the probl=
em is
> for stacked disk, the under layer disk has BDI_CAP_STABLE_WRITES enabled,=
 but
> upper layer doesn't enable it. The under layer disk could be a raid5 with
> skip_copy enabled or could be any disk with block integrity enabled (whic=
h will
> enable BDI_CAP_STABLE_WRITES). Currently we don't propagate the flag to u=
pper
> layer disk.
>
> A solution is blk_set_stacking_limits propagate the flag at queue setup, =
we
> then don't allow the flag changing in runtime later. The raid5 skip_copy
> interface changes the flag in runtime which probably isn't safe.
>
> Thanks,
> Shaohua

It has always been messy to handle dependencies from the bottom of the
stack affecting things closer to the filesystem.
We used to have issues with alignments and request sizes, and got rid of
those problems by requiring all devices to accept all bio sizes, and
providing support for them to split as necessary.
This is a similar sort of problem, but also quite different.

It is different because the STABLE_WRITES requirement doesn't affect the
sort of bio that is passed down, but instead affect the way it is waited
for.

I have thought a few times that it would be useful if the "bd_claim"
functionality included a callback so the claimed device could notify the
claimer that things had changed.
Then raid5 could notice that it has been claimed, and call the callback
when it changes BDI_CAP_STABLE_WRITES.  If the claimer is a stacked
device, it can re-run blk_set_stacking_limits and call its own claimer.

There are probably some interesting locking issues around this but, to
me, it seems like the most likely path to a robust solution.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmwnL4ACgkQOeye3VZi
gblVcg/+LAszmyWn2Xij2gqdEBN7O+pKYuW7nOBS0354H+DirW/YoD/OE4OujYc8
o6l67eNNje1/e6xO1jNUnMc+BZWat0pizWNg5anKMRrzJZepoGhy4rXX0QqXI6MH
2zZneCjVEhNvcJKtn7+ysvZVooSwaiyL8fa9OrlfUtY15pvxG1H5RZzFRwjbCgw2
S2c1COAQRjmUvzQ6M7kc7Aai2nbwXt7gbE6bfoF+P4t67bxFmtkFEJEqyp9w4b98
8EnxOAp5c6J6+d3FuEMdxg+/fXUdIN65+9sYLQONcF9qmwpUoHbCsNXmwJ1/0aT0
DM7JNBUvEweHFjF2c1++fM/TqwLvKxIcToCSPJfA2UI7HHVZAS3cNpTT/7Xm/XxT
Dw4Uxc+ulcNbP/n2V1OTdIsOHQdg80tqsurmMwaZ4VunG9qDc444FtkFtcIfu+Ut
JgHbUi4yYXQ1U8OtZvi0C6hUXiBZ0ExoD0pkPfH92iGg8wET3PKvWB2TGVj54I8P
5GWQkq+E8Utxpf2gK9EvJUOv+H82NCiKEX5d3+YCHlPyopYfOpuK+DIK4ar16Mw7
eex9rWNorzdTQCShhHcxvZu1KzE6jXKdmOW1HKI5Yv+PmsmAsyfna+tiWM1jkdPC
KesuS5GavuWFwOaYgnbTV5QSdVVXs4PuMveJ9AzZhXfB3LUoXbE=
=oxGr
-----END PGP SIGNATURE-----
--=-=-=--
