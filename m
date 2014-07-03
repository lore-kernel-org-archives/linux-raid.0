From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Thu, 03 Jul 2014 09:29:04 +0100
Message-ID: <20140703092904.Horde.PWB1KPYRo99TtRRQFNkmJ5A@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702204502.6b538fa8@notabene.brown>
 <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
 <20140703124046.74272588@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140703124046.74272588@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

    Thanks for the very informative answer, that nailed it, and Ethan =20
was obviously onto it too!

    I tried running the commands you posted and it gives me an error:

    bb.sh
    "
    =C2=A0 sed 's/^/-/' /sys/block/md0/md/dev-sdq/bad_blocks
    =C2=A0 while read; do
    =C2=A0=C2=A0=C2=A0=C2=A0 echo $a > /sys/block/md0/md/dev-sdq/bad_bl=
ocks
    =C2=A0 done
    "
    root@nas3:~# ./bb.sh
    -211996592 128
    ./bb.sh: line 3: echo: write error: Invalid argument
    "
    Can you help me with this?

    I will clear all the bad blocks on all the drives and force a =20
repair and see if some error shows up.=C2=A0 If not, I will then fsck t=
he =20
filesystem.

    I'm not sure how the volume failed. On one friday morning ( past =20
month ) I checked the system and everything was ok ( no dmesg errors =20
and mdastat repoted all disks up ). next monday I got a call telling =20
me that the volume was inacessible. When I got back the next thursday, =
=20
the machine had already  been rebooted and the md0 volume had three =20
failed disks. I did a --examine and two of them were completly off in =20
terms of events regarding the non-failed disks. the other one was much =
=20
more close, but still a bit off. Not close enough to do a --assemble =20
--force, so I recreated the array with something like this:

"mdadm --create --assume-clean --level=3D6 --raid-devices=3D16 =20
--name=3Dnas3:Datastore --uuid=3D9e97c588:59135324:c7d3fdf6:e543bdc3 =20
/dev/md0 /dev/sde /dev/sdc /dev/sdd /dev/sdb /dev/sdf /dev/sdg =20
/dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl missing /dev/sdn missing =20
/dev/sdp /dev/sdq". I think the last failed drive was sdl or sdn, =20
can't remember.


then I cleared the superblocks on the missing disks and readded them. =20
Then I fsck'd the filesystem and I started getting those errors. I =20
since then replaced them with new disks and tested the old ones only =20
to find that they have no smart errors reported ( smart is enabled in =20
bios ) and I also did a read-write test to them and I found them to be =
=20
ok.

I will rebuild this machine next weekend, or the one after that, to =20
try to sort out some hardware problem or issues with the cabling, but =20
I am inclined to say that maybe it's related to the sshd's.


Cheers
Pedro


    Citando NeilBrown <neilb@suse.de>:
> On Wed, 02 Jul 2014 12:54:34 +0100 Pedro Teixeira <finas@aeiou.pt> wr=
ote:
>> cpu is a phenom x6, 8gb ram. controller is LSI 9201-i16. hdd's are
>>    seagate sshd ST1000DX001.
>>
>>    So I run the "dd if=3D/dev/md0 of=3D/dev/null=C2=A0 bs=3D4096" an=
d it failed on
>>    alot of places. I had to restart the command several times with t=
he
>>    skip parameter set to a couple of blocks after the last block err=
or.
>>    It run for about 1.5TB of the total 13TB of the volume.
>>    The md volume didn't drop any drive when running this.
>>
>>    dmesg showed:
>>
>>    [ 1678.478156] Buffer I/O error on device md0, logical block 1960=
12546
>   I love numbers, thanks.
>   The logical block size is 4096, or 8 sectors (1 sector is defined a=
s 512
>   bytes), so this is at
>   196012546*8 =3D=3D 1568100368 sectors into the array.
>
>   The array has a chunksize of 512K, or 1024 sectors so
>   196012546*8/1024 =3D 1531348.015625
>
>   gives us the chunk number, and the remaining fraction of a chunk.
>
>   The RAID6 has 16 devices, so there are 14 data chunks in each strip=
e, so to
>   find where the above chunk is stored we divide by 14
>
>   =C2=A0 1531348/14 =3D 109382.0000
>
>   So that is chunk 109382 on the first device (though with rotating d=
ata,
>   it might not be the very first).
>
>   Add back in the factional part, multiple by 1024 sectors per chunk,=
 and add
>   the Data Offset,
>
>   109382.01562500*1024+262144 =3D 112269328
>
>   So it seems that sector 112269328 on some device is bad.
>> The command "mdadm --examine-badblocks /dev/sd[bcdefghijklmnopqr] >>
>>    raid.b" before and after running the "dd" command returned no cha=
nges:
>   I didn't notice the fact that the bad block logs were not empty =20
> before, sorry.
>   Anyway:...  > Bad-blocks on /dev/sdb:
>>    =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 112269328 for 512 secto=
rs
>   Look at that - exactly the number I calculated.=C2=A0 I love it whe=
n that works
>   out.
>
>   So the problem is exactly that some blocks are thought by md to be =
bad.
>
>
>   Blocks get recorded as bad (for raid6) when:
>
>   - a 'read' reported an error which could not be fixed, either
>   =C2=A0 because the array was degraded so the data could not be reco=
vered,
>   =C2=A0 or because the attempt to write restored data failed
>   - when recovering a spare, if the data to be written cannot be =20
> found (due to
>   =C2=A0 errors on other devices)
>   - when a 'write' request to a device fails
>
>   When your array had three failed devices, some reads and writes wou=
ld have
>   failed.=C2=A0 Maybe that caused the bad blocks to be recorded.
>   What sort of devices failures where they?=C2=A0 If the device becam=
e completely
>   inaccessible, then it would not have been possible to record the ba=
d block
>   information.
>
>   Can you describe the sequence of events that lead to the three fail=
ures?
>   When you put the array back together, did you --create it, or --ass=
emble
>   --force?
>
>   There isn't an easy way to remove the bad block list, as doing so =20
> is normally
>   asking for data corruption.
>   However it is probably justified in your case.
>   As it happens I included code in the kernel to make it possible to =
=20
> remove bad
>   blocks from the list - it was intended for testing only but I never=
 removed
>   it.
>   If you run
>   sed 's/^/-/' /sys/block/md0/md/dev-sdq/bad_blocks |
>   while read; do
>   =C2=A0 =C2=A0 echo $a > /sys/block/md0/md/dev-sdq/bad_blocks
>   done
>
>   then it should clear all of the bad blocks recorded=C2=A0 on sdq.
>   You should probably fail/remove the last two devices that you added=
 to the
>   array before you do this, as they probably don't have properly upto=
date
>   information and doing this will cause corruption.
>
>   I probably need to think about better ways to handle the bad block =
lists.
>   NeilBrown

_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
