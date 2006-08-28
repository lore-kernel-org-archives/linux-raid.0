From: Luca Berra <bluca@comedia.it>
Subject: [PATCH] mdadm -As --auto=yes fails if some of the md are already active
Date: Mon, 28 Aug 2006 13:23:30 +0200
Message-ID: <20060828112330.GB32563@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

hello, since i started forcing auto=yes to mdadm, due to udev
i discovered a small problem.

basically when starting an array the routine that should check and
create the device file in mdopen.c errors if the md is already active.
this is not needed since trying to activate an already active array is
checked further in the code path.

also i believe that running mdadm -As when all devices are active should
return with 0 exit code. (that is the reason for the hunk patching
mdadm.c)

please apply

Regards,
L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.5.3-active.patch"

* Sat Aug 19 2006 Luca Berra <bluca@vodka.it>
- do not fail when autoassembling everything and some md are already active

--- mdadm-2.5.3/mdadm.c	2006-08-19 17:00:51.000000000 +0200
+++ mdadm-2.5.3/mdadm.c	2006-08-19 16:30:16.000000000 +0200
@@ -1020,7 +1020,7 @@
 				}
 				if (ioctl(mdfd, GET_ARRAY_INFO, &array)>=0)
 					/* already assembled, skip */
-					;
+					cnt++;
 				else {
 					rv |= Assemble(ss, array_list->devname, mdfd,
 						       array_list,
--- mdadm-2.5.3/mdopen.c	2006-06-26 07:11:00.000000000 +0200
+++ mdadm-2.5.3/mdopen.c	2006-08-19 17:03:24.000000000 +0200
@@ -166,10 +166,7 @@
 			}
 			if (ioctl(mdfd, GET_ARRAY_INFO, &array)==0) {
 				/* already active */
-				close(mdfd);
-				fprintf(stderr, Name ": %s is already active.\n",
-					dev);
-				return -1;
+				return mdfd;
 			} else {
 				if (major != MD_MAJOR && parts > 0)
 					make_parts(dev, parts);

--5mCyUwZo2JvN/JJP--
