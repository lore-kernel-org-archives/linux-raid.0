From: Jonas Fisher <fisherthepooh@protonmail.com>
Subject: Re: mdadm failed to create internal bitmap
Date: Thu, 11 Jun 2020 04:16:46 +0000
Message-ID: <R7U_r63MZfQnsq_dXezKz6IGonEFCrlHxliAyWVn_FgeR1KZ0JilClvwO7V2h9BQ1od9j9--edK1f-3ntp1TChJNdzEvMJFrDfKVTFBNqg0=@protonmail.com>
References: <46XMI93tZHsxcOEfRj7cEIl272c4YrZUfsGBCr904ogr3xj8zPNdBaJdDWZBnahFIVVpLhDKWE0zc4_6JsBXWMu2mkiK63MUzuM6_ND7CpE=@protonmail.com>
Reply-To: Jonas Fisher <fisherthepooh@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46XMI93tZHsxcOEfRj7cEIl272c4YrZUfsGBCr904ogr3xj8zPNdBaJdDWZBnahFIVVpLhDKWE0zc4_6JsBXWMu2mkiK63MUzuM6_ND7CpE=@protonmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

About this issue, it is because of setting rdev size that

leads to integer overflow while adding internal bitmap.

Besides fixing integer overflow, I was wondering are there

any concerns if we always set the rdev size to the max while doing expansio=
n?

Thanks,


=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90

> Hi all,
>
> I got a raid1 composed with 2 disks
> /dev/sda -- 2T
> /dev/sdb -- 4T
>
> mdadm version is 3.3 and md metadata version is 1.0
>
> At first, I was only using 1T of the each disk,
>
> then I grew the array recently with the command
>
> mdadm --grow /dev/md1 --size=3D1951944704K
>
> I also tried to add the internal bitmap after expansion finished
>
> mdadm --grow /dev/md1 --bitmap=3Dinternal
>
> But I got the following message
>
> mdadm: failed to create internal bitmap - chunksize problem.
>
> I found that Avail Dev Size in superblock examine of two disks
>
> are the same, same as the value I set when I expanded the array (19519447=
04K).
>
> Then I found that in mdadm bitmap chunksize calculation,
>
> in function add_internal_bitmap1 (super1.c)
>
> variable "room" and and "max_bits" seems to be overflowed under this situ=
ation
>
> /dev/sdb3:
> Magic : a92b4efc
> Version : 1.0
> Feature Map : 0x0
> Array UUID : 8d7b8858:e0e93d83:7c87e6e0:bd1628b8
> Name : 1
> Creation Time : Sun Apr 8 09:54:47 2018
> Raid Level : raid1
> Raid Devices : 2
>
> Avail Dev Size : 3903889408 (1861.52 GiB 1998.79 GB)
> Array Size : 1951944704 (1861.52 GiB 1998.79 GB)
> Super Offset : 7810899368 sectors
> Unused Space : before=3D0 sectors, after=3D3907009952 sectors
> State : clean
> Device UUID : 3546fab2:3bfd9a17:39d78059:3d1eb830
>
> Update Time : Sun May 17 10:24:33 2020
> Bad Block Log : 512 entries available at offset -8 sectors
> Checksum : cf552c50 - correct
> Events : 93088
>
> Device Role : Active device 0
> Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D repla=
cing)
>
> /dev/sda3:
> Magic : a92b4efc
> Version : 1.0
> Feature Map : 0x0
> Array UUID : 8d7b8858:e0e93d83:7c87e6e0:bd1628b8
> Name : 1
> Creation Time : Sun Apr 8 09:54:47 2018
> Raid Level : raid1
> Raid Devices : 2
>
> Avail Dev Size : 3903889408 (1861.52 GiB 1998.79 GB)
> Array Size : 1951944704 (1861.52 GiB 1998.79 GB)
> Super Offset : 3903891368 sectors
> Unused Space : before=3D0 sectors, after=3D1952 sectors
> State : clean
> Device UUID : 980038ac:99f4e8c6:39d91851:bdf6ed6d
>
> Update Time : Sun May 17 10:24:33 2020
> Bad Block Log : 512 entries available at offset -8 sectors
> Checksum : c3ce8290 - correct
> Events : 93088
>
> Device Role : Active device 1
> Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D repla=
cing)
>
> I was wondering is this because mdadm set the size of the rdevs in the ar=
ray
>
> before doing expansion (in function Grow_reshape)
>
> that caused the sb->data_size not equals to actual raw device size
>
> and consequently led to bitmap chunksize calculation error
>
> or it is simply a data type issue.
>
> Thanks,
