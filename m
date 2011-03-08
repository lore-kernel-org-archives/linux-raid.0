From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/9] Grow_continue() - single array.
Date: Tue, 8 Mar 2011 17:43:17 +1100
Message-ID: <20110308174317.489684f1@notabene.brown>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids


Hi Adam,
 I've reviewed this set of patches, applied a few of them, and
made some patches of my own that should achieve the result that I think you
were aiming for.  I haven't tested them so there might still be some
issues...

Two important points.

1/ I now require getinfo_super and container_content to present a
 reshape_active array in a form that md can cope with it.  So a
 RAID0 array that is in the middle of a reshape must appear to be
 a RAID4 or RAID5 array.
 I have changed super-intel to do this, but I have probably missed
 some cases - please check that all supported migrations that cannot
 be handled directly are handled by the new code.

 With this in place, I have changed sysfs_set_array to set up all
 the geometry of the array, both old and new.  I think this makes
 a lot of things a lot cleaner.

2/ I've revised how to handle the restart of a container-wide
  migration.
  As there is only one array in such a container that is actually
  migrating, the mdadm which assembles it can be the one that forks
  and managed the whole container.
  This now happens.  The metadata informs metadata that a container-wide
  reshape is needed by setting ->reshape_active to '2'.


I have added a 'freeze' call where I think it should go but I wouldn't be at
all surprised if I got it wrong.

Please review the patch - which are all in my devel-3.2 branch
    http://neil.brown.name/git?p=mdadm;a=log;h=refs/heads/devel-3.2

and let me know what you think.

Thanks,
NeilBrown

