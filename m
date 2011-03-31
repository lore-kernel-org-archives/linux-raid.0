From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Thu, 31 Mar 2011 11:11:48 +0400
Message-ID: <4D942934.3030605@msgid.tls.msk.ru>
References: <20110330080823.GA9167@apartia.fr> <4D933435.3010709@gmail.com> <20110330152011.GA6863@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110330152011.GA6863@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

30.03.2011 19:20, Louis-David Mitterrand wrote:
[]

> /dev/mapper/cmd1	/		xfs	defaults,inode64,delaylog,logbsize=3D262144	0=
	0
> /dev/mapper/cmd1	/		xfs	defaults,inode64,delaylog,logbsize=3D262144	0=
	0
>=20
>> [root@vault t]# dd if=3D/dev/zero of=3D/backup/t/big.file bs=3D32k c=
ount=3D32000
>=20
> 1048576000 octets (1,0 GB) copi=E9s, 0,870001 s, 1,2 GB/s
> 1048576000 bytes (1.0 GB) copied, 9.11934 s, 115 MB/s

Are you sure your LVM volumes are aligned to raid stripe size correctly=
?
Proper alignment for raid levels with parity is _critical_, and with
8-drive raid6 you'll have 6 data disks in eash stripe, but since LVM
can only align volumes to a power of two, you'll have 2 unaligned
volumes after each aligned...  Verify that the volume starts at the
raid stripe boundary, maybe create new volume and recheck -- there
should be quite dramatic speed difference like the above when you
change from aligned to misaligned.

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
