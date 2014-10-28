From: Roland RoLaNd <r_o_l_a_n_d@hotmail.com>
Subject: FW: can i recover an all spare raid10 array ?
Date: Tue, 28 Oct 2014 20:11:09 +0200
Message-ID: <DUB121-W36815710601874A9BDD858A9F0@phx.gbl>
References: <DUB121-W342C9D8FABB014826217FA8A9F0@phx.gbl>,<20141028170111.GA20226@cthulhu.home.robinhill.me.uk>,<DUB121-W268A97DFB2DCC142617CED8A9F0@phx.gbl>,<DUB121-W26D4B9D346A4A0A0407CD38A9F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DUB121-W26D4B9D346A4A0A0407CD38A9F0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

sending again as it failed the first time for some unknown reason=A0

________________________________
> From: r_o_l_a_n_d@hotmail.com=20
> To: robin@robinhill.me.uk=20
> CC: linux-raid@vger.kernel.org=20
> Subject: RE: can i recover an all spare raid10 array ?=20
> Date: Tue, 28 Oct 2014 19:30:50 +0200=20
>=20
>=20
> Correction:=20
> i couldn't force assemble the read devices so i issued instead:=20
>=20
> mdadm --create /dev/md089 --assume-clean --level=3D10 --verbose=20
> --raid-devices=3D8 missing /dev/dm-1 /dev/dm-0 /dev/dm-5 /dev/dm-3=20
> /dev/dm-2 missing /dev/dm-4=20
>=20
> which got it into degraded state=20
>=20
>=20
> ________________________________=20
> From: r_o_l_a_n_d@hotmail.com=20
> To: robin@robinhill.me.uk=20
> CC: linux-raid@vger.kernel.org=20
> Subject: RE: can i recover an all spare raid10 array ?=20
> Date: Tue, 28 Oct 2014 19:29:25 +0200=20
>=20
> Thanks for pitching in.=20
> here are the responses to you questions:=20
>=20
>=20
> - yes i expected both of them to be part of the array though one of=20
> them was just added to the array and didnt finish recovering when rai=
d1=20
> "/" crashed=20
>=20
> - i have not removed their superblocks or at least not in a way that =
i=20
> amaware of=20
>=20
> - mdadm: 3.2.5-5ubuntu4.1=20
> - uname -a: 3.13.0-24-generic=20
>=20
>=20
> PS:=20
> I just followed this recovery page:=20
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_R=
AID=20
>=20
> I managed to reach the last step, whenever i tried to mount it kept=20
> asking me for the right file system=20
>=20
>=20
>> Date: Tue, 28 Oct 2014 17:01:11 +0000=20
>> From: robin@robinhill.me.uk=20
>> To: r_o_l_a_n_d@hotmail.com=20
>> CC: linux-raid@vger.kernel.org=20
>> Subject: Re: can i recover an all spare raid10 array ?=20
>>=20
>> On Tue Oct 28, 2014 at 06:22:11PM +0200, Roland RoLaNd wrote:=20
>>=20
>>> I have two raid arrays on my system:=20
>>> raid1: /dev/sdd1 /dev/sdh1=20
>>> raid10: /dev/sde1 /dev/sda1 /dev/sdf1 /dec/sdb1 /dev/sdc1 /dev/sdg1=
=20
>>>=20
>>>=20
>>> two disks had bad sectors: sdd and sdf <<-- they both got hot swapp=
ed.=20
>>> i added sdf back to raid10 and recovery took place but adding sdd1 =
to=20
>>> raid1 proved to be troublesome=20
>>> as i didn't have anything important on '/' i formatted and installe=
d=20
>>> ubuntu 14 on raid1=20
>>>=20
>>> now system is up on raid 1, but raid10 (md127) is inactive=20
>>>=20
>>> cat /proc/mdstat=20
>>>=20
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6]=20
> [raid5] [raid4] [raid10]=20
>>> md127 : inactive sde1[2](S) sdg1[8](S) sdc1[6](S) sdb1[5](S)=20
> sdf1[4](S) sda1[3](S)=20
>>> 17580804096 blocks super 1.2=20
>>>=20
>>> md2 : active raid1 sdh4[0] sdd4[1]=20
>>> 2921839424 blocks super 1.2 [2/2] [UU]=20
>>> [=3D=3D>..................] resync =3D 10.4%=20
> (304322368/2921839424) finish=3D672.5min speed=3D64861K/sec=20
>>>=20
>>> md1 : active raid1 sdh3[0] sdd3[1]=20
>>> 7996352 blocks super 1.2 [2/2] [UU]=20
>>>=20
>>> md0 : active raid1 sdh2[0] sdd2[1]=20
>>> 292544 blocks super 1.2 [2/2] [UU]=20
>>>=20
>>> unused devices: <none>=20
>>> if i try to assemble md127=20
>>>=20
>>>=20
>>> mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /dev/sdf1=20
> /dev/sdb1 /dev/sdc1 /dev/sdg1=20
>>> mdadm: /dev/sde1 is busy - skipping=20
>>> mdadm: /dev/sda1 is busy - skipping=20
>>> mdadm: /dev/sdf1 is busy - skipping=20
>>> mdadm: /dev/sdb1 is busy - skipping=20
>>> mdadm: /dev/sdc1 is busy - skipping=20
>>> mdadm: /dev/sdg1 is busy - skipping=20
>>>=20
>>>=20
>>> if i try to add one of the disks: mdadm --add /dev/md127 /dev/sdj1=20
>>> mdadm: cannot get array info for /dev/md127=20
>>>=20
>>> if i try:=20
>>>=20
>>> mdadm --stop /dev/md127=20
>>> mdadm: stopped /dev/md127=20
>>>=20
>>> then running: mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1=20
> /dev/sdf1 /dev/sdb1 /dev/sdc1 /dev/sdg1=20
>>>=20
>>> returns:=20
>>>=20
>>> assembled from 5 drives and 1 rebuilding - not enough to start the =
array=20
>>>=20
>>> what does it mean ? is my data lost ?=20
>>>=20
>>> if i examine one of the md127 raid 10 array disks it shows this:=20
>>>=20
>>> mdadm --examine /dev/sde1=20
>>> /dev/sde1:=20
>>> Magic : a92b4efc=20
>>> Version : 1.2=20
>>> Feature Map : 0x0=20
>>> Array UUID : ab90d4c8:41a55e14:635025cc:28f0ee76=20
>>> Name : ubuntu:data (local to host ubuntu)=20
>>> Creation Time : Sat May 10 21:54:56 2014=20
>>> Raid Level : raid10=20
>>> Raid Devices : 8=20
>>>=20
>>> Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)=20
>>> Array Size : 11720534016 (11177.57 GiB 12001.83 GB)=20
>>> Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)=20
>>> Data Offset : 262144 sectors=20
>>> Super Offset : 8 sectors=20
>>> State : clean=20
>>> Device UUID : a2a5db61:bd79f0ae:99d97f17:21c4a619=20
>>>=20
>>> Update Time : Tue Oct 28 10:07:18 2014=20
>>> Checksum : 409deeb4 - correct=20
>>> Events : 8655=20
>>>=20
>>> Layout : near=3D2=20
>>> Chunk Size : 512K=20
>>>=20
>>> Device Role : Active device 2=20
>>> Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)=20
>>>=20
>>> Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB) <<--- does this=
=20
> mean i still have my data ?=20
>>>=20
>>>=20
>>> the remaining two disks:=20
>>>=20
>>> mdadm --examine /dev/sdj1=20
>>> mdadm: No md superblock detected on /dev/sdj1.=20
>>> mdadm --examine /dev/sdi1=20
>>> mdadm: No md superblock detected on /dev/sdi1.=20
>>=20
>> The --examine output indicates the RAID10 array was 8 members, not 6=
=2E=20
>> As it stands, you are missing two array members (presumably a mirror=
ed=20
>> pair as mdadm won't start the array). Without these you're missing 5=
12K=20
>> of every 2M in the array, so your data is toast (well, with a lot of=
=20
>> effort you may recover some files under 1.5M in size).=20
>>=20
>> Were you expecting sdi1 and sdj1 to have been part of the original=20
>> RAID10 array? Have you removed the superblocks from them at any poin=
t?=20
>> For completeness, what mdadm and kernel versions are you running?=20
>>=20
>> Cheers,=20
>> Robin=20
>> --=20
>> ___=20
>> ( ' } | Robin Hill <robin@robinhill.me.uk> |=20
>> / / ) | Little Jim says .... |=20
>> // !! | "He fallen in de water !!" |=20
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
