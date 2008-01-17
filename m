From: Neil Brown <neilb@suse.de>
Subject: Re: do_md_run returned -22 [Was: 2.6.24-rc8-mm1]
Date: Fri, 18 Jan 2008 10:15:32 +1100
Message-ID: <18319.57748.532354.179523@notabene.brown>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<478F72F2.6000707@gmail.com>
	<20080117110153.f224f24e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday January 17
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org, Torsten Kaiser <just.for.lkml@googlemail.com>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 17, akpm@linux-foundation.org wrote:
> On Thu, 17 Jan 2008 16:23:30 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > On 01/17/2008 11:35 AM, Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> > 
> > still the same md issue (do_md_run returns -22=EINVAL) as in -rc6-mm1 reported 
> > by Thorsten here:
> > http://lkml.org/lkml/2007/12/27/45
> 
> hm, I must have been asleep when that was reported.  Neil, did you see it?

No, even though it was Cc:ed to me - sorry.
Maybe a revised subject line would have helped... maybe not.

> 
> > Is there around any fix for this?
> 
> Well, we could bitbucket md-allow-devices-to-be-shared-between-md-arrays.patch

Yeah, do that.  I'll send you something new.
I'll move that chunk into a different patch and add the extra bits
needed to make that test correct in *all* cases rather than just the
ones I was thinking about at the time.
My test suit does try in-kernel-autodetect (the problem case) but it
didn't catch this bug due to another bug.  I'll fix that too.

Thanks,
NeilBrown
