From: John Yates <jyates65@gmail.com>
Subject: Re: Advice recovering from interrupted grow on RAID5 array
Date: Wed, 16 Oct 2013 09:02:52 -0400
Message-ID: <CA+90J_9vLnEVPhAkQmZ5VS=gTw0fjf107wf=2riLn+=RstJMSQ@mail.gmail.com>
References: <CA+90J__=u_m9RW7c9KHGMRr+6ZOSVQUN6yXm61YM_yir-7LE7A@mail.gmail.com>
	<20131016162625.628c5558@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131016162625.628c5558@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 16, 2013 at 1:26 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 14 Oct 2013 21:59:45 -0400 John Yates <jyates65@gmail.com> wrote:
>
>> Midway through a RAID5 grow operation from 5 to 6 USB connected
>> drives, system logs show that the kernel lost communication with some
>> of the drive ports which has left my array in a state that I have not
>> been able to reassemble. After reseating the cable connections and
>> rebooting, all of the drives appear to be functioning normally, so
>> hopefully the data is still intact. I need advice on recovery steps
>> for the array.
>>
>> It appears that each drive failed in quick succession with /dev/sdc1
>> being the last standing and having the others marked as missing in its
>> superblock. The superblocks of the other drives show all drives as
>> available. (--examine output below)
>>
>> >mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1
>> mdadm: too-old timestamp on backup-metadata on device-5
>> mdadm: If you think it is should be safe, try 'export MDADM_GROW_ALLOW_OLD=1'
>> mdadm: /dev/md127 assembled from 1 drives - not enough to start the array.
>
> Did you try following the suggestion and run
>
>  export MDADM_GROW_ALLOW_OLD=1
>
> and the try the --asssemble again?
>
> NeilBrown

Yes I did, thanks. Not much change though. It accepts the timestamp,
but then appears not to use it.

mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
/dev/sdf1 /dev/sdg1 --verbose
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdg1 is identified as a member of /dev/md127, slot 5.
mdadm: :/dev/md127 has an active reshape - checking if critical
section needs to be restored
mdadm: accepting backup with timestamp 1381360844 for array with
timestamp 1381729948
mdadm: backup-metadata found on device-5 but is not needed
mdadm: added /dev/sdf1 to /dev/md127 as 1
mdadm: added /dev/sdd1 to /dev/md127 as 2
mdadm: added /dev/sdc1 to /dev/md127 as 3
mdadm: added /dev/sdb1 to /dev/md127 as 4 (possibly out of date)
mdadm: added /dev/sdg1 to /dev/md127 as 5 (possibly out of date)
mdadm: added /dev/sde1 to /dev/md127 as 0
mdadm: /dev/md127 assembled from 4 drives - not enough to start the array.
