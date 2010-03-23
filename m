From: Luca Berra <bluca@comedia.it>
Subject: [PATCH] (Re: Questions regarding startup of imsm container)
Date: Tue, 23 Mar 2010 09:04:19 +0100
Message-ID: <20100323080419.GA9374@maude.comedia.it>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline

On Mon, Mar 22, 2010 at 09:56:01PM -0600, Randy Terbush wrote:
>Having a go at building a raid5 array using the new imsm support and
>having good luck keeping drives in the array, etc. Nice work. I have a
>few questions though as I am having some trouble figuring out how to
>properly start this container.
>
># mdadm --version
>mdadm - v3.1.2 - 10th March 2010
>
># mdadm -Es
>ARRAY metadata=imsm UUID=30223250:76fd248b:50280919:0836b7f0
>ARRAY /dev/md/Volume0 container=30223250:76fd248b:50280919:0836b7f0
>member=0 UUID=8a4ae452:da1e7832:70ecf895:eb58229c
>
># ls -l /dev/md/
>total 0
>lrwxrwxrwx 1 root root 6 Mar 22 20:54 0 -> ../md0
>lrwxrwxrwx 1 root root 8 Mar 22 20:54 127 -> ../md127
>lrwxrwxrwx 1 root root 8 Mar 22 20:54 Volume0_0 -> ../md127
>
>As you can see, the name for the link in /dev/md does not agree with
>the name that the Examine is coming up with.
please read mdadm.conf manpage, under the section "HOMEHOST"

>Is it better to just forgo the ARRAY statements and go with an AUTO +imsm?
>
>And last, does the concept of a write-intent bitmap make sense on an
>imsm container? If so, I get a segv if trying to run mdadm /dev/mdX
>-Gb internal on either device.

i don't believe it makes sense at all, surely imsm do not support an
internal bitmap (no provisioning for it in the metadata)

The attached patch completely disables bitmap support for arrays with
externally managed metadata.

on a style note, i do not like having the struct superswitch, which is a
collection of function pointers which is then instanced with only some
of the pointers initialized, it forces having to check at runtime if
they are or not.
a possible solution would be to wrap every call of these into a macro
that check for NULL before, but how do you return the correct return
type from that?

L.

-- 
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-External-metadata-array-do-not-support-bitmaps.patch"

From f970449a469f009d3f31703151652361acb8a41e Mon Sep 17 00:00:00 2001
From: Luca Berra <bluca@comedia.it>
Date: Tue, 23 Mar 2010 08:49:00 +0100
Subject: [PATCH] External metadata array do not support bitmaps

Signed-off-by: Luca Berra <bluca@comedia.it>
---
 Create.c |    6 ++++++
 Grow.c   |    6 ++++++
 bitmap.c |    5 +++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Create.c b/Create.c
index 909ac5d..ae905fc 100644
--- a/Create.c
+++ b/Create.c
@@ -206,6 +206,12 @@ int Create(struct supertype *st, char *mddev,
 		fprintf(stderr, Name ": You haven't given enough devices (real or missing) to create this array\n");
 		return 1;
 	}
+	if (st && st->ss->external && bitmap_file) {
+		fprintf(stderr,
+			Name ": This metadata type does not support "
+			"bitmaps\n");
+		return 1;
+	}
 	if (bitmap_file && level <= 0) {
 		fprintf(stderr, Name ": bitmaps not meaningful with level %s\n",
 			map_num(pers, level)?:"given");
diff --git a/Grow.c b/Grow.c
index 6264996..d736d27 100644
--- a/Grow.c
+++ b/Grow.c
@@ -283,6 +283,12 @@ int Grow_addbitmap(char *devname, int fd, char *file, int chunk, int delay, int
 			array.major_version, array.minor_version);
 		return 1;
 	}
+	if (st->ss->external) {
+		fprintf(stderr,
+			Name ": This metadata type does not support "
+			"bitmaps\n");
+		return 1;
+	}
 	if (strcmp(file, "none") == 0) {
 		fprintf(stderr, Name ": no bitmap found on %s\n", devname);
 		return 1;
diff --git a/bitmap.c b/bitmap.c
index 088e37d..ff63588 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -227,6 +227,11 @@ bitmap_info_t *bitmap_file_read(char *filename, int brief, struct supertype **st
 		if (!st) {
 			/* just look at device... */
 			lseek(fd, 0, 0);
+		} else if (st->ss->external) {
+			fprintf(stderr,
+				Name ": This metadata type does not support "
+				"bitmaps\n");
+			return NULL;
 		} else {
 			st->ss->locate_bitmap(st, fd);
 		}
-- 
1.7.0.1


--YiEDa0DAkWCtVeE4--
