From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 17:11:47 -0700 (PDT)
Message-ID: <519370.21161.qm@web65110.mail.ac2.yahoo.com>
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

Okay Stan,

What obvious thing have I done, or not done, here?

What should I do now?

(I am not panicking, because I can always revert back...)

I tried to implement you suggestion,=20

# swapoff -a
# dd if=3D/dev/zero of=3D/swapfile1 bs=3D1K count=3D16M
16777216+0 records in
16777216+0 records out
17179869184 bytes (17 GB) copied, 119.642 s, 144 MB/s
# mkswap /swapfile1
Setting up swapspace version 1, size =3D 16777212 KiB
no label, UUID=3D9afbf206-9a79-45b8-ad4b-148f71c440d7
# swapon /swapfile1
# cp /etc/fstab /etc/fstab-20110519

in
/etc/fstab
I replaced
UUID=3D654f3b90-ed2c-4de6-9f2a-e2ad65fd1af1 swap                    swa=
p    defaults        0 0
by
/swapfile1                                swap                    swap =
   defaults        0 0

The log message for the swapon was:
May 19 11:27:38 saturn kernel: [38075.451398] Adding 16777212k swap on =
/swapfile1.  Priority:-1 extents:159 across:24068092k=20


However, it failed to hibernate.  The log messages were:
May 19 11:44:43 saturn kernel: [39043.115385] sd 1:0:0:0: [sdb] Startin=
g disk
May 19 11:44:43 saturn kernel: [39043.128453] sd 2:0:0:0: [sdc] Startin=
g disk
May 19 11:44:43 saturn kernel: [39043.140116] sd 3:0:0:0: [sdd] Startin=
g disk
May 19 11:44:43 saturn kernel: [39043.150889] sd 5:0:0:0: [sde] Startin=
g disk
May 19 11:44:43 saturn kernel: [39043.165729] PM: thaw of devices compl=
ete after 756.642 msecs
May 19 11:44:43 saturn kernel: [39043.322491] PM: Saving image data pag=
es (809839 pages) ... done
May 19 11:44:43 saturn kernel: [39094.461575] PM: Wrote 3239356 kbytes =
in 51.13 seconds (63.35 MB/s)
May 19 11:44:43 saturn kernel: [39094.465739] PM: S
May 19 11:44:43 saturn kernel: [39094.482407] PM: Swap header not found=
!
May 19 11:44:43 saturn kernel: [39094.485188] |
May 19 11:44:43 saturn kernel: [39094.706731] Restarting tasks ... done=
=2E
May 19 11:44:43 saturn NetworkManager[1501]: <info> wake requested (sle=
eping: yes  enabled: yes)
May 19 11:44:43 saturn NetworkManager[1501]: <info> waking up and re-en=
abling...
May 19 11:44:43 saturn NetworkManager[1501]: <info> (eth0): now managed
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
