From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] A couple of Intel metadata fixes for mdadm-3.0-rc
Date: Mon, 18 May 2009 18:02:50 -0700
Message-ID: <1242694970.3830.9.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

Here are two imsm fixes.  The first, "imsm: fix num_domains" was
discovered by Jacek as the current value causes problems for the orom
when accessing raid1 arrays.  The second, "imsm: kill "auto=" in
brief_examine_super_imsm" was the fix I mentioned when you made your
call for final patches for mdadm-3.0-final.

Thanks,
Dan

The following changes since commit 222a7bfd2ea1696f84fa2f98196f5bdd851ac548:
  NeilBrown (1):
        Release mdadm-3.0-rc1

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (2):
      imsm: fix num_domains
      imsm: kill "auto=" in brief_examine_super_imsm

 super-intel.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

commit 1124b3cf29dad544e8a5aa01e5f9e94e7be1765a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon May 18 10:02:58 2009 -0700

    imsm: kill "auto=" in brief_examine_super_imsm
    
    The auto parameter is obsolete after kernel version 2.6.28 as all arrays
    are partitionable via block device extended minor support.  Environments
    that requre the mdp style of array can always edit the configuration
    file to specify auto=mdp.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index 35c43f4..73fe5fa 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -768,15 +768,14 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 
 	getinfo_super_imsm(st, &info);
 	fname_from_uuid(st, &info, nbuf, ':');
-	printf("ARRAY metadata=imsm auto=md UUID=%s\n", nbuf + 5);
+	printf("ARRAY metadata=imsm UUID=%s\n", nbuf + 5);
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
 
 		super->current_vol = i;
 		getinfo_super_imsm(st, &info);
 		fname_from_uuid(st, &info, nbuf1, ':');
-		printf("ARRAY /dev/md/%.16s container=%s\n"
-		       "   member=%d auto=mdp UUID=%s\n",
+		printf("ARRAY /dev/md/%.16s container=%s member=%d UUID=%s\n",
 		       dev->volume, nbuf + 5, i, nbuf1 + 5);
 	}
 }

commit 81062a36abd28d2354036da398c2e090fa759198
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon May 18 09:58:55 2009 -0700

    imsm: fix num_domains
    
    The 'num_domains' field simply identifies the number of mirrors.  So it
    is 2 for a 2-disk raid1 or a 4-disk raid10.  The orom does not currently
    support more than 2 mirrors, but a three disk raid1 for example would
    increase num_domains to 3.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index d7383fb..35c43f4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2405,13 +2405,16 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 				"in a raid1 volume\n");
 		return 0;
 	}
+
+	map->raid_level = info->level;
 	if (info->level == 10) {
 		map->raid_level = 1;
 		map->num_domains = info->raid_disks / 2;
-	} else {
-		map->raid_level = info->level;
+	} else if (info->level == 1)
+		map->num_domains = info->raid_disks;
+	else
 		map->num_domains = 1;
-	}
+
 	num_data_stripes = info_to_num_data_stripes(info, map->num_domains);
 	map->num_data_stripes = __cpu_to_le32(num_data_stripes);
 



