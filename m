From: "L.M.J" <linuxmasterjedi@free.fr>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Fri, 25 Apr 2014 07:13:40 +0200
Message-ID: <20140425071340.1ac35ded@netstation>
References: <20140424070548.445497dd@netstation>
	<20140424194832.2d0a867f@netstation>
	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>
	<20140424203506.5fdee0d3@netstation>
	<CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com>
	<CAK_KU4aDDaUSGgcGBwCeO+yE0Qa_pUmMdAHMu7pqO7dqEEC71g@mail.gmail.com>
	<20140424215654.0447d300@netstation>
	<CAK_KU4YUejncX9yQk4HM5HE=1-qPPxOibuRauFheo3jaBc8SaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4YUejncX9yQk4HM5HE=1-qPPxOibuRauFheo3jaBc8SaQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Le Thu, 24 Apr 2014 16:22:49 -0400,
"Scott D'Vileskis" <sdvileskis@gmail.com> a =E9crit :

> I have been replying directly to you, not to the mailing list, since =
your
> case seems to be a case of user-screwed-up-his-own-data, and not a pr=
oblem
> with mdadm/linux raid, nor a problem that will necessarily help someo=
ne
> else (since it is not likely someone will create a mess in exactly th=
e same
> manner you have) .

Ha OK.=20



> To summarize:
> 1) You lost a disk. Even down a disk, you should have been able to
> run/start the array (in degraded mode) with only 2 disks, mounted the
> filesystem, etc.
Yes of course, it worked only with 2 disks the last 3 weeks.


> 2) You then should have simply partitioned and then --add 'ed the new=
 disk.
>   mdadm would have written a superblock to the new disk, and resynced=
 the
> data
>=20
> I assume your original disks were in the order sdb, sdc, sdd.

Exactly


> Unfortunately, you might have clobbered your drives by recreating the
> array. You certainly clobbered your superblocks and changed the order=
 when
> you did this:
> > ~# mdadm -Cv /dev/md0 --assume-clean --level=3D5 --raid-devices=3D3=
 /dev/sdc1
> /dev/sdd1 /dev/sdb1
>=20
> You changed the order, but because of the assume-clean, it shouldn't =
have
> started a resync of the data. Your file system probably had a fit tho=
ugh.
>=20
> Hindsight is 20/20, a mistake was made, it happens to all of us at so=
me
> point or another, (I've lost arrays and filesystems with careless use=
 of
> 'dd' once upon a time, once I was giving a raid demo to a friend with=
 loop
> devices, mistyped something, and blew something away)
>=20
> IMPORTANT: At any point did your drives do a resync?

Unfortunatly : yes, resync occurs when I=20



> Assuming no, and assuming you haven't done any other writing to your
> disks(besides rewriting the superblocks), you can probably correct th=
e
> order of your drives by reissuing the --create command with the two
> original drives, in the proper order, and the missing drive as the
> placeholder. (This will rewrite the superblocks again, but hopefully =
in the
> right order)
> mdadm -Cv /dev/md0 --level=3D5 --raid-devices=3D3 missing /dev/sdc1 /=
dev/sdd1
>=20
> If you can start that array (it will be degraded with only 2/3 drives=
) you
> should be able to mount and recover your data. You may need to run a =
full
> fsck again since your last fsck probably made a mess.

I shutdown the computer, remove the old disk, added the new one. Maybe =
I've messed up with SATA cables too.
Unfortunately, I use to start the degraded array like this :

~# mdadm --assemble --force /dev/sdc1 /dev/sdd1

didn't work

I created a partition on sdb, and then, the mistake
~# mdadm --stop /dev/md0
~# mdadm -Cv /dev/md0 --assume-clean --level=3D5 --raid-devices=3D3 /de=
v/sdb1 /dev/sdc1 /dev/sdd1

Didn't work better, then
~# mdadm --stop /dev/md0
~# mdadm --create /dev/md0 --level=3D5 --assume-clean --raid-devices=3D=
3 /dev/sdc1 /dev/sdd1 missing
~# mdadm --manage /dev/md0 --add /dev/sdb1=20


Looks even worst, isn't it ?



>=20
> Assuming you can mount and copy your data, you can then --add your 'n=
ew'
> drive to the array with the --add argument. (Note, you'll have to cle=
ar
> it's superblock or mdadm will object)
>=20


And what do you think of files fsck may recovered :

5,5M 2013-04-24 17:53 #4456582
5,7M 2013-04-24 17:53 #4456589
 16M 2013-04-24 17:53 #4456590
 25M 2013-04-24 17:53 #4456594
 17M 2013-04-24 17:53 #4456578
 18M 2013-04-24 17:53 #4456580
1,3M 2013-04-24 17:54 #4456597
1,1M 2013-04-24 17:54 #4456596
 17M 2013-04-24 17:54 #4456595
2,1M 2013-04-24 17:54 #4456599
932K 2013-04-24 17:54 #4456598



Well, what should I do now ? mkfs everything and restart from scratch ?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
