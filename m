From: "Phil Drummond" <raidtools@fubard.org>
Subject: [PATCH] parser.c stronger
Date: Wed, 3 Dec 2003 21:33:34 -0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <32864.192.168.65.254.1070487214.squirrel@web.fubard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

This patch aims to make the raidtab parser stronger.

I found that with a duff new raidtab for raidreconf it was possible to
reconf the array then fail to write the superblocks. I figured add checks
to the parser rather than raidreconf so all utils get to use the extra
checks (though mkraid does a number of these checks already)

The way the checks are done allows the raidtab syntax to be a little
looser in as much as the options can ve defined in any order after the
raiddev statement that introduces the stanza and the device entries can be
in any order, though they must still be defined after the options.

It does now insist on chunk-size being defined for all levels except
linear rather than risking defaults with the likes of raidreconf.

It fails to parse the example multipath config because the only spare-disk
is defined as 1 rather than 0. I spent ages checking if multipath required
this anomaly. Apparently it does not. If anyone knows any different please
let me know.

any more info on hsm and translucent levels anywhere ?

regards

Phil.


diff -ur raidtools-1.00.3/parser.c raidtools-1.00.3+parser_stronger/parser.c
--- raidtools-1.00.3/parser.c   Wed Jan 15 08:58:25 2003
+++ raidtools-1.00.3+parser_stronger/parser.c   Wed Dec  3 20:12:50 2003
@@ -36,7 +36,7 @@

 static int process_entry (char *par, char *val_s)
 {
-       int val, i;
+       int val, i, j;
        md_raid_info_t *array;
        md_cfg_entry_t *last;

@@ -68,6 +68,10 @@
                }
                strcpy(cfg->md_name, val_s);
                cfg->array.param.nr_disks = 0;
+               cfg->array.param.level = -9;
+               cfg->array.param.layout = -1;
+               cfg->array.param.raid_disks = -1;
+               cfg->array.param.spare_disks = -1;

                last = cfg_head;
                while (last && last->next) last = last->next;
@@ -101,37 +105,43 @@
                        fprintf(stderr, "raid level %d not supported\n",
val);
                        return 1;
                }
