From: Neil Brown <neilb@suse.de>
Subject: Re: grow fails with 2.6.34 git
Date: Thu, 15 Apr 2010 11:04:01 +1000
Message-ID: <20100415110401.22c7a6bf@notabene.brown>
References: <hq5efu$mqb$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hq5efu$mqb$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: James Braid <jamesb@loreland.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 14 Apr 2010 23:10:06 +0100
James Braid <jamesb@loreland.org> wrote:

> Trying to grow a 4 disk RAID 5 array to a 6 disk RAID 6 array - running 
> 2.6.34-rc2 (also tried with latest git, same sysfs errors)
> 
> Using mdadm from git.
> 
> Here's the error I get when I try to perform the grow:
> 
> # ./mdadm --grow --backup-file=/root/backup.md4 --level=6 
> --raid-devices=6 /dev/md4
> mdadm: Need to backup 768K of critical section..
> mdadm: /dev/md4: Cannot get array details from sysfs

That is odd, and isn't really explained by the dmesg errors you mentioned.

I'll have to do some experimentation to see if I can reproduce your symptom.

The sysfs errors are more noise than a real issue, I'm currently working on
a patch to get rid of them.

> 
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md4 : active raid6 sde[0] sdg[5](S) sdh[6](S) sdc[3] sdd[2] sdf[1]
>        4395415488 blocks level 6, 64k chunk, algorithm 18 [5/4] [UUUU_]

So it has converted your RAID5 to RAID6 with a special layout which places
all the Q blocks on the one disk.  That disk is missing.  So your data is
still safe, but the layout is somewhat unorthodox, and it didn't grow to 6
devices like you asked it to.

> After the grow failed, I stopped the array and restarted it. At that 
> point it appears to be continuing with the grow process? Is this correct?
...
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md4 : active raid6 sde[0] sdh[5] sdg[6](S) sdc[3] sdd[2] sdf[1]
>        4395415488 blocks level 6, 64k chunk, algorithm 18 [5/4] [UUUU_]
>        [>....................]  recovery =  0.0% (147712/1465138496) 
> finish=661.1min speed=36928K/sec

What is happening here is that the spare (sdh) is getting the Q blocks
written to it.  When this completes you will have full 2-disk redundancy but
the layout will not be optimal and the array wont be any bigger.
To fix this you would:

  mdadm --grow --backup-file=/root/backup.md4 --raid-devices=6 \
      --layout=normalise /dev/md4

Hopefully this will not hit the same problem that you hit before.

NeilBrown
