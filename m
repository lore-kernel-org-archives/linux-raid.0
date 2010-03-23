From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] (Re: Questions regarding startup of imsm container)
Date: Tue, 23 Mar 2010 16:06:39 -0700
Message-ID: <e9c3a7c21003231606s388d26e6gba266e6a44281973@mail.gmail.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
	 <20100323080419.GA9374@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100323080419.GA9374@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Tue, Mar 23, 2010 at 1:04 AM, Luca Berra <bluca@comedia.it> wrote:
> The attached patch completely disables bitmap support for arrays with
> externally managed metadata.

It should be possible to use an external bitmap, but that requires
that you have storage separate from the raid array.

# mdadm --grow --bitmap=$(pwd)/test --force /dev/md125
# cat /proc/mdstat
Personalities : [raid1] [raid0]
md125 : active raid1 loop1[1] loop0[0]
      100143 blocks super external:/md127/0 [2/2] [UU]
      bitmap: 13/13 pages [52KB], 4KB chunk, file: /root/test

md127 : inactive loop1[1](S) loop0[0](S)
      418 blocks super external:imsm

unused devices: <none>


> on a style note, i do not like having the struct superswitch, which is a
> collection of function pointers which is then instanced with only some
> of the pointers initialized, it forces having to check at runtime if
> they are or not.

In some cases this is a 'feature' as it is an optional implementation
detail of the metadata format whether it supports, or wants to
override a given operation.  See ->default_layout() and
->detail_platform().  Another example is the small collection of
operations that are only applicable for mdmon to use.

I think something like this untested patch would be more appropriate
to fix the issue at hand.

diff --git a/bitmap.c b/bitmap.c
index 088e37d..054a507 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -227,6 +227,12 @@ bitmap_info_t *bitmap_file_read(char *filename,
int brief, struct supertype **st
                if (!st) {
                        /* just look at device... */
                        lseek(fd, 0, 0);
+               } else if (!st->ss->locate_bitmap) {
+                       fprintf(stderr, Name
+                               ": %s-metadata arrays do not support
an internal bitmap\n",
+                               st->ss->name);
+                       close(fd);
+                       return NULL;
                } else {
                        st->ss->locate_bitmap(st, fd);
                }


> a possible solution would be to wrap every call of these into a macro
> that check for NULL before, but how do you return the correct return
> type from that?

We need to fix up all the locations that assume md-metadata, once that
is done a macro is not needed.

--
Dan
