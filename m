From: mwilck@arcor.de
Subject: DDF/RAID10 patch series
Date: Wed,  3 Jul 2013 22:27:40 +0200
Message-ID: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This is the DDF/RAID10 patch series I announced.

The whole patch set is aimed at making --Create work with DDF/RAID10.
When --Create eventually works, RAID10 can be added to the DDF
regression test.

With this patch set, DDF is still far from the level of functionality
present in IMSM, but getting a little closer.

The patch set also includes some cleanup patches and debug code which
I needed to find the bugs in earlier versions, and which might be useful
later as well.

Please review and test.

Regards
Martin

Martin Wilck (27):
  DDF (cleanup): use a common macro for failed searches
  DDF: check_secondary: fix treatment of missing BVDs
  DDF: load_ddf_headers: use secondary header as fallback
  DDF: handle "open flag" according to spec
  DDF: Implement store_super_ddf
  DDF: ddf_open_new: implement minimal consistency check
  DDF: find_vdcr: account for secondary RAID level
  DDF: ddf_set_disk: move status logic to separate function
  DDF: get_svd_state: Status logic for secondary RAID level
  DDF: allow empty slots in virt disk table
  DDF: layout_ddf2md: new DDF->md RAID layout conversion
  DDF: layout_md2ddf: new md->DDF layout conversion
  DDF: Simplify allocation of "other BVDs"
  DDF: init_super_ddf_bvd: initialize other bvds
  DDF: validate_geometry_ddf: support RAID10
  DDF: use LBA_OFFSET macro instead of lba_offset field
  DDF: get_extents: support secondary RAID level
  DDF: add_to_super_ddf: allow empty slots in phys disk table
  DDF: add_to_super_ddf: Use same amount of workspace as other disks
  DDF: add_to_super_ddf: RAID10 changes
  DDF: add_to_super_ddf_bvd: use get_svd_state()
  DDF: getinfo_super_ddf_bvd: lba_offset calculation for RAID10
  DDF: guid_str: convenience function to print GUID for debugging
  DDF: ddf_set_array_state: more meaningful output
  DDF: ddf_process_update: handle update of conf records for SVD
  DDF: ddf_process_update: Fix vlist treatment for SVDs
  tests/10ddf-create: add RAID 10 array

 super-ddf.c        | 1134 +++++++++++++++++++++++++++++++++-------------------
 tests/10ddf-create |   15 +-
 2 files changed, 739 insertions(+), 410 deletions(-)
