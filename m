From: "Majed B." <majedb@gmail.com>
Subject: Re: 2 Disks Jumped Out While Reshaping RAID5
Date: Mon, 7 Sep 2009 19:34:18 +0300
Message-ID: <70ed7c3e0909070934j216cfd5etd61293ee01b72bd3@mail.gmail.com>
References: <70ed7c3e0909051322l7cf66158lbbc8a5dd2cc18b8b@mail.gmail.com>
	<a6dfa0829c75cc81fd4482bb344bbff2.squirrel@neil.brown.name>
	<70ed7c3e0909060300la51bec3ke51c35373b2ee1fc@mail.gmail.com>
	<19108.19281.495223.465327@notabene.brown> <70ed7c3e0909061655u344c2c6dt1939f85b10f49fa0@mail.gmail.com>
	<70ed7c3e0909061701i4190642ew66827a3aca3c277e@mail.gmail.com>
	<3b8699b874ea2645458f9295812270a5.squirrel@neil.brown.name>
	<70ed7c3e0909061744h52b9fe77o5dac310e983d2252@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909061744h52b9fe77o5dac310e983d2252@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A little update on the situation:

After uninstalling mdadm 2.6.7.1 which ships with Ubuntu 9.04, and
installing mdadm 3.0, I got this:

root@Adam:~# cat /proc/mdstat
Personalities :
unused devices: <none>

I'm guessing that happened because initram tools was removed when
uninstalling the old mdadm. No problem, I'll just assemble the array
on boot (through a line in /etc/rc.local).

I then proceeded to assemble the array, but it refused:
root@Adam:~# mdadm -Af --verbose /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sdi5: Device or resource busy
mdadm: /dev/sdi5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdi2
mdadm: /dev/sdi2 has wrong uuid.
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: /dev/sdi1 has wrong uuid.
mdadm: cannot open device /dev/sdi: Device or resource busy
mdadm: /dev/sdi has wrong uuid.
mdadm: no RAID superblock on /dev/sdh
mdadm: /dev/sdh has wrong uuid.
mdadm: superblock on /dev/sdg1 doesn't match others - assembly aborted

Since sdg1 has flunked out before, I just zeroed its superblock to add
it later, if it wasn't dead:

root@Adam:~# mdadm --zero-superblock /dev/sdg
mdadm: Unrecognised md component device - /dev/sdg
root@Adam:~# mdadm --zero-superblock /dev/sdg1
root@Adam:~# mdadm --zero-superblock /dev/sdg1
mdadm: Unrecognised md component device - /dev/sdg1

The array assembled properly after that (with 7 out 8 disks -- running
degraded):
root@Adam:~# mdadm -Af --verbose /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sdi5: Device or resource busy
mdadm: /dev/sdi5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdi2
mdadm: /dev/sdi2 has wrong uuid.
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: /dev/sdi1 has wrong uuid.
mdadm: cannot open device /dev/sdi: Device or resource busy
mdadm: /dev/sdi has wrong uuid.
mdadm: no RAID superblock on /dev/sdh
mdadm: /dev/sdh has wrong uuid.
mdadm: no RAID superblock on /dev/sdg1
mdadm: /dev/sdg1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg
mdadm: /dev/sdg has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 4.
mdadm: added /dev/sde1 to /dev/md0 as 1
mdadm: added /dev/sdc1 to /dev/md0 as 2
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: added /dev/sda1 to /dev/md0 as 4
mdadm: added /dev/sdh1 to /dev/md0 as 5
mdadm: added /dev/sdb1 to /dev/md0 as 6
mdadm: added /dev/sdd1 to /dev/md0 as 7
mdadm: added /dev/sdf1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 7 drives (out of 8).
root@Adam:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdf1[0] sdd1[7] sdb1[6] sdh1[5] sda1[4] sdc1[2] sde1=
[1]
      6837318656 blocks level 5, 256k chunk, algorithm 2 [8/7] [UUU_UUU=
U]

unused devices: <none>


After some poking, I'm suspecting the MSI motherboard itself, since
the problems happens to disks that are on ports 7 and 8 on the
motherboard, and those two ports have their own controller and they
share a single bus.

