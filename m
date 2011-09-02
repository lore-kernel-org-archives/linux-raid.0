From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Thu, 1 Sep 2011 22:24:01 -0700
Message-ID: <CAEUYfyN6nfEDwgE8_eZN48UFzaJNCN2NjBpJbeQR_G01CYCgvQ@mail.gmail.com>
References: <4E57FE4D.5080503@vorgon.com>
	<20110827084535.5e64bf5c@notabene.brown>
	<4E5FC63A.1040206@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FC63A.1040206@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 1, 2011 at 10:51 AM, Timothy D. Lenz <tlenz@vorgon.com> wro=
te:
>
>
> On 8/26/2011 3:45 PM, NeilBrown wrote:
>>
>> On Fri, 26 Aug 2011 13:13:01 -0700 "Timothy D. Lenz"<tlenz@vorgon.co=
m>
>> =A0wrote:
>>
>>> I have 4 drives set up as 2 pairs. =A0The first part has 3 partitio=
ns on
>>> it and it seems 1 of those drives is failing (going to have to figu=
re
>>> out which drive it is too so I don't pull the wrong one out of the =
case)
>>>
>>> It's been awhile since I had to replace a drive in the array and my
>>> notes are a bit confusing. I'm not sure which I need to use to remo=
ve
>>> the drive:
>>>
>>>
>>> =A0 =A0 =A0 =A0sudo mdadm --manage /dev/md0 --fail /dev/sdb
>>> =A0 =A0 =A0 =A0sudo mdadm --manage /dev/md0 --remove /dev/sdb
>>> =A0 =A0 =A0 =A0sudo mdadm --manage /dev/md1 --fail /dev/sdb
>>> =A0 =A0 =A0 =A0sudo mdadm --manage /dev/md1 --remove /dev/sdb
>>> =A0 =A0 =A0 =A0sudo mdadm --manage /dev/md2 --fail /dev/sdb
>>> =A0 =A0 =A0 =A0sudo mdadm --manage /dev/md2 --remove /dev/sdb
>>
>> sdb is not a member of any of these arrays so all of these commands =
will
>> fail.
>>
>> The partitions are members of the arrays.
>>>
>>> or
>>>
>>> sudo mdadm /dev/md0 --fail /dev/sdb1 --remove /dev/sdb1
>>> sudo mdadm /dev/md1 --fail /dev/sdb2 --remove /dev/sdb2
>>
>> sd1 and sdb2 have already been marked as failed so there is little p=
oint
>> in
>> marking them as failed again. =A0Removing them makes sense though.
>>
>>
>>> sudo mdadm /dev/md2 --fail /dev/sdb3 --remove /dev/sdb3
>>
>> sdb3 hasn't been marked as failed yet - maybe it will soon if sdb is=
 a bit
>> marginal.
>> So if you want to remove sdb from the machine this the correct thing=
 to
>> do.
>> Mark sdb3 as failed, then remove it from the array.
>>
>>>
>>> I'm not sure if I fail the drive partition or whole drive for each.
>>
>> You only fail things that aren't failed already, and you fail the th=
ing
>> that
>> mdstat or mdadm -D tells you is a member of the array.
>>
>> NeilBrown
>>
>>
>>
>>>
>>> -------------------------------------
>>> The mails I got are:
>>> -------------------------------------
>>> A Fail event had been detected on md device /dev/md0.
>>>
>>> It could be related to component device /dev/sdb1.
>>>
>>> Faithfully yours, etc.
>>>
>>> P.S. The /proc/mdstat file currently contains the following:
>>>
>>> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
>>> md1 : active raid1 sdb2[2](F) sda2[0]
>>> =A0 =A0 =A0 =A04891712 blocks [2/1] [U_]
>>>
>>> md2 : active raid1 sdb3[1] sda3[0]
>>> =A0 =A0 =A0 =A0459073344 blocks [2/2] [UU]
>>>
>>> md3 : active raid1 sdd1[1] sdc1[0]
>>> =A0 =A0 =A0 =A0488383936 blocks [2/2] [UU]
>>>
>>> md0 : active raid1 sdb1[2](F) sda1[0]
>>> =A0 =A0 =A0 =A024418688 blocks [2/1] [U_]
>>>
>>> unused devices:<none>
>>> -------------------------------------
>>> A Fail event had been detected on md device /dev/md1.
>>>
>>> It could be related to component device /dev/sdb2.
>>>
>>> Faithfully yours, etc.
>>>
>>> P.S. The /proc/mdstat file currently contains the following:
>>>
>>> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
>>> md1 : active raid1 sdb2[2](F) sda2[0]
>>> =A0 =A0 =A0 =A04891712 blocks [2/1] [U_]
>>>
>>> md2 : active raid1 sdb3[1] sda3[0]
>>> =A0 =A0 =A0 =A0459073344 blocks [2/2] [UU]
>>>
>>> md3 : active raid1 sdd1[1] sdc1[0]
>>> =A0 =A0 =A0 =A0488383936 blocks [2/2] [UU]
>>>
>>> md0 : active raid1 sdb1[2](F) sda1[0]
>>> =A0 =A0 =A0 =A024418688 blocks [2/1] [U_]
>>>
>>> unused devices:<none>
>>> -------------------------------------
>>> A Fail event had been detected on md device /dev/md2.
>>>
>>> It could be related to component device /dev/sdb3.
>>>
>>> Faithfully yours, etc.
>>>
>>> P.S. The /proc/mdstat file currently contains the following:
>>>
>>> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
>>> md1 : active raid1 sdb2[2](F) sda2[0]
>>> =A0 =A0 =A0 =A04891712 blocks [2/1] [U_]
>>>
>>> md2 : active raid1 sdb3[2](F) sda3[0]
>>> =A0 =A0 =A0 =A0459073344 blocks [2/1] [U_]
>>>
>>> md3 : active raid1 sdd1[1] sdc1[0]
>>> =A0 =A0 =A0 =A0488383936 blocks [2/2] [UU]
>>>
>>> md0 : active raid1 sdb1[2](F) sda1[0]
>>> =A0 =A0 =A0 =A024418688 blocks [2/1] [U_]
>>>
>>> unused devices:<none>
>>> -------------------------------------
>
>
> Got another problem. Removed the drive and tried to start it back up =
and now
> get Grub Error 2. I'm not sure if when I did the mirrors if something=
 when
> wrong with installing grub on the second drive< or if is has to do wi=
th [U_]
> which points to sda in that report instead of [_U].
>
> I know I pulled the correct drive. I had it labled sdb, it's the seco=
nd
> drive in the bios bootup drive check and it's the second connector on=
 the
> board. And when I put just it in instead of the other, I got the nois=
e
> again. =A0I think last time a drive failed it was one of these two dr=
ives
> because I remember recopying grub.
>
> I do have another computer setup the same way, that I could put this
> remaining drive on to get grub fixed, but it's a bit of a pain to get=
 the
> other computer hooked back up and I will have to dig through my notes=
 about
> getting grub setup without messing up the array and stuff. I do know =
that
> both computers have been updated to grub 2


How did you install Grub on the second drive? I have seen some
instructions on the web that would not allow the system to boot if the
first drive failed or was removed.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
