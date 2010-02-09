From: =?ISO-8859-1?Q?Stefan_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Tue, 09 Feb 2010 07:57:09 +0100
Message-ID: <4B710745.7020200@stud.tu-ilmenau.de>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com> <adf93d751002082020t642cb1d3ne3d3f5fe5d57e7b5@mail.gmail.com>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002082020t642cb1d3ne3d3f5fe5d57e7b5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I do RAID-recoveries at least once a month and get paid for it.  Rule o=
f
thumb: if your have one drive dropped and another one with pending
sectors, your rebuild will fail - no need for calculations there.

ddrescue on a clean disk is about half as fast as dd with a blocksize
beyond 1M.  ddrescue on a disk with pending sectors is just no pita as
dd or sg_dd would be, because it adds the neccesary intelligence.

Do you have the original sde still around?  If yes, ddrescue both: sdb
and sde.  My experience says: there will only be a few KB lost.  Then
re-create your raid (it will only write the superblock new) with
"--assume-clean".  After that worked, you might make another (big)
backup first, then run fsck and see what happens.  If the lost bytes
have screwed the filesystem, you might want to re-create the raid with
another (personally I prefer xfs) fs and replay your backup into it.

A few commands to make the intentions cleaner:
ddrescue -dv -r5 /dev/oldsdb1 /dev/newsdb1 /root/sdblog
ddrescue -dv -r5 /dev/oldsde1 /dev/newsde1 /root/sdelog
=2E.. find out which drive is which raid-device -> mdadm -E /dev/sdX1
mdadm --create /dev/md0 --raid-devices=3D4 --level=3D5
--chunk=3D${your_chunk_size_in_kb} --assume-clean
${ordered_list_of_raid_devices}

Hope this helps,
Stefan H=FCbner


Am 09.02.2010 05:20, schrieb Dawning Sky:
> On Mon, Feb 8, 2010 at 3:23 PM, Dawning Sky <the.dawning.sky@gmail.co=
m> wrote:
>  =20
>> Hi,
>>
>> Now I have two faulty drives and things don't look good.  However, I
>> was able to add the sdb back to the array and md seemed not mind and
>> still reported "active sync".  At this point I shut down computer an=
d
>> decided to clone sdb with clonezilla so that I can have a good sdb t=
o
>> finish rebuilding sde.  Not sure if it will complete without I/O
>> errors.  It appears clonezilla is using dd and the speed is extremel=
y
>> slow (~5MB/sec) and it says it's gonna take 1 day to clone the 500GB=
=2E
>>
>>    =20
> As expected, dd encountered the same UNC error.  Now I'm trying to
> ddrescue the drive to see what happens.  My question is whether this
> is worth doing.  Assuming ddrescue cannot read the bad sector either
> and writes 0's to the new drive, will I be able to rebuild the raid-5=
,
> from 2 good disks and this disk with a bad sector?  I can assume ther=
e
> will be a bad file but will the array still function?
>
> Or I'm better off just build a new array from scratch.
>
> Any suggestions are appreciated.
>
> Regards,
>
> DS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
