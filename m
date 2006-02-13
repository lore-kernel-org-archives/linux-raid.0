From: Luca Berra <bluca@comedia.it>
Subject: Re: Question: array locking, possible?
Date: Mon, 13 Feb 2006 22:53:43 +0100
Message-ID: <20060213215343.GA12679@percy.comedia.it>
References: <1C4766A743ADF74FAEDF2AAD0679BAA20767917E@cacexc03.americas.cpqcorp.net> <20060209204847.GA1387@percy.comedia.it> <20060213185247.2bb2ffee@mwdsp001.swissptt.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060213185247.2bb2ffee@mwdsp001.swissptt.ch>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Mon, Feb 13, 2006 at 06:52:47PM +0100, Chris Osicki wrote:
>
>Luca
>
>On Thu, 9 Feb 2006 21:48:48 +0100
>Luca Berra <luca.berra@comedia.it> wrote:
>
>> On Thu, Feb 09, 2006 at 10:28:58AM -0800, Stern, Rick (Serviceguard Linux) wrote:
>> >There is more interest, just not vocal.
>> >
>> >May want to look at LVM2 and its ability to use tagging to control enablement of VGs. This way it is not HW dependent.
>> >
>> I believe there is space in md1 superblock for a "cluster/exclusive"
>> flag, if not the name field could be used
>
>Great if there is space for it there is a hope.
>Unfortunately I don't think my programming skills are up to
>such a task as making proof-of-concept patches.

i was thinking of adding a bit in the feature_map flags to enable this
kind of behaviour, the downside of it is that kernel space code has to
be updated to account for this flags, as it is for anything in the
superblock except for name.

Neil, what would you think of reserving some more space in the superblock for
other data which can be used from user-space?

i believe playing with name is a kludge.

>> what is missing is an interface between mdadm and cmcld so mdadm can ask
>> cmcld permission to activate an array with the "cluster/exclusive" flag
>> set.
>
>For the time being we could live without it. I'm convinced HP would
>make use of it once it's there.

i was thinking something like a socket based interface between mdadm and
a generic cluster daemon, non necessarily cmcld.

>And I wouldn't say mdadm should get permission from cmcld (for those
>who don't know Service Guard cluster software from HP: cmcld is
>the Cluster daemon). IMHO cmcld should clear the flag on the array
>when initiating a fail-over in case the host which used it crashed.
no, i don't like the flag to be cleared, there is too much space for a
race. The flag should be permanent (unless it is forcibly removed with
mdadm --grow).

>Once again, what I would like it for is for preventing two hosts writing
>the array at the same time because I accidentally activated it.
>Without cmcld's awareness of the "cluster/exclusive" flag I would
>always run mdadm with the '--force' option to enable the array during
>package startup, because if I trust the cluster software I know the
>fail-over is happening because the other node crashed or it is a
>manual (clean) fail-over. 

if you only want this, it could be entirely implemented into mdadm, just
adding a exclusive flag to the ARRAY line in mdadm.conf
this is not foolproof, as it will only prevent "mdadm -As" from assembling
a device, providing the identification information on the command line
or running something like "mdadm -Asc partitions", to fool it.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.3.1-exclusive.patch"

diff -urN mdadm-2.3.1/Assemble.c mdadm-2.3.1.exclusive/Assemble.c
--- mdadm-2.3.1/Assemble.c	2006-01-25 08:01:10.000000000 +0100
+++ mdadm-2.3.1.exclusive/Assemble.c	2006-02-13 22:48:04.000000000 +0100
@@ -34,7 +34,7 @@
 	     mddev_dev_t devlist,
 	     int readonly, int runstop,
 	     char *update,
