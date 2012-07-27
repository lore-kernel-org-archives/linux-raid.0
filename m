From: David Dillow <dave@thedillows.org>
Subject: Re: RAID extremely slow
Date: Thu, 26 Jul 2012 22:15:03 -0400
Message-ID: <1343355303.29938.5.camel@obelisk.thedillows.org>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>
	 <5010A386.4080209@familyross.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5010A386.4080209@familyross.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Kevin Ross <kevin@familyross.net>
Cc: Phil Turmel <philip@turmel.org>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2012-07-25 at 18:55 -0700, Kevin Ross wrote:
> On 07/25/2012 06:00 PM, Phil Turmel wrote:
> > Piles of small reads  scattered across multiple drives, and a
> > concentration of queued writes to /dev/sda.  What's on /dev/sda?
> > It's not a member of the raid, so it must be some other system task
> > involved.

> After rebooting, MythTV is currently recording two shows, and the resync 
> is running at full speed.
> 
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdh1[0] sdd1[9] sde1[10] sdb1[6] sdi1[7] sdc1[4] 
> sdf1[3] sdg1[8] sdj1[1]
>        6837311488 blocks super 1.2 level 6, 512k chunk, algorithm 2 
> [9/9] [UUUUUUUUU]
>        [=>...................]  resync =  9.3% (91363840/976758784) 
> finish=1434.3min speed=10287K/sec
> 
> unused devices: <none>
> 
> atop shows the avio of all the drives to be less than 1ms, where before 
> they were much higher.  It will run for a couple days under load just 
> fine, and then it will come to a halt.
> 
> It's a 3.2.21 kernel.  I'm running Debian Testing, and the exact Debian 
> package version is:

I suspect you are being hit by same bug I was -- delayed stripes never
got processed. If you get into the state where the rebuild isn't
progressing, and you find that increasing the size of the stripe cache
allows the rebuild to proceed (but the filesystem stays wedged), then
that cinches it.

If you can, upgrade to the latest 3.4 stable kernel (3.4.6 right now).
As far as I can see, the latest 3.2 stable does not contain the delayed
stripe fix.

After applying those fixes to my kernel, my MythTV setup over a 5 disk
RAID5 has been pretty solid, where before I was getting lockups every
few days. It still seems to be getting slower over time, but I've not
looked into it yet as it is not as catastrophic as the wedging.

HTH,
Dave
