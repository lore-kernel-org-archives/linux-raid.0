From: Roland RoLaNd <r_o_l_a_n_d@hotmail.com>
Subject: FW: can i recover an all spare raid10 array ?
Date: Tue, 28 Oct 2014 20:10:35 +0200
Message-ID: <DUB121-W17FE6F4540F77AD26256068A9F0@phx.gbl>
References: <DUB121-W342C9D8FABB014826217FA8A9F0@phx.gbl>,<20141028170111.GA20226@cthulhu.home.robinhill.me.uk>,<DUB121-W268A97DFB2DCC142617CED8A9F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DUB121-W268A97DFB2DCC142617CED8A9F0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

sending again as it failed to deliver the first time for an unknown rea=
son


=46rom: r_o_l_a_n_d@hotmail.com
To: robin@robinhill.me.uk
CC: linux-raid@vger.kernel.org
Subject: RE: can i recover an all spare raid10 array ?
Date: Tue, 28 Oct 2014 19:29:25 +0200

Thanks for pitching in.
here are the responses to you questions:


- yes i expected both of them to be part of the array though one of the=
m was just added to the array and didnt finish recovering when raid1 "/=
" crashed

- i have not removed their superblocks or at least not in a way that i =
amaware of=A0

- mdadm:=A03.2.5-5ubuntu4.1
- uname -a: 3.13.0-24-generic


PS:=A0
I just followed this recovery page:=A0
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAI=
D

I managed to reach the last step, whenever i tried to mount it kept ask=
ing me for the right file system


> Date: Tue, 28 Oct 2014 17:01:11 +0000
> From: robin@robinhill.me.uk
> To: r_o_l_a_n_d@hotmail.com
> CC: linux-raid@vger.kernel.org
> Subject: Re: can i recover an all spare raid10 array ?
>=20
> On Tue Oct 28, 2014 at 06:22:11PM +0200, Roland RoLaNd wrote:
>=20
>> I have two raid arrays on my system:
>> raid1: /dev/sdd1 /dev/sdh1
>> raid10: /dev/sde1 /dev/sda1 /dev/sdf1 /dec/sdb1 /dev/sdc1 /dev/sdg1
>>=20
>>=20
>> two disks had bad sectors: sdd and sdf <<-- they both got hot swappe=
d.
>> i added sdf back to raid10 and recovery took place but adding sdd1 t=
o
>> raid1 proved to be troublesome
>> as i didn't have anything important on '/' i formatted and installed
>> ubuntu 14 on raid1=A0
>>=20
>> now system is up on raid 1, but raid10 (md127) is inactive
>>=20
>> cat /proc/mdstat
>>=20
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=
 [raid4] [raid10]=A0
