From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] mdadm: Linux 3.x version change
Date: Fri, 17 Jun 2011 14:18:47 +0200
Message-ID: <4DFB4627.7050809@redhat.com>
References: <1307716200-27483-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307716200-27483-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/10/2011 04:30 PM, Namhyung Kim wrote:
> As Linux 3.x changes its versioning scheme, we have to deal with
> the 2-digit version number also.
FYI: we have patch below currently in Fedora rawhide
(which already switched to 3.0-rc numbering scheme).

Without it is system unable to assembly RAID during boot
("mdadm -As --auto=yes --run" fails because of wrong version detected).

It seems that 3.2.2 still have the same problem.

Milan

--- mdadm-3.2.1.old/util.c	2011-03-28 04:31:20.000000000 +0200
+++ mdadm-3.2.1/util.c	2011-06-05 07:59:03.741904751 +0200
@@ -154,8 +154,8 @@ int get_linux_version()
 	a = strtoul(cp, &cp, 10);
 	if (*cp != '.') return -1;
 	b = strtoul(cp+1, &cp, 10);
-	if (*cp != '.') return -1;
-	c = strtoul(cp+1, NULL, 10);
+	if (*cp != '.' && a <= 2) return -1;
+	c = (*cp == '.') ? strtoul(cp+1, NULL, 10) : 0;
 
 	return (a*1000000)+(b*1000)+c;
 }


