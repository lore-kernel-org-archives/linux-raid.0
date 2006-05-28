From: Luca Berra <bluca@comedia.it>
Subject: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing Soft RAID under Linux)
Date: Sun, 28 May 2006 15:32:03 +0200
Message-ID: <20060528133203.GC8203@percy.comedia.it>
References: <17526.41252.855793.479011@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="yVhtmJPUSI46BTXb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17526.41252.855793.479011@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Fri, May 26, 2006 at 04:33:08PM +1000, Neil Brown wrote:
>
>
>I am pleased to announce the availability of
>   mdadm version 2.5
>

hello,
i tried rebuilding mdadm 2.5 on current mandriva cooker, which uses
gcc-4.1.1, glibc-2.4 and dietlibc 0.29 and found the following issues
addressed by patches attacched to this message
I would be glad if you could review these patches and include them in
upcoming mdadm releases.

- mdadm-2.3.1-kernel-byteswap-include-fix.patch
reverts a change introduced with mdadm 2.3.1 for redhat compatibility
asm/byteorder.h is an architecture dependent file and does more
stuff than a call to the linux/byteorder/XXX_endian.h
the fact that not calling asm/byteorder.h does not define
__BYTEORDER_HAS_U64__ is just an example of issues that might arise.
if redhat is broken it should be worked around differently than breaking
mdadm.

- mdadm-2.4-snprintf.patch
this is self commenting, just an error in the snprintf call

- mdadm-2.4-strict-aliasing.patch
fix for another srict-aliasing problem, you can typecast a reference to a
void pointer to anything, you cannot typecast a reference to a struct.

- mdadm-2.5-mdassemble.patch
pass CFLAGS to mdassemble build, enabling -Wall -Werror showed some
issues also fixed by the patch.

- mdadm-2.5-rand.patch
Posix dictates rand() versus bsd random() function, and dietlibc
deprecated random(), so switch to srand()/rand() and make everybody
happy.

- mdadm-2.5-unused.patch
glibc 2.4 is pedantic on ignoring return values from fprintf, fwrite and
write, so now we check the rval and actually do something with it.
in the Grow.c case i only print a warning, since i don't think we can do
anithing in case we fail invalidating those superblocks (is should never
happen, but then...)

Regards,
L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.3.1-kernel-byteswap-include-fix.patch"

* Sat Feb 18 2006 Christiaan Welvaart <cjw@daneel.dyndns.org>
not including asm/byteorder.h will not define __BYTEORDER_HAS_U64__
causing __fswab64 to be undefined and failure compiling mdadm on
big_endian architectures like PPC

--- mdadm-2.3.1/mdadm.h.bak	2006-02-06 04:52:12.000000000 +0100
+++ mdadm-2.3.1/mdadm.h	2006-02-18 03:51:59.786926267 +0100
@@ -72,16 +72,7 @@
 #include	"bitmap.h"
 
 #include <endian.h>
-/* #include "asm/byteorder.h" Redhat don't like this so... */
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#  include <linux/byteorder/little_endian.h>
-#elif __BYTE_ORDER == __BIG_ENDIAN
-#  include <linux/byteorder/big_endian.h>
-#elif __BYTE_ORDER == __PDP_ENDIAN
-#  include <linux/byteorder/pdp_endian.h>
-#else
-#  error "unknown endianness."
-#endif
+#include <asm/byteorder.h>
 
 
 

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.4-snprintf.patch"

* Sat May 27 2006 Luca Berra <bluca@vodka.it>
snprintf size should be at most the size of the buffer

--- mdadm-2.4/util.c.snprintf	2006-05-27 13:53:18.000000000 +0200
+++ mdadm-2.4/util.c	2006-05-27 13:53:38.000000000 +0200
@@ -439,7 +439,7 @@
 		}
 	if (create && !std && !nonstd) {
 		static char buf[30];
-		snprintf(buf, 1024, "%d:%d", major, minor);
+		snprintf(buf, 30, "%d:%d", major, minor);
 		nonstd = buf;
 	}
 

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.4-strict-aliasing.patch"

* Sat May 27 2006 Luca Berra <bluca@vodka.it>
This is to avoid gcc warnings when building with strict-aliasing optimization

--- mdadm-2.4/dlink.h.alias	2006-05-26 21:05:07.000000000 +0200
+++ mdadm-2.4/dlink.h	2006-05-27 12:32:58.000000000 +0200
@@ -4,16 +4,16 @@
 
 struct __dl_head
 {
-    struct __dl_head *	dh_prev;
-    struct __dl_head *	dh_next;
+    void * dh_prev;
+    void * dh_next;
 };
 
 #define	dl_alloc(size)	((void*)(((char*)calloc(1,(size)+sizeof(struct __dl_head)))+sizeof(struct __dl_head)))
 #define	dl_new(t)	((t*)dl_alloc(sizeof(t)))
 #define	dl_newv(t,n)	((t*)dl_alloc(sizeof(t)*n))
 
