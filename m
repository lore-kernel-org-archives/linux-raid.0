From: John Yates <jyates65@gmail.com>
Subject: Re: Advice recovering from interrupted grow on RAID5 array
Date: Mon, 21 Oct 2013 16:06:27 -0400
Message-ID: <CA+90J_9uveDYnv8RiKLcp9nOcMNzaF4rtwSrmZ5S5UKExmLwhA@mail.gmail.com>
References: <CA+90J__=u_m9RW7c9KHGMRr+6ZOSVQUN6yXm61YM_yir-7LE7A@mail.gmail.com>
	<20131016162625.628c5558@notabene.brown>
	<CA+90J_9vLnEVPhAkQmZ5VS=gTw0fjf107wf=2riLn+=RstJMSQ@mail.gmail.com>
	<20131017110725.54de5b06@notabene.brown>
	<CA+90J_8y+XOhdmKuAm9VSKSvb61+57YU0iYWGjkh4WP3BAF5pA@mail.gmail.com>
	<20131021120943.179a2bb0@notabene.brown>
	<CA+90J_8twC0A2GD-xm6TQLgrK7FU+W2ueqGdF8tauRpzG_aPpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+90J_8twC0A2GD-xm6TQLgrK7FU+W2ueqGdF8tauRpzG_aPpQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 21, 2013 at 12:29 PM, John Yates <jyates65@gmail.com> wrote:
