From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.2 compile problem
Date: Fri, 16 Dec 2005 12:44:10 +1100
Message-ID: <17314.7146.595860.14295@cse.unsw.edu.au>
References: <43A1ED5A.2050406@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert Heinzmann on Thursday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 15, Robert.Heinzmann@gmx.net wrote:
> Hello,
> I tried to compile mdadm 2.2 on my machine (sles8)
> 
> Kernel: 2.4.21-295-athlon
> gcc: gcc version 2.95.3 20010315
> 
> The compile fails with this error message:
> 
> cc1: warnings being treated as errors
> In file included from mdadm.h:219,
>                  from bitmap.c:23:
> /usr/include/ftw.h:93: warning: `struct stat64' declared inside 
> parameter list
> /usr/include/ftw.h:93: warning: its scope is only this definition or 
> declaration, which is probably not what you want.
> /usr/include/ftw.h:102: warning: `struct stat64' declared inside 
> parameter list
> bitmap.c: In function `bitmap_fd_read':
> bitmap.c:130: warning: unknown conversion type character `z' in format
> bitmap.c:130: warning: too many arguments for format
> make: *** [bitmap.o] Error 1
> 
> I changed the makefile and removed -Werror. Is there another way to fix 
> this issue ?

Yes.  You can 
   make CWFLAGS=

or you can report it like you did (thanks) and get a patch.
(One of the reasons I still have -Werror in there is to encourage
people to report these warnings, so I can fix them for the next version).

The following allows mdadm to compile with gcc-2.95

Thanks,
NeilBrown


### Diffstat output
 ./bitmap.c |    5 +++++
 ./mdadm.h  |    4 ++++
 2 files changed, 9 insertions(+)

diff ./bitmap.c~current~ ./bitmap.c
--- ./bitmap.c~current~	2005-12-05 16:52:22.000000000 +1100
+++ ./bitmap.c	2005-12-16 12:41:31.000000000 +1100
@@ -126,8 +126,13 @@ bitmap_info_t *bitmap_fd_read(int fd, in
 
 	info = malloc(sizeof(*info));
 	if (info == NULL) {
+#if __GNUC__ < 3
+		fprintf(stderr, Name ": failed to allocate %d bytes\n",
+				(int)sizeof(*info));
+#else
 		fprintf(stderr, Name ": failed to allocate %zd bytes\n",
 				sizeof(*info));
+#endif
 		return NULL;
 	}
 

diff ./mdadm.h~current~ ./mdadm.h
--- ./mdadm.h~current~	2005-12-05 16:55:02.000000000 +1100
+++ ./mdadm.h	2005-12-16 12:40:47.000000000 +1100
@@ -211,6 +211,10 @@ struct supertype {
 extern struct supertype *super_by_version(int vers, int minor);
 extern struct supertype *guess_super(int fd);
 
+#if __GNUC__ < 3
+struct stat64;
+#endif
+
 #ifdef UCLIBC
   struct FTW {};
 # define FTW_PHYS 1
