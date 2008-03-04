From: =?UTF-8?B?VG9yIEFybmUgVmVzdGLDuA==?= <torarnv@gmail.com>
Subject: Re: RAID5 in sync does not populate slots sequentially, shows array as (somewhat) faulty
Date: Tue, 4 Mar 2008 11:58:30 +0100
Message-ID: <47CD2B56.5040403@gmail.com>
References: <47CBD62E.7040608@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CD2A03.6010408@rabbit.us>
References: <47CD279F.2070500@gmail.com>
References: <47CD2A03.6010408@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
>> Tor Arne Vestb=F8 wrote:
>> [...] so I shredded them both using 'shred -n 1' and reinstalled.
>=20
> This is irrelevant to 1.x superblocks, and largely insignificant for =
0.9=20
> superblocks (baring some really bizzare cases). In either case mdadm=20
> --zero-superblock /dev/XX (possibly executed multiple times) would sa=
ve=20
> you a lot of disk churning :)

The only way to learn is the hard way ;)

Tor Arne

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
