From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Planning a bug-fix release for mdadm: mdadm 3.2.6
Date: Sat, 20 Oct 2012 19:44:14 +0400
Message-ID: <5082C6CE.9050809@msgid.tls.msk.ru>
References: <20121018154807.461ddd29@notabene.brown> <5082C322.6020506@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060705040806060907080805"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5082C322.6020506@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Sergey B Kirpichev <skirpichev@gmail.com>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060705040806060907080805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 20.10.2012 19:28, Michael Tokarev wrote:
> On 18.10.2012 08:48, NeilBrown wrote:
>>  The "mdadm-3.2.x" branch of my git tree (git://neil.brown.name/mdadm)
>>  contains what I have so far.  If anyone knows of bugs in current mdadm that
>>  really should be fixed for the next release and aren't in that tree, please
>>  let me know (or even send me a patch).
> 
> There's apparently a small (but annoying when you hit it) bug mentioned in
> http://bugs.debian.org/686703 -- when specifying --uuid, --homehost is NOT
> ignored as it should be.  I'm looking at it right now, so for now it is JFYI.

I just sent a trivial one-liner patch for this issue.  It is applicable for
older releases too.

And here's another trivial bugfix, now for spelling mistakes in various
places, authred by Sergey Kirpichev (Cc'ed) and carried in debian mdadm
package.  Please consider applying.

/mjt

--------------060705040806060907080805
Content-Type: text/x-patch;
 name="spelling-and-manpages.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="spelling-and-manpages.patch"

---
 Build.c      |    2 +-
 md.4         |    2 +-
 mdadm.8.in   |   26 --------------------------
 mdadm.conf.5 |    2 +-
 super0.c     |    2 +-
 5 files changed, 4 insertions(+), 30 deletions(-)

--- a/Build.c
+++ b/Build.c
@@ -174,7 +174,7 @@
 			goto abort;
 		}
 		if ((stb.st_mode & S_IFMT)!= S_IFBLK) {
-			fprintf(stderr, Name ": Wierd: %s is no longer a block device.\n",
+			fprintf(stderr, Name ": Weird: %s is no longer a block device.\n",
 				dv->devname);
 			goto abort;
 		}
--- a/md.4
+++ b/md.4
@@ -773,7 +773,7 @@
 .I n
 gives the md device number,
 .I l
-gives the level, 0 for RAID0 or -1 for LINEAR,
+gives the level, 0 for RAID0 or \-1 for LINEAR,
 .I c
 gives the chunk size as a base-2 logarithm offset by twelve, so 0
 means 4K, 1 means 8K.
--- a/mdadm.conf.5
+++ b/mdadm.conf.5
@@ -573,7 +573,7 @@
 .br
 HOMEHOST <system>
 .br
-AUTO +1.x homehost -all
+AUTO +1.x homehost \-all
 
 .SH SEE ALSO
 .BR mdadm (8),
--- a/super0.c
+++ b/super0.c
@@ -445,7 +445,7 @@
 		       sb32+MD_SB_GENERIC_CONSTANT_WORDS+7+1,
 		       (MD_SB_WORDS - (MD_SB_GENERIC_CONSTANT_WORDS+7+1))*4);
 		if (verbose >= 0)
-			fprintf (stderr, Name ": adjusting superblock of %s for 2.2/sparc compatability.\n",
+			fprintf (stderr, Name ": adjusting superblock of %s for 2.2/sparc compatibility.\n",
 				 devname);
 	} else if (strcmp(update, "super-minor") ==0) {
 		sb->md_minor = info->array.md_minor;
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -332,7 +332,6 @@
 .IP "0, 0.90, default"
 .el
 .IP "0, 0.90"
-..
 Use the original 0.90 format superblock.  This format limits arrays to
 28 component devices and limits component devices of levels 1 and
 greater to 2 terabytes.  It is also possible for there to be confusion
@@ -342,7 +341,6 @@
 .IP "1, 1.0, 1.1, 1.2"
 .el
 .IP "1, 1.0, 1.1, 1.2 default"
-..
 Use the new version-1 format superblock.  This has fewer restrictions.
 It can easily be moved between hosts with different endian-ness, and a
 recovery operation can be checkpointed and restarted.  The different
@@ -888,30 +886,6 @@
 or
 .BR \-\-build .
 
-.ig XX
-.\".TP
-.\".BR \-\-symlink = no
-.\"Normally when
-.\".B \-\-auto
-.\"causes
-.\".I mdadm
-.\"to create devices in
-.\".B /dev/md/
-.\"it will also create symlinks from
-.\".B /dev/
-.\"with names starting with
-.\".B md
-.\"or
-.\".BR md_ .
-.\"Use
-.\".B \-\-symlink=no
-.\"to suppress this, or
-.\".B \-\-symlink=yes
-.\"to enforce this even if it is suppressing
-.\".IR mdadm.conf .
-.\"
-.XX
-
 .TP
 .BR \-a ", " "\-\-add"
 This option can be used in Grow mode in two cases.

--------------060705040806060907080805--
