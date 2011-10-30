From: Michael Busby <michael.a.busby@gmail.com>
Subject: Re: Unable to restart reshape
Date: Sun, 30 Oct 2011 22:15:43 +0000
Message-ID: <CAFsPQ__+ofSpEy57Ly_u_NkCf94BJ49+_mcqWb7SPMnaSdQyMA@mail.gmail.com>
References: <CAFsPQ_-EdKXHjwodOnqt3TSJFS73Wgv0EXXe81nriBFJU5DV2w@mail.gmail.com>
	<CAFsPQ_9Bg=pJpbtyKF2G4oT2p6QHZhZ3gm-ZLQhG3yDjwDoSTQ@mail.gmail.com>
	<CAFsPQ__+n+Y8G6TUH1+6zYxaxd2AK+--N6FnRw8rQx-BRJA0ag@mail.gmail.com>
	<CAFsPQ_9DQ26S7ePcruN+M0H3RZiFnQK34u4W25WLDPZ48+6f-A@mail.gmail.com>
	<CAFsPQ__MtwQvgiJ+BsZg0sGky6GstbHEHneuzs86zSKNfrt8CA@mail.gmail.com>
	<20111030230215.Horde.zF2Mdpk8pphOrclnrmpTWiA@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111030230215.Horde.zF2Mdpk8pphOrclnrmpTWiA@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Alexander_K=FChn?= <alexander.kuehn@nagilum.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>>> I have a system the was doing a reshape from RAID5 to 6, the sys=
