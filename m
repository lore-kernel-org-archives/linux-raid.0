From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
Date: Mon, 26 Oct 2015 08:25:10 -0400 (EDT)
Message-ID: <1424506067.42737315.1445862310535.JavaMail.zimbra@redhat.com>
References: <1445751362-15677-1-git-send-email-xni@redhat.com> <284284227.42321345.1445751531086.JavaMail.zimbra@redhat.com> <877fmag0mn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877fmag0mn.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jes Sorensen <jes.sorensen@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "Neil Brown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: "Jes Sorensen" <jes.sorensen@redhat.com>, linux-raid@vger.kernel.org
> Sent: Monday, October 26, 2015 4:21:36 AM
> Subject: Re: Fwd: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
> 
> Xiao Ni <xni@redhat.com> writes:
> 
> > Hi Neil
> >
> > I encountered one problem. When reshape one raid1 with bitmap to raid0,
> > it'll
> > lose legs.
> >
> > I sent the patch by git-send-email, but I can't see the mail in linux-raid.
> > So
> > I forward it again. And add signed-off-by line.
> >
> > Best Regards
> > Xiao
> >
> > ----- Forwarded Message -----
> > From: "Xiao Ni" <xni@redhat.com>
> > To: xni@redhat.com
> > Sent: Sunday, October 25, 2015 1:36:02 PM
> > Subject: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
> >
> > One raid1 with bitmap is composed by 4 disks. It'll fail when rashape to
> > raid0
> > and lose 3 disks. It should check bitmap first when reshape raid1 to raid0.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  Grow.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 80d7b22..5e9b0bb 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -1898,6 +1898,12 @@ size_change_error:
> >  	     array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) ||
> >  	    (s->level == 0 && array.level == 1 && sra)) {
> >  		int err;
> > +
> > +		if (array.state & (1<<MD_SB_BITMAP_PRESENT)) {
> > +			cont_err("Bitmap must be removed before level can be changed\n");
> > +			rv = 1;
> > +			goto release;
> > +		}
> >  		err = remove_disks_for_takeover(st, sra, array.layout);
> >  		if (err) {
> >  			dprintf("Array cannot be reshaped\n");
> > @@ -2706,9 +2712,6 @@ static int impose_level(int fd, int level, char
> > *devname, int verbose)
> >  			err = errno;
> >  			pr_err("%s: could not set level to %s\n",
> >  				devname, c);
> > -			if (err == EBUSY &&
> > -			    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
> > -				cont_err("Bitmap must be removed before level can be changed\n");
> >  			return err;
> >  		}
> >  		if (verbose >= 0)
> > --
> 
> You appear to have identified a problem that needs fixing, but the
> patch is fairly obviously wrong.
> 
> You've removed a test and error message that could apply to any level
> change, and added a test and error message that only applies to some
> specific level changes.
> Why does that error message no longer apply to all the other possible
> level changes?
> 
> The test that you have added is mostly OK ... but you missed something.
> Look around and similar nearby code.
> The test you removed certainly should stay.
> 
> NeilBrown
> 

Thanks for printing out the mistake. I checked the nearby code and found 
I missed close the cfd. Is this I missed? But I'm wondering that it doesn't 
close it in the following code. Now it's just closed when it's failed to
reshape raid1/raid10 to raid0.

 Grow.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Grow.c b/Grow.c
index 80d7b22..d711884 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1898,6 +1898,15 @@ size_change_error:
             array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) ||
            (s->level == 0 && array.level == 1 && sra)) {
                int err;
+               
+               if (array.state & (1<<MD_SB_BITMAP_PRESENT)) {
+                       dprintf("Bitmap must be removed before level can be changed\n");
+                       if (cfd > -1)
+                               close(cfd);
+                       rv = 1;
+                       goto release;
+               }
+
                err = remove_disks_for_takeover(st, sra, array.layout);

Best Regards
Xiao