>> md127 : inactive sde1[2](S) sdg1[8](S) sdc1[6](S) sdb1[5](S) sdf1[4]=
(S) sda1[3](S)
>> =A0 =A0 =A0 17580804096 blocks super 1.2
>> =A0 =A0 =A0 =A0
>> md2 : active raid1 sdh4[0] sdd4[1]
>> =A0 =A0 =A0 2921839424 blocks super 1.2 [2/2] [UU]
>> =A0 =A0 =A0 [=3D=3D>..................] =A0resync =3D 10.4% (3043223=
68/2921839424) finish=3D672.5min speed=3D64861K/sec
>> =A0 =A0 =A0=A0
>> md1 : active raid1 sdh3[0] sdd3[1]
>> =A0 =A0 =A0 7996352 blocks super 1.2 [2/2] [UU]
>> =A0 =A0 =A0=A0
>> md0 : active raid1 sdh2[0] sdd2[1]
>> =A0 =A0 =A0 292544 blocks super 1.2 [2/2] [UU]
>> =A0 =A0 =A0=A0
>> unused devices: <none>
>> if i try to assemble md127=A0
>> =A0=A0
>>=20
>> =A0 mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /dev/sdf1 /dev/s=
db1 /dev/sdc1 /dev/sdg1
>> mdadm: /dev/sde1 is busy - skipping
>> mdadm: /dev/sda1 is busy - skipping
>> mdadm: /dev/sdf1 is busy - skipping
>> mdadm: /dev/sdb1 is busy - skipping
>> mdadm: /dev/sdc1 is busy - skipping
>> mdadm: /dev/sdg1 is busy - skipping
>>=20
>>=20
>> if i try to add one of the disks: =A0mdadm --add /dev/md127 /dev/sdj=
1
>> mdadm: cannot get array info for /dev/md127
>>=20
>> if i try:
>>=20
>> mdadm --stop /dev/md127
>> mdadm: stopped /dev/md127
>>=20
>> then running: =A0 mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /d=
ev/sdf1 /dev/sdb1 /dev/sdc1 /dev/sdg1
>>=20
>> returns:=A0
>> =A0
>> assembled from 5 drives and 1 rebuilding - not enough to start the a=
rray
>>=20
>> what does it mean ? is my data lost ?=A0
>>=20
>> if i examine one of the md127 raid 10 array disks it shows this:
>> =A0
>> mdadm --examine /dev/sde1
>> /dev/sde1:
>> =A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
>> =A0 =A0 =A0 =A0 Version : 1.2
>> =A0 =A0 Feature Map : 0x0
>> =A0 =A0 =A0Array UUID : ab90d4c8:41a55e14:635025cc:28f0ee76
>> =A0 =A0 =A0 =A0 =A0 =A0Name : ubuntu:data =A0(local to host ubuntu)
>> =A0 Creation Time : Sat May 10 21:54:56 2014
>> =A0 =A0 =A0Raid Level : raid10
>> =A0 =A0Raid Devices : 8
>>=20
>> =A0Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>> =A0 =A0 =A0Array Size : 11720534016 (11177.57 GiB 12001.83 GB)
>> =A0 Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
>> =A0 =A0 Data Offset : 262144 sectors
>> =A0 =A0Super Offset : 8 sectors
>> =A0 =A0 =A0 =A0 =A0 State : clean
>> =A0 =A0 Device UUID : a2a5db61:bd79f0ae:99d97f17:21c4a619
>>=20
>> =A0 =A0 Update Time : Tue Oct 28 10:07:18 2014
>> =A0 =A0 =A0 =A0Checksum : 409deeb4 - correct
>> =A0 =A0 =A0 =A0 =A0Events : 8655
>>=20
>> =A0 =A0 =A0 =A0 =A0Layout : near=3D2
>> =A0 =A0 =A0Chunk Size : 512K
>>=20
>> =A0 =A0Device Role : Active device 2
>> =A0 =A0Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>=20
>> Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB) <<--- does this =
mean i still have my data ? =A0
>>=20
>>=20
>> the remaining two disks:
>>=20
>> =A0 mdadm --examine /dev/sdj1
>> mdadm: No md superblock detected on /dev/sdj1.
>> =A0 mdadm --examine /dev/sdi1
>> mdadm: No md superblock detected on /dev/sdi1.
>=20
> The --examine output indicates the RAID10 array was 8 members, not 6.
> As it stands, you are missing two array members (presumably a mirrore=
d
> pair as mdadm won't start the array). Without these you're missing 51=
2K
> of every 2M in the array, so your data is toast (well, with a lot of
> effort you may recover some files under 1.5M in size).
>=20
> Were you expecting sdi1 and sdj1 to have been part of the original
> RAID10 array? Have you removed the superblocks from them at any point=
?
> For completeness, what mdadm and kernel versions are you running?
>=20
> Cheers,
> Robin
> --=20
> ___=20
> ( ' } | Robin Hill <robin@robinhill.me.uk> |
> / / ) | Little Jim says .... |
> // !! | "He fallen in de water !!" |
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
