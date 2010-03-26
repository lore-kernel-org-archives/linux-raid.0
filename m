From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: 4 partition raid 5 with 2 disks active and 2 spare, how to force?
Date: Fri, 26 Mar 2010 12:04:54 -0700
Message-ID: <4877c76c1003261204h2777547dn67a8e692864ff26a@mail.gmail.com>
References: <S1753093Ab0CYHZE/20100325072504Z+37@vger.kernel.org>
	 <2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com>
	 <4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com>
	 <DFC0232A-8DCD-4815-AA08-DA7065F01221@brillgene.com>
	 <4877c76c1003252038o655b2a29p9d994df27b5d2afd@mail.gmail.com>
	 <6093BE49-EE3B-41B5-9519-C6D5D0496C64@brillgene.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6093BE49-EE3B-41B5-9519-C6D5D0496C64@brillgene.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman@brillgene.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 9:28 AM, Anshuman Aggarwal
<anshuman@brillgene.com> wrote:
> Thanks again. I have visited those pages (twice no less) and nothing =
seems to be new from the concepts (both raid and lvm) since I last stud=
ied them.
>
> My problem is that I'm not familiar enough with the recovery tools an=
d the common practical pitfalls to do this comfortably without the hand=
 holding of this mailing list :)
>
> Here is the requested output:
> Note: Since I have 3-4 other arrays running (root device etc.) which =
don't have anything to do with this one and are all working fine...I am=
 just putting the output of the relevant devices (in order to avoid con=
fusing everybody). Please let me know if you still require the full out=
put.
>
> mdadm -Dvvs /dev/md_d127
> mdadm: md device /dev/md_d127 does not appear to be active.
>
> mdadm --assemble =A0/dev/md_d127 /dev/sda1 /dev/sdb5 /dev/sdc5 /dev/s=
dd5
> mdadm: /dev/md_d127 assembled from 2 drives and 1 spare - not enough =
to start the array.
>
> Says that the device /dev/md_d127 is not active (because its not acti=
ve in /proc/mdstat)
> mdadm -Evvs =A0/dev/sda1 /dev/sdb5 /dev/sdc5 /dev/sdd5
> /dev/sda1:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
> =A0 =A0 =A0 =A0 =A0 Name : GATEWAY:127 =A0(local to host GATEWAY)
> =A0Creation Time : Sat Aug 22 09:44:21 2009
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 4
>
> =A0Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
> =A0 =A0 Array Size : 1758296832 (838.42 GiB 900.25 GB)
> =A0Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
> =A0 =A0Data Offset : 272 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : 571fa32b:d76198a1:0f5d3a2d:31f6d6b8
>
> Internal Bitmap : 2 sectors from superblock
> =A0 =A0Update Time : Fri Mar 19 00:56:15 2010
> =A0 =A0 =A0 Checksum : 7e769165 - expected aa523227
> =A0 =A0 =A0 =A0 Events : 3796145
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 Device Role : spare
> =A0 Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdb5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
> =A0 =A0 =A0 =A0 =A0 Name : GATEWAY:127 =A0(local to host GATEWAY)
> =A0Creation Time : Sat Aug 22 09:44:21 2009
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 4
>
> =A0Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
> =A0 =A0 Array Size : 1758296832 (838.42 GiB 900.25 GB)
> =A0Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
> =A0 =A0Data Offset : 272 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : f8ebb9f8:b447f894:d8b0b59f:ca8e98eb
>
> Internal Bitmap : 2 sectors from superblock
> =A0 =A0Update Time : Fri Mar 19 00:56:15 2010
> =A0 =A0 =A0 Checksum : 1005cfbc - correct
> =A0 =A0 =A0 =A0 Events : 3796145
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 Device Role : Active device 2
> =A0 Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdc5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
> =A0 =A0 =A0 =A0 =A0 Name : GATEWAY:127 =A0(local to host GATEWAY)
> =A0Creation Time : Sat Aug 22 09:44:21 2009
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 4
>
> =A0Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
> =A0 =A0 Array Size : 1758296832 (838.42 GiB 900.25 GB)
> =A0Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
> =A0 =A0Data Offset : 272 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : d9ce99fc:79bc1e9d:197d5b11:c990e007
>
> Internal Bitmap : 2 sectors from superblock
> =A0 =A0Update Time : Fri Mar 19 00:56:15 2010
> =A0 =A0 =A0 Checksum : a9f9f59f - correct
> =A0 =A0 =A0 =A0 Events : 3796145
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 Device Role : Active device 1
> =A0 Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdd5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
> =A0 =A0 =A0 =A0 =A0 Name : GATEWAY:127 =A0(local to host GATEWAY)
> =A0Creation Time : Sat Aug 22 09:44:21 2009
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 4
>
> =A0Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
> =A0 =A0 Array Size : 1758296832 (838.42 GiB 900.25 GB)
> =A0Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
> =A0 =A0Data Offset : 272 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : 763a832f:1a9a7ea8:ce90d4a3:32e8ae54
>
> Internal Bitmap : 2 sectors from superblock
> =A0 =A0Update Time : Fri Mar 19 00:56:15 2010
> =A0 =A0 =A0 Checksum : c78aab46 - correct
> =A0 =A0 =A0 =A0 Events : 3796145
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 Device Role : spare
> =A0 Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
>
>
> Regards,
> Anshuman
>
> On 26-Mar-2010, at 9:08 AM, Michael Evans wrote:
>
>> On Thu, Mar 25, 2010 at 7:09 AM, Anshuman Aggarwal
>> <anshuman@brillgene.com> wrote:
>>> Thanks Michael, I am clear about the problem of why the multiple fa=
ilure would cause me to lose data. Which is why I wanted to consult thi=
s mailing list before proceeding.
>>>
>>> Could you tell me how to keep the array read-only? =A0and mark one =
or both of these spares as active forcibly? and Also, once I am able to=
 use these spares as active and the data is not consistent in a particu=
