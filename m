From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: kicking non-fresh member from array?
Date: Thu, 18 Oct 2007 15:04:27 -0400
Message-ID: <170fa0d20710181204j1dc8904ax93770a0c99819417@mail.gmail.com>
References: <170fa0d20710161120u65d5fd1bifea2aef4176c93f9@mail.gmail.com>
	 <87fy085u1c.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fy085u1c.fsf@informatik.uni-tuebingen.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/18/07, Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de> wrote:
> "Mike Snitzer" <snitzer@gmail.com> writes:
>
> > All,
> >
> > I have repeatedly seen that when a 2 member raid1 becomes degraded,
> > and IO continues to the lone good member, that if the array is then
> > stopped and reassembled you get:
> >
> > md: bind<nbd0>
> > md: bind<sdc>
> > md: kicking non-fresh nbd0 from array!
> > md: unbind<nbd0>
> > md: export_rdev(nbd0)
> > raid1: raid set md0 active with 1 out of 2 mirrors
> >
> > I'm not seeing how one can avoid assembling such an array in 2 passes:
> > 1) assemble array with both members
> > 2) if a member was deemed "non-fresh" re-add that member; whereby
> > triggering recovery.
> >
> > So why does MD kick non-fresh members out on assemble when its
> > perfectly capable of recovering the "non-fresh" member?  Looking at
> > md.c it is fairly clear there isn't a way to avoid this 2-step
> > procedure.
> >
> > Why/how does MD benefit from this "kicking non-fresh" semantic?
> > Should MD/mdadm be made optionally tolerant of such non-fresh members
> > during assembly?
> >
> > Mike
>
> What if the disk has lots of bad blocks, just not where the meta data
> is? On every restart you would resync and fail.
>
> Or what if you removed a mirror to keep a snapshot of a previous
> state? If it auto resyncs you loose that snapshot.

Both of your examples are fairly tenuous given that such members
shouldn't have been provided on the --asemble commandline.  I'm not
talking about auto assemble via udev or something.  But auto assemble
via udev brings up an annoying corner-case when you consider the 2
cases you pointed out.

So you have valid points.  This leads to my last question; having the
ability to _optionally_ tolerate (repair) such stale members would
allow for greater flexibility.  The current behavior isn't conducive
to repairing unprotected raids (that mdadm/md were told to assemble
with specific members) without taking steps to say "no I really
_really_ mean it; now re-add this disk!".

Any pointers from Neil (or others) on how such a 'repair "non-fresh"
member(s) on assemble' override _should_ be implemented would be
helpful.  My first thought is to add a new superblock
--update=repair-non-fresh option to mdadm that would tie into a new
flag in the MD superblock.  But then it begs the question: why not
first add support to set such a superblock option at MD create-time?
The validate_super methods would also need to be trained accordingly.

regards,
Mike
