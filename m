From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: partitions
Date: Sat, 29 Jan 2011 02:17:35 -0200
Message-ID: <AANLkTin=rFMRRRhLfFjafjqUBPm=UyKAzWbxKQ46bnvG@mail.gmail.com>
References: <AANLkTimGHtECH2oFdcWWmjXjzrFeRmDsXhfwg4FMR2a8@mail.gmail.com>
	<AANLkTim_16xzRaQJLd1QGd5Dx2LScNX-VUjxrN5uXZng@mail.gmail.com>
	<AANLkTinjmGobHBtZxsz3Tv9US1-VKr32ODy4h=-9V1cO@mail.gmail.com>
	<AANLkTi=z7PxSrsPoh4gozv8sx2H416pqn=dEGBcciR2m@mail.gmail.com>
	<AANLkTikNPmc2AK93k5KTUg4fTM5GoOcr+mtYyv5GN08z@mail.gmail.com>
	<4D438D7F.50007@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D438D7F.50007@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Hank Barta <hbarta@gmail.com>, doug@easyco.com, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice i don't know if LVM make a more overhead but it's a very feature
=3D) thanks again guys!

2011/1/29 Phillip Susi <psusi@cfl.rr.com>:
> On 01/28/2011 08:22 PM, Hank Barta wrote:
>>
>> One exception: Grub (and perhaps LILO) can boot from a RAID1 partiti=
on
>> because the individual partition looks like a plain file system. It
>> requires v 0.9 metadata which stores the superblock at the end of th=
e
>> partition. (Don't ask me how I know! ;) )
>
> Grub2 can boot from raid1, raid0, raid5, it doesn't care ( without a =
plain
> /boot partition ).
>
>> I have used LVM to partition a RAID5. I have no idea if it adds
>> significant overhead vs. partitioning the RAID itself if that were
>> possible. It was arcane enough for me to not care to do it again. It
>> appears to have some powerful capabilities that were not needed by m=
e.
>
> With LVM you can do online resize and moves, and don't run into issue=
s
> trying to expand a partition and having to take forever to move an ad=
jacent
> one over to make room, or other issues with the 4 primary partition l=
imit.
> =A0I find these to be pretty handy.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
