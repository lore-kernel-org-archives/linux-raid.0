From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Home desktop/server RAID upgrade
Date: Fri, 30 May 2014 17:58:25 -0300
Message-ID: <CAH3kUhFGWO6w49PHGxDzKEs-dCJBuntey2ote+07jTOp_TbW0A@mail.gmail.com>
References: <CAK2H+ef2YNuy9aoipDjYGWJKMi=soW393dKz00iMN8cUuBd+Og@mail.gmail.com>
	<20140530212907.0b00e8a3@netstation>
	<CAK2H+efDHKGVEdNHUXcDjbHSLKBLDu-DZTTxH9aN2vt+TLHy3A@mail.gmail.com>
	<CAK2H+ee0NqpR=W4sM=hjAgM3vE=9Wx1RLZqT_jRqVvG=Y_Wt0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ee0NqpR=W4sM=hjAgM3vE=9Wx1RLZqT_jRqVvG=Y_Wt0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: "L.M.J" <linuxmasterjedi@free.fr>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

no problem using 3 hdd with raid1
about speed diference:
write speed is the same (slowest disk give the write speed of raid arra=
y)
read speed is the same (each disk have a mb/s rate)
but ... number of hdd heads is diferent, in other words, if you read,
part 1%-20%  40%-60% 90%-100% with 3 threads, you will end faster with
3 disks than with 2 disks
raid1 with many disks give you a better parallel read speed (more
disks =3D more heads =3D more read threads), but write speed is "the sa=
me"
as a single disk

2014-05-30 17:36 GMT-03:00 Mark Knecht <markknecht@gmail.com>:
> On Fri, May 30, 2014 at 1:14 PM, Mark Knecht <markknecht@gmail.com> w=
rote:
>> On Fri, May 30, 2014 at 12:29 PM, L.M.J <linuxmasterjedi@free.fr> wr=
ote:
>>> Le Fri, 30 May 2014 12:04:07 -0700,
>>> Mark Knecht <markknecht@gmail.com> a =C3=A9crit :
>>>
>>>> In a RAID1 would a 3-drive Red
>>>> RAID1 possibly be faster than the 2-drive Se RAID1 and at the same
>>>> time give me more safety?
>>>
>>> Just a question inside the question : how do you manager a RAID1 wi=
th 3 drives ? Maybe you're talking about
>>> RAID5 then ?
>>
>> OK, I'm no RAID expert but RAID1 is just drives in parallel right. 2
>> drives, 3 drives, 4 drives, all holding exactly the same data. In th=
e
>> case of a 3-drive RAID1 - if there is such a beast - I could safely
>> lose 2 drives. You ask a reasonable question though as maybe the way
>> this is actually done is 2 drives + a hot spare in the box that gets
>> sync'ed if and only if one drive fails. Not sure and maybe I'm total=
ly
>> wrong about that.
>>
>> A 3-drive RAID5 would be 2 drives in series - in this case making 6T=
B
>> - and then the 3rd drive being the redundancy. In the case of a
>> 3-drive RAID5 I could safely lose 1 drive.
>>
>> In my case I don't need more than 3TB, so an option would be a 3-dri=
ve
>> RAID5 made out of 2TB drives which would give me 4TB but I don't nee=
d
>> the space as much as I want the redundancy and I think RAID5 is slow=
er
>> than RAID1. Additionally some more mdadm RAID knowledgeable people o=
n
>> other lists say Linux mdadm RAID1 would be faster as it will get dat=
a
>> from more than one drive at a time. (Or possibly get data from which
>> ever drive returns it the fastest. Not sure.)
>>
>> I believe one good option if I wanted 4 physical drives would be
>> RAID10 but that's getting more complicated again which I didn't real=
ly
>> want to do.
>>
>> So maybe it is just 2 drives and the 3 drive version isn't even a
>> possibility? Could be.
>
> Using the instructions here:
>
> http://sempike.blogspot.com/2012/06/linux-software-raid-mdadm-with-vi=
rtual.html
>
> I just built a 3 device RAID1 using loop devices and it seems to have
> worked. Below md50 did not exist, I created it as a 3 device RAID1 an=
d
> then mdadm shows it's there. I have no idea if it's a good thing to d=
o
> but mdadm doesn't stop me. I would need to test other real things lik=
e
> putting a file system on it, mounting it, etc., to be more confident
> but this much seems to work fine.
>
> Great question and good experience for me doing this. Thanks!
>
> Cheers,
> Mark
>
>
> c2RAID6 loopraid # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md3 : active raid6 sdb3[9] sdf3[5] sde3[6] sdd3[7] sdc3[8]
>       1452264480 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/=
5] [UUUUU]
>
> unused devices: <none>
> c2RAID6 loopraid # mdadm --create /dev/md50 --level=3D1 --raid-device=
s=3D3
> /dev/loop[012]
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=3D0.90
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md50 started.
> c2RAID6 loopraid # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md50 : active raid1 loop2[2] loop1[1] loop0[0]
>       20416 blocks super 1.2 [3/3] [UUU]
>
> md3 : active raid6 sdb3[9] sdf3[5] sde3[6] sdd3[7] sdc3[8]
>       1452264480 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/=
5] [UUUUU]
>
> unused devices: <none>
> c2RAID6 loopraid #
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
