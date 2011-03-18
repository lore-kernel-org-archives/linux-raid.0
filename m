From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Raid0 metadata cannot be recognized
Date: Fri, 18 Mar 2011 12:36:25 +1100
Message-ID: <20110318123625.0f641c3c@notabene.brown>
References: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids


Sorry for the delayed reply - I've been swamped with other things.


On Tue, 15 Mar 2011 14:48:16 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Hi,
> 
> I've executed unit tests on today's devel3-2 and I've found that
> expansion cannot be executed due to fact that imsm metadata
> cannot be found after creation.
> Looking patches I've found that problem was introduced by patch:
> 
> Manage/external: for external metadata, add_to_super needs lock on container.
> 

Yes, I messed that up, didn't I.

> It is due to fact that metadata is not written by monitor for raid0.
> 
> Problem is fixed by patch:
>   FIX: Write metadata when mdmon is not running

That isn't quite right but does help me see where the problem is.
See below for the patch that I have committed.

> 
> Other patches addresses problems/i.e. inconsistency in closing handle/
> that I've noticed during investigation.
> 
> BR
> Adam
> 
> 
> ---
> 
> Adam Kwolek (4):
>       FIX: ping_monitor() usage causes memory leaks

nice clean up - thanks!  Applied.

>       FIX: Handle has to be closed

No it doesn't.  "free_super" closes this handle.  The place where I had a
'close' was wrong.  I've removed it.

>       FIX: Write metadata when mdmon is not running

As mentioned, I applied something which is a bit more complete.

>       FIX: Ping monitor when mdmon is running only

I cannot see why this would be necessary.  If mdmon is not running, then
ping_monitor will very quickly fail, so there is no need for an extra check,
is there?

Thanks,
NeilBrown

> 
> 
>  Assemble.c    |    2 +-
>  Create.c      |    2 +-
>  Grow.c        |    2 +-
>  Incremental.c |   10 ++++------
>  Manage.c      |   10 +++++++++-
>  Monitor.c     |    2 +-
>  msg.c         |   14 ++++++++++++++
>  msg.h         |    1 +
>  8 files changed, 32 insertions(+), 11 deletions(-)
> 



commit d6221e667f55c46505125ae182051de499000ed8
Author: NeilBrown <neilb@suse.de>
Date:   Fri Mar 18 12:31:45 2011 +1100

    Manage: fix the mess I made in earlier patch.
    
    When I separated the 'native metadata' case more cleanly from the
    "external metadata" case for adding a drive, I left some 'external'
    code in the 'native' case, and didn't copy it to the 'external' case.
    
    When - in the external case - we add to super, we much check for
    mdmon first, so we know whether to do the metadata update ourselves
    or not, then afterwards call either flush_metadata_updates (to send
    to mdmon) or sync_metadata (to do it directly).
    
    Reported-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Manage.c b/Manage.c
index 3361269..a679c24 100644
--- a/Manage.c
+++ b/Manage.c
@@ -835,9 +835,6 @@ int Manage_subdevs(char *devname, int fd,
 				if (dv->writemostly == 1)
 					disc.state |= 1 << MD_DISK_WRITEMOSTLY;
 				dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
-				if (tst->ss->external &&
-				    mdmon_running(tst->container_dev))
-					tst->update_tail = &tst->updates;
 				if (tst->ss->add_to_super(tst, &disc, dfd,
 							  dv->devname)) {
 					close(dfd);
@@ -898,13 +895,18 @@ int Manage_subdevs(char *devname, int fd,
 				}
 
 				dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
+				if (mdmon_running(tst->container_dev))
+					tst->update_tail = &tst->updates;
 				if (tst->ss->add_to_super(tst, &disc, dfd,
 							  dv->devname)) {
 					close(dfd);
 					close(container_fd);
 					return 1;
 				}
-				close(dfd);
+				if (st->update_tail)
+					flush_metadata_updates(st);
+				else
+					tst->ss->sync_metadata(st);
 
 				sra = sysfs_read(container_fd, -1, 0);
 				if (!sra) {
