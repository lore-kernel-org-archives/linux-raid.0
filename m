From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5: failing an active component during spare rebuild -
 arrays hangs
Date: Wed, 22 Jun 2011 12:54:09 +1000
Message-ID: <20110622125409.14428883@notabene.brown>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 5 Jun 2011 22:41:55 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello everybody,
> I am testing a scenario, in which I create a RAID5 with three devices:
> /dev/sd{a,b,c}. Since I don't supply --force to mdadm during creation,
> it treats the array as degraded and starts rebuilding the sdc as a
> spare. This is as documented.
> 
> Then I do --fail on /dev/sda. I understand that at this point my data
> is gone, but I think should still be able to tear down the array.
> 
> Sometimes I see that /dev/sda is kicked from the array as faulty, and
> /dev/sdc is also removed and marked as a spare. Then I am able to tear
> down the array.
> 
> But sometimes, it looks like the system hits some kind of a deadlock.

I cannot reproduce this, either on current mainline or 2.6.38.  I didn't try
the particular Ubuntu kernel that you mentioned as I don't have any Ubuntu
machines.
It is unlikely that Ubuntu have broken something, but not impossible... are
you able to compile a kernel.org kernel (preferably 2.6.39) and see if you
can reproduce.

Also, can you provide a simple script that will trigger the bug reliably for
you.

I did:

while : ; do mdadm -CR /dev/md0 -l5 -n3 /dev/sd[abc] ; sleep 5; mdadm /dev/md0 -f /dev/sda ; mdadm -Ss ; echo ; echo; done

and it has no problems at all.

Certainly a deadlock shouldn't be happening...

 From the stack trace you get it looks like it is probably hanging at

	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));

which suggests that so resync request started and didn't complete.  I've
never seen a hang there before.

NeilBrown

