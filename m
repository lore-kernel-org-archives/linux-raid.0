From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: MD on raw device, use unallocated space anyway?
Date: Fri, 10 Jan 2014 19:52:11 +0000
Message-ID: <CADNH=7FRJwC+N8dTfOgbXRxcVa0Drcrptv=tmXY33mz25zdgYg@mail.gmail.com>
References: <CADNH=7H2E5J3MPyGt4YHHK8wLzhizJLmdos0G60OE1qEwvBOKg@mail.gmail.com>
	<BLU0-SMTP3004D13A23660A4859D816298B30@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP3004D13A23660A4859D816298B30@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10 January 2014 18:12, Wilson Jonathan <piercing_male@hotmail.com> w=
rote:
> On Fri, 2014-01-10 at 17:36 +0000, Mathias Bur=C3=A9n wrote:
>> Hi all,
>>
>> I've a device that's part of an MD array:
>>
>> fdisk
>> Disk /dev/sdg: 3000.6 GB, 3000592982016 bytes
>> 255 heads, 63 sectors/track, 364801 cylinders, total 5860533168 sect=
ors
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> Disk identifier: 0x00000000
>>
>> $ sudo mdadm -E /dev/sdg
>> /dev/sdg:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>>            Name : ion:md0  (local to host ion)
>>   Creation Time : Tue Feb  5 17:33:27 2013
>>      Raid Level : raid6
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
>>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : 39c0b717:a9ca1dd7:bcba618f:caed0879
>>
>>     Update Time : Fri Jan 10 17:28:31 2014
>>        Checksum : 53ea0170 - correct
>>          Events : 2668
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 4
>>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>>
>> As you can see, Used Dev Size is lower than Avail Dev Size. Can I us=
e
>> the unallocated space by MD for storage somehow? As the devices in t=
he
>> array are used fully (no partitions) I guess not, but perhaps there =
is
>> a way.
>>
>
> I'm wondering, did you perhaps add a drive after the initial creation
> and forgot to grow the array to use the additional space? I believe t=
hat
> adding a drive after creation causes the raid to spread the data over
> all the drives via (I think) a re-shape which then needs a "grow" to
> then extend to the end of the drives.
>
> Actually thinking about it, 8GB would equate to 4 drives of 2TB each =
and
> 2 for redundancy =3D 6 drives total as noted in your post... is one o=
f the
> drives a 2 tb by mistake which would cause the 3tb drives to be limit=
ed
> to the first 2tb... if they are all 3tb then I believe a grow=3Dmax s=
ize
> (You'll need to double check the man page) should then use the un-use=
d
> space which will mean your array size should increase to 12TB (4*3TB+=
2
> redundancy)
>
>> Regards,
>> Mathis
>
> Jon.
>
>

Doh,

Of course, I forgot ti add; the array is using 6x 2TB drives and 1x
3TB drive, for a total of 7 drives in a RAID6. It's the single 3TB
drive that I'm wondering about, if I can use the space not used by MD
on it.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
