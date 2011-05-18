From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 15:31:55 -0700 (PDT)
Message-ID: <953428.5114.qm@web65107.mail.ac2.yahoo.com>
References: <4DD43FE3.7000905@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD43FE3.7000905@hardwarefreak.com>
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
> Date: Thursday, 19 May, 2011, 9:53
> On 5/18/2011 3:13 PM, Gavin Flower
> wrote:
> > --- On Thu, 19/5/11, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> >=20
> >> From: Stan Hoeppner <stan@hardwarefreak.com>
> >> Subject: Re: Best way to create RAID-6 for swap
> partition - existing one failed
> >> To: "Gavin Flower" <gavinflower@yahoo.com>
> >> Cc: linux-raid@vger.kernel.org,
> neilb@suse.de, mb@gem.win.co.nz
> >> Date: Thursday, 19 May, 2011, 6:59
> >> On 5/16/2011 4:41 PM, Gavin Flower
> >> wrote:
> >>
> >>> Motivation, existing RAID-6 swap partition
> >> failed.=A0 I am thinking I should recreate it
> in a new
> >> format, as currently it is 'Version : 0.90',
> rather than
> >> simply rebuild it.
> >> <snip>
> >>
> >> Forget using a partition.=A0 Simply use a swap
> >> file.=A0 This example creates
> >> a 1GB swap file in the / filesystem.=A0 You can
> locate
> >> it on any
> >> filesystem you wish.
> >>
> >> # swappoff -a
> >> # dd if=3D/dev/zero of=3D/swapfile1 bs=3D1024
> count=3D1048576
> >> # mkswap /swapfile1
> >> # swapon /swapfile1
> >> # vi /etc/fstab
> >> Add:
> >> /swapfile1 swap swap defaults 0 0
> >>
> >> and remove your old entry for the failed swap
> partition.
> >>
> >> There is little performance difference between
> swap files
> >> and swap
> >> partitions with modern kernels.=A0 The kernel
> will map
> >> the disk location
> >> of the swap file and perform direct disk access,
> bypassing
> >> the
> >> filesystem and buffer cache.
> >>
> >> --=20
> >> Stan
> >>
> >=20
> > Thanks.
> >=20
> > Interesting!
> >=20
> > (Reminds me of when I first got into Linux.=A0 Then
> you could have any size swap file up to 128 MB, and have up
> to 8 swap files, for a maximum of 1 GB. I then had about 64
> MB of RAM - now I have 8 GB of RAM. Also, swap partitions
> were recommended.=A0 When the 2.4 kernel first came out,
> it was said to be faster if you had at least 16 MB.)
> >=20
> > I read up and could not see any benefit in changing,
> so I ended up 'simply' reassembling the partition.
>=20
> The big benefits are flexibility, simplicity, and time
> consumed.=A0 Given
> your particular case it seems a bit ironic that you see no
> benefit in
> using swap files.=A0 The time to resolution in this case
> would be mere
> seconds with swap files.=A0 How much total time did you
> spend reassembling
> your swap partition, bot command execution time, but your
> total time?
>=20
> --=20
> Stan
>=20

I took longer than I'm prepared to admit!  :-)

I'll take note, and either apply your idea next time it happens, or whe=
n I do a major O/S upgrade.


Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
