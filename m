From: "Phil Drummond" <raidtools@fubard.org>
Subject: [PATCH] raidreconf (v2)
Date: Sat, 6 Dec 2003 13:13:34 -0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <32812.192.168.65.254.1070716414.squirrel@web.fubard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok, restored bits of Jakob's code that I should never have touched in the first place and we seem to be in business.

happily converting between various combinations of raid0 and raid5 with & without spares, with component devices of different sizes.

anyone out there able to break it ?

Phil.


diff -ur raidtools-1.00.3/raidreconf.c raidtools-1.00.3-rrc_raid5_spare+unequal_v2/raidreconf.c
--- raidtools-1.00.3/raidreconf.c       Wed Jan 15 08:58:25 2003
+++ raidtools-1.00.3-rrc_raid5_spare+unequal_v2/raidreconf.c    Sat Dec  6 01:47:09 2003
@@ -93,7 +93,7 @@
        }

        if (version) {
-               printf ("raidreconf 0.1.2 for mkraid version %d.%d.%d\n",
+               printf ("raidreconf 0.1.2-h for mkraid version %d.%d.%d\n",
                        MKRAID_MAJOR_VERSION, MKRAID_MINOR_VERSION,
                        MKRAID_PATCHLEVEL_VERSION);
                return EXIT_VERSION;
@@ -175,7 +175,7 @@
                fprintf (stderr, "Parsing %s\n", old_raidtab);
                if (parse_config (fp)) {
                        fprintf (stderr,
-                                "Cannot parse old-array configuration file");
+                                "Cannot parse old-array configuration file\n");
                        return EXIT_FAILURE;
                }

@@ -218,7 +218,7 @@
                fprintf (stderr, "Parsing %s\n", new_raidtab);
                if (parse_config (fp)) {
                        fprintf (stderr,
-                                "Cannot parse new-array configuration file.\n");
+                                "Cannot parse new-array configuration file\n");
                        return EXIT_FAILURE;
                }

@@ -351,7 +351,7 @@
        int i;

        *sum = 0;
