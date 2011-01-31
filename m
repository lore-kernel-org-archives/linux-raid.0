From: Denis <denismpa@gmail.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 16:35:17 -0200
Message-ID: <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
 <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
 <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
 <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
 <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com> <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
> i think that partial failure (raid0 fail) of a mirror, is a fail
> (since all mirror is repaired and resync)
> the security is, if you lose all mirrors you have a device
> so your 'secure' is the number of mirrors, not the number of disks ss=
d
> or another type of device...
> how many mirrors you have here:
> raid0=3D 1,2(a) 3,4(b)
> raid1=3Da,b
> 1 mirror (a or b)
>
> and here:
> raid1=3D1,2(a) 3,4(b)
> raid0=3Dab
> 1 mirror (a or b)
>
> let=B4s think about hard disk?
> your hard disk have 2 disks?
> why not make two partition? first partition is disk1, second partitio=
n is disk2
> mirror it
> what=B4s your security? 1 mirror
> is it security? normaly when a harddisk crash all disks inside it
> crash but you is secury if only one internal disk fail...
>
> that=B4s the point, how many mirror?
> the point is
> with raid1+0 (raid10) we know that disks are fragments (raid1)
> with raid0+1 we know that disks are a big disk (raid0)
> the point is, we can=B4t allow that information stop, we need mirror =
to
> be secured (1 is good, 2 better, 3 really better, 4 5 6 7...)
> you can=B4t break mirror (not disk) to don=B4t break mirror have a se=
cond
> mirror (raid0 don=B4t help here! just raid1)
>
> with raid10 you will repair smal size of information (raid1), here
> sync will cost less time
> with raid01 you will repair big =A0size of information (raid0), here
> sync will cost more time

Roberto, to quite understend how better a raid 10 is over raid 01  you
need to take down into a mathematical level:

once I had the same doubt:

"The difference is that the chance of system failure with two drive
failures in a RAID 0+1 system with two sets of drives is (n/2)/(n - 1)
where n is the total number of drives in the system. The chance of
system failure in a RAID 1+0 system with two drives per mirror is 1/(n
- 1). So, for example, using a 8 drive system, the chance that losing
a second drive would bring down the RAID system is 4/7 with a RAID 0+1
system and 1/7 with a RAID 1+0 system."


Another problem is that in the case of a failury of one disk ( in a
two sets case), in a raid01 you will loose redundancy for ALL your
data, while in a raid10 you will loose redundancy for 1/[(n/2
-1)/(n/2)], in the same case 1/4 of your data set.

And also, in a raid 10 you will have o re-mirror just one disk in the
case of a disk failure, in raid 01 you will have to re-mirror the
whole failed set.

--=20
Denis Anjos,
www.versatushpc.com.br
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