I've ordered an EVGA motherboard that should arrive in a week or so.
I'll update later when I move the hard disks to it and add that sdg
disk.

Thanks again Neil for your help :)

On Mon, Sep 7, 2009 at 3:44 AM, Majed B.<majedb@gmail.com> wrote:
> Thanks a lot Neil for your help :)
>
> kernel logs showed a SATA link error for sdg. I double checked the
> cables and they were more than fine and the array was running for
> weeks before I did the reshaping and no errors were reported before
> the reshaping process.
>
> I'm using an MSI motherboard (MS-7514) and been having random issues
> with it since reaching 6 disks. I've recently ordered an EVGA
> motherboard and if things turn to be stable on it, I'll ditch MSI for
> good.
>
> Throughout searching for the past 6 days, I noticed people complainin=
g
> from acpi and apic causing issues, so I turned them off and will see
> how things turn out.
>
> These are the hard disks I'm using:
>
> root@Adam:~# hddtemp /dev/sd[a-h]
> /dev/sda: WDC WD10EACS-00D6B1: 26=C2=B0C
> /dev/sdb: WDC WD10EACS-00D6B1: 28=C2=B0C
> /dev/sdc: WDC WD10EACS-00ZJB0: 29=C2=B0C
> /dev/sdd: WDC WD10EADS-65L5B1: 27=C2=B0C
> /dev/sde: WDC WD10EADS-65L5B1: 28=C2=B0C
> /dev/sdf: MAXTOR STM31000340AS: 28=C2=B0C
> /dev/sdg: WDC WD10EACS-00ZJB0: 26=C2=B0C
> /dev/sdh: WDC WD10EADS-00L5B1: 25=C2=B0C
> /dev/sdi: Hitachi HDS721680PLAT80: 32=C2=B0C
>
> (sdi is the OS disk)
>
> Neil, do you suggest any certain test/stress-tests to put sdg through=
?
>
> I'll force a couple of short and long smartd tests on it, and have dd
> read the whole disk a couple of times to make sure all sectors are
> read properly. Is that sufficient?
>
> Thank you again.
>
> On Mon, Sep 7, 2009 at 3:31 AM, NeilBrown<neilb@suse.de> wrote:
>> On Mon, September 7, 2009 10:01 am, Majed B. wrote:
>>> I have installed mdadm 3.0 and ran -Af and now it's continuing
>>> reshaping!!!
>>
>> Excellent.
>>
>> Based on the --examine info you provided it appears that
>> /dev/sdg1 reported an error at about 00:10:39 on Wednesday morning
>> and was evicted from the array. =C2=A0Reshape was up to 2435GB (37%)=
 at
>> that point.
>> Reshape continued until 06:40:04 that morning at which point it
>> had reached 3201GB (49%). =C2=A0At that point /dev/sdf1 seems to hav=
e
>> reported an error so the whole array went off line.
>>
>> When you reassembled with mdadm-3.0 and --force, it excluded sdg1
>> as that was the oldest, and marked sdf1 as up-to-date, and continued=
=2E
>>
>> The reshape processes will have redone the last few chunks so all
>> the data will have been properly relocated.
>>
>> As all the superblocks report that the array was "State : clean",
>> you can be quite sure that all your data is safe (if they were
>> "State : active" there would be a small chance some a block or two
>> was corrupted and a fsck etc would be advised).
>>
>> It wouldn't hurt to examine your kernel logs to see what sort of
>> error was tiggered at those two times in case there might be a need
>> to replace a device.
>>
>>
>>
>>
>>> sdg1 is not in the list. Is that correct?! =C2=A0sdg1 was one of th=
e
>>> array's disks before expanding. So I guess now the array is degrade=
d
>>> yet is reshaping as if it had 8 disks, correct?
>>
>> Yes, that is correct.
>> It may be that sdg has a transient error, or it may have a serious
>> media or other error. =C2=A0You should convince yourself that it is =
working
>> reliably before adding it back in to the array.
>>
>>
>>
>>>
>>> So after the reshaping process is over, I can add sdg1 again and it
>>> will resync properly, right?
>>
>> Yes it will, providing no write-errors occur while writing data to i=
t.
>>
>> NeilBrown
>>
>>
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0 Majed B.
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
