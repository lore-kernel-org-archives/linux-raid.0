From: Luca Berra <bluca@comedia.it>
Subject: Re: small patches to mdadm
Date: Mon, 30 Aug 2004 15:09:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040830130904.GA1763@percy.comedia.it>
References: <20040825072235.GB5851@percy.comedia.it> <16686.39118.516906.365004@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="U+BazGySraz5kW0T"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16686.39118.516906.365004@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Fri, Aug 27, 2004 at 12:13:34PM +1000, Neil Brown wrote:
>They'll both be in the next release.
thanks a lot!
here is another patch for mdassemble.
1) add raid6 and raid10
2) add support for the auto=... option.
the auto= can be disabled in the Makefile, allowing users to save about
5k (on x86).

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.7.0-mdassemble.patch"

--- mdadm-1.7.0/mdadm.c.mdassemble	2004-08-29 11:35:31.986605997 +0200
+++ mdadm-1.7.0/mdadm.c	2004-08-29 11:35:31.991606047 +0200
@@ -193,7 +193,7 @@
 }
 
 
-
+#ifndef MDASSEMBLE_AUTO
 int main(int argc, char *argv[])
 {
 	int mode = 0;
@@ -1004,3 +1004,4 @@
 	}
 	exit(rv);
 }
+#endif /* MDASSEMBLE_AUTO */
--- mdadm-1.7.0/mdassemble.c.mdassemble	2004-08-11 03:28:50.000000000 +0200
+++ mdadm-1.7.0/mdassemble.c	2004-08-29 11:35:31.992606057 +0200
@@ -46,11 +46,15 @@
 	{ "5", 5},
 	{ "multipath", -4},
 	{ "mp", -4},
+	{ "raid6", 6},
+	{ "6", 6},
+	{ "raid10", 10},
+	{ "10", 10},
 	{ NULL, 0}
 };
 
-/* from mdadm.c */
-int open_mddev(char *dev)
+#ifndef MDASSEMBLE_AUTO
+int open_mddev(char *dev, int autof /*ignored*/)
 {
 	int mdfd = open(dev, O_RDWR, 0);
 	if (mdfd < 0)
@@ -64,6 +68,10 @@
 	}
 	return mdfd;
 }
+#else
+#include "mdstat.c"
+#include "mdadm.c"
+#endif
 
 char *configfile = NULL;
 int rv;
@@ -81,7 +89,7 @@
 	} else
 		for (; array_list; array_list = array_list->next) {
 			mdu_array_info_t array;
-			mdfd = open_mddev(array_list->devname);
+			mdfd = open_mddev(array_list->devname, array_list->autof);
 			if (mdfd < 0) {
 				rv |= 1;
 				continue;
--- mdadm-1.7.0/Makefile.mdassemble	2004-08-29 11:35:31.980605936 +0200
+++ mdadm-1.7.0/Makefile	2004-08-29 11:35:31.993606067 +0200
@@ -44,6 +44,8 @@
 CONFFILE = $(SYSCONFDIR)/mdadm.conf
 MAILCMD =/usr/sbin/sendmail -t
 CFLAGS = $(CWFLAGS) -DCONFFILE=\"$(CONFFILE)\" $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\"
+# build mdassemble with support for auto=
+ASSEMBLE_FLAGS=-DMDASSEMBLE_AUTO
 
 # If you want a static binary, you might uncomment these
 # LDFLAGS = -static
@@ -83,20 +85,20 @@
 
 mdassemble : $(ASSEMBLE_SRCS) mdadm.h
 	rm -f $(OBJS)
-	$(DIET_GCC) -o mdassemble $(ASSEMBLE_SRCS) 
+	$(DIET_GCC) $(ASSEMBLE_FLAGS) -o mdassemble $(ASSEMBLE_SRCS) 
 
 mdassemble.static : $(ASSEMBLE_SRCS) mdadm.h
 	rm -f $(OBJS)
-	$(CC) $(LDFLAGS) -static -o mdassemble $(ASSEMBLE_SRCS)
+	$(CC) $(LDFLAGS) $(ASSEMBLE_FLAGS) -static -o mdassemble $(ASSEMBLE_SRCS)
 
 mdassemble.uclibc : $(ASSEMBLE_SRCS) mdadm.h
 	rm -f $(OBJS)
-	$(UCLIBC_GCC) -DUCLIBC -static -o mdassemble.uclibc $(ASSEMBLE_SRCS) 
+	$(UCLIBC_GCC) $(ASSEMBLE_FLAGS) -DUCLIBC -static -o mdassemble.uclibc $(ASSEMBLE_SRCS) 
 
 # This doesn't work
 mdassemble.klibc : $(ASSEMBLE_SRCS) mdadm.h
 	rm -f $(OBJS)
-	$(KLIBC_GCC) $(CFLAGS) -o mdassemble $(ASSEMBLE_SRCS)
+	$(KLIBC_GCC) $(CFLAGS) $(ASSEMBLE_FLAGS) -o mdassemble $(ASSEMBLE_SRCS)
 
 mdadm.man : mdadm.8
 	nroff -man mdadm.8 > mdadm.man
--- mdadm-1.7.0/mdadm.h.mdassemble	2004-08-29 11:35:31.987606007 +0200
+++ mdadm-1.7.0/mdadm.h	2004-08-29 11:35:31.993606067 +0200
@@ -27,6 +27,8 @@
  *           Australia
  */
 
+#ifndef _MDADM_H
+#define _MDADM_H 1
 #define	__USE_LARGEFILE64
 #include	<unistd.h>
 #ifndef __dietlibc__
@@ -227,3 +229,4 @@
 extern char *get_md_name(int dev);
 
 extern char DefaultConfFile[];
+#endif /* _MDADM_H */

--U+BazGySraz5kW0T--
