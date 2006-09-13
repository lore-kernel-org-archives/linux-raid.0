From: Luca Berra <bluca@comedia.it>
Subject: [PATCH] missing close in mdassemble
Date: Wed, 13 Sep 2006 16:57:43 +0200
Message-ID: <20060913145743.GH32581@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

attached, please apply
without this mdassemble cannot activate stacked arrays, i wonder how i
managed to miss it :(

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.5.3-closefd.patch"

--- mdadm-2.5.3/mdassemble.c.close	2006-09-13 12:28:00.000000000 +0200
+++ mdadm-2.5.3/mdassemble.c	2006-09-13 12:30:24.000000000 +0200
@@ -91,13 +91,12 @@
 				rv |= 1;
 				continue;
 			}
-			if (ioctl(mdfd, GET_ARRAY_INFO, &array)>=0)
-				/* already assembled, skip */
-				continue;
+			if (ioctl(mdfd, GET_ARRAY_INFO, &array) < 0)
 			rv |= Assemble(array_list->st, array_list->devname, mdfd,
 					   array_list,
 					   NULL, NULL,
 					   readonly, runstop, NULL, NULL, verbose, force);
+			close(mdfd);
 		}
 	return rv;
 }

--3MwIy2ne0vdjdPXF--