tem
>>>>>> had to be powered off this morning and moved, upon restarting th=
e
>>>>>> server i issued the following command to continue the reshape
>>>>>>
>>>>>> =A0mdadm -A /dev/md0 --backup-file=3D/home/md.backup
>>>>>>
>>>>>> i get back to following error
>>>>>>
>>>>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>>>>
>>>>>> any idea why?
>>>>>>
>>>>>> before shutting down cat /proc/mdstat showed
>>>>>>
>>>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [ra=
id5]
>>>>>> [raid4] [raid10]
>>>>>> md0 : active raid6 sdf[0] sdb[6](S) sda[4] sdc[3] sde[2] sdd[1]
>>>>>> =A0 =A0 7814055936 blocks super 1.0 level 6, 512k chunk, algorit=
hm 18
>>>>>> [6/5] [UUUUU_]
>>>>>> =A0 =A0 [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>......] =A0r=
eshape =3D 70.8% (1384415232/1953513984)
>>>>>> finish=3D3658.6min speed=3D2592K/sec
>>>>>>
>>>>>> but now it shows
>>>>>>
>>>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [ra=
id5]
>>>>>> [raid4] [raid10]
>>>>>> md0 : inactive sdc[3] sdb[6](S) sde[2] sdd[1] sdf[0]
>>>>>> =A0 =A0 =A09767572240 blocks super 1.0
>>>>>>
>>>>>> i am totally confused, it seems to have lost a drive from the ra=
id,
>>>>>> and the number of blocks is incorrect
>>>>>>
>>>>>
>>>>> issuing the following
>>>>>
>>>>> =A0mdadm -Avv --backup-file=3D/home/md.backup /dev/md0
>>>>>
>>>>> returns
>>>>>
>>>>>
>>>>> mdadm: looking for devices for /dev/md0
>>>>> mdadm: cannot open device /dev/sda5: Device or resource busy
>>>>> mdadm: /dev/sda5 has wrong uuid.
>>>>> mdadm: no RAID superblock on /dev/sda2
>>>>> mdadm: /dev/sda2 has wrong uuid.
>>>>> mdadm: cannot open device /dev/sda1: Device or resource busy
>>>>> mdadm: /dev/sda1 has wrong uuid.
>>>>> mdadm: cannot open device /dev/sda: Device or resource busy
>>>>> mdadm: /dev/sda has wrong uuid.
>>>>> mdadm: /dev/sdg is identified as a member of /dev/md0, slot -1.
>>>>> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 4.
>>>>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
>>>>> mdadm: /dev/sde is identified as a member of /dev/md0, slot 0.
>>>>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
>>>>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 3.
>>>>> mdadm:/dev/md0 has an active reshape - checking if critical secti=
on
>>>>> needs to be restored
>>>>> mdadm: backup-metadata found on /home/md.backup but is not needed
>>>>> mdadm: Failed to find backup of critical section
>>>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>>>
>>>>
>>>> seem the above was trying at use the wrong disks to assemble, so u=
sing
>>>> the following
>>>>
>>>> mdadm -Avv /dev/md0 --backup-file=3D/home/md.backup /dev/sd[abcdef=
]
>>>>
>>>> =A0mdadm: looking for devices for /dev/md0
>>>> mdadm: /dev/sda is identified as a member of /dev/md0, slot 4.
>>>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot -1.
>>>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 3.
>>>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 1.
>>>> mdadm: /dev/sde is identified as a member of /dev/md0, slot 2.
>>>> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 0.
>>>> mdadm:/dev/md0 has an active reshape - checking if critical sectio=
n
>>>> needs to be restored
>>>> mdadm: backup-metadata found on /home/md.backup but is not needed
>>>> mdadm: Failed to find backup of critical section
>>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>>
>>>
>>> have now upgraded to mdadm 3.2.2
>>>
>>> and get a little more info
>>>
>>> mdadm -Avv /dev/md0 --backup-file=3D/home/md.backup /dev/sd[abcdef]
>>>
>>> mdadm: looking for devices for /dev/md0
>>> mdadm: /dev/sda is identified as a member of /dev/md0, slot 4.
>>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot -1.
>>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 3.
>>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 1.
>>> mdadm: /dev/sde is identified as a member of /dev/md0, slot 2.
>>> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 0.
>>> mdadm: device 6 in /dev/md0 has wrong state in superblock, but /dev=
/sdb
>>> seems ok
>>> mdadm:/dev/md0 has an active reshape - checking if critical section
>>> needs to be restored
>>> mdadm: backup-metadata found on /home/md.backup but is not needed
>>> mdadm: Failed to find backup of critical section
>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>
>>
>>
>> Ok, i dont know if this is the right thing to have done
>>
>> ~# mdadm -Avv --force /dev/md0 --backup-file=3D/home/md.backup
>> /dev/sd[abcdef]
>>
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sda is identified as a member of /dev/md0, slot 4.
>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot -1.
>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 3.
>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 1.
>> mdadm: /dev/sde is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 0.
>> mdadm: clearing FAULTY flag for device 1 in /dev/md0 for /dev/sdb
>> mdadm: Marking array /dev/md0 as 'clean'
>> mdadm:/dev/md0 has an active reshape - checking if critical section
>> needs to be restored
>> mdadm: backup-metadata found on /home/md.backup but is not needed
>> mdadm: Failed to find backup of critical section
>> mdadm: Failed to restore critical section for reshape, sorry.
>>
>>
>> ~# mdadm -Avv /dev/md0 --backup-file=3D/home/md.backup /dev/sd[abcde=
f]
>>
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sda is identified as a member of /dev/md0, slot 4.
>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot -1.
>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 3.
>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 1.
>> mdadm: /dev/sde is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 0.
>> mdadm:/dev/md0 has an active reshape - checking if critical section
>> needs to be restored
>> mdadm: restoring critical section
>> mdadm: added /dev/sdd to /dev/md0 as 1
>> mdadm: added /dev/sde to /dev/md0 as 2
>> mdadm: added /dev/sdc to /dev/md0 as 3
>> mdadm: added /dev/sda to /dev/md0 as 4
>> mdadm: no uptodate device for slot 5 of /dev/md0
>> mdadm: added /dev/sdb to /dev/md0 as -1
>> mdadm: added /dev/sdf to /dev/md0 as 0
>> mdadm: /dev/md0 has been started with 4 drives (out of 6) and 1 spar=
e.
>>
>> ~# cat /proc/mdstat
>>
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md0 : active raid6 sdf[0] sdb[6](S) sdc[3] sde[2] sdd[1]
>> =A0 =A0 =A07814055936 blocks super 1.0 level 6, 512k chunk, algorith=
m 18
>> [6/4] [UUUU__]
>> =A0 =A0 =A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>......] =A0re=
shape =3D 74.3% (1452929024/1953513984)
>> finish=3D2545.2min speed=3D3276K/sec
>>
>> unused devices: <none>
>>
>> so looks like its carrying on now but with 4 disks and a spare, mayb=
e
>> i can add the other disk once the reshape has finished
>
> It generally helps to include/examine "mdadm -E /dev/sdX" of all devi=
ces
> involved in your mail(s) and also "mdadm -Q --detail /dev/md0".
> After the reshape is done it will automatically rebuild using the spa=
re.
> Then you can have a close look which of your devices arent used, clea=
r the
> metadate from the device and add it as well to regain full redundancy=
=2E
> You'll have plenty hours of fun watching /proc/mdstat. ;)
> Alex.
>

Thanks for the response Alex, the reshape has got about 2400mins left
to run and no idea how long the rebuild will take..

I will check out those commands once i am back up and running, i am
fairly new to mdadm so still finding out all the useful commands when
trouble shooting issues, thanks for pointing these out to me
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
