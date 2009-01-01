From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Thu, 1 Jan 2009 13:29:15 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467705.96388.qm@web30807.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

I think some output would be pertinent here:

mdadm -D /dev/md0..1..2 etc

cat /proc/mdstat

dmesg/syslog of the errors you are seeing etc



On Thu, 1 Jan 2009, Mike Myers wrote:

> The disks that are problematic are still online as far as the OS can tell.  I can do a dd from them and pull off data at the normal speeds, so I don't understand if that's the case why the backplane would be a problem here.  I can try and move them to another slot however (I have a 20 slot SATA backplane in there) and see if that changes how md deals with it.
>
> The OS sees the drive, it inits fine, but md shows it as removed and won't let me add it back to the array because of the "device being busy".  I don't understand the criteria that md uses to add a drive I guess.  The uuid looks fine, and if the events is off, then the -f flag should take care of that.  I've never seen a "device busy" failure on an add before.
>
> thx
> mike
>
>
>
>
> ----- Original Message ----
> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> To: Mike Myers <mikesm559@yahoo.com>
> Cc: linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
> Sent: Thursday, January 1, 2009 7:40:21 AM
> Subject: Re: Need urgent help in fixing raid5 array
>
>
>
> On Thu, 1 Jan 2009, Mike Myers wrote:
>
>> Well, thanks for all your help last month.  As i posted, things came
>> back up and I survived the failure.  Now, I have yet another problem.
>> :(  After 5 years of running a linux server as a dedicated NAS, I am
>> hitting some very weird problems.  This server started as an single
>> processor AMD system with 4 320GB drives, and has been upgraded
>> multiple times so that it is now a quad core Intel rackmounted 4U
>> system with 14 1 TB drives and I have never lost data in any of the
>> upgrades of CPU, motherboard and disk controller hardware and disk
>> drives.  Now after last month's near death experience I am faced with
>> another serious problem in less than a month.  Any help you guys could
>> give me would be most appreciated.  This is a sucky way to start the
>> new year.
>>
>> The array I had problems with last month (md2
>> comprised of 7 1 TB drives in a RAID5 config) is running just fine.
>> md1, which is built of 7 1 TB hitachi 7K1000 drives is now having
>> problems.  We returned from a 10 day family visit with everything
>> running just fine.  There ws a brief power outage today, abt 3 mins,
>> but I can't see how that could be related as the server is on a high
>> quality rackmount 3U APC UPS that handled the outage just fine.  I was
>> working on the system getting X to work again after a nvidia driver
>> update, and when that was working fine, checked the disks to discover
>> that md1 was in a degraded state, with /dev/sdl1 kicked out of the
>> array (removed).  I tried to do a dd from the drive to verify it's
>> location in the rack, but I got an i/o error.  This was most odd, and
>> so went to the rack and pulled the disk and reinserted it.  No system
>> log entries recorded the device being pulled or re-installed.  So I am
>> thinking that a cable somehow
>> has come loose.  I power the system
>> down, pull it out of the rack, look at the cable that goes to the
>> drive, everything looks fine.
>>
>> So I reboot the system, and now
>> the array won't come online because now in addition to the drive that
>> shows as (removed), one of the other drives shows as a faulty spare.
>> Well, learning from the last go around, I reassemble the array with the
>> --force option, and the array comes back up.  But LVM won't come back
>> up because it sees the physical volume that maps to md1 as missing.
>> Now I am very concerned.  After trying a bunch of things, I do a
>> pvcreate with the missing UUID on md1, restart the vg and the logical
>> volume comes back up.  I was thinking I may have told lvm to use an
>> array of bad data, but to my surprise, I mounted the filesystem and
>> everything looked intact!  Ok, sometimes you win.  So I do one more
>> reboot to get the system back up in multiuser so I can back up some of
>> the more important media stored on the volume (it's got about 10 Tb
>> used, but most of that is PVR recordings, but there is a lot of ripped
>> music and DVD's that I really don't
>> want to rerip) on a another server that has some space on it while I figure out what has been happening.
>>
>> The
>> reboot again fails because of a problem with md1.  This time, another
>> one of the drives shows as removed (/dev/sdm1), and I can't reassemble
>> the array with a --force option.  It is acting like /dev/sdl1 (the
>> other removed unit), and even though I can read from the drives fine,
>> their UUID is fine, etc..., md does not consider them as part of the
>> array.  /dev/sdo1 (which was the drive that looked like a faulty spare)
>> seems OK when trying to do the assemble.  sdm1 seemed just fine before
>> the reboot, and was showing no problems before.  They are not hooked up
>> on the same controller cable ( a SAS to SATA fanout), and the LSI MPT
>> controller card seems to talk to the other disks just fine.
>>
>> Anyways,
>> I have no idea as to what's going on.  When I try to add sdm1 or sdl1
>> back into the array, md complains the device is busy, which is very odd
>> because it's not part of another array or doing anything else in the
>> system.
>>
>> Any idea as to what could be happening here?  I am beyond frustrated.
>>
>> thanks,
>> Mike
>>
>>
>>
>
> If you are using a hotswap chasis, then it has some sort of
> sata-backplane.  I have seen backplanes go bad in the past, that would be
> my first replacement.
>
> Justin.
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