-#define dl_next(p) *((void**)&(((struct __dl_head*)(p))[-1].dh_next))
-#define dl_prev(p) *((void**)&(((struct __dl_head*)(p))[-1].dh_prev))
+#define dl_next(p) *(&(((struct __dl_head*)(p))[-1].dh_next))
+#define dl_prev(p) *(&(((struct __dl_head*)(p))[-1].dh_prev))
 
 void *dl_head(void);
 char *dl_strdup(char *);

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.5-mdassemble.patch"

* Sat May 27 2006 Luca Berra <bluca@vodka.it>
add CFLAGS to mdassemble build and fix a couple of non-returning functions

--- mdadm-2.5/mdadm.h.bluca	2006-05-27 14:25:53.000000000 +0200
+++ mdadm-2.5/mdadm.h	2006-05-27 15:20:37.000000000 +0200
@@ -44,10 +44,8 @@
 #include	<errno.h>
 #include	<string.h>
 #include	<syslog.h>
-#ifdef __dietlibc__NONO
-int strncmp(const char *s1, const char *s2, size_t n) __THROW __pure__;
-char *strncpy(char *dest, const char *src, size_t n) __THROW;
-#include    <strings.h>
+#ifdef __dietlibc__
+#include	<strings.h>
 #endif
 
 
--- mdadm-2.5/mdassemble.c.bluca	2006-05-27 15:11:02.000000000 +0200
+++ mdadm-2.5/mdassemble.c	2006-05-27 15:15:24.000000000 +0200
@@ -54,7 +54,7 @@
 };
 
 #ifndef MDASSEMBLE_AUTO
-/* from mdadm.c */
+/* from mdopen.c */
 int open_mddev(char *dev, int autof/*unused */)
 {
 	int mdfd = open(dev, O_RDWR, 0);
@@ -79,7 +79,7 @@
 int verbose = 0;
 int force = 0;
 
-int main() {
+int main(int argc, char *argv[]) {
 	mddev_ident_t array_list =  conf_get_ident(configfile, NULL);
 	if (!array_list) {
 		fprintf(stderr, Name ": No arrays found in config file\n");
@@ -100,4 +100,5 @@
 					   NULL, NULL,
 					   readonly, runstop, NULL, NULL, verbose, force);
 		}
+	return rv;
 }
--- mdadm-2.5/Makefile.bluca	2006-05-27 14:56:07.000000000 +0200
+++ mdadm-2.5/Makefile	2006-05-27 15:24:07.000000000 +0200
@@ -73,7 +73,7 @@
 	mdopen.c super0.c super1.c bitmap.c restripe.c sysfs.c
 
 ASSEMBLE_SRCS := mdassemble.c Assemble.c config.c dlink.c util.c super0.c super1.c
-ASSEMBLE_FLAGS:= -DMDASSEMBLE
+ASSEMBLE_FLAGS:= $(CFLAGS) -DMDASSEMBLE
 ifdef MDASSEMBLE_AUTO
 ASSEMBLE_SRCS += mdopen.c mdstat.c
 ASSEMBLE_FLAGS += -DMDASSEMBLE_AUTO
--- mdadm-2.5/util.c.bluca	2006-05-27 14:25:53.000000000 +0200
+++ mdadm-2.5/util.c	2006-05-27 15:34:47.000000000 +0200
@@ -375,7 +375,7 @@
 }
 int nftw(const char *path, int (*han)(const char *name, const struct stat *stb, int flag, struct FTW *s), int nopenfd, int flags)
 {
-	ftw(path, add_dev_1, nopenfd);
+	return ftw(path, add_dev_1, nopenfd);
 }
 #endif
 

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.5-rand.patch"

* Sat May 27 2006 Luca Berra <bluca@vodka.it>
POSIX dictates rand/srand instead of BSD srandom/random

