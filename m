From: Luca Berra <bluca@comedia.it>
Subject: Re: Multipath problem
Date: Tue, 23 Nov 2004 21:16:51 +0100
Message-ID: <20041123201650.GA8972@percy.comedia.it>
References: <41A32AE7.2080502@fbihome.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41A32AE7.2080502@fbihome.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Tue, Nov 23, 2004 at 01:19:51PM +0100, Oliver Heinz wrote:
>Mixing mdadm-1.6 and 1.8.1 for creating/managing the device doesn't 
>work, it gives me an segfault.

try patching mdadm-1.8.1 with this patch, it might help with the
segfault.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.8.1-memset.patch"

--- mdadm-1.8.1/mdadm.c.bluca	2004-11-14 19:44:26.000000000 +0100
+++ mdadm-1.8.1/mdadm.c	2004-11-14 19:44:31.747309097 +0100
@@ -80,11 +80,10 @@
 
 	int mdfd = -1;
 
-	ident.uuid_set=0;
+	memset(&ident,0,sizeof(struct mddev_ident_s));
 	ident.level = UnSet;
 	ident.raid_disks = UnSet;
 	ident.super_minor= UnSet;
-	ident.devices=0;
 
 	while ((option_index = -1) ,
 	       (opt=getopt_long(argc, argv,
--- mdadm-1.8.1/config.c.bluca	2004-11-02 06:11:06.000000000 +0100
+++ mdadm-1.8.1/config.c	2004-11-14 19:44:35.693660204 +0100
@@ -266,15 +266,11 @@
 	struct mddev_ident_s mis;
 	mddev_ident_t mi;
 
-	mis.uuid_set = 0;
+	memset(&mis,0,sizeof(struct mddev_ident_s));
 	mis.super_minor = UnSet;
 	mis.level = UnSet;
 	mis.raid_disks = UnSet;
 	mis.spare_disks = UnSet;
-	mis.devices = NULL;
-	mis.devname = NULL;
-	mis.spare_group = NULL;
-	mis.autof = 0;
 
 	for (w=dl_next(line); w!=line; w=dl_next(w)) {
 		if (w[0] == '/') {

--k+w/mQv8wyuph6w0--
