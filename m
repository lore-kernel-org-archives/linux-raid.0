From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 19:50:27 -0700 (PDT)
Message-ID: <826307.18822.qm@web65107.mail.ac2.yahoo.com>
References: <4DD47FD3.2000909@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD47FD3.2000909@hardwarefreak.com>
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
> Date: Thursday, 19 May, 2011, 14:26
> On 5/18/2011 7:11 PM, Gavin Flower
> wrote:
>=20
> We're getting pretty OT here...
>=20
> > What obvious thing have I done, or not done, here?
> >=20
> > What should I do now?
> >=20
> > (I am not panicking, because I can always revert
> back...)
> >=20
> > I tried to implement you suggestion,=20
> >=20
> > # swapoff -a
> > # dd if=3D/dev/zero of=3D/swapfile1 bs=3D1K count=3D16M
> > 16777216+0 records in
> > 16777216+0 records out
> > 17179869184 bytes (17 GB) copied, 119.642 s, 144 MB/s
> > # mkswap /swapfile1
> > Setting up swapspace version 1, size =3D 16777212 KiB
> > no label, UUID=3D9afbf206-9a79-45b8-ad4b-148f71c440d7
>=20
> 17GB is a bit ridiculous for swap, especially on a single
> user machine.

Strictly speaking, I should have used the recommended 10GB (2GB + RAM s=
ize) to allow for hibernation.

> > # swapon /swapfile1
> > # cp /etc/fstab /etc/fstab-20110519
> >=20
> > in
> > /etc/fstab
> > I replaced
> > UUID=3D654f3b90-ed2c-4de6-9f2a-e2ad65fd1af1 swap=A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 swap=A0 =A0 defaults=A0 =A0 =A0 =A0
> 0 0
> > by
> > /swapfile1=A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 swap=A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 swap=A0 =A0 defaults=A0
> =A0 =A0 =A0 0 0
> >=20
> > The log message for the swapon was:
> > May 19 11:27:38 saturn kernel: [38075.451398] Adding
> 16777212k swap on /swapfile1.=A0 Priority:-1 extents:159
> across:24068092k=20
>=20
> Looks good.
>=20
> > However, it failed to hibernate.=A0 The log
> messages were:
> > May 19 11:44:43 saturn kernel: [39043.115385] sd
> 1:0:0:0: [sdb] Starting disk
> > May 19 11:44:43 saturn kernel: [39043.128453] sd
> 2:0:0:0: [sdc] Starting disk
> > May 19 11:44:43 saturn kernel: [39043.140116] sd
> 3:0:0:0: [sdd] Starting disk
> > May 19 11:44:43 saturn kernel: [39043.150889] sd
> 5:0:0:0: [sde] Starting disk
> > May 19 11:44:43 saturn kernel: [39043.165729] PM: thaw
> of devices complete after 756.642 msecs
> > May 19 11:44:43 saturn kernel: [39043.322491] PM:
> Saving image data pages (809839 pages) ... done
> > May 19 11:44:43 saturn kernel: [39094.461575] PM:
> Wrote 3239356 kbytes in 51.13 seconds (63.35 MB/s)
> > May 19 11:44:43 saturn kernel: [39094.465739] PM: S
> > May 19 11:44:43 saturn kernel: [39094.482407] PM: Swap
> header not found!
> > May 19 11:44:43 saturn kernel: [39094.485188] |
> > May 19 11:44:43 saturn kernel: [39094.706731]
> Restarting tasks ... done.
> > May 19 11:44:43 saturn NetworkManager[1501]:
> <info> wake requested (sleeping: yes=A0 enabled:
> yes)
> > May 19 11:44:43 saturn NetworkManager[1501]:
> <info> waking up and re-enabling...
> > May 19 11:44:43 saturn NetworkManager[1501]:
> <info> (eth0): now managed
>=20
> I've never used hibernation, but a quick Google search
> gives lots of
> information on this.=A0 Google "linux swap file
> hibernate".=A0 I read one
> thread from 2008, in which folks easily solved this with a
> kernel update
> or switching the filesystem where they stored the swap
> file.=A0 I would
> think 3 years later any bugs in the hibernation code have
> been squashed
> and this should work flawlessly.
>=20
> What kernel/distro version are you running?=A0 Anything
> recent should be
> able to handle hibernation to a swap file.
>=20
> --=20
> Stan
>=20

Hibernation mostly worked (almost all problems were associated with the=
 Radeon video drivers) when I was using the RAID-6 swap partition.  So =
I was not anticipating any new problem with hibernations.

I am using Fedora 14 with all the latest patches applied.

$ uname -a
Linux saturn 2.6.35.13-91.fc14.x86_64 #1 SMP Tue May 3 13:23:06 UTC 201=
1 x86_64 x86_64 x86_64 GNU/Linux


Cheers,
Gavin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