--- mdadm-2.5/Assemble.c.rand	2006-05-27 14:40:30.000000000 +0200
+++ mdadm-2.5/Assemble.c	2006-05-27 15:32:39.000000000 +0200
@@ -412,10 +412,10 @@
 				int rfd;
 				if ((rfd = open("/dev/urandom", O_RDONLY)) < 0 ||
 				    read(rfd, ident->uuid, 16) != 16) {
-					*(__u32*)(ident->uuid) = random();
-					*(__u32*)(ident->uuid+1) = random();
-					*(__u32*)(ident->uuid+2) = random();
-					*(__u32*)(ident->uuid+3) = random();
+					*(__u32*)(ident->uuid) = rand();
+					*(__u32*)(ident->uuid+1) = rand();
+					*(__u32*)(ident->uuid+2) = rand();
+					*(__u32*)(ident->uuid+3) = rand();
 				}
 				if (rfd >= 0) close(rfd);
 			}
--- mdadm-2.5/mdadm.c.rand	2006-05-26 07:43:35.000000000 +0200
+++ mdadm-2.5/mdadm.c	2006-05-27 15:31:18.000000000 +0200
@@ -107,7 +107,7 @@
 
 	int mdfd = -1;
 
-	srandom(time(0) ^ getpid());
+	srand(time(0) ^ getpid());
 
 	ident.uuid_set=0;
 	ident.level = UnSet;
--- mdadm-2.5/super0.c.rand	2006-05-27 14:34:54.000000000 +0200
+++ mdadm-2.5/super0.c	2006-05-27 15:33:08.000000000 +0200
@@ -539,7 +539,7 @@
 	sb->patch_version = 0;
 	sb->gvalid_words = 0; /* ignored */
 	if (rfd < 0 || read(rfd, &sb->set_uuid0, 4) != 4)
-		sb->set_uuid0 = random();
+		sb->set_uuid0 = rand();
 	sb->ctime = time(0);
 	sb->level = info->level;
 	if (size != info->size)
@@ -550,9 +550,9 @@
 	sb->md_minor = info->md_minor;
 	sb->not_persistent = 0;
 	if (rfd < 0 || read(rfd, &sb->set_uuid1, 12) != 12) {
-		sb->set_uuid1 = random();
-		sb->set_uuid2 = random();
-		sb->set_uuid3 = random();
+		sb->set_uuid1 = rand();
+		sb->set_uuid2 = rand();
+		sb->set_uuid3 = rand();
 	}
 	if (rfd >= 0)
 		close(rfd);
--- mdadm-2.5/super1.c.rand	2006-05-27 14:37:22.000000000 +0200
+++ mdadm-2.5/super1.c	2006-05-27 15:33:29.000000000 +0200
@@ -583,10 +583,10 @@
 
 	if ((rfd = open("/dev/urandom", O_RDONLY)) < 0 ||
 	    read(rfd, sb->set_uuid, 16) != 16) {
-		*(__u32*)(sb->set_uuid) = random();
-		*(__u32*)(sb->set_uuid+4) = random();
-		*(__u32*)(sb->set_uuid+8) = random();
-		*(__u32*)(sb->set_uuid+12) = random();
+		*(__u32*)(sb->set_uuid) = rand();
+		*(__u32*)(sb->set_uuid+4) = rand();
+		*(__u32*)(sb->set_uuid+8) = rand();
+		*(__u32*)(sb->set_uuid+12) = rand();
 	}
 	if (rfd >= 0) close(rfd);
 
@@ -751,10 +751,10 @@
 
 	if ((rfd = open("/dev/urandom", O_RDONLY)) < 0 ||
 	    read(rfd, sb->device_uuid, 16) != 16) {
-		*(__u32*)(sb->device_uuid) = random();
-		*(__u32*)(sb->device_uuid+4) = random();
-		*(__u32*)(sb->device_uuid+8) = random();
-		*(__u32*)(sb->device_uuid+12) = random();
+		*(__u32*)(sb->device_uuid) = rand();
+		*(__u32*)(sb->device_uuid+4) = rand();
+		*(__u32*)(sb->device_uuid+8) = rand();
+		*(__u32*)(sb->device_uuid+12) = rand();
 	}
 	if (rfd >= 0) close(rfd);
 	sb->events = 0;

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.5-unused.patch"

* Sat May 27 2006 Luca Berra <bluca@vodka.it>
check return status of all write/fwrite functions as required by glibc 2.4

--- mdadm-2.5/Monitor.c.unused	2006-05-27 14:28:23.000000000 +0200
+++ mdadm-2.5/Monitor.c	2006-05-27 14:28:28.000000000 +0200
@@ -521,7 +521,7 @@
 				int n;
 				fprintf(mp, "\nP.S. The /proc/mdstat file current contains the following:\n\n");
 				while ( (n=fread(buf, 1, sizeof(buf), mdstat)) > 0)
-					fwrite(buf, 1, n, mp);
+					n=fwrite(buf, 1, n, mp); /* yes, i don't care about the result */
 				fclose(mdstat);
 			}
 			fclose(mp);
