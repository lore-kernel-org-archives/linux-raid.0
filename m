From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Q: Is this how 'check' works (on raid10 in particular)?
Date: Sun, 3 Aug 2008 15:28:51 +0200
Message-ID: <20080803132851.GA10465@rap.rap.dk>
References: <cccedfc60808030532u14cfd668vfeca77a79996d11@mail.gmail.com> <20080803125413.GA10118@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080803125413.GA10118@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-sabmag@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Aug 03, 2008 at 02:54:13PM +0200, Keld Jørn Simonsen wrote:
> On Sun, Aug 03, 2008 at 07:32:00AM -0500, Jon Nelson wrote:
> > After digging through the code (admittedly, way too late at night), I
> > think I have a basic understanding of how the resync code works, and
> > why it appears to be suboptimal (speed-wise) for raid10.
> > 
> > It would appear that, upon receipt of a 'check' (other resync methods
> > have different paths, sometimes), md.c basically says, "start at the
> > first sector or the first sector after the checkpoint and proceed
> > logically through the end (unless told to stop)' and md.c schedules
> > this check with the relevant sync_request method. For raid10, this
> > finds the first device with that logical sector as a copy and then
> > compares the data there to the data in all of the other copies on the
> > other disks. For raid10 in f2 format (and to a less extent with the
> > offset format) this is going to result in a great deal of thrashing.
> > I'm guessing this is the reason why a 'check' operation raid10,f2
> > takes 2x as long as for raid5 (same disks). One way to improve the
> > efficiency here would be to perform a loop like this:
> > 
> > for device in devices:
> >   for chunk that is not a mirror:
> >     read chunk
> >     compare chunk to mirror chunks on other devices
> > 
> > If I'm not wrong this should result in near streaming speeds from each
> > device with a minimum of seeking. However, to effect this change it
> > looks like the changes would be more invasive than just changing
> > raid10.c. One way, of course, might be to abstract the sync code just
> > a bit more so that md.c could ask each device to provide a function
> > which does the driving (the above 4 lines) and md.c does all of the
> > common error checking, interrupt checking, etc... Does this seem like
> > crazy talk? If I can get some help I might give it a stab.
> 
> My idea is to do the checks in bigger blocks, then you would minimize
> the trashing, by minimizing the number of times you need to move the
> head.  And this would not need much change in the code. I have done a
> patch to do this, but I have not yet tested it.

Maybe you could test the patch?  enclosed

Best regards
keld

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="raid10.resync.patch"

--- raid10.c	2008-07-12 18:28:59.438235317 +0200
+++ raid10.c~	2008-07-03 05:46:47.000000000 +0200
@@ -80,7 +80,7 @@
 //#define RESYNC_BLOCK_SIZE PAGE_SIZE
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
-#define RESYNC_WINDOW (2048*1024*16)
+#define RESYNC_WINDOW (2048*1024)
 
 /*
  * When performing a resync, we need to read and compare, so
@@ -686,7 +686,7 @@
  *    there is no normal IO happeing.  It must arrange to call
  *    lower_barrier when the particular background IO completes.
  */
-#define RESYNC_DEPTH 32*16
+#define RESYNC_DEPTH 32
 
 static void raise_barrier(conf_t *conf, int force)
 {

--opJtzjQTFsWo+cga--
