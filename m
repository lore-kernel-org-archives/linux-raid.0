From: NeilBrown <neilb@suse.de>
Subject: Re: After 0->10 takeover process hangs at "wait_barrier"
Date: Thu, 3 Feb 2011 18:35:48 +1100
Message-ID: <20110203183548.3b875693@notabene.brown>
References: <BE2BFE91933D1B4089447C6448604080670E9A24@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C6448604080670E9A24@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2 Feb 2011 12:15:28 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> Neil,
> 
> I would like to return to problem related to raid0->raid10 takeover operation.
> I observed following symptoms:
> 1. After raid0->raid10 takeover we have array with 2 missing disks. When we add disk for rebuild, recovery process starts as expected but it does not finish- it stops at about 90%, md126_resync process hangs in "D" state
> 2. Similar behavior is when we have mounted raid0 array and we execute takeover to raid10. After this when we try to unmount array- it causes process umount hangs in "D"
> 
> In scenarios above processes hang at the same function- wait_barrier in raid10.c.
> Process waits in macro "wait_event_lock_irq" until the "!conf->barrier" condition will be true. In scenarios above it never happens.
> 
> Issue does not appear if after takeover we stop array and assemble it again- we can rebuild disks without problem. It indicates that raid0->raid10 takeover process does not initialize all array parameters in proper way.
> 
> Do you have any suggestions what can I do to get closer to solving this problem?

Yes.

Towards the end of level_store, after calling pers->run, we call
mddev_resume..
This calls pers->quiesce(mddev, 0)

With RAID10, that calls lower_barrier.
However raise_barrier hadn't been called on that 'conf' yet,
so conf->barrier becomes negative, which is bad.

Maybe raid10_takeover_raid0 should call raise_barrier on the conf
before returning it.
I suspect that is the right approach, but I would need to review some
of the code in various levels to make sure it makes sense, and would
need to add some comments to clarify this.

Could you just try that one change and see if it fixed the problem?

i.e.

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 69b6595..10b636d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2467,7 +2467,7 @@ static void *raid10_takeover_raid0(mddev_t *mddev)
 		list_for_each_entry(rdev, &mddev->disks, same_set)
 			if (rdev->raid_disk >= 0)
 				rdev->new_raid_disk = rdev->raid_disk * 2;
-		
+	conf->barrier++;
 	return conf;
 }
 


Thanks,
NeilBrown
