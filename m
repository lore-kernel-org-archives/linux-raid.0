From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Report new_disks number when migration is started
Date: Mon, 18 Apr 2011 10:33:51 +1000
Message-ID: <20110418103351.76f3f594@notabene.brown>
References: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 15 Apr 2011 14:30:22 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> External metadata handler reports starting disks number during expansion
> until migration is finished. It is opposite to native metadata behavior
> where new disks number is reported immediately when expansion is started.
> This causes problem during expansion restart and causes exception
> due to wrong disks number information.
> 
> This patch series unifies reported raid disks number. After reshape
> is started external metadata handler reports new disks number now.
> 
> BR
> Adam
> 
> ---
> 
> Adam Kwolek (4):
>       FIX: Count correctly added devices
>       FIX: Set proper raid disks during migration
>       FIX: Fiddle raid_disks number for external metadta
>       FIX: Always report new raid_disks during migration
> 
> 

Thanks.  I've applied all this.

I change the second one a bit - please check that it still works for you.

Thanks.
NeilBrown


commit 178b8f353c4b4ffdf3bd4cd8c9dde37f64097da8
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Mon Apr 18 10:31:06 2011 +1000

    FIX: Fiddle raid_disks number when restarting reshape
    
    When restarting a reshape, the value of 'raid_disks' is the *new*
    value.  The old value is found by subtracting delta_disks.
    So before calling analyse_change we must set raid_disks to be the
    old value, and then reset it afterwards.
    
    All other fields are cleanly separated with the main field being
    the 'old' value and a new_* field available.
    
    Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index 017a79d..9c1f096 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1676,8 +1676,10 @@ static int reshape_array(char *container, int fd, char *devname,
 	if (info->reshape_active) {
 		int new_level = info->new_level;
 		info->new_level = UnSet;
+		info->array.raid_disks -= info->delta_disks;
 		msg = analyse_change(info, &reshape);
 		info->new_level = new_level;
+		info->array.raid_disks += info->delta_disks;
 		if (!restart)
 			/* Make sure the array isn't read-only */
 			ioctl(fd, RESTART_ARRAY_RW, 0);
