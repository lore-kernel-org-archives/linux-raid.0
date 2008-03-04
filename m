From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: RAID5 in sync does not populate slots sequentially, shows array
 as (somewhat) faulty
Date: Tue, 04 Mar 2008 11:52:51 +0100
Message-ID: <47CD2A03.6010408@rabbit.us>
References: <47CBD62E.7040608@rabbit.us> <47CD279F.2070500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CD279F.2070500@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VG9yIEFybmUgVmVzdGLDuA==?= <torarnv@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tor Arne Vestb=C3=B8 wrote:
> The reason I did this was because /dev/sda and /dev/sdb used to be pa=
rt=20
> of a RAID1 array, but were now used as system disk and home disk=20
> respectively. I was afraid that mdadm would pick up on some of the=20
> lingering RAID superblocks on those disks when reporting, so I shredd=
ed=20
> them both using 'shred -n 1' and reinstalled.
>=20

This is irrelevant to 1.x superblocks, and largely insignificant for 0.=
9=20
superblocks (baring some really bizzare cases). In either case mdadm=20
--zero-superblock /dev/XX (possibly executed multiple times) would save=
 you a=20
lot of disk churning :)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
