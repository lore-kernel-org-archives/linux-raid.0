From: NeilBrown <neilb@suse.com>
Subject: Re: Why can't I re-add my drive after partition shrink?
Date: Fri, 14 Jul 2017 11:35:46 +1000
Message-ID: <87tw2f2425.fsf@notabene.neil.brown.name>
References: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 13 2017, Ram Ramesh wrote:

> I am trying to shring my mdadm underlying disks/partitions as a way of=20
> reclaiming space after md shrink operation. Here is my md
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
>> [raid4] [raid10]
>> md0 : active raid6 sdb1[6] sdg1[11] sdd1[12] sdf1[8] sde1[9] sdc1[10]
>>       12348030976 blocks super 1.2 level 6, 64k chunk, algorithm 2=20
>> [6/6] [UUUUUU]
>>       bitmap: 2/23 pages [8KB], 65536KB chunk
>>
>> unused devices: <none>
>
> Here is my mdadm detail about /dev/sdb1
>> Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
> I fail, remove and repartition /dev/sdb1 so that new partition table=20
> looks like this. (No change to data obviously)
>>    New partition table:
>>    Number  Start (sector)    End (sector)  Size       Code  Name
>>        1            2048      6442452991   3.0 TiB     FD00  Linux RAID
>>        2      6442452992     11721045134   2.5 TiB     FD00  Linux RAID
>
> Since new /dev/sdb1 is significantly bigger than what mdadm says that it=
=20
> is using, I thought I could simply re-add the drive. However, I get
>> sudo mdadm /dev/md0 --re-add /dev/sdb1
>> ***mdadm: --re-add for /dev/sdb1 to /dev/md0 is not possible***
> Why? What did I miss here? Is it possible to fix this so that I can=20
> repartition other drives and -re-add them without having to go through=20
> full rebuild after each change?

Please report output of "mdadm --examine" on both a device that is active
in the array, and the device that you are trying to add.
Also "mdadm --examine-bitmap" of a device that is active in the array.

NeilBrown

>
> I researched as much as I could on the net and came up with nothing=20
> except some one saying that mdadm keeps something at the end of the disk=
=20
> regardless of what it says about "Used Dev Size." Is it possible to move=
=20
> this info so that I could re-add?
>
> Ramesh
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlloH/QACgkQOeye3VZi
gbny3A//e6O/UYM4CFrKScSC9hym9wGdln2Z1mFr7jcYnGMsr2GjuotHe0AnxeHH
ITcJaUBs55my9nSxHbMNhqWwmB/hcFjClX62/qy3ozkbVgnYxBh2gZT9toPOobkI
3vZdXYkIANkrFd5iDh09p1zN7S3CIzS9OUZ9p2BZEjffUN/urhO9/1y6TMW3uD1g
44c71kgFvdK0LxX3WtH2X0BcTJRlZYaWR9VC8fWj5x9cB+zRSXNX8PTc1yV+rJey
2L6ofqVfdYbGNbQXtPv37vJl5dmXmNtu4gb50XRcnXv9R0rldiFDz4VtpC0u4rz1
IKg4pD+R3vgmSvj5mKKALijOFy21V1bFV2JePKB+nmOCRf6WoLib9P5Gpf3r6V0b
298ws2bY68IKASpuLbM3k4HBFebjtYL7EdGRG7tslf9NoEOxwGa+5/ytL19K8nDL
sx/X4oAS8V/W4BdahYWZiXLBgN5kNZoH/KjwbkQh9UfURWV2wSm4QtFdVqUhJ5Ck
bzwI9iu47T2gFE8Q2z5Rk9nVKe6exuIBKQFyQCf9ByNjzFa2/6uBvHXrBqV4OVvm
nkH3Zs+fZzGGZfyy0MivspC+/CqFbENvfkvN1ELl6I510GEeFEP2BIoRauVAEh99
OkNKYE69hqrwOWga2MbQLBF18oONVphGSAFD18ljcLOi/axs+X4=
=GRL1
-----END PGP SIGNATURE-----
--=-=-=--
