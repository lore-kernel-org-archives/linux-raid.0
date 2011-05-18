From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 13:42:04 -0700 (PDT)
Message-ID: <811592.40689.qm@web65112.mail.ac2.yahoo.com>
References: <4DD41713.5070407@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD41713.5070407@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

--- On Thu, 19/5/11, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> From: Stan Hoeppner <stan@hardwarefreak.com>
> Subject: Re: Best way to create RAID-6 for swap partition - existing =
one failed
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
> Date: Thursday, 19 May, 2011, 6:59
[...]
> Forget using a partition.=A0 Simply use a swap
> file.=A0 This example creates
> a 1GB swap file in the / filesystem.=A0 You can locate
> it on any
> filesystem you wish.
>=20
> # swappoff -a
> # dd if=3D/dev/zero of=3D/swapfile1 bs=3D1024 count=3D1048576
> # mkswap /swapfile1
> # swapon /swapfile1
> # vi /etc/fstab
> Add:
> /swapfile1 swap swap defaults 0 0
>=20
> and remove your old entry for the failed swap partition.
>=20
> There is little performance difference between swap files
> and swap
> partitions with modern kernels.=A0 The kernel will map
> the disk location
> of the swap file and perform direct disk access, bypassing
> the
> filesystem and buffer cache.
>=20
> --=20
> Stan
>=20

I just checked the man page for mkswap, it still recommends using a par=
tition.

"WARNING
       The swap header does not touch the first block.  A boot loader o=
r  disk label can be there, but it is not a recommended setup.  The rec=
ommended setup is to use a separate partition for a Linux swap area."

I am curious to know the tradeoffs between having a file and using a pa=
rtition for swap.  While it may not make much difference in my current =
situation, it might to others.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
