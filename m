From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 13:13:15 -0700 (PDT)
Message-ID: <986071.90796.qm@web65108.mail.ac2.yahoo.com>
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
> On 5/16/2011 4:41 PM, Gavin Flower
> wrote:
>=20
> > Motivation, existing RAID-6 swap partition
> failed.=A0 I am thinking I should recreate it in a new
> format, as currently it is 'Version : 0.90', rather than
> simply rebuild it.
> <snip>
>=20
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

Thanks.

Interesting!

(Reminds me of when I first got into Linux.  Then you could have any si=
ze swap file up to 128 MB, and have up to 8 swap files, for a maximum o=
f 1 GB. I then had about 64 MB of RAM - now I have 8 GB of RAM. Also, s=
wap partitions were recommended.  When the 2.4 kernel first came out, i=
t was said to be faster if you had at least 16 MB.)

I read up and could not see any benefit in changing, so I ended up 'sim=
ply' reassembling the partition.

The 2 things I had thought of altering, were the version of the super b=
lock and the chunk size. With the amount of RAM I have, performance is =
not normally an issue, I was thinking of reliability.  The badblocks ru=
n did not reveal any problems, nor did checking the smart diagnostics i=
n detail reveal anything significant.  I think it was some kind of kern=
el error, transient anyhow.

SUGGESTION:
Could we please have some explanation of the benefits and tradeoffs bet=
ween the different values of things like chunk size and super block ver=
sion.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
