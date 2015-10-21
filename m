From: andras@tantosonline.com
Subject: Re: How to recover after md crash during =?UTF-8?Q?reshape=3F?=
Date: Tue, 20 Oct 2015 22:52:58 -0500
Message-ID: <87f5f235fc9d29f9e146d5431d3642cb@tantosonline.com>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562660EE.9020504@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil,

Thank you so much for the detailed explanation and your patience with 
me! Sorry for not being more responsive - I don't have access to this 
mail account from work.

> 
>> Apparently my problems don't stop adding up: now SDD started 
>> developing
>> problems, so my root partition (md0) is now degraded. I will attempt 
>> to
>> dd out whatever I can from that drive and continue...
> 
> Don't.  You have another problem: green & desktop drives in a raid
> array.  They aren't built for it and will give you grief of one form or
> another.  Anyways, their problem with timeout mismatch can be worked
> around with long driver timeouts.  Before you do anything else, you
> *MUST* run this command:
> 
> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done
> 
> (Arrange for this to happen on every boot, and keep doing it manually
> until your boot scripts are fixed.)

Yes, will do. In your links below it seems that you're half advocating 
for using desktop drives in RAID arrays, half advocating against. From 
what I can tell, it seems the recommendation might depend on the 
use-case. If one doesn't care too much about instant performance in case 
of errors, one might want to use desktop drivers (with the above fix). 
If one wants reliable performance, one probably wants NAS drives. Did I 
understand the basic trade-off correctly?

It seems that people also think that green drives are a bad idea in 
RAIDs in general - mostly because the frequent parking of heads reduces 
life-time. Is that a correct statement?

> Then you can add your missing mirror and let MD fix it:
> 
> mdadm /dev/md0 --add /dev/sdd3
> 
> After that's done syncing, you can have MD fix any remaining UREs in
> that raid1 with:
> 
> echo check >/sys/block/md0/md/sync_action
> 
> While that's in progress, take the time to read through the links in 
> the
> postscript -- the timeout mismatch problem and its impact on
> unrecoverable read errors has been hashed out on this list many times.
> 
> Now to your big array.  It is vital that it also be cleaned of UREs
> after re-creation before you do anything else.  Which means it must
> *not* be created degraded (the redundancy is needed to fix UREs).
> 
> According to lsdrv and your "mdadm -E" reports, the creation order you
> need is:
> 
> raid device 0 /dev/sdf2 {WD-WMAZA0209553}
> raid device 1 /dev/sdd2 {WD-WMAZA0348342}
> raid device 2 /dev/sdg1 {9VS1EFFD}
> raid device 3 /dev/sde1 {5XW05FFV}
> raid device 4 /dev/sdc1 {6XW0BQL0}
> raid device 5 /dev/sdh1 {ML2220F30TEBLE}
> raid device 6 /dev/sdi2 {WD-WMAY01975001}
> 
> Chunk size is 64k.
> 
> Make sure your partially assembled array is stopped:
> 
> mdadm --stop /dev/md1
> 
> Re-create your array as follows:
> 
> mdadm --create --assume-clean --verbose \
>     --metadata=1.0 --raid-devices=7 --chunk=64 --level=6 \
>     /dev/md1 /dev/sd{f2,d2,g1,e1,c1,h1,i2}
> 
> Use "fsck -n" to check your array's filesystem (expect some damage at
> the very begining).  If it look reasonable, use fsck to fix any damage.
> 
> Then clean up any lingering UREs:
> 
> echo check > /sys/block/md1/md/sync_action
> 
> Now you can mount it and catch any critical backups. (You do know that
> raid != backup, I hope.)
> 
> Your array now has a new UUID, so you probably want to fix your
> mdadm.conf file and your initramfs.

Yes sir! I will go through the steps and report back. One question: the 
reason I shouldn't attempt to re-create the new 10-disk array is that it 
would wipe out the 7->10 grow progress, so MD would think that it's a 
fully grown 10-disk array, right?

> Finaly, go back and do your --grow, with the --backup-file.
> 
> In the future, buy drives with raid ratings like the WD Red family, and
> make sure you have a cron job that regularly kicks off array scrubs.  I
> do mine weekly.

Thanks for the info. This is the first time someone mentions scrubbing 
with regards to RAID to me, but it makes total sense. I will set it up.

Thanks again,
Andras

