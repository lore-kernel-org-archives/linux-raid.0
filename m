From: Dawning Sky <the.dawning.sky@gmail.com>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Mon, 8 Feb 2010 23:39:02 -0800
Message-ID: <adf93d751002082339m4493166fo3f9d0ffe6a2c1eb4@mail.gmail.com>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
	 <adf93d751002082020t642cb1d3ne3d3f5fe5d57e7b5@mail.gmail.com>
	 <4B710745.7020200@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B710745.7020200@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the good advice.  ddrescue on sdb returned an error of 4kB.
 I do still have my old sde.  But one thing I did, which was stupid,
was trying to rebuild the raid-5 when it was mounted.  So I don't know
the old sde is still consistent with the rest 3 disks, since some
files would have been modified between the times when I took the old
sde offline and when the rebuild failed.

So at this point, I guess I'll get 4 new drives and set up a brand new
raid-6 and try to restore my data from my backup in an external drive
and hope for the best.  I'll keep the 4 drives from my old raid-5 just
in case if I need to recover something from them.

I guess I learned my lesson.  I should have ddrescued all the disks I
want to replace, instead of using md's rebuild mechanism.

DS


On Mon, Feb 8, 2010 at 10:57 PM, Stefan H=FCbner
<stefan.huebner@stud.tu-ilmenau.de> wrote:
> Hi!
>
> I do RAID-recoveries at least once a month and get paid for it. =A0Ru=
le of
> thumb: if your have one drive dropped and another one with pending
> sectors, your rebuild will fail - no need for calculations there.
>
> ddrescue on a clean disk is about half as fast as dd with a blocksize
> beyond 1M. =A0ddrescue on a disk with pending sectors is just no pita=
 as
> dd or sg_dd would be, because it adds the neccesary intelligence.
>
> Do you have the original sde still around? =A0If yes, ddrescue both: =
sdb
> and sde. =A0My experience says: there will only be a few KB lost. =A0=
Then
> re-create your raid (it will only write the superblock new) with
> "--assume-clean". =A0After that worked, you might make another (big)
> backup first, then run fsck and see what happens. =A0If the lost byte=
s
> have screwed the filesystem, you might want to re-create the raid wit=
h
> another (personally I prefer xfs) fs and replay your backup into it.
>
> A few commands to make the intentions cleaner:
> ddrescue -dv -r5 /dev/oldsdb1 /dev/newsdb1 /root/sdblog
> ddrescue -dv -r5 /dev/oldsde1 /dev/newsde1 /root/sdelog
> ... find out which drive is which raid-device -> mdadm -E /dev/sdX1
> mdadm --create /dev/md0 --raid-devices=3D4 --level=3D5
> --chunk=3D${your_chunk_size_in_kb} --assume-clean
> ${ordered_list_of_raid_devices}
>
> Hope this helps,
> Stefan H=FCbner
>
>
> Am 09.02.2010 05:20, schrieb Dawning Sky:
>> On Mon, Feb 8, 2010 at 3:23 PM, Dawning Sky <the.dawning.sky@gmail.c=
om> wrote:
>>
>>> Hi,
>>>
>>> Now I have two faulty drives and things don't look good. =A0However=
, I
>>> was able to add the sdb back to the array and md seemed not mind an=
d
>>> still reported "active sync". =A0At this point I shut down computer=
 and
>>> decided to clone sdb with clonezilla so that I can have a good sdb =
to
>>> finish rebuilding sde. =A0Not sure if it will complete without I/O
>>> errors. =A0It appears clonezilla is using dd and the speed is extre=
mely
>>> slow (~5MB/sec) and it says it's gonna take 1 day to clone the 500G=
B.
>>>
>>>
>> As expected, dd encountered the same UNC error. =A0Now I'm trying to
>> ddrescue the drive to see what happens. =A0My question is whether th=
is
>> is worth doing. =A0Assuming ddrescue cannot read the bad sector eith=
er
>> and writes 0's to the new drive, will I be able to rebuild the raid-=
5,
>> from 2 good disks and this disk with a bad sector? =A0I can assume t=
here
>> will be a bad file but will the array still function?
>>
>> Or I'm better off just build a new array from scratch.
>>
>> Any suggestions are appreciated.
>>
>> Regards,
>>
>> DS
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
