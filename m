From: mwilck@arcor.de
Subject: [PATCH] Detail: Add container device to device list
Date: Thu, 27 Jun 2013 21:39:27 +0200
Message-ID: <1372361967-8124-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

    commit b3908491 "Detail: fix --brief --verbose" introduced a
    problem when a mdadm.conf file generated with
    "mdadm --Detail --brief --verbose" is later scanned with
    "mdadm --Assemble --scan --config=mdadm.conf"

    Subarrays of containers will not be scanned correctly any more,
    because the container device, not being a member of the "devices"
    list, is not scanned.

    This patch fixes that by adding the (generic) container device
    to the devices list.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 Detail.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/Detail.c b/Detail.c
index 031219a..2cc422c 100644
--- a/Detail.c
+++ b/Detail.c
@@ -32,6 +32,22 @@ static int cmpstringp(const void *p1, const void *p2)
 	return strcmp(* (char * const *) p1, * (char * const *) p2);
 }
 
+static int _add_device(const char *dev, char ***p_devices,
+		       int *p_max_devices, int n_devices)
+{
+	if (n_devices + 1 >= *p_max_devices) {
+		*p_max_devices += 16;
+		*p_devices = xrealloc(*p_devices, *p_max_devices *
+				      sizeof(**p_devices));
+		if (!*p_devices) {
+			*p_max_devices = 0;
+			return 0;
+		}
+	};
+	(*p_devices)[n_devices] = xstrdup(dev);
+	return n_devices + 1;
+}
+
 int Detail(char *dev, struct context *c)
 {
 	/*
@@ -642,15 +658,9 @@ This is pretty boring
 		dv=map_dev_preferred(disk.major, disk.minor, 0, c->prefer);
 		if (dv != NULL) {
 			if (c->brief) {
-				if (n_devices + 1 >= max_devices) {
-					max_devices += 16;
-					devices = xrealloc(devices, max_devices
-							   *sizeof(*devices));
-					if (!devices)
-						goto out;
-				};
-				devices[n_devices] = xstrdup(dv);
-				n_devices++;
+				n_devices = _add_device(dv, &devices,
+							&max_devices,
+							n_devices);
 			} else
 				printf("   %s", dv);
 		}
@@ -662,6 +672,9 @@ This is pretty boring
 	if (st)
 		st->ss->free_super(st);
 
+	if (container)
+		n_devices = _add_device(get_md_name(st->container_devnm),
+					&devices, &max_devices, n_devices);
 	if (c->brief && c->verbose > 0 && devices) {
 		qsort(devices, n_devices, sizeof(*devices), cmpstringp);
 		printf("\n   devices=%s", devices[0]);
-- 
1.7.1
