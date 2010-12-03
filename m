From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/2] Monitor: don't add more spares than needed
Date: Fri, 3 Dec 2010 14:12:50 +1100
Message-ID: <20101203141250.6330ee79@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C172D60@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C172D60@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Thu, 2 Dec 2010 21:59:27 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From ce59ecdb2b6a6e1fc65c645d0ca8733056e4979a Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Thu, 2 Dec 2010 22:48:19 +0100
> Subject: [PATCH 2/2] Monitor: don't add more spares than needed
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> When we add a spare to a container it takes a while
> before it is noticed by mdmon and recovery starts.
> During this time the array remains degraded but we don't want to add
> any more spares to this container. Therefore we must check container
> with degraded array if it doesn't already have a suitable spare.
> container_choose_spare is reused with from=to
> Domain check is not needed in this situation.
> 
> Ping_manager after moving disk is needed to be able to see
> newly added disk in container after coming back through the loop.
> 

Thanks for these.  I have applied both.

The second I made a few little changes to resulting the the following.

thanks,
NeilBrown


commit e9a2ac028eb66fdc50c079fc9bf03aa4325bcd5f
Author: Anna Czarnowska <anna.czarnowska@intel.com>
Date:   Fri Dec 3 14:11:29 2010 +1100

    Monitor: don't add more spares than needed
    
    When we add a spare to a container it takes a while
    before it is noticed by mdmon and recovery starts.
    During this time the array remains degraded but we don't want to add
    any more spares to this container. Therefore we must check container
    with degraded array if it doesn't already have a suitable spare.
    container_choose_spare is reused with from=to
    Domain check is not needed in this situation.
    
    Ping_manager after moving disk is needed to be able to see
    newly added disk in container after coming back through the loop.
    
    Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Monitor.c b/Monitor.c
index 8f1bfea..61550ee 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -743,6 +743,11 @@ static int move_spare(struct state *from, struct state *to,
 		devlist.disposition = 'a';
 		if (Manage_subdevs(to->devname, fd1, &devlist, -1, 0) == 0) {
 			alert("MoveSpare", to->devname, from->devname, info);
+			/* make sure we will see newly added spare before next
+			 * time through loop
+			 */
+			ping_manager(to->devname);
+			ping_manager(from->devname);
 			close(fd1);
 			close(fd2);
 			return 1;
@@ -853,13 +858,20 @@ static dev_t container_choose_spare(struct state *from, struct state *to,
 				dev = 0;
 				continue;
 			}
+			if (from == to)
+				/* Just checking if destination already has
+				 * a spare, no need to check policy, we are
+				 * done.
+				 */
+				break;
+
 			pol = devnum_policy(dev);
 			if (from->spare_group)
 				pol_add(&pol, pol_domain,
 					from->spare_group, NULL);
 			if (!domain_test(domlist, pol, to->metadata->ss->name))
 				dev = 0;
-			
+
 			dev_policy_free(pol);
 		}
 	}
@@ -887,6 +899,15 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 				to = to->parent;
 
 			min_size = min_spare_size_required(to);
+			if (to->metadata->ss->external) {
+				/* We must make sure there is
+				 * no suitable spare in container already.
+				 * If there is we don't add more */
+				dev_t devid = container_choose_spare(
+					to, to, NULL, min_size);
+				if (devid > 0)
+					continue;
+			}
 			for (d = 0; d < MaxDisks; d++)
 				if (to->devid[d])
 					domainlist_add_dev(&domlist,
