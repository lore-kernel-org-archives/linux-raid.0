From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: kicking non-fresh member from array?
Date: Thu, 18 Oct 2007 17:20:15 +0200
Message-ID: <87fy085u1c.fsf@informatik.uni-tuebingen.de>
References: <170fa0d20710161120u65d5fd1bifea2aef4176c93f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20710161120u65d5fd1bifea2aef4176c93f9@mail.gmail.com>
	(Mike Snitzer's message of "Tue, 16 Oct 2007 14:20:13 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Mike Snitzer" <snitzer@gmail.com> writes:

> All,
>
> I have repeatedly seen that when a 2 member raid1 becomes degraded,
> and IO continues to the lone good member, that if the array is then
> stopped and reassembled you get:
>
> md: bind<nbd0>
> md: bind<sdc>
> md: kicking non-fresh nbd0 from array!
> md: unbind<nbd0>
> md: export_rdev(nbd0)
> raid1: raid set md0 active with 1 out of 2 mirrors
>
> I'm not seeing how one can avoid assembling such an array in 2 passes:
> 1) assemble array with both members
> 2) if a member was deemed "non-fresh" re-add that member; whereby
> triggering recovery.
>
> So why does MD kick non-fresh members out on assemble when its
> perfectly capable of recovering the "non-fresh" member?  Looking at
> md.c it is fairly clear there isn't a way to avoid this 2-step
> procedure.
>
> Why/how does MD benefit from this "kicking non-fresh" semantic?
> Should MD/mdadm be made optionally tolerant of such non-fresh members
> during assembly?
>
> Mike

What if the disk has lots of bad blocks, just not where the meta data
is? On every restart you would resync and fail.

Or what if you removed a mirror to keep a snapshot of a previous
state? If it auto resyncs you loose that snapshot.

MfG
        Goswin
