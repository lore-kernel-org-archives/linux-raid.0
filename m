From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: RE: crash: write_sb_page walks mddev.disks without holding reconfig_mutex
Date: Thu, 24 Jul 2008 08:42:54 -0400
Message-ID: <3DC430E8F4814543943B52C2F34BF52A1194A2@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: 18565.5132.347195.910949@notabene.brown
References: message from Dailey, Nate on Monday July 21 18565.5132.347195.910949@notabene.brown
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, mingo@redhat.com
List-Id: linux-raid.ids

This version of the patch seems to do the trick... at least I haven't so
far hit a failure testing with it.

Thanks!

Nate


 

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Monday, July 21, 2008 6:56 PM
To: Dailey, Nate
Cc: linux-raid@vger.kernel.org; mingo@redhat.com
Subject: RE: crash: write_sb_page walks mddev.disks without holding
reconfig_mutex

On Monday July 21, Nate.Dailey@stratus.com wrote:
> Quick update... I've applied your patch to the kernel I'm using. There
> were a few differences... for example, md_delayed_delete doesn't exist
> in my kernel (so I added it).
> 
> Unfortunately, I'm hitting a deadlock, and it looks like
md_delayed_work
> is at fault. Seems that in at least one case, code which holds the
> inode_lock is interrupted, at which point the md_delayed_delete code
> gets to run. He ends up needing the inode_lock too, and we're stuck.

Yes.... I noticed yesterday that there was a problem with that patch.
calling md_delayed_delete with call_rcu just isn't right.
md_delayed_delete needs to get a mutex, and call_rcu calls things in a
context where mutexes aren't allowed.  The problem you are seeing has
exactly the same cause.

So I've changed it to:
  call synchronise_rcu() to handle the RCU side, and
  restore the use of schedule_work to run md_delayed delete.
so unbind_rdev_from_array now ends.
	synchronize_rcu();
	INIT_WORK(&rdev->del_work, md_delayed_delete);
	kobject_get(&rdev->kobj);
	schedule_work(&rdev->del_work);

You can see the submitted version of the full patch at 

 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
tdiff;h=4b80991c6cb9efa607bc4fd6f3ecdf5511c31bb0

If you can test that (with appropriate revisions to apply to your
kernel) I'd really appreciate it.

Thanks,
NeilBrown
