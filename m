From: Glen Dragon <glen.dragon@gmail.com>
Subject: Re: raid5 reshape failure - restart?
Date: Sun, 15 May 2011 17:45:34 -0400
Message-ID: <BANLkTi=7oHaQYbOA+qWHHzUzP5fp6UB=9A@mail.gmail.com>
References: <BANLkTi=-QZaQD6itGGZeyFekb2Kq5=_1iA@mail.gmail.com>
	<20110516073702.6b6b9bb2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110516073702.6b6b9bb2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 15, 2011 at 5:37 PM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 15 May 2011 13:33:28 -0400 Glen Dragon <glen.dragon@gmail.com=
> wrote:
>
>> In trying to reshape a raid5 array, I encountered some problems.
>> I was trying to reshape from raid5 3->4 devices. =A0The reshape proc=
ess
>> started with seeming no problems, however i noticed in the kernel lo=
g
>> a number of ata3.00: failed command: WRITE FPDMA QUEUED errors.
>> In trying to determine if this was going to be bad for me, I disable=
d
>> ncq on this device. Looking at the log, i notice around the same tim=
e
>> /dev/sdd reported problems and took itself offline.
>> At this point the reshape seemed to be continuing w/o issue, even
>> though one of the drives was offline.. I wasn't sure that this made
>> sense.
>>
>> Shortly after, I noticed that the progress on the reshape had stalle=
d.
>> =A0I tried changing the stripe_cache_size from 256 to [1024|2048|409=
6],
>> but the reshape did not resume. =A0top reported that the reshape pro=
cess
>> was using 100% of one core, and the load average was climbing into t=
he
>> 50's
>>
>> At this point I rebooted. =A0 The array does not start.
>>
>> Can the reshape be restarted? =A0I cannot figure out where the backu=
p
>> file ended up. =A0It does not seem to be where I thought I saved it.
>
> When a reshape is increasing the size of the array the backup file is=
 only
> needed for the first few stripes. =A0After that it is irrelevant and =
is removed.
>
> You should be able to simply reassemble the array and it should conti=
nue the
> reshape.
>
> What happens when you =A0try:
>
> =A0mdadm -S /dev/md_d2
> =A0mdadm -A /dev/md_d2 /dev/sd[abc]5 -vv
>
> Please report both the messsages from mdadm and any new message is "d=
mesg" at
> the time.
>
> NeilBrown
>

 # mdadm -S /dev/md_d2
mdadm: stopped /dev/md_d2


 # mdadm -A /dev/md_d2  /dev/sd[abcd]5 -vv
mdadm: looking for devices for /dev/md_d2
mdadm: /dev/sda5 is identified as a member of /dev/md_d2, slot 0.
mdadm: /dev/sdb5 is identified as a member of /dev/md_d2, slot 1.
mdadm: /dev/sdc5 is identified as a member of /dev/md_d2, slot 3.
mdadm: /dev/sdd5 is identified as a member of /dev/md_d2, slot 2.
mdadm:/dev/md_d2 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on device-3
mdadm: added /dev/sdb5 to /dev/md_d2 as 1
mdadm: added /dev/sdd5 to /dev/md_d2 as 2
mdadm: added /dev/sdc5 to /dev/md_d2 as 3
mdadm: added /dev/sda5 to /dev/md_d2 as 0
mdadm: /dev/md_d2 assembled from 3 drives - not enough to start the
array while not clean - consider --force.

 # mdadm -D /dev/md_d2
mdadm: md device /dev/md_d2 does not appear to be active.

 # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [multipath] [raid1]
md_d2 : inactive sda5[0](S) sdc5[3](S) sdd5[2](S) sdb5[1](S)
      2799357952 blocks super 0.91

md8 : active raid5 sdh1[0] sdg1[4] sdf1[1] sdi1[3] sde1[2]
      5860542464 blocks level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]

md1 : active raid5 sdd3[2] sdb3[1] sda3[0]
      62926336 blocks level 5, 256k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid1 sdb1[1] sda1[0] sdd1[2]
      208704 blocks [3/3] [UUU]


kernel log:
md: md_d2 stopped.
md: unbind<sda5>
md: export_rdev(sda5)
md: unbind<sdc5>
md: export_rdev(sdc5)
md: unbind<sdd5>
md: export_rdev(sdd5)
md: unbind<sdb5>
md: export_rdev(sdb5)
md: md_d2 stopped.
md: bind<sdb5>
md: bind<sdd5>
md: bind<sdc5>
md: bind<sda5>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
