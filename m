From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: ensure sectors is nonzero when change component size
Date: Tue, 17 Oct 2017 11:21:31 +1100
Message-ID: <871sm2lj3o.fsf@notabene.neil.brown.name>
References: <1507797051-18545-1-git-send-email-zlliu@suse.com> <20171012173743.nocrm6ejov3pvhjd@kernel.org> <111b18f3-4db6-bf53-3a9f-15db452192ba@suse.com> <20171013190558.svbyj35i7xtls4wr@kernel.org> <31970279-37d7-e8bc-b37f-955f23434f7f@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <31970279-37d7-e8bc-b37f-955f23434f7f@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16 2017, Zhilong Liu wrote:

> On 10/14/2017 03:05 AM, Shaohua Li wrote:
>> On Fri, Oct 13, 2017 at 10:47:29AM +0800, Zhilong Liu wrote:
>>>
>>> On 10/13/2017 01:37 AM, Shaohua Li wrote:
>>>> On Thu, Oct 12, 2017 at 04:30:51PM +0800, Zhilong Liu wrote:
>>>>> Against the raids which chunk_size is meaningful, the component_size
>>>>> must be >=3D chunk_size when require resize. If "new_size < chunk_siz=
e"
>>>>> has required, the "mddev->pers->resize" will set sectors as '0', and
>>>>> then the raids isn't meaningful any more due to mddev->dev_sectors is
>>>>> '0'.
>>>>>
>>>>> Cc: Neil Brown <neilb@suse.com>
>>>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>>> Not sure about this, does size 0 disk really harm?
>>>>
>>>  From my site, I think changing the component size as '0' should be avo=
ided.
>>> When resize changing required and new_size < current_chunk_size, such as
>>> raid5:
>>>
>>> raid5.c: raid5_resize()
>>> ...
>>> 7727         sectors &=3D ~((sector_t)conf->chunk_sectors - 1);
>>> ...
>>>
>>> 'sectors' got '0'.
>>>
>>> then:
>>> ...
>>> 7743         mddev->dev_sectors =3D sectors;
>>> ...
>>>
>>> the dev_sectors(the component size) got '0'.
>>> same scenario happens in raid10.
>>>
>>> So, it's really not meaningful if changing the raid component_size to '=
0',
>>> md
>>> should give this scenario a test, otherwise, it's a trouble thing to re=
store
>>> after
>>> doing such invalid re-size.
>> Yes, I understand how it could be 0. My question is what's wrong with a =
size-0
>> disk? For example, if you don't setup file for a loop block device, its =
size is
>> 0.
> I'm sorry I'm not very clear with your question, I try to describe more=20
> on this scenario.
> the 0-component_size isn't a 0-size disk. resize doesn't change=20
> raid_member_disk size
> to 0.
>
> For example: mdadm -CR /dev/md0 -b internal -l5 -n2 -x1 /dev/sd[b-d]
> if set the component_size to 0, how would the 'internal bitmap' be? And=20
> if I want to make
> a file-system on this raid, how would it be? it's out of my control.
>
> I would continue to provide infos for you if any questions needs further=
=20
> discussion.
>
> Hope this information is useful for you.
> Here is piece of dmesg for the following steps:
> 1. mdadm -CR /dev/md0 -b internal -l5 -n2 -x1 /dev/sd[b-d]
> 2. mdadm -G /dev/md0 --size 511
> 3. mkfs.ext3 /dev/md0
> the mkfs would be stuck all time, cannot kill the mkfs process and have to
> force to reboot, then lots of same call trace prints in dmesg.

I think the cause of this problem is that raid5_size() treats zero
values for 'sectors' and 'raid_disks' as "don't change".

So setting the size to zero will change mddev->dev_sectors but not
mddev->array_size.
This causes internal confusion.
Maybe we should use a different number of "don't change" ??

This could affect any of the ->size() functions.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnlTQ0ACgkQOeye3VZi
gbm5vA//SPUG0Y5G2+ZYVt4usGxc6rKI6cQ3ewp6yarN09HUyozCyMvalbFtTMP+
Waf6qxT2tBYFgsKb0pLfWO2iwL+DghjWECYdZdaVy9+ais1ZqvBYA6zkycLxZqI0
drbykZt33xK2v5fFaCbtHuDX+XeVCvcWhOCMFpD0uN3gnMhsb27N8DueFM/xGMgo
Cl7vI+EnTqj5xw3ppLBRYRmP6eePZQugyUA2uwdwSaLzrFlhloDvDN9gsjRspav1
YoQJwIchQ1b1wP2tyFyy3hsJTaBBZ6SQxdvIyhinvLn3yqzAxAzC/+78m1/r6dzV
fKOMe9Uly8wUzgz1Sjjl0NDsoxZlBlWtY05kvFkUxQMwc2LFsJGHQ74vrchuC3H1
n16SKdgiOrnARGPj9YBrX15yqvif+L2kS8v+9GsiWsPHSBlM0rKIyGoCfyh2h1f2
lfBEEns4ITTdfQtM0+ysN0S5Es2mD/UBmwYowsaDrCX3PHZtz+KRHaIAvxXLRxvi
EsM6wKsZ0nJHiBOL7WCasQPcfhKZMgaQG5qruGT8MGwOVb/IzOcP8bwR38hIfFtJ
DdToYgEKexbb0riQBJKVlwFc0omzZFMWvj4YcDSWkCm2juTP2RhDvHe6Q7HlWqKi
5U2Hgm+UgtsLfq/1bEdkyuDvT0eSu6GGe8BPCQ26SZZaTELkwmw=
=5q0w
-----END PGP SIGNATURE-----
--=-=-=--
