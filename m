From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Wed, 27 Jan 2010 11:09:57 +0100
Message-ID: <4B6010F5.6030702@texsoft.it>
References: <4B5F6C73.30707@texsoft.it> <4B6000F0.2000405@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6000F0.2000405@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Firstable, thanks for the many replies :-)

>> This could (and for me did) bring to big disasters!
>> Suppose you have a 4 disk raid with 2 spare disk ready for recovery
>> There are lot of read errors on disk 1, but md silently recovers them 
>> whitout marking disk as faulty (as it did for me)
>> Disk 3 fails
>> md adds one of the spare disks, and starts resync
>> resync fails due to the read errors on disk 1
>> everything is lost! till having 2 spare disks!!!???
>> This is no fault tollerance ... it's fault creation!!!
>
> Other than monitoring & proactively replacing the disk as Luca 
> suggests, the thing that you (probably) have missed is periodically 
> performing scrubs.
>
> See man md for "check" or "repair".
>
> With scrubs, your errors in /dev/sdf and /dev/sdb would have been 
> detected long time ago, and the disk in the worst shape would have run 
> out of reallocation sectors and be kicked long time ago when the other 
> disk was still relatively in good shape.
I didn't setup smart monitoring... Luca is right.
But I dont like the idea that md relies on another tool, that could be 
not installed or correctly configured, to warn the user on potential 
critical situations which involve directly itself.

 From the logs, it results that it did a "check" on md3 the 4 january 
(first read errors at beginning of december, failure of other disk 18 
january); no read error occurred.
Looks like it did not help much :(
Maybe I was just very unluky

>
> Double failures (in different positions of different disks) are 
> relatively likely if you don't scrub the array. If you scrub the array 
> they are much less likely.
>
> That said, you might still be able to get data out of your array:
>
> 1 - reassemble it, possibly with --force if normal reassemble refuses 
> to work  (*)
> 2 - immediately stop the resync by writing "idle" on 
> /sys/block/mdX/md/sync_action
> 3 - immediately set it as readonly: mdadm --readonly /dev/sdX
> 4 - mount the array (w/ readonly mount) and get data out of it with 
> rsyncs
>
> The purpose of 2 and 3 is to stop the resync (your array is not 
> clean). I hope one of those two does it. You should not see progress 
> with cat /dev/mdstat after those two steps.
>
> #3 also should prevent further resyncs to start, which normally start 
> when you hit an unreadable sector. Remember that if the rsync starts, 
> at 98% of it your array will go down.
>
> Let us know
I recovered the array in degraded mode with:

mdadm --create /dev/md3 --assume-clean --level=5 --raid-devices=6 
--spare-devices=0 /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdd4 /dev/sde4 missing

setting md3 readonly and mounting readonly.
Obviously when a read error occurs on sdb, it goes again offline and I 
have to repeat the procedure
It does not resync as I run in degraded mode (missing in place of 
/dev/sdf4).

I'm saving not all data, but many.

Which I complain most, is the 'silent' manage of the recovered read errors.
I think it would be very apreciated, not only by me, if a warning could 
be issued (by md, no others, as it says and manages the read error) to 
inform the admin that a problem may face.
In 2 years of 24/7 activity, none of the other 5 disks in the array gave 
a single read error; just sdb started giving many in december (while sdf 
failed suddenly at one shot).
In my experience, when a disk begins to give read errors, it's better to 
replace it as soon as possible (with a disk which has done some burn in, 
and which is tested to be ok).
As raid is meant to be redundant, maybe some redundant warning on 
recoverable read errors could be useful too.
Because which is a recoverable read error if all other disk are ok, it 
becomes a fatal error if another disk fails.

By the way I'm having a look at the md kernel source.
It look like raid5 is hard configured to set a device faulty if it gives 
 > 256 recoverable read errors.
Would be nice if this could be configurable into /proc/sys/md

I'll follow a more detailed post on this point.

Thanks again.

Giovanni

