From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] Incremental() lock error handling
Date: Fri, 21 Oct 2011 18:21:38 +0200
Message-ID: <1319214098-10409-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1319214098-10409-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319214098-10409-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 5c5f34f..0241aa1 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -298,7 +298,7 @@ int Incremental(char *devname, int verbose, int runstop,
 				    name_to_use, autof, trustworthy, chosen_name);
 
 		if (mdfd < 0)
-			goto out;
+			goto out_unlock;
 
 		sysfs_init(&info, mdfd, 0);
 
@@ -306,7 +306,7 @@ int Incremental(char *devname, int verbose, int runstop,
 			fprintf(stderr, Name ": failed to set array info for %s: %s\n",
 				chosen_name, strerror(errno));
 			rv = 2;
-			goto out;
+			goto out_unlock;
 		}
 
 		dinfo = info;
@@ -317,7 +317,7 @@ int Incremental(char *devname, int verbose, int runstop,
 				devname, chosen_name, strerror(errno));
 			ioctl(mdfd, STOP_ARRAY, 0);
 			rv = 2;
-			goto out;
+			goto out_unlock;
 		}
 		sra = sysfs_read(mdfd, -1, (GET_DEVS | GET_STATE |
 					    GET_OFFSET | GET_SIZE));
@@ -333,7 +333,7 @@ int Incremental(char *devname, int verbose, int runstop,
 				"      --incremental reliably.  Aborting.\n");
 			sysfs_free(sra);
 			rv = 2;
-			goto out;
+			goto out_unlock;
 		}
 		info.array.working_disks = 1;
 		/* 6/ Make sure /var/run/mdadm.map contains this array. */
@@ -380,12 +380,12 @@ int Incremental(char *devname, int verbose, int runstop,
 					": not adding %s to active array (without --run) %s\n",
 					devname, chosen_name);
 				rv = 2;
-				goto out;
+				goto out_unlock;
 			}
 		}
 		if (!sra) {
 			rv = 2;
-			goto out;
+			goto out_unlock;
 		}
 		if (sra->devs) {
 			sprintf(dn, "%d:%d", sra->devs->disk.major,
@@ -400,7 +400,7 @@ int Incremental(char *devname, int verbose, int runstop,
 					devname, chosen_name);
 				close(dfd2);
 				rv = 2;
-				goto out;
+				goto out_unlock;
 			}
 			close(dfd2);
 			st2->ss->getinfo_super(st2, &info2, NULL);
@@ -412,7 +412,7 @@ int Incremental(char *devname, int verbose, int runstop,
 					": unexpected difference between %s and %s.\n",
 					chosen_name, devname);
 				rv = 2;
-				goto out;
+				goto out_unlock;
 			}
 		}
 		info2.disk.major = major(stb.st_rdev);
@@ -433,7 +433,7 @@ int Incremental(char *devname, int verbose, int runstop,
 			fprintf(stderr, Name ": failed to add %s to %s: %s.\n",
 				devname, chosen_name, strerror(errno));
 			rv = 2;
-			goto out;
+			goto out_unlock;
 		}
 		info.array.working_disks = 0;
 		for (d = sra->devs; d; d=d->next)
@@ -486,9 +486,8 @@ int Incremental(char *devname, int verbose, int runstop,
 			fprintf(stderr, Name
 			     ": %s attached to %s, not enough to start (%d).\n",
 				devname, chosen_name, active_disks);
-		map_unlock(&map);
 		rv = 0;
-		goto out;
+		goto out_unlock;
 	}
 
 	/* 7b/ if yes, */
@@ -502,9 +501,8 @@ int Incremental(char *devname, int verbose, int runstop,
 			fprintf(stderr, Name
 			   ": %s attached to %s which is already active.\n",
 				devname, chosen_name);
-		map_unlock(&map);
 		rv = 0;
-		goto out;
+		goto out_unlock;
 	}
 
 	map_unlock(&map);
@@ -585,6 +583,9 @@ out:
 	if (sra)
 		sysfs_free(sra);
 	return rv;
+out_unlock:
+	map_unlock(&map);
+	goto out;
 }
 
 static struct mddev_ident *search_mdstat(struct supertype *st,
-- 
1.7.4.4