--- mdadm-2.5/super1.c.unused	2006-05-27 14:36:13.000000000 +0200
+++ mdadm-2.5/super1.c	2006-05-27 14:37:22.000000000 +0200
@@ -715,7 +715,8 @@
 			(((char*)sb)+1024);
 		if (__le32_to_cpu(bm->magic) == BITMAP_MAGIC) {
 			locate_bitmap1(st, fd, sbv);
-			write(fd, bm, sizeof(*bm));
+			if (write(fd, bm, sizeof(*bm)) != sizeof(*bm))
+			    return 5;
 		}
 	}
 	fsync(fd);
--- mdadm-2.5/super0.c.unused	2006-05-27 14:31:33.000000000 +0200
+++ mdadm-2.5/super0.c	2006-05-27 14:34:54.000000000 +0200
@@ -625,7 +625,8 @@
 	if (super->state & (1<<MD_SB_BITMAP_PRESENT)) {
 		struct bitmap_super_s * bm = (struct bitmap_super_s*)(super+1);
 		if (__le32_to_cpu(bm->magic) == BITMAP_MAGIC)
-			write(fd, bm, sizeof(*bm));
+			if (write(fd, bm, sizeof(*bm)) != sizeof(*bm))
+			    return 5;
 	}
 
 	fsync(fd);
--- mdadm-2.5/Grow.c.unused	2006-05-23 06:34:37.000000000 +0200
+++ mdadm-2.5/Grow.c	2006-05-27 14:25:53.000000000 +0200
@@ -801,7 +801,10 @@
 		memset(&bsb, 0, sizeof(bsb));
 		for (i=odisks; i<d ; i++) {
 			lseek64(fdlist[i], (offsets[i]+last_block)<<9, 0);
-			write(fdlist[i], &bsb, sizeof(bsb));
+			if (write(fdlist[i], &bsb, sizeof(bsb)) < 0) {
+				fprintf(stderr, Name ": %s: failed to invalidate metadata for raid disk %d\n",
+					devname, i);
+			}
 		}
 
 		/* unsuspend. */
--- mdadm-2.5/bitmap.c.unused	2006-05-19 09:15:32.000000000 +0200
+++ mdadm-2.5/bitmap.c	2006-05-27 14:52:31.000000000 +0200
@@ -399,16 +399,22 @@
 	return rv;
 }
 
-void bitmap_update_uuid(int fd, int *uuid)
+int bitmap_update_uuid(int fd, int *uuid)
 {
 	struct bitmap_super_s bm;
-	lseek(fd, 0, 0);
+	if (lseek(fd, 0, 0) != 0)
+		return 1;
 	if (read(fd, &bm, sizeof(bm)) != sizeof(bm))
-		return;
+		return 1;
 	if (bm.magic != __cpu_to_le32(BITMAP_MAGIC))
-		return;
+		return 1;
 	memcpy(bm.uuid, uuid, 16);
+	if (lseek(fd, 0, 0) != 0)
+		return 2;
+	if (write(fd, &bm, sizeof(bm)) != sizeof(bm)) {
+		lseek(fd, 0, 0);
+		return 2;
+	}
 	lseek(fd, 0, 0);
-	write(fd, &bm, sizeof(bm));
-	lseek(fd, 0, 0);
+	return 0;
 }
--- mdadm-2.5/mdadm.h.unused	2006-05-27 14:25:53.000000000 +0200
+++ mdadm-2.5/mdadm.h	2006-05-27 14:51:53.000000000 +0200
@@ -371,7 +371,7 @@
 			unsigned long long array_size,
 			int major);
 extern int ExamineBitmap(char *filename, int brief, struct supertype *st);
-extern void bitmap_update_uuid(int fd, int *uuid);
+extern int bitmap_update_uuid(int fd, int *uuid);
 
 extern int md_get_version(int fd);
 extern int get_linux_version(void);
--- mdadm-2.5/Assemble.c.unused	2006-05-26 08:28:07.000000000 +0200
+++ mdadm-2.5/Assemble.c	2006-05-27 14:40:30.000000000 +0200
@@ -451,7 +451,9 @@
 
 			if (strcmp(update, "uuid")==0 &&
 			    ident->bitmap_fd)
-				bitmap_update_uuid(ident->bitmap_fd, info.uuid);
+				if (bitmap_update_uuid(ident->bitmap_fd, info.uuid) != 0)
+					fprintf(stderr, Name ": Could not update uuid on %s.\n",
+						devname);
 		} else
 #endif
 		{

--yVhtmJPUSI46BTXb--
