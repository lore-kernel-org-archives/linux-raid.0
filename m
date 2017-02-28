From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component devices
Date: Wed, 01 Mar 2017 07:29:28 +1100
Message-ID: <87mvd6oy8n.fsf@notabene.neil.brown.name>
References: <20170224040816.41f2f372.ian_bruce@mail.ru> <87y3wsp47n.fsf@notabene.neil.brown.name> <20170228022513.2cf5445a.ian_bruce@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170228022513.2cf5445a.ian_bruce@mail.ru>
Sender: linux-raid-owner@vger.kernel.org
To: ian_bruce@mail.ru
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 28 2017, ian_bruce@mail.ru wrote:

> On Mon, 27 Feb 2017 16:55:56 +1100
> NeilBrown <neilb@suse.com> wrote:
>
>>> When assembling non-metadata arrays ("mdadm --build"), the in-kernel
>>> superblock apparently defaults to the MD-RAID v0.90 type. This
>>> imposes a maximum of 27 component block devices, presumably as well
>>> as limits on device size.
>>>
>>> mdadm does not allow you to override this default, by specifying the
>>> v1.2 superblock. It is not clear whether mdadm tells the kernel to
>>> use the v0.90 superblock, or the kernel assumes this by itself. One
>>> or other of them should be fixed; there does not appear to be any
>>> reason why the v1.2 superblock should not be the default in this
>>> case.
>>=20
>> Can you see if this change improves the behavior for you?
>
> Unfortunately, I'm not set up for kernel compilation at the moment. But
> here is my test case; it shouldn't be any harder to reproduce than this,
> on extremely ordinary hardware (=3D no actual disk RAID array):
>
>
> # truncate -s 64M img64m.{00..31}   # requires no space on ext4,
> #                                   # because sparse files are created
> #=20
> # ls img64m.*
> img64m.00  img64m.04  img64m.08  img64m.12  img64m.16  img64m.20  img64m.=
24  img64m.28
> img64m.01  img64m.05  img64m.09  img64m.13  img64m.17  img64m.21  img64m.=
25  img64m.29
> img64m.02  img64m.06  img64m.10  img64m.14  img64m.18  img64m.22  img64m.=
26  img64m.30
> img64m.03  img64m.07  img64m.11  img64m.15  img64m.19  img64m.23  img64m.=
27  img64m.31
> #=20
> # RAID=3D$(for x in img64m.* ; do losetup --show -f $x ; done)
> #=20
> # echo $RAID
> /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 /dev/lo=
op6 /dev/loop7
> /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11 /dev/loop12 /dev/loop13 /de=
v/loop14 /dev/loop15
> /dev/loop16 /dev/loop17 /dev/loop18 /dev/loop19 /dev/loop20 /dev/loop21 /=
dev/loop22 /dev/loop23
> /dev/loop24 /dev/loop25 /dev/loop26 /dev/loop27 /dev/loop28 /dev/loop29 /=
dev/loop30 /dev/loop31
> #=20
> # mdadm --build /dev/md/md-test --level=3Dlinear --raid-devices=3D32 $RAID
> mdadm: ADD_NEW_DISK failed for /dev/loop27: Device or resource busy
> #=20

Thanks.  That makes it easy.
Test works with my patch applied.
....

>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index ba485dcf1064..e0ac7f5a8e68 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6464,9 +6464,8 @@ static int set_array_info(struct mddev *mddev, mdu=
_array_info_t *info)
>>  	mddev->layout        =3D info->layout;
>>  	mddev->chunk_sectors =3D info->chunk_size >> 9;
>>=20=20
>> -	mddev->max_disks     =3D MD_SB_DISKS;
>> -
>>  	if (mddev->persistent) {
>> +		mddev->max_disks     =3D MD_SB_DISKS;
>>  		mddev->flags         =3D 0;
>>  		mddev->sb_flags         =3D 0;
>>  	}
>
> What value does mddev->max_disks get in the opposite case,
> (!mddev->persistent) ?

Default value is zero, which causes no limit to be imposed.

>
> I note this comment from the top of the function:
>
>     * set_array_info is used two different ways
>     * The original usage is when creating a new array.
>     * In this usage, raid_disks is > 0 and it together with
>     *  level, size, not_persistent,layout,chunksize determine the
>     *  shape of the array.
>     *  This will always create an array with a type-0.90.0 superblock.

Unfortunately you cannot always trust comments.  They are more like hints.

>
> http://lxr.free-electrons.com/source/drivers/md/md.c#L6410
>
> Surely there is an equivalent function which creates arrays with a
> type-1 superblock?

Not really.  type-1 superblock are created from userspace by mdadm.
mdadm then tells the kernel "here are some devices that form an array".
md reads the devices, finds the type-1 metadata, and proceeds.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli13agACgkQOeye3VZi
gbn0mw//VKQFNOcM4RQxFY6p3qG/EnyzASRHGUyhKr1e9OfErwCmDoiY1FWab+UU
YPCnGteUNwqxUCKPij0E6TePdVxgG8WM6zNiKVrKDKpWZvxObBnwDkAR4P0yNptG
honRa1vl8D6pS4y+emTwD9m+WjHX8/ay+auoF2O1QETyR+kAx/KzMuVCTborj2gn
CmVOACxbHW2yRZ6nnNzHnz2u3YsVIbP7XIv6w21HSNKS1QrQt+1HPgyiWU32Cu5H
uFbnrygO6ruNfP4ZYg3z1ZDjUEiYaMP73On+ia8eeGHoBp2BsLXQ4JRq61CiSo8D
RDAXcBcxyxfCnhSA2hjFmfjtPUTzfom0JfX5O6iZqdVNGhh9zVIWNaIifRQtwzXY
BKC+Q90u4wUPsSJB+cg2wJv3FTFFrXeFX8lBFO6oBm6uuXi/FD2ZkEGWczt/Z3vW
YqN9V+98O2Vkjx3ExrPCLcQ/vkcr9yCaV0Y+0a9DOWBnwA06uptVcRdnZWeqnvqu
GjI4JcbOL9RHnrZbQLCtkuEauZCT8lcqZWHonbTJ1sK8YckwO/6xoL0cP8PpVFrS
ijXQYXApfatPEbSVhIixSNKFNRrQlvOM4GwlEWu3MixcJFV9srG2KMvmydWjNn9v
ErLdfjHMELojIgzRf8lO7GvdzH2RAzNdUHkTOwZQcZlnudU9znk=
=QcPq
-----END PGP SIGNATURE-----
--=-=-=--
