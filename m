From: Neil Brown <neilb@suse.de>
Subject: Re: New RAID causing system lockups
Date: Sun, 12 Sep 2010 06:43:08 +1000
Message-ID: <20100912064308.46d96742@notabene>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 11 Sep 2010 14:20:40 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> PART 3:
> 
> Update:
> 
> I'm even more concerned about this now, because I just started the
> newest reshaping to add a new drive with:
> 
> mdadm --grow -c 256 --raid-devices=5 --backup-file=/grow_md0.bak /dev/md0
> 
> And the system output:
> 
> mdadm: Need to backup 768K of critical section..
> 
> cat /proc/mdstat shows the reshaping is proceeding,
> 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sdi1[0] sdf1[5] md1p1[4] sdj1[3] sdh1[1]
>       2929691136 blocks super 1.2 level 6, 128k chunk, algorithm 2 [5/5] [UUUUU]
>       [>....................]  reshape =  0.0% (56576/1464845568)
> finish=2156.9min speed=11315K/sec
> 
> md1 : active raid0 sdg1[0] sdk1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> unused devices: <none>
> 
> but I've checked for /grow_md0.bak and it's not there. So it looks
> like for some reason it ignored my backup file option.

It didn't.

When you making an array larger, you only need the backup file for a small
'critical region' at the beginning of the reshape - 768K worth in your case.

Once that is complete the backup-file is not needed and so is removed.

So your current situation is no worse that before.

[When making an array smaller, the critical section happen and the very end,
so mdadm keeps the backup file around - unused - until then.  Then uses it
quickly and completes.  When reshaping an array without changing the size the
'critical section' lasts for the entire time so a backup file is needed and
is very heavily used]

I don't know yet what is causing the lock-up.  A quick look at your logs
suggest that it could be related to the barrier handling.  Maybe trying to
handle a barrier during a reshape is prone to races of some sort - I wouldn't
be very surprised by that.

I'll have a look at the code and see what I can find.

Thanks for the report,
NeilBrown


> 
> This scares me, because if I experience the lockup again and am forced
> to reboot, without a backup file I'm afraid my array will be hosed.
> I'm also afraid to stop it cleanly right now for the same reason.
> 
> So in addition to fixing the lockup itself, does anyone know if
> there's a way to either cancel this reshaping or belatedly add the
> backup file in a different way so it will be recoverable? It's only at
> 1% and says it will take another 2193 minutes.
> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

