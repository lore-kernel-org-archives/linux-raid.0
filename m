From: Hank Barta <hbarta@gmail.com>
Subject: Re: partitions
Date: Fri, 28 Jan 2011 19:22:05 -0600
Message-ID: <AANLkTikNPmc2AK93k5KTUg4fTM5GoOcr+mtYyv5GN08z@mail.gmail.com>
References: <AANLkTimGHtECH2oFdcWWmjXjzrFeRmDsXhfwg4FMR2a8@mail.gmail.com>
	<AANLkTim_16xzRaQJLd1QGd5Dx2LScNX-VUjxrN5uXZng@mail.gmail.com>
	<AANLkTinjmGobHBtZxsz3Tv9US1-VKr32ODy4h=-9V1cO@mail.gmail.com>
	<AANLkTi=z7PxSrsPoh4gozv8sx2H416pqn=dEGBcciR2m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=z7PxSrsPoh4gozv8sx2H416pqn=dEGBcciR2m@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 28, 2011 at 4:39 PM, Doug Dumitru <doug@easyco.com> wrote:
>
> grub and lilo need a "plain" boot partition. =A0the raid setup is lat=
er
=2E..

One exception: Grub (and perhaps LILO) can boot from a RAID1 partition
because the individual partition looks like a plain file system. It
requires v 0.9 metadata which stores the superblock at the end of the
partition. (Don't ask me how I know! ;) )

I have used LVM to partition a RAID5. I have no idea if it adds
significant overhead vs. partitioning the RAID itself if that were
possible. It was arcane enough for me to not care to do it again. It
appears to have some powerful capabilities that were not needed by me.

best,
hank

--=20
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