> On Sun, Oct 20, 2013 at 9:09 PM, NeilBrown <neilb@suse.de> wrote:
>> On Thu, 17 Oct 2013 01:36:28 -0400 John Yates <jyates65@gmail.com> wrote:
>>
>>> On Wed, Oct 16, 2013 at 8:07 PM, NeilBrown <neilb@suse.de> wrote:
>>> > On Wed, 16 Oct 2013 09:02:52 -0400 John Yates <jyates65@gmail.com> wrote:
>>> >
>>> >> On Wed, Oct 16, 2013 at 1:26 AM, NeilBrown <neilb@suse.de> wrote:
>>> >> > On Mon, 14 Oct 2013 21:59:45 -0400 John Yates <jyates65@gmail.com> wrote:
>>> >> >
>>> >> >> Midway through a RAID5 grow operation from 5 to 6 USB connected
>>> >> >> drives, system logs show that the kernel lost communication with some
>>> >> >> of the drive ports which has left my array in a state that I have not
>>> >> >> been able to reassemble. After reseating the cable connections and
>>> >> >> rebooting, all of the drives appear to be functioning normally, so
>>> >> >> hopefully the data is still intact. I need advice on recovery steps
>>> >> >> for the array.
>>> >> >>
>>> >> >> It appears that each drive failed in quick succession with /dev/sdc1
>>> >> >> being the last standing and having the others marked as missing in its
>>> >> >> superblock. The superblocks of the other drives show all drives as
>>> >> >> available. (--examine output below)
>>> >> >>
>>> >> >> >mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1
>>> >> >> mdadm: too-old timestamp on backup-metadata on device-5
>>> >> >> mdadm: If you think it is should be safe, try 'export MDADM_GROW_ALLOW_OLD=1'
>>> >> >> mdadm: /dev/md127 assembled from 1 drives - not enough to start the array.
>>> >> >
>>> >> > Did you try following the suggestion and run
>>> >> >
>>> >> >  export MDADM_GROW_ALLOW_OLD=1
>>> >> >
>>> >> > and the try the --asssemble again?
>>> >> >
>>> >> > NeilBrown
>>> >>
>>> >> Yes I did, thanks. Not much change though. It accepts the timestamp,
>>> >> but then appears not to use it.
>>> >>
>>> >> mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>> >> /dev/sdf1 /dev/sdg1 --verbose
>>> >> mdadm: looking for devices for /dev/md127
>>> >> mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 4.
>>> >> mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 3.
>>> >> mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 2.
>>> >> mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 0.
>>> >> mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 1.
>>> >> mdadm: /dev/sdg1 is identified as a member of /dev/md127, slot 5.
>>> >> mdadm: :/dev/md127 has an active reshape - checking if critical
>>> >> section needs to be restored
>>> >> mdadm: accepting backup with timestamp 1381360844 for array with
>>> >> timestamp 1381729948
>>> >> mdadm: backup-metadata found on device-5 but is not needed
>>> >> mdadm: added /dev/sdf1 to /dev/md127 as 1
>>> >> mdadm: added /dev/sdd1 to /dev/md127 as 2
>>> >> mdadm: added /dev/sdc1 to /dev/md127 as 3
>>> >> mdadm: added /dev/sdb1 to /dev/md127 as 4 (possibly out of date)
>>> >> mdadm: added /dev/sdg1 to /dev/md127 as 5 (possibly out of date)
>>> >> mdadm: added /dev/sde1 to /dev/md127 as 0
>>> >> mdadm: /dev/md127 assembled from 4 drives - not enough to start the array.
>>> >
>>> >
>>> > What about with MDADM_GROW_ALLOW_OLD=1 *and* --force ??
>>> >
>>> > If that doesn't work, please add --verbose as well, and report the output.
>>> >
>>> > NeilBrown
>>>
>>> Thanks Neil. I had tried that as well (output below). I'm wondering if
>>> there is a way to fix the metadata for /dev/sdc1 since that seems to
>>> be the odd one where the --examine data indicates that the other disks
>>> are all bad when I don't believe they really are (just the result of a
>>> partial kernel or driver crash). I have read about some people zeroing
>>> the superblock on a device so that it can be recreated, but I am not
>>> sure exactly how that works and am hesitant to try it since a reshape
>>> was in progress. I have also read about people having had success by
>>> re-running the original mdadm --create while leaving the data intact,
>>> but again I am hesitant to try that, especially because of the reshape
>>> state.
>>>
>>> Or... maybe this all has more to do with the Update Time, since the
>>> output seems to indicate 4 drives are usable. All of the drives have
>>> the same Update Time except for /dev/sdc1 which is about 5 minutes
>>> later than the rest. Since it is the fourth device, perhaps the
>>> assemble is satisfied with devices 0, 1, 2, 3, but then seeing an
>>> Update Time on devices 4 and 5 that is earlier than device 3, it
>>> marks them as "possibly out of date" and stops trying to assemble the
>>> array. Hard to tell, but I still would not have any idea how to
>>> overcome that scenario. I appreciate your help!
>>>
>>> # export MDADM_GROW_ALLOW_OLD=1
>>> # mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>> /dev/sdf1 /dev/sdg1 --force --verbose
>>> mdadm: looking for devices for /dev/md127
>>> mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 4.
>>> mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 3.
>>> mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 2.
>>> mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 0.
>>> mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 1.
>>> mdadm: /dev/sdg1 is identified as a member of /dev/md127, slot 5.
>>> mdadm: :/dev/md127 has an active reshape - checking if critical
>>> section needs to be restored
>>> mdadm: accepting backup with timestamp 1381360844 for array with
>>> timestamp 1381729948
>>> mdadm: backup-metadata found on device-5 but is not needed
>>> mdadm: added /dev/sdf1 to /dev/md127 as 1
>>> mdadm: added /dev/sdd1 to /dev/md127 as 2
>>> mdadm: added /dev/sdc1 to /dev/md127 as 3
>>> mdadm: added /dev/sdb1 to /dev/md127 as 4 (possibly out of date)
>>> mdadm: added /dev/sdg1 to /dev/md127 as 5 (possibly out of date)
>>> mdadm: added /dev/sde1 to /dev/md127 as 0
>>> mdadm: /dev/md127 assembled from 4 drives - not enough to start the array.
>>
>> That shouldn't happen.  With '-f' it should force the event count of either b1
>> or g1 (or maybe both) to match the others.
>>
>> What version of mdadm are you using? (mdadm -V)
>>
>
> mdadm - v3.3 - 3rd September 2013
> (Arch Linux)
>
>> Maybe try the latest
>>   git clone git://git.neil.brown.name/mdadm
>>   cd mdadm
>>   make mdadm
>>   ./mdadm .....
>>
>> NeilBrown
>
> OK, trying the latest...
>
> # ./mdadm -V
> mdadm - v3.3-27-ga4921f3 - 16th October 2013
>
> # uname -rv
> 3.11.4-1-ARCH #1 SMP PREEMPT Sat Oct 5 21:22:51 CEST 2013
>
> No change in the result and I don't see errors anywhere indicating a
> problem writing to /dev/sdb1 or /dev/sdg1. Are there any more debug
> options that I am overlooking?
>
> # ./mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1
> /dev/sde1 /dev/sdf1 /dev/sdg1 -f -v
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 4.
> mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 0.
> mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 1.
> mdadm: /dev/sdg1 is identified as a member of /dev/md127, slot 5.
> mdadm: :/dev/md127 has an active reshape - checking if critical
> section needs to be restored
> mdadm: accepting backup with timestamp 1381360844 for array with
> timestamp 1381729948
> mdadm: backup-metadata found on device-5 but is not needed
> mdadm: added /dev/sdf1 to /dev/md127 as 1
> mdadm: added /dev/sdd1 to /dev/md127 as 2
> mdadm: added /dev/sdc1 to /dev/md127 as 3
> mdadm: added /dev/sdb1 to /dev/md127 as 4 (possibly out of date)
> mdadm: added /dev/sdg1 to /dev/md127 as 5 (possibly out of date)
> mdadm: added /dev/sde1 to /dev/md127 as 0
> mdadm: /dev/md127 assembled from 4 drives - not enough to start the array.
>
> # ./mdadm --examine /dev/sd[bcdefg]1 | egrep '/dev/sd|Events|Update|Role|State'
> /dev/sdb1:
>           State : clean
>     Update Time : Mon Oct 14 01:52:28 2013
>          Events : 155279
>    Device Role : Active device 4
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdc1:
>           State : clean
>     Update Time : Mon Oct 14 01:57:26 2013
>          Events : 155281
>    Device Role : Active device 3
>    Array State : ...A.. ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdd1:
>           State : clean
>     Update Time : Mon Oct 14 01:52:28 2013
>          Events : 155281
>    Device Role : Active device 2
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sde1:
>           State : clean
>     Update Time : Mon Oct 14 01:52:28 2013
>          Events : 155281
>    Device Role : Active device 0
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdf1:
>           State : clean
>     Update Time : Mon Oct 14 01:52:28 2013
>          Events : 155281
>    Device Role : Active device 1
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdg1:
>           State : clean
>     Update Time : Mon Oct 14 01:52:28 2013
>          Events : 155279
>    Device Role : Active device 5
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
>
>
>
> Not sure is this is significant but at boot time they are all shown as
> spares though the indexing seems odd in that index 2 is skipped:
>
> # cat /proc/mdstat
> Personalities :
> md127 : inactive sdf1[1](S) sde1[0](S) sdg1[6](S) sdd1[3](S)
> sdb1[5](S) sdc1[4](S)
>       11717972214 blocks super 1.2
>
> unused devices: <none>
>
>
> Then I do an `mdadm --stop /dev/md127` before trying the assemble.

OK, I got the array started and is has resumed reshaping.

Line 806 of Assemble.c:
for (i = 0; i < content->array.raid_disks && i < bestcnt; i++) {

'bestcnt' appears to be an index into the list of available devices,
including non-array members. The loop condition here limits iteration
to the number of devices in the array. In my array, there are some
non-member devices early in the list, so later members are not
considered for updating. Perhaps the 'i < content->array.raid_disks'
condition is not needed here?
