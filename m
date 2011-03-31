From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Thu, 31 Mar 2011 11:32:30 +0200
Message-ID: <20110331093229.GA20417@apartia.fr>
References: <20110330080823.GA9167@apartia.fr>
 <4D933435.3010709@gmail.com>
 <20110330152011.GA6863@apartia.fr>
 <4D93565E.3070403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D93565E.3070403@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 30, 2011 at 12:12:14PM -0400, Joe Landman wrote:
>=20
> >- T610:
> >
> >/dev/mapper/cmd1 on / type xfs (rw,inode64,delaylog,logbsize=3D26214=
4)
> >
> >- PE2900:
> >
> >/dev/mapper/cmd1 on / type xfs (rw,inode64,delaylog,logbsize=3D26214=
4)
>=20
> Hmmm.  You are layering an LVM atop the raid?  Your raids are
> /dev/md1.  How is /dev/mapper/cmd1 related to /dev/md1?

It's a dm-crypt (luks) layer. No lvm here.

> [...]
>=20
> >>[root@vault t]# dd if=3D/dev/md2 of=3D/dev/null bs=3D32k count=3D32=
000
> >
> >- T610:
> >
> >32000+0 enregistrements lus
> >32000+0 enregistrements =E9crits
> >1048576000 octets (1,0 GB) copi=E9s, 1,70421 s, 615 MB/s
> >
> >- PE2900:
> >
> >32000+0 records in
> >32000+0 records out
> >1048576000 bytes (1.0 GB) copied, 2.02322 s, 518 MB/s
>=20
> Raw reads from the MD device.  For completeness, you should also do
>=20
> 	dd if=3D/dev/mapper/cmd1 of=3D/dev/null bs=3D32k count=3D32000

- T610:

32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 0.21472 s, 4.9 GB/s

- PE2900:

32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 0.396733 s, 2.6 GB/s

> and
>=20
> 	dd if=3D/backup/t/big.file  of=3D/dev/null bs=3D32k count=3D32000
>=20
> to see if there is a sudden loss of performance at some level.

- T610:

32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 0.251609 s, 4.2 GB/s

- PE2900:

32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 1.70794 s, 614 MB/s

> >>[root@vault t]# dd if=3D/dev/zero of=3D/backup/t/big.file bs=3D32k =
count=3D32000
> >
> >- T610:
> >
> >32000+0 enregistrements lus
> >32000+0 enregistrements =E9crits
> >1048576000 octets (1,0 GB) copi=E9s, 0,870001 s, 1,2 GB/s
> >
> >- PE2900:
> >
> >32000+0 records in
> >32000+0 records out
> >1048576000 bytes (1.0 GB) copied, 9.11934 s, 115 MB/s

> Ahhh ...  look at that.  Cached write is very different between the
> two.  An order of magnitude.  You could also try a direct
> (noncached) write, using oflag=3Ddirect at the end of the line.  This
> could be useful, though direct IO isn't terribly fast on MD raids.

- T610:

32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 316.461 s, 3.3 MB/s

- PE2900:

32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 262.569 s, 4.0 MB/s

> If we can get the other dd's indicated, we might have a better sense
> of which layer is causing the issue.  It might not be MD.

Thanks for your help,
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