-	     int verbose, int force)
+	     int verbose, int force, int exclusive)
 {
 	/*
 	 * The task of Assemble is to find a collection of
@@ -255,6 +255,15 @@
 			continue;
 		}
 
+		if (ident->exclusive != UnSet &&
+		    !exclusive ) {
+			if ((inargv && verbose >= 0) || verbose > 0)
+				fprintf(stderr, Name ": %s can be activated in exclusive mode only.\n",
+					devname);
+			continue;
+		}
+
+
 		/* If we are this far, then we are commited to this device.
 		 * If the super_block doesn't exist, or doesn't match others,
 		 * then we cannot continue
diff -urN mdadm-2.3.1/ReadMe.c mdadm-2.3.1.exclusive/ReadMe.c
--- mdadm-2.3.1/ReadMe.c	2006-02-06 05:09:35.000000000 +0100
+++ mdadm-2.3.1.exclusive/ReadMe.c	2006-02-13 22:27:26.000000000 +0100
@@ -147,6 +147,7 @@
     {"scan",      0, 0, 's'},
     {"force",	  0, 0, 'f'},
     {"update",	  1, 0, 'U'},
+    {"exclusive", 0, 0, 'x'},
 
     /* Management */
     {"add",       0, 0, 'a'},
diff -urN mdadm-2.3.1/config.c mdadm-2.3.1.exclusive/config.c
--- mdadm-2.3.1/config.c	2005-12-09 06:00:47.000000000 +0100
+++ mdadm-2.3.1.exclusive/config.c	2006-02-13 22:23:02.000000000 +0100
@@ -286,6 +286,7 @@
 	mis.st = NULL;
 	mis.bitmap_fd = -1;
 	mis.name[0] = 0;
+	mis.exclusive = 0;
 
 	for (w=dl_next(line); w!=line; w=dl_next(w)) {
 		if (w[0] == '/') {
@@ -386,6 +387,8 @@
 					fprintf(stderr, Name ": auto type of \"%s\" ignored for %s\n",
 						w+5, mis.devname?mis.devname:"unlabeled-array");
 			}
+		} else if (strncasecmp(w, "exclusive", 9) == 0 ) {
+			mis.exclusive = 1;
 		} else {
 			fprintf(stderr, Name ": unrecognised word on ARRAY line: %s\n",
 				w);
diff -urN mdadm-2.3.1/mdadm.c mdadm-2.3.1.exclusive/mdadm.c
--- mdadm-2.3.1/mdadm.c	2006-02-06 04:58:01.000000000 +0100
+++ mdadm-2.3.1.exclusive/mdadm.c	2006-02-13 22:45:35.000000000 +0100
@@ -72,6 +72,7 @@
 	int quiet = 0;
 	int brief = 0;
 	int force = 0;
+	int exclusive = 0;
 	int test = 0;
 	int assume_clean = 0;
 	int autof = 0; /* -2 means create device based on name:
@@ -808,6 +809,11 @@
 				}
 			}
 			continue;
+
+		case O(ASSEMBLE,'x'):
+			exclusive = 1;
+			continue;
+
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
@@ -928,7 +934,7 @@
 				else {
 					rv |= Assemble(ss, devlist->devname, mdfd, array_ident, configfile,
 						       NULL,
-						       readonly, runstop, update, verbose-quiet, force);
+						       readonly, runstop, update, verbose-quiet, force, exclusive);
 					close(mdfd);
 				}
 			}
@@ -957,7 +963,7 @@
 				}
 				rv |= Assemble(ss, dv->devname, mdfd, array_ident, configfile,
 					       NULL,
-					       readonly, runstop, update, verbose-quiet, force);
+					       readonly, runstop, update, verbose-quiet, force, exclusive);
 				close(mdfd);
 			}
 		} else {
@@ -981,7 +987,7 @@
 						rv |= Assemble(ss, array_list->devname, mdfd,
 							       array_list, configfile,
 							       NULL,
-							       readonly, runstop, NULL, verbose-quiet, force);
+							       readonly, runstop, NULL, verbose-quiet, force, exclusive);
 					close(mdfd);
 				}
 		}
diff -urN mdadm-2.3.1/mdadm.h mdadm-2.3.1.exclusive/mdadm.h
--- mdadm-2.3.1/mdadm.h	2006-02-06 04:52:12.000000000 +0100
+++ mdadm-2.3.1.exclusive/mdadm.h	2006-02-13 22:21:21.000000000 +0100
@@ -142,6 +142,7 @@
 	int	autof;		/* 1 for normal, 2 for partitioned */
 	char	*spare_group;
 	int	bitmap_fd;
+	int	exclusive;
 
 	struct mddev_ident_s *next;
 } *mddev_ident_t;

--oyUTqETQ0mS9luUI--