-               array->param.level = val;
-               if ((val == 0) || (val == -1))
-                       array->param.not_persistent = 1;
-               else
-                       array->param.not_persistent = 0;
-               return 0;
+               if (array->param.level == -9) {
+                       array->param.level = val;
+                       if ((val == 0) || (val == -1))
+                               array->param.not_persistent = 1;
+                       else
+                               array->param.not_persistent = 0;
+                       return 0;
+               } else {
+                       fprintf(stderr, "raid-level defined twice in
%s\n", cfg->md_name);
+                       return 1;
+               }
        } else if (strcmp(par, "nr-raid-disks") == 0) {
                if (val < 0)
                        return 1;
-               array->param.raid_disks = val;
-               return 0;
+               if (array->param.raid_disks < 0) {
+                       array->param.raid_disks = val;
+                       return 0;
+               } else {
+                       fprintf(stderr, "nr-raid-disks defined twice in
%s\n", cfg->md_name);
+                       return 1;
+               }
        } else if (strcmp(par, "persistent-superblock") == 0) {
                if ((val < 0) || (val > 1))
                        return 1;
                array->param.not_persistent = 1-val;
                return 0;
        } else if (strcmp(par, "nr-spare-disks") == 0) {
-               if ((array->param.level < 1) && (array->param.level != -4)
&& val) {
-                       fprintf(stderr, "nr-spare-disks must be zero for
raid level %d\n", array->param.level);
-                       return 1;
-               }
-
                if (val < 0)
                        return 1;
-               array->param.spare_disks = val;
-               return 0;
-       } else if (strcmp(par, "parity-algorithm") == 0) {
-               if (array->param.level != 5) {
-                       fprintf(stderr, "parity-algorithm undefined for
raid level %d\n", array->param.level);
+               if (array->param.spare_disks < 0) {
+                       array->param.spare_disks = val;
+                       return 0;
+               } else {
+                       fprintf(stderr, "nr-spare-disks defined twice in
%s\n", cfg->md_name);
                        return 1;
                }
+       } else if (strcmp(par, "parity-algorithm") == 0) {
                if (val < 0)
                        val = parity_algorithm_to_num(val_s);
                if (val < 0)
@@ -139,6 +149,10 @@
                array->param.layout = val;
                return 0;
        } else if (strcmp(par, "chunk-size") == 0) {
+               if (array->param.chunk_size) {
+                       fprintf(stderr, "chunk-size defined twice in
%s\n", cfg->md_name);
+                       return 1;
+               }
                if (!val || val % 4 || ((1 << (ffs(val)-1)) != val)) {
                        fprintf(stderr, "invalid chunk-size (%dkB)\n", val);
                        return 1;
@@ -151,38 +165,84 @@
                        return 1;
                }
                i = array->param.nr_disks++;
+               i--;
+               if ((i > 0) && (array->disks[i].raid_disk == -1)) {
+                       fprintf(stderr, "disk index line expected\n");
+                       return 1;
+               }
+               i++;
                if ((cfg->device_name[i] = malloc(strlen(val_s) + 1)) ==
NULL) {
                        fprintf(stderr, "out of memory\n");
                        return 1;
                }
                strcpy(cfg->device_name[i], val_s);
-               array->disks[i].raid_disk = i;
+               array->disks[i].raid_disk = -1;
                return 0;
        } else if (strcmp(par, "raid-disk") == 0) {
+               if (array->param.level == -9) {
+                       fprintf(stderr, "raid-level not defined before
disks in %s\n", cfg->md_name);
+                       return 1;
+               }
+               if (array->param.raid_disks == -1) {
+                       fprintf(stderr, "nr-raid-disks not defined before
disks in %s\n", cfg->md_name);
+                       return 1;
+               }
                if (!array->param.nr_disks) {
                        fprintf(stderr, "\"device\" line expected\n");
                        return 1;
                }
-               if (val >= array->param.raid_disks) {
-                       fprintf(stderr, "raid-disk should be smaller than
raid_disks\n");
+               if ((val < 0 ) || (val >= array->param.raid_disks)) {
+                       fprintf(stderr, "bad raid-disk index %d\n", val);
                        return 1;
                }
                i = array->param.nr_disks - 1;
+               if (array->disks[i].raid_disk != -1) {
+                       fprintf(stderr, "\"device\" line expected\n");
+                       return 1;
+               }
                array->disks[i].raid_disk = val;
                return 0;
        } else if (strcmp(par, "spare-disk") == 0) {
+               if (array->param.level == -9) {
+                       fprintf(stderr, "raid-level not defined before
disks in %s\n", cfg->md_name);
+                       return 1;
+               }
+               if (array->param.raid_disks == -1) {
+                       fprintf(stderr, "nr-raid-disks not defined before
disks in %s\n", cfg->md_name);
+                       return 1;
+               }
                if ((array->param.level != 5) && (array->param.level != 4)
&& (array->param.level != 1) && (array->param.level !=
-4)) {
                        fprintf(stderr, "spare-disk not supported for raid
level %d\n", array->param.level);
                        return 1;
                }
+               if (array->param.spare_disks < 1) {
+                       fprintf(stderr, "spare-disk defined but none
expected for %s\n", cfg->md_name);
+                       return 1;
+               }
                if (!array->param.nr_disks) {
                        fprintf(stderr, "\"device\" line expected\n");
                        return 1;
                }
+               if ((val < 0) || (val >= array->param.spare_disks)) {
+                       fprintf(stderr, "bad spare-disk index %d\n", val);
+                       return 1;
+               }
                i = array->param.nr_disks - 1;
-               array->disks[i].raid_disk = i;
+               if (array->disks[i].raid_disk != -1) {
+                       fprintf(stderr, "\"device\" line expected\n");
+                       return 1;
+               }
+               array->disks[i].raid_disk = array->param.raid_disks + val;
                return 0;
        } else if (strcmp(par, "parity-disk") == 0) {
+               if (array->param.level == -9) {
+                       fprintf(stderr, "raid-level not defined before
disks in %s\n", cfg->md_name);
+                       return 1;
+               }
+               if (array->param.raid_disks == -1) {
+                       fprintf(stderr, "nr-raid-disks not defined before
disks in %s\n", cfg->md_name);
+                       return 1;
+               }
                if (!array->param.nr_disks) {
                        fprintf(stderr, "\"device\" line expected\n");
                        return 1;
@@ -192,23 +252,116 @@
                        return 1;
                }
                i = array->param.nr_disks - 1;
+               if (array->disks[i].raid_disk != -1) {
+                       fprintf(stderr, "\"device\" line expected\n");
+                       return 1;
+               }
                array->disks[i].raid_disk = array->param.raid_disks - 1;
                return 0;
        } else if (strcmp(par, "failed-disk") == 0) {
+               if (array->param.level == -9) {
+                       fprintf(stderr, "raid-level not defined before
disks in %s\n", cfg->md_name);
+                       return 1;
+               }
+               if (array->param.raid_disks == -1) {
+                       fprintf(stderr, "nr-raid-disks not defined before
disks in %s\n", cfg->md_name);
+                       return 1;
+               }
                if ((array->param.level != 5) && (array->param.level != 4)
&& (array->param.level != 1)) {
                        fprintf(stderr, "failed-disk not supported for
raid level %d\n", array->param.level);
                        return 1;
                }
-               if (val >= array->param.raid_disks) {
-                       fprintf(stderr, "failed-disk should be smaller
than raid_disks\n");
+               if (!array->param.nr_disks) {
+                       fprintf(stderr, "\"device\" line expected\n");
+                       return 1;
+               }
+               if ((val < 0) || (val >= array->param.raid_disks)) {
+                       fprintf(stderr, "bad failed-disk index %d\n", val);
                        return 1;
                }
                i = array->param.nr_disks - 1;
+               if (array->disks[i].raid_disk != -1) {
+                       fprintf(stderr, "\"device\" line expected\n");
+                       return 1;
+               }
                array->disks[i].raid_disk = val;
                array->disks[i].state |= (1 << MD_DISK_FAULTY);
                array->param.failed_disks++;
                return 0;
-
+       } else if (strcmp(par, "verify-stanza") == 0) {
+               /*
+                * check for missing and incompatible options
+                * check each slot in array index has an entry
+                */
+/*             fprintf(stderr, "verifying stanza %s\n", cfg->md_name); */
+               if (array->param.spare_disks == -1)
+                       array->param.spare_disks = 0;
+               if (array->param.level == -9) {
+                       fprintf(stderr, "raid-level not defined in %s\n",
cfg->md_name);
+                       return 1;
+               }
+               if (!array->param.chunk_size && (array->param.level != -1)) {
+                       fprintf(stderr, "chunk-size not defined in %s\n",
cfg->md_name);
+                       return 1;
+               }
+               if (array->param.raid_disks < 0) {
+                       fprintf(stderr, "nr-raid-disks not defined in
%s\n", cfg->md_name);
+                       return 1;
+               }
+               if ((array->param.level < 1) && (array->param.level != -4)
&& (array->param.spare_disks != 0)) {
+                       fprintf(stderr, "nr-spare-disks must be zero for
raid level %d in %s\n", array->param.level, cfg->md_name);
+                       return 1;
+               }
+               if ((array->param.layout > -1) && (array->param.level !=
5)) {
+                       fprintf(stderr, "parity-algorithm undefined for
raid level %d in %s\n", array->param.level, cfg->md_name);
+                       return 1;
+               }
+               if ((array->param.level == 5) && (array->param.layout < 0)) {
+                       fprintf(stderr, "parity-algorithm required for
raid level %d in %s\n", array->param.level, cfg->md_name);
+                       return 1;
+               }
+               if (array->param.nr_disks != array->param.raid_disks +
array->param.spare_disks) {
+                       fprintf(stderr, "device entries does not match
defined number of disks in %s\n", cfg->md_name);
+                       return 1;
+               }
+               for (i = 0; i < array->param.nr_disks - 1; i++) {
+                       par = cfg->device_name[i];
+                       val = array->disks[i].raid_disk;
+                       if (val == -1) {
+                               fprintf(stderr, "%s index not set in %s\n",
+                                               par, cfg->md_name);
+                               return 1;
+                       }
+                       for (j = i + 1; j < array->param.nr_disks; j++) {
+                               if (strcmp(par, cfg->device_name[j]) == 0) {
+                                       fprintf(stderr, "%s not unique in
%s\n", par, cfg->md_name);
+                                       return 1;
+                               }
+                               if (val == array->disks[j].raid_disk) {
+                                       fprintf(stderr, "error in disk
indexes in %s\n", cfg->md_name);
+                                       return 1;
+                               }
+                       }
+               }
+               /* check last item as loop does disks - 1 */
+               if (array->disks[i].raid_disk == -1) {
+                       fprintf(stderr, "%s index not set in %s\n",
cfg->device_name[i], cfg->md_name);
+                       return 1;
+               }
+               /* sort devices as we allow any order in raidtab */
+               for (i = 0; i < array->param.nr_disks - 1; i++) {
+                       par = cfg->device_name[i];
+                       val = array->disks[i].raid_disk;
+                       while (val != i) {
+                               cfg->device_name[i] = cfg->device_name[val];
+                               array->disks[i].raid_disk =
array->disks[val].raid_disk;
+                               cfg->device_name[val] = par;
+                               array->disks[val].raid_disk = val;
+                               par = cfg->device_name[i];
+                               val = array->disks[i].raid_disk;
+                       }
+               }
+               return 0;
        }
        fprintf(stderr, "unrecognized option %s\n", par);
        return 1;
@@ -216,7 +369,7 @@

 int parse_config (FILE *fp)
 {
-       int nr = 0;
+       int nr = 0, indevflag = 0;
        char line[MAX_LINE_LENGTH], par[MAX_LINE_LENGTH],
val[MAX_LINE_LENGTH];

 #if DEBUG
@@ -236,11 +389,25 @@
 #if DEBUG
                printf("par == %s, val == %s\n", par, val);
 #endif /* DEBUG */
+               if (strcmp(par, "verify-stanza") == 0) {
+                       printf("detected error on line %d:\n\t%s", nr, line);
+                       return 1;
+               }
+               if (strcmp(par, "raiddev") == 0) {
+                       if (!indevflag) {
+                               indevflag++;
+                       } else {
+                               if (process_entry("verify-stanza", "0"))
+                                       return 1;
+                       }
+               }
                if (process_entry(par, val)) {
                        printf("detected error on line %d:\n\t%s", nr, line);
                        return 1;
                }
        }
+       if ((indevflag) && (process_entry("verify-stanza", "0")))
+               return 1;
 #if DEBUG
        printf("finished to parse configuration file\n");
 #endif /* DEBUG */



