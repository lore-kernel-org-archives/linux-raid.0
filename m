From: Tim Janik <timj@imendio.com>
Subject: mdadm write-behind with --grow
Date: Thu, 11 Sep 2008 00:34:21 +0200 (CEST)
Message-ID: <alpine.DEB.1.00.0809110018360.7184@clinker.birnet.private>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 08 Jul 2007 18:30:54 -0700, Neil Brown wrote:
> On Tuesday July 3, Ian Dall wrote:
> > There doesn't seem to be any designated place to send bug reports and
> > feature requests to mdadm, so I hope I am doing the right thing by
> > sending it here.
> 
> Yes. Exactly the right thing, thanks.
> 
> I have applied the patch and pushed it out into .git.  It will appear
> in the next release of mdadm.
> 
> Thank,
> NeilBrown
> 
> > 
> > I have a small patch to mdamd which allows the write-behind amount to be
> > set a array grow time (instead of currently only at grow or create
> > time). I have tested this fairly extensively on some arrays built out of
> > loop back devices, and once on a real live array. I haven't lot any data
> > and it seems to work OK, though it is possible I am missing something.
> > 
> > --- mdadm-2.6.1/mdadm.c.writebehind   2006-12-21 16:12:50.000000000 +1030
> > +++ mdadm-2.6.1/mdadm.c       2007-06-30 13:16:22.000000000 +0930
> > @@ -827,6 +827,7 @@
> >                       bitmap_chunk = bitmap_chunk ? bitmap_chunk * 1024 : 512;
> >                       continue;
> > 
> > +             case O(GROW, WriteBehind):
> >               case O(BUILD, WriteBehind):
> >               case O(CREATE, WriteBehind): /* write-behind mode */
> >                       write_behind = DEFAULT_MAX_WRITE_BEHIND;

This change appears to not be enough:

# mdadm --grow /dev/md0 --write-behind
mdadm: no changes to --grow

# mdadm -X /dev/sdb1 | fgrep Write
       Write Mode : Normal

The releavant mdadm code for handling GROW reads:
         case GROW:
 	[...]
                 else if (bitmap_file) {
                         if (delay == 0) delay = DEFAULT_BITMAP_DELAY;
                         rv = Grow_addbitmap(devlist->devname, mdfd, bitmap_file,
                                             bitmap_chunk, delay, write_behind, force);

So the only way to make use of the newly enabled --write-behind
for --grow is:

# mdadm --grow /dev/md0 -b internal --write-behind
mdadm: failed to set internal bitmap.

# mdadm -X /dev/sdb1 | fgrep Write
       Write Mode : Allow write behind, max 256


However the "-b internal" produces an error message
for devices with persistent superblocks...

Also, mdadm --grow --help doesn't document the use
of --write-behind (also missing for --build --help and
  --create --help).

PS: I'm not subscribed to the mailing list, so please CC: me on replies.

---
ciaoTJ
