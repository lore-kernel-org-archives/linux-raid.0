From: David Brown <david@westcontrol.com>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 01 Feb 2011 11:01:33 +0100
Message-ID: <ii8lcv$3jg$1@dough.gmane.org>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131225235.GA11775@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/01/2011 23:52, Keld J=F8rn Simonsen wrote:
> raid1+0 and Linux MD raid10 are similar, but significantly different
> in a number of ways. Linux MD raid10 can run on only 2 drives.
> Linux raid10,f2 has almost RAID0 striping performance in sequential r=
ead.
> You can have an odd number of drives in raid10.
> And you can have as many copies as you like in raid10,
>

You can make raid10,f2 functionality from raid1+0 by using partitions.=20
=46or example, to get a raid10,f2 equivalent on two drives, partition t=
hem=20
into equal halves.  Then make md0 a raid1 mirror of sda1 and sdb2, and=20
md1 a raid1 mirror of sdb1 and sda2.  Finally, make md2 a raid0 stripe=20
set of md0 and md1.

If you have three disks, you can do that too:

md0 =3D raid1(sda1, sdb2)
md1 =3D raid1(sdb1, sdc2)
md2 =3D raid1(sdc1, sda2)
md3 =3D raid0(md0, md1, md2)

As far as I can figure out, the performance should be pretty much the=20
same (although wrapping everything in a single raid10,f2 is more=20
convenient).

=46or four disks, there are more ways to do it:

Option A:

md0 =3D raid1(sda1, sdb2)
md1 =3D raid1(sdb1, sdc2)
md2 =3D raid1(sdc1, sdd2)
md3 =3D raid1(sdd1, sda2)
md4 =3D raid0(md0, md1, md2, md3)

Option B:

md0 =3D raid1(sda1, sdb2)
md1 =3D raid1(sdb1, sda2)
md2 =3D raid1(sdc1, sdd2)
md3 =3D raid1(sdd1, sdc2)
md4 =3D raid0(md0, md1, md2, md3)

Option C:

md0 =3D raid1(sda1, sdc2)
md1 =3D raid1(sdb1, sdd2)
md2 =3D raid1(sdc1, sda2)
md3 =3D raid1(sdd1, sdb2)
md4 =3D raid0(md0, md1, md2, md3)

"Ordinary" raid 1 + 0 is roughly like this:

md0 =3D raid1(sda1, sdb1)
md1 =3D raid1(sda2, sdb2)
md2 =3D raid1(sdc1, sdc1)
md3 =3D raid1(sdc2, sdd2)
md4 =3D raid0(md0, md1, md2, md3)


I don't know which of A, B or C is used for raid10,f2 on four disks -=20
maybe Neil knows?

The fun thing here is to try to figure out the performance for these=20
combinations.  For large reads, A, B and C will give you much better=20
performance than raid 1 + 0, since you can stream data off all disks in=
=20
parallel.  For most other accesses, I think the performance will be=20
fairly similar, except for medium write sizes (covering between a=20
quarter and half a stripe), which will be faster with C since all four=20
disks can write in parallel.

All four arrangements support any single disk failing, and B, C and=20
raid1+0 have a 66% chance of supporting a second failure.


I don't think there is any way you can get the equivalent of raid10,o2=20
in this way.  But then, I am not sure how much use raid10,o2 actually i=
s=20
- are there any usage patterns for which it is faster than raid10,n2 or=
=20
raid10,f2?



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
