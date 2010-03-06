From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Removing drives
Date: Fri, 5 Mar 2010 22:43:28 -0800
Message-ID: <4877c76c1003052243r790e0528v71efe38038bfafeb@mail.gmail.com>
References: <4B8F26AF.7080308@vorgon.com>
	 <4877c76c1003041445g2ac9aaf6ua5fac64db975da1@mail.gmail.com>
	 <4B9154C0.7060200@vorgon.com>
	 <4877c76c1003051222i584bdb19r65002981060a6360@mail.gmail.com>
	 <4B91DF69.5030804@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B91DF69.5030804@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 5, 2010 at 8:51 PM, Timothy D. Lenz <tlenz@vorgon.com> wrot=
e:
>
>
> On 3/5/2010 1:22 PM, Michael Evans wrote:
>>
>> On Fri, Mar 5, 2010 at 11:00 AM, Timothy D. Lenz<tlenz@vorgon.com> =A0=
wrote:
>>>
>>> Current setup, 3 500gb sata drives, each with 3 partitions.
>>> The first partition of each drive make up raid1 md0 boot and most
>>> software
>>> The next partition of each drive make up raid1 md1 swap
>>> The 3rd partition of each drive make up raid5 md2 main data storage
>>>
>>> There is also a 40gb ide drive with 2 partitions, boot/software and=
 swap.
>>> It
>>> was used for install and setup. But I never got boot changed over t=
o md0.
>>> So
>>> currently md0 is not in use. md0 and md2 are mounted to folders on =
the
>>> 40gb
>>> so a precopy to md0 could be made before booting with a cd and copy=
ing
>>> what
>>> ever is left that needs coping. and to use md2.
>>>
>>> Current
>>> # /etc/fstab: static file system information.
>>> #
>>> #<file system> =A0<mount point> =A0 =A0 <type> =A0 =A0<options> =A0=
 =A0 =A0 =A0 <dump>
>>> =A0<pass>
>>> proc =A0 =A0 =A0 =A0 =A0 =A0/proc =A0 =A0 =A0 =A0 =A0 proc =A0 =A0d=
efaults =A0 =A0 =A0 =A00 =A0 =A0 =A0 0
>>> /dev/hda1 =A0 =A0 =A0 / =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3 =A0 =A0def=
aults,errors=3Dremount-ro 0
>>> =A0 1
>>> /dev/hda5 =A0 =A0 =A0 none =A0 =A0 =A0 =A0 =A0 =A0swap =A0 =A0sw =A0=
 =A0 =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 0
>>> /dev/md0 =A0 =A0 =A0 =A0/mnt/md0 =A0 =A0 =A0 =A0ext3 =A0 =A0default=
s =A0 =A0 =A0 =A00 =A0 =A0 =A0 0
>>> /dev/md2 =A0 =A0 =A0 =A0/mnt/md2 =A0 =A0 =A0 =A0ext3 =A0 =A0default=
s =A0 =A0 =A0 =A00 =A0 =A0 =A0 0
>>> /dev/hdb =A0 =A0 =A0 =A0/media/cdrom0 =A0 udf,iso9660 user,noauto =A0=
 =A0 0 =A0 =A0 =A0 0
>>> /dev/fd0 =A0 =A0 =A0 =A0/media/floppy0 =A0auto =A0 =A0rw,user,noaut=
o =A00 =A0 =A0 =A0 0
>>>
>>> I want to change md0 and md1 from 3 drive mirriors to 2 drive mirro=
rs.
>>>
>>> Finish changing over to booting from md0, move swap to md1 and move=
 the
