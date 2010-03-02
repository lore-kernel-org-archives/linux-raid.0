From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Raid1 backup solution.
Date: Tue, 2 Mar 2010 02:24:22 -0800
Message-ID: <4877c76c1003020224r18faa044g26fab219f84c4044@mail.gmail.com>
References: <1267523407.5869.1181.camel@localhost.localdomain>
	 <1267524355.5869.1188.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1267524355.5869.1188.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 2, 2010 at 2:05 AM, Daniel Reurich <daniel@centurion.net.nz=
> wrote:
> On Tue, 2010-03-02 at 22:50 +1300, Daniel Reurich wrote:
>> Hi Guys.
>>
>> I'm considering implementing a rotating offsite backup solution usin=
g
>> raid 1. =A0This solution uses 1 or more internal drives and 2 extern=
al
>> e-sata harddrives. =A0The raid setup would be a whole disk partition=
able
>> raid1 volume.
>>
>> The idea is that by swapping the external drives, =A0I can have a
>> boot-able ready to run offsite backup of the machine, as well as
>> redundancy on the machine itself. =A0Backups of the important data w=
ould
>> be replicated via an incremental daily backup process onto the raid
>> volume itself.
>>
>> The part that concerns me is how to get a clean removal of the drive
>> being swapped out, and how will the raid handle having a stale drive
>> inserted/re-added.
>>
>> I have been considering a couple of ways to handle this:
>>
>> 1) Power the machine down to swap the drives. =A0This has the advant=
age
>> that the backup is always in a clean bootable state with filesystem
>> consistency pretty much guaranteed.
>>
>> 2) Use mdadm to fail and remove the drives, and then re-add the newl=
y
>> attached stale drive. =A0(Perhaps a udev rule could be made handle t=
he
>> re-add). =A0The disadvantage is this will potentially leave the back=
up
> with an inconsistent filesystem and possibly have some corrupted file=
s
> unless there is a way to programmatically queisce all write filesyste=
m
> write activity and sync the disk before the removal.
>
>> It will also mark the drive as failed and require mdadm --re-add to
>> insert the spare drive. =A0 =A0 =A0It's advantage is that the machin=
e
>> doesn't need to be turned off.
>>
>> 3) Hot pull the drive e-sata cable, then power down the drive. =A0Th=
is is
>> likely to leave the filesystems in really nasty state if there just
>> happens to be a write going on at the time.
>
> Actually scrap 3 as on re-reading it goes against all sensibility.
>>
>> My preference is for option 2 as option 1 may not always be feasible=
 due
>> to the downtime, but I'm wondering about how best to handle the re-a=
dd,
>> as I suspect that the metadata on the failed then removed drive, wou=
ld
>> make it more difficult to re-add the drive into the array.
>>
>> If option 1 was used (cold swap), how would md handle assembly with =
the
>> stale but not failed member disk? =A0Would it simply force a resync,=
 or
>> would it fail the disk and require manual intervention to re-add it.
>>
>> Any thoughts on my hair brained scheme would be appreciated.
>>
>> Daniel Reurich.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Why don't you just sync ; sync; sync; wait a few seconds and then
mdadm --fail /dev/whatever the device you want to remove is; then
actually remove it from the array?

In the event you need to boot or read from the failed 'snapshot' of
the array you can add --force to the mdadm --assemble to cause it to
accept the failed member as a valid array member (just make sure there
are no other members of that array present).  It will then become the
current master set for that fork of your storage versions.  If you
need to add that drive back to the original array be sure to
--zero-superblock for that device first, otherwise the versions may
confuse things.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
