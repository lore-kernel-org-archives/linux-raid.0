From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] (Re: Questions regarding startup of imsm container)
Date: Wed, 24 Mar 2010 11:57:49 +1100
Message-ID: <20100324115749.1ac9d6f8@notabene.brown>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
	<20100323080419.GA9374@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100323080419.GA9374@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Mar 2010 09:04:19 +0100
Luca Berra <bluca@comedia.it> wrote:

> On Mon, Mar 22, 2010 at 09:56:01PM -0600, Randy Terbush wrote:
> >Having a go at building a raid5 array using the new imsm support and
> >having good luck keeping drives in the array, etc. Nice work. I have a
> >few questions though as I am having some trouble figuring out how to
> >properly start this container.
> >
> ># mdadm --version
> >mdadm - v3.1.2 - 10th March 2010
> >
> ># mdadm -Es
> >ARRAY metadata=imsm UUID=30223250:76fd248b:50280919:0836b7f0
> >ARRAY /dev/md/Volume0 container=30223250:76fd248b:50280919:0836b7f0
> >member=0 UUID=8a4ae452:da1e7832:70ecf895:eb58229c
> >
> ># ls -l /dev/md/
> >total 0
> >lrwxrwxrwx 1 root root 6 Mar 22 20:54 0 -> ../md0
> >lrwxrwxrwx 1 root root 8 Mar 22 20:54 127 -> ../md127
> >lrwxrwxrwx 1 root root 8 Mar 22 20:54 Volume0_0 -> ../md127
> >
> >As you can see, the name for the link in /dev/md does not agree with
> >the name that the Examine is coming up with.
> please read mdadm.conf manpage, under the section "HOMEHOST"
> 
> >Is it better to just forgo the ARRAY statements and go with an AUTO +imsm?
> >
> >And last, does the concept of a write-intent bitmap make sense on an
> >imsm container? If so, I get a segv if trying to run mdadm /dev/mdX
> >-Gb internal on either device.
> 
> i don't believe it makes sense at all, surely imsm do not support an
> internal bitmap (no provisioning for it in the metadata)
> 
> The attached patch completely disables bitmap support for arrays with
> externally managed metadata.

Thanks for the patch.  However I would prefer to disable bitmap support for
those metadata formats which report that they don't support it.
Thus the following patch.

Thanks,
NeilBrown


diff --git a/Create.c b/Create.c
index 909ac5d..8f6e6e7 100644
--- a/Create.c
+++ b/Create.c
@@ -651,6 +651,11 @@ int Create(struct supertype *st, char *mddev,
 			fprintf(stderr, Name ": internal bitmaps not supported by this kernel.\n");
 			goto abort;
 		}
+		if (!st->ss->add_internal_bitmap) {
+			fprintf(stderr, Name ": internal bitmaps not supported with %s metadata\n",
+				st->ss->name);
+			goto abort;
+		}
 		if (!st->ss->add_internal_bitmap(st, &bitmap_chunk,
 						 delay, write_behind,
 						 bitmapsize, 1, major_num)) {
diff --git a/Grow.c b/Grow.c
index 6264996..053a372 100644
--- a/Grow.c
+++ b/Grow.c
@@ -288,6 +288,11 @@ int Grow_addbitmap(char *devname, int fd, char *file, int chunk, int delay, int
 		return 1;
 	} else if (strcmp(file, "internal") == 0) {
 		int d;
+		if (st->ss->add_internal_bitmap == NULL) {
+			fprintf(stderr, Name ": Internal bitmaps not supported "
+				"with %s metadata\n", st->ss->name);
+			return 1;
+		}
 		for (d=0; d< st->max_devs; d++) {
 			mdu_disk_info_t disk;
 			char *dv;
diff --git a/bitmap.c b/bitmap.c
index 088e37d..beef2dc 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -227,9 +227,13 @@ bitmap_info_t *bitmap_file_read(char *filename, int brief, struct supertype **st
 		if (!st) {
 			/* just look at device... */
 			lseek(fd, 0, 0);
-		} else {
+		} else if (!st->ss->locate_bitmap) {
+			fprintf(stderr, Name ": No bitmap possible with %s metadata\n",
+				st->ss->name);
+			return NULL;
+		} else
 			st->ss->locate_bitmap(st, fd);
-		}
+
 		ioctl(fd, BLKFLSBUF, 0); /* make sure we read current data */
 		*stp = st;
 	} else {