>>> mount point for md2 to md0
>>>
>>> Remove the the ide drive to free up space for the 4th 500gb drive.
>>>
>>> Copy md2 over to the new 500gb temparally.
>>>
>>> Get rid of the current md2 freeing up the 3rd drive since it was al=
ready
>>> taken out of the mirrors above.
>>>
>>> Make a new md2 raid1 with the remaining space of the first 2 sata d=
rives.
>>>
>>> Move the data from the 4th drive back to the new md2
>>>
>>> Repartition the 3rd drive to 1 partition same as the 4th drive.
>>>
>>> Make raid1 md3 from the 3rd and 4th drives.
>>>
>>> It's the steps/commands to change md0 and md1 from 3 drive mirrors =
to 2
>>> drive mirrors that I'm not sure about. Though now looking at fstab =
I see
>>> I
>>> never even switched over the swap. So I guess, those to arrays woul=
d be
>>> rebuilt. So it's more how to do that without messing with md2.
>>>
>>> The computer is still on grub1. I haven't updated it it.
>>>
>>
>> So you have:
>>
>> [3-devices]
>> Raid 1: Unused
>> Raid 1: Unused
>> Raid 5: Used - 3 disks
>>
>> [1-device]
>> Boot + swap
>>
>> Just swapoff the raid-swap you want to re-create, then:
>> mdadm -S /dev/md(swap)
>> mdadm -S /dev/md(boot)
>> mdadm --zero-superblock /dev/devices in those arrays
>>
>> Repartition those two areas of the disks as necessary.
>>
>> Create new boot and swap partitions.
>> For boot make SURE you use either -e 0.90 OR -e 1.0 . =A0 Given the
>> nature of /boot I'd say use -e 0.90 on it.
>> For everything else, including swap use -e 1.1 and optionally
>> write-intent bitmaps.
>>
>> At this point you should be able to move /boot and your swap off of
>> the 40gb drive; just remember to re-install grub and that your BIOS
>> likely sets the boot drive as bios-drive 0 regardless of which SDA/H=
DA
>> linux sees it as. =A0This is what the device.map file is used to tel=
l
>> grub.
>>
>>
>> I lost exactly what you wanted the result to look like amid a long
>> list of steps you /thought/ you needed to make to get there and
>> references to md numbers that only have meaning to you. =A0However i=
t
>> seems that you were mostly stuck getting to this point, so you might
>> be able to determine a plan using the data you've yet to share with
>> the rest of us with that 40gb drive out of the equation.
>>
>> Remember that you can't reshape raid10 yet, but you can start raid10
>> with 'missing' devices (and add in the spares later).
>>
>
> can't make it much clearer, and I don't know where you got raid10 fro=
m.
>
> ARRAY /dev/md0 level=3Draid1 num-devices=3D3
> UUID=3De4926be6:8d6f08e5:0ab6b006:621c4ec0
> ARRAY /dev/md1 level=3Draid1 num-devices=3D3
> UUID=3Deac96451:66efa3ab:0ab6b006:621c4ec0
> ARRAY /dev/md2 level=3Draid5 num-devices=3D3
> UUID=3Da7ed721e:04b10ab6:0ab6b006:621c4ec0
>
> md 0 and 1 I want to change to 2 deivces.
> Then get it booting from md0 which I think I know how to do as I got =
another
> computer working that way. Then I can dump the ide drive making room =
for
> another 500gb sata. It will be used to store the data from md2 while =
md2 is
> remade from a 3 device raid5 to a 2 device raid1. This frees up a dri=
ve
> giving me 2 500gb drives to make another 2 device raid1. Its the sepe=
rating
> out 1 device from each of the current raid1's, md0 and md1 that I was=
 asking
> about.
>

That was concise enough to be worth reading through to get your desired=
 result.

I already told you how to do the safe portion of your last operation.

Actually, I can see one benefit from two raid 1s over raid10; you
could stripe them using LVM and for very little extra cost have a lot
more flexibility.

After you've followed my last email to get the system booting off your
raid devices, you can replace the 40 with a 500, and then use the
/new/ 500 to start a raid 1 with one device set as 'missing'.
StartSlower but totally safe way:

However what I'd do if I were you is get everything I could off of the
40gb drive; it would only take 10 DVDs at worse case; presuming it
won't fit within ~500gb.

1) Duplicate all your data from the raid5 on to the single disk in a
raid 1 + missing configuration.
* you now have 1 copy with parity, and 1 copy waiting for mirroring.
(two copies and some parity)

2) Fail one of the partitions from the raid5, --zero superblock it.
* you now have 1 copy without parity, and 1 copy waiting for
mirroring, and one free drive. (two copies)

3) --add the previous parity partition as part of the mirror set; IT
MUST BE >=3D the size of the other partition in that mirror.
* You have 1 copy without parity, 1 full copy being mirrored in to two =
copies.

4) WAIT for the mirroring operation to finish.

5) Optionally 'check' the mirror copy.
* You now have 1 copy without parity, 1 fully mirrored copy (3 copies
of your data)

6) With a fully safe copy of your data, and two partitions you can
start a wider range of procedures.

You could create two more raid 1 + missing arrays
setup LVM with striping across them
copy your data over in to one logical volume
++THEN AGAIN in to a second logical volume
(Manually creating two copies of your data; this won't protect against
drive failure but it will protect against individual failed sectors,
which may be good enough.)
=46inally one at a time fail out members of the intact raid1 set and ad=
d
them to the new raid 1s.


Or probably proceed through other ideas; though none seems as
appealing to me as what I just wrote; 4 drives isn't enough to
seriously consider raid 5 or 6, and with the size of the drives you'd
really be better off with going for raid 6, which is much slower and
only slightly less risky than raid 1 + striping via LVM.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
