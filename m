From: Roland RoLaNd <r_o_l_a_n_d@hotmail.com>
Subject: RE: can i recover an all spare raid10 array ?
Date: Tue, 28 Oct 2014 21:11:21 +0200
Message-ID: <DUB121-W224F0805F3F731496386978A9F0@phx.gbl>
References: <DUB121-W342C9D8FABB014826217FA8A9F0@phx.gbl>,<20141028170111.GA20226@cthulhu.home.robinhill.me.uk>,<DUB121-W268A97DFB2DCC142617CED8A9F0@phx.gbl>,<DUB121-W26D4B9D346A4A0A0407CD38A9F0@phx.gbl>,<20141028183422.GA30582@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141028183422.GA30582@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



----------------------------------------
> Date: Tue, 28 Oct 2014 18:34:22 +0000
> From: robin@robinhill.me.uk
> To: r_o_l_a_n_d@hotmail.com
> CC: robin@robinhill.me.uk; linux-raid@vger.kernel.org
> Subject: Re: can i recover an all spare raid10 array ?
>
> Please don't top post, it makes conversations very difficult to follo=
w.
> Responses should go at the bottom, or interleaved with the previous p=
ost
> if responding to particular points. I've moved your previous response=
s
> to keep the conversation flow straight.
>
> On Tue Oct 28, 2014 at 07:30:50PM +0200, Roland RoLaNd wrote:
>>
>>> From: r_o_l_a_n_d@hotmail.com
>>> To: robin@robinhill.me.uk
>>> CC: linux-raid@vger.kernel.org
>>> Subject: Re: can i recover an all spare raid10 array ?
>>> Date: Tue, 28 Oct 2014 19:29:25 +0200
>>>
>>>> Date: Tue, 28 Oct 2014 17:01:11 +0000
>>>> From: robin@robinhill.me.uk
>>>> To: r_o_l_a_n_d@hotmail.com
>>>> CC: linux-raid@vger.kernel.org
>>>> Subject: Re: can i recover an all spare raid10 array ?
>>>>
>>>> On Tue Oct 28, 2014 at 06:22:11PM +0200, Roland RoLaNd wrote:
>>>>
>>>>> I have two raid arrays on my system:
>>>>> raid1: /dev/sdd1 /dev/sdh1
>>>>> raid10: /dev/sde1 /dev/sda1 /dev/sdf1 /dec/sdb1 /dev/sdc1 /dev/sd=
g1
>>>>>
>>>>>
>>>>> two disks had bad sectors: sdd and sdf <<-- they both got hot swa=
pped.
>>>>> i added sdf back to raid10 and recovery took place but adding sdd=
1 to
>>>>> raid1 proved to be troublesome
>>>>> as i didn't have anything important on '/' i formatted and instal=
led
>>>>> ubuntu 14 on raid1
>>>>>
>>>>> now system is up on raid 1, but raid10 (md127) is inactive
>>>>>
>>>>> cat /proc/mdstat
>>>>>
>>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [rai=
d5] [raid4] [raid10]
>>>>> md127 : inactive sde1[2](S) sdg1[8](S) sdc1[6](S) sdb1[5](S) sdf1=
[4](S) sda1[3](S)
>>>>> 17580804096 blocks super 1.2
>>>>>
>>>>> md2 : active raid1 sdh4[0] sdd4[1]
>>>>> 2921839424 blocks super 1.2 [2/2] [UU]
>>>>> [=3D=3D>..................] resync =3D 10.4% (304322368/292183942=
4) finish=3D672.5min speed=3D64861K/sec
>>>>>
>>>>> md1 : active raid1 sdh3[0] sdd3[1]
>>>>> 7996352 blocks super 1.2 [2/2] [UU]
>>>>>
>>>>> md0 : active raid1 sdh2[0] sdd2[1]
>>>>> 292544 blocks super 1.2 [2/2] [UU]
>>>>>
>>>>> unused devices: <none>
>>>>> if i try to assemble md127
>>>>>
>>>>>
>>>>> mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /dev/sdf1 /dev/sd=
b1 /dev/sdc1 /dev/sdg1
>>>>> mdadm: /dev/sde1 is busy - skipping
>>>>> mdadm: /dev/sda1 is busy - skipping
>>>>> mdadm: /dev/sdf1 is busy - skipping
>>>>> mdadm: /dev/sdb1 is busy - skipping
>>>>> mdadm: /dev/sdc1 is busy - skipping
>>>>> mdadm: /dev/sdg1 is busy - skipping
>>>>>
>>>>>
>>>>> if i try to add one of the disks: mdadm --add /dev/md127 /dev/sdj=
1
>>>>> mdadm: cannot get array info for /dev/md127
>>>>>
>>>>> if i try:
>>>>>
>>>>> mdadm --stop /dev/md127
>>>>> mdadm: stopped /dev/md127
>>>>>
>>>>> then running: mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /de=
v/sdf1 /dev/sdb1 /dev/sdc1 /dev/sdg1
>>>>>
>>>>> returns:
>>>>>
>>>>> assembled from 5 drives and 1 rebuilding - not enough to start th=
e array
>>>>>
>>>>> what does it mean ? is my data lost ?
>>>>>
>>>>> if i examine one of the md127 raid 10 array disks it shows this:
>>>>>
>>>>> mdadm --examine /dev/sde1
>>>>> /dev/sde1:
>>>>> Magic : a92b4efc
>>>>> Version : 1.2
>>>>> Feature Map : 0x0
>>>>> Array UUID : ab90d4c8:41a55e14:635025cc:28f0ee76
>>>>> Name : ubuntu:data (local to host ubuntu)
>>>>> Creation Time : Sat May 10 21:54:56 2014
>>>>> Raid Level : raid10
>>>>> Raid Devices : 8
>>>>>
>>>>> Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>>>>> Array Size : 11720534016 (11177.57 GiB 12001.83 GB)
>>>>> Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
>>>>> Data Offset : 262144 sectors
>>>>> Super Offset : 8 sectors
>>>>> State : clean
>>>>> Device UUID : a2a5db61:bd79f0ae:99d97f17:21c4a619
>>>>>
>>>>> Update Time : Tue Oct 28 10:07:18 2014
>>>>> Checksum : 409deeb4 - correct
>>>>> Events : 8655
>>>>>
>>>>> Layout : near=3D2
>>>>> Chunk Size : 512K
>>>>>
>>>>> Device Role : Active device 2
>>>>> Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>>>>>
>>>>> Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB) <<--- does th=
is mean i still have my data ?
>>>>>
>>>>>
>>>>> the remaining two disks:
>>>>>
>>>>> mdadm --examine /dev/sdj1
>>>>> mdadm: No md superblock detected on /dev/sdj1.
>>>>> mdadm --examine /dev/sdi1
>>>>> mdadm: No md superblock detected on /dev/sdi1.
>>>>
>>>> The --examine output indicates the RAID10 array was 8 members, not=
 6.
