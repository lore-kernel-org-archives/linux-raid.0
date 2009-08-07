From: "NeilBrown" <neilb@suse.de>
Subject: Re: question about bitmaps and dirty percentile
Date: Fri, 7 Aug 2009 11:47:20 +1000 (EST)
Message-ID: <0b3f2dc27832051e76c23cec416f1469.squirrel@neil.brown.name>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
    <19066.30329.778572.603105@notabene.brown>
    <cccedfc60908060602i52403915oa7afcb38a9e386b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60908060602i52403915oa7afcb38a9e386b0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, August 6, 2009 11:02 pm, Jon Nelson wrote:
> On Thu, Aug 6, 2009 at 1:21 AM, Neil Brown<neilb@suse.de> wrote:
>> On Thursday July 30, jnelson-linux-raid@jamponi.net wrote:
>>>
>>> I saw this, which just *can't* be right:
>>>
>>> md12 : active raid1 nbd0[2](W) sde[0]
>>>       72612988 blocks super 1.1 [3/1] [U__]
>>>       [======================================>]  recovery =192.7%
>>> (69979200/36306494) finish=13228593199978.6min speed=11620K/sec
>>>       bitmap: 139/139 pages [556KB], 256KB chunk
>>
>> Certainly very strange.  I cannot explain it at all.
>>
>> Please report exactly what kernel version you were running, all kernel
>> log messages from before the first resync completed until after the
>> sync-to-200% completed.
>>
>> Hopefully there will be a clue somewhere in there.
>
> Stock openSUSE 2.6.27.25-0.1-default on x86_64.

Ok, so it was probably broken by whoever maintain md for
SuSE.... oh wait, that's me :-)


>
> I'm pretty sure this is it:
>
> Jul 30 13:51:01 turnip kernel: md: bind<nbd0>
> Jul 30 13:51:01 turnip kernel: RAID1 conf printout:
> Jul 30 13:51:01 turnip kernel:  --- wd:1 rd:3
> Jul 30 13:51:01 turnip kernel:  disk 0, wo:0, o:1, dev:sde
> Jul 30 13:51:01 turnip kernel:  disk 1, wo:1, o:1, dev:nbd0
> Jul 30 13:51:01 turnip kernel: md: recovery of RAID array md12
> Jul 30 13:51:01 turnip kernel: md: minimum _guaranteed_  speed: 1000
> KB/sec/disk.
> Jul 30 13:51:01 turnip kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Jul 30 13:51:01 turnip kernel: md: using 128k window, over a total of
> 72612988 blocks.
> Jul 30 14:10:48 turnip kernel: md: md12: recovery done.
> Jul 30 14:10:49 turnip kernel: RAID1 conf printout:
> Jul 30 14:10:49 turnip kernel:  --- wd:2 rd:3
> Jul 30 14:10:49 turnip kernel:  disk 0, wo:0, o:1, dev:sde
> Jul 30 14:10:49 turnip kernel:  disk 1, wo:0, o:1, dev:nbd0
>

Thanks...
So:
 - when the recovery started, mddev->size was twice of half of the value
   printed for "over a total of...", so 72612988 (I assume this is
   expected to be a 72 Gig array).
   Twice this will have been stored in 'max_sectors' and the loop in
   md_do_sync will have taken 'j' up to that value and periodically
   stored in in mddev->curr_resync
 - When you ran "cat /proc/mdstat", mddev->array_sectors will have been
   twice the value printed at "... blocks", which is the same,
   145225976
 - When you ran "cat /proc/mdstat", it printed "recovery", not "resync",
   so MD_RECOVERY_SYNC was not set, so max_sectors was set to
   mddev->size... that looks wrong (size is in KB)
   Half of this is printed in the second number in
   the (%d/%d) bit, so ->size was twice 36306494 or
   72612988, which is consistent.

So the problem is that in resync_status, max_sectors is being set to
mddev->size rather than mddev->size*2.  This is purely a cosmetic problem,
it do not affect data safety at all.

It looks like I botched a backport of
  commit dd71cf6b2773310b01c6fe6c773064c80fd2476b
into the Suse kernel.  I'll get that fixed for the next update.

Thanks for the report, and as I said, the only thing affected here
is the content of /proc/mdstat.  The recovery is doing the right
thing.

Thanks,
NeilBrown



