From: Vasco =?iso-8859-15?b?Tul2b2E=?= <vasco.nevoa@sapo.pt>
Subject: Re: upgrading the superblock version
Date: Thu, 21 Jul 2011 16:44:24 +0100
Message-ID: <20110721164424.61342u4pdouzh3yw@mail.sapo.pt>
References: <20110721100600.66251wgcutbqknw8@mail.sapo.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721100600.66251wgcutbqknw8@mail.sapo.pt>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I have read success reports that using "--create" on an array that =20
already exists should preserve the disk data.
So to upgrade the superblock version one can simply do a --create with =
=20
newer version requested?

What exactly happens to the partition and filesystem on the disk when =20
one does mdadm --create or --zero-superblock?
Does it get altered at all?


Citando Vasco N=E9voa <vasco.nevoa@sapo.pt>:

>
> Hello.
>
> I'd like to know if it is possible to upgrade the superblock model =20
> version of an array, from 0.9 to 1.0 for example.
>
> Theoretically it should be possible, I think. What would be the safe =
=20
> steps to do it?
>
> I imagine something like:
> - zeroing the current superblocks in all the array disks;
> - (optionally) assembling the array in "build" mode, ignoring superbl=
ocks;
> - updating the superblocks using the desired version.
>
> If that isn't possible, then:
> - zeroing the current superblocks in all the array disks;
> - creating a new array with those disks, using the desired =20
> superblock version and --assume-clean;
> - would this lead to the loss of the partition table inside the array=
?
>
> Has anyone done such a thing?
> How should I proceed?
>
> Thanks,
> Vasco.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