>>>> As it stands, you are missing two array members (presumably a mirr=
ored
>>>> pair as mdadm won't start the array). Without these you're missing=
 512K
>>>> of every 2M in the array, so your data is toast (well, with a lot =
of
>>>> effort you may recover some files under 1.5M in size).
>>>>
>>>> Were you expecting sdi1 and sdj1 to have been part of the original
>>>> RAID10 array? Have you removed the superblocks from them at any po=
int?
>>>> For completeness, what mdadm and kernel versions are you running?
>>>>
>>>> Cheers,
>>>> Robin
>>>
>>> Thanks for pitching in.here are the responses to you questions:
>>>
>>> - yes i expected both of them to be part of the array though one of
>>> them was just added to the array and didnt finish recovering when
>>> raid1 "/" crashed
>>>
> According to your --examine earlier, the RAID10 rebuild had completed
> (it shows the array clean and having all disks active). Are you certa=
in
> that the new RAID1 array isn't using disks that used to be part of th=
e
> RAID10 array? Regardless, I'd expect the disks to have a superblock i=
f
> they were part of either array (unless they've been repartitioned?).
>

the examine earlier was to one of the 6 disks that belong to the curren=
t inactive array.. they're all clean
as for raid1/10 arrays, =9Athat's what i thought as it happened with me=
 before, but lsblk shows the following:

NAME =9A =9AMAJ:MIN RM =9A SIZE RO TYPE =9AMOUNTPOINT
sda =9A =9A =9A 8:0 =9A =9A0 =9A 2.7T =9A0 disk =9A
=84=80sda1 =9A =9A8:1 =9A =9A0 =9A 2.7T =9A0 part =9A
sdb =9A =9A =9A 8:16 =9A 0 =9A 2.7T =9A0 disk =9A
=84=80sdb1 =9A =9A8:17 =9A 0 =9A 2.7T =9A0 part =9A
sdc =9A =9A =9A 8:32 =9A 0 =9A 2.7T =9A0 disk =9A
=84=80sdc1 =9A =9A8:33 =9A 0 =9A 2.7T =9A0 part =9A
sdd =9A =9A =9A 8:48 =9A 0 =9A 2.7T =9A0 disk =9A
=86=80sdd1 =9A =9A8:49 =9A 0 =9A =9A 1M =9A0 part =9A
=86=80sdd2 =9A =9A8:50 =9A 0 =9A 286M =9A0 part =9A
=81 =84=80md0 =9A 9:0 =9A =9A0 285.7M =9A0 raid1 /boot
=86=80sdd3 =9A =9A8:51 =9A 0 =9A 7.6G =9A0 part =9A
=81 =84=80md1 =9A 9:1 =9A =9A0 =9A 7.6G =9A0 raid1 [SWAP]
=84=80sdd4 =9A =9A8:52 =9A 0 =9A 2.7T =9A0 part =9A
=9A =84=80md2 =9A 9:2 =9A =9A0 =9A 2.7T =9A0 raid1 /
sde =9A =9A =9A 8:64 =9A 0 =9A 2.7T =9A0 disk =9A
=84=80sde1 =9A =9A8:65 =9A 0 =9A 2.7T =9A0 part =9A
sdf =9A =9A =9A 8:80 =9A 0 =9A 2.7T =9A0 disk =9A
=84=80sdf1 =9A =9A8:81 =9A 0 =9A 2.7T =9A0 part =9A
sdg =9A =9A =9A 8:96 =9A 0 =9A 2.7T =9A0 disk =9A
=84=80sdg1 =9A =9A8:97 =9A 0 =9A 2.7T =9A0 part =9A
sdh =9A =9A =9A 8:112 =9A0 =9A 2.7T =9A0 disk =9A
=86=80sdh1 =9A =9A8:113 =9A0 =9A =9A 1M =9A0 part =9A
=86=80sdh2 =9A =9A8:114 =9A0 =9A 286M =9A0 part =9A
=81 =84=80md0 =9A 9:0 =9A =9A0 285.7M =9A0 raid1 /boot
=86=80sdh3 =9A =9A8:115 =9A0 =9A 7.6G =9A0 part =9A
=81 =84=80md1 =9A 9:1 =9A =9A0 =9A 7.6G =9A0 raid1 [SWAP]
=84=80sdh4 =9A =9A8:116 =9A0 =9A 2.7T =9A0 part =9A
=9A =84=80md2 =9A 9:2 =9A =9A0 =9A 2.7T =9A0 raid1 /
sdi =9A =9A =9A 8:128 =9A0 =9A 2.7T =9A0 disk =9A
=84=80sdi1 =9A =9A8:129 =9A0 =9A 2.7T =9A0 part =9A
sdj =9A =9A =9A 8:144 =9A0 =9A 2.7T =9A0 disk =9A
=84=80sdj1 =9A =9A8:145 =9A0 =9A 2.7T =9A0 part=9A


>>> - i have not removed their superblocks or at least not in a way tha=
t i
>>> amaware of
>>>
>>> - mdadm: 3.2.5-5ubuntu4.1
>>> - uname -a: 3.13.0-24-generic
>>>
> That's a pretty old mdadm version, but I don't see anything in the
> change logs that looks relevant. Others may be more familiar with iss=
ues
> though.

that's the latest in my current ubuntu repository

>
>>>
>>> PS:
>>> I just followed this recovery page:
>>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software=
_RAID
>>> I managed to reach the last step, whenever i tried to mount it kept
>>> asking me for the right file system
>>>
> That's good documentation anyway. As long as you stick to the overlay
> devices your original data is untouched. It's amazing how many people
> run --create on their original disks and lose any chance of getting t=
he
> data back.

unfortunately i used to be/am one of those people.=9A
=9Ahad bad experiences with this before, so i took it slow and went wit=
h the overlay documentation.
all ebooks i could found about raid speak about different between multi=
ple raid levels but none are thorough when it comes to =9Asetting up/tr=
oubleshooting =9Araid.=9A
and once i do fix my issue, i move on to the next firefighting situatio=
n so i lose interest due to lack of time.

>
>> Correction:i couldn't force assemble the read devices so i issued in=
stead:
>> mdadm --create /dev/md089 --assume-clean --level=3D10 --verbose --ra=
id-devices=3D8 missing /dev/dm-1 /dev/dm-0 /dev/dm-5 /dev/dm-3 /dev/dm-=
2 missing /dev/dm-4
>> which got it into degraded state
>>
>
> What error did you get when you tried to force assemble (both from md=
adm
> and anything reported via dmesg)? The device order you're using would
> suggest that the missing disks wouldn't be mirrors of each other, so =
the
> data should be okay.

mdadm --assemble --force /dev/md100 $OVERLAYS
mdadm: /dev/md100 assembled from 5 drives and =9A1 rebuilding - not eno=
ugh to start the array.

dmesg:
[ 6025.573964] md: md100 stopped.
[ 6025.595810] md: bind<dm-0>
[ 6025.596086] md: bind<dm-5>
[ 6025.596364] md: bind<dm-2>
[ 6025.596612] md: bind<dm-1>
[ 6025.596840] md: bind<dm-4>
[ 6025.597026] md: bind<dm-3>




>
> Can you post the --examine results for all the RAID members? Both for
> the original partitions and for the overlay devices after you recreat=
ed
> the array. There may be differences in data offset, etc. which will
> break the filesystem.

Original partitions:
http://pastebin.com/nHCxidvE

overlay:
http://pastebin.com/eva4cnu6

>
> Cheers,
> Robin
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