lar stripe, how does the kernel resolve the inconsistency (as in what d=
ata does it use, the one based on the data stripes or the one based on =
the parity?) this one is just academic interest since it'll be difficul=
t to figure out which is the right data anyways.
>>>
>>> Thanks,
>>> Anshuman
>>>
>>
>> Please, read the wikipedia page first,
>>
>> http://en.wikipedia.org/wiki/RAID
>>
>> and then this
>>
>> http://wiki.tldp.org/LVM-on-RAID (some links need updating, but it's
>> still up to date for concepts)
>>
>>
>> With that background nearly out of the way, please stop, and read th=
em
>> both again. =A0Yes, seriously. =A0In order to prevent data loss you'=
ll
>> need to have a good understanding of what RAID does, so that you can
>> watch out for ways it can fail.
>>
>> The next step, before we do /anything/ else is for you to post the
>> COMPLETE output of these commands.
>>
>> mdadm -Dvvs
>> mdadm -Evvs
>>
>> They will help everyone on the list better understand the state of t=
he
>> metadata records and what potential solutions might be possible.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>

Obviously you do not understand the problem then, since if you did not
previously, and you say you learned nothing new.

Also, you added additional arguments to the commands I provided when
that was neither required nor desired.

However enough data was returned to see one thing:  ALL of the events
counters show the same number.

That is extremely odd, usually in this situation at least one device
will have a lower number.


If possible please describe what happened to cause this in the first pl=
ace.

Also, you'll find these links more directly relevant to your problem:

https://raid.wiki.kernel.org/index.php/RAID_Recovery

Reading my local copy of the manpage (which is slightly outdated, you
should really get the latest stable mdadm release, compile, install
and read the manual to confirm it's still not there) I can't find any
way of bringing an array up in read only mode without using missing
devices, which is what the permutation script tries to do.
Additionally without knowing what type of event is being recovered
from; I suspect either simultaneous disconnection of half the drives;
or what you've done since, because it looks like something, I cannot
offer concrete advice on how to proceed.

However there are two main routes open to you at this point.  Posting
a fresh message asking how to create an array read only for use with
data recovery, and some variant of following the perl script's steps
that the linked document mentions.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