-       for (i = 0; i != cfg->array.param.nr_disks; i++) {
+       for (i = 0; i != cfg->array.param.raid_disks; i++) {
                int dnum = cfg->array.disks[i].raid_disk;
                char *devname = cfg->device_name[dnum];
                int fd = open (devname, O_RDONLY);
diff -ur raidtools-1.00.3/reconfiguration.c raidtools-1.00.3-rrc_raid5_spare+unequal_v2/reconfiguration.c
--- raidtools-1.00.3/reconfiguration.c  Wed Jan 15 08:58:25 2003
+++ raidtools-1.00.3-rrc_raid5_spare+unequal_v2/reconfiguration.c       Thu Dec  4 00:57:57 2003
@@ -94,11 +94,11 @@
        source_disk_free_map =

            (char **) malloc (sizeof (char *) *
-                             old_md_cfg->array.param.nr_disks);
+                             old_md_cfg->array.param.raid_disks);
        if (!source_disk_free_map)
                return "Cannot allocate source_disk_free_map";

-       for (sd = 0; sd != old_md_cfg->array.param.nr_disks; sd++) {
+       for (sd = 0; sd != old_md_cfg->array.param.raid_disks; sd++) {
                /* initialize .reconf_blocks in rrc structure */
                old_rrc_cfg[sd].reconf_blocks = old_rrc_cfg[sd].blocks;
 #if 0
@@ -121,7 +121,7 @@
        }

        /* Initialize the sink disk .reconf_blocks as well */
-       for (sd = 0; sd != new_md_cfg->array.param.nr_disks; sd++) {
+       for (sd = 0; sd != new_md_cfg->array.param.raid_disks; sd++) {
                new_rrc_cfg[sd].reconf_blocks = new_rrc_cfg[sd].blocks;
 #if 0
                new_rrc_cfg[sd].reconf_blocks = new_rrc_cfg[sd].chunks
@@ -247,7 +247,7 @@

        if (
            (ret =
-            setup_free_blocks (old_md_cfg->array.param.nr_disks,
+            setup_free_blocks (old_md_cfg->array.param.raid_disks,
                                old_rrc_cfg))) return ret;

        if ((ret = initialize_unique_disks ()))
diff -ur raidtools-1.00.3/rrc_common.c raidtools-1.00.3-rrc_raid5_spare+unequal_v2/rrc_common.c
--- raidtools-1.00.3/rrc_common.c       Wed Jan 15 08:58:25 2003
+++ raidtools-1.00.3-rrc_raid5_spare+unequal_v2/rrc_common.c    Thu Dec  4 00:57:57 2003
@@ -434,7 +434,7 @@

        /*
         * This may be a request to free a block from the source disks, where the
-        * corrosponding location on the sink disks is not yet free.
+        * corresponding location on the sink disks is not yet free.
         * The common reader will detect this case and bring two gifts from only
         * one wish.  So, worst case, we will end up with twice as many gifts
         * as we had wishes.
@@ -457,7 +457,7 @@
        unsigned long ret = 0;
        int d;

-       for (d = 0; d != old_md_cfg->array.param.nr_disks; d++) {
+       for (d = 0; d != old_md_cfg->array.param.raid_disks; d++) {
                ret += nr_free_disk_blocks[d];
 /*      fprintf(stderr, "\nFree blocks in disk %i = %lu\n", d, nr_free_disk_blocks[d]); */
        }
@@ -470,7 +470,7 @@
 {
        int d;

-       for (d = 0; d != old_md_cfg->array.param.nr_disks; d++)
+       for (d = 0; d != old_md_cfg->array.param.raid_disks; d++)
                if (old_rrc_cfg[d].disk_id == diskid)
                        return 1;
        return 0;
@@ -482,10 +482,10 @@
        int disk;
        unsigned long blk, ofs;

-       for (disk = 0; disk != old_md_cfg->array.param.nr_disks; disk++)
+       for (disk = 0; disk != old_md_cfg->array.param.raid_disks; disk++)
                if (old_rrc_cfg[disk].disk_id == diskid)
                        break;
-       if (disk == old_md_cfg->array.param.nr_disks) {
+       if (disk == old_md_cfg->array.param.raid_disks) {
                /* disk is not in source, so block is free per definition */
                return 1;
        }
@@ -517,10 +517,10 @@
        int disk;
        unsigned long blk, ofs;

-       for (disk = 0; disk != old_md_cfg->array.param.nr_disks; disk++)
+       for (disk = 0; disk != old_md_cfg->array.param.raid_disks; disk++)
                if (old_rrc_cfg[disk].disk_id == diskid)
                        break;
-       if (disk == old_md_cfg->array.param.nr_disks) {
+       if (disk == old_md_cfg->array.param.raid_disks) {
                /* disk is not in source, so block is free per definition */
                fprintf (stderr, "\ndisk_id %i not in source\n", diskid);
                return;
@@ -582,10 +582,10 @@
        int disk;
        unsigned long blk, ofs;

-       for (disk = 0; disk != old_md_cfg->array.param.nr_disks; disk++)
+       for (disk = 0; disk != old_md_cfg->array.param.raid_disks; disk++)
                if (old_rrc_cfg[disk].disk_id == diskid)
                        break;
-       if (disk == old_md_cfg->array.param.nr_disks) {
+       if (disk == old_md_cfg->array.param.raid_disks) {
                /* disk is not in source, so block cannot be unfreed
                 * This is an acceptable error, (in order to keep the unfree_all_blocks() routines simple
                 */
@@ -626,7 +626,7 @@
 {
        int disk;

-       for (disk = 0; disk != old_md_cfg->array.param.nr_disks; disk++) {
+       for (disk = 0; disk != old_md_cfg->array.param.raid_disks; disk++) {
                unsigned long blk;

                fprintf (stderr, "\nUnfree blocks on disk %i\n", disk);
@@ -673,7 +673,7 @@
        const char *ret = 0;

        /* Traverse sink disks */
-       for (dsk = 0; dsk != new_md_cfg->array.param.nr_disks; dsk++) {
+       for (dsk = 0; dsk != new_md_cfg->array.param.raid_disks; dsk++) {
                fulfilled_t *gift =

                    gift_list_sink_diskid (new_rrc_cfg[dsk].disk_id);
@@ -737,7 +737,7 @@
         * to know that the write has completed, if we will be doing more
         * sophisticated requesting in the future
         */
-       for (dsk = 0; dsk != new_md_cfg->array.param.nr_disks; dsk++)
+       for (dsk = 0; dsk != new_md_cfg->array.param.raid_disks; dsk++)
                fsync (new_rrc_cfg[dsk].fd);

        return ret;
@@ -902,11 +902,11 @@
                cdepth++;
                /* Calculate block and disk numbers */
                source_block = block * reconf_block_size;
-               for (dsk = 0; dsk != old_md_cfg->array.param.nr_disks;
+               for (dsk = 0; dsk != old_md_cfg->array.param.raid_disks;
                     dsk++)
                        if (old_rrc_cfg[dsk].disk_id == diskid)
                                break;
-               if (dsk == old_md_cfg->array.param.nr_disks) {
+               if (dsk == old_md_cfg->array.param.raid_disks) {
                        fprintf (stderr,
                                 "Diskid %i is not in source, when freeing blocks and their friends...\n",
                                 diskid);
diff -ur raidtools-1.00.3/rrc_raid5.c raidtools-1.00.3-rrc_raid5_spare+unequal_v2/rrc_raid5.c
--- raidtools-1.00.3/rrc_raid5.c        Wed Jan 15 08:58:25 2003
+++ raidtools-1.00.3-rrc_raid5_spare+unequal_v2/rrc_raid5.c     Sat Dec  6 02:08:46 2003
@@ -39,10 +39,10 @@
        if (cfg->array.param.level != 5)
                return ("Wrong level for RAID-5 Driver");

-       if (cfg->array.param.nr_disks < 3)
+       if (cfg->array.param.raid_disks < 3)
                return "Too few disks for RAID5";

-       ctx->raid_disks = cfg->array.param.nr_disks;
+       ctx->raid_disks = cfg->array.param.raid_disks;
        ctx->data_disks = ctx->raid_disks-1;
        ctx->chunk_size = cfg->array.param.chunk_size;
        ctx->algorithm = cfg->array.param.layout;
@@ -51,11 +51,16 @@

        /* sum the total blocks in the array */
        ctx->tot_chunks = 0;
-       for (d = 0; d < ctx->raid_disks; ++d)
-               ctx->tot_chunks += ctx->disks[d].chunks;
+       for (d = 0; d < cfg->array.param.nr_disks; ++d) {
+               if ((!ctx->tot_chunks) || (ctx->disks[d].chunks < ctx->tot_chunks)) {
+                       ctx->tot_chunks = ctx->disks[d].chunks;
+               }
+       }
+       fprintf(stderr, "RAID5 smallest component %lu chunks\n", ctx->tot_chunks);

        /* RAID5 uses one disk's worth of data for parity, so subtract it */
-       ctx->tot_chunks -= ctx->disks[0].chunks;
+       ctx->tot_chunks *= (ctx->raid_disks - 1);
+       fprintf(stderr, "RAID5 array total %lu chunks\n", ctx->tot_chunks);

        /* set up the disk_id -> disks[] mapping */
        for (d = 0; d < ctx->raid_disks; ++d)
@@ -84,8 +89,9 @@

        for (d = 0; d < ctx->raid_disks; ++d)
                ctx->disk_total_blocks[d] =
-                   cfgdisks[d].chunks * (ctx->chunk_size / MD_BLK_SIZ) /
-                   reconf_block_size;
+                   (ctx->tot_chunks / (ctx->raid_disks - 1)) *
+                       (ctx->chunk_size / MD_BLK_SIZ) /
+                           reconf_block_size;

        return NULL;
 }



